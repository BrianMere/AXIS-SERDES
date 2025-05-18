`timescale 1ns/1ps
module tb_top_axi_serdes;

`ifdef USE_POWER_PINS
    wire VPWR;
    wire VGND;
    assign VPWR=1;
    assign VGND=0;
`endif

localparam int NumPhase = 5;

logic m_axis_reset_n, s_axis_reset_n;
logic m_axis_aclk, s_axis_aclk;
logic [31:0] m_axis_tdata, s_axis_tdata;
logic m_axis_valid, s_axis_valid;
logic m_axis_ready, s_axis_ready;

logic tx_clk, rx_clk;

logic [NumPhase-1:0] clk_phase;

top_axi_serdes #(.NUM_PHASES(NumPhase)) DUT (.*);

// generate clock phases
genvar i;
generate
    for (i = 0; i < NumPhase; i++) begin: gen_clks
        always begin
            clk_phase[i] = 0;
            #i;
            while (1) begin
                #(NumPhase/2.0) clk_phase[i] = ~clk_phase[i];
            end
        end
    end
endgenerate

assign tx_clk = clk_phase[0];
assign rx_clk = clk_phase[0];
assign s_axis_reset_n = m_axis_reset_n;


// Make sure to call finish so test exits
always begin
    $dumpfile("tb_top_axi_serdes.vcd");
    $dumpvars(0);
    m_axis_reset_n <= 0;
    s_axis_valid <= 0;
    m_axis_ready <= 0;
    #10;
    m_axis_reset_n <= 1;
    s_axis_tdata <= 32'hdeadbeef;
    s_axis_valid <= 1;
    m_axis_ready <= 1;
    #20000;
    $finish();
end

endmodule

