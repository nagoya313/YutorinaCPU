`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "bus.h"

module yutorina_bus_arbiter(input wire clk, input wire rst,
                            input wire m0_req_, output wire m0_grnt_,
                            input wire m1_req_, output wire m1_grnt_,
                            input wire m2_req_, output wire m2_grnt_,
                            input wire m3_req_, output wire m3_grnt_);
  reg [`BusMasterBus] owner;
  assign m0_grnt_ = owner == `BUS_MASTER_0 ? `ENABLE_ : `DISABLE_;
  assign m1_grnt_ = owner == `BUS_MASTER_1 ? `ENABLE_ : `DISABLE_;
  assign m2_grnt_ = owner == `BUS_MASTER_2 ? `ENABLE_ : `DISABLE_;
  assign m3_grnt_ = owner == `BUS_MASTER_3 ? `ENABLE_ : `DISABLE_;
  always @(posedge clk or `RESET_EDGE rst) begin
    if (rst == `RESET_ENABLE) begin
      owner <= #1 `BUS_MASTER_0;
    end else begin
      case (owner)
        `BUS_MASTER_0 : begin
          if (m0_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_0;
          end else if (m1_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_1;
          end else if (m2_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_2;
          end else if (m3_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_3;
          end
        end `BUS_MASTER_1 : begin
          if (m1_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_1;
          end else if (m2_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_2;
          end else if (m3_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_3;
          end else if (m0_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_0;
          end
        end `BUS_MASTER_2 : begin
          if (m2_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_2;
          end else if (m3_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_3;
          end else if (m0_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_0;
          end else if (m1_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_1;
          end
        end `BUS_MASTER_3 : begin
          if (m3_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_3;
          end else if (m0_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_0;
          end else if (m1_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_1;
          end else if (m2_req_ == `ENABLE_) begin
            owner <= #1 `BUS_MASTER_2;
          end
        end
      endcase
    end
  end  
endmodule
