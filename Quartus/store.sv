
module store(
	input logic [31:0] 	rd2, ReadData,
	input logic [1:0]		ByteOffset, LdStrSrc,
	output logic [31:0]	WriteData
);

	always_comb
		case(LdStrSrc)
			2'b00:
				case(ByteOffset[1:0])
					2'b00:	WriteData = {ReadData[31:8], rd2[7:0]};
					2'b01:	WriteData = {ReadData[31:16], rd2[7:0], ReadData[7:0]};
					2'b10:	WriteData = {ReadData[31:24], rd2[7:0], ReadData[15:0]};
					2'b11:	WriteData = {rd2[7:0], ReadData[23:0]};
					default:	WriteData = ReadData;
				endcase
			2'b01:
				case(ByteOffset[1])
					1'b0:		WriteData = {ReadData[31:16], rd2[15:0]};
					1'b1:		WriteData = {rd2[15:0], ReadData[15:0]};
					default:	WriteData = ReadData;
				endcase
			2'b10:	WriteData = rd2;
			default:	WriteData = ReadData;
		endcase

endmodule