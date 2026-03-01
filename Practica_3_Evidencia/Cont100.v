//Ana Cristina Chávez Acosta 
//Practica 3


module Cont100 #( parameter CMAX = 100)(
	input clk, 
	input rst,
	//Entradas nuevas
	input up_down,
	input [6:0] data_in,
	input load, 
	output reg [6:0] count
	
);




always @(posedge clk or posedge rst)
	begin 
	if(rst)
		count <= 0;
	else if (load)
		count <= data_in;
		//Hacia arriba
	else
		begin
		if(up_down)
			begin
		 
			if (count == CMAX)
				count <= 0;
				else 
				count <= count + 1;
			end
	
	else if(count == 0)
		count <= CMAX;
	else
		count = count -1;
	end
end
	
 
		
	//Descendente de 100 a 0
			/*
			if(rst)
				count <= 0;
			
			
			else
			begin 
				if(count == 0)
					count <= CMAX;
				else 
					count <= count -1;
			end
	end
end

	
	
	
	
	
	
	/*
			if(rst)
				count <= 0;
			else
				begin
					if(load)
						begin
						count <= data_in;
						end
						//Hacia arriba
						if(up_down)
						begin 
							if (count == CMAX)
							count <= 0;
							else 
							count <= count + 1;
						end
			 
		
	//Descendente de 100 a 0
			/*
			if(rst)
				count <= 0;
			
			
			else
			begin 
				if(count == 0)
					count <= CMAX;
				else 
					count <= count -1;
			end
	end
end

*/


endmodule 