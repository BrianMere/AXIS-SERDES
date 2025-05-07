module tb_synchronizer;

localparam LOGIC_SIZE = 9; // can test only up to 32 bits
localparam NUM_FFS    = 4;

parameter MAX_VAL = (1 << LOGIC_SIZE) - 1;

reg [31:0] counter = 0;

// Sample to drive clock
localparam CLK_PERIOD = 2;

logic i_reset_n = 1;    // active low reset, but can be async from the new_clk
logic [LOGIC_SIZE-1:0] i_input_data = 0;  // from old clock domain
logic i_new_clk = 0;                      // clock domain for the output port

logic [LOGIC_SIZE-1:0] o_output_data;

synchronizer #(LOGIC_SIZE, NUM_FFS) DUT(.*);

// Random array for testing
localparam MEMSIZE = 32;
localparam MEMSIZE_BITS = $clog2(MEMSIZE);
logic [LOGIC_SIZE-1:0] mem[0:MEMSIZE-1];
logic[LOGIC_SIZE-1:0] index;
logic [LOGIC_SIZE-1:0] data_sel;
initial begin 
    for (int i = 0; i < MEMSIZE; i++) begin 
        mem[i] = $urandom_range(0, MAX_VAL)[LOGIC_SIZE-1:0] ; // implicit cast here...
        // integer for debugging: mem[i] = i[LOGIC_SIZE-1:0];
        $display("mem[%0d] = %0h", i, mem[i]);
    end
end

// Necessary to create Waveform
initial begin
    // Name as needed
    $dumpfile("tb_synchronizer.vcd");
    $dumpvars(0);
end

// Make sure to call finish so test exits
always begin

    i_reset_n = 1; // undefined
    i_input_data = 0;
    i_new_clk = 0;

    clock();
    clock();

    i_reset_n = 0; // active low
    
    clock();
    clock();

    assert(o_output_data == 0) else $error("Failed reset test on synchronization module.");

    i_reset_n = 1; // not active now... 
    clock();
    while (counter != MEMSIZE) begin
        i_input_data = mem[counter];
        $display("Testing %d out of %d", counter, MEMSIZE);
        testExpected();

        clock();
        counter++;
        clock();
    end

    $finish;
end

task clock();
    #(CLK_PERIOD/2); 
    i_new_clk=~i_new_clk;
endtask

always_comb begin 
    index = (counter[LOGIC_SIZE-1:0] - NUM_FFS);
    if(counter < NUM_FFS) begin
        data_sel = 0;
    end
    else begin
        data_sel = mem[index[MEMSIZE_BITS-1:0]];
    end
end

task testExpected();
    $display(">> counter=%0d, index=%0d, mem[%0d]=%0h -> data_sel=%0h", counter, index, index[MEMSIZE_BITS-1:0], mem[index[MEMSIZE_BITS-1:0]], data_sel);

    assert(o_output_data == data_sel) else $error("Failed to have valid output data from input data. Got %d but expected %d", o_output_data, data_sel);
    
endtask

endmodule