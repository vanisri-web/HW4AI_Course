module mac (
    input  logic        clk,
    input  logic        rst,
    input  logic signed [7:0]  a,
    input  logic signed [7:0]  b,
    output logic signed [31:0] out
);

    logic signed [15:0] product;

    always_ff @(posedge clk) begin
        if (rst)
            out <= 32'sd0;
        else begin
            product = a * b;
            out <= out + 32'(signed'(product));
        end
    end

endmodule