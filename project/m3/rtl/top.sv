module top (
    input  logic        clk, rst_n,
    input  logic        s_awvalid,
    output logic        s_awready,
    input  logic [31:0] s_awaddr,
    input  logic        s_wvalid,
    output logic        s_wready,
    input  logic [31:0] s_wdata,
    input  logic [ 3:0] s_wstrb,
    output logic        s_bvalid,
    input  logic        s_bready,
    output logic [ 1:0] s_bresp,
    input  logic        s_arvalid,
    output logic        s_arready,
    input  logic [31:0] s_araddr,
    output logic        s_rvalid,
    input  logic        s_rready,
    output logic [31:0] s_rdata,
    output logic [ 1:0] s_rresp
);
    logic [15:0] weight_wire, threshold_wire, leak_wire, membrane_wire;
    logic spike_in_wire, spike_out_wire;
    snn_interface u_interface (
        .clk(clk),.rst_n(rst_n),
        .s_awvalid(s_awvalid),.s_awready(s_awready),.s_awaddr(s_awaddr),
        .s_wvalid(s_wvalid),.s_wready(s_wready),.s_wdata(s_wdata),.s_wstrb(s_wstrb),
        .s_bvalid(s_bvalid),.s_bready(s_bready),.s_bresp(s_bresp),
        .s_arvalid(s_arvalid),.s_arready(s_arready),.s_araddr(s_araddr),
        .s_rvalid(s_rvalid),.s_rready(s_rready),.s_rdata(s_rdata),.s_rresp(s_rresp),
        .weight_out(weight_wire),.threshold_out(threshold_wire),.leak_out(leak_wire),
        .spike_in_out(spike_in_wire),.membrane_in(membrane_wire),.spike_out_in(spike_out_wire)
    );
    compute_core u_compute_core (
        .clk(clk),.rst_n(rst_n),
        .spike_in(spike_in_wire),.weight(weight_wire),
        .threshold(threshold_wire),.leak_factor(leak_wire),
        .spike_out(spike_out_wire),.membrane(membrane_wire)
    );
endmodule
