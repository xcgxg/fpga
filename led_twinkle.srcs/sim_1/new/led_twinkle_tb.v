`timescale 1ns / 1ps

module led_twinkle_tb();

   reg clk, reset_n;
   wire led;

   led_twinkle led_twinkle_i(clk, reset_n, led);

   initial clk = 1;

   // Main frequency 50MHz, cycle 20ns
   always #10 clk = ~clk;

   initial begin
      reset_n = 0;
      #201;
      reset_n = 1;
      #2000_000_000;
      $stop;
   end

endmodule
