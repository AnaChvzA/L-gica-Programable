module pwm(
	input [9:0] SW,
	input clk,
	input rst,
	output reg pwm_out,
	output [0:6] HEX0,
	output [0:6] HEX1, 
	output [0:6] HEX2


);


reg [9:0] SW_TOP;

always@(*)
begin
if(SW > 10'd180)
	SW_TOP = 10'd180;
else
	SW_TOP = SW;
end



wire clk_div;

CLK_divider  #(.FREQ(1_000_000)) DIV(
	.clk(clk),
	.rst(rst),
	.clk_div(clk_div)
);


wire [19:0] count;

//Contador Sincrono

contador #(.CMAX(20_000)) CONT(
	.clk(clk_div),
	.rst(rst),
	.count(count)
	

);

//BCD

BCD_4displays #(.N_in(10), .N_out(7)) DISP(
	.bcd_in(SW_TOP), //Es el comparador o los SW
	.D_un(HEX0),
	.D_de(HEX1),
	.D_ce(HEX2),
	.D_mi()
	
);


wire [19:0] comparador= 20'd1_000 + (({10'd0, SW_TOP} * 20'd1_000)/ 20'd180);

always@(posedge clk_div or posedge rst)
begin

	if(rst)
		pwm_out <= 1'b0;
	
	else	
		 pwm_out<= (count <= comparador) ? 1'b1: 1'b0; 
end 

endmodule 





