# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Thu May 21 13:04:21 IST 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design alu_top

create_clock -name "clk" -period 5.0 -waveform {0.0 2.5} [get_ports clk]
set_clock_transition 0.1 [get_clocks clk]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[7]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[6]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[5]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[4]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[3]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[0]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[7]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[6]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[5]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[4]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[3]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[0]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports cin]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {opcode[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {opcode[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {opcode[0]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[7]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[6]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[5]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[4]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[3]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[2]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[1]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {result[0]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports cout]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports zero]
set_wire_load_mode "enclosed"
set_dont_use true [get_lib_cells tsl18fs120_scl_ss/slbhb2]
set_dont_use true [get_lib_cells tsl18fs120_scl_ss/slbhb1]
set_dont_use true [get_lib_cells tsl18fs120_scl_ss/slbhb4]
