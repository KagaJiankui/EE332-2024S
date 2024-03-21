`timescale 1us / 10ns
module encoder16x4 (
    input wire clk,
    input [15:0] in,
    output reg [3:0] out,
    output reg v
);
  wire [1:0] enc1, enc2, enc3, enc4;
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

  reg [3:0] result0, result1, v_sel;

  always @(posedge clk) begin
    v_sel   <= {v4, v3, v2, v1};
    result1 <= {enc1[1], enc2[1], enc3[1], enc4[1]};
    result0 <= {enc1[0], enc2[0], enc3[0], enc4[0]};
  end

  wire [1:0] sel_output;
  wire v_from_input;

  encoder4x2 e_select (
      .in (v_sel),
      .out(sel_output),
      .v  (v_from_input)
  );

  always @(posedge clk) begin
    out[3:2] <= sel_output;
    v <= v_from_input;
    case (sel_output)
      2'b11:   out[1:0] <= {result1[0], result0[0]};
      2'b10:   out[1:0] <= {result1[1], result0[1]};
      2'b01:   out[1:0] <= {result1[2], result0[2]};
      2'b00:   out[1:0] <= {result1[3], result0[3]};
      default: out[1:0] <= 2'b00;
    endcase
  end
endmodule
