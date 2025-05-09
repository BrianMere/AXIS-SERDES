module axis_interface #(
    parameter LOGIC_SIZE = 32
)
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

    // Design-specific signals
    output logic [7:0] o_to_encoder, // to our 8b/10b encoder
    input logic [7:0] i_from_decoder // from our 8b/10b decoder
);

    localparam FIFO_SIZE = LOGIC_SIZE/8; // 4 by default
    typedef logic[$clog2(FIFO_SIZE)-1:0] strobe_t;
    typedef logic[LOGIC_SIZE-1:0] data_t;

    // for our FIFOs we must reset once a transaction is done as well
    logic fifo_reset_n;
    assign fifo_reset_n = (s_axis_ready && m_axis_valid);

    // Input interface AXIS handling

    logic i_wr_en, i_rd_en, i_empty, i_full;
    data_t i_selected_data;
    strobe_t i_strobe_sel;

    sync_fifo #(FIFO_SIZE, LOGIC_SIZE) i_FIFO(
        .rstn(fifo_reset_n), 
        .clk(m_axis_aclk), 
        .wr_en(i_wr_en), 
        .rd_en(i_rd_en), 
        .din(m_axis_tdata), 
        .dout(i_selected_data), 
        .empty(i_empty), 
        .full(i_full)
    );

    always_ff @(posedge m_axis_aclk or negedge m_axis_reset_n or negedge fifo_reset_n) begin
        if(!m_axis_reset_n) begin // reset as wel on 
            m_axis_ready <= 0;
            i_wr_en <= 0;
            i_rd_en <= 0;
            if(!fifo_reset_n)
                i_strobe_sel <= 0;
        end
        else begin 
            m_axis_ready <= 1;
            if(m_axis_valid && !i_full) // the user wants to send data, so try
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
            o_to_encoder = 0;
        else 
            o_to_encoder = i_selected_data[i_strobe_sel*8 +: 8];
    end

    // Output interface AXIS handling

    logic o_wr_en, o_rd_en, o_empty, o_full;
    logic[7:0] o_selected_data;
    strobe_t o_strobe_sel;

    sync_fifo #(FIFO_SIZE, 8) o_FIFO(
        .rstn(fifo_reset_n), 
        .clk(s_axis_aclk), 
        .wr_en(o_wr_en), 
        .rd_en(o_rd_en), 
        .din(i_from_decoder), 
        .dout(o_selected_data), 
        .empty(o_empty), 
        .full(o_full)
    );

    always_ff @(posedge s_axis_aclk or negedge s_axis_reset_n or negedge fifo_reset_n) begin
        if(!s_axis_reset_n) begin
            s_axis_valid <= 0;
            o_wr_en <= 0;
            o_rd_en <= 0;
            if(!fifo_reset_n)
                o_strobe_sel <= 0;
        end
        else begin 
            s_axis_valid <= 1;
            if(s_axis_ready && !o_full) // the user wants to receive data, so try
                o_wr_en <= 1;
            else 
                o_wr_en <= 0;

            if(!o_empty) begin  // on a non-empty, read one set of bytes and iterate over the strobe. 
                if(i_strobe_sel == strobe_t'(-1)) begin 
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
        s_axis_tdata[o_strobe_sel*8 +: 8] = o_selected_data;
    end

endmodule 