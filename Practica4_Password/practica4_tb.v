module practica4_tb ();
    reg clk;
    reg [3:0] SW;
    reg [1:0] KEY;
    wire [0:6] HEX0, HEX1, HEX2, HEX3;

    practica4 DUT (
        .clk(clk),
        .SW(SW),
        .KEY(KEY),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );

    initial begin clk = 0; forever #10 clk = ~clk; end

    // sustituyo clk_div por una señal controlada para no esperar tantos ciclos
    // tip de: https://www.chipverify.com/verilog/verilog-force-release
    initial force DUT.clk_div = 0;
    always #10 force DUT.clk_div = ~DUT.clk_div;

    initial
    begin
        $display("simulacion iniciada");
        SW = 4'b0000;
        KEY[0] = 0;
        KEY[1] = 1;
        #40;
        KEY[0] = 1;
        #40;

        // password = 16'h5234 

        // Digito 1
        SW = 4'h4;
        #15; KEY[1] = 0;
        #20; KEY[1] = 1;
        #40;

        // Digito 2
        SW = 4'h3;
        #15; KEY[1] = 0;
        #20; KEY[1] = 1;
        #40;

        // Digito 3
        SW = 4'h2;
        #15; KEY[1] = 0;
        #20; KEY[1] = 1;
        #40;

        // Digito 4
        SW = 4'h5;
        #15; KEY[1] = 0;
        #20; KEY[1] = 1;
        #40;

        #40;
        $display("simulacion finalizada");
        $stop;
		  $finish;
    end

    initial
    begin
        $monitor("SW = %h, KEY = %b, HEX0 = %b, HEX1 = %b, HEX2 = %b, HEX3 = %b",
                  SW, KEY, HEX0, HEX1, HEX2, HEX3);
    end

endmodule
