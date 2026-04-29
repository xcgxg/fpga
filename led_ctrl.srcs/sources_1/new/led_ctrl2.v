`timescale 1ns / 1ps
`define CNT_MAX (12_500)


module led_ctrl2(clk, reset_n, led);

   input clk, reset_n;
   output reg led;

   /**
    * Main frequency 50MHz, 0.25s on, 0.5s down, 0.75s on, 1s down
    * 50MHz * (0.25s + 0.5s + 0.75s + 1s) = 125M = 0111 0111 0011 0101 1001 0100 0000
    */
   reg [26:0] counter;

   parameter TIME_UNIT_MS = 1000;
   parameter CNT_MAX = `CNT_MAX * TIME_UNIT_MS;

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

   reg [3:0] counter1;

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         counter1 <= 0;
      else if ((counter == 0) || (counter == CNT_MAX)) begin
         if (counter1 == 10)
            counter1 <= 1;
         else
            counter1 <= counter1 + 1'd1;
      end
   end

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         led <= 0;
      else begin
         case (counter1)
            0 : led <= 1'd1;
            1 : led <= 1'd0;
            2 : led <= 1'd0;
            3 : led <= 1'd1;
            4 : led <= 1'd1;
            5 : led <= 1'd1;
            6 : led <= 1'd0;
            7 : led <= 1'd0;
            8 : led <= 1'd0;
            9 : led <= 1'd0;
            10 : led <= 1'd1;
            default: led <= led;
         endcase
      end
   end

endmodule
