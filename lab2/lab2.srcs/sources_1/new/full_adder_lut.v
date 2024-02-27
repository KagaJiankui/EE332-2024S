`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SUSTech-EE332
// Engineer: pachina
//
// Create Date: 02/27/2024 02:53:02 AM
// Design Name: Full Adder using Gate-level RTL
// Module Name: full_adder_g
// Project Name:
// Target Devices: XC7A100T-1CSG324C
// Tool Versions:
// Description:
// Full adder using gate-level RTL simulation.
// $$ FA:{c_0,a,b}|->{c_1,s} $$
// $$ c_1=AB+BC+CA$$
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module full_adder_lut (
  input  wire [2:0] in_1,
  output wire [1:0] out_1
);

  assign out_1 = in_1[2] + in_1[1] + in_1[0];

endmodule
