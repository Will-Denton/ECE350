/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB,                  // I: Data from port B of RegFile
	 
    // Output
    motor_out
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

    // Output
    output[7:0] motor_out;

    //PC and Counter
    wire stall, mult_stall; //STALL CONDITIONS
    wire stall_lw_bne = ((DX_Opcode == 5'b01000) && (FD_Opcode == 5'b00010)) && (DX_rd == FD_rd);
    assign stall = (((DX_Opcode == 5'b01000) && ((FD_rt == DX_rd) || ((FD_rs == DX_rd) && (FD_Opcode != 5'b00111))))) || stall_lw_bne;

    wire[31:0] inPC, outPC, outPCadder, PCadd;
    wire extra_stall;
    assign extra_stall = 1'b0;
	register PC(outPC, !stall && !mult_stall && !motor_stall && !wait_stall && !extra_stall, clock, inPC, reset);

    CLA_32 PC_adder(.S(outPCadder), .A(outPC), .B(32'b1), .cin(1'b0)); //S, c32, A, B, cin

    assign inPC = jump ? next_PC : outPCadder;

    assign address_imem = outPC;
    wire[31:0] PC_ins_out = jump ? 32'b0 : q_imem;

    //---------
    //FD and Regfile control
    //---------
    wire[31:0] outFD_IR, outFD_PC;
    latch FD(.inPC(outPC), .inIR(PC_ins_out), .outPC(outFD_PC), .outIR(outFD_IR), .clock(~clock), .reset(reset), .we(!stall && !mult_stall && !motor_stall && !wait_stall));

    wire[4:0] FD_Opcode, FD_rs, FD_rt, FD_rd;
    wire[26:0] FD_imm;
    assign FD_Opcode = outFD_IR[31:27];
    assign FD_imm = outFD_IR[26:0];
    assign FD_rd = outFD_IR[26:22];
    assign FD_rs = outFD_IR[21:17];
    assign FD_rt = outFD_IR[16:12];

    //If SW or jr then DX_B = Rd
    //NOTE LOOK AT WHICH REGISTERS GO WHERE FOR JR SW BNE BLT
    wire[4:0] reg_b_add;
    assign reg_b_add = (FD_Opcode == 5'b00111) || (FD_Opcode == 5'b00100) || (FD_Opcode == 5'b00010) || (FD_Opcode == 5'b00110) || (FD_Opcode == 5'b11000) ? FD_rd : FD_rt;
    wire[4:0] A_ex = (FD_Opcode == 5'b10110) ? 5'b11110 : FD_rs;

    assign ctrl_readRegA = A_ex;
    assign ctrl_readRegB = reg_b_add;

    //Motor move ins
    wire ctrl_motor = (FD_Opcode == 5'b11000) && !dff_motor_out;

    wire dff_motor_out, motor_done;
    dffe_ref motor_dff(dff_motor_out, (FD_Opcode == 5'b11000 && !motor_done), clock, 1'b1, 1'b0);
    
    assign motor_stall = (dff_motor_out);

    wire[31:0] motorBypass;
    assign motorBypass = (((DX_Opcode == 5'b00101) || (DX_Opcode == 5'b00111) || (DX_Opcode == 5'b00000)) && (DX_rd == A_ex)) ? alu_out : data_readRegA;

    wire[16:0] counterLimit2;
    assign counterLimit2 = ((100000)/180)*motorBypass + 25000; 

    wire[31:0] tm_out;
    T_counter_Long TCL(tm_out, clock, ctrl_motor);

    assign motor_done = tm_out > counterLimit2;

    assign motor_out[0] = (data_readRegB == 32'd1) ? dff_motor_out : 1'b0;
    assign motor_out[1] = (data_readRegB == 32'd2) ? dff_motor_out : 1'b0;
    assign motor_out[2] = (data_readRegB == 32'd3) ? dff_motor_out : 1'b0;
    assign motor_out[3] = (data_readRegB == 32'd4) ? dff_motor_out : 1'b0;
    assign motor_out[4] = (data_readRegB == 32'd5) ? dff_motor_out : 1'b0;
    assign motor_out[5] = (data_readRegB == 32'd6) ? dff_motor_out : 1'b0;
    assign motor_out[6] = (data_readRegB == 32'd7) ? dff_motor_out : 1'b0;
    assign motor_out[7] = (data_readRegB == 32'd8) ? dff_motor_out : 1'b0;

    //wait ins

    wire ctrl_wait = (FD_Opcode == 5'b11111) && !dff_wait_out;

    wire dff_wait_out, wait_done;
    dffe_ref wait_dff(dff_wait_out, (FD_Opcode == 5'b11111 && !wait_done), clock, 1'b1, 1'b0);
    
    assign wait_stall = (dff_wait_out);

    wire[31:0] counterLimit;
    assign counterLimit = (32'd50000)*FD_imm; 

    wire[31:0] tw_out;
    T_counter_Long TCLW(tw_out, clock, ctrl_wait);

    assign wait_done = tw_out > counterLimit;


    wire[31:0] FD_ins_out = stall || jump ? 32'b0 : outFD_IR;

    //---------
    //DX and ALU control
    //---------
    wire[31:0] outDX_IR, outDX_PC, outDX_A, outDX_B;
    latch DX(.inPC(outFD_PC), .inIR(FD_ins_out), .inA(data_readRegA), .inB(data_readRegB), .outPC(outDX_PC), .outIR(outDX_IR), .outA(outDX_A), .outB(outDX_B), .clock(~clock), .reset(reset), .we(!mult_stall && !motor_stall && !wait_stall));

    wire[4:0] DX_Opcode, DX_shamt, DX_ALU_op, DX_rs, DX_rt, DX_rd;
    assign DX_Opcode = outDX_IR[31:27];
    assign DX_rd = outDX_IR[26:22];
    assign DX_rs = outDX_IR[21:17];
    assign DX_rt = outDX_IR[16:12];
    assign DX_shamt = outDX_IR[11:7];
    assign DX_ALU_op = outDX_IR[6:2];

    wire[16:0] DX_half_imm;
    assign DX_half_imm = outDX_IR[16:0];

    wire[31:0] DX_imm; //Sign Extension
    assign DX_imm[31:17] = {DX_imm[16], DX_imm[16], DX_imm[16], DX_imm[16], DX_imm[16], DX_imm[16], DX_imm[16], DX_imm[16], DX_imm[16], DX_imm[16], DX_imm[16], DX_imm[16], DX_imm[16], DX_imm[16], DX_imm[16]};
    assign DX_imm[16:0] = DX_half_imm;

    wire[31:0] DX_big_imm = {5'b0, outDX_IR[26:0]};

    wire use_imm = ((DX_Opcode == 5'b00101) || (DX_Opcode == 5'b00111) || (DX_Opcode == 5'b01000)); //INSERT IMMEM CONTROL

    wire use_big_imm = (DX_Opcode == 5'b10101);

    wire[31:0] in_DX_B;
    assign in_DX_B = use_imm ? DX_imm : outDX_B;

    wire[4:0] alu_op; 
    assign alu_op = use_imm ? 5'b00000 : DX_ALU_op;

    wire[31:0] alu_out;
    wire is_NE, is_LT, alu_ovf;

    //Bypassing #1 & #2 (XM rd = DX rs) (MW rd = DX rs)
    wire[31:0] in_A_bypass_1, in_A_bypass_2;
    wire allow_bypass_A, sub_rd_1, sub_rd_2;
    wire[4:0] target_register;
    wire use_rd = (DX_Opcode == 5'b00100) || (DX_Opcode == 5'b00111) || (DX_Opcode == 5'b00010) || (DX_Opcode == 5'b00110);

    wire ins_from_bypass_XM = (XM_Opcode == 5'b00000) || (XM_Opcode == 5'b00101) || (XM_Opcode == 5'b01000);
    wire ins_from_bypass_MW = (MW_Opcode == 5'b00000) || (MW_Opcode == 5'b00101) || (MW_Opcode == 5'b01000);

    assign allow_bypass_A = (DX_Opcode == 5'b00000) || (DX_Opcode == 5'b00101) || (DX_Opcode == 5'b01000) || (DX_Opcode == 5'b00111) || (DX_Opcode == 5'b00010) || (DX_Opcode == 5'b00110);
    assign in_A_bypass_1 = (MW_rd == DX_rs) && allow_bypass_A && (DX_rs != 5'b00000) && ins_from_bypass_MW ? data_writeReg : outDX_A;
    assign in_A_bypass_2 = (XM_rd == DX_rs) && allow_bypass_A && (DX_rs != 5'b00000) && ins_from_bypass_XM ? XM_byp_out : in_A_bypass_1;

    //Bypassing #3 & #4 (XM rd = DX rt) (MW rd = DX rt)
    wire[31:0] in_B_bypass_1, in_B_bypass_2, final_in_B_bypass;
    wire allow_bypass_B = (DX_Opcode == 5'b00000) || (DX_Opcode == 5'b00100) || (DX_Opcode == 5'b00010) || (DX_Opcode == 5'b00110);
    assign target_register = use_rd ? DX_rd : DX_rt;    
    assign in_B_bypass_1 = (MW_rd == target_register) && allow_bypass_B && (target_register != 5'b00000) && ins_from_bypass_MW ? data_writeReg : in_DX_B;
    assign in_B_bypass_2 = (XM_rd == target_register) && allow_bypass_B && (target_register != 5'b00000) && ins_from_bypass_XM ? XM_byp_out : in_B_bypass_1;

    wire[31:0] DX_B_out_1 = (MW_rd == target_register) && (DX_Opcode == 5'b00111) && (target_register != 5'b00000) && ins_from_bypass_MW ? data_writeReg : outDX_B;
    wire[31:0] DX_B_out = (XM_rd == target_register) && (DX_Opcode == 5'b00111) && (target_register != 5'b00000) && ins_from_bypass_XM ? XM_byp_out : DX_B_out_1;

    alu ALU(.data_operandA(in_A_bypass_2), .data_operandB(in_B_bypass_2), .ctrl_ALUopcode(alu_op), .ctrl_shiftamt(DX_shamt), .data_result(alu_out), .isNotEqual(is_NE), .isLessThan(is_LT), .overflow(alu_ovf));

    wire[31:0] add_error, addi_error, sub_error;

    assign add_error = 32'd1;
    assign addi_error = 32'd2;
    assign sub_error = 32'd3;

    wire[31:0] first_error, error_out;

    assign first_error = (DX_ALU_op == 5'b00000) ? add_error : sub_error;
    assign error_out = (DX_Opcode == 5'b00101) ? addi_error : first_error;

    wire[31:0] ovf_IR;
    assign ovf_IR = {outDX_IR[31:27], 5'b11110, outDX_IR[21:0]};

    wire[31:0] next_IR_err, next_A1;
    assign next_IR_err = (((DX_Opcode == 5'b00000) || (DX_Opcode == 5'b00101)) && alu_ovf == 1'b1) ? ovf_IR : outDX_IR;
    assign next_A1 = (((DX_Opcode == 5'b00000) || (DX_Opcode == 5'b00101)) && alu_ovf == 1'b1) ? error_out : alu_out;

    wire[31:0] next_IR_1 = (DX_Opcode == 5'b10101) ? {5'b0, 5'b11110, 22'b0} : next_IR_err;
    wire[31:0] next_A = (DX_Opcode == 5'b10101) ? DX_big_imm : next_A1;

    //Jump and control

    wire[31:0] target_J = {5'b0, outDX_IR[26:0]};
    wire[31:0] target_I;

    CLA_32 add_PC_imm(.S(target_I), .A(outDX_PC), .B(DX_imm), .cin(1'b0));

    wire j_ne, j_lt;
    alu CONTROL(.data_operandA(in_B_bypass_2), .data_operandB(in_A_bypass_2), .ctrl_ALUopcode(5'b1), .isNotEqual(j_ne), .isLessThan(j_lt));

    //bypass r status
    wire[31:0] rs_byp_1 = (MW_rd == 5'b11110) && ins_from_bypass_MW ? data_writeReg : outDX_A;
    wire[31:0] rs_byp_2 = (XM_rd == 5'b11110) && ins_from_bypass_XM ? outXM_A : rs_byp_1;

    wire jump_bne = (DX_Opcode == 5'b00010) && j_ne;
    wire jump_blt = (DX_Opcode == 5'b00110) && j_lt;
    wire jump_ex =  (DX_Opcode == 5'b10110) && (rs_byp_2 != 32'b0);
    
    wire jump;
    assign jump = ((DX_Opcode == 5'b00001) || (DX_Opcode == 5'b00011) || (DX_Opcode == 5'b00100) || jump_bne || jump_blt || jump_ex) && (next_PC != outDX_PC);

    wire[31:0] DX_out_PC_A = (DX_Opcode == 5'b00011) ? outDX_PC : next_A;

    wire[31:0] target = (DX_Opcode == 5'b00001) || (DX_Opcode == 5'b00011) || (DX_Opcode == 5'b10110) ? target_J : target_I;

    wire[31:0] next_PC = (DX_Opcode == 5'b00100) ? in_B_bypass_2 : target;

    wire[31:0] outDX_PC_plus_one;
    CLA_32 addOnePC(.S(outDX_PC_plus_one), .A(outDX_PC), .B(32'b1), .cin(1'b0));

    //---------
    //multdiv
    //---------

    wire[31:0] mult_div_res;
    wire mult_div_exp, mult_div_ready;
    wire[4:0] mult_div_Opcode = outDX_IR[6:2];

    wire ctrl_mult, ctrl_div;
    assign ctrl_mult = (DX_Opcode == 5'b00000) && (mult_div_Opcode == 5'b00110) && !dff_out;
    assign ctrl_div =  (DX_Opcode == 5'b00000) && (mult_div_Opcode == 5'b00111)  && !dff_out;
    multdiv MultDivider(.data_operandA(in_A_bypass_2), .data_operandB(in_B_bypass_2), .ctrl_MULT(ctrl_mult), .ctrl_DIV(ctrl_div), .clock(clock), .data_result(mult_div_res), .data_exception(mult_div_exp), .data_resultRDY(mult_div_ready));

    wire dff_out;
    dffe_ref dff(dff_out, ((mult_div_Opcode == 5'b00110) || (mult_div_Opcode == 5'b00111)) && (DX_Opcode == 5'b00000) && !mult_div_ready, clock, 1'b1, 1'b0);

    assign mult_stall = ((mult_div_Opcode == 5'b00110) || (mult_div_Opcode == 5'b00111)) && !mult_div_ready && (DX_Opcode == 5'b00000);

    wire[31:0] md_exception = (mult_div_Opcode == 5'b00110) ? 32'd4 : 32'd5;

    wire[31:0] DX_A_out_1 = (mult_div_ready && dff_out) ? mult_div_res : DX_out_PC_A;
    wire[31:0] DX_A_out = (mult_div_ready && dff_out && mult_div_exp) ? md_exception : DX_A_out_1;

    wire[31:0] next_IR = (mult_div_ready && dff_out && mult_div_exp) ? {5'b0, 5'b11110, 22'b0} : next_IR_1;

    //---------
    //XM and Memory control
    //---------
    wire[31:0] outXM_IR, outXM_A, outXM_B;
    latch XM(.inIR(next_IR), .inA(DX_A_out), .inB(DX_B_out), .outIR(outXM_IR), .outA(outXM_A), .outB(outXM_B), .clock(~clock), .reset(reset), .we(!mult_stall && !motor_stall && !wait_stall));

    wire[4:0] XM_Opcode, XM_rd;
    assign XM_Opcode = outXM_IR[31:27];
    assign XM_rd = outXM_IR[26:22];

    assign address_dmem = outXM_A;
    assign wren = (XM_Opcode == 5'b00111);

    //Bypassing #5 (MW rd = XM rd)
    assign data = (MW_rd == XM_rd) ? data_writeReg : outXM_B;

    wire[31:0] XM_byp_out = (XM_Opcode == 5'b01000) ? q_dmem : outXM_A;

    //---------
    //MW and Writing control
    //---------
    wire[31:0] outMW_IR, outMW_A, outMW_B; //insert outMW_B
    latch MW(.inIR(outXM_IR), .inA(outXM_A), .inB(q_dmem), .outIR(outMW_IR), .outA(outMW_A), .outB(outMW_B), .clock(~clock), .reset(reset), .we(!mult_stall && !motor_stall && !wait_stall));

    wire[4:0] MW_Opcode, MW_rd;
    assign MW_Opcode = outMW_IR[31:27];
    assign MW_rd = outMW_IR[26:22];

    wire[31:0] data_out;

    assign data_out = (MW_Opcode == 5'b01000) ? outMW_B : outMW_A;
    wire[31:0] write_register = (MW_Opcode == 5'b00011) ? 5'b11111 : MW_rd;

    assign data_writeReg = data_out;
    assign ctrl_writeReg = write_register;

    assign ctrl_writeEnable = (MW_Opcode == 5'b00000) || (MW_Opcode == 5'b00101) || (MW_Opcode == 5'b01000) || (MW_Opcode == 5'b00011);

endmodule
