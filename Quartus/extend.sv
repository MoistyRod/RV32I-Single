
module extend(
	input logic [24:0] 	Imm,
	input logic [2:0] 	ImmSrc,
	output logic [31:0]	ImmExt
);

	always_comb
		case(ImmSrc)
			3'b000:	ImmExt = {{21{Imm[24]}}, Imm[23:13]};												//I-type
			3'b001:	ImmExt = {{21{Imm[24]}}, Imm[23:18], Imm[4:0]};									//S-type
			3'b010:	ImmExt = {{20{Imm[24]}}, Imm[0], Imm[23:18], Imm[4:1], 1'b0};				//B-type
			3'b011:	ImmExt = {Imm[24:5], 12'b0};															//U-type
			3'b100:	ImmExt = {{12{Imm[24]}}, Imm[12:5], Imm[13], Imm[23:14], 1'b0};			//J-type
			default:	ImmExt = 32'bx;
		endcase

endmodule