`timescale 1ns/1ps
module tb_interface;
    logic clk,rst_n;
    logic s_awvalid,s_awready; logic [31:0] s_awaddr;
    logic s_wvalid,s_wready; logic [31:0] s_wdata; logic [3:0] s_wstrb;
    logic s_bvalid,s_bready; logic [1:0] s_bresp;
    logic s_arvalid,s_arready; logic [31:0] s_araddr;
    logic s_rvalid,s_rready; logic [31:0] s_rdata; logic [1:0] s_rresp;
    logic [15:0] weight_out,threshold_out,leak_out;
    logic spike_in_out;
    logic [15:0] membrane_in; logic spike_out_in;
    snn_interface dut(.clk(clk),.rst_n(rst_n),.s_awvalid(s_awvalid),.s_awready(s_awready),.s_awaddr(s_awaddr),.s_wvalid(s_wvalid),.s_wready(s_wready),.s_wdata(s_wdata),.s_wstrb(s_wstrb),.s_bvalid(s_bvalid),.s_bready(s_bready),.s_bresp(s_bresp),.s_arvalid(s_arvalid),.s_arready(s_arready),.s_araddr(s_araddr),.s_rvalid(s_rvalid),.s_rready(s_rready),.s_rdata(s_rdata),.s_rresp(s_rresp),.weight_out(weight_out),.threshold_out(threshold_out),.leak_out(leak_out),.spike_in_out(spike_in_out),.membrane_in(membrane_in),.spike_out_in(spike_out_in));
    initial clk=0;
    always #5 clk=~clk;
    assign membrane_in=16'h0300;
    assign spike_out_in=1'b0;
    integer pass_count,fail_count;
    task check32(input string name,input logic [31:0] got,input logic [31:0] exp);
        if(got===exp) begin $display("[PASS] %s",name); pass_count++; end
        else begin $display("[FAIL] %s: got=0x%08X exp=0x%08X",name,got,exp); fail_count++; end
    endtask
    task axi_write(input logic [31:0] addr,input logic [31:0] data);
        s_awvalid=1; s_awaddr=addr; s_wvalid=1; s_wdata=data; s_wstrb=4'hF;
        @(posedge clk); #1; s_awvalid=0; s_wvalid=0; s_bready=1;
        while(!s_bvalid) @(posedge clk);
        @(posedge clk); #1; s_bready=0; @(posedge clk); #1;
    endtask
    task axi_read(input logic [31:0] addr,output logic [31:0] data);
        s_arvalid=1; s_araddr=addr; s_rready=1;
        @(posedge clk); #1; s_arvalid=0;
        while(!s_rvalid) @(posedge clk);
        data=s_rdata; @(posedge clk); #1; s_rready=0; @(posedge clk); #1;
    endtask
    logic [31:0] rdata;
    initial begin
        pass_count=0; fail_count=0;
        s_awvalid=0; s_wvalid=0; s_bready=0; s_arvalid=0; s_rready=0;
        rst_n=0; repeat(4) @(posedge clk); #1; rst_n=1; repeat(2) @(posedge clk); #1;
        $display("=== Test 1: Write WEIGHT ===");
        axi_write(32'h00,32'h0000_0200);
        check32("T1 weight_out=0x0200",{16'h0,weight_out},32'h0000_0200);
        $display("=== Test 2: Read back WEIGHT ===");
        axi_read(32'h00,rdata);
        check32("T2 read WEIGHT=0x0200",rdata,32'h0000_0200);
        $display("=== Test 3: Write THRESHOLD ===");
        axi_write(32'h04,32'h0000_0600);
        check32("T3 threshold_out=0x0600",{16'h0,threshold_out},32'h0000_0600);
        $display("=== Test 4: Read MEMBRANE ===");
        axi_read(32'h0C,rdata);
        check32("T4 membrane=0x0300",rdata,32'h0000_0300);
        $display("-----------------------------------");
        if(fail_count==0) $display("PASS: All %0d checks passed.",pass_count);
        else $display("FAIL: %0d checks failed.",fail_count);
        $display("-----------------------------------");
        $finish;
    end
    initial begin #50000; $display("FAIL: Timeout."); $finish; end
endmodule
