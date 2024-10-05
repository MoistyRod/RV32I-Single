
module main_decoder(
	input logic [6:0] 	op,
	//output
	output logic 			MemWrite, PCTargetSrc,
	output logic 			ALUSrcA, ALUSrcB,
	output logic 			RegWrite,
	output logic [1:0] 	ResultSrc,
	output logic [2:0] 	ImmSrc,
	output logic 			Branch, Jump,
	output logic [1:0] 	ALUOp
);

	logic [13:0] controls;
	
	assign {Jump, Branch, ALUOp, ImmSrc, RegWrite, PCTargetSrc, ALUSrcA, ALUSrcB, ResultSrc, MemWrite} = controls;
	
	always_comb
		casez(op)
			7'b0000011: controls = 14'b0_0_00_000_1_?_0_1_01_0;	//load instructions
			7'b0010011: controls = 14'b0_0_1?_000_1_?_0_1_00_0;	//I-type ALU instructions
			7'b0010111: controls = 14'b0_0_??_011_1_0_?_?_11_0;	//auipc
			7'b0100011: controls = 14'b0_0_00_001_0_?_0_1_??_1;	//store instructions
			7'b0110011: controls = 14'b0_0_1?_???_1_?_0_0_00_0; 	//R-type ALU instructions
			7'b0110111: controls = 14'b0_0_00_011_1_?_1_1_00_0;	//lui
			7'b1100011:	controls = 14'b0_1_01_010_0_0_0_0_10_0;	//Branch instructions
			7'b1100111: controls = 14'b1_0_??_000_1_1_?_?_10_0;	//jalr
			7'b1101111:	controls = 14'b1_0_??_100_1_0_?_?_10_0;	//jal
			default: 	controls = 14'b?_?_??_???_?_?_?_?_??_?;
		endcase
	
endmodule
			