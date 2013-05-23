`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "isa.h"

`timescale 1ns/1ps

module yutorina_controller(
  input wire clock, input wire reset,
  output reg register_write_enable_);
  // 色々初期化
  always @(posedge clock or `YUTORINA_RESET_EDGE reset) begin
    if (reset == `YUTORINA_RESET_ENABLE) begin
      //register_write_enable_ <= #1 `YUTORINA_DISABLE_;
    end
  end
endmodule
