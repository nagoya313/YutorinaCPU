`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "bus.h"

module yutorina_bus_arbiter(
  input wire clock, input wire reset,
  input wire master0_request_, output wire master0_grant_,
  input wire master1_request_, output wire master1_grant_,
  input wire master2_request_, output wire master2_grant_,
  input wire master3_request_, output wire master3_grant_);
  reg [`YutorinaBusOwnerBus] owner;
  // バスグラント生成
  assign master0_grant_ = owner == `YUTORINA_BUS_OWNER_MASTER_0 ?
                          `YUTORINA_ENABLE_ : `YUTORINA_DISABLE_;
  assign master1_grant_ = owner == `YUTORINA_BUS_OWNER_MASTER_1 ?
                          `YUTORINA_ENABLE_ : `YUTORINA_DISABLE_;
  assign master2_grant_ = owner == `YUTORINA_BUS_OWNER_MASTER_2 ?
                          `YUTORINA_ENABLE_ : `YUTORINA_DISABLE_;
  assign master3_grant_ = owner == `YUTORINA_BUS_OWNER_MASTER_3 ?
                          `YUTORINA_ENABLE_ : `YUTORINA_DISABLE_;
  // バス權アービトレーション
  // らうんどろびん的な何か
  always @(posedge clock or `YUTORINA_RESET_EDGE reset) begin
    if (reset == `YUTORINA_RESET_ENABLE) begin
      owner <= #1 `YUTORINA_BUS_OWNER_MASTER_0;
    end else begin
      case (owner)
        `YUTORINA_BUS_OWNER_MASTER_0 : begin
          if (master0_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_0;
          end else if (master1_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_1;
          end else if (master2_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_2;
          end else if (master3_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_3;
          end
        end
        `YUTORINA_BUS_OWNER_MASTER_1 : begin
          if (master1_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_1;
          end else if (master2_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_2;
          end else if (master3_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_3;
          end else if (master0_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_0;
          end
        end
        `YUTORINA_BUS_OWNER_MASTER_2 : begin
          if (master2_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_2;
          end else if (master3_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_3;
          end else if (master0_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_0;
          end else if (master1_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_1;
          end
        end
        `YUTORINA_BUS_OWNER_MASTER_3 : begin
          if (master3_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_3;
          end else if (master0_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_0;
          end else if (master1_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_1;
          end else if (master2_request_ == `YUTORINA_ENABLE_) begin
            owner <= #1 `YUTORINA_BUS_OWNER_MASTER_2;
          end
        end
      endcase
    end
  end  
endmodule
