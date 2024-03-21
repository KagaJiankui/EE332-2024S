`timescale 1us / 1ns
/**
Company: SUSTech-EE332
Engineer: pachina

Create Date: 02/27/2024 02:53:02 AM
Design Name: Full Adder using Gate-level RTL
Module Name: full_adder_g
Project Name:
Target Devices: XC7A100T-1CSG324C
Tool Versions:
Description:
Full adder using gate-level RTL simulation.
$$ FA:{c_0,a,b}|->{c_1,s} $$
$$ c_1=AB+BC+CA$$

Dependencies:

Revision:
Revision 0.01 - File Created
Additional Comments:

*/


module full_adder_g (
    input  wire c0,
    input  wire a,
    input  wire b,
    output wire s,
    output wire c1
);

  assign s  = ((~c0) & (~a) & b) | ((~c0) & a & (~b)) | (c0 & (~a) & (~b)) | (c0 & a & b);
  assign c1 = (c0 & a) | (a & b) | (c0 & b);

endmodule
