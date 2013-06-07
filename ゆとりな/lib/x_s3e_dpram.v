`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "spm.h"

module x_s3e_dpram(
  // ポートA
  input wire clka,
  input wire [`SpmAddrBus] addra,
  input wire [`WordDataBus] dina,
  input wire wea,
  output reg [`WordDataBus] douta,
  // ポートB
  input wire clkb,
  input wire [`SpmAddrBus] addrb,
  input wire [`WordDataBus] dinb,
  input wire web,
  output reg [`WordDataBus] doutb);
  // メモリ
  reg [`WordDataBus] memory[`SPM_DEPTH - 1:0];
  // ポートA
  always @(posedge clka) begin
    // 讀出しと同時にポートBが書込み？
    douta <= #1 web == `ENABLE && addra == addrb ? dinb : memory[addra];
    // 書込み
    if (wea == `ENABLE) begin
      memory[addra] <= #1 dina;
    end
  end
  // ポートB
  always @(posedge clkb) begin
    // 讀出しと同時にポートAが書込み？
    doutb <= #1 wea == `ENABLE && addra == addrb ? dina : memory[addrb];
    // 書込み
    if (web == `ENABLE) begin
      memory[addrb] <= #1 dinb;
    end
  end
endmodule
