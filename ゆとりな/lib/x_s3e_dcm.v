`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

module x_s3e_dcm(input wire CLKIN_IN, input wire RST_IN,
                 output wire CLK0_OUT, output wire CLK180_OUT,
                 output wire LOCKED_OUT);
  assign CLK0_OUT   = CLKIN_IN;
  assign CLK180_OUT = ~CLKIN_IN;
  assign LOCKED_OUT = ~RST_IN;
endmodule
