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
    always_comb begin 
        r_req  = o_rd_en;
    end
    logic [7:0] o_selected_data;
    strobe_t o_strobe_sel;

    sync_fifo #(FIFO_SIZE, 8) o_FIFO(
        .rstn(s_axis_reset_n), 
        .clk(s_axis_aclk), 
        .wr_en(o_wr_en), 
        .rd_en(o_rd_en), 
        .din(i_from_fifo), 
        .dout(o_selected_data), 
        .empty(o_empty), 
        .full(o_full)
    );

    always_ff @(posedge s_axis_aclk or negedge s_axis_reset_n) begin
        if(!s_axis_reset_n) begin
            s_axis_valid <= 0;
            o_wr_en <= 0;
            o_rd_en <= 0;
            o_strobe_sel <= 0;
        end
        else begin 
            s_axis_valid <= 1;
            if(s_axis_ready && !o_full && !o_full) // the user wants to receive data, so try
                o_wr_en <= 1;
            else 
                o_wr_en <= 0;

            if(!o_empty) begin  // on a non-empty, read one set of bytes and iterate over the strobe. 
                if(o_strobe_sel == strobe_t'(-1)) begin 
                    o_strobe_sel <= 0;
                    o_rd_en <= 1;
                end
                else begin 
                    o_strobe_sel <= o_strobe_sel + 1;
                    o_rd_en <= 0;
                end
            end
        end
    end

    always_ff @(posedge s_axis_aclk) begin
        s_axis_tdata[o_strobe_sel*8 +: 8] <= o_selected_data;
    end

endmodule 