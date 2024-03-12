`timescale 1ns / 10ps
module encoder2x1 (
    input wire [1:0] in,
    output reg out,
    output reg v
);
  always @(in) begin
    v = in[1] | in[0];
    if (in[1]) out = 1'b1;
    else if (in[0]) out = 1'b0;
    else out = 1'bx;
  end
endmodule
