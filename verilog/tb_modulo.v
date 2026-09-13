module tb_bcd7seg;
    reg  [3:0] bcd;
    wire [6:0] seg_base, seg_hex;
    wire       e_base, e_hex;

    bcd7seg     u_base (.bcd(bcd), .seg(seg_base), .E(e_base));
    bcd7seg_hex u_hex  (.bcd(bcd), .seg(seg_hex),  .E(e_hex));

    integer i;
    initial begin
        $dumpfile("tb.vcd");
        $dumpvars(0, tb_bcd7seg);

        $display("=== Decodificador BCD 7 segmentos ===");
        $display("bcd | D3D2D1D0 | base: seg     E | hex: seg     E");
        for (i = 0; i < 16; i = i + 1) begin
            bcd = i[3:0];
            #10;
            $display("%2d  |   %b   | %b  %b | %b  %b",
                     bcd, bcd, seg_base, e_base, seg_hex, e_hex);
        end
        $finish;
    end
endmodule
