`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "gpr.h"
`include "spr.h"
`include "spm.h"

module yutorina_cpu(input wire clk, input wire clk_, input wire rst,
                    input wire [`WordDataBus] i_r_data,
                    input wire i_rdy_, output wire i_req_,
                    output wire [`WordAddrBus] i_addr,
                    output wire i_as_, output i_rw,
                    output wire [`WordDataBus] i_w_data,
                    input wire i_grnt_,
                    input wire [`WordDataBus] d_r_data,
                    input wire d_rdy_, output wire d_req_,
                    output wire [`WordAddrBus] d_addr,
                    output wire d_as_, output d_rw,
                    output wire [`WordDataBus] d_w_data,
                    input wire d_grnt_);
  wire [`SpmAddrBus] spm_i_addr;
  wire spm_i_as_;
  wire [`WordDataBus] spm_i_r_data;
  wire [`SpmAddrBus] spm_d_addr;
  wire spm_d_as_;
  wire spm_d_rw;
  wire [`WordDataBus] spm_d_w_data;
  wire [`WordDataBus] spm_d_r_data;
  wire [`GprAddrBus] gpr_r_addr1;
  wire [`GprAddrBus] gpr_r_addr2;
  wire [`GprAddrBus] gpr_w_addr;
  wire [`WordDataBus] gpr_r_data1;
  wire [`WordDataBus] gpr_r_data2;
  wire [`WordDataBus] gpr_w_data;
  wire gpr_we_;
  yutorina_spm spm(
    .clk (clk_),
    .i_addr (spm_i_addr), .i_as_ (spm_i_as_), .i_r_data (spm_i_r_data),
    .d_addr (spm_d_addr), .d_as_ (spm_d_as_), .d_rw (spm_d_rw),
    .d_w_data (spm_d_w_data), .d_r_data (spm_d_r_data));
  yutorina_gpr gpr(
    .clk (clk), .rst (rst), 
    .r_addr1 (gpr_r_addr1), .r_data1 (gpr_r_data1),
    .r_addr2 (gpr_r_addr2), .r_data2 (gpr_r_data2),
    .we_ (gpr_we_), .w_addr (gpr_w_addr), .w_data (gpr_w_data));
endmodule
