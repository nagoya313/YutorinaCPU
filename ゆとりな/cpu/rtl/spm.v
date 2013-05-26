`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "spm.h"

`timescale 1ns/1ps

module yutorina_spm(
  input wire clk,
  input wire [`SpmAddrBus] i_addr, input wire i_as_,
  output wire [`WordDataBus] i_rd_data,
  input wire [`SpmAddrBus] d_addr, input wire d_as_, input wire d_rw,
  input wire [`WordDataBus] d_wr_data, output wire [`WordDataBus] d_rd_data);
  wire we_a;
  wire we_b;
  // 命令ポートは常に書込み不可
  // 入力は取敢ずデータのを流しておく
  assign we_a = `DISABLE;
  assign we_b = (d_as_ == `ENABLE_) && (d_rw == `WRITE) ? `ENABLE : `DISABLE;
  // ザイリンクスのでゆあるぽーとめもり
  x_s3e_dpram x_s3e_dpram(.clka (clk), .addra (i_addr), .dina (d_wr_data),
                          .wea (we_a), .douta (i_rd_data),
                          .clkb (clk), .addrb (d_addr), .dinb (d_wr_data),
                          .web (we_b), .doutb (d_rd_data));
endmodule
