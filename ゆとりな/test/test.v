`include "nettype.h"
`include "global_config.h"
`include "stddef.h"
`include "timescale.h"

module cpu_tset();
  reg clk;
  reg rst;
  parameter STEP = 100.0000;
  
  always #(STEP / 2) begin
    clk <= ~clk;
  end
  
  yutorina_chip_top top(.clk_ref (clk), .rst_sw (rst));
  
  initial begin
    #0 begin
      clk <= `HIGH;
      rst <= `RESET_ENABLE;
    end
    #(STEP / 4) begin
      $readmemh("test.dat", top.chip.rom.x_s3e_sprom.memory);
      $readmemh("mem.dat", top.chip.cpu.spm.x_s3e_dpram.memory);
    end
    #(STEP *3 / 4) begin
      rst <= `RESET_DISABLE;
    end
    #10000000 begin
      $finish;
    end
  end
  
  initial begin
    $dumpfile("yutorina.vcd");
    $dumpvars(0, top);
  end
endmodule
