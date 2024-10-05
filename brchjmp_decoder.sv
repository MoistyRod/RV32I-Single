
module brchjmp_decoder(
	input logic 		eq, lt, ltu,
	input logic 		Branch, Jump,
	input logic [2:0] funct3,
	//output
	output logic PCSrc
);

	logic flag;
	
	//branch conditions
	always_comb
		casez(funct3)
			3'b000:	flag = eq;
			3'b001:	flag = ~eq;
			3'b100:	flag = lt;
			3'b101:	flag = ~lt;
			3'b110:	flag = ltu;
			3'b111:	flag = ~ltu;
			default: flag = 1'b?;
		endcase
	
	assign PCSrc = Jump | (Branch & flag);		//select PCTarget for Jump instr or for Branch if its condition is met

endmodule