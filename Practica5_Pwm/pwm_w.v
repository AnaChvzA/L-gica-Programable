module pwm_w(
    input [7:0] SW,
    input MAX10_CLK1_50,
    input [0:0] KEY, 
    output [0:6] ARDUINO_IO,
    output [0:6] HEX0, 
    output [0:6] HEX1, 
    output [0:6] HEX2
);

pwm WRAP(
    .SW(SW[7:0]),
    .clk(MAX10_CLK1_50),
    .rst(~KEY[0]),
    .pwm_out(ARDUINO_IO[2]),
    .HEX0(HEX0),
    .HEX1(HEX1),
    .HEX2(HEX2)
);

endmodule