`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "bus.h"

module yutorina_bus_master_mux(
  input wire [`WordAddrBus] m0_addr, input wire m0_as_, input wire m0_rw,
  input wire [`WordDataBus] m0_w_data, input wire m0_grnt_,
  input wire [`WordAddrBus] m1_addr, input wire m1_as_, input wire m1_rw,
  input wire [`WordDataBus] m1_w_data, input wire m1_grnt_,
  input wire [`WordAddrBus] m2_addr, input wire m2_as_, input wire m2_rw,
  input wire [`WordDataBus] m2_w_data, input wire m2_grnt_,
  input wire [`WordAddrBus] m3_addr, input wire m3_as_, input wire m3_rw,
  input wire [`WordDataBus] m3_w_data, input wire m3_grnt_,
  output wire [`WordAddrBus] s_addr, output wire s_as_, output wire s_rw,
  output wire [`WordDataBus] s_w_data);
  assign s_addr = m0_grnt_ == `ENABLE_ ? m0_addr :
                  m1_grnt_ == `ENABLE_ ? m1_addr :
                  m2_grnt_ == `ENABLE_ ? m2_addr :
                  m3_grnt_ == `ENABLE_ ? m3_addr :
                  `NULL;
  assign s_as_ = m0_grnt_ == `ENABLE_ ? m0_as_ :
                 m1_grnt_ == `ENABLE_ ? m1_as_ :
                 m2_grnt_ == `ENABLE_ ? m2_as_ :
                 m3_grnt_ == `ENABLE_ ? m3_as_ :
                 `DISABLE_;
  assign s_rw = m0_grnt_ == `ENABLE_ ? m0_rw :
                m1_grnt_ == `ENABLE_ ? m1_rw :
                m2_grnt_ == `ENABLE_ ? m2_rw :
                m3_grnt_ == `ENABLE_ ? m3_rw :
                `READ;
  assign s_w_data = m0_grnt_ == `ENABLE_ ? m0_w_data :
                    m1_grnt_ == `ENABLE_ ? m1_w_data :
                    m2_grnt_ == `ENABLE_ ? m2_w_data :
                    m3_grnt_ == `ENABLE_ ? m3_w_data :
                    `ZERO;
endmodule
