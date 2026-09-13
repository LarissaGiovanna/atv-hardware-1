`timescale 1ns/1ps

module bcd7seg (
    input  wire [3:0] d,
    output reg  [6:0] seg,
    output reg        E
);
    always @(*) begin
        case (d)
            4'd0:  begin seg = 7'b1111110; E = 1'b0; end
            4'd1:  begin seg = 7'b0110000; E = 1'b0; end
            4'd2:  begin seg = 7'b1101101; E = 1'b0; end
            4'd3:  begin seg = 7'b1111001; E = 1'b0; end
            4'd4:  begin seg = 7'b0110011; E = 1'b0; end
            4'd5:  begin seg = 7'b1011011; E = 1'b0; end
            4'd6:  begin seg = 7'b1011111; E = 1'b0; end
            4'd7:  begin seg = 7'b1110000; E = 1'b0; end
            4'd8:  begin seg = 7'b1111111; E = 1'b0; end
            4'd9:  begin seg = 7'b1111011; E = 1'b0; end
            4'd10: begin seg = 7'b0000000; E = 1'b1; end
            4'd11: begin seg = 7'b0000000; E = 1'b1; end
            4'd12: begin seg = 7'b0000000; E = 1'b1; end
            4'd13: begin seg = 7'b0000000; E = 1'b1; end
            4'd14: begin seg = 7'b0000000; E = 1'b1; end
            4'd15: begin seg = 7'b0000000; E = 1'b1; end
            default: begin
                 seg = 7'b0000000;
                 E   = 1'b1;
            end
        endcase
    end
endmodule

