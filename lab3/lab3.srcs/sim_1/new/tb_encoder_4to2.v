`timescale 1us / 10ns
/**
 Company:
 Engineer:

 Create Date: 03/12/2024 07:24:48 PM
 Design Name:
 Module Name: tb_4x2
 Project Name:
 Target Devices:
 Tool Versions:
 Description:

 Dependencies:

 Revision:
 Revision 0.01 - File Created
 Additional Comments:
*/

/* verilator lint_off UNOPTFLAT */

module tb_encoder_4to2;
reg [3:0] data;
wire [1:0] result1;
wire [1:0] result2;
wire [1:0] result3;
wire v;

encoder4x2_cas enc_cas(
  .in(data),
  .out(result1),
  .v(v)
);

encoder4x2_lut enc_lut(
  .in(data),
  .out(result2),
  .v(v)
);

encoder4x2 enc_tree(
  .in(data),
  .out(result3),
  .v(v)
);

initial begin
  data=4'b0000;
end

always begin
  #5;
  if (data>15) begin
    data=0;
  end
  data=data+1;
end

endmodule
