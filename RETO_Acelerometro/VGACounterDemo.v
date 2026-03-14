// Módulo principal que muestra un contador en VGA con fuente 8x16 bits
module VGACounterDemo(
    input MAX10_CLK1_50,      // reloj de 50 MHz de la tarjeta
    output reg [2:0] pixel,   // salida de color RGB (3 bits)
    
	 input [9:0] angle_x, 
	 input [9:0] angle_y,
	 input [9:0] angle_z,
	 
	 output hsync_out,         // señal de sincronización horizontal
    output vsync_out          // señal de sincronización vertical
);

//-------------------------------------------------
// Señales del sistema VGA
//-------------------------------------------------

wire inDisplayArea;   // indica si estamos dentro del área visible de la pantalla
wire [9:0] CounterX;  // posición horizontal actual del pixel
wire [9:0] CounterY;  // posición vertical actual del pixel

  
//-------------------------------------------------
// Generación de pixel clock (25 MHz)
//-------------------------------------------------

// VGA 640x480 usa aproximadamente 25 MHz
// aquí dividimos el reloj de 50 MHz entre 2
reg pixel_tick = 0;

always @(posedge MAX10_CLK1_50)
    pixel_tick <= ~pixel_tick;


//-------------------------------------------------
// Generador de sincronización VGA
//-------------------------------------------------

// Este módulo genera las señales hsync, vsync
// y también las coordenadas del pixel actual
hvsync_generator hvsync(
    .clk(MAX10_CLK1_50),
    .pixel_tick(pixel_tick),
    .vga_h_sync(hsync_out),
    .vga_v_sync(vsync_out),
    .CounterX(CounterX),
    .CounterY(CounterY),
    .inDisplayArea(inDisplayArea)
);


//Conversión de angulos a digitos

// Eje X
wire [3:0] x_d0 = angle_x % 10;
wire [3:0] x_d1 = (angle_x / 10) % 10;
wire [3:0] x_d2 = angle_x / 100;

// Eje Y
wire [3:0] y_d0 = angle_y % 10;
wire [3:0] y_d1 = (angle_y / 10) % 10;
wire [3:0] y_d2 = angle_y / 100;

// Eje Z
wire [3:0] z_d0 = angle_z % 10;
wire [3:0] z_d1 = (angle_z / 10) % 10;
wire [3:0] z_d2 = angle_z / 100;


//POSICIONES EN LA PANTALLA

parameter X_START  = 200;  // columna inicial del texto
parameter Y_X_LINE = 100;  // fila donde aparece X
parameter Y_Y_LINE = 124;  // fila donde aparece Y (200 + 16 + 4 de margen)
parameter Y_Z_LINE = 148;  // fila donde aparece Z

wire [3:0] row = in_line_x ? (CounterY - Y_X_LINE) :
                 in_line_y ? (CounterY - Y_Y_LINE) :
                              (CounterY - Y_Z_LINE);
										
//COLUMNA Y FILA 

wire [2:0] col = CounterX - X_START;         // pixel dentro del carácter (0–7)

//indice del caracter
wire [2:0] char_index = (CounterX - X_START) >> 3;


//LINEA DE TEXTO ACTUAL 

wire in_line_x = (CounterY >= Y_X_LINE) && (CounterY < Y_X_LINE + 16);
wire in_line_y = (CounterY >= Y_Y_LINE) && (CounterY < Y_Y_LINE + 16);
wire in_line_z = (CounterY >= Y_Z_LINE) && (CounterY < Y_Z_LINE + 16);
wire in_col    = (CounterX >= X_START)  && (CounterX < X_START + 48); // 6×8=48


//CARACTER ASCII
reg [7:0] ascii;

always @*
begin
    if (in_line_x) begin
        case (char_index)
            3'd0: ascii = "X";
            3'd1: ascii = ":";
            3'd2: ascii = " ";
            3'd3: ascii = x_d2 + "0";  // centenas
            3'd4: ascii = x_d1 + "0";  // decenas
            3'd5: ascii = x_d0 + "0";  // unidades
            default: ascii = " ";
        endcase
    end
    else if (in_line_y) begin
        case (char_index)
            3'd0: ascii = "Y";
            3'd1: ascii = ":";
            3'd2: ascii = " ";
            3'd3: ascii = y_d2 + "0";
            3'd4: ascii = y_d1 + "0";
            3'd5: ascii = y_d0 + "0";
            default: ascii = " ";
        endcase
    end
    else begin  // in_line_z
        case (char_index)
            3'd0: ascii = "Z";
            3'd1: ascii = ":";
            3'd2: ascii = " ";
            3'd3: ascii = z_d2 + "0";
            3'd4: ascii = z_d1 + "0";
            3'd5: ascii = z_d0 + "0";
            default: ascii = " ";
        endcase
    end
end


//DIRECCION DE LA MEMORIA

wire [11:0] rom_addr;
assign rom_addr = (ascii << 4) + row;

//LECTURA DE LA ROM
wire [7:0] font_row;

font_rom font(
    .addr(rom_addr[10:0]),
    .data(font_row)
);


//VER SI EL PIXEL ESTÁ PRENDIDO 

wire pixel_on;
assign pixel_on = font_row[7 - col];

//PONER EL PIXEL EN LA PANTALLA

always @(posedge MAX10_CLK1_50)
begin
    if (inDisplayArea)
    begin
        if (in_col && (in_line_x || in_line_y || in_line_z))
        begin
            if (pixel_on)
                pixel <= 3'b011; // blanco
            else
                pixel <= 3'b000; // negro
        end
        else
            pixel <= 3'b000;
    end
    else
        pixel <= 3'b000;
end

endmodule

