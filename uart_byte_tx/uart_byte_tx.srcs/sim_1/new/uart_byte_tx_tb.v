`timescale 1ns / 1ps
// 10ms
`define MCNT_DLY (500_000)

module uart_byte_tx_tb();

   reg clk, reset_n;
   reg [7:0] data;
   wire uart_tx, led;

   uart_byte_tx uart_byte_tx_i(clk, reset_n, data, uart_tx, led);
   defparam uart_byte_tx_i.MCNT_DLY = `MCNT_DLY;

   initial clk = 1;
   always #10 clk = ~clk;
   initial begin
      reset_n = 0;
      // data = 8'b0101_0101;
      // data = 8'b1010_1010;
      #201;
      reset_n = 1;
      data = 8'b0101_0101;
      // 30ms
      #30_000_000;
      data = 8'b1010_1010;
      // 30ms
      #30_000_000;
      $stop;
   end

endmodule
