module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/lif_neuron.fst");
    $dumpvars(0, lif_neuron);
end
endmodule
