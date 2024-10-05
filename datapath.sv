
module datapath(
	input logic 			reset, clk,
	input logic [4:0] 	a1, a2, a3,
	input logic [24:0] 	Imm,
	input logic [31:0] 	ReadData,
	//control input
	input logic 			PCSrc,
	input logic 			ALUSrcA, ALUSrcB,
	input logic 			PCTargetSrc, RegWrite,
	input logic [1:0] 	ResultSrc,
	input logic [2:0] 	ImmSrc, LdStrSrc,
	input logic [3:0] 	ALUControl,
	//output
	output logic [31:0] 	ALUResult,
	output logic [31:0] 	WriteData,
	output logic [31:0] 	PC,
	output logic 			eq, lt, ltu,
	//to testbench
	output logic [31:0]	PCNext, Result
);
	
	logic [31:0] PCPlus4;
	logic [31:0] ImmExt, PCTarget, TargetSrcA;
	logic [31:0] rd1, rd2, SrcA, SrcB;
	logic [31:0] LoadExt;
	
	//PCNext logic (PCNext, PC, PCPlus4, PCTarget, TargetSrcA)
	flopr #(32)	pc_reg(.clk(clk), .reset(reset), .d(PCNext), .q(PC));
	assign PCPlus4 = PC + 3'd4;
	mux2	#(32)	target_mux(.d0(PC), .d1(rd1), .s(PCTargetSrc), .y(TargetSrcA));
	assign PCTarget = TargetSrcA + ImmExt;
	mux2 	#(32)	pcnext_mux(.d0(PCPlus4), .d1(PCTarget), .s(PCSrc), .y(PCNext));
	
	
	//Register File logic (rd1, rd2, ImmExt)
	regfile		rf(
		.clk(clk), .we3(RegWrite),
		.a1(a1), .a2(a2), .a3(a3), .wd3(Result),
		.rd1(rd1), .rd2(rd2)
	);
	extend		ext(.Imm(Imm), .ImmSrc(ImmSrc), .ImmExt(ImmExt));
	
	
	//ALU Logic (SrcA, SrcB, ALUResult)
	mux2	#(32)	srca_mux(.d0(rd1), .d1(32'd0), .s(ALUSrcA), .y(SrcA));
	mux2	#(32)	srcb_mux(.d0(rd2), .d1(ImmExt), .s(ALUSrcB), .y(SrcB));
	alu			alu(
		.a(SrcA), .b(SrcB),
		.ALUControl(ALUControl), .lt(lt), .ltu(ltu), .eq(eq),
		.ALUOut(ALUResult)
	);
	
	
	//Store and Load Logic (WriteData, LoadExt)
	store 		str(
		.rd2(rd2), .ReadData(ReadData), .ByteOffset(ALUResult[1:0]),
		.LdStrSrc(LdStrSrc[1:0]), .WriteData(WriteData));
	load 			ld(
		.ReadData(ReadData), .ByteOffset(ALUResult[1:0]),
		.LdStrSrc(LdStrSrc), .LoadExt(LoadExt));
	
	
	//Result Mux (Result)
	always_comb
		case(ResultSrc)
			2'b00:	Result = ALUResult;
			2'b01:	Result = LoadExt;
			2'b10:	Result = PCPlus4;
			2'b11:	Result = PCTarget;
			default:	Result = 32'd0;
		endcase

endmodule
	