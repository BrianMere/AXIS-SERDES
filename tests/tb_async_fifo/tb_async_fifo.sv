module tb_async_fifo;

// Params for the DUT
localparam LOGIC_SIZE = 32;
localparam FIFO_SIZE  = 128;

logic i_rst_n;    // Active-low reset (reset internal data)

// Clock Domain for the input
logic i_wclk;     // write clock signal (async)
logic i_wr;       // write request
logic [LOGIC_SIZE-1:0] i_wdata; // input write data
logic o_wfull;   // indicates if the writing is full (cannot write)

// Clock Domain for the output
logic i_rclk;     // input read clock signal (async)
logic i_rr;      // input read request
logic [LOGIC_SIZE-1:0] o_rdata; // output read data (after a request)
logic o_rempty;   // indicates if the reading is empty (cannot read)

async_fifo #(FIFO_SIZE, LOGIC_SIZE) DUT(.*);

// Necessary to create Waveform
initial begin
    // Name as needed
    $dumpfile("tb_async_fifo.vcd");
    $dumpvars(0);
end

// Random array for testing
localparam MEMSIZE = 64;
localparam MEMSIZE_BITS = $clog2(MEMSIZE);
bit [LOGIC_SIZE-1:0] mem[0:MEMSIZE];
int read_ptr = 0;
int write_ptr = 0;
parameter MAX_VAL = (1 << LOGIC_SIZE) - 1;
initial begin 
    for (int i = 0; i < MEMSIZE; i++) begin 
        //mem[i] = $urandom_range(0, MAX_VAL)[LOGIC_SIZE-1:0] ; // implicit cast here...
        mem[i] = i;
        $display("mem[%d] = %d", i, mem[i]);
    end
end

// Handle the logic of syncronizing the designed FIFO with ours, considering the clocking
always @(posedge i_wclk) begin 
    if(i_rst_n && i_wr && !o_wfull) begin 
      write_ptr <= write_ptr + 1;
    end
end 
always @(posedge i_rclk) begin 
    #(TIME_PERIOD/2);
    if(i_rst_n && i_rr && !o_rempty) begin 
        assert(mem[read_ptr] == o_rdata) else $error("FIFO contents on read didn't match. Expected %d but got %d.", mem[read_ptr], o_rdata);
        read_ptr <= read_ptr + 1;
    end
end

// Make sure to call finish so test exits
always begin

    // This test should
    // 1: Test that the FIFO works under equal clocks.
    // 2: Test that the FIFO can handle the empty case (have Bclk go faster than Aclk)
    // 3: Test that the FIFO can handle the full case (now Bclk is faster)

    // 0: Prelim reset test...

    i_wr = 0; i_rr = 0;
    i_wdata = 0; 

    // undefined behavior rn
    i_rst_n = 1;
    clock();
    clock();

    i_rst_n = 0;
    clock();
    clock();
    assert(o_rempty) else $error("Empty not asserted on reset");
    assert(!o_wfull) else $error("Full was asserted on the reset");

    // 1: Unequal Clocks, to simulate a bit of filling up the queue.

    CLK_W_PERIOD_DIV = 2;
    CLK_R_PERIOD_DIV = 3;

    i_rst_n = 1; // turn off reset
    i_rr = 1; // always try to read request...
    for(int i = 0; i < 1000; i++) begin 
        i_wr = 1;
        i_wdata = getNextData();
        wclock();
    end
    i_wr = 0;

    // 2: Unequal Clocks, to simulate stopping the flow of information into the queue

    CLK_W_PERIOD_DIV = 3;
    CLK_R_PERIOD_DIV = 2;

    for(int i = 0; i < 2000; i++) begin
        i_wr = 1;
        i_wdata = getNextData();
        wclock();
    end

    $finish;
end

// Sample to drive clock
localparam TIME_PERIOD = 1; // value to use in the clock() task
int CLK_W_PERIOD_DIV = 2;
int CLK_R_PERIOD_DIV = 3;

logic ref_clk = 0;
longint current_time = 0;

// Handle what the other clocks do 
always @(posedge ref_clk or negedge ref_clk) begin
    current_time <= current_time + 1; 

    $display("Current Time: %d", current_time);

    if(bit '(current_time % longint'(CLK_W_PERIOD_DIV)))  begin
        i_wclk <= ~i_wclk;
    end
    
    if(bit '(current_time % longint'(CLK_R_PERIOD_DIV)))
        i_rclk <= ~i_rclk;
end

/** Delay for one TIME_PERIOD, making the other clocks go at the
    specified periods.
*/
task clock();
    #(TIME_PERIOD);
    ref_clk=~ref_clk;
endtask

/** Wait for w_clk to have at least one posedge
*/
task wclock();
    while(i_wclk) clock();
    while(!i_wclk) clock();
endtask

/** 
    Gets the next data in the memory array, making sure
    to keep track of the index. 
*/
function bit [LOGIC_SIZE-1:0] getNextData(); 
    return mem[write_ptr];
endfunction

endmodule