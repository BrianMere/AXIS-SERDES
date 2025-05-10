`timescale 1ns / 1ps
module top_axi_serdes 
(
    // From clock domain I (input)
    input logic m_axis_reset_n, // active low input clock domain reset
    input logic m_axis_aclk, // input clock domain clock
    input logic [LOGIC_SIZE-1:0] m_axis_tdata, // transmit data for the input
    input logic m_axis_valid,  // manager controlled axis valid 
    output logic m_axis_ready, // manager receiving axis ready

    // From clock domain O (output)
    input logic s_axis_reset_n, // active low output clock domain reset
    input logic s_axis_aclk, // input clock domain clock
    output logic [LOGIC_SIZE-1:0] s_axis_tdata, // transmit data from the output
    output logic s_axis_valid,  // subordinate receiving axis valid 
    input logic s_axis_ready,   // subordinate controlled axis ready

    // Clocks
    input logic tx_clk,         // used in the transmit clock domain
    input logic rx_clk          // used in the receive clock domain
);

    localparam LOGIC_SIZE = 32;
    localparam FIFO_SIZE = 32;
    localparam NUM_BYTES_PER_PACKET = 8;

    logic [7:0] to_tx_fifo, from_tx_fifo;
    logic [7:0] to_rx_fifo, from_rx_fifo;
    logic k_flag_enc, k_flag_dec;

    logic tx_fifo_ren, tx_fifo_wen;
    logic tx_fifo_full, tx_fifo_empty;

    logic rx_fifo_ren, rx_fifo_wen;
    logic rx_fifo_full, rx_fifo_empty;

    logic strobe_bit; // sent into the aether

    // User Space

    axis_interface #(LOGIC_SIZE) AXIS_Interface(
        .m_axis_reset_n(m_axis_reset_n), 
        .m_axis_aclk(m_axis_aclk), 
        .m_axis_tdata(m_axis_tdata), 
        .m_axis_valid(m_axis_valid), 
        .m_axis_ready(m_axis_ready), 

        .s_axis_reset_n(s_axis_reset_n), 
        .s_axis_aclk(s_axis_aclk), 
        .s_axis_tdata(s_axis_tdata), 
        .s_axis_valid(s_axis_valid), 
        .s_axis_ready(s_axis_ready), 

        .o_to_fifo(to_tx_fifo), 
        .w_full(tx_fifo_full), 
        .w_req(tx_fifo_wen), 
        .i_from_fifo(from_rx_fifo), 
        .r_empty(rx_fifo_empty), 
        .r_req(tx_fifo_ren)
    );

    async_fifo #(FIFO_SIZE, 8) TXFIFO(
        .i_rst_n(m_axis_reset_n), 
        .i_wclk(m_axis_aclk), 
        .i_wr(tx_fifo_wen), 
        .i_wdata(to_tx_fifo), 
        .o_wfull(tx_fifo_full),
        .i_rclk(tx_clk), 
        .i_rr(tx_fifo_ren), 
        .o_rdata(from_tx_fifo),
        .o_rempty(tx_fifo_empty) 
    );

    // consider in TX land: from_tx_fifo, tx_fifo_ren, tx_fifo_empty 
    comma_counter #(NUM_BYTES_PER_PACKET) comma_counter(
        .rst(!m_axis_reset_n), 
        .din(from_tx_fifo), 
        .clk(tx_clk),
        .fifo_ren(tx_fifo_ren), 
        .fifo_empty(tx_fifo_empty),
        .strobe_bit(strobe_bit)
    );

    // ------------- strobe_bit goes into the void ---------- //

    // consider in RX land: to_rx_fifo, rx_fifo_wen, rx_fifo_full
    comma_detector #(NUM_BYTES_PER_PACKET) comma_detector(
        .rst(!s_axis_reset_n), 
        .strobin(strobe_bit), 
        .clk(rx_clk), 
        .fifo_wen(rx_fifo_wen), 
        .fifo_full(rx_fifo_full), 
        .dout(to_rx_fifo)
    );

    async_fifo #(FIFO_SIZE, 8) RXFIFO(
        .i_rst_n(s_axis_reset_n), 
        .i_wclk(s_axis_aclk), 
        .i_wr(rx_fifo_wen), 
        .i_wdata(to_rx_fifo), 
        .o_wfull(rx_fifo_full), 
        .i_rclk(rx_clk), 
        .i_rr(rx_fifo_ren), 
        .o_rdata(from_rx_fifo),
        .o_rempty(rx_fifo_empty) 
    );

endmodule 