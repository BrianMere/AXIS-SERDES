module clock_recovery #(parameter int N_PHASE=5) (
    input ref_clk,
    input [N_PHASE-1:0] clk_phase,
    input rst_n,
    input data_in,
    output data_out
);
    localparam int SelWidth = $clog2(N_PHASE);
    localparam int HalfNPhase = N_PHASE / 2;

    logic [SelWidth-1:0] data_sel;
    logic [N_PHASE-1:0]         sync_data;
    logic [N_PHASE-1:0]         trans_detect;

    // synchronizers to take the data in
    logic sample_ffs [N_PHASE];

    genvar i;
    generate
        // CREDIT: Francisco Keenan Wilken
        for (i = 0; i < N_PHASE; i++) begin: gen_sync_loop
            logic sample_ff;
            always_ff @(posedge clk_phase[i]) begin
                sample_ff <= data_in;
            end
            assign sample_ffs[i] = sample_ff;
        end
    endgenerate

    always_ff @(posedge ref_clk) begin
        for (int i = 0; i < N_PHASE; i++) begin
            sync_data[i] <= sample_ffs[i];
        end
    end

    // XOR outputs to find the bit transitions
    assign trans_detect[N_PHASE-2:0] = sync_data[N_PHASE-2:0] ^ sync_data[N_PHASE-1:1];
    assign trans_detect[N_PHASE-1] = sync_data[0] ^ sync_data[N_PHASE-1];

    logic priority_valid;
    logic [SelWidth-1:0] priority_out;

    // priority encoder to select which bit transition to use
    priority_encoder #(.WIDTH(N_PHASE)) prio_i (
        .in(trans_detect),
        .out(priority_out),
        .valid(priority_valid)
    );

    // latch the output
    always_ff @(posedge ref_clk) begin
        if (!rst_n) begin
            data_sel <= 0;
        end else if (priority_valid) begin
            data_sel <= priority_out;
        end
    end


    assign data_out = sync_data[data_sel + HalfNPhase[SelWidth-1:0]];

endmodule
