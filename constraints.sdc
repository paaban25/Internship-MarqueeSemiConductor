create_clock -name rdclk -period 60 [get_ports rdclk]
create_clock -name wrclk -period 45 [get_ports wrclk]

set_clock_uncertainty -setup 0.2 [get_clocks wrclk]
set_clock_uncertainty -hold 0.1 [get_clocks wrclk]
set_clock_uncertainty -setup 0.2 [get_clocks rdclk]
set_clock_uncertainty -hold 0.1 [get_clocks rdclk]

set_input_delay -clock wrclk 2.0 [get_ports {wr_en wrst_n data_in}]
set_input_delay -clock rdclk 2.0 [get_ports {rd_en rrst_n}]

set_output_delay -clock wrclk 2.0 [get_ports data_out]
set_output_delay -clock wrclk 2.0 [get_ports fifo_full]
set_output_delay -clock rdclk 2.0 [get_ports fifo_empty]

set_maximum_delay 15.0 -from [get_ports data_in] -to [get_ports data_out]
set_minimum_delay 5.0 -from [get_ports data_in] -to [get_ports data_out]

set_false_path -from [get_ports rdclk] -to [get_ports wrclk]
set_false_path -from [get_ports wrclk] -to [get_ports rdclk]

set_input_transistion_time 0.2 [get_ports rd_en]
set_input_transistion_time 0.3 [get_ports wr_en]
set_input_transistion_time 0.25 [get_ports rrst_n]
set_input_transistion_time 0.18 [get get_ports wrst_n]
set_input_transistion_time 0.24 [get_ports data_in]


set_output_transistion_time 0.12 [get_ports data_out]
set_output_transistion_time 0.32 [get_ports fifo_full]
set_output_transistion_time 0.23 [get_ports fifo_empty]

set_max_area 1000

set_max_dynamic_power 10.0 -cell [get_cells *]
set_max_leakage_power 5.0 -cell [get_cells *]

set_load 1.0 [get_ports wr_en]
set_load 1.0 [get_ports rd_en]
set_load 1.0 [get_ports data_in]