
module RV32I_Single(
	input logic 			reset, clk,
	input logic [31:0] 	Instr, ReadData,
	//output
	output logic [31:0] 	PC, DataAdr, WriteData,
	output logic 			MemWrite,
	//to testbench
	output logic [31:0]	PCNext, Result
);
	
	logic [2:0] ImmSrc, LdStrSrc;
	logic 		PCSrc, RegWrite, PCTargetSrc, ALUSrcA, ALUSrcB;
	logic [3:0] ALUControl;
	logic [1:0] ResultSrc;
	logic 		eq, lt, ltu;	//ALU flags
	
	//Instantiate controller
	controller c(
		.op(Instr[6:0]), .funct3(Instr[14:12]), .funct7(Instr[30]),
		.eq(eq), .lt(lt), .ltu(ltu),
		//outputs
		.RegWrite(RegWrite), .ImmSrc(ImmSrc), .PCTargetSrc(PCTargetSrc),
		.ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ALUControl(ALUControl),
		.LdStrSrc(LdStrSrc), .ResultSrc(ResultSrc), .PCSrc(PCSrc), .MemWrite(MemWrite)
	);
	
	//Instantiate datapath
	datapath dp(
		.reset(reset), .clk(clk),
		.a1(Instr[19:15]), .a2(Instr[24:20]), .a3(Instr[11:7]), .Imm(Instr[31:7]),
		.RegWrite(RegWrite), .ImmSrc(ImmSrc), .PCTargetSrc(PCTargetSrc),
		.ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ALUControl(ALUControl),
		.LdStrSrc(LdStrSrc), .ResultSrc(ResultSrc), .PCSrc(PCSrc), .ReadData(ReadData),
		//outputs
		.eq(eq), .lt(lt), .ltu(ltu),
		.ALUResult(DataAdr), .WriteData(WriteData),
		.PC(PC),
		//to testbench
		.PCNext(PCNext), .Result(Result)
	);

endmodule
				  
