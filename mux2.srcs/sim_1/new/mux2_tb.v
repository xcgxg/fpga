`timescale 1ns / 1ps

module mux2_tb();

reg s0, s1, s2;
wire out;

mux2 mux2_i(s0, s1, s2, out);

initial begin
    s2 = 0; s1 = 0; s0 = 0;
    #20;
    s2 = 0; s1 = 0; s0 = 1;
    #20;
    s2 = 0; s1 = 1; s0 = 0;
    #20;
    s2 = 0; s1 = 1; s0 = 1;
    #20;
    s2 = 1; s1 = 0; s0 = 0;
    #20;
    s2 = 1; s1 = 0; s0 = 1;
    #20;
    s2 = 1; s1 = 1; s0 = 0;
    #20;
    s2 = 1; s1 = 1; s0 = 1;
    #20;
end

endmodule
