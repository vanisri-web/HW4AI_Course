`timescale 1ns/1ps

module mac_tb;

    reg        clk;
    reg        rst;
    reg  signed [7:0]  a;
    reg  signed [7:0]  b;
    wire signed [31:0] out;

    // Instantiate the mac module
    mac uut (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(b),
        .out(out)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Initialize
        rst = 1;
        a = 0;
        b = 0;
        @(posedge clk); #1;

        // Release reset
        rst = 0;

        // Apply a=3, b=4 for 3 cycles
        a = 3; b = 4;
        @(posedge clk); #1; $display("Cycle 1: out = %0d", out);
        @(posedge clk); #1; $display("Cycle 2: out = %0d", out);
        @(posedge clk); #1; $display("Cycle 3: out = %0d", out);

        // Assert reset
        rst = 1;
        @(posedge clk); #1; $display("After reset: out = %0d", out);
        rst = 0;

        // Apply a=-5, b=2 for 2 cycles
        a = -5; b = 2;
        @(posedge clk); #1; $display("Cycle 4: out = %0d", out);
        @(posedge clk); #1; $display("Cycle 5: out = %0d", out);

        $finish;
    end

endmodule