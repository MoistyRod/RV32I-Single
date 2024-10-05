
module regfile(
	input logic 			clk,
	input logic 			we3,
	input logic	[4:0]		a1, a2, a3, 
	input logic [31:0]	wd3,
	output logic [31:0]	rd1, rd2
);

	//2D array of 32x 32-bit reg
	logic [31:0] rf[31:0];
	
	//write wd3 to register a3 if we3 is high and at rising edge of clk
	always_ff @(posedge clk)
		if (we3)
			rf[a3] <= wd3;
	
	//r0 = 0. rd1 = reg a1 if a1 != 0. Else rd1 = 0.
	assign rd1 = (a1 != 0) ? rf[a1] : 0;
	assign rd2 = (a2 != 0) ? rf[a2] : 0;
	
endmodule
	