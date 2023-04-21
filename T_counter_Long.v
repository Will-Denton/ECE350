module T_counter_Long(out, clock, reset);

    input clock, reset;
    output[31:0] out;

    wire high;
    assign high = 1'b1;

    wire tff_out_1, tff_out_2, tff_out_3, tff_out_4, tff_out_5;

    T_flip_flop tff1(tff_out_1, high, clock, reset);
    T_flip_flop tff2(tff_out_2, tff_out_1, clock, reset);
    T_flip_flop tff3(tff_out_3, tff_out_1 && tff_out_2, clock, reset);
    T_flip_flop tff4(tff_out_4, tff_out_1 && tff_out_2 && tff_out_3, clock, reset);
    T_flip_flop tff5(tff_out_5, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4, clock, reset);
    T_flip_flop tff6(tff_out_6, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5, clock, reset);
    T_flip_flop tff7(tff_out_7, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6, clock, reset);
    T_flip_flop tff8(tff_out_8, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7, clock, reset);
    T_flip_flop tff9(tff_out_9, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8, clock, reset);
    T_flip_flop tff10(tff_out_10, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9, clock, reset);
    T_flip_flop tff11(tff_out_11, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10, clock, reset);
    T_flip_flop tff12(tff_out_12, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11, clock, reset);
    T_flip_flop tff13(tff_out_13, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12, clock, reset);
    T_flip_flop tff14(tff_out_14, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13, clock, reset);
    T_flip_flop tff15(tff_out_15, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14, clock, reset);
    T_flip_flop tff16(tff_out_16, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15, clock, reset);
    T_flip_flop tff17(tff_out_17, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16, clock, reset);
    T_flip_flop tff18(tff_out_18, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16 && tff_out_17, clock, reset);
    T_flip_flop tff19(tff_out_19, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16 && tff_out_17 && tff_out_18, clock, reset);
    T_flip_flop tff20(tff_out_20, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16 && tff_out_17 && tff_out_18 && tff_out_19, clock, reset);       
    T_flip_flop tff21(tff_out_21, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16 && tff_out_17 && tff_out_18 && tff_out_19 && tff_out_20, clock, reset);
    T_flip_flop tff22(tff_out_22, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16 && tff_out_17 && tff_out_18 && tff_out_19 && tff_out_20 && tff_out_21, clock, reset);
    T_flip_flop tff23(tff_out_23, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16 && tff_out_17 && tff_out_18 && tff_out_19 && tff_out_20 && tff_out_21 && tff_out_22, clock, reset);
    T_flip_flop tff24(tff_out_24, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16 && tff_out_17 && tff_out_18 && tff_out_19 && tff_out_20 && tff_out_21 && tff_out_22 && tff_out_23, clock, reset);
    T_flip_flop tff25(tff_out_25, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16 && tff_out_17 && tff_out_18 && tff_out_19 && tff_out_20 && tff_out_21 && tff_out_22 && tff_out_23 && tff_out_24, clock, reset);
    T_flip_flop tff26(tff_out_26, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16 && tff_out_17 && tff_out_18 && tff_out_19 && tff_out_20 && tff_out_21 && tff_out_22 && tff_out_23 && tff_out_24 && tff_out_25, clock, reset);
    T_flip_flop tff27(tff_out_27, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16 && tff_out_17 && tff_out_18 && tff_out_19 && tff_out_20 && tff_out_21 && tff_out_22 && tff_out_23 && tff_out_24 && tff_out_25 && tff_out_26, clock, reset);
    T_flip_flop tff28(tff_out_28, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16 && tff_out_17 && tff_out_18 && tff_out_19 && tff_out_20 && tff_out_21 && tff_out_22 && tff_out_23 && tff_out_24 && tff_out_25 && tff_out_26 && tff_out_27, clock, reset);
    T_flip_flop tff29(tff_out_29, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16 && tff_out_17 && tff_out_18 && tff_out_19 && tff_out_20 && tff_out_21 && tff_out_22 && tff_out_23 && tff_out_24 && tff_out_25 && tff_out_26 && tff_out_27 && tff_out_28, clock, reset);
    T_flip_flop tff30(tff_out_30, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16 && tff_out_17 && tff_out_18 && tff_out_19 && tff_out_20 && tff_out_21 && tff_out_22 && tff_out_23 && tff_out_24 && tff_out_25 && tff_out_26 && tff_out_27 && tff_out_28 && tff_out_29, clock, reset);
    T_flip_flop tff31(tff_out_31, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16 && tff_out_17 && tff_out_18 && tff_out_19 && tff_out_20 && tff_out_21 && tff_out_22 && tff_out_23 && tff_out_24 && tff_out_25 && tff_out_26 && tff_out_27 && tff_out_28 && tff_out_29 && tff_out_30, clock, reset);      
    T_flip_flop tff32(tff_out_32, tff_out_1 && tff_out_2 && tff_out_3 && tff_out_4 && tff_out_5 && tff_out_6 && tff_out_7 && tff_out_8 && tff_out_9 && tff_out_10 && tff_out_11 && tff_out_12 && tff_out_13 && tff_out_14 && tff_out_15 && tff_out_16 && tff_out_17 && tff_out_18 && tff_out_19 && tff_out_20 && tff_out_21 && tff_out_22 && tff_out_23 && tff_out_24 && tff_out_25 && tff_out_26 && tff_out_27 && tff_out_28 && tff_out_29 && tff_out_30 && tff_out_31, clock, reset);
    
    assign out[0] = tff_out_1;
    assign out[1] = tff_out_2;
    assign out[2] = tff_out_3;
    assign out[3] = tff_out_4;
    assign out[4] = tff_out_5;
    assign out[5] = tff_out_6;
    assign out[6] = tff_out_7;
    assign out[7] = tff_out_8;
    assign out[8] = tff_out_9;
    assign out[9] = tff_out_10;
    assign out[10] = tff_out_11;
    assign out[11] = tff_out_12;
    assign out[12] = tff_out_13;
    assign out[13] = tff_out_14;
    assign out[14] = tff_out_15;
    assign out[15] = tff_out_16;
    assign out[16] = tff_out_17;
    assign out[17] = tff_out_18;
    assign out[18] = tff_out_19;
    assign out[19] = tff_out_20;
    assign out[20] = tff_out_21;
    assign out[21] = tff_out_22;
    assign out[22] = tff_out_23;
    assign out[23] = tff_out_24;
    assign out[24] = tff_out_25;
    assign out[25] = tff_out_26;
    assign out[26] = tff_out_27;
    assign out[27] = tff_out_28;
    assign out[28] = tff_out_29;
    assign out[29] = tff_out_30;
    assign out[30] = tff_out_31;
    assign out[31] = tff_out_32;

endmodule