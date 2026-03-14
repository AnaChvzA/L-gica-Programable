module UART_tb();

//Señales para el transmisor
reg clk;
reg rst;
reg [7:0] data_in;
reg start;
//wire tx_out;
wire busy;

//Señales intermedias
wire UART_wire; // Conexión entre TX y RX

//Señales para el receptor
//reg rx_in;
wire [7:0] data_out;
wire data_ready;

/*
UART_Tx #(.BAUD_RATE(9600), .CLOCK_FREQ(50000000), .BITS(8)) UART_TX_TB (
    .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .start(start),
    .tx_out(UART_wire),
    .busy(busy)
);

UART_Rx #(.BAUD_RATE(9600), .CLOCK_FREQ(50000000), .BITS(8)) UART_RX_TB (
    .clk(clk),
    .rst(rst),
    .rx_in(UART_wire),
    .data_out(data_out),
    .data_ready(data_ready)
);

*/

UART_TOP DUT (
	 .clk(clk),
    .rst(rst),
    .data_in(data_in),
    .start(start),
    .busy(busy),
    .data_out(data_out),
    .data_ready(data_ready)
);

initial begin
    clk = 0;
    rst = 0;
    data_in = 8'h00;
    start = 0;
end

always
    #10 clk = ~clk; // Genera un reloj de 50 MHz

initial
begin
    $display("Simulación iniciada");
    #30;
    rst = 1; // Activa el reset
    #10;        
    rst = 0; // Desactiva el reset
    #20000; // Espera suficiente tiempo para que el sistema se estabilice
    repeat(10) begin
		  wait(!busy)
        data_in = $random % 256; // Carga un dato de prueba
        @(posedge clk)
		  start = 1; // Inicia la transmisión
        @(posedge clk)
        start = 0; // Detiene la señal de inicio
        @(posedge data_ready); // Espera a que termine la transmisión
        $display("Dato transmitido: %b, Dato recibido: %b", data_in, data_out);
        #20;
    end
    $stop;
    $finish;
end




endmodule