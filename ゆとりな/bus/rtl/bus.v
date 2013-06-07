`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "bus.h"

module yutorina_bus(
  input wire clk, input wire rst,
  output wire [`WordDataBus] m_r_data, output wire m_rdy_,
  input wire m0_req_, input wire [`WordAddrBus] m0_addr,
  input wire m0_as_, input wire m0_rw,
  input wire [`WordDataBus] m0_w_data, output wire m0_grnt_,
  input wire m1_req_, input wire [`WordAddrBus] m1_addr,
  input wire m1_as_, input wire m1_rw,
  input wire [`WordDataBus] m1_w_data, output wire m1_grnt_,
  input wire m2_req_, input wire [`WordAddrBus] m2_addr,
  input wire m2_as_, input wire m2_rw,
  input wire [`WordDataBus] m2_w_data, output wire m2_grnt_,
  input wire m3_req_, input wire [`WordAddrBus] m3_addr,
  input wire m3_as_, input wire m3_rw,
  input wire [`WordDataBus] m3_w_data, output wire m3_grnt_,
  output wire [`WordAddrBus] s_addr, output wire s_as_,
  output wire s_rw, output wire [`WordDataBus] s_w_data,
  input wire [`WordDataBus] s0_r_data, input wire s0_rdy_, output wire s0_cs_,
  input wire [`WordDataBus] s1_r_data, input wire s1_rdy_, output wire s1_cs_,
  input wire [`WordDataBus] s2_r_data, input wire s2_rdy_, output wire s2_cs_,
  input wire [`WordDataBus] s3_r_data, input wire s3_rdy_, output wire s3_cs_,
  input wire [`WordDataBus] s4_r_data, input wire s4_rdy_, output wire s4_cs_,
  input wire [`WordDataBus] s5_r_data, input wire s5_rdy_, output wire s5_cs_,
  input wire [`WordDataBus] s6_r_data, input wire s6_rdy_, output wire s6_cs_,
  input wire [`WordDataBus] s7_r_data, input wire s7_rdy_, output wire s7_cs_);
  yutorina_bus_arbiter bus_arbiter(.clk (clk), .rst (rst),
                                   .m0_req_ (m0_req_), .m0_grnt_ (m0_grnt_),
                                   .m1_req_ (m1_req_), .m1_grnt_ (m1_grnt_),
                                   .m2_req_ (m2_req_), .m2_grnt_ (m2_grnt_),
                                   .m3_req_ (m3_req_), .m3_grnt_ (m3_grnt_));
  yutorina_bus_master_mux bus_master_mux(
    .m0_addr (m0_addr), .m0_as_ (m0_as_), .m0_rw (m0_rw),
    .m0_w_data (m0_w_data), .m0_grnt_ (m0_grnt_),
    .m1_addr (m1_addr), .m1_as_ (m1_as_), .m1_rw (m1_rw),
    .m1_w_data (m1_w_data), .m1_grnt_ (m1_grnt_),
    .m2_addr (m2_addr), .m2_as_ (m2_as_), .m2_rw (m2_rw),
    .m2_w_data (m2_w_data), .m2_grnt_ (m2_grnt_),
    .m3_addr (m3_addr), .m3_as_ (m3_as_), .m3_rw (m3_rw),
    .m3_w_data (m3_w_data), .m3_grnt_ (m3_grnt_),
    .s_addr (s_addr), .s_as_ (s_as_), .s_rw (s_rw), .s_w_data (s_w_data));
  yutorina_bus_addr_dec bus_addr_dec(
    .s_addr (s_addr),
    .s0_cs_ (s0_cs_), .s1_cs_ (s1_cs_), .s2_cs_ (s2_cs_), .s3_cs_ (s3_cs_),
    .s4_cs_ (s4_cs_), .s5_cs_ (s5_cs_), .s6_cs_ (s6_cs_), .s7_cs_ (s7_cs_));
  yutorina_bus_slave_mux bus_slave_mux(
    .s0_cs_ (s0_cs_), .s1_cs_ (s1_cs_), .s2_cs_ (s2_cs_), .s3_cs_ (s3_cs_),
    .s4_cs_ (s4_cs_), .s5_cs_ (s5_cs_), .s6_cs_ (s6_cs_), .s7_cs_ (s7_cs_),
    .s0_r_data (s0_r_data), .s0_rdy_ (s0_rdy_),
    .s1_r_data (s1_r_data), .s1_rdy_ (s1_rdy_),
    .s2_r_data (s2_r_data), .s2_rdy_ (s2_rdy_),
    .s3_r_data (s3_r_data), .s3_rdy_ (s3_rdy_),
    .s4_r_data (s4_r_data), .s4_rdy_ (s4_rdy_),
    .s5_r_data (s5_r_data), .s5_rdy_ (s5_rdy_),
    .s6_r_data (s6_r_data), .s6_rdy_ (s6_rdy_),
    .s7_r_data (s7_r_data), .s7_rdy_ (s7_rdy_),
    .m_r_data (m_r_data), .m_rdy_(m_rdy_));
endmodule
