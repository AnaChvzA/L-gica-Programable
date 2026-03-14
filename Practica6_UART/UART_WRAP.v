module UART_WRAP_Tx (
	input CLOCK_50,
	input MAX10_CLK1_50,
	input [0:0] KEY,
	input [9:0] SW,
	inout [5:0] GPIO,
	output [0:6] HEX0, 
	output [0:6] HEX1,
	output [0:6] HEX2, 
	output [0:6] HEX3
	
);

UART_Tx #(.BAUD_RATE(9600), .CLOCK_FREQ(50000000), .BITS(8)) WRAP_Tx (
	.clk(CLOCK_50),
	.rst(~KEY[0]),
	.start(SW[0]),
	.data_in(SW[4:1]),
	.tx_out(GPIO[0])
);

endmodule 

