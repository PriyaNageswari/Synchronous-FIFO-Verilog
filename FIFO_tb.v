module FIFO_tb;
    reg clk,rst,wrt,rd;
    reg [7:0]din;
    wire full,emt;
    wire [7:0]dout;
    
    FIFO dut(clk,rst,wrt,rd,din,full,emt,dout);
    
    always #5 clk = ~clk;
    initial begin
            $monitor("T=%0t rst=%b wrt=%b rd=%b din=%h dout=%h full=%b emt=%b",
                        $time,rst,wrt,rd,din,dout,full,emt);
        clk = 0; rst = 0; din = 0; wrt = 0; rd = 0; #5
        rst = 1; #10
        rst = 0; #20
        
        wrt = 1; 
        din = 8'h11; #10;
        din = 8'h22; #10;
        din = 8'h33; #10;
        din = 8'h44; #10;
        din = 8'h55; #10;
        din = 8'h66; #10;
        din = 8'h77; #10;
        din = 8'h88; #10;
        wrt = 0;
        
        //Overflow condition
        wrt = 1;
        din = 8'hAA; #10;
        wrt = 0;
        
        rd = 1; #40;
        rd = 0;
        
        wrt = 1;
        din = 8'h99; #10;
        din = 8'hBB; #10;
        wrt = 0;
        
        rd = 1; #80;
        rd = 0;
        
        //Underflow condition
        rd = 1;  #10;
        rd = 0;

        // Simultaneous Read and Write
        wrt = 1;
        din = 8'hCC; #10;
        wrt = 0;

        wrt = 1;
        rd  = 1;
        din = 8'hDD; #10;

        wrt = 0;
        rd  = 0;

        rd = 1; #20;
        rd = 0; #20;
        $finish;
    end
endmodule
