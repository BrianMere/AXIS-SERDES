module tb_top_axi_serdes;

`ifdef USE_POWER_PINS
    wire VPWR;
    wire VGND;
    assign VPWR=1;
    assign VGND=0;
`endif

// Make sure to call finish so test exits
always begin
    $finish();
end

endmodule