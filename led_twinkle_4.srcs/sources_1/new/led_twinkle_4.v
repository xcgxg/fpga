`timescale 1ns / 1ps
`define CNT_MAX_1HZ (25_000_000)
`define CNT_MAX_2HZ (12_500_000)
`define CNT_MAX_4HZ (6_250_000)
`define CNT_MAX_10HZ (2_500_000)

module led_twinkle_4(clk, reset_n, led);

   input clk, reset_n;
   output wire [3:0] led;

   parameter CNT_MAX_1HZ = `CNT_MAX_1HZ;
   led_twinkle #(.CNT_MAX(CNT_MAX_1HZ))
      led_twinkle_i0(clk, reset_n, led[0]);

   parameter CNT_MAX_2HZ = `CNT_MAX_2HZ;
   led_twinkle led_twinkle_i1(clk, reset_n, led[1]);
   defparam led_twinkle_i1.CNT_MAX = CNT_MAX_2HZ;

   parameter CNT_MAX_4HZ = `CNT_MAX_4HZ;
   led_twinkle led_twinkle_i2(clk, reset_n, led[2]);
   defparam led_twinkle_i2.CNT_MAX = CNT_MAX_4HZ;

   parameter CNT_MAX_10HZ = `CNT_MAX_10HZ;
   led_twinkle led_twinkle_i3(clk, reset_n, led[3]);
   defparam led_twinkle_i3.CNT_MAX = CNT_MAX_10HZ;


endmodule
