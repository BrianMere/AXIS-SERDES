`timescale 1ns/1ps

// Return the grey code for the input'ed value. Only works for counter values (ie: sequential values)
`define GREY_CODE(val) ((val) ^ ((val) >> 1))

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
    output logic [LOGIC_SIZE-1:0] o_rdata, // output read data (after a request)
    output logic o_rempty   // indicates if the reading is empty (cannot read)

); 
    typedef logic [$clog2(FIFO_SIZE):0] fifo_ptr_t;

    logic [FIFO_SIZE-1:0] [LOGIC_SIZE-1:0] queue_data; // driven here

    // Pointers for the read-write pointers
    fifo_ptr_t r_ptr, w_ptr; // driven here

    // Gray-code pointers from the OTHER clock domain (here _s suggests it's 'synchronized', so the output of the other OTHER domain)
    fifo_ptr_t rgray_s, wgray_s; // driven by synch.

    // Read-to-write grey code clock domain synch.
    synchronizer #($bits(fifo_ptr_t), 2) ReadToWrite(
        .i_reset_n(i_rst_n), 
        .i_input_data(GREY_CODE(r_ptr)), 
        .i_new_clk(i_wclk), 
        .o_output_data(rgray_s)
    );

    // Write-to-read grey code clock domain synch.
    synchronizer #($bits(fifo_ptr_t), 2) WriteToRead(
        .i_reset_n(i_rst_n), 
        .i_input_data(GREY_CODE(w_ptr)), 
        .i_new_clk(i_rclk), 
        .o_output_data(wgray_s)
    );

    // Intialize our values with 0's
    initial begin
        r_ptr = 0; w_ptr = 0; queue_data = 0;
    end

    // Set the values of the flags as combinational circuits
    always_comb begin : flags
        o_wfull = IS_FULL();
        o_rempty = IS_EMPTY();
    end

    // Handle the writing itself (write clock domain)
    always_ff @(posedge i_wclk or negedge i_rst_n) begin : writes
        if(!i_rst_n) w_ptr <= 0; // reset logic
        else if(!IS_FULL() && i_wr) begin 
            queue_data[w_ptr] <= i_wdata;
            w_ptr <= w_ptr + 1;
        end
    end

    // Handle the reading itself (read clock domain)
    always_ff @(posedge i_rclk or negedge i_rst_n) begin : reads
        if(!i_rst_n) r_ptr <= 0; // reset logic
        else if(!IS_EMPTY() && i_rr) begin 
            o_rdata <= queue_data[r_ptr+1];
            r_ptr <= r_ptr + 1;
        end
    end


    // DEBUG Variables
    fifo_ptr_t r_gray, w_gray;
    always_comb begin : grayCodeDebug
        r_gray = GREY_CODE(r_ptr);
        w_gray = GREY_CODE(w_ptr);
    end

// BEGIN FUNCTION DEFS

// Returns if the FIFO is empty or not. Only works for the read clock domain. 
function logic IS_EMPTY();
    return r_gray == wgray_s;
endfunction;

// Returns if the FIFO is full or not. Only works from the write clock domain. 
function logic IS_FULL();
    return (w_gray[$bits(fifo_ptr_t)-1:$bits(fifo_ptr_t)-2] == ~rgray_s[$bits(fifo_ptr_t)-1:$bits(fifo_ptr_t)-2])
        && (w_gray[$bits(fifo_ptr_t)-3:0] == rgray_s[$bits(fifo_ptr_t)-3:0]);
endfunction;

function automatic logic [WIDTH-1:0] GREY_CODE (input logic [WIDTH-1:0] count);
    parameter WIDTH = $bits(fifo_ptr_t);
    return count ^ (count >> 1);
endfunction;
    
endmodule