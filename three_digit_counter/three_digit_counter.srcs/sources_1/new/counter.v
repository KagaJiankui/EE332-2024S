`timescale 1ns / 1ns

module decimal_counter (
    input            clk,        // 时钟信号
    input            reset,      // 异步复位信号
    input            en,         // 异步使能信号
    input            direction,  // 计数方向控制信号
    input            load,       // 同步置位使能信号
    input      [3:0] data_load,  // 同步置位数据输入
    input            carr_in,    // 进位输入信号
    output reg [3:0] count,      // 计数器当前值
    output reg       carr_out    // 进位输出信号
);

  // 参数定义
  parameter MAX_COUNT = 9;  // 最大计数值
  parameter MIN_COUNT = 0;  // 最小计数值

  // 内部信号定义
  reg [3:0] next_count;  // 下一个状态的计数值

  // 组合逻辑部分
  always @(*) begin
    if (reset) begin
      next_count = MIN_COUNT;
      carr_out   = 0;
    end else if (load) begin
      next_count = data_load;
      carr_out   = 0;
    end else if (en) begin
      if (direction) begin
        // 减计数
        if (count == MIN_COUNT && carr_in) begin
          next_count = MAX_COUNT;
          carr_out   = 1;
        end else if (count > MIN_COUNT) begin
          next_count = count - 1;
          carr_out   = 0;
        end else begin
          next_count = count;
          carr_out   = 1;
        end
      end else begin
        // 加计数
        if (count == MAX_COUNT && carr_in) begin
          next_count = MIN_COUNT;
          carr_out   = 1;
        end else if (count < MAX_COUNT) begin
          next_count = count + 1;
          carr_out   = 0;
        end else begin
          next_count = count;
          carr_out   = 1;
        end
      end
    end else begin
      next_count = count;
      carr_out   = 0;
    end
  end

  // 时序逻辑部分
  always @(posedge clk) begin
    if (reset) begin
      count <= MIN_COUNT;
    end else begin
      count <= next_count;
    end
  end

endmodule
