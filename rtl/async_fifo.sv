module async_fifo #(
    parameter FIFO_SIZE = 32,  // Number of 'logics' in our fifo
    parameter LOGIC_SIZE = 8   // How big our 'logic' size is, in bits
) (
    // Independent of clock
    input logic i_rst_n,    // Active-low reset (reset internal data)

    // Clock Domain for the input
    input logic i_wclk,     // write clock signal (async)
    input logic i_wr,       // write request
    input logic [LOGIC_SIZE-1:0] i_wdata, // input write data
    output logic o_wfull,   // indicates if the writing is full (cannot write)

    // Clock Domain for the output
    input logic i_rclk,     // input read clock signal (async)
    input logic i_rr,       // input read request
    output logic [LOGIC_SIZE-1:0] i_rdata, // output read data (after a request)
    output logic o_rempty   // indicates if the reading is empty (cannot read)

);
    logic [FIFO_SIZE-1:0] [LOGIC_SIZE-1:0] queue_data; 

    
    

    
endmodule