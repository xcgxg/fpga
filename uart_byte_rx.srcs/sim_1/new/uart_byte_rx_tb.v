`timescale 1ns / 1ps
// 10ms
`define MCNT_FREQ (500_000)

module uart_byte_rx_tb();

   reg clk, reset_n, uart_rx;
   wire rx_done;
   wire [7:0] rx_data;

   uart_byte_rx uart_byte_rx_i(clk, reset_n, uart_rx, rx_done, rx_data);
   // defparam uart_byte_tx_i.MCNT_FREQ = `MCNT_FREQ;

   initial clk = 1;
   always #10 clk = ~clk;
   initial begin
      reset_n = 0;
      uart_rx = 1;
      #201;
      reset_n = 1;
      #100;

      // Start bit
      uart_rx = 0;#(5208*20);
      // 8'b0101_0101;
      uart_rx = 0; #(5208*20);
      uart_rx = 1; #(5208*20);
      uart_rx = 0; #(5208*20);
      uart_rx = 1; #(5208*20);
      uart_rx = 0; #(5208*20);
      uart_rx = 1; #(5208*20);
      uart_rx = 0; #(5208*20);
      uart_rx = 1; #(5208*20);
      // End bit
      uart_rx = 1; #(5208*20);

      #(5208*20*10);

      // Start bit
      uart_rx = 0;#(5208*20);
      // 8'b1111_0101;
      uart_rx = 1; #(5208*20);
      uart_rx = 1; #(5208*20);
      uart_rx = 1; #(5208*20);
      uart_rx = 1; #(5208*20);
      uart_rx = 0; #(5208*20);
      uart_rx = 1; #(5208*20);
      uart_rx = 0; #(5208*20);
      uart_rx = 1; #(5208*20);
      // End bit
      uart_rx = 1; #(5208*20);

      $stop;
   end

endmodule
