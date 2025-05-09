module top_axi_serdes #(
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
    input logic s_axis_ready    // subordinate controlled axis ready
);

    logic [7:0] to_encoder, from_decoder;

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

        .o_to_encoder(to_encoder), 
        .i_from_decoder(from_decoder)
    );

    logic [9:0] from_encoder, to_decoder;

    // Continue from here...
    // encoder_8b10 encoder(
    //     .clk(m_axis_aclk), 
    //     .rst(!m_axis_reset_n), 
    //     .en(1), 
    //     .kin()
    // )



    

endmodule 