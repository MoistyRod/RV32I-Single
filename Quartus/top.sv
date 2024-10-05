
module top(
	input logic 			clk, reset,
	//to testbench
	output logic [31:0]	PC, PCNext, Result
);
	
	logic [31:0] DataAdr, WriteData;
	logic MemWrite;
	logic [31:0] Instr, ReadData;
	
	//Instantiate rv32i single cycle datapath and controller
	RV32I_Single rvsingle(
		.clk(clk), .reset(reset), .Instr(Instr), .ReadData(ReadData),
		.MemWrite(MemWrite), .PC(PC), .DataAdr(DataAdr), .WriteData(WriteData),
		//to testbench
		.PCNext(PCNext), .Result(Result)
	);
	
	//Instantiate instruction memory
	Instr_Memory imem(
		.a(PC),
		.rd(Instr)
	);
	
	//Instantiate data memory
	Data_Memory dmem(
		.clk(clk), .we(MemWrite), .a(DataAdr), .wd(WriteData),
		.rd(ReadData)
	);
	
endmodule