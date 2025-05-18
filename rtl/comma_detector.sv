`timescale 1ns / 1ps

`define COMMA_ENC (10'h0FA)
`define COMMA_DETECTED (shift_reg == `COMMA_ENC || shift_reg == ~`COMMA_ENC)

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

    always_ff @(posedge clk) begin 
        if(rst) shift_reg <= 0;
        //else shift_reg <= {shift_reg[8:0], strobin};
        else shift_reg <= {strobin, shift_reg[9:1]};

        if(rst) bit_align_counter <= 0; // reset on comma or reset
        else if(bit_align_counter == 9) bit_align_counter <= 0; // overflow
        else if(`COMMA_DETECTED) bit_align_counter <= 1; // we detected at cycle 0 so we offset by 1
        else bit_align_counter <= bit_align_counter + 1;
    end

    // debug information... 
    logic comma_detected;
    always_comb begin 
        comma_detected = `COMMA_DETECTED;
    end

    always_ff @(posedge clk) begin
        if(rst) fifo_wen <= 0;

        else if(!kout) begin 
            if(bit_align_counter == 0 && !kout) begin 
                fifo_wen <= !fifo_full; // all we can do, if the fifo is full, is respect it. This is the crux that doesn't allow this to be 100\% correct.
            end
            else begin 
                fifo_wen <= 0; // we don't need to repeat writes
                // and don't change the data if we are in the middle of getting more data
            end
        end
        else begin 
            fifo_wen <= 0;
        end

        if(bit_align_counter == 9) 
            dout <= decoded_data;
        
    end

    always_comb begin 
        // and the data we want to write is from the decoder always
        // if(disp) begin 
        //     dout = ~decoded_data;
        // end
        // else begin 
        //     dout = decoded_data;
        // end
        
    end

    logic code_err, disp, disp_err;
    decoder_8b10b decode_this(
        .clk(clk), 
        .rst(rst), 
        .en(bit_align_counter == 0), 
        .din(shift_reg), 
        .dout(decoded_data),
        .kout(kout),
        .code_err(code_err), // not connected (ignoring errors)
        .disp_err(disp_err),
        .disp(disp)  // we don't care, but gives info on whether P or N are used.
    );
    
endmodule