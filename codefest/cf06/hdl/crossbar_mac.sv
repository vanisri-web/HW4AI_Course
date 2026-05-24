// crossbar_mac.sv
// 4x4 Binary-Weight Crossbar MAC Unit
// LLM-assisted generation (Claude, May 2026)
// out[j] = sum_i( weight[i][j] * in[i] )

module crossbar_mac (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        load_en,
    input  logic [1:0]  load_row,
    input  logic [1:0]  load_col,
    input  logic        load_val,
    input  logic signed [7:0] in_vec [0:3],
    input  logic        compute_en,
    output wire signed [10:0] out [0:3]
);
    logic [15:0] weight;
    logic [3:0]  idx;
    assign idx = {load_row, load_col};

    always_ff @(posedge clk) begin
        if (!rst_n) weight <= 16'b0;
        else if (load_en) begin
            case (idx)
                4'h0: weight[0]  <= load_val;  4'h1: weight[1]  <= load_val;
                4'h2: weight[2]  <= load_val;  4'h3: weight[3]  <= load_val;
                4'h4: weight[4]  <= load_val;  4'h5: weight[5]  <= load_val;
                4'h6: weight[6]  <= load_val;  4'h7: weight[7]  <= load_val;
                4'h8: weight[8]  <= load_val;  4'h9: weight[9]  <= load_val;
                4'ha: weight[10] <= load_val;  4'hb: weight[11] <= load_val;
                4'hc: weight[12] <= load_val;  4'hd: weight[13] <= load_val;
                4'he: weight[14] <= load_val;  4'hf: weight[15] <= load_val;
            endcase
        end
    end

    assign out[0] = compute_en ? (
        (weight[0] ? $signed({{3{in_vec[0][7]}},in_vec[0]}) : -$signed({{3{in_vec[0][7]}},in_vec[0]}))
      + (weight[4] ? $signed({{3{in_vec[1][7]}},in_vec[1]}) : -$signed({{3{in_vec[1][7]}},in_vec[1]}))
      + (weight[8] ? $signed({{3{in_vec[2][7]}},in_vec[2]}) : -$signed({{3{in_vec[2][7]}},in_vec[2]}))
      + (weight[12]? $signed({{3{in_vec[3][7]}},in_vec[3]}) : -$signed({{3{in_vec[3][7]}},in_vec[3]}))
    ) : 11'bx;
    assign out[1] = compute_en ? (
        (weight[1] ? $signed({{3{in_vec[0][7]}},in_vec[0]}) : -$signed({{3{in_vec[0][7]}},in_vec[0]}))
      + (weight[5] ? $signed({{3{in_vec[1][7]}},in_vec[1]}) : -$signed({{3{in_vec[1][7]}},in_vec[1]}))
      + (weight[9] ? $signed({{3{in_vec[2][7]}},in_vec[2]}) : -$signed({{3{in_vec[2][7]}},in_vec[2]}))
      + (weight[13]? $signed({{3{in_vec[3][7]}},in_vec[3]}) : -$signed({{3{in_vec[3][7]}},in_vec[3]}))
    ) : 11'bx;
    assign out[2] = compute_en ? (
        (weight[2] ? $signed({{3{in_vec[0][7]}},in_vec[0]}) : -$signed({{3{in_vec[0][7]}},in_vec[0]}))
      + (weight[6] ? $signed({{3{in_vec[1][7]}},in_vec[1]}) : -$signed({{3{in_vec[1][7]}},in_vec[1]}))
      + (weight[10]? $signed({{3{in_vec[2][7]}},in_vec[2]}) : -$signed({{3{in_vec[2][7]}},in_vec[2]}))
      + (weight[14]? $signed({{3{in_vec[3][7]}},in_vec[3]}) : -$signed({{3{in_vec[3][7]}},in_vec[3]}))
    ) : 11'bx;
    assign out[3] = compute_en ? (
        (weight[3] ? $signed({{3{in_vec[0][7]}},in_vec[0]}) : -$signed({{3{in_vec[0][7]}},in_vec[0]}))
      + (weight[7] ? $signed({{3{in_vec[1][7]}},in_vec[1]}) : -$signed({{3{in_vec[1][7]}},in_vec[1]}))
      + (weight[11]? $signed({{3{in_vec[2][7]}},in_vec[2]}) : -$signed({{3{in_vec[2][7]}},in_vec[2]}))
      + (weight[15]? $signed({{3{in_vec[3][7]}},in_vec[3]}) : -$signed({{3{in_vec[3][7]}},in_vec[3]}))
    ) : 11'bx;
endmodule
