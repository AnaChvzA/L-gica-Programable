module Practica_1_Numeros_primos_tb ();

reg [3:0] SW;
wire LED;

Practica_1_Numeros_primos DUT (.SW(SW), .LED(LED));

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
		$monitor("SW = %b, LED = %b", SW, LED);
	end
	
endmodule