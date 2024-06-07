`timescale 1ns / 1ns

module decimal_counter (
    input            clk,        // 时钟信号
    input            reset,      // 异步复位信号
    input            en,         // 异步使能信号
    input            direction,  // 计数方向控制信号
    input            load,       // 同步置位使能信号
    input      [3:0] data_load,  // 同步置位数据输入
    input            carr_in,    // 进位/借位输入信号
    output reg [3:0] count,      // 计数器当前值
    output reg       carr_out    // 进位/借位输出信号
);

  // 参数定义
  parameter integer MAX_COUNT = 4'd9;  // 最大计数值
  parameter integer MIN_COUNT = 4'd0;  // 最小计数值

  initial begin
    count = MIN_COUNT; // 自启动条件
    carr_out = 0;
  end

  always @(posedge clk) begin
    if (reset) begin
      count <= MIN_COUNT;
      carr_out <= 1'b0;
    end else if (load) begin
      count <= data_load;
      carr_out <= 1'b0;
    end else if (en) begin
      if (direction) begin
        count = count - carr_in;  // 借位输入
        if (count == MIN_COUNT) begin
          count <= MAX_COUNT;
          carr_out <= 1'b1;
        end else begin
          count <= count - 4'b0001;
          carr_out <= 1'b0;
        end
      end else begin
        count = count + carr_in;  // 进位输入
        if (count == MAX_COUNT) begin
          count <= MIN_COUNT;
          carr_out <= 1'b1;
        end else begin
          count <= count + 4'b0001;
          carr_out <= 1'b0;
        end
      end
    end else begin
      carr_out <= 1'b0;
    end
  end

endmodule
