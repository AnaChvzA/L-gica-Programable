//Ana Cristina Chávez Acosta - A01742237

//BCD para un solo display 
module BCD_module (
	input [3:0] bcd_in,
	output reg [0:6] bcd_out

); 
	
always @ (*)
begin 
	case(bcd_in)
    0: bcd_out = 7'b0000001;
    1: bcd_out = 7'b1001111;
    2: bcd_out = 7'b0010010;
    3: bcd_out = 7'b0000110;
    4: bcd_out = 7'b1001100;
    5: bcd_out = 7'b0100100;
    6: bcd_out = 7'b0100000;
    7: bcd_out = 7'b0001111;
    8: bcd_out = 7'b0000000;
    9: bcd_out = 7'b0000100;
    default: bcd_out = 7'b1111111;
endcase
end

endmodule 
			