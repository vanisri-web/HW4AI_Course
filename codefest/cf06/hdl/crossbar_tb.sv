`timescale 1ns/1ps
module crossbar_tb;
    logic clk, rst_n, load_en, compute_en;
    logic [1:0] load_row, load_col;
    logic load_val;
    logic signed [7:0] in_vec [0:3];
    wire  signed [10:0] out [0:3];
    crossbar_mac dut (.*);
    initial clk = 0;
    always #5 clk = ~clk;
    initial begin
        $dumpfile("crossbar_tb.vcd");
        $dumpvars(0, crossbar_tb);
        rst_n=0; load_en=0; compute_en=0;
        load_row=0; load_col=0; load_val=0;
        in_vec[0]=10; in_vec[1]=20; in_vec[2]=30; in_vec[3]=40;
        repeat(5) @(posedge clk);
        rst_n=1;
        repeat(2) @(posedge clk);
        @(negedge clk); load_en=1; load_row=0; load_col=0; load_val=1;
        @(negedge clk); load_row=0; load_col=1; load_val=0;
        @(negedge clk); load_row=0; load_col=2; load_val=1;
        @(negedge clk); load_row=0; load_col=3; load_val=0;
        @(negedge clk); load_row=1; load_col=0; load_val=1;
        @(negedge clk); load_row=1; load_col=1; load_val=1;
        @(negedge clk); load_row=1; load_col=2; load_val=0;
        @(negedge clk); load_row=1; load_col=3; load_val=0;
        @(negedge clk); load_row=2; load_col=0; load_val=0;
        @(negedge clk); load_row=2; load_col=1; load_val=1;
        @(negedge clk); load_row=2; load_col=2; load_val=1;
        @(negedge clk); load_row=2; load_col=3; load_val=0;
        @(negedge clk); load_row=3; load_col=0; load_val=0;
        @(negedge clk); load_row=3; load_col=1; load_val=0;
        @(negedge clk); load_row=3; load_col=2; load_val=0;
        @(negedge clk); load_row=3; load_col=3; load_val=1;
        @(negedge clk); load_en=0;
        repeat(3) @(posedge clk);
        compute_en=1;
        #1;
        $display("=== Simulation Results ===");
        $display("out[0] = %0d  (expected -40)", $signed(out[0]));
        $display("out[1] = %0d  (expected   0)", $signed(out[1]));
        $display("out[2] = %0d  (expected -20)", $signed(out[2]));
        $display("out[3] = %0d  (expected -20)", $signed(out[3]));
        if ($signed(out[0])===-40 && $signed(out[1])===0 && $signed(out[2])===-20 && $signed(out[3])===-20)
            $display("=== All outputs matched! PASS ===");
        else
            $display("=== MISMATCH DETECTED ===");
        $finish;
    end
endmodule
