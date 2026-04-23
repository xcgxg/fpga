`timescale 1ns / 1ps
`define CNT_MAX_1HZ (25_000)
`define CNT_MAX_2HZ (12_500)
`define CNT_MAX_4HZ (6_250)
`define CNT_MAX_10HZ (2_500)

module led_twinkle_4_tb();

   reg clk, reset_n;
   wire [3:0] led;

   led_twinkle_4 led_twinkle_4_i(clk, reset_n, led);
   defparam led_twinkle_4_i.CNT_MAX_1HZ = `CNT_MAX_1HZ;
   defparam led_twinkle_4_i.CNT_MAX_2HZ = `CNT_MAX_2HZ;
   defparam led_twinkle_4_i.CNT_MAX_4HZ = `CNT_MAX_4HZ;
   defparam led_twinkle_4_i.CNT_MAX_10HZ = `CNT_MAX_10HZ;

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

