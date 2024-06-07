`timescale 1ns / 1ns

module tb_led ();

  reg main_clock = 1'b0;
  integer data = 0;
  reg [11:0] led_in;
  wire [20:0] led_out;

  parameter integer MAIN_CLK = 2e4;

  led_decoder decoder1 (
      .data(led_in[3:0]),
      .led_wire(led_out[6:0])
  );

  led_decoder decoder2 (
      .data(led_in[7:4]),
      .led_wire(led_out[13:7])
  );

  led_decoder decoder3 (
      .data(led_in[11:8]),
      .led_wire(led_out[20:14])
  );

  initial begin
    led_in = 12'b0;
  end

  always begin
    #(MAIN_CLK);
    main_clock = ~main_clock;
    data = data + 1'd1;
    led_in = data;
    if (data > 12'hfff) begin
      data = 0;
    end
  end

endmodule
