module RETO_w (

	 input ADC_CLK_10,
	 input MAX10_CLK1_50,
	 input MAX10_CLK2_50,
    input [1:0] KEY,
	 input [9:0] SW,

	 output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	 output [9:0] LEDR,
    // acelerómetro
    output GSENSOR_CS_N,
    input  [2:1] GSENSOR_INT,
    output GSENSOR_SCLK,
    inout  GSENSOR_SDI,
    inout  GSENSOR_SDO,

    // servos
    output pwm_x,
    output pwm_y,
    output pwm_z,
	 
	 //GARRA 
	 output wire pwm_garra,
	 
	 //Puertos para VGA
	 
	 output wire VGA_HS,
	 output wire VGA_VS, 
	 output wire [2:0] VGA_pixel

);

wire [15:0] data_x;
wire [15:0] data_y;
wire [15:0] data_z;
wire data_update;


// acelerómetro
accel accel_inst(
	 .ADC_CLK_10 (ADC_CLK_10),
    .MAX10_CLK1_50(MAX10_CLK1_50),
	 .MAX10_CLK2_50(MAX10_CLK2_50),
    .KEY(KEY),
	 .SW(SW),
	 .HEX0(), .HEX1(), .HEX2(), 
	 .HEX3(), .HEX4(), .HEX5(),
	 .LEDR (LEDR),

    .GSENSOR_CS_N(GSENSOR_CS_N),
    .GSENSOR_INT(GSENSOR_INT),
    .GSENSOR_SCLK(GSENSOR_SCLK),
    .GSENSOR_SDI(GSENSOR_SDI),
    .GSENSOR_SDO(GSENSOR_SDO),
		
	 .data_update(data_update),
    .data_x(data_x),
    .data_y(data_y),
    .data_z(data_z)

);

wire [9:0] angle_x_out, angle_y_out, angle_z_out;

// lógica del brazo
RETO reto(

    .clk(MAX10_CLK1_50),
    .rst(~KEY[0]),
    .guardar(~KEY[1]),
	 
	 .modo_auto(SW[0]),
	 .ejecutar(SW[1]),

    .data_x(data_x),
    .data_y(data_y),
    .data_z(data_z),
    .data_update(data_update),

    .pwm_x(pwm_x),
    .pwm_y(pwm_y),
    .pwm_z(pwm_z), 
	 
	 .garra(SW[2]),
	 .pwm_garra(pwm_garra),
	 
	 .HEX0(HEX0),
	 .HEX1(HEX1),
	 .HEX2(HEX2),
	 .HEX3(HEX3),
	 .HEX4(HEX4),
	 .HEX5(HEX5),
	 
	 
	 .angle_x_out(angle_x_out),
    .angle_y_out(angle_y_out),
    .angle_z_out(angle_z_out)
);


//VGA
VGACounterDemo vga(
    .MAX10_CLK1_50(MAX10_CLK1_50),
    .angle_x(angle_x_out),   // ← ahora sí existe
    .angle_y(angle_y_out),
    .angle_z(angle_z_out),
    .pixel(VGA_pixel),
    .hsync_out(VGA_HS),
    .vsync_out(VGA_VS)
);

endmodule