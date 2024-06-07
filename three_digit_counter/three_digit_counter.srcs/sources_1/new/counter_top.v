`timescale 1ns / 1ns
module counter_top (
    main_clock,
    reset,
    load_comm,
    load_data,
    direction,
    led_out1,
    led_out2,
    led_out3
);
  input main_clock;
  input reset, load_comm;
  input direction;
  input [11:0] load_data;
  output wire [6:0] led_out1, led_out2, led_out3;

  wire [3:0] data_1, data_2, data_3;
  wire div;
  wire [2:0] cout;

  divider #(.MAIN_FREQ(32'd50)) Div_mainclock
   (
      .clk(main_clock),
      .div(div)
  );

  decimal_counter ctr1 (
      .clk(main_clock),
      .en(div),
      .reset(reset),
      .direction(direction),
      .load(load_comm),
      .data_load(load_data[3:0]),
      .carr_in(1'd0),
      .carr_out(cout[0]),
      .count(data_1)
  );

  decimal_counter ctr2 (
      .clk(main_clock),
      .en(div),
      .reset(reset),
      .direction(direction),
      .load(load_comm),
      .data_load(load_data[7:4]),
      .carr_in(cout[0]),
      .carr_out(cout[1]),
      .count(data_2)
  );

  decimal_counter ctr3 (
      .clk(main_clock),
      .en(div),
      .reset(reset),
      .direction(direction),
      .load(load_comm),
      .data_load(load_data[11:8]),
      .carr_in(cout[1]),
      .carr_out(cout[2]),
      .count(data_3)
  );

  led_decoder led1 (
    .data (data_1),
    .led_wire (led_out1)
  );

  led_decoder led2 (
    .data (data_2),
    .led_wire (led_out2)
  );
  led_decoder led3 (
    .data (data_3),
    .led_wire (led_out3)
  );

endmodule
