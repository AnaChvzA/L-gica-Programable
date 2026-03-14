module CONVERTIDOR (

input [15:0] data_x, 
input [15:0] data_y, 
input [15:0] data_z,

output reg [9:0] data_out_x,
output reg [9:0] data_out_y, 
output reg [9:0] data_out_z

);

parameter signed [15:0] OFFSET_X = -16'sd34;
parameter signed [15:0] OFFSET_Y =  16'sd0;
parameter signed [15:0] OFFSET_Z =  16'sd256;
parameter signed [17:0] DIVISOR  =  18'sd256;

//Ponerlo como signed porque lo que da son complementos a dos

wire signed [15:0] x= $signed(data_x);
wire signed [15:0] y= $signed(data_y);
wire signed [15:0] z= $signed(data_z);

wire signed [15:0] x_cal = x - OFFSET_X;
wire signed [15:0] y_cal = y - OFFSET_Y;
wire signed [15:0] z_cal = z - OFFSET_Z;

wire signed [17:0] x_ext = {{2{x_cal[15]}}, x_cal};
wire signed [17:0] y_ext = {{2{y_cal[15]}}, y_cal};
wire signed [17:0] z_ext = {{2{z_cal[15]}}, z_cal};

wire signed [17:0] x_grad = (x_ext * 18'sd180) / DIVISOR + 18'sd90;
wire signed [17:0] y_grad = (y_ext * 18'sd180) / DIVISOR + 18'sd90;
wire signed [17:0] z_grad = (z_ext * 18'sd180) / DIVISOR + 18'sd90;


//Hay que limitarlo entre 0 y 180

always @(*) begin
        if      (x_grad < 18'sd0)   data_out_x = 10'd0;
        else if (x_grad > 18'sd180) data_out_x = 10'd180;
        else                        data_out_x = x_grad[9:0];

        if      (y_grad < 18'sd0)   data_out_y = 10'd0;
        else if (y_grad > 18'sd180) data_out_y = 10'd180;
        else                        data_out_y = y_grad[9:0];

        if      (z_grad < 18'sd0)   data_out_z = 10'd0;
        else if (z_grad > 18'sd180) data_out_z = 10'd180;
        else                        data_out_z = z_grad[9:0];
    end
endmodule


