`timescale 1ns / 1ps

module mux2(a, b, sel, out);

   input a, b, sel;
   output out;

   assign out = (sel == 0) ? a : b;

endmodule
