module practica4_w (
	input [1:0] KEY,
	input MAX10_CLK1_50,
	input [3:0] SW,
	output[0:6] HEX0,
	output[0:6] HEX1,
	output[0:6] HEX2,
	output[0:6] HEX3

);

practica4 WRAP (
	.clk(MAX10_CLK1_50),
	.SW(SW),
	.KEY(KEY[1:0]),
	.HEX0(HEX0),
	.HEX1(HEX1),
	.HEX2(HEX2),
	.HEX3(HEX3)


);

endmodule 