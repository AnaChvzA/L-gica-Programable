module RETO (
	input clk, 
	input rst, 
	input guardar, 
	input modo_auto,
	input wire ejecutar, 

	input [15:0] data_x,
	input [15:0] data_y, 
	input [15:0] data_z, 
	
	input data_update, 
	
	input wire garra,
	
	output pwm_x, 
	output pwm_y, 
	output pwm_z,
	
	output wire pwm_garra,
	
	output wire[7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	
	output wire [9:0] angle_x_out,
	output wire [9:0] angle_y_out,
	output wire [9:0] angle_z_out
);

//Wires para que podamos convertir lo del acelerometro a algo que puede leer el pwm



wire [9:0] x_target;
wire [9:0] y_target;
wire [9:0] z_target;


CONVERTIDOR #(.OFFSET_X(-16'sd34),  // su valor medido en reposo
    .OFFSET_Y(16'sd0),    // medir igual para Y
    .OFFSET_Z(16'sd256),    // medir igual para Z
    .DIVISOR (18'sd256)) CONV(
	.data_x(data_x),
	.data_y(data_y),
	.data_z(data_z),
	.data_out_x(x_target),
	.data_out_y(y_target),
	.data_out_z(z_target)


);

wire clk_rampa;

CLK_divider #(.FREQ(150)) DIV_RAMPA (
	.clk(clk),
	.rst(rst),
	.clk_div(clk_rampa)
);

wire [9:0] x_smooth, y_smooth, z_smooth;

RAMPA #(.STEP(3)) rampa_x(
	.clk(clk_rampa),
	.rst(rst),
	.target(x_target),
	.angle_out(x_smooth)
);


RAMPA #(.STEP(3)) rampa_y(
	.clk(clk_rampa),
	.rst(rst),
	.target(y_target),
	.angle_out(y_smooth)
);


RAMPA #(.STEP(3)) rampa_z(
	.clk(clk_rampa),
	.rst(rst),
	.target(z_target),
	.angle_out(z_smooth)
);


//CONTADOR DE POSICIONES 

wire [2:0] pos_escritura;
wire [2:0] pos_lectura;
wire [3:0] num_guardadas;
wire we;


CONTADOR contador(
	.clk(clk),
	.rst(rst),
	.guardar(guardar),
	.modo_auto(modo_auto),
	.ejecutar(ejecutar),
	.pos_escritura(pos_escritura),
	.pos_lectura(pos_lectura),
	.num_guardadas(num_guardadas), 
	.we(we)
);


reg [29:0] memoria [0:7];
reg [29:0] ram_out_reg;

always @(posedge clk) begin 
	if (we)
		memoria [pos_escritura] <= {x_smooth, y_smooth, z_smooth};
	  ram_out_reg <= memoria[pos_lectura];
	end
	
	wire [9:0] x_mem = ram_out_reg [29:20];
	wire [9:0] y_mem = ram_out_reg [19:10];
	wire [9:0] z_mem = ram_out_reg [9:0];
	
	//MUX para elegir si va a ser manual o si será automatico
	wire [9:0] x_pwm = ejecutar ? x_mem : x_smooth;
	wire [9:0] y_pwm = ejecutar ? y_mem : y_smooth;
	wire [9:0] z_pwm = ejecutar ? z_mem : z_smooth;
	
//Instancias para cada uno de los servos

pwm servo_x(
.clk(clk),
.rst(rst),
.SW(x_pwm),
.pwm_out(pwm_x)
);

pwm servo_y(
.clk(clk),
.rst(rst),
.SW(y_pwm),
.pwm_out(pwm_y)

);

pwm servo_z(
.clk(clk),
.rst(rst),
.SW(z_pwm),
.pwm_out(pwm_z)
);

//GARRA

wire [9:0] garra_angle = garra ? 10'd150 : 10'd30;

pwm servo_garra(
	.clk(clk),
	.rst(rst), 
	.SW(garra_angle),
	.pwm_out(pwm_garra)
);

//DISPLAYS 

	 wire [3:0] x_un = x_smooth % 10;
    wire [3:0] x_de = (x_smooth / 10) % 10;
    wire [3:0] y_un = y_smooth % 10;
    wire [3:0] y_de = (y_smooth / 10) % 10;
    wire [3:0] z_un = z_smooth % 10;
    wire [3:0] z_de = (z_smooth / 10) % 10;

    wire [3:0] d0 = modo_auto ? {1'b0, pos_lectura}  : x_un;
    wire [3:0] d1 = modo_auto ? num_guardadas[3:0]   : x_de;
    wire [3:0] d2 = modo_auto ? 4'hF                 : y_un;
    wire [3:0] d3 = modo_auto ? 4'hF                 : y_de;
    wire [3:0] d4 = modo_auto ? 4'hF                 : z_un;
    wire [3:0] d5 = modo_auto ? 4'hF                 : z_de;

    seg7 s0 (.in(d0), .display(HEX0));
    seg7 s1 (.in(d1), .display(HEX1));
    seg7 s2 (.in(d2), .display(HEX2));
    seg7 s3 (.in(d3), .display(HEX3));
    seg7 s4 (.in(d4), .display(HEX4));
    seg7 s5 (.in(d5), .display(HEX5));
	 
	 assign angle_x_out = x_pwm;
	 assign angle_y_out = y_pwm;
	 assign angle_z_out = z_pwm;
		 
	 


endmodule 