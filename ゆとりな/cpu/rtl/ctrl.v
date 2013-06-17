`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "cpu.h"
`include "exp.h"

module yutorina_ctrl(input wire clk, input wire rst,
                     input wire i_busy, input wire d_busy,
                     input wire mem_en_, input wire [`ExpBus] exp_code,
                     output reg mode, output wire stall,
                     output reg flush);
  assign stall = i_busy | d_busy;
  always @(posedge clk or `RESET_EDGE rst) begin
    if (rst == `RESET_ENABLE) begin
      mode  <= #1 `MODE_KERNEL;
      flush <= #1 `DISABLE;
    end else begin
      if (mem_en_ == `ENABLE_) begin
        if (exp_code != `EXP_NONE) begin
          $display("Exception!(code=%x)", exp_code);
          flush <= #1 `ENABLE;
        end else begin
          flush <= #1 `DISABLE;
        end
      end
    end
  end
endmodule
