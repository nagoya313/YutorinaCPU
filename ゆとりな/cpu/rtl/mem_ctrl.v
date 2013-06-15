`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "cpu.h"
`include "exp.h"
`include "gpr.h"

`define MemCtrlBus 32+2+1+1-1:0 

module yutorina_mem_ctrl(
  input wire ex_en_, input wire [`MemOpBus] ex_mem_op,
  input wire [`WordDataBus] ex_out, input wire [`WordDataBus] ex_w_data,
  input wire [`WordDataBus] mem_r_data,
  output wire [`WordDataBus] out,
  output wire [`MissAlignBus] miss_align, output wire as_, output wire rw);
  function [`MemCtrlBus] mem_ctrl;
    input [`MemOpBus] mem_op;
    input [`WordDataBus] o_data;
    input [`WordDataBus] w_data;
    input [`WordDataBus] r_data;
    reg [`ByteOffsetBus] byte;
    begin
      byte = ex_out[`ByteOffsetLocale];
      mem_ctrl = {o_data, `MISS_ALIGN_NONE, `DISABLE_, `READ};
      if (ex_en_ == `ENABLE_) begin
        case (mem_op)
          `MEM_W_W: begin
            if (byte == 2'b00) begin
              mem_ctrl = {o_data, `MISS_ALIGN_NONE, `ENABLE_, `WRITE};
            end else begin
              mem_ctrl = {`ZERO, `MISS_ALIGN_STORE, `DISABLE_, `READ};
            end
          end `MEM_R_W: begin
            if (byte == 2'b00) begin
              mem_ctrl = {r_data, `MISS_ALIGN_NONE, `ENABLE_, `READ};
            end else begin
              mem_ctrl = {`ZERO, `MISS_ALIGN_LOAD, `DISABLE_, `READ};
            end
          end
        endcase
      end
    end
  endfunction
  assign {out, miss_align, as_, rw}
    = mem_ctrl(ex_mem_op, ex_out, ex_w_data, mem_r_data);
endmodule
