module UART_WRAP_Tx (
	input CLOCK_50,
	input [1:0] KEY,
	input [9:0] SW,
	output [5:0] GPIO,
	output [0:0] LEDR,
	output [0:6] HEX0, HEX1, HEX2, HEX3
);


UART_Tx WRAP(.clk(CLOCK_50), .rst(~KEY[0]), .data_in(SW[8:1]), .start(~KEY[1]), .tx_out(GPIO[0]), .busy(LEDR[0]));

BCD_4displays #(.N_in(10), .N_out(7)) BCD(
	.bcd_in({2'b00, SW[8:1]}), 
	.D_un(HEX0),
	.D_de(HEX1),
	.D_ce(HEX2),
	.D_mi(HEX3)
);

endmodule