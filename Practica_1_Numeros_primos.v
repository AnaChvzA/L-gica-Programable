module Practica_1_Numeros_primos (
	input [3:0] SW, 
	output reg LED);
	
	always @(*)
	 begin
		case(SW)
			4'b0010: LED = 1;
			4'b0011: LED = 1;
			4'b0101: LED = 1;
			4'b0111: LED = 1;
			4'b1011: LED = 1;
			4'b1101: LED = 1;
			default: LED = 0;
		endcase
	end
	
endmodule 
			