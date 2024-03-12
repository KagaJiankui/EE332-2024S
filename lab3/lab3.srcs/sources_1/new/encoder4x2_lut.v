`timescale 1ns / 10ps
module encoder4x2_lut (
    input wire [3:0] in,
    output wire [1:0] out,
    output wire v
);
  reg [1:0] lut[0:15];
  initial begin
    lut[4'h0] = 2'bxx;
    lut[4'h1] = 2'b00;
    lut[4'h2] = 2'b01;
    lut[4'h3] = 2'b01;
    lut[4'h4] = 2'b10;
    lut[4'h5] = 2'b10;
    lut[4'h6] = 2'b10;
    lut[4'h7] = 2'b10;
    lut[4'h8] = 2'b11;
    lut[4'h9] = 2'b11;
    lut[4'ha] = 2'b11;
    lut[4'hb] = 2'b11;
    lut[4'hc] = 2'b11;
    lut[4'hd] = 2'b11;
    lut[4'he] = 2'b11;
    lut[4'hf] = 2'b11;
  end


  assign out = lut[in];
  assign v   = (in != 4'h0) ? 1'b1 : 1'b0;

endmodule
