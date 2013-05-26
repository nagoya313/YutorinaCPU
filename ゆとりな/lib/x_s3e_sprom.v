`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "rom.h"

`timescale 1ns/1ps

module x_s3e_sprom(input wire clka, input wire [`RomAddrBus] addra,
                   output reg [`WordDataBus] douta);
  reg [`WordDataBus] memory[`ROM_DEPTH - 1:0];
  always @(posedge clka) begin
    douta <= #1 memory[addra];
  end
endmodule
