`timescale 1ns / 1ps
`define CNT_MAX_1HZ (50_000)
`define CNT_MAX_1HZ_ON (12_500)

`define TIME_UNIT_MS (1)


module led_ctrl_tb();
   reg clk, reset_n;
   reg [7:0] sw;
   wire led;

   // led_ctrl0 led_ctrl0_i(clk, reset_n, led);
   // defparam led_ctrl0_i.CNT_MAX_1HZ = `CNT_MAX_1HZ;
   // defparam led_ctrl0_i.CNT_MAX_1HZ_ON = `CNT_MAX_1HZ_ON;

   // led_ctrl1 led_ctrl1_i(clk, reset_n, led);
   // defparam led_ctrl1_i.TIME_UNIT_MS = `TIME_UNIT_MS;

   // led_ctrl2 led_ctrl2_i(clk, reset_n, led);
   // defparam led_ctrl2_i.TIME_UNIT_MS = `TIME_UNIT_MS;

   led_ctrl3 led_ctrl3_i(clk, reset_n, sw, led);
   defparam led_ctrl3_i.TIME_UNIT_MS = `TIME_UNIT_MS;

   initial clk = 1;

   // Main frequency 50MHz, cycle 20ns
   always #10 clk = ~clk;

   initial begin
      // reset_n = 0;
      // #201;
      // reset_n = 1;
      // // 80ms
      // #80_000_000;
      // // 2s
      // // #2000_000_000;

      reset_n = 0;
      sw = 8'b1010_1010;
      #201;
      reset_n = 1;
      // 40ms
      #40_000_000;

      sw = 8'b0000_1111;
      // 40ms
      #40_000_000;
      $stop;
   end

endmodule
