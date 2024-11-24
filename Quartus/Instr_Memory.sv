
module Instr_Memory(
	input logic [31:0]	a,
	output logic [31:0]	rd
);

	//255x 32-bit words
	logic [31:0] memory[255:0];
	
	//read hexadecimal instructions from path into memory
	initial
		$readmemh("instruction_memory/rv32i_simple_test(instr_only).txt", memory);
	
	//word aligned memory
	assign rd = memory[a[31:2]];
	
endmodule