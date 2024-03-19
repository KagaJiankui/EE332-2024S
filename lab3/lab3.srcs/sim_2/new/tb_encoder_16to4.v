`timescale 1ns / 10ps
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



module tb_encoder_16to4;
  reg [15:0] data;
  reg [15:0] mask;
  reg [15:0] test_rand;
  reg [15:0] incr;
  wire [3:0] result;
  wire v;
  reg clock;

  encoder16x4 encoder (
      .clk(clock),
      .in (data),
      .out(result),
      .v  (v)
  );

  initial begin
    clock = 1'b0;
    data = 16'h0000;
    incr = 16'h0001;
    mask = 16'h0000;
    test_rand = {$urandom} & 16'hFFFF;
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
