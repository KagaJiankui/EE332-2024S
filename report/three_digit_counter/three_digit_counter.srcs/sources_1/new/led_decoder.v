`timescale 1ns / 1ns

module led_decoder (
    kill_zero,
    flag_zero,
    data,
    led_wire
);

  input kill_zero;
  input [3:0] data;
  output reg [6:0] led_wire;
  output reg flag_zero;

  always @(*) begin
    flag_zero = data == 0;
    if (flag_zero && kill_zero) begin
      led_wire = 7'b0;
    end else begin
      case (data)
        4'h0: begin
          led_wire = 7'h01;
        end
        4'h1: begin
          led_wire = 7'h4f;
        end
        4'h2: begin
          led_wire = 7'h12;
        end
        4'h3: begin
          led_wire = 7'h06;
        end
        4'h4: begin
          led_wire = 7'h4c;
        end
        4'h5: begin
          led_wire = 7'h24;
        end
        4'h6: begin
          led_wire = 7'h20;
        end
        4'h7: begin
          led_wire = 7'h0f;
        end
        4'h8: begin
          led_wire = 7'h00;
        end
        4'h9: begin
          led_wire = 7'h04;
        end
        4'ha: begin
          led_wire = 7'h08;
        end
        4'hb: begin
          led_wire = 7'h60;
        end
        4'hc: begin
          led_wire = 7'h31;
        end
        4'hd: begin
          led_wire = 7'h42;
        end
        4'he: begin
          led_wire = 7'h30;
        end
        4'hf: begin
          led_wire = 7'h38;
        end
        default: begin
          led_wire = 7'h7e;
        end
      endcase
    end
  end



endmodule
