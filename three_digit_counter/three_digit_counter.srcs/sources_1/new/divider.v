module divider (
    input  wire clk,
    output reg  div
);

  parameter integer MAIN_FREQ = 32'd50_000;
  parameter integer PULSE_WIDTH = 100;

  reg [31:0] time_count = 32'd0;

  always @(posedge clk) begin
    if (time_count == (MAIN_FREQ-PULSE_WIDTH)) begin
      div <= 1'b1;
    end else if (time_count == MAIN_FREQ) begin
      div <= 1'b0;
      time_count <= 32'd0;
    end else begin
      time_count <= time_count + 32'd1;
      div <= div;
    end
  end

endmodule
