
module Data_Memory(
	input logic				clk,
	input logic [31:0] 	a, wd,
	input logic 			we,
	output logic [31:0]	rd
);
	
	//255x 32-bit word
	logic [31:0] memory[255:0];
	
	//byte aligned memory
	assign rd = memory[a[31:2]];
	
	//if WriteMem = 1, WriteData is stored in memory[DataAdr]
	always @(posedge clk)
		if (we)
			memory[a[31:2]] <= wd;
	
endmodule