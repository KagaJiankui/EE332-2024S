`timescale 1ns / 10ps
module encoder4x2_cas (
    input wire [3:0] in,
    output reg [1:0] out,
    output reg v
);

  always @(in) begin
    v = in[3] | in[2] | in[1] | in[0];
    if (in[3]) begin
      out = 2'b11;
    end else if (in[2]) begin
      out = 2'b10;
    end else if (in[1]) begin
      out = 2'b01;
    end else if (in[0]) begin
      out = 2'b00;
    end else begin
      out = 2'b00;
    end
  end

endmodule
