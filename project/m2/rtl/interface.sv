// =============================================================================
// Module:      interface
// Project:     Spiking Neural Network (SNN) Speedup Chip
// Course:      ECE 410/510 – Hardware for AI/ML, Spring 2026
// Author:      Vanisri Kyatham
// Description: AXI4-Lite slave interface to configure the LIF neuron core.
//
// Port List:
//   clk          – input,  1b  – AXI clock (rising-edge triggered)
//   rst_n        – input,  1b  – Active-low synchronous reset
//   s_awvalid    – input,  1b  – Master drives valid write address
//   s_awready    – output, 1b  – Slave ready to accept write address
//   s_awaddr     – input, 32b  – Byte address of write target
//   s_wvalid     – input,  1b  – Master drives valid write data
//   s_wready     – output, 1b  – Slave ready to accept write data
//   s_wdata      – input, 32b  – Write data
//   s_wstrb      – input,  4b  – Byte strobes
//   s_bvalid     – output, 1b  – Slave drives valid write response
//   s_bready     – input,  1b  – Master ready to accept response
//   s_bresp      – output, 2b  – Response: 00=OKAY, 10=SLVERR
//   s_arvalid    – input,  1b  – Master drives valid read address
//   s_arready    – output, 1b  – Slave ready to accept read address
//   s_araddr     – input, 32b  – Byte address of read target
//   s_rvalid     – output, 1b  – Slave drives valid read data
//   s_rready     – input,  1b  – Master ready to accept read data
//   s_rdata      – output,32b  – Read data
//   s_rresp      – output, 2b  – Response: 00=OKAY, 10=SLVERR
//   weight_out   – output,16b  – Connected to compute_core weight port
//   threshold_out– output,16b  – Connected to compute_core threshold port
//   leak_out     – output,16b  – Connected to compute_core leak_factor port
//   spike_in_out – output, 1b  – Connected to compute_core spike_in port
//   membrane_in  – input, 16b  – From compute_core membrane port
//   spike_out_in – input,  1b  – From compute_core spike_out
//
// Protocol:  AXI4-Lite slave (ARM IHI0022E)
// Register Map (byte address):
//   0x00  WEIGHT      – Synaptic weight   (Q8.8, 16-bit)
//   0x04  THRESHOLD   – Firing threshold  (Q8.8, 16-bit)
//   0x08  LEAK_FACTOR – Leak factor       (Q1.15, 16-bit)
//   0x0C  MEMBRANE_RO – Membrane potential (read-only, 16-bit)
//   0x10  SPIKE_IN    – Write 1 to inject a spike
//   0x14  SPIKE_OUT   – Read-only: last spike output
//
// Clock Domain: Single (clk).
// Reset:        Synchronous, active-low.
// =============================================================================

module interface (
    input  logic        clk,
    input  logic        rst_n,
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
    output logic [ 1:0] s_rresp,
    output logic [15:0] weight_out,
    output logic [15:0] threshold_out,
    output logic [15:0] leak_out,
    output logic        spike_in_out,
    input  logic [15:0] membrane_in,
    input  logic        spike_out_in
);

    logic [15:0] reg_weight;
    logic [15:0] reg_threshold;
    logic [15:0] reg_leak;
    logic        reg_spike_in;
    logic [31:0] aw_addr_lat;
    logic        aw_active;
    logic [31:0] w_data_lat;
    logic [ 3:0] w_strb_lat;
    logic        w_active;

    localparam ADDR_WEIGHT    = 32'h00;
    localparam ADDR_THRESHOLD = 32'h04;
    localparam ADDR_LEAK      = 32'h08;
    localparam ADDR_MEMBRANE  = 32'h0C;
    localparam ADDR_SPIKE_IN  = 32'h10;
    localparam ADDR_SPIKE_OUT = 32'h14;

    assign weight_out    = reg_weight;
    assign threshold_out = reg_threshold;
    assign leak_out      = reg_leak;
    assign spike_in_out  = reg_spike_in;
    assign s_awready     = !aw_active;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            aw_active   <= 1'b0;
            aw_addr_lat <= 32'h0;
        end else begin
            if (s_awvalid && s_awready) begin
                aw_addr_lat <= s_awaddr;
                aw_active   <= 1'b1;
            end else if (s_bvalid && s_bready) begin
                aw_active   <= 1'b0;
            end
        end
    end

    assign s_wready = !w_active;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            w_active   <= 1'b0;
            w_data_lat <= 32'h0;
            w_strb_lat <= 4'h0;
        end else begin
            if (s_wvalid && s_wready) begin
                w_data_lat <= s_wdata;
                w_strb_lat <= s_wstrb;
                w_active   <= 1'b1;
            end else if (s_bvalid && s_bready) begin
                w_active   <= 1'b0;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            s_bvalid      <= 1'b0;
            s_bresp       <= 2'b00;
            reg_weight    <= 16'h0100;
            reg_threshold <= 16'h0800;
            reg_leak      <= 16'h7EB8;
            reg_spike_in  <= 1'b0;
        end else begin
            reg_spike_in <= 1'b0;
            if (aw_active && w_active && !s_bvalid) begin
                s_bvalid <= 1'b1;
                s_bresp  <= 2'b00;
                case (aw_addr_lat)
                    ADDR_WEIGHT:    reg_weight    <= w_data_lat[15:0];
                    ADDR_THRESHOLD: reg_threshold <= w_data_lat[15:0];
                    ADDR_LEAK:      reg_leak      <= w_data_lat[15:0];
                    ADDR_SPIKE_IN:  reg_spike_in  <= w_data_lat[0];
                    default:        s_bresp       <= 2'b10;
                endcase
            end else if (s_bvalid && s_bready) begin
                s_bvalid <= 1'b0;
            end
        end
    end

    assign s_arready = !s_rvalid;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            s_rvalid <= 1'b0;
            s_rdata  <= 32'h0;
            s_rresp  <= 2'b00;
        end else begin
            if (s_arvalid && s_arready) begin
                s_rvalid <= 1'b1;
                s_rresp  <= 2'b00;
                case (s_araddr)
                    ADDR_WEIGHT:    s_rdata <= {16'h0, reg_weight};
                    ADDR_THRESHOLD: s_rdata <= {16'h0, reg_threshold};
                    ADDR_LEAK:      s_rdata <= {16'h0, reg_leak};
                    ADDR_MEMBRANE:  s_rdata <= {16'h0, membrane_in};
                    ADDR_SPIKE_IN:  s_rdata <= {31'h0, reg_spike_in};
                    ADDR_SPIKE_OUT: s_rdata <= {31'h0, spike_out_in};
                    default: begin
                        s_rdata <= 32'hDEADBEEF;
                        s_rresp <= 2'b10;
                    end
                endcase
            end else if (s_rvalid && s_rready) begin
                s_rvalid <= 1'b0;
            end
        end
    end

endmodule
