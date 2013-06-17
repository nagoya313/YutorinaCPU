`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "isa.h"
`include "spm.h"
`include "bus.h"
`include "cpu.h"

module yutorina_bus_if(
  input wire clk, input wire rst, input wire stall,
  input wire rw, input wire as_, input wire [`WordAddrBus] addr,
  input wire [`WordDataBus] w_data, output wire [`WordDataBus] r_data,
  input wire [`WordDataBus] spm_r_data, output wire [`WordDataBus] spm_w_data,
  output wire [`SpmAddrBus] spm_addr, output wire spm_as_, output wire spm_rw,
  input wire [`WordDataBus] bus_r_data, output reg [`WordDataBus] bus_w_data,
  input wire bus_rdy_, output reg bus_req_,
  output reg [`WordAddrBus] bus_addr, output reg bus_as_,
  output reg bus_rw,  input wire bus_grnt_, output wire bus_busy);
  reg [`BusStateBus] bus_state;
  reg [`WordDataBus] r_buf;
  wire [`BusSlaveIndexBus] s_index = addr[`BusSlaveIndexLocale];
  function bus_busy_state;
    input [`BusStateBus] bus_state;
    input [`BusSlaveIndexBus] s_index;
    input as_;
    input bus_rdy_;
    begin
      bus_busy_state = `FREE;
      if (bus_state == `BUS_STATE_IDLE) begin
        if (as_ == `ENABLE_ && s_index != `BUS_SLABE_1) begin
          bus_busy_state = `BUSY;
        end
      end else if (bus_state == `BUS_STATE_REQ) begin
        bus_busy_state = `BUSY;
      end else if (bus_state == `BUS_STATE_ACCESS) begin
        if (bus_rdy_ == `DISABLE_) begin
          bus_busy_state = `BUSY;
        end
      end
    end
  endfunction
  assign bus_busy = bus_busy_state(bus_state, s_index, as_, bus_rdy_);
  function [`WordDataBus] r_data_sel;
    input [`BusStateBus] bus_state;
    input [`BusSlaveIndexBus] s_index;
    input as_;
    input bus_rdy_;
    input [`WordDataBus] bus_r_data;
    input [`WordDataBus] spm_r_data;
    input [`WordDataBus] r_buf;
    begin
      r_data_sel = `ZERO;
      if (rw == `READ) begin
        r_data_sel = s_index == `BUS_SLABE_1 ? spm_r_data : r_buf;
      end
      case (bus_state)
        `BUS_STATE_IDLE: begin
          if (s_index == `BUS_SLABE_1 && as_ == `ENABLE_ && rw == `READ) begin
            r_data_sel = spm_r_data;
          end
        end `BUS_STATE_ACCESS: begin
          if (bus_rdy_ == `ENABLE_ && rw == `READ) begin
            r_data_sel = bus_r_data;
          end
        end `BUS_STATE_STALL: begin
          if (rw == `READ) begin
            r_data_sel = r_buf;
          end
        end
      endcase
    end
  endfunction
  assign r_data = r_data_sel(bus_state, s_index, as_,
                             bus_rdy_, bus_r_data, spm_r_data, r_buf);
  assign spm_rw = rw;
  assign spm_as_ = bus_state == `BUS_STATE_IDLE && s_index == `BUS_SLABE_1 &&
                   as_ == `ENABLE_ && s_index == `BUS_SLABE_1 ?
                   `ENABLE_ : `DISABLE_;
  assign spm_addr = addr;
  assign spm_w_data = w_data;
  always @(posedge clk or `RESET_EDGE rst) begin
    if (rst == `RESET_ENABLE) begin
      bus_req_   <= #1 `DISABLE_;
      bus_as_    <= #1 `DISABLE_;
      bus_addr   <= #1 `NULL;
      bus_w_data <= #1 `ZERO;
      bus_state  <= #1 `BUS_STATE_IDLE;
      r_buf      <= #1 `ZERO;
    end else begin
      case (bus_state)
        `BUS_STATE_IDLE: begin
          if (s_index != `BUS_SLABE_1 && as_ == `ENABLE_) begin
            bus_state  <= #1 `BUS_STATE_REQ;
            bus_req_   <= #1 `ENABLE_;
            bus_rw     <= #1 rw;
            bus_addr   <= #1 addr;
            bus_w_data <= #1 w_data;
          end
        end `BUS_STATE_REQ: begin
          if (bus_grnt_ == `ENABLE_) begin
            bus_state <= #1 `BUS_STATE_ACCESS;
            bus_as_   <= #1 `ENABLE_;
          end
        end `BUS_STATE_ACCESS: begin
          bus_as_ <= #1 `DISABLE_;
          if (bus_rdy_ == `ENABLE_) begin
            if (rw == `READ) begin
              r_buf <= #1 bus_r_data;
            end
            bus_req_   <= #1 `DISABLE_;
            bus_addr   <= #1 `NULL;
            bus_w_data <= #1 `ZERO;
            if (stall == `ENABLE) begin
              bus_state <= #1 `BUS_STATE_STALL;
            end else begin
              bus_state  <= #1 `BUS_STATE_IDLE;
            end
          end
        end `BUS_STATE_STALL: begin
          if (stall == `DISABLE) begin
              bus_state <= #1 `BUS_STATE_IDLE;
          end
        end
      endcase
    end
  end
endmodule
