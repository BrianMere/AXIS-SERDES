`timescale 1ns/1ps
module tb_clock_recovery();

`ifdef USE_POWER_PINS
    wire VPWR;
    wire VGND;
    assign VPWR=1;
    assign VGND=0;
`endif

    localparam int NumPhase = 5;
    localparam byte Payload = 8'hAA;

    logic [NumPhase-1:0] clk_phase;
    logic data_in, data_out;
    logic ref_clk, rst_n;

    assign ref_clk = clk_phase[0];

    genvar i;
    generate
        for (i = 0; i < NumPhase; i++) begin: gen_clks
            always begin
                clk_phase[i] = 0;
                #i;
                while (1) begin
                    #(NumPhase/2.0) clk_phase[i] = ~clk_phase[i];
                end
            end
        end

    endgenerate

    clock_recovery DUT (.*);

    always begin
        $dumpfile("tb_clock_recovery.vcd");
        $dumpvars(0);
        data_in = 0;
        rst_n = 0;
        #10;
        rst_n = 1;
        for (int i = 0; i < $bits(Payload); i++) begin
            data_in <= Payload[i];
            #NumPhase;
        end

        #(NumPhase * 2);
        $finish();
    end



endmodule
