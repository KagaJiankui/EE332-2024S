`timescale 1ns / 10ps
module encoder16x4 (
    input wire clk,
    input [15:0] in,
    output reg [3:0] out
);
  wire [3:0] enc1, enc2, enc3, enc4;
  wire v1, v2, v3, v4;

  encoder4x2 e1 (
      .in (in[3:0]),
      .out(enc1),
      .v  (v1)
  );
  encoder4x2 e2 (
      .in (in[7:4]),
      .out(enc2),
      .v  (v2)
  );
  encoder4x2 e3 (
      .in (in[11:8]),
      .out(enc3),
      .v  (v3)
  );
  encoder4x2 e4 (
      .in (in[15:12]),
      .out(enc4),
      .v  (v4)
  );

  reg [1:0] out1, out2;
  reg v1_reg, v2_reg;

  always @(posedge clk) begin
    out1   <= v1 ? enc1 : enc2;
    v1_reg <= v1;
    v2_reg <= v2;
  end

  always @(posedge clk) begin
    out2 <= v1_reg ? out1 : enc3;
    out[1:0] <= v2_reg ? out2 : enc4;
    out[3:2] <= v1_reg ? 2'b00 : (v2_reg ? 2'b01 : 2'b10);
  end
endmodule
