puts "\[INFO\]: Creating Clocks"

create_clock [get_ports tx_clk] -name tx_clk -period 11
set_propagated_clock tx_clk
create_clock [get_ports rx_clk] -name rx_clk -period 11
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

# Set the minimum period as the smaller of the two async clock domain periods.
# For now it's just the slower tx_frequency. This is the one in the AXIS side of the clock domain.
set min_tx_period      [expr {${tx_period}}]
set min_rx_period      [expr {${rx_period}}]

# Replace the '1' with NUM_FFS - 1 if that ever changes...
set_max_delay -from [get_pins RXFIFO.ReadToWrite.imm\[0\]*df*/CLK] -to [get_pins RXFIFO.ReadToWrite.imm\[1\]*df*/D] $min_rx_period
set_max_delay -from [get_pins RXFIFO.WriteToRead.imm\[0\]*df*/CLK] -to [get_pins RXFIFO.WriteToRead.imm\[1\]*df*/D] $min_rx_period
set_max_delay -from [get_pins TXFIFO.ReadToWrite.imm\[0\]*df*/CLK] -to [get_pins TXFIFO.ReadToWrite.imm\[1\]*df*/D] $min_tx_period
set_max_delay -from [get_pins TXFIFO.WriteToRead.imm\[0\]*df*/CLK] -to [get_pins TXFIFO.WriteToRead.imm\[1\]*df*/D] $min_tx_period
