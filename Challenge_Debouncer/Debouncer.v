module Debouncer (
//Necesito un boton
input Boton, 
input clk, //el reloj de siempre
output reg state, //el estado de si se le aplasta al botón o no
output boton_nada,  //Salida de cuando dejan de aplastar el boton
output boton_aplastado //Salida de cuando aplastan del boton

);


//Primera parte es hacer los dos flip flops y que se sincronicen con el boton


//Contador de 7 bits porque no se cuanto cabe 

reg [6:0] counter;


//Inicializar el estado y el contador

initial
begin
state = 0;
counter = 0;
end

reg Boton_0;

always @(posedge clk) Boton_0 <= ~Boton; //Invertir el boton para que sea activo otra vez

reg Boton_1;

always @(posedge clk) Boton_1 <= Boton_0;

//Cada vez que se le presiona al boton el contador debe subir
//Entonces el contador debe estar lleno hasta que se decide que el cambio pasó

wire IDLE = (state == Boton_1);
wire MAX = &counter; //Se cumple cuando todos los bits del contador no son 1

always @(posedge clk)
begin
if(IDLE)
	counter <= 0; //Se queda en 0, no pasa nada
else 
begin
	counter <= counter + 7'd1; //Se incrementa el contador 
	if(MAX)
		state <= ~state; //Si se llega al maximo encontes cambia el boton
end 

end

assign boton_aplastado = ~IDLE & MAX & ~state;
assign boton_nada = ~IDLE & MAX & state;

endmodule 
