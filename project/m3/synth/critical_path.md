# Critical Path Analysis - Real OpenLane 2 Results

## Path (from actual OpenLane 2 STA report, nom_tt_025C_1v80)

Start: _3716_ (sky130_fd_sc_hd__dfxtp_2, rising edge FF, net: membrane_wire[6])
End:   _3711_ (rising edge-triggered flip-flop, clocked by clk)
Corner: nom_tt_025C_1v80
Path Type: max (Setup)

## Logic Stages on Critical Path

1. _3716_/Q (dfxtp_2) -> membrane_wire[6] net, fanout 32, delay 0.679 ns
2. _3606_ (a22oi_2) -> combinational, delay 0.181 ns
3. _3607_ (or3_2) -> delay 0.461 ns
4. _1903_ (a21o_2) -> delay 0.221 ns
5. _1911_ (a21bo_2) -> delay 0.200 ns
6. _1912_ (nand3_2) -> delay 0.112 ns
7. _1914_ (or4bb_2) -> delay 0.672 ns
8. _1948_ (a21o_2) -> delay 0.228 ns
9. _1955_ (and3_2) -> delay 0.207 ns
10. _1988_ (or3_2) -> delay 0.515 ns
11. _2016_ (a21o_2) -> delay 0.209 ns
12. _2018_ (a21o_2) -> delay 0.196 ns
13. _2062_ (a221o_2) -> delay 0.317 ns
14. _2064_ (o211a_2) -> delay 0.136 ns
15. _2135_ (o2111a_2) -> delay 0.261 ns
... (continues to endpoint _3711_)

## Why This Is the Critical Path

The path starts at membrane_wire[6] which has fanout 32 - the highest fanout
in the design. This membrane register feeds the leak multiply logic chain
(the dominant arithmetic operation in the LIF neuron). The path traverses
the full fixed-point multiply-accumulate chain: the membrane value is
multiplied by the leak factor, right-shifted, and added to the spike weight.
This multi-stage arithmetic without pipeline registers creates the longest
combinational delay in the design.

## Timing Summary (nom_tt_025C_1v80)

The design has setup violations in the worst-case slow corner
(nom_ss_100C_1v60) but meets timing in the nominal corner (nom_tt_025C_1v80).
This is expected for an unpipelined 16x16 fixed-point multiplier.

## What Would Shorten the Critical Path

1. Pipeline the multiply: insert a register between the multiplier output
   and the accumulator. This halves the critical path to ~5 ns, enabling
   >180 MHz at nom_tt corner and clearing the ss_100C corner violations.
   Tradeoff: one extra clock cycle of latency per LIF update.

2. Reduce fanout on membrane_wire[6]: the fanout-32 net at the start of the
   critical path adds 0.679 ns. Adding a buffer tree would reduce this to
   ~0.2 ns, saving ~0.5 ns.

3. Reduce word width to 12-bit fixed-point: smaller multiplier means fewer
   carry stages and shorter critical path, at the cost of reduced precision.
