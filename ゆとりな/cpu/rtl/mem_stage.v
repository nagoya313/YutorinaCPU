`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "exp.h"
`include "gpr.h"

module yutorina_mem_stage(
  input wire clk, input wire rst, input wire stall, output wire busy,
  input wire ex_en_,
  input wire [`GprAddrBus] ex_w_addr, input wire [`WordDataBus] ex_w_data,
  inout wire ex_gpr_we_, input wire [`ExpBus] ex_exp_code,
  input wire [`MemOpBus] ex_mem_op, input wire [`CtrlOpBus] ex_ctrl_op,
  input wire [`WordDataBus] ex_out,
  output reg mem_en_, output reg [`GprAddrBus] mem_w_addr,
  output reg mem_gpr_we_, output reg [`ExpBus] mem_exp_code,
  output reg [`CtrlOpBus] mem_ctrl_op, output reg [`WordDataBus] mem_out,
  input wire [`WordDataBus] spm_r_data, output wire [`WordDataBus] spm_w_data,
  output wire [`SpmAddrBus] spm_addr, output wire spm_as_, output wire spm_rw,
  input wire [`WordDataBus] bus_r_data, output wire [`WordDataBus] bus_w_data,
  input wire bus_rdy_, output wire bus_req_,
  output wire [`WordAddrBus] bus_addr, output wire bus_as_,
  output wire bus_rw, input wire bus_grnt_,
  output wire [`GprAddrBus] fwd_addr, output wire [`WordDataBus] fwd_out,
  output reg [`SprAddrBus] spr_w_addr,
  output reg spr_we_, output reg [`WordDataBus] spr_w_data);
  wire rw;
  wire as_;
  wire [`WordDataBus] out;
  wire [`MissAlignBus] miss_align;
  wire [`WordAddrBus] addr = ex_out[`WordAddrLocale];
  wire [`WordDataBus] r_data;
  assign fwd_out = out;
  assign fwd_addr = ex_w_addr;
  always @(posedge clk or `RESET_EDGE rst) begin
    if (rst == `RESET_ENABLE) begin
      mem_en_      <= #1 `DISABLE_;
      mem_w_addr   <= #1 `GPR_ZERO;
      mem_gpr_we_  <= #1 `DISABLE_;
      mem_exp_code <= #1 `EXP_NONE;
      mem_ctrl_op  <= #1 `CTRL_NONE;
      mem_out      <= #1 `ZERO;
    end else begin
      //if (ex_en_ == `ENABLE_) begin
        mem_en_     <= #1 ex_en_;
        mem_w_addr  <= #1 miss_align != `MISS_ALIGN_NONE ? `NULL : ex_w_addr;
        mem_gpr_we_
          <= #1 miss_align != `MISS_ALIGN_NONE ? `DISABLE_ : ex_gpr_we_;
        case (miss_align)
          `MISS_ALIGN_LOAD: begin
            mem_exp_code <= #1 `EXP_LOAD_MISS_ALIGN;
          end `MISS_ALIGN_STORE: begin
            mem_exp_code <= #1 `EXP_STORE_MISS_ALIGN;
          end default: begin
            mem_exp_code <= #1 ex_exp_code;
          end
        endcase
        mem_ctrl_op 
          <= #1 miss_align != `MISS_ALIGN_NONE ? `CTRL_NONE : ex_ctrl_op;
        mem_out      <= #1 miss_align != `MISS_ALIGN_NONE ? `ZERO : out;
        if (ex_en_ == `ENABLE_) begin
          spr_w_addr <= #1 miss_align != `MISS_ALIGN_NONE ? `SPR_ZERO : 
                           ex_ctrl_op == `CTRL_SSR ? ex_w_addr : `SPR_ZERO;
          spr_we_    <= #1 miss_align != `MISS_ALIGN_NONE ? `DISABLE_ : 
                           ex_ctrl_op == `CTRL_SSR ? `ENABLE_ : `DISABLE_;
          spr_w_data <= #1 miss_align != `MISS_ALIGN_NONE ? `ZERO : 
                           ex_ctrl_op == `CTRL_SSR ? ex_w_data : `ZERO;
        end else begin
          spr_w_addr <= #1 `SPR_ZERO; 
          spr_we_    <= #1 `DISABLE_;
          spr_w_data <= #1 `ZERO;
        end
      //end else begin
        //mem_en_ <= #1 `DISABLE_;
      //end
    end
  end
  yutorina_mem_ctrl mem_ctrl(
    .ex_en_ (ex_en_), .ex_mem_op (ex_mem_op), .ex_out (ex_out),
    .mem_r_data (r_data),
    .out (out), .miss_align (miss_align), .as_ (as_), .rw (rw));
  yutorina_bus_if bus_if(
    .clk (clk), .rst (rst), .stall (stall),
    .rw (rw), .as_ (as_), .addr (addr), .w_data (ex_w_data), .r_data (r_data),
    .spm_r_data (spm_r_data), .spm_w_data (spm_w_data),
    .spm_addr (spm_addr), .spm_as_ (spm_as_), .spm_rw (spm_rw),
    .bus_r_data (bus_r_data), .bus_w_data (bus_w_data),
    .bus_rdy_ (bus_rdy_), .bus_req_ (bus_req_), .bus_rw (bus_rw),
    .bus_addr (bus_addr), .bus_as_ (bus_as_),
    .bus_grnt_ (bus_grnt_), .bus_busy (busy));
endmodule
