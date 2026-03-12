module Sumatoria (
	input clk, 
	input rst, 
	input [3:0] num,
	input start, 
	output reg [9:0] suma
	
	
);

reg [3:0] num_max; //Aqui puedo poner que sea igual al numero ingresado 
reg [3:0] counter; //Es la variable para contar y que se le vayan sumando valores 
reg previo; //Para poder guardar el estado previo


always@(posedge clk or posedge rst)
begin
if(rst) begin //pongo todos en 0 porque rst 
		suma <= 0;
		counter <= 0;
		num_max <= 0;
	end
	else if(start && !previo) //Si la señal se activa y si detecta que se subío el flanco
	begin
		suma <= 0;
		counter <= 0;
		num_max <= num; //le meto el numero que se ingresa por switches 
		previo <= 1; //Aqui ya empieza 
	end 

	else 
	begin
		previo <= start; //Que se actualice el estado anterior
		if(counter < num_max)
		begin
			counter <= counter + 1;
			suma <= suma + counter + 1;
		end
	end 

end 

endmodule 

	
