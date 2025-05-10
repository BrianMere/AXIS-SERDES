`timescale 1ns / 1ps
/**
  Wrapper to try to take in strobe bits at a time to know when we
  should send the normal packet (decoded), or we got the comma character
  and need to adjust
*/
module comma_detector #(
    parameter NUM_BYTES_PER_PACKET = 8 // power of 2, one more than the actual number of bytes per packet
) (
    input logic rst,          // Active high reset

    input logic strobin,      // From the TX SERDES
    input logic clk,          // Rx Clock

    output logic fifo_wen,    // Flag to say we'd want to read
    input logic  fifo_full,   // Flag that says the fifo is full. We'll ignore data if that's the case.

    output logic [7:0] dout   // the bits to send to the fifo for writing 
);

    logic [9:0] shift_reg;
    logic [7:0] decoded_data;
    logic [4:0] bit_align_counter;
    logic kout;


    always_ff @(posedge clk or posedge rst) begin 
        if(rst) shift_reg <= 0;
        else shift_reg <= {shift_reg[9:1] , strobin};

        if(rst || kout) bit_align_counter <= 0; // reset on comma or reset
        else if(bit_align_counter == 9) bit_align_counter <= 0; // overflow
        else bit_align_counter <= bit_align_counter + 1;
    
    end

    always_comb begin 
        fifo_wen = !fifo_full; // all we can do, if the fifo is full, is respect it. This is the crux that doesn't allow this to be 100\% correct. 
        dout = decoded_data;
    end
    
    decoder_8b10b decode_this(
        .clk(clk), 
        .rst(rst), 
        .en(1), 
        .din(shift_reg), 
        .dout(decoded_data),
        .kout(kout),
        .code_err(), // not connected (ignoring errors)
        .disp_err(),
        .disp()  // we don't care, but gives info on whether P or N are used.
    );
    
endmodule