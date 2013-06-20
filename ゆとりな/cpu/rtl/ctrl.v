`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "cpu.h"
`include "exp.h"
`include "spr.h"

module yutorina_ctrl(
  input wire clk, input wire rst,
  input wire i_busy, input wire d_busy, input wire [`CtrlOpBus] ctrl_op,
  input wire id_en_, input wire mem_en_, input wire [`ExpBus] exp_code,
  output reg mode, output wire stall, output reg [`WordAddrBus] new_pc,
  output reg flush, output reg id_flush,
  input wire we_, input wire [`WordAddrBus] mem_pc,
  input wire [`SprAddrBus] r_addr, input wire [`SprAddrBus] w_addr, 
  output wire [`WordDataBus] r_data, input wire [`WordDataBus] w_data);
  reg [`WordAddrBus] v_addr;
  reg [`WordAddrBus] epc;
  reg [`SprCntBus] cnt;
  reg pre_mode;
  assign stall = i_busy | d_busy;
  function [`WordDataBus] sel_spr;
    input [`SprAddrBus] addr;
    input [`SprCntBus] cnt;
    input [`WordAddrBus] v_addr;
    input mode;
    input [`WordAddrBus] pc;
    input [`WordAddrBus] epc;
    begin
      case (addr)
        `SPR_PC: begin
          sel_spr = {pc, {2{1'b0}}};
        end `SPR_EPC: begin
          sel_spr = {epc, {2{1'b0}}};
        end `SPR_CNT_L: begin
          sel_spr = cnt[`SprCntLLocale];
        end `SPR_CNT_H: begin
          sel_spr = cnt[`SprCntHLocale];
        end `SPR_VECTOR: begin
          sel_spr = {v_addr, {2{1'b0}}};
        end `SPR_MODE: begin
          sel_spr = {{31{1'b0}}, mode};
        end default: begin
          sel_spr = `ZERO;
        end
      endcase
    end
  endfunction
  assign r_data = sel_spr(r_addr, cnt, v_addr, mode, mem_pc, epc);
  always @(posedge clk or `RESET_EDGE rst) begin
    if (rst == `RESET_ENABLE) begin
      flush    <= #1 `DISABLE;
      id_flush <= #1 `DISABLE;
      new_pc   <= #1 `NULL;
      epc      <= #1 `NULL;
      pre_mode <= #1 `MODE_KERNEL;
      cnt      <= #1 `SPR_CNT_DATA_W'h0;
      v_addr   <= #1 `NULL;
      mode     <= #1 `MODE_KERNEL;
    end else begin
      cnt <= #1 cnt + 1;
      if (id_en_ == `ENABLE && ctrl_op == `CTRL_ERET) begin
        flush    <= #1 `ENABLE;
        id_flush <= #1 `ENABLE;
        new_pc   <= #1 epc;
        epc      <= #1 `NULL;
        pre_mode <= #1 `MODE_KERNEL;
        mode     <= #1 pre_mode;
      end else if (mem_en_ == `ENABLE_) begin
        id_flush <= #1 `DISABLE;
        if (exp_code != `EXP_NONE) begin
          $display("Exception!(code=%x)", exp_code);
          flush    <= #1 `ENABLE;
          new_pc   <= #1 v_addr;
          epc      <= #1 mem_pc;
          pre_mode <= #1 mode;
          mode     <= #1 `MODE_KERNEL;
        end else if (we_ == `ENABLE_) begin
          flush  <= #1 `ENABLE;
          new_pc <= #1 mem_pc;
          case (w_addr)
            `SPR_VECTOR: begin
              v_addr <= #1 w_data[`WordAddrLocale];
            end `SPR_MODE: begin
              mode <= #1 w_data[0];
            end
`ifdef YUTORINA_SIMULATION
            `SPR_SP: begin
              $display("%x", w_data);
            end
`endif
          endcase
        end else begin
          flush    <= #1 `DISABLE;
          id_flush <= #1 `DISABLE;
          new_pc   <= #1 `NULL;
        end
      end
    end
  end
endmodule
