`timescale 1ns / 1ps
`define CNT_MAX (25_000)

module led_run_tb();

   reg clk, reset_n;
   wire [7:0] led;

   // led_run led_run_i(clk, reset_n, led);
   // defparam led_run_i.CNT_MAX = `CNT_MAX;
   // led_run1 led_run1_i(clk, reset_n, led);
   // defparam led_run1_i.CNT_MAX = `CNT_MAX;
   led_run2 led_run2_i(clk, reset_n, led);
   defparam led_run2_i.CNT_MAX = `CNT_MAX;

   initial clk = 1;

   // Main frequency 50MHz, cycle 20ns
   always #10 clk = ~clk;

   initial begin
      reset_n = 0;
      #201;
      reset_n = 1;
      // 80ms
      #80_000_000;
      $stop;
   end

endmodule

