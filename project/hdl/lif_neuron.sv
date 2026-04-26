module lif_neuron #(
    parameter DATA_WIDTH = 8,
    parameter MEM_WIDTH  = 32
)(
    input  logic                         clk,
    input  logic                         rst,
    input  logic signed [DATA_WIDTH-1:0] i_syn,
    input  logic                         spike_in,
    output logic                         spike_out,
    output logic signed [MEM_WIDTH-1:0]  v_mem
);

    localparam signed [MEM_WIDTH-1:0] V_THRESH = 32'sd127;
    localparam signed [MEM_WIDTH-1:0] V_RESET  = 32'sd0;
    localparam signed [MEM_WIDTH-1:0] LEAK     = 32'sd1;

    always_ff @(posedge clk) begin
        if (rst) begin
            v_mem     <= V_RESET;
            spike_out <= 1'b0;
        end else begin
            if (spike_in)
                v_mem <= v_mem - LEAK + {{(MEM_WIDTH-DATA_WIDTH){i_syn[DATA_WIDTH-1]}}, i_syn};
            else
                v_mem <= v_mem - LEAK;

            if (v_mem >= V_THRESH) begin
                spike_out <= 1'b1;
                v_mem     <= V_RESET;
            end else begin
                spike_out <= 1'b0;
            end
        end
    end

endmodule
