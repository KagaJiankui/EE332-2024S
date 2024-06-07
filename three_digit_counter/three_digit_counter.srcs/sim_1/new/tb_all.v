`timescale 1ns / 1ns


module tb_all();

reg main_clock, rst, enable, direction, load, carr_in;
reg [11:0] data_load;
wire [20:0] count;
wire carr_out, divided_clock;
integer t_var, loop_var;

parameter integer MAIN_CLK=50;
parameter integer CTR_CLK_MULT=5;
parameter integer PULSE_WIDTH=50;
parameter integer T_DIR_INV = 16;
parameter integer T_LOAD = 48;
parameter integer T_RESET = 60;
parameter integer T_LOAD2 = 64;

divider #(
  .MAIN_FREQ (250),
  .PULSE_WIDTH (50)
  ) div_0 (
  .clk (main_clock),
  .div (divided_clock)
);

counter_top ctr_test1 (
  .main_clock (main_clock),
  .reset (rst),
  .direction (direction),
  .load_comm (load),
  .load_data (data_load),
  .led_out1 (count[6:0]),
  .led_out2 (count[13:7]),
  .led_out3 (count[20:14])
);

initial begin
  t_var=32'b0;
  loop_var=32'd0;
  main_clock=0;
  rst=1;
  #50;
  enable=1;
  rst=0;
  direction=0;
  carr_in=0;
  #10;
  load=1;
  data_load=4'h0;
  #10;
  load=0;
end

always begin
  #(MAIN_CLK/2);
  main_clock=~main_clock;
end

always @(posedge divided_clock) begin
  t_var=t_var+32'd1;
  if(t_var>=T_DIR_INV) begin
    direction=1;
  end
//  if(t_var>=T_LOAD) begin
//    direction=0;
//  end
//  if(t_var==T_LOAD) begin
//    load=1;
//    #5;
//    data_load=4'hc;
//    #5;
//    load=0;
//    data_load=4'h0;
//  end
//  if(t_var==T_RESET) begin
//    rst=1;
//    rst=0;
//  end
//  if(t_var==T_LOAD2) begin
//    direction=0;
//    load=1;
//    #5;
//    data_load=4'hc;
//    #5;
//    load=0;
//    data_load=4'h0;
//    direction=1;
//  end
  if(t_var==(T_DIR_INV+T_LOAD2)) begin
    direction=0;
  end
end

endmodule
