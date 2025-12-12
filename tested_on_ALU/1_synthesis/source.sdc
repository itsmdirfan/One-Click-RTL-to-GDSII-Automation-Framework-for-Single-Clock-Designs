# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Fri Dec 12 15:59:46 IST 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design source

create_clock -name "clk" -period 5.0 -waveform {0.0 2.5} [get_ports clk]
set_clock_transition 0.1 [get_clocks clk]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports rst_n]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {A[7]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {A[6]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {A[5]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {A[4]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {A[3]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {A[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {A[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {A[0]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {B[7]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {B[6]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {B[5]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {B[4]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {B[3]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {B[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {B[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {B[0]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {op[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {op[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {op[0]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[7]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[6]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[5]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[4]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[3]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[2]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[1]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[0]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports carry]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports zero]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports sign]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports overflow]
set_wire_load_mode "enclosed"
set_dont_use true [get_lib_cells tsl18fs120_scl_ss/slbhb2]
set_dont_use true [get_lib_cells tsl18fs120_scl_ss/slbhb1]
set_dont_use true [get_lib_cells tsl18fs120_scl_ss/slbhb4]
