module Debouncer_tb();

reg clk;
reg Boton;
wire state;
wire boton_nada;
wire boton_aplastado;


Debouncer DUT (
	.Boton(Boton),
	.clk(clk),
	.state(state),
	.boton_nada(boton_nada),
	.boton_aplastado(boton_aplastado)

);


//Reloj
initial clk = 0;
always #10 clk = ~clk;

//Test

initial 
begin

Boton = 1; //Boton sin presionar (logica invertida)
#100;

Boton = 0;
#15;
Boton = 1;
#15;
Boton = 0;
#15;
Boton = 1;
#15;
Boton = 0;

//Esperar suficiente tiempo para que el contador si llegue al maximo
#3000;

$stop;
$finish;

end 

endmodule 