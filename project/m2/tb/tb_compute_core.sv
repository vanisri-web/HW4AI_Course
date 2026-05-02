`timescale 1ns/1ps
module tb_compute_core;
    logic clk, rst_n, spike_in, spike_out;
    logic [15:0] weight, threshold, leak_factor, membrane;
    compute_core dut (.clk(clk),.rst_n(rst_n),.spike_in(spike_in),.weight(weight),.threshold(threshold),.leak_factor(leak_factor),.spike_out(spike_out),.membrane(membrane));
    initial clk=0;
    always #5 clk=~clk;
    integer pass_count,fail_count;
    task check(input string name,input logic got,input logic exp);
        if(got===exp) begin $display("[PASS] %s",name); pass_count++; end
        else begin $display("[FAIL] %s: got=%0b exp=%0b",name,got,exp); fail_count++; end
    endtask
    task check16(input string name,input logic [15:0] got,input logic [15:0] exp);
        if(got===exp) begin $display("[PASS] %s",name); pass_count++; end
        else begin $display("[FAIL] %s: got=0x%04X exp=0x%04X",name,got,exp); fail_count++; end
    endtask
    initial begin
        pass_count=0; fail_count=0;
        weight=16'h0200; threshold=16'h0600; leak_factor=16'h8000;
        rst_n=0; spike_in=0;
        @(posedge clk); #1; @(posedge clk); #1; rst_n=1;
        $display("=== Test 1: Accumulate spikes until fire ===");
        spike_in=1;
        @(posedge clk); #1; check("T1 spike1 spike_out=0",spike_out,1'b0); check16("T1 spike1 membrane=0x0200",membrane,16'h0200);
        @(posedge clk); #1; check("T1 spike2 spike_out=0",spike_out,1'b0); check16("T1 spike2 membrane=0x0400",membrane,16'h0400);
        @(posedge clk); #1; check("T1 spike3 FIRE spike_out=1",spike_out,1'b1);
        $display("=== Test 2: Membrane resets to 0 after fire ===");
        check16("T2 membrane=0x0000",membrane,16'h0000);
        $display("=== Test 3: No spike when below threshold ===");
        spike_in=0; rst_n=0; @(posedge clk); #1; rst_n=1; @(posedge clk); #1;
        spike_in=1; @(posedge clk); #1; spike_in=0; @(posedge clk); #1;
        check("T3 no fire",spike_out,1'b0); check16("T3 membrane=0x0200",membrane,16'h0200);
        $display("-----------------------------------");
        if(fail_count==0) $display("PASS: All %0d checks passed.",pass_count);
        else $display("FAIL: %0d checks failed.",fail_count);
        $display("-----------------------------------");
        $finish;
    end
    initial begin #5000; $display("FAIL: Timeout."); $finish; end
endmodule
