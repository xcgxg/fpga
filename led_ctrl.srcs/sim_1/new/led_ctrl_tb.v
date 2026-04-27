`timescale 1ns / 1ps
`define CNT_MAX_1HZ (50_000)
`define CNT_MAX_1HZ_ON (12_500)


module led_ctrl_tb();
   reg clk, reset_n;
   wire led;

   led_ctrl0 led_ctrl0_i(clk, reset_n, led);
   defparam led_ctrl0_i.CNT_MAX_1HZ = `CNT_MAX_1HZ;
   defparam led_ctrl0_i.CNT_MAX_1HZ_ON = `CNT_MAX_1HZ_ON;

   initial clk = 1;

   // Main frequency 50MHz, cycle 20ns
   always #10 clk = ~clk;

   initial begin
      reset_n = 0;
      #201;
      reset_n = 1;
      // 80ms
      #80_000_000;
      // 2s
      // #2000_000_000;
      $stop;
   end

endmodule
