`ifndef __YUTORINA_CPU_SPR_H__
`define __YUTORINA_CPU_SPR_H__

`define SprCntBus      63:0
`define SPR_CNT_DATA_W 64
`define SprCntHLocale  63:32
`define SprCntLLocale  31:0

`define SPR_NUM    32
`define SPR_ADDR_W 5
`define SprAddrBus 4:0

`define SPR_ZERO        5'h0
`define SPR_PC          5'h0
`define SPR_EPC         5'h1
`define SPR_CNT_L       5'h2
`define SPR_CNT_H       5'h3
`define SPR_INT_MASK    5'h4
`define SPR_INT_PENDING 5'h5
`define SPR_RA          5'h6
`define SPR_SP          5'h1f

`endif
