`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "spm.h"

`timescale 1ns/1ps

module x_s3e_dpram(input wire clka, input wire [`SpmAddrBus] addra,
                   input wire [`WordDataBus] dina, input wire wea,
                   output reg [`WordDataBus] douta,
                   input wire clkb, input wire [`SpmAddrBus] addrb,
                   input wire [`WordDataBus] dinb, input wire web,
                   output reg [`WordDataBus] doutb);
  reg [`WordDataBus] memory[`SPM_DEPTH - 1:0];
  always @(posedge clka) begin
    if ((web == `ENABLE) && (addra == addrb)) begin
      douta <= #1 dinb;
    end else begin
      douta <= #1 memory[addra];
    end
    if (wea == `ENABLE) begin
      memory[addra] <= #1 dina;
    end
  end
  always @(posedge clkb) begin
    if ((wea == `ENABLE) && (addra == addrb)) begin
      doutb <= #1 dina;
    end else begin
      doutb <= #1 memory[addrb];
    end
    if (web == `ENABLE) begin
      memory[addrb] <= #1 dinb;
    end
  end
endmodule
