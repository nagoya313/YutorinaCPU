`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

module yutorina_clk_gen(input wire clk_ref, input wire rst_sw,
                        output wire clk, output wire clk_,
                        output wire chip_rst);
  wire locked;
  wire dcm_rst = rst_sw == `RESET_ENABLE ? `ENABLE : `DISABLE;
  assign chip_rst = rst_sw == `RESET_ENABLE || locked == `DISABLE ?
                    `RESET_ENABLE : `RESET_DISABLE;
  x_s3e_dcm x_s3e_dcm(.CLKIN_IN (clk_ref), .RST_IN (dcm_rst),
                      .CLK0_OUT (clk), .CLK180_OUT (clk_),
                      .LOCKED_OUT (locked));
endmodule
