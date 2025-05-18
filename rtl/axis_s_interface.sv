`timescale 1ns / 1ps
module axis_s_interface #(
    parameter LOGIC_SIZE = 32
)
(

    // From clock domain O (output)
    input logic s_axis_reset_n, // active low output clock domain reset
    input logic s_axis_aclk, // input clock domain clock
    output logic [LOGIC_SIZE-1:0] s_axis_tdata, // transmit data from the output
    output logic s_axis_valid,  // subordinate receiving axis valid 
    input logic s_axis_ready,   // subordinate controlled axis ready

    // Design-specific signals
    input logic [7:0] i_from_fifo,// from our fifo
    input logic r_empty,             // from the fifo to say it's empty
    output logic r_req               // to the fifo to say to read request or not
);

    localparam FIFO_SIZE = LOGIC_SIZE/8; // 4 by default
    typedef logic[$clog2(FIFO_SIZE)-1:0] strobe_t;
    typedef logic[LOGIC_SIZE-1:0] data_t;

    // Output interface AXIS handling

    logic o_wr_en, o_rd_en, o_empty, o_full;
    logic [LOGIC_SIZE-1:0] o_selected_data;
    strobe_t o_strobe_sel;

    always_ff @(posedge s_axis_aclk or negedge s_axis_reset_n) begin
        if(!s_axis_reset_n) begin // reset as wel on 
            s_axis_valid <= 0;
            o_wr_en <= 0;
            o_strobe_sel <= 0;
        end
        else begin 
            
            if(s_axis_ready && !o_full && 
                o_strobe_sel == strobe_t'('1)
            ) begin // the user wants to receive data, so try to pull from the FIFO
                o_wr_en <= 1;
                s_axis_valid <= 1;
            end
            else o_wr_en <= 0;
            if(!s_axis_ready) s_axis_valid <= 0;

            if(!o_full && !r_empty) begin  // on a non-full (internal FIFO), read one set of bytes and iterate over the strobe. 

                r_req <= 1; // we are going to a new byte, so we have to write it to the FIFO
                o_selected_data[o_strobe_sel*8 +: 8] <= i_from_fifo;

                if(o_strobe_sel == strobe_t'('1)) begin
                    o_strobe_sel <= 0;
                end
                else begin 
                    o_strobe_sel <= o_strobe_sel + 1;
                end
            end
            else begin 
                r_req <= 0; // don't rewrite the same data to the aFIFO
            end

            if(!o_empty) begin 
                if(o_strobe_sel == strobe_t'('1))
                    o_strobe_sel <= 0;
                else 
                    o_strobe_sel <= o_strobe_sel + 1;
            end
        
        end
    end

    always_comb begin
        if(!o_empty) begin
            o_rd_en = 1;
        end
        else begin 
            o_rd_en = 0;
        end
    end

    sync_fifo #(FIFO_SIZE, LOGIC_SIZE) o_FIFO(
        .rstn(s_axis_reset_n), 
        .clk(s_axis_aclk), 
        .wr_en(o_wr_en), 
        .rd_en(o_rd_en), 
        .din(o_selected_data), 
        .dout(s_axis_tdata), 
        .empty(o_empty), 
        .full(o_full)
    );

endmodule 