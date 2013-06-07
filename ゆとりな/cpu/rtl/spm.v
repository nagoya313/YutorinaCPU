`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "spm.h"

module yutorina_spm(
  input wire clk,
  input wire [`SpmAddrBus] i_addr, input wire i_as_,
  output wire [`WordDataBus] i_r_data,
  input wire [`SpmAddrBus] d_addr, input wire d_as_, input wire d_rw,
  input wire [`WordDataBus] d_w_data, output wire [`WordDataBus] d_r_data);
  wire we_a = `DISABLE;
  wire we_b = d_as_ == `ENABLE_ && d_rw == `WRITE ? `ENABLE : `DISABLE;
  x_s3e_dpram x_s3e_dpram(.clka (clk), .addra (i_addr), .dina (d_w_data),
                          .wea (we_a), .douta (i_r_data),
                          .clkb (clk), .addrb (d_addr), .dinb (d_w_data),
                          .web (we_b), .doutb (d_r_data));
endmodule
