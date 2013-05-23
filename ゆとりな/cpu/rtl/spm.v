`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`include "spm.h"

`timescale 1ns/1ps

module yutorina_spm(
  input wire clock,
  input wire [`YutorinaSpmAddressBus] instruction_address,
  input wire instruction_address_strobe_, input wire instruction_read_write,
  input wire [`YutorinaWordDataBus] instruction_write_data,
  output wire [`YutorinaWordDataBus] instruction_read_data,
  input wire [`YutorinaSpmAddressBus] data_address,
  input wire data_address_strobe_, input wire data_read_write,
  input wire [`YutorinaWordDataBus] data_write_data,
  output wire [`YutorinaWordDataBus] data_read_data);
  wire write_enable_port_a;
  wire write_enable_port_b;
  assign write_enable_port_a
    = ((instruction_address_strobe_ == `YUTORINA_ENABLE_) &&
       (instruction_read_write == `YUTORINA_WRITE)) ?
       `YUTORINA_ENABLE : `YUTORINA_DISABLE;
  assign write_enable_port_b
    = ((data_address_strobe_ == `YUTORINA_ENABLE_) &&
       (data_read_write == `YUTORINA_WRITE)) ?
       `YUTORINA_ENABLE : `YUTORINA_DISABLE;
  x_s3e_dpram x_s3e_dpram(.clka (clock),
                          .addra (instruction_address),
                          .dina (instruction_write_data),
                          .wea (write_enable_port_a),
                          .douta (instruction_read_data),
                          .clkb (clock),
                          .addrb (data_address),
                          .dinb (data_write_data),
                          .web (write_enable_port_b),
                          .doutb (data_read_data));
endmodule
