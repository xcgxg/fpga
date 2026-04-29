`timescale 1ns / 1ps
`define CNT_MAX (125_000)
`define CNT1 (12_500)
`define CNT2 (37_500)
`define CNT3 (75_000)


module led_ctrl1(clk, reset_n, led);

   input clk, reset_n;
   output reg led;

   /**
    * Main frequency 50MHz, 0.25s on, 0.5s down, 0.75s on, 1s down
    * 50MHz * (0.25s + 0.5s + 0.75s + 1s) = 125M = 0111 0111 0011 0101 1001 0100 0000
    */
   reg [26:0] counter;

   parameter TIME_UNIT_MS = 1000;
   parameter CNT_MAX = `CNT_MAX * TIME_UNIT_MS;
   parameter CNT1 = `CNT1 * TIME_UNIT_MS;
   parameter CNT2 = `CNT2 * TIME_UNIT_MS;
   parameter CNT3 = `CNT3 * TIME_UNIT_MS;

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         counter <= 0;
      /**
       * Not set (CNT_MAX - 1) here to make the first 0.25s not to be
        * (0.25s - 20ns).
       */
      else if (counter == CNT_MAX)
         /**
          * After the first 1s, avoid spending extra 20ns to inc the counter
          * from 0 to 1, otherwise the cycle will be (1s + 20ns).
          */
         counter <= 1;
      else
         counter <= counter + 1'd1;
   end

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         led <= 1'd0;
      else if ((counter == 0) || (counter == CNT_MAX))
         led <= 1'd1;
      else if (counter == CNT1)
         led <= 1'd0;
      else if (counter == CNT2)
         led <= 1'd1;
      else if (counter == CNT3)
         led <= 1'd0;
   end

endmodule
