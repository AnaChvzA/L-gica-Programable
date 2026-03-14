module practica4 (
	input clk, 
	input [3:0] SW, 
	input [1:0] KEY,
	output reg [0:6] HEX0, 
	output reg [0:6] HEX1,
	output reg [0:6] HEX2,
	output reg [0:6] HEX3


);


//clk divider 


reg [25:0] counter;
reg clk_div;

always @(posedge clk)
begin
	counter <= counter + 1;
	clk_div <= counter[25];
end

parameter [15:0] password = 16'h5234;

parameter IDLE = 0, S1 = 1, S2 = 2, S3 = 3, GOOD = 4, BAD = 5; 

reg [2:0] state, next; 
wire [3:0] x = SW;
wire reset = ~KEY[0];
wire check = ~KEY[1];

reg[3:0] display1, display2, display3, display4;
wire [0:6] D1, D2, D3, D4;
BCD_module BCD1 (.bcd_in(display1), .bcd_out(D1));
BCD_module BCD2 (.bcd_in(display2), .bcd_out(D2));
BCD_module BCD3 (.bcd_in(display3), .bcd_out(D3));
BCD_module BCD4 (.bcd_in(display4), .bcd_out(D4)); 

//Current state
always @(posedge clk_div or posedge reset)
begin
	if(reset)
		state <= IDLE;
	else
		state <= next;
end


always @(posedge clk or posedge reset)
begin
		if(reset)
		begin
			
			next <= IDLE;
			display1 <= 0;
			display2 <= 0;
			display3 <= 0;
			display4 <= 0;
		end
		
		else
		begin
		
		case(state)
			
			IDLE:
				if(check)
				begin
					display1 <= SW;
					if(SW == password[3:0])
						next = S1;
					else
						next = BAD;
				end
					
			S1: 
				if(check)
				begin
					display2 <= SW;
					if(SW == password[7:4])
						next = S2;
					else 
					next = BAD;
				end
			
			S2: //12 bits
				if(check)
				begin
					display3 <= SW;
					if(SW == password[11:8])
						next = S3;
					else 
						next = BAD;
				end
					
			S3: //16 bits
				if(check)
				begin
					display4 <= SW;
					if(SW == password[15:12])
						next = GOOD;
					else 
						next = BAD;
				end
				
			GOOD:
				if(reset)
					next = IDLE;
				else 
					next = GOOD;
			
			BAD:
				next = IDLE;
			default:
				next = IDLE;
			
			endcase 
		end

end



//Outputs 

always @(*)
begin
	case(state)
	
	IDLE:
			begin
			HEX0 = 7'b0000001;
			HEX1 = 7'b0000001;
			HEX2 = 7'b0000001;
			HEX3 = 7'b0000001;
			end
	
	GOOD: //good
			begin
			HEX0 = 7'b1000010;
			HEX1 = 7'b0000001;
			HEX2 = 7'b0000001;
			HEX3 = 7'b0100000;
			end
		
		BAD: //bad
			begin
			HEX0 = 7'b1000010;
			HEX1 = 7'b0001000;
			HEX2 = 7'b1100000; 
			HEX3 = 7'b1111111;
			end
			
		
		default://0000
			begin
			HEX0 = D1;
			HEX1 = D2;
			HEX2 = D3;
			HEX3 = D4;
			end
	endcase
		
end
	

endmodule 
	 
	



