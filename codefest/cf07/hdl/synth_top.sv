// =============================================================================
// Module:      synth_top
// Project:     Spiking Neural Network (SNN) Speedup Chip
// Course:      ECE 410/510 - Hardware for AI/ML, Spring 2026
// Author:      Vanisri Kyatham
// =============================================================================
module synth_top (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        spike_in,
    input  logic [15:0] weight,
    input  logic [15:0] threshold,
    input  logic [15:0] leak_factor,
    output logic        spike_out,
    output logic [15:0] membrane
);
    logic signed [31:0] membrane_wide;
    logic signed [31:0] leaked;
    logic signed [31:0] next_membrane;

    always_comb begin
        leaked = ($signed(membrane) * $signed({1'b0, leak_factor})) >>> 15;
        if (spike_in)
            next_membrane = leaked + $signed({{16{weight[15]}}, weight});
        else
            next_membrane = leaked;
    end

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            membrane  <= 16'h0000;
            spike_out <= 1'b0;
        end else begin
            if (next_membrane >= $signed({{16{threshold[15]}}, threshold})) begin
                spike_out <= 1'b1;
                membrane  <= 16'h0000;
            end else begin
                spike_out <= 1'b0;
                if (next_membrane > 32'sh00007FFF)
                    membrane <= 16'h7FFF;
                else if (next_membrane < 32'shFFFF8000)
                    membrane <= 16'h8000;
                else
                    membrane <= next_membrane[15:0];
            end
        end
    end
endmodule
