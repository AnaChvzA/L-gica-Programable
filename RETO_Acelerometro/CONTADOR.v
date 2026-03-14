module CONTADOR (
	input wire clk, 
	input wire rst, 
	input wire guardar,
	input wire modo_auto, 
	input wire ejecutar,
	
	output reg [2:0] pos_escritura,
	output reg [2:0] pos_lectura, 
	output reg [3:0] num_guardadas, 
	output reg we
	
);

localparam TIMER_MAX = 50_000_000;
reg [25:0] timer;


reg guardar_prev;
wire guardar_pulse = guardar & ~guardar_prev;


always@(posedge clk) 
begin
if(rst)
	guardar_prev <= 1'b0;
	
else
	guardar_prev <= guardar;

end


//Bloque principal

always@(posedge clk)
begin
if(rst)
begin
	pos_escritura <= 3'd0;
	pos_lectura <= 3'd0;
	num_guardadas <= 4'd0;
	we <= 1'b0;
	timer <= 26'd0;
	end else begin
	we <= 1'b0; //El default es que no escriba nada 
	
	if(guardar_pulse && modo_auto && !ejecutar && num_guardadas < 4'd8)
	begin
		we <= 1'b1;
		pos_escritura <= pos_escritura + 3'd1;
		num_guardadas <= num_guardadas + 4'd1;
	end
	
	//AUTOMATICO
	
	if(ejecutar && num_guardadas > 4'd0) begin
		if(timer >= TIMER_MAX -1) begin
			 timer <= 26'd0;
			 if(pos_lectura >= num_guardadas -1) 
				pos_lectura <=  3'd0;
			 else
				pos_lectura <= pos_lectura + 3'd1;
			end else begin
				timer <= timer + 26'd1;
			end
		end else begin
			timer <= 26'd0;
			pos_lectura <= 3'd0;
		end
	end
end
	
	

endmodule 