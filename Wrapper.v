`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper(clk, reset, BTNC, LED, MotorOut, ctrl_ultrasonic, ultrasonic_in);

	input clk, reset;
	input BTNC;
	output[15:0] LED;
	output[7:0] MotorOut;
	output ctrl_ultrasonic;
	input ultrasonic_in;

	assign counterLimit = 18'd0; //50MHz
	reg clock = 0;
	reg[17:0] counter = 0;
	always @(posedge clk) begin
		if(counter < counterLimit)
			counter <= counter + 1;
		else begin
			counter <= 0;
			clock <= ~clock;
		end
	end

	wire ctrl_ultrasonic;

	wire[31:0] timer_out;
	T_counter_Long TCL(timer_out, clk, (timer_out > 32'd20000000));

	assign ctrl_ultrasonic = (timer_out <= 32'd1000);

	reg[31:0] counter2 = 0;

	reg [31:0] ultrasonicData = 0;  
	reg counting = 0;              

	always @(posedge clock) begin
		if (ultrasonic_in && !counting) begin
			counting <= 1;  
			counter2 <= 0;  
		end else if (!ultrasonic_in && counting) begin
			counting <= 0;          
			ultrasonicData <= counter2 + 1;  
		end
		if (counting) begin
			counter2 <= counter2 + 1;  
		end
	end

	// wire [31:0] ultrasonicData;
	// register ultrasonicReg(ultrasonicData, !ultrasonic_in, clk, counter2, reset);

	assign LED[0] = (ultrasonicData >= 32'd11662);
	assign LED[1] = (ultrasonicData >= 32'd23324);
	assign LED[2] = (ultrasonicData >= 32'd34986);
	assign LED[3] = (ultrasonicData >= 32'd46648);
	assign LED[4] = (ultrasonicData >= 32'd58310);
	assign LED[5] = (ultrasonicData >= 32'd69972);
	assign LED[6] = (ultrasonicData >= 32'd81634);
	assign LED[7] = (ultrasonicData >= 32'd93296);
	assign LED[8] = (ultrasonicData >= 32'd104958);
	assign LED[9] = (ultrasonicData >= 32'd116620);
	assign LED[10] = (ultrasonicData >= 32'd128282);
	assign LED[11] = (ultrasonicData >= 32'd139944);
	assign LED[12] = (ultrasonicData >= 32'd151606);
	assign LED[13] = (ultrasonicData >= 32'd163268);
	assign LED[14] = (ultrasonicData >= 32'd174930);
	assign LED[15] = (ultrasonicData >= 32'd186592);

	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;

	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "motor_home";
	
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut),
		
		// Output
		.motor_out(MotorOut)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
		
	// Register File
	wire[4:0] tempLED;
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
		.BTNC(BTNC), .LED(tempLED));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

endmodule
