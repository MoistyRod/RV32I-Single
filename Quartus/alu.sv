
module alu(
	input logic [31:0]	a, b,
	input logic [3:0]		ALUControl,
	output logic [31:0]	ALUOut,
	output logic 			eq, lt, ltu
);

	logic 			v, c;
	logic [31:0]	sum;
	logic [31:0]	aorB, aandB, axorB;
	logic [31:0]	sll, srl, sra;
	logic [31:0]	Bsrc;

	
	always_comb begin	
		//add, subtract
		Bsrc 		= ALUControl[0] ? ~b : b;
		{c, sum} = Bsrc + a + ALUControl[0];
		
		//or, and, xor
		aorB 		= a | b;
		aandB 	= a & b;
		axorB 	= a ^ b;
		
		//shifters
		sll 		= a << b[4:0];
		srl 		= a >> b[4:0];
		sra 		= $signed(a) >>> b[4:0];
		
		//internal flags
		v			= axorB[31] & (a[31] ^ sum[31]);
		
		//flags
		lt 		= sum[31] ^ v;
		ltu 		= ~c;
		eq 		= ~|sum;
	end


	always_comb
		casez(ALUControl)
			4'b000?:	ALUOut = sum;						//select sum for add or sub
			4'b001?:	ALUOut = sll;
			4'b010?:	ALUOut = {{31{1'b0}}, lt};
			4'b011?:	ALUOut = {{31{1'b0}}, ltu};
			4'b100?:	ALUOut = axorB;
			4'b1010:	ALUOut = srl;
			4'b1011:	ALUOut = sra;
			4'b110?:	ALUOut = aorB;
			4'b111?:	ALUOut = aandB;
			default:	ALUOut = 32'bx;
		endcase

endmodule