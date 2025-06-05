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
    data_t i_selected_data;
    strobe_t i_strobe_sel;
    logic valid_selected_data;

    // our transmitted data goes into the FIFO and then is parsed by us to the aFIFO
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
            i_strobe_sel <= 0;
            valid_selected_data <= 0; // resets will invalidate i_selected_data
        end
        else begin 
            
            if(m_axis_valid && !i_full) begin // the user wants to send data, so try to put into the FIFO
                i_wr_en <= 1;
                m_axis_ready <= 1;
            end
            else begin // we don't have to write if the data isn't valid, or if we can't write internally
                i_wr_en <= 0;
                m_axis_ready <= 0;
            end

            if(!i_empty && !w_full) begin  // on a non-empty (internal FIFO), read one set of bytes and iterate over the strobe. 
                if(valid_selected_data) w_req <= 1; // we are going to a new byte, so we have to write it to the FIFO
                else w_req <= 0;

                if(i_strobe_sel == strobe_t'('1)-1) valid_selected_data <= 1; // do it the CYCLE BEFORE so that w_req goes at the right time. 
                if(i_strobe_sel == strobe_t'('1)) i_strobe_sel <= 0; 
                else i_strobe_sel <= i_strobe_sel + 1;
            end
            else begin 
                w_req <= 0; // don't rewrite the same data to the aFIFO
            end
        
        end
    end

    always_comb begin
        if(!i_empty && i_strobe_sel == strobe_t'('1)) begin
            i_rd_en = 1;
        end
        else begin 
            i_rd_en = 0;
        end
    end

    always_comb begin
        if(!m_axis_reset_n)
            o_to_fifo = 0;
        else 
            o_to_fifo = i_selected_data[i_strobe_sel*8 +: 8];
    end

endmodule 