//Ana Cristina Chávez Acosta - A01742237
//Practica #1 
//Test bench para detector de numeros primos

module Practica_1_Numeros_primos_tb ();

reg [3:0] SW; //Inputs
wire LED; //Output

Practica_1_Numeros_primos DUT (.SW(SW), .LED(LED));

//En este bloque va cambiando las combinaciones de las entradas para números del 0 al 15
//Va probando de uno en uno
//Cuando es primo el led se enciende
initial 
	begin
		$display("Simulación iniciada");
		SW = 4'b0000; #10;
		SW = 4'b0001; #10;
		SW = 4'b0010; #10;
		SW = 4'b0011; #10;
		SW = 4'b0100; #10;
		SW = 4'b0101; #10;
		SW = 4'b0110; #10;
		SW = 4'b0111; #10;
		SW = 4'b1000; #10;
		SW = 4'b1001; #10;
		SW = 4'b1010; #10;
		SW = 4'b1011; #10;
		SW = 4'b1100; #10;
		SW = 4'b1101; #10;
		SW = 4'b1110; #10;
		SW = 4'b1111; #10;
		
		$display("Simulacion finalizada");
		$stop;
		$finish;
	end

initial 
	begin 
		$monitor("SW = %b, LED = %b", SW, LED); //Display en el monitor de las salidas
	end
	
endmodule