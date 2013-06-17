`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "spm.h"
`include "bus.h"
`include "cpu.h"

module yutorina_if_stage(
  input wire clk, input wire rst, input wire stall, output wire busy,
  input wire br_taken, input wire [`WordAddrBus] br_addr,
  input [`WordDataBus] spm_r_data, output [`SpmAddrBus] spm_addr,
  output spm_as_,
  input wire [`WordDataBus] bus_r_data, output wire [`WordDataBus] bus_w_data,
  input wire bus_rdy_, output wire bus_rw,
  output wire bus_req_, output wire [`WordAddrBus] bus_addr,
  output wire bus_as_, input wire bus_grnt_,
  output reg [`WordAddrBus] if_pc, output reg [`WordDataBus] if_insn,
  output reg if_en_);
  wire rw = `READ;
  wire as_ = `ENABLE_;
  wire [`WordDataBus] w_data = `ZERO;
  wire [`WordDataBus] insn;
  yutorina_bus_if bus_if(
    .clk (clk), .rst (rst), .stall (stall),
    .rw (rw), .as_ (as_), .addr (if_pc), .w_data (w_data), .r_data (insn),
    .spm_r_data (spm_r_data), .spm_addr (spm_addr), .spm_as_ (spm_as_),
    .bus_r_data (bus_r_data), .bus_w_data (bus_w_data),
    .bus_rdy_ (bus_rdy_), .bus_req_ (bus_req_), .bus_rw (bus_rw),
    .bus_addr (bus_addr), .bus_as_ (bus_as_),
    .bus_grnt_ (bus_grnt_), .bus_busy (busy));
  always @(posedge clk or `RESET_EDGE rst) begin
    if (rst == `RESET_ENABLE) begin
      if_pc   <= #1 `NULL;
      if_insn <= #1 `ZERO;
      if_en_  <= #1 `DISABLE_;
    end else begin
      if (stall == `DISABLE) begin
        if (br_taken == `ENABLE) begin
          if_pc   <= #1 br_addr;
          if_insn <= #1 insn;
          if_en_  <= #1 `ENABLE_;
        end else begin
          if_pc   <= #1 if_pc + 1;
          if_insn <= #1 insn;
          if_en_  <= #1 `ENABLE_;
        end
      end else begin
        if_en_ <= #1 `DISABLE_;
      end
    end
  end
endmodule
