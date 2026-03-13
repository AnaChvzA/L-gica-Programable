module BCD_4displays #(parameter N_in = 10, N_out = 7)(
	input [N_in - 1:0] bcd_in,
	output [N_out -1:0] D_un, D_de, D_ce, D_mi);
	
	wire [3:0] unidades, decenas, centenas, millares;
	
	assign unidades = bcd_in % 10;
	
	//Dividir entre 10 y obtener modulo de 10
	
	assign decenas = (bcd_in/10) % 10;
	
	assign centenas = (bcd_in /100) % 10;
	
	assign millares = (bcd_in / 1000) % 10;
	

//Unidades
BCD_module uni (
	.bcd_in(unidades),
	.bcd_out(D_un)

);

//Decenas
BCD_module dec (
	.bcd_in(decenas),
	.bcd_out(D_de)
);

//Centenas
BCD_module cen(
	.bcd_in(centenas),
	.bcd_out(D_ce)
);

//Millares
BCD_module mil (
	.bcd_in(millares),
	.bcd_out(D_mi)
);


endmodule 
