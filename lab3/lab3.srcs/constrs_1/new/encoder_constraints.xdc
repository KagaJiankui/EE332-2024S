create_clock -period 100.000 -name clk -waveform {0.000 50.000} [get_ports clk]



set_input_delay -clock [get_clocks clk] -min -add_delay 2.300 [get_ports {in[*]}]
set_input_delay -clock [get_clocks clk] -max -add_delay 5.000 [get_ports {in[*]}]
set_output_delay -clock [get_clocks clk] -min -add_delay -0.050 [get_ports {out[*]}]
set_output_delay -clock [get_clocks clk] -max -add_delay 2.300 [get_ports {out[*]}]
set_output_delay -clock [get_clocks clk] -min -add_delay -0.050 [get_ports v]
set_output_delay -clock [get_clocks clk] -max -add_delay 2.300 [get_ports v]
