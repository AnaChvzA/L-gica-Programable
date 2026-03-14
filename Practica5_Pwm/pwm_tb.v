module pwm_tb();

    reg [9:0] sw;
    reg clk;
    reg rst;
    wire pwm_out;
    wire [0:6] hex0, hex1, hex2;

    pwm DUT (
        .SW(sw),
        .clk(clk),
        .rst(rst),
        .pwm_out(pwm_out),
        .HEX0(hex0),
        .HEX1(hex1),
        .HEX2(hex2)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst = 1; sw = 0;
        #20 rst = 0;
        
        #1000 sw = 10;
        #1000 sw = 90;
        #1000 sw = 180;
        
        #1000 
		  
		  $stop;
		  $finish;
    end
endmodule