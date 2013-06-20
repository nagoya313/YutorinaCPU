`ifndef __YUTORINA_CPU_CPU_H__
`define __YUTORINA_CPU_CPU_H__

`define BusStateBus 1:0
`define BUS_STATE_IDLE   2'b00
`define BUS_STATE_REQ    2'b01
`define BUS_STATE_ACCESS 2'b10
`define BUS_STATE_STALL  2'b11

`define MODE_USER   1'b0
`define MODE_KERNEL 1'b1 

`define MissAlignBus     1:0
`define MISS_ALIGN_NONE  2'b00
`define MISS_ALIGN_LOAD  2'b01
`define MISS_ALIGN_STORE 2'b10

`define MemOpBus  3:0
`define MEM_NONE  4'b0000
`define MEM_W_W  4'b0100
`define MEM_W_H  4'b0101
`define MEM_W_B  4'b0110
`define MEM_R_W  4'b1000 
`define MEM_R_H  4'b1001 
`define MEM_R_B  4'b1010 
`define MEM_R_HU 4'b1011 
`define MEM_R_BU 4'b1100 

`define CtrlOpBus 1:0
`define CTRL_NONE 2'b00
`define CTRL_SSR  2'b01
`define CTRL_LSR  2'b10
`define CTRL_ERET 2'b11

`endif
