import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer

@cocotb.test()
async def test_lif_reset(dut):
    """Test that reset clears membrane potential"""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    dut.rst.value = 1
    dut.i_syn.value = 0
    dut.spike_in.value = 0
    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")

    assert dut.v_mem.value.to_signed() == 0, \
        f"Expected v_mem=0 after reset, got {dut.v_mem.value.to_signed()}"
    assert dut.spike_out.value == 0, \
        f"Expected spike_out=0 after reset"

    cocotb.log.info("test_lif_reset PASSED")

@cocotb.test()
async def test_lif_accumulate(dut):
    """Test membrane potential accumulates with spike input"""
    cocotb.start_soon(Clock(dut.clk, 10, unit="ns").start())

    dut.rst.value = 1
    dut.i_syn.value = 0
    dut.spike_in.value = 0
    await RisingEdge(dut.clk)
    await Timer(1, unit="ns")

    dut.rst.value = 0
    dut.i_syn.value = 10
    dut.spike_in.value = 1

    for i in range(5):
        await RisingEdge(dut.clk)
        await Timer(1, unit="ns")
        cocotb.log.info(f"Cycle {i+1}: v_mem={dut.v_mem.value.to_signed()} spike_out={dut.spike_out.value}")

    cocotb.log.info("test_lif_accumulate PASSED")
