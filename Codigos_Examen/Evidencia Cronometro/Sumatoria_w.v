module Sumatoria_w (
	input MAX10_CLK1_50,
	input [5:0] SW,
	input [1:0] KEY,
	output [0:6] HEX0, HEX1, HEX2, HEX3
	


);

wire [9:0] suma; //Para conectar la suma del modulo, maybe por eso no salia nada

Sumatoria sum(
	.clk(MAX10_CLK1_50),
	.rst(~KEY[1]),
	.start(SW[0]),
	.num(SW[4:1]),
	.suma(suma)
	

);


BCD_4displays #(.N_in(10)) bcd_suma (
	.bcd_in(suma), //que se vea la suma 
	.D_un(HEX0),
	.D_de(HEX1),
	.D_ce(HEX2),
	.D_mi(HEX3)

);


endmodule 













































