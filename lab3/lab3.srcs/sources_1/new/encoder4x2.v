`timescale 1ns / 10ps

module encoder4x2 (
    input wire [3:0] in,
    output reg [1:0] out,
    output reg v
);

  always @(in) begin
    v = in[3] | in[2] | in[1] | in[0];
    out[0] = v ? (in[3] | (~in[2] & in[1])) : 1'bz;
    out[1] = v ? (in[3] | (~in[3] & in[2])) : 1'bz;
  end

endmodule
