/** From https://www.chipverify.com/verilog/synchronous-fifo */
`timescale 1ns / 1ps
module sync_fifo #(parameter DEPTH=8, DWIDTH=16)
(
        input               	rstn,               // Active low reset
                            	clk,                // Clock
                            	wr_en, 				// Write enable
                            	rd_en, 				// Read enable
        input      [DWIDTH-1:0] din, 				// Data written into FIFO
        output logic [DWIDTH-1:0] dout, 				// Data read from FIFO
        output logic             	empty, 				// FIFO is empty when high
        output logic full               				// FIFO is full when high
);


  logic [$clog2(DEPTH)-1:0]   wptr;
  logic [$clog2(DEPTH)-1:0]   rptr;

  logic [DWIDTH-1 : 0]    fifo [0:DEPTH-1] ;

  always_ff @ (posedge clk) begin
    if (!rstn) begin
      wptr <= 0;
      rptr <= 0;
    end else begin
      if (wr_en & !full) begin
        fifo[wptr] <= din;
        wptr <= wptr + 1;
      end
      if (rd_en & !empty) begin
        dout <= fifo[rptr];
        rptr <= rptr + 1;
      end
    end
  end

  always_comb begin 
    full  = (wptr + 1) == rptr;
    empty = wptr == rptr;
  end

endmodule