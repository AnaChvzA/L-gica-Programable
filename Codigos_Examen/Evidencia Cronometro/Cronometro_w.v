module Cronometro_w (
	input MAX10_CLK1_50, 
	input [1:0] KEY, 
	output [0:6] HEX0, HEX1, HEX2, HEX3


);

wire [9:0] ms;
wire [5:0] seg;

Cronometro crono(
	.clk(MAX10_CLK1_50),
	.rst(~KEY[0]),
	.start_stop(~KEY[1]),
	.ms(ms),
	.seg(seg)

);

//Milisegundos en HEX0, HEX1

BCD_4displays #(.N_in(10)) bcd_ms (
	.bcd_in(ms),
	.D_un(HEX0),
	.D_de(HEX1),
	.D_ce(),
	.D_mi()

);

//Segundos en HEX2, HEX3

BCD_4displays #(.N_in(6)) bcd_seg (
	.bcd_in(seg),
	.D_un(HEX2),
	.D_de(HEX3),
	.D_ce(),
	.D_mi()

);

endmodule 