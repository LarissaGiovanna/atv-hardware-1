`timescale 1ns/1ps

module tb_modulo;

    reg  [3:0] d;
    wire [6:0] seg;
    wire       E;

    integer i;
    integer erros;

    reg [7:0] esperado [0:15];

    bcd7seg dut (
        .d   (d),
        .seg (seg),
        .E   (E)
    );

    initial begin
        esperado[0]  = {7'b1111110, 1'b0}; 
        esperado[1]  = {7'b0110000, 1'b0}; 
        esperado[2]  = {7'b1101101, 1'b0}; 
        esperado[3]  = {7'b1111001, 1'b0}; 
        esperado[4]  = {7'b0110011, 1'b0}; 
        esperado[5]  = {7'b1011011, 1'b0}; 
        esperado[6]  = {7'b1011111, 1'b0}; 
        esperado[7]  = {7'b1110000, 1'b0}; 
        esperado[8]  = {7'b1111111, 1'b0}; 
        esperado[9]  = {7'b1111011, 1'b0}; 
        esperado[10] = {7'b0000000, 1'b1}; 
        esperado[11] = {7'b0000000, 1'b1};
        esperado[12] = {7'b0000000, 1'b1};
        esperado[13] = {7'b0000000, 1'b1};
        esperado[14] = {7'b0000000, 1'b1};
        esperado[15] = {7'b0000000, 1'b1};
    end

    initial begin
        $dumpfile("onda.vcd");
        $dumpvars(0, tb_modulo);
    end

    initial begin
        erros = 0;
        $display("=== INICIO DOS TESTES: Decodificador BCD-7seg ===");
        $display(" d  | seg[6:0] a-g | E | esperado seg | esperado E | resultado");
        $display("----+--------------+---+--------------+------------+----------");

        for (i = 0; i < 16; i = i + 1) begin
            d = i[3:0];
            #10; 

            if ({seg, E} === esperado[i]) begin
                $display(" %2d | %b     | %b | %b     | %b          | PASS",
                          i, seg, E, esperado[i][7:1], esperado[i][0]);
            end else begin
                erros = erros + 1;
                $display(" %2d | %b     | %b | %b     | %b          | FALHA",
                          i, seg, E, esperado[i][7:1], esperado[i][0]);
            end
        end

        $display("----+--------------+---+--------------+------------+----------");
        if (erros == 0)
            $display("RESULTADO FINAL: PASS - todas as 16 combinacoes corretas.");
        else
            $display("RESULTADO FINAL: FALHA - %0d de 16 combinacoes incorretas.", erros);

        $finish;
    end

endmodule
