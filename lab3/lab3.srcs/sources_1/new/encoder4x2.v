`timescale 1ns / 10ps

module encoder4x2 (
    input wire [3:0] in,
    output reg [1:0] out,
    output reg v
);

  // assign v = in[3] | in[2] | in[1] | in[0];
  // assign out[0] = v ? (in[3] | (~in[2] & in[1])) : 1'bz;
  // assign out[1] = v ? (in[3] | (~in[3] & in[2])) : 1'bz;
always @(in) begin
  if (in!=4'b0000) begin
    v=1'b1;
    out[0] = in[3] | (~in[2] & in[1]);
    out[1] = in[3] | (~in[3] & in[2]);
  end
  else begin
    v=1'b0;
    out=2'b00;
  end
end

endmodule
