`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "bus.h"

module yutorina_bus_slave_mux(
  input wire s0_cs_, input wire [`WordDataBus] s0_r_data, input wire s0_rdy_,
  input wire s1_cs_, input wire [`WordDataBus] s1_r_data, input wire s1_rdy_,
  input wire s2_cs_, input wire [`WordDataBus] s2_r_data, input wire s2_rdy_,
  input wire s3_cs_, input wire [`WordDataBus] s3_r_data, input wire s3_rdy_,
  input wire s4_cs_, input wire [`WordDataBus] s4_r_data, input wire s4_rdy_,
  input wire s5_cs_, input wire [`WordDataBus] s5_r_data, input wire s5_rdy_,
  input wire s6_cs_, input wire [`WordDataBus] s6_r_data, input wire s6_rdy_,
  input wire s7_cs_, input wire [`WordDataBus] s7_r_data, input wire s7_rdy_,
  output wire [`WordDataBus] m_r_data, output wire m_rdy_);
  assign m_r_data = s0_cs_ == `ENABLE_ ? s0_r_data :
                    s1_cs_ == `ENABLE_ ? s1_r_data :
                    s2_cs_ == `ENABLE_ ? s2_r_data :
                    s3_cs_ == `ENABLE_ ? s3_r_data :
                    s4_cs_ == `ENABLE_ ? s4_r_data :
                    s5_cs_ == `ENABLE_ ? s5_r_data :
                    s6_cs_ == `ENABLE_ ? s6_r_data :
                    s7_cs_ == `ENABLE_ ? s7_r_data :
                    `ZERO;
  assign m_rdy_ = s0_cs_ == `ENABLE_ ? s0_rdy_ :
                  s1_cs_ == `ENABLE_ ? s1_rdy_ :
                  s2_cs_ == `ENABLE_ ? s2_rdy_ :
                  s3_cs_ == `ENABLE_ ? s3_rdy_ :
                  s4_cs_ == `ENABLE_ ? s4_rdy_ :
                  s5_cs_ == `ENABLE_ ? s5_rdy_ :
                  s6_cs_ == `ENABLE_ ? s6_rdy_ :
                  s7_cs_ == `ENABLE_ ? s7_rdy_ :
                  `DISABLE_;
endmodule
