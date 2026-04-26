import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_mac_basic(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    # Reset
    dut.rst.value = 1
    dut.a.value = 0
    dut.b.value = 0
    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")

    # Release reset and set inputs
    dut.rst.value = 0
    dut.a.value = 3
    dut.b.value = 4

    for expected in [12, 24, 36]:
        await RisingEdge(dut.clk)
        await Timer(1, unit="ns")
        got = dut.out.value.to_signed()
        assert got == expected, \
            f"Expected {expected}, got {got}"

    # Assert reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")
    got = dut.out.value.to_signed()
    assert got == 0, \
        f"Expected 0 after reset, got {got}"

    cocotb.log.info("test_mac_basic PASSED")

@cocotb.test()
async def test_mac_overflow(dut):
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    # Reset
    dut.rst.value = 1
    dut.a.value = 0
    dut.b.value = 0
    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")
    dut.rst.value = 0

    # Max positive 8-bit signed inputs
    dut.a.value = 127
    dut.b.value = 127

    prev = 0
    wrapped = False
    for i in range(200):
        await RisingEdge(dut.clk)
        await Timer(1, unit="ns")
        current = dut.out.value.to_signed()
        if current < prev:
            wrapped = True
            cocotb.log.info(f"Overflow wrap at cycle {i+1}: {prev} -> {current}")
            break
        prev = current

    if wrapped:
        cocotb.log.info("OVERFLOW BEHAVIOR: Accumulator WRAPS no saturation")
    else:
        cocotb.log.info("OVERFLOW BEHAVIOR: Accumulator did not wrap in 200 cycles")
