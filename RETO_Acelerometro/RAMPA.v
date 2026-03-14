module RAMPA(

    input clk,
    input rst,
    input [9:0] target,

    output reg [9:0] angle_out

);

parameter STEP = 1;

always @(posedge clk or posedge rst)
begin

    if(rst)
        angle_out <= 10'd90;

    else begin

        if(angle_out < target) begin 
				if (target - angle_out <= STEP)
						angle_out <= target;
				else 
					angle_out <= angle_out + STEP[9:0];
		end

        else if(angle_out > target) begin 
				if (angle_out - target <= STEP)
						angle_out <= target;
        else
            angle_out <= angle_out - STEP[9:0];
			end
    end

end

endmodule