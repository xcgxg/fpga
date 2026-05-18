`timescale 1ns / 1ps
`define MCNT_BAUD (5208)
`define BAUD (9600)
`define MCNT_FREQ (50_000_000)

module uart_byte_tx1(clk, reset_n, data, send_go, uart_tx, tx_done);

   input clk, reset_n, send_go;
   input [7:0] data;
   output reg uart_tx, tx_done;

   wire w_tx_done;


   parameter BAUD = `BAUD;
   parameter MCNT_FREQ = `MCNT_FREQ;
   parameter MCNT_BAUD = MCNT_FREQ / BAUD;


   // Baud counter, 9600, 1/9600 s * 50MHz = 5208, 001 010 001 011 000
   reg [31:0]baud_div_cnt;
   reg en_baud_cnt;

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         baud_div_cnt <= 0;
      else if (en_baud_cnt) begin
         if (baud_div_cnt == MCNT_BAUD)
            baud_div_cnt <= 1'd1;
         else
            baud_div_cnt <= baud_div_cnt + 1'd1;
      end else
         baud_div_cnt <= 0;
   end

   // Bit counter
   reg [3:0] bit_cnt;

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         bit_cnt <= 0;
      else if (baud_div_cnt == MCNT_BAUD) begin
         if (bit_cnt == 9)
            bit_cnt <= 0;
         else
            bit_cnt <= bit_cnt + 1'd1;
      end
   end

   // Fetch data
   reg [7:0] r_data;

   always @(posedge clk or negedge reset_n) begin
      if (send_go)
         r_data <= data;
   end

   // Tx
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         uart_tx <= 1'd1;
      else if (en_baud_cnt == 0)
         uart_tx <= 1'd1;
      else begin
         case (bit_cnt)
            0: uart_tx <= 1'd0;
            1: uart_tx <= r_data[0];
            2: uart_tx <= r_data[1];
            3: uart_tx <= r_data[2];
            4: uart_tx <= r_data[3];
            5: uart_tx <= r_data[4];
            6: uart_tx <= r_data[5];
            7: uart_tx <= r_data[6];
            8: uart_tx <= r_data[7];
            9: uart_tx <= 1'd1;
            default: uart_tx <= uart_tx;
         endcase
      end
   end

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         en_baud_cnt <= 1'd0;
      else if (send_go)
         en_baud_cnt <= 1'd1;
      else if (w_tx_done)
         en_baud_cnt <= 1'd0;
   end

   always @(posedge clk) begin
      tx_done = w_tx_done;
   end

   assign w_tx_done = (bit_cnt == 9) && (baud_div_cnt == MCNT_BAUD);

endmodule
