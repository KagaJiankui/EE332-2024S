`timescale 1ns / 10ps
module encoder4x2 (
    input wire [3:0] in,
    output reg [1:0] out,
    output reg v
);

  wire enc0, enc1, v0, v1;

  encoder2x1 ec0 (
      .in (in[3:2]),
      .out(enc0),
      .v  (v0)
  );
  encoder2x1 ec1 (
      .in (in[1:0]),
      .out(enc1),
      .v  (v1)
  );

  always @(in) begin
    v = v0 | v1;
    out[1] = v ? v0 : 1'bx;
    out[0] = v ? (v0 ? enc0 : enc1) : 1'bx;
  end

endmodule
