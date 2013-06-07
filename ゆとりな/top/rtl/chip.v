`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "rom.h"

module yutorina_chip(input wire clk, input wire clk_, input wire rst);
  wire [`WordDataBus] m_r_data; 
  wire m_rdy_;
  wire cpu_i_req_;
  wire [`WordAddrBus] cpu_i_addr;
  wire cpu_i_as_;
  wire cpu_i_rw;
  wire [`WordDataBus] cpu_i_w_data;
  wire cpu_i_grnt_;
  wire cpu_d_req_;
  wire [`WordAddrBus] cpu_d_addr;
  wire cpu_d_as_;
  wire cpu_d_rw;
  wire [`WordDataBus] cpu_d_w_data;
  wire cpu_d_grnt_;
  wire dmac_req_;
  wire [`WordAddrBus] dmac_addr;
  wire dmac_as_;
  wire dmac_rw;
  wire [`WordDataBus] dmac_w_data;
  wire dmac_grnt_;
  wire null_m_req_                  = `DISABLE_;
  wire [`WordAddrBus] null_m_addr   = `NULL;
  wire null_m_as_                   = `DISABLE_;
  wire null_m_rw                    = `READ;
  wire [`WordDataBus] null_m_w_data = `ZERO;
  wire null_m_grnt_                 = `DISABLE_;
  wire [`WordAddrBus] s_addr;
  wire s_as_;
  wire s_rw;
  wire [`WordDataBus] s_w_data;
  wire rom_cs_;
  wire rom_as_;
  wire [`WordDataBus] rom_r_data;
  wire rom_rdy_;
  wire [`WordDataBus] null_s_r_data = `ZERO;
  wire null_s_rdy_                  = `DISABLE_;
  wire null_s_cs_;
  yutorina_cpu cpu(.clk (clk), .clk_ (clk_), .rst (rst),
                   .i_r_data (m_r_data), .i_rdy_ (m_rdy_),
                   .i_req_ (cpu_i_req_), .i_addr (cpu_i_addr),
                   .i_as_ (cpu_i_as_), .i_rw (cpu_i_rw),
                   .i_w_data (cpu_i_w_data), .i_grnt_ (cpu_i_grnt_),
                   .d_r_data (m_r_data), .d_rdy_ (m_rdy_),
                   .d_req_ (cpu_d_req_), .d_addr (cpu_d_addr),
                   .d_as_ (cpu_d_as_), .d_rw (cpu_d_rw),
                   .d_w_data (cpu_d_w_data), .d_grnt_ (cpu_d_grnt_));
  yutorina_bus bus(
    .clk (clk), .rst (rst),
    .m_r_data (m_r_data), .m_rdy_ (m_rdy_),
    .m0_req_ (cpu_i_req_), .m0_addr (cpu_i_addr), .m0_as_ (cpu_i_as_),
    .m0_rw (cpu_i_rw), .m0_w_data (cpu_i_w_data), .m0_grnt_ (cpu_i_grnt_),
    .m1_req_ (cpu_d_req_), .m1_addr (cpu_d_addr), .m1_as_ (cpu_d_as_),
    .m1_rw (cpu_d_rw), .m1_w_data (cpu_d_w_data), .m1_grnt_ (cpu_d_grnt_),
    .m2_req_ (dmac_req_), .m2_addr (dmac_addr), .m2_as_ (dmac_as_),
    .m2_rw (dmac_rw), .m2_w_data (dmac_w_data), .m2_grnt_ (dmac_grnt_),
    .m3_req_ (null_m_req_), .m3_addr (null_m_addr), .m3_as_ (null_m_as_),
    .m3_rw (null_m_rw), .m3_w_data (null_m_w_data), .m3_grnt_ (null_m_grnt_),
    .s_addr (s_addr), .s_as_ (s_as_), .s_rw (s_rw), .s_w_data (s_w_data),
    .s0_r_data (rom_r_data), .s0_rdy_ (rom_rdy_), .s0_cs_ (rom_cs_),
    .s1_r_data (null_s_r_data), .s1_rdy_ (null_s_rdy_), .s1_cs_ (null_s_cs_),
    .s2_r_data (null_s_r_data), .s2_rdy_ (null_s_rdy_), .s2_cs_ (null_s_cs_),
    .s3_r_data (null_s_r_data), .s3_rdy_ (null_s_rdy_), .s3_cs_ (null_s_cs_),
    .s4_r_data (null_s_r_data), .s4_rdy_ (null_s_rdy_), .s4_cs_ (null_s_cs_),
    .s5_r_data (null_s_r_data), .s5_rdy_ (null_s_rdy_), .s5_cs_ (null_s_cs_),
    .s6_r_data (null_s_r_data), .s6_rdy_ (null_s_rdy_), .s6_cs_ (null_s_cs_),
    .s7_r_data (null_s_r_data), .s7_rdy_ (null_s_rdy_), .s7_cs_ (null_s_cs_));
  yutorina_rom rom(.clk (clk), .rst (rst), .cs_ (rom_cs_), .as_ (s_as_),
                   .addr (s_addr[`RomAddrBus]),
                   .r_data (rom_r_data), .rdy_ (rom_rdy_));
endmodule
