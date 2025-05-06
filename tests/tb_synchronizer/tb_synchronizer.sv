module tb_synchronizer;

localparam LOGIC_SIZE = 9; // can test only up to 32 bits
localparam NUM_FFS    = 4;

parameter MAX_VAL = (1 << LOGIC_SIZE) - 1;

reg [MEMSIZE_BITS:0] counter = 0;

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
bit [LOGIC_SIZE-1:0] mem[0:MEMSIZE];
initial begin 
    foreach (mem[i]) begin 
        mem[i] = $urandom_range(0, MAX_VAL)[LOGIC_SIZE-1:0] ; // implicit cast here...
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

    i_reset_n = 0; // active low
    i_input_data = 0;
    i_new_clk = 0;

    clock();
    clock();

    assert(o_output_data == 0) else $error("Failed reset test on synchronization module.");
    while (counter != MEMSIZE) begin
        $display("Testing %d out of %d", counter, MEMSIZE);
        testExpected();

        clock(1);
        clock();
    end

    $finish;
end

task clock(bit increase_counter=0);
    if(increase_counter) counter++;
    #(CLK_PERIOD/2); 
    i_new_clk=~i_new_clk;
endtask

task testExpected();
    if(counter < NUM_FFS) begin
        assert(o_output_data == 0);
    end
    else begin
        logic[MEMSIZE_BITS:0] index = counter - NUM_FFS;
        assert(o_output_data == mem[index]);
    end
    
endtask

endmodule