`timescale 1ns / 1ns


module tb_counter();

reg main_clock, load_command, rst, direction;
reg [11:0] load_data;
wire [6:0] led_segments1, led_segments2,led_segments3;
integer time_ctr, t_invert, t_load, t_rst, n_loop;

counter_top CTR(
  .main_clock (main_clock),
  .reset (rst),
  .load_comm (load_command),
  .load_data (load_data),
  .direction (direction),
  .led_out1 (led_segments1),
  .led_out2 (led_segments2),
  .led_out3 (led_segments3)
);

initial begin
  time_ctr=32'b0;
  t_invert=32'd120;
  t_load=32'd216;
  t_rst=32'd240;
  n_loop=32'd0;
  main_clock=0;
  rst=0;
  direction=0;
  #5;
  load_command=1;
  load_data=12'h000;
end

always begin
  load_command=0;
  main_clock=~main_clock;
  time_ctr=time_ctr+32'd1;
  if(time_ctr==t_invert) begin
    direction=1;
  end
  if(time_ctr==t_load) begin
    rst=1;
    load_command=1;
    load_data=12'h456;
  end
  if(time_ctr==t_rst) begin
    rst=1;
    time_ctr=0;
    n_loop=n_loop+1;
  end
  if(n_loop>300) begin
  $finish;
  end
end

endmodule
