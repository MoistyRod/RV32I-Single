
module testbench();

	logic	clk, reset;
	logic [31:0] PCNext, Result, PC;
	logic [95:0] testvectors[255:0];
	logic [31:0] PCNext_test, Result_test;	//sliced from test vector and used to compare values with result
	logic [31:0] fail_counter;	//counts the number of failed instructions
	
	//instantiate top level module
	top dut(
		.clk(clk), .reset(reset), 
		.PCNext(PCNext), .Result(Result), .PC(PC)
	);
	
	initial
		begin
			fail_counter = 0;	//initiialize fail counter
			$readmemh("instruction_memory/rv32i_simple_test.txt", testvectors);	//load test into testvectors
			reset <= 1;
			#22;
			reset <= 0;
		end
	
	always
		begin
			clk <= 1;
			#5;
			clk <= 0;
			#5;
		end
		
	assign {PCNext_test, Result_test} = testvectors[PC[31:2]][63:0];	//assign test vectors for current instruction
	
	always @(negedge clk)
		begin
			if (PCNext !== PCNext_test) begin	//test PCNext
				$display("%h : PCNext Failed. PCNext = %h. Expected = %h", PC, PCNext, PCNext_test);	//print error message for PCNext if it doesnt match expected output
				fail_counter++;
			end
				
			if (Result !== Result_test && Result_test !== 32'bx) begin	//design error occurs when Result does not match test vector and is not a "dont care" value
				$display("%h : Result Failed. Result = %h. Expected = %h", PC, Result, Result_test);	//print error message for Result
				fail_counter++;
			end
			
			if (PC === 32'h128) begin //end of test
				$display("Test concluded. %d instructions failed.", fail_counter);
				$stop;
			end
		end

endmodule
			