module UART_Tx_Tb();
reg clk;
reg rst;
reg [7:0] data_in;
reg start;
wire tx_out;
wire busy;


UART_Tx #(.BAUD_RATE(9600), .CLOCK_FREQ(50_000_000), .BITS(8)) DUT (
	.clk(clk),
	.rst(rst),
	.data_in(data_in),
	.start(start),
	.tx_out(tx_out),
	.busy(busy)

);

initial begin
clk = 0;
rst = 0;
data_in = 8'h00;
start = 0;
end 


initial clk = 0;
always #10 clk = ~clk;


initial 
begin
$display("Simulación iniciada");
#30;
rst = 1;
#10;
rst = 0;
#20;

repeat (10) begin
	data_in = $random % 256; 
	start = 1;
	#20;
	start = 0;
	wait(!busy);
	#104000;
	$display("Dato transmitido: %h", data_in);
	
	
end 

$stop;
$finish;

end 



endmodule 








