module synth_top (
    input  wire        clk,
    input  wire        rst_n,
    input  wire signed [7:0] x0, x1, x2, x3,
    input  wire signed [7:0] w00, w01, w02, w03,
    input  wire signed [7:0] w10, w11, w12, w13,
    input  wire signed [7:0] w20, w21, w22, w23,
    input  wire signed [7:0] w30, w31, w32, w33,
    output reg signed [16:0] y0, y1, y2, y3
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            y0 <= 0; y1 <= 0; y2 <= 0; y3 <= 0;
        end else begin
            y0 <= w00*x0 + w01*x1 + w02*x2 + w03*x3;
            y1 <= w10*x0 + w11*x1 + w12*x2 + w13*x3;
            y2 <= w20*x0 + w21*x1 + w22*x2 + w23*x3;
            y3 <= w30*x0 + w31*x1 + w32*x2 + w33*x3;
        end
    end

endmodule