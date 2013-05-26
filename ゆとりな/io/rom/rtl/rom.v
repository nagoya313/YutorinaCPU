`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "rom.h"

`timescale 1ns/1ps

module yutorina_rom(
  input wire clk, input wire rst, input wire cs_, input wire as_,
  input wire [`RomAddrBus] addr,
  output wire [`WordDataBus] rd_data, output reg rdy_);
  // XlinxのFPGAのROM
  x_s3e_sprom x_s3e_sprom(.clka (clk), .addra(addr), .douta(rd_data));
  // レディ生成
  always @(posedge clk or `RESET_EDGE rst) begin
    if (rst == `RESET_ENABLE) begin
      rdy_ <= #1 `DISABLE_;
    end else begin
      if (cs_ == `ENABLE_ && 
          as_ == `ENABLE_) begin
        rdy_ <= #1 `ENABLE_;
      end else begin
        rdy_ <= #1 `DISABLE_;
      end
    end
  end
endmodule
