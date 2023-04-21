module SLL(S, A, shamt);

    input [31:0] A;
    input [4:0] shamt;
    output [31:0] S;

    wire[31:0] w1, w2, w3, w4;

    wire[31:0] sll16A, sll8A, sll4A, sll2A, sll1A;
    SLL_16 sll16(sll16A, A);

    mux_2 mux16(w1, shamt[4], A, sll16A);
    SLL_8 sll8(sll8A, w1);  

    mux_2 mux8(w2, shamt[3], w1, sll8A);
    SLL_4 sll4(sll4A, w2);

    mux_2 mux4(w3, shamt[2], w2, sll4A);
    SLL_2 sll2(sll2A, w3);

    mux_2 mux2(w4, shamt[1], w3, sll2A);
    SLL_1 sll1(sll1A, w4);

    mux_2 mux1(S, shamt[0], w4, sll1A);


endmodule