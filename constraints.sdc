puts "\[INFO\]: Creating Clocks"

create_clock [get_ports tx_clk] -name tx_clk -period 15
set_propagated_clock tx_clk
create_clock [get_ports rx_clk] -name rx_clk -period 15
set_propagated_clock rx_clk

set tx_period [get_property -object_type clock [get_clocks {tx_clk}] period]
set rx_period [get_property -object_type clock [get_clocks {rx_clk}] period]

set_clock_groups -asynchronous -group [get_clocks {tx_clk rx_clk}]

set clk_phase_period [expr {max(${tx_period}, ${rx_period}) * 5}]
create_clock [get_ports clk_phase[0]] -name clk_phase[0] -period ${clk_phase_period}
set_propagated_clock clk_phase[0]
create_clock [get_ports clk_phase[1]] -name clk_phase[1] -period ${clk_phase_period}
set_propagated_clock clk_phase[1]
create_clock [get_ports clk_phase[2]] -name clk_phase[2] -period ${clk_phase_period}
set_propagated_clock clk_phase[2]
create_clock [get_ports clk_phase[3]] -name clk_phase[3] -period ${clk_phase_period}
set_propagated_clock clk_phase[3]
create_clock [get_ports clk_phase[4]] -name clk_phase[4] -period ${clk_phase_period}
set_propagated_clock clk_phase[4]

set_clock_groups -asynchronous -group [get_clocks {clk_phase[0] clk_phase[1] clk_phase[2] clk_phase[3] clk_phase[4]}]

puts "\[INFO\]: Setting Max Delay"

set min_tx_period      [expr {${tx_period} / 4}]
set min_rx_period      [expr {${rx_period} / 4}]

set_max_delay -from [get_pins RXFIFO.ReadToWrite.imm[1].out*df*/CLK] -to [get_pins RXFIFO.WriteToRead.imm[1].r1*df*/D] $min_rx_period
set_max_delay -from [get_pins TXFIFO.ReadToWrite.imm[1].out*df*/CLK] -to [get_pins TXFIFO.WriteToRead.imm[1].r1*df*/D] $min_tx_period

#openlane config.yaml --flow Classic -T openroad.staprepnr 
#to not run all stages


# puts "\[INFO\]: Setting inputs to synchronous"
# # set_input_delay 0 -clock clk {a_i b_i}
# # set_output_delay 0 -clock clk {z_o}

# set_multicycle_path -setup 17 -from [get_pins Comb.a_reg*/CLK ] -to  [get_pins  multicycle_out*df*/D]
# set_multicycle_path -hold  16 -from [get_pins Comb.a_reg*/CLK ] -to  [get_pins  multicycle_out*df*/D]

# set_multicycle_path -setup 17 -from [get_pins Comb.b_reg*/CLK ] -to  [get_pins  multicycle_out*df*/D]
# set_multicycle_path -hold  16 -from [get_pins Comb.b_reg*/CLK ] -to  [get_pins  multicycle_out*df*/D]

# puts [get_pins Div.a[*]*df*/Q ]
# puts [get_pins z_o*df*/D]