module Cronometro(
	input clk, 
	input rst, 
	input start_stop, //señal para poder iniciar y detener el conteo
	output reg [9:0] ms, //milisegundos, 10 bits pues 1024
	output reg [5:0] seg //segundos, 6 bits pues 64



);


wire clk_ms;
wire clk_seg;
reg andando; //Variable para decir que está contando 

CLK_divider #(.FREQ(1000)) div_ms ( //Frecuencia de 1000 porque son mili segundos
	.clk(clk),
	.rst(rst),
	.clk_div(clk_ms)
);


CLK_divider #(.FREQ(1)) div_seg ( //Frecuencia de 1 porque son segundos 
	.clk(clk),
	.rst(rst),
	.clk_div(clk_seg)


);

 // El start stop
    always @(posedge start_stop or posedge rst)
    begin
        if(rst) //Si se resetea entonces es 0 
            andando <= 0;
        else
            andando <= ~andando; //Si no, entonces tiene que estar cambiando 
    end

    // Conteo para los milisegundos, tiene que ser con clock de milisegundos
    always @(posedge clk_ms or posedge rst)
    begin
        if(rst)
            ms <= 0;
        else if(andando) begin
            if(ms == 999) //Si llega hasta 999 entonces se reinicia porque va de 0 a 999
                ms <= 0;
            else
                ms <= ms + 1; //Si no ha legado pues se sigue sumando
        end
    end

    // Conteo para los segundos
    always @(posedge clk_seg or posedge rst) //Aqui tengo que usar el reloj de los segundos 
    begin
        if(rst) //Si se resetea pues se va a 0
            seg <= 0;
        else if(andando) begin //Si sigue contando o andando entra 
            if(seg == 59) //Si ya llegó a los 59 entonces se tiene que reiniciar 
                seg <= 0;
            else
                seg <= seg + 1;//Si no ha llegado pues se sigue sumando 
        end
    end

endmodule

