module contador #(parameter CMAX=1_000_000)(
    input clk,
    input rst,
    output reg [19:0] count
);

always @(posedge clk or posedge rst)
begin
    if (rst)  
        count <=0;
	 else 
    begin
		if (count>=CMAX)
		count <=0;
		else 
        count <= count +1;
    end 
end 
endmodule

