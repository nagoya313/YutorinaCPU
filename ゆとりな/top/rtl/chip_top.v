`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`timescale 1ns/1ps

module yutorina_chip_top(input wire clk_ref, input wire rst_sw);
  wire clk;
  wire clk_;
  wire chip_rst;
  // クロックジェネレータ
  yutorina_clk_gen clk_gen(.clk_ref (clk_ref), .rst_sw (rst_sw),
                           .clk (clk), .clk_ (clk_), .chip_rst (chip_rst));
  // ゆとりなちっぷ
  yutorina_chip chip(.clk (clk), .clk_ (clk_), .rst(chip_rst));
endmodule
