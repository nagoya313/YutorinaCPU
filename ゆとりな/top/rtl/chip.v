`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`timescale 1ns/1ps

module yutorina_chip(input wire clk, input wire clk_, input wire rst);
  // 信号達
  // マスタ
  wire [`WordDataBus] m_rd_data; 
  wire m_rdy_;
  // マスタ0はCPU樣
  wire cpu_req_;
  wire [`WordAddrBus] cpu_addr;
  wire cpu_as_;
  wire cpu_rw;
  wire [`WordDataBus] cpu_wr_data;
  wire cpu_grnt_;
  // マスタ1は多分DMA
  wire dmac_req_;
  wire [`WordAddrBus] dmac_addr;
  wire dmac_as_;
  wire dmac_rw;
  wire [`WordDataBus] dmac_wr_data;
  wire dmac_grnt_;
  // 奴隷
  wire [`WordAddrBus] s_addr;
  wire s_as_;
  wire s_rw;
  wire [`WordDataBus] s_wr_data;
  // 奴隷0はROM
  wire rom_cs_;
  wire rom_as_;
  wire [`RomAddrBus] rom_addr;
  wire [`WordDataBus] rom_rd_data;
  wire rom_rdy_;
  // ゆとつたCPU
  yutorina_cpu cpu(.clk (clk), .clk_ (clk_), .rst (rst),
                   .bus_rd_data (m_rd_data), .bus_rdy_ (m_rdy_),
                   .bus_req_ (cpu_req_), .bus_addr (cpu_addr),
                   .bus_as_ (cpu_as_), .bus_rw (cpu_rw),
                   .bus_wr_data (cpu_wr_data), .bus_grnt_ (cpu_grnt_));
  // ゆとつたバス
  yutorina_bus bus(.clk (clk), .rst (rst),
                   .m_rd_data (m_rd_data), 
                   .m_rdy_ (m_rdy_),
                   .m0_req_ (cpu_req_), .m0_addr (cpu_addr),
                   .m0_as_ (cpu_as_), .m0_rw (cpu_rw),
                   .m0_wr_data (cpu_wr_data), .m0_grnt_ (cpu_grnt_),
                   .m1_req_ (dmac_req_), .m1_addr (dmac_addr),
                   .m1_as_ (dmac_as_), .m1_rw (dmac_rw),
                   .m1_wr_data (dmac_wr_data), .m1_grnt_ (dmac_grnt_),
                   .s_addr (s_addr), .s_as_ (s_as_), .s_rw (s_rw),
                   .s_wr_data (s_wr_data),
                   .s0_rd_data (rom_rd_data), .s0_rdy_ (rom_rdy_), 
                   .s0_cs_ (rom_cs_));
  // 奴隷さん
  // ROM
  yutorina_rom rom(.clk (clk), .rst (rst),
                   .addr (rom_addr), .rd_data (rom_rd_data), .rdy_ (rom_rdy_));
endmodule
