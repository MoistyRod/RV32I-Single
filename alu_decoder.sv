
module alu_decoder(
	input logic [2:0] 	funct3,
	input logic 			funct7,
	input logic 			op5,
	input logic [1:0] 	ALUOp,
	//output
	output logic [3:0] 	ALUControl
);

	logic addi, slt;
	
	assign addi = ~(op5 | (|funct3));				//instruction is addi if op5 and funct3 bits are all 0
	assign slt	= ~(funct3[2]) & funct3[1];		//instruction is slt/i/u/iu if funct3[2:1] is 01
	
	always_comb
		casez(ALUOp)
			2'b00: ALUControl = 4'b0000;
			2'b01: ALUControl = 4'b0001;
			2'b1?:
				if (addi)
					ALUControl = {funct3, 1'b0};		//funct7 should equal 0 for addition if addi
				else if (slt)
					ALUControl = {funct3, 1'b1};		//funct7 should equal 1 for subtraction as slt uses flags
				else
					ALUControl = {funct3, funct7};
			default:	ALUControl = 4'b0;
		endcase

endmodule
					