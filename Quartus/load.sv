
module load(
	input logic [31:0]	ReadData,
	input logic [1:0]		ByteOffset,
	input logic [2:0]		LdStrSrc,
	output logic [31:0]	LoadExt
);

	logic [31:0]	ByteSign, ByteZero;	//Byte extension
	logic [31:0]	HalfSign, HalfZero;	//Half extension
	logic [7:0]		Byte;
	logic [15:0]	Half;

	always_comb begin
		//mux selects Byte
		case(ByteOffset)
			2'b00:	Byte = ReadData[7:0];
			2'b01:	Byte = ReadData[15:8];
			2'b10:	Byte = ReadData[23:16];
			2'b11:	Byte = ReadData[31:24];
			default:	Byte = 8'd0;
		endcase
		//mux selects Half
		case(ByteOffset[1])
			2'b0:		Half = ReadData[15:0];
			2'b1:		Half = ReadData[31:16];
			default:	Half = 16'd0; 
		endcase
	end
	
	//extend Byte 8 to 32 bits
	assign ByteSign = {{24{Byte[7]}}, Byte};
	assign ByteZero = {24'd0, Byte};
	//extend half 16 to 32 bits
	assign HalfSign = {{16{Half[15]}}, Half};
	assign HalfZero = {16'd0, Half};
	
	always_comb
		case(LdStrSrc)
			3'b000:	LoadExt = ByteSign;
			3'b001:	LoadExt = HalfSign;
			3'b010:	LoadExt = ReadData;
			3'b100:	LoadExt = ByteZero;
			3'b101:	LoadExt = HalfZero;
			default:	LoadExt = 32'd0;
		endcase
	
endmodule