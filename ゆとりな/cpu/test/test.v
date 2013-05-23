`include "nettype.h"
`include "global_config.h"
`include "stddef.h"

`timescale 1ns/1ps

module cpu_tset();
  reg clock;
  wire clock_;
  reg reset;
  // 10MHz
  parameter STEP = 100.0000;
  
  assign clock_ = ~clock;
  
  // クロック
  always #(STEP / 2) begin
    clock <= ~clock;
  end
  
  // ゆとりなちやん！
  yutorina_cpu cpu(.clock (clock), .clock_ (clock_), .reset (reset));
  
  initial begin
    #0 begin
      clock <= `YUTORINA_HIGH;
      reset <= `YUTORINA_RESET_ENABLE;
    end
    #(STEP / 4) begin
      $readmemh("test.dat", cpu.spm.x_s3e_dpram.memory);
    end
    #(STEP *3 / 4) begin
      reset <= `YUTORINA_RESET_DISABLE;
    end
    #10000000 begin
      $finish;
    end
  end
  
  // 波形
  initial begin
    $dumpfile("yutorina_cpu.vcd");
    $dumpvars(0, cpu);
  end
endmodule
