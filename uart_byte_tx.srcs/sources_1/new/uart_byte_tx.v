`timescale 1ns / 1ps
`define MCNT_BAUD (5208)
`define MCNT_DLY (50_000_000)

module uart_byte_tx(clk, reset_n, data, uart_tx, led);

   input clk, reset_n;
   input [7:0] data;
   output reg uart_tx, led;

   parameter MCNT_BAUD = `MCNT_BAUD;
   parameter MCNT_DLY = `MCNT_DLY;

   // Delay counter
   reg [25:0] delay_count;

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         delay_count <= 0;
      else if (delay_count == MCNT_DLY)
         delay_count <= 1'd1;
      else
         delay_count <= delay_count + 1'd1;
   end

   // Baud counter, 9600, 1/9600 s *50MHz = 5208, 0001 010 001 011 000
   reg [12:0]baud_div_cnt;
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
      // if (!reset_n)
      //    r_data <= 0;
      // else if (delay_count == MCNT_DLY)
      //    r_data <= data;
      // else
      //    r_data <= r_data;
      if (delay_count == MCNT_DLY)
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

   // Led flip
   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         led <= 1'd0;
      else if ((bit_cnt == 9) && (baud_div_cnt == MCNT_BAUD))
         led <= !led;
   end

   always @(posedge clk or negedge reset_n) begin
      if (!reset_n)
         en_baud_cnt <= 1'd0;
      else if (delay_count == (MCNT_DLY - 1))
         en_baud_cnt <= 1'd1;
      else if ((bit_cnt == 9) && (baud_div_cnt == MCNT_BAUD))
         en_baud_cnt <= 1'd0;
   end

endmodule
