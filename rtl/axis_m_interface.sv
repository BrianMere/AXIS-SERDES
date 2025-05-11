`timescale 1ns / 1ps
module axis_m_interface #(
    parameter LOGIC_SIZE = 32
)
(

    // From clock domain I (input)
    input logic m_axis_reset_n, // active low input clock domain reset
    input logic m_axis_aclk, // input clock domain clock
    input logic [LOGIC_SIZE-1:0] m_axis_tdata, // transmit data for the input
    input logic m_axis_valid,  // manager controlled axis valid 
    output logic m_axis_ready, // manager receiving axis ready

    // Design-specific signals
    output logic [7:0] o_to_fifo, // to our fifo
    input logic w_full,              // from the fifo to say it's full...
    output logic w_req               // data from the fifo to control writes
);

    localparam FIFO_SIZE = LOGIC_SIZE/8; // 4 by default
    typedef logic[$clog2(FIFO_SIZE)-1:0] strobe_t;
    typedef logic[LOGIC_SIZE-1:0] data_t;

    // Input interface AXIS handling

    logic i_wr_en, i_rd_en, i_empty, i_full;
    always_comb begin 
        w_req  = i_wr_en;
    end
    data_t i_selected_data;
    strobe_t i_strobe_sel;

    sync_fifo #(FIFO_SIZE, LOGIC_SIZE) i_FIFO(
        .rstn(m_axis_reset_n), 
        .clk(m_axis_aclk), 
        .wr_en(i_wr_en), 
        .rd_en(i_rd_en), 
        .din(m_axis_tdata), 
        .dout(i_selected_data), 
        .empty(i_empty), 
        .full(i_full)
    );

    always_ff @(posedge m_axis_aclk or negedge m_axis_reset_n) begin
        if(!m_axis_reset_n) begin // reset as wel on 
            m_axis_ready <= 0;
            i_wr_en <= 0;
            i_rd_en <= 0;
            i_strobe_sel <= 0;
        end
        else begin 
            m_axis_ready <= 1;
            if(m_axis_valid && !i_full && !w_full) // the user wants to send data, so try
                i_wr_en <= 1;
            else 
                i_wr_en <= 0;

            if(!i_empty) begin  // on a non-empty, read one set of bytes and iterate over the strobe. 
                if(i_strobe_sel == strobe_t'(-1)) begin 
                    i_strobe_sel <= 0;
                    i_rd_en <= 1;
                end
                else begin 
                    i_strobe_sel <= i_strobe_sel + 1;
                    i_rd_en <= 0;
                end
            end
        end
    end

    always_comb begin
        if(!m_axis_reset_n)
            o_to_fifo = 0;
        else 
            o_to_fifo = i_selected_data[i_strobe_sel*8 +: 8];
    end

endmodule 