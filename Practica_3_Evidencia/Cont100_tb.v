module Cont100_tb();
	reg clk;
	reg rst;
	wire [6:0] count;
	
	
Cont100 DUT(
	.clk(clk),
	.rst(rst),
	.count(count)
);


initial
	begin
		clk=0;
		forever #5
		clk= ~clk;
end

initial 
	begin 
		$display("Simulacion");
		rst=1;
		#100
		rst=0;
		#1000
		$stop;
		$finish;
end 


initial
	begin
		$monitor("CLK=%b, rst=%b, Count=%d", clk, rst, count);
		end

endmodule