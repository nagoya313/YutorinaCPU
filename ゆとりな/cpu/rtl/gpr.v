`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

`include "gpr.h"

module yutorina_gpr(
  input wire clk, input wire rst, input wire flush,
  input wire [`GprAddrBus] r_addr1, output wire [`WordDataBus] r_data1,
  input wire [`GprAddrBus] r_addr2, output wire [`WordDataBus] r_data2,
  input wire we_,
  input wire [`GprAddrBus] w_addr, input wire [`WordDataBus] w_data);
  reg [`WordDataBus] gprs[`GPR_NUM - 1:0];
  integer i;
`ifdef YUTORINA_SIMULATION
  wire [`WordDataBus] gpr0  = gprs[0];
  wire [`WordDataBus] gpr1  = gprs[1];
  wire [`WordDataBus] gpr2  = gprs[2];
  wire [`WordDataBus] gpr3  = gprs[3];
  wire [`WordDataBus] gpr4  = gprs[4];
  wire [`WordDataBus] gpr5  = gprs[5];
  wire [`WordDataBus] gpr6  = gprs[6];
  wire [`WordDataBus] gpr7  = gprs[7];
  wire [`WordDataBus] gpr8  = gprs[8];
  wire [`WordDataBus] gpr9  = gprs[9];
  wire [`WordDataBus] gpr10 = gprs[10];
  wire [`WordDataBus] gpr11 = gprs[11];
  wire [`WordDataBus] gpr12 = gprs[12];
  wire [`WordDataBus] gpr13 = gprs[13];
  wire [`WordDataBus] gpr14 = gprs[14];
  wire [`WordDataBus] gpr15 = gprs[15];
  wire [`WordDataBus] gpr16 = gprs[16];
  wire [`WordDataBus] gpr17 = gprs[17];
  wire [`WordDataBus] gpr18 = gprs[18];
  wire [`WordDataBus] gpr19 = gprs[19];
  wire [`WordDataBus] gpr20 = gprs[20];
  wire [`WordDataBus] gpr21 = gprs[21];
  wire [`WordDataBus] gpr22 = gprs[22];
  wire [`WordDataBus] gpr23 = gprs[23];
  wire [`WordDataBus] gpr24 = gprs[24];
  wire [`WordDataBus] gpr25 = gprs[25];
  wire [`WordDataBus] gpr26 = gprs[26];
  wire [`WordDataBus] gpr27 = gprs[27];
  wire [`WordDataBus] gpr28 = gprs[28];
  wire [`WordDataBus] gpr29 = gprs[29];
  wire [`WordDataBus] gpr30 = gprs[30];
  wire [`WordDataBus] gpr31 = gprs[31];
`endif
  assign r_data1
    = we_ == `ENABLE_ && w_addr == r_addr1 && w_addr != `GPR_ZERO ?
      w_data : gprs[r_addr1];
  assign r_data2
    = we_ == `ENABLE_ && w_addr == r_addr2 && w_addr != `GPR_ZERO ?
      w_data : gprs[r_addr2];
  always @(posedge clk or `RESET_EDGE rst) begin
    if (rst == `RESET_ENABLE) begin
      for (i = 0; i < `GPR_NUM; i = i + 1) begin
        gprs[i] <= #1 `WORD_DATA_W'h0;
      end
    end else begin
      if (we_ == `ENABLE_ && w_addr != `GPR_ZERO && flush == `DISABLE) begin
        gprs[w_addr] <= #1 w_data;
      end
    end
  end
endmodule
