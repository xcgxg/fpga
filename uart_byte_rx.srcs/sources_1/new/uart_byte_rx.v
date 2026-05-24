`timescale 1ns / 1ps
`define MCNT_BAUD (5208)
`define BAUD (9600)
`define MCNT_FREQ (50_000_000)

module uart_byte_rx(clk, reset_n, uart_rx, rx_done, rx_data);

   input clk, reset_n, uart_rx;
   output reg rx_done;
   output reg [7:0] rx_data;
   wire w_rx_done;

   parameter BAUD = `BAUD;
   parameter MCNT_FREQ = `MCNT_FREQ;
   parameter MCNT_BAUD = MCNT_FREQ / BAUD;


   reg [1:0] dff_uart_rx;
   always @(posedge clk) begin
      dff_uart_rx[0] <= uart_rx;
   end
   always @(posedge clk) begin
      dff_uart_rx[1] <= dff_uart_rx[0];
   end

   // negedge uart_rx
   reg r_uart_rx;
   wire nedge_uart_byte_rx;

   always @(posedge clk) begin
      r_uart_rx <= dff_uart_rx[1];
   end
   assign nedge_uart_byte_rx = (dff_uart_rx[1] == 0) && (r_uart_rx == 1);

   // Baud counter
   reg [31:0] baud_div_cnt;
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

   // en_baud_cnt
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         en_baud_cnt <= 0;
      else if (nedge_uart_byte_rx)
         en_baud_cnt <= 1'd1;
      else if ((baud_div_cnt == MCNT_BAUD) && (bit_cnt == 9))
         // All bit received
         en_baud_cnt <= 0'd1;
      else if ((baud_div_cnt == (MCNT_BAUD / 2)) &&
               (bit_cnt == 0) && (dff_uart_rx[1] == 1))
         // Noisy start signal
         en_baud_cnt <= 0'd1;
   end

   // Store dff_uart_rx[1]
   reg [7:0] r_rx_data;

   always @(posedge clk or negedge reset_n) begin
      if (w_rx_done)
         rx_data <= r_rx_data;
   end

   // Rx
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         r_rx_data <= 8'd0;
      else if (en_baud_cnt == 0)
         r_rx_data <= 8'd0;
      else if (baud_div_cnt == (MCNT_BAUD / 2)) begin
         case (bit_cnt)
            1: r_rx_data[0] <= dff_uart_rx[1];
            2: r_rx_data[1] <= dff_uart_rx[1];
            3: r_rx_data[2] <= dff_uart_rx[1];
            4: r_rx_data[3] <= dff_uart_rx[1];
            5: r_rx_data[4] <= dff_uart_rx[1];
            6: r_rx_data[5] <= dff_uart_rx[1];
            7: r_rx_data[6] <= dff_uart_rx[1];
            8: r_rx_data[7] <= dff_uart_rx[1];
            default: r_rx_data <= r_rx_data;
         endcase
      end
   end

   // rx_done
   always @(posedge clk) begin
      rx_done <= w_rx_done;
   end
   assign w_rx_done = (bit_cnt == 9) && (baud_div_cnt == MCNT_BAUD);

endmodule
