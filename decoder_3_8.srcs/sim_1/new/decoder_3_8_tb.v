`timescale 1ns / 1ps

module decoder_3_8_tb();

    reg a0, a1, a2;
    wire y0, y1, y2, y3, y4, y5, y6, y7;

    decoder_3_8 decoder_3_8_i(a0, a1, a2,
                    y0, y1, y2, y3, y4, y5, y6, y7);

    initial begin
        a2 = 0; a1 = 0; a0 = 0;
        #20;
        a2 = 0; a1 = 0; a0 = 1;
        #20;
        a2 = 0; a1 = 1; a0 = 0;
        #20;
        a2 = 0; a1 = 1; a0 = 1;
        #20;
        a2 = 1; a1 = 0; a0 = 0;
        #20;
        a2 = 1; a1 = 0; a0 = 1;
        #20;
        a2 = 1; a1 = 1; a0 = 0;
        #20;
        a2 = 1; a1 = 1; a0 = 1;
        #20;
        $stop;
    end

endmodule
