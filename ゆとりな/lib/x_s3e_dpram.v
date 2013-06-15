`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "spm.h"

module x_s3e_dpram(input wire clka, input wire [`SpmAddrBus] addra,
                   input wire [`WordDataBus] dina, input wire wea,
                   output reg [`WordDataBus] douta,
                   input wire clkb, input wire [`SpmAddrBus] addrb,
                   input wire [`WordDataBus] dinb,
                   input wire web,
                   output reg [`WordDataBus] doutb);
  reg [`WordDataBus] memory[`SPM_DEPTH - 1:0];
  always @(posedge clka) begin
    douta <= #1 web == `ENABLE && addra == addrb ? dinb : memory[addra];
    if (wea == `ENABLE) begin
      memory[addra] <= #1 dina;
    end
  end
  always @(posedge clkb) begin
    doutb <= #1 wea == `ENABLE && addra == addrb ? dina : memory[addrb];
    if (web == `ENABLE) begin
      memory[addrb] <= #1 dinb;
    end
  end
endmodule
