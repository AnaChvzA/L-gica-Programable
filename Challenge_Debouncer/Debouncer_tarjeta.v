module Debouncer_tarjeta(
input MAX10_CLK1_50,
input [0:0] KEY,
output [0:0] LEDR

);

wire state;
wire boton_nada;
wire boton_aplastado;

Debouncer DUT(
	.Boton(KEY[0]),
	.clk(MAX10_CLK1_50),
	.state(state),
	.boton_nada(boton_nada),
	.boton_aplastado(boton_aplastado)
);

assign LEDR[0] = state;

endmodule