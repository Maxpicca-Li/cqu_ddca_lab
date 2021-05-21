`timescale 1ns/1ns
module tb_fdivider ();
    reg clk;
    reg [31:0]rate;
    wire myclk;
    initial begin
        clk = 1'b0;
        rate = 32'd100;
        #1000;
        $stop;
    end    
    always #1 clk=~clk;

    fdivider fdivider(clk,rate,myclk); 
endmodule