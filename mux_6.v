module mux_6(out0, select, in0, in1, in2, in3, in4, in5);
    input [2:0] select;
    input [31:0] in0, in1, in2, in3, in4, in5;
    output [31:0] out0;
    wire [31:0] w1, w2;

    mux_4 m00(w1, select[1:0], in0, in1, in2, in3);
    mux_2 m01(w2, select[0], in4, in5);
    mux_2 m10(out0, select[2], w1, w2);
endmodule