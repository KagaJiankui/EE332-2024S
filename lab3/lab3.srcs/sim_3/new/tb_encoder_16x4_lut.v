`timescale 1us / 10ns
/*
 Company:
 Engineer:

 Create Date: 03/19/2024 04:49:04 PM
 Design Name:
 Module Name: tb_encoder_16to4
 Project Name:
 Target Devices:
 Tool Versions:
 Description:

 Dependencies:

 Revision:
 Revision 0.01 - File Created
 Additional Comments:
*/



module tb_encoder_16x4_lut;
  reg [15:0] data;
  reg [15:0] mask;
  reg [15:0] test_rand;
  reg [15:0] incr;
  wire [3:0] result_cas, result_lut;
  wire v_cas, v_lut;
  reg clock;
  parameter reg [32:0] powerupDelay = 30;

  encoder16x4_cas encoder (
      .clk(clock),
      .in (data),
      .out(result_cas),
      .v  (v_cas)
  );

  encoder16x4_lut encoder_lut (
      .clk(clock),
      .in (data),
      .out(result_lut),
      .v  (v_lut)
  );

  initial begin
    clock = 1'b0;
    data = 16'h0000;
    incr = 16'h0001;
    mask = 16'h0000;
    test_rand = {$urandom} & 16'hFFFF;
    #powerupDelay;  // register initialization on powerUp
    forever begin
      #5;
      clock = ~clock;
    end
  end

  always @(posedge clock) begin
    #2;
    if (mask == 16'hffff) begin
      incr = 16'h0001;
      mask = 16'h0000;
    end
    incr = incr << 1;
    test_rand = {$urandom} & 16'hFFFF;
    mask = incr - 16'h0001;
    data = test_rand & mask;
  end

endmodule
