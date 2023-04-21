module AudioController(
    input        clk, 		
    input        micData,	
    input[3:0]   switches,	
    output       micClk, 	
    output       chSel,		
    output       audioOut,	
    output       audioEn);	

	localparam MHz = 1000000;
	localparam SYSTEM_FREQ = 100*MHz; // System clock frequency

	
	wire[6:0] duty_cycle, max, min;
	assign max = 7'd75;
	assign min = 7'd25;

	assign duty_cycle = desiredClock ? max : min;

	PWMSerializer PWM(clk, 1'b0, duty_cycle, audioOut);

	wire[17:0] counterLimit;

	assign counterLimit = SYSTEM_FREQ / (2*FREQs[switches]);

	reg desiredClock = 0;
	reg[17:0] counter = 0;
	always @(posedge clk) begin
		if(counter < counterLimit)
			counter <= counter + 1;
		else begin
			counter <= 0;
			desiredClock <= ~desiredClock;
		end
	end



	

endmodule