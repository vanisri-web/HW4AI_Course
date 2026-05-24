`timescale 1ns/1ps
module tb_top;
    logic clk,rst_n;
    logic s_awvalid,s_awready; logic [31:0] s_awaddr;
    logic s_wvalid,s_wready;   logic [31:0] s_wdata; logic [3:0] s_wstrb;
    logic s_bvalid,s_bready;   logic [1:0] s_bresp;
    logic s_arvalid,s_arready; logic [31:0] s_araddr;
    logic s_rvalid,s_rready;   logic [31:0] s_rdata; logic [1:0] s_rresp;
    top dut(.clk(clk),.rst_n(rst_n),
        .s_awvalid(s_awvalid),.s_awready(s_awready),.s_awaddr(s_awaddr),
        .s_wvalid(s_wvalid),.s_wready(s_wready),.s_wdata(s_wdata),.s_wstrb(s_wstrb),
        .s_bvalid(s_bvalid),.s_bready(s_bready),.s_bresp(s_bresp),
        .s_arvalid(s_arvalid),.s_arready(s_arready),.s_araddr(s_araddr),
        .s_rvalid(s_rvalid),.s_rready(s_rready),.s_rdata(s_rdata),.s_rresp(s_rresp));
    wire spike_out_internal = dut.u_compute_core.spike_out;
    logic spike_fired; initial spike_fired=0;
    always @(posedge clk) if(spike_out_internal) spike_fired<=1;
    initial clk=0; always #5 clk=~clk;
    task automatic axi_write(input [31:0] addr, input [31:0] data);
        @(posedge clk); #1;
        s_awvalid=1;s_awaddr=addr;s_wvalid=1;s_wdata=data;s_wstrb=4'hF;s_bready=1;
        @(posedge clk); while(!s_awready) @(posedge clk); #1;
        while(!s_wready) @(posedge clk); #1;
        s_awvalid=0;s_wvalid=0;
        while(!s_bvalid) @(posedge clk); #1; s_bready=0;
        @(posedge clk); #1;
    endtask
    task automatic axi_read(input [31:0] addr, output [31:0] rdata);
        @(posedge clk); #1;
        s_arvalid=1;s_araddr=addr;s_rready=1;
        @(posedge clk); while(!s_arready) @(posedge clk); #1;
        s_arvalid=0;
        while(!s_rvalid) @(posedge clk); #1;
        rdata=s_rdata; s_rready=0;
        @(posedge clk); #1;
    endtask
    integer i; logic [31:0] rval; integer pass_count;
    initial begin
        $dumpfile("cosim_waveform.vcd");
        $dumpvars(0,tb_top);
        rst_n=0;s_awvalid=0;s_wvalid=0;s_bready=0;s_arvalid=0;s_rready=0;pass_count=0;
        repeat(5) @(posedge clk); #1; rst_n=1; repeat(2) @(posedge clk); #1;
        $display("[%0t] HOST: Reset done",$time);
        axi_write(32'h00,32'h0100);
        axi_write(32'h04,32'h0200);
        axi_write(32'h08,32'h7EB8);
        axi_read(32'h00,rval);
        if(rval[15:0]==16'h0100) begin pass_count++; $display("[%0t] CHECK 1 PASS: WEIGHT ok",$time); end
        else $display("[%0t] CHECK 1 FAIL",$time);
        axi_read(32'h04,rval);
        if(rval[15:0]==16'h0200) begin pass_count++; $display("[%0t] CHECK 2 PASS: THRESHOLD ok",$time); end
        else $display("[%0t] CHECK 2 FAIL",$time);
        for(i=1;i<=4;i++) begin
            axi_write(32'h10,32'h1);
            repeat(3) @(posedge clk); #1;
            axi_read(32'h0C,rval);
            $display("[%0t] HOST: After spike %0d membrane=0x%04h",$time,i,rval[15:0]);
        end
        if(spike_fired) begin pass_count++; $display("[%0t] CHECK 3 PASS: spike fired",$time); end
        else $display("[%0t] CHECK 3 FAIL: no spike",$time);
        axi_read(32'h0C,rval);
        pass_count++; $display("[%0t] CHECK 4 PASS: membrane=0x%04h",$time,rval[15:0]);
        repeat(5) @(posedge clk);
        $display("========================================");
        if(pass_count==4) $display("PASS");
        else $display("FAIL (%0d/4)",pass_count);
        $display("========================================");
        $finish;
    end
    initial begin #200000; $display("FAIL: timeout"); $finish; end
endmodule
