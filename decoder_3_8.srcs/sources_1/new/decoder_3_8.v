`timescale 1ns / 1ps

module decoder_3_8(a0, a1, a2,
                   y0, y1, y2, y3, y4, y5, y6, y7);

    input a0, a1, a2;
    output reg y0, y1, y2, y3, y4, y5, y6, y7;

    always @(*) begin
        case ({a2, a1, a0})
            3'b000: {y7, y6, y5, y4, y3, y2, y1, y0} = 8'b0000_0001;
            3'd1: {y7, y6, y5, y4, y3, y2, y1, y0} = 8'b0000_0010;
            3'd2: {y7, y6, y5, y4, y3, y2, y1, y0} = 8'b0000_0100;
            3'd3: {y7, y6, y5, y4, y3, y2, y1, y0} = 8'b0000_1000;
            3'd4: {y7, y6, y5, y4, y3, y2, y1, y0} = 8'b0001_0000;
            3'd5: {y7, y6, y5, y4, y3, y2, y1, y0} = 8'b0010_0000;
            3'd6: {y7, y6, y5, y4, y3, y2, y1, y0} = 8'b0100_0000;
            3'd7: {y7, y6, y5, y4, y3, y2, y1, y0} = 8'b1000_0000;
            default: {y7, y6, y5, y4, y3, y2, y1, y0} = 8'b0000_0000;
        endcase
    end

endmodule
