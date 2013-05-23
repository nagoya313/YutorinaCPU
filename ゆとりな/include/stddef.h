`ifndef __YUTORINA_STDDEF_H__
`define __YUTORINA_STDDEF_H__

`define YUTORINA_HIGH 1'b1
`define YUTORINA_LOW  1'b0

`define YUTORINA_DISABLE  1'b0
`define YUTORINA_ENABLE   1'b1
`define YUTORINA_DISABLE_ 1'b1
`define YUTORINA_ENABLE_  1'b0

`define YUTORINA_READ  1'b1
`define YUTORINA_WRITE 1'b0

`define YUTORINA_LSB             0
`define YUTORINA_BYTE_DATA_WIDTH 8
`define YUTORINA_BYTE_MSB        7
`define YutorinaByteDataBus      7:0

`define YUTORINA_WORD_DATA_WIDTH 32
`define YUTORINA_WORD_MSB        31
`define YutorinaWordDataBus      31:0

`define YUTORINA_WORD_ADDRESS_WIDTH 30
`define YUTORINA_WORD_ADDRESS_MSB   29
`define YutorinaWordAddressBus      29:0

`define YUTORINA_BYTE_OFFSET_WIDTH 2
`define YutorinaByteOffsetBus      1:0

`define YutorinaWordAddressLocale 31:2
`define YutorinaByteOffsetLocale  1:0

`define YUTORINA_BYTE_OFFSET_WORD 2'b00

`endif
