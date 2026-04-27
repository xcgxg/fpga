`timescale 1ns / 1ps
`define CNT_MAX_1HZ (50_000_000)
`define CNT_MAX_1HZ_ON (12_500_000)

module led_ctrl0(clk, reset_n, led);

   input clk, reset_n;
   output reg led;

   /**
    * Main frequency 50MHz, 0.25s led on, 0.75s led down
    * 50MHz * (0.25s + 0.75s) = 50M = 0010 1111 1010 1111 0000 1000 0000
    */
   reg [25:0] counter;

   parameter CNT_MAX_1HZ = `CNT_MAX_1HZ;
   parameter CNT_MAX_1HZ_ON = `CNT_MAX_1HZ_ON;

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         counter <= 0;
      /**
       * Not set (50_000_000 - 1) here to make the first 0.25s not to be
        * (0.25s - 20ns).
       */
      else if (counter == CNT_MAX_1HZ)
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
      else if ((counter == 0) || (counter == CNT_MAX_1HZ))
         led <= 1'd1;
      else if (counter == CNT_MAX_1HZ_ON)
         led <= 1'd0;
   end

endmodule
