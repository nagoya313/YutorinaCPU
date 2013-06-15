`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "spr.h"

module yutorina_spr(input wire clk, input wire rst, input wire stall,
                    input wire [`SprAddrBus] addr, 
                    output wire [`WordDataBus] r_data,
                    input wire wr, input wire [`WordDataBus] w_data);
  reg [`SprCntBus] cnt;
  function [`WordDataBus] sel_spr;
    input [`SprAddrBus] addr;
    begin
      case (addr)
        `SPR_CNT_L: begin
          sel_spr = cnt[`SprCntLLocale];
        end `SPR_CNT_H: begin
          sel_spr = cnt[`SprCntHLocale];
        end default: begin
          sel_spr = `ZERO;
        end
      endcase
    end
  endfunction
  assign r_data = sel_spr(addr);
  always @(posedge clk or `RESET_EDGE rst) begin
    if (rst == `RESET_ENABLE) begin
      cnt <= #1 `SPR_CNT_DATA_W'h0;
    end else begin
      if (wr == `WRITE && stall == `DISABLE) begin
        case (addr)
`ifdef YUTORINA_SIMULATION
          `SPR_SP: begin
            $display("%x", w_data);
          end
`endif
        endcase
      end else begin
        cnt <= #1 cnt + 1;
      end
    end
  end
endmodule
