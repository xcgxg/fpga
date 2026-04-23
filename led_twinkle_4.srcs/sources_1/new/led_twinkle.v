`timescale 1ns / 1ps
`define CNT_MAX_1HZ (25_000_000)

module led_twinkle(clk, reset_n, led);

   input clk, reset_n;
   output reg led;

   /**
    * Main frequency 50MHz, 0.5s twinkle cycle
    * 50MHz * 0.5s = 25M = 0001 0111 1101 0111 1000 0100 0000
    */
   reg [24:0] counter;

   parameter CNT_MAX = `CNT_MAX_1HZ;

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         counter <= 0;
      /**
       * Not set (25_000_000 - 1) here to make the first 0.5s not to be
        * (0.5s - 20ns).
       */
      else if (counter == CNT_MAX)
         /**
          * After the first 0.5s, avoid spending extra 20ns to inc the counter
          * from 0 to 1, otherwise the cycle will be (0.5s + 20ns).
          */
         counter <= 1;
      else
         counter <= counter + 1'd1;
   end

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         led <= 1'd0;
      else if (counter == CNT_MAX)
         led <= !led;
   end

endmodule
