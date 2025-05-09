`timescale 1ns / 1ps
/**
  Wrapper to try to take in 8B packets at a time to know when we
  should send the normal packet (encoded), or we should send the 
  comma character.
*/
module comma_counter #(
    parameter NUM_BYTES_PER_PACKET = 8 // power of 2, one more than the actual number of bytes per packet
) (
    input logic rst,          // Active high reset

    input logic [7:0] din,    // Data we'd normally transmit
    input logic clk,          // Transmit Clock

    output logic fifo_ren,    // Flag to say we'd want to read
    input logic  fifo_empty,  // Flag that says the fifo is empty. We'll send commas if that's the case.

    output logic strobe_bit   // the bit to send into the SERDES void 
);

    logic [$clog2(NUM_BYTES_PER_PACKET)-1:0] c_counter; // byte per packet counter
    logic [3:0] b_counter; // bit strobe counter, needs to count to 10
    logic kin; // used to denote K sel (1) or D sel (0)
    logic [9:0] encoded_data;
    logic [7:0] enc_in; // mux between the comma byte and the not comma byte

    always_comb begin : SendingCommaFlag
        kin = (c_counter == 0 || fifo_empty);
        fifo_ren = !kin && b_counter == 9; // kin is high for commas, so we should not read on comma sends. 

        case (kin)
            0: enc_in = 8'hBC;
            1: enc_in = din;
        endcase

        strobe_bit = encoded_data[b_counter]; // the strobe selects the n-th bit
    end

    always_ff @(posedge clk or posedge rst) begin : Strobe
        if(rst) b_counter <= 0;
        else if (b_counter == 9) b_counter <= 0; //loopback
        else if (clk) b_counter <= b_counter+1;
    end

    always_ff @(posedge b_counter or posedge rst) begin : PacketCount
        if(rst) c_counter <= 0;
        else if (b_counter == 9) c_counter <= c_counter+1;
    end

    encoder_8b10 encode_this(
        .clk(clk), 
        .rst(rst), 
        .en(1), 
        .kin(kin), 
        .din(enc_in), 
        .dout(encoded_data),
        .disp(), // we don't care, but gives info on whether P or N are used.
        .kin_err() // not connected (ignoring errors)
    );
    
endmodule