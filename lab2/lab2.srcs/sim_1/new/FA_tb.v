`timescale 1ns / 10ps
/**
Company:
Engineer:

Create Date: 02/27/2024 02:53:28 AM
Design Name:
Module Name: FA_tb
Project Name:
Target Devices:
Tool Versions:
Description:

Dependencies:

Revision:
Revision 0.01 - File Created
Additional Comments:

*/


module FA_tb;

  reg  [2:0] data;
  wire [1:0] out_g;
  wire [1:0] out_lut;

  full_adder_g fag (
      .c0(data[0]),
      .a (data[1]),
      .b (data[2]),
      .s (out_g[0]),
      .c1(out_g[1])
  );

  full_adder_lut fa_lut (
      .in_1 (data),
      .out_1(out_lut)
  );

  initial begin
    data=3'b000;
  end

  always begin
    #5;
    if(data>7) data=0;
    data=data+1;
  end

endmodule
