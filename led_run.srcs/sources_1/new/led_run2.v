`timescale 1ns / 1ps
`define CNT_MAX (25_000_000)
// `define CNT_MAX (25_000)

module led_run2(clk, reset_n, led);

    input clk, reset_n;
    output wire [7:0] led;
    /**
     * Main frequency 50MHz, 0.5s twinkle cycle
     * 50MHz * 0.5s = 25M = 0001 0111 1101 0111 1000 0100 0000
     */
   reg [24:0] counter;

   parameter CNT_MAX = `CNT_MAX;

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         counter <= 0;
      /**
       * Not set (`CNT_MAX - 1) here to make the first 0.5s not to be
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

   reg [2:0] state;
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         state <= 0;
      else if (counter == CNT_MAX)
         state <= state + 1'd1;
   end


   decoder_3_8 decoder_3_8_i(state[0], state[1], state[2],
                             led[0], led[1], led[2], led[3],
                             led[4], led[5], led[6], led[7]);

endmodule
