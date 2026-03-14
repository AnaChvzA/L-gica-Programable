module UART_Rx #(parameter BAUD_RATE = 9600, parameter CLOCK_FREQ = 50_000_000, BITS = 8)(
    input wire clk,
    input wire rst,
    input wire rx_in,
    output reg [BITS-1:0] data_out,
    output wire idle,
    output wire startbit,
    output wire databits,
    output wire stopbits,
    output reg data_ready
);

localparam IDLE = 2'b00, START_BIT = 2'b01, DATA_BITS = 2'b10, STOP_BIT = 2'b11;

reg [1:0] state;
reg [3:0] bit_index;
reg [15:0] baud_counter;
reg [BITS-1:0] data_buffer;

// Sincronización de entrada (evita metastabilidad)
reg rx_sync1, rx_sync2;
always @(posedge clk) begin
    rx_sync1 <= rx_in;
    rx_sync2 <= rx_sync1;
end 

assign idle     = (state == IDLE);
assign startbit = (state == START_BIT);
assign databits = (state == DATA_BITS);
assign stopbits = (state == STOP_BIT);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE; 
        data_out <= 0; 
         data_ready <= 0; 
        bit_index <= 0; 
        baud_counter <= 0;
        data_buffer <= 0;
    end else begin
        data_ready <= 0;
        case (state)
            IDLE: begin
                if(!rx_sync2)begin
                    state <= START_BIT; 
                    baud_counter <= 0; 
                    data_buffer  <= 0;
                end
            end
            START_BIT: begin
               if (baud_counter < CLOCK_FREQ / BAUD_RATE / 2- 1) begin //Tiene que ser medio periodo para que no se acumulen los atrasos
                    baud_counter <= baud_counter + 1;
               end else begin
                    baud_counter <= 0;
						if(!rx_sync2)begin 	
							state <= DATA_BITS;
						end else begin 
							state<= IDLE;
						end
					end
				end
            DATA_BITS: begin
                if (baud_counter < CLOCK_FREQ / BAUD_RATE - 1) begin
                    baud_counter <= baud_counter + 1;
                end else begin
                    baud_counter <= 0;
                    data_buffer[bit_index] <= rx_sync2; // Captura bits de datos
                    if (bit_index < BITS - 1) begin
                        bit_index <= bit_index + 1;
                    end else begin
                         bit_index <= 0;
                        state <= STOP_BIT;
                    end
                end
            end

            STOP_BIT: begin
                if (baud_counter < CLOCK_FREQ / BAUD_RATE - 1) begin
                    baud_counter <= baud_counter + 1;
                end else begin
                    baud_counter <= 0;
						  if(rx_sync2) begin
							data_out <= data_buffer; // Salida de datos recibidos
							data_ready <= 1; // Indica que los datos están listos
						end 
						  state <= IDLE; // Vuelve al estado de espera para el próximo byte
                end
            end
        endcase
    end
end


endmodule