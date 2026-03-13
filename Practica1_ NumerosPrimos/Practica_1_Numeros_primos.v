// Ana Cristina Chávez Acosta - A01742237
// Practica #1
// Detector de números primos



module Practica_1_Numeros_primos (
	input [3:0] SW, //Inputs
	output reg LED); //Output
	
	//Bloque de código que enciende el LED cuando los numeros son primos, en cualquier otro caso el LED se mantiene apagado
	//Números primos que detecta 2,3,5,7,11,13 
	always @(*)
	 begin
		case(SW)
			4'b0010: LED = 1;
			4'b0011: LED = 1;
			4'b0101: LED = 1;
			4'b0111: LED = 1;
			4'b1011: LED = 1;
			4'b1101: LED = 1;
			default: LED = 0; //Cuando el numero no es primo, led está apagado
		endcase
	end
	
endmodule 
			