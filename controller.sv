
module controller(
	input logic 		eq, lt, ltu,
	input logic [6:0] op,
	input logic [2:0]	funct3,
	input logic funct7,
	//output
	output logic 			PCSrc, MemWrite, 
	output logic 			ALUSrcA, ALUSrcB,
	output logic 			PCTargetSrc, RegWrite,
	output logic [1:0] 	ResultSrc,
	output logic [2:0] 	LdStrSrc, ImmSrc,
	output logic [3:0] 	ALUControl
);
	
	logic 		Branch, Jump;
	logic [1:0] ALUOp;

	//instantiate main decoder
	main_decoder md(
		.op(op),
		//output
		.ResultSrc(ResultSrc), .MemWrite(MemWrite),
		.ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
		.PCTargetSrc(PCTargetSrc), .ImmSrc(ImmSrc),
		.RegWrite(RegWrite), 
		//to alu decoder
		.ALUOp(ALUOp),
		//to branch jump decoder
		.Branch(Branch), .Jump(Jump)
	);
		
	//Instantiate branch/jump decoder
	brchjmp_decoder bjd(
		.eq(eq), .lt(lt), .ltu(ltu),
		.Branch(Branch), .Jump(Jump),
		.funct3(funct3),
		//output
		.PCSrc(PCSrc)
	);
		
	//Instantiate ALU decoder
	alu_decoder ad(
		.ALUOp(ALUOp),
		.op5(op[5]),
		.funct3(funct3), .funct7(funct7),
		//output
		.ALUControl(ALUControl)
	);
		
	assign LdStrSrc = funct3;

endmodule
	

	