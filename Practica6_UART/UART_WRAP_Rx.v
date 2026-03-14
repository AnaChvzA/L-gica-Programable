module UART_WRAP_Rx (
	input MAX10_CLK1_50,
	input [0:0] KEY,
	input [9:0] ARDUINO_IO,
	output [4:0] LEDR,
	output wire [0:6] HEX0, HEX1, HEX2, HEX3
	
);

wire [7:0] data_out;

UART_Rx WRAP(.clk(MAX10_CLK1_50), 
			.rst(~KEY[0]), 
			.rx_in(ARDUINO_IO[0]), 
			.data_ready(LEDR[0]), 
			.data_out(data_out)
);

BCD_4displays #(.N_in(10), .N_out(7)) BCD(
	.bcd_in({2'b00, data_out}), 
	.D_un(HEX0),
	.D_de(HEX1),
	.D_ce(HEX2),
	.D_mi(HEX3)

);
	
endmodule