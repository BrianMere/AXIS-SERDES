`timescale 1ns/1ps
module priority_encoder #(parameter int WIDTH=8) (
    input [WIDTH-1:0] in,
    output logic [$clog2(WIDTH)-1:0] out,
    output logic valid
);
    always_comb begin
        out = 0;
        valid = 0;
        for (int i = WIDTH-1; i >= 0; i--) begin
            if (in[i]) begin
                out = i[$bits(out)-1:0];
                valid = 1;
            end
        end
    end

endmodule
