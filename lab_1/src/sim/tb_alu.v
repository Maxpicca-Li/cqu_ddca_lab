`timescale 1ns / 1ps
`define halfclk 5
`define clock 10
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 19:55:43
// Design Name: 
// Module Name: tb_alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_alu();
    reg clk,rst;
    reg [7:0]num1;
    reg [2:0]f;
    wire [31:0]res;
    wire [6:0]seg;
    wire [7:0]ans;

    always #(`halfclk) clk = ~clk;
    top mytop(
        .clk(clk),
        .rst(rst),
        .num1(num1),
        .f(f),
        // .res(res),
        .seg(seg),
        .ans(ans)
    );
    initial begin
        clk = 0;
        rst = 1;

        // 加法
        #(`clock) rst = 0;
        num1 = 8'b00000010;
        f = 3'b000;
        
        #(`clock) $display($time, "==> %d + 1 = %d; bin: %b", num1, res, res);
        
        // 减法
        #(`clock) 
        num1 = 8'b11111111;
        f = 3'b001;
        
        #(`clock) $display($time, "==> %d - 1 = %d, bin: %b", num1, res, res);
        
        // and
        #(`clock) 
        num1 = 8'b11111110;
        f = 3'b010;
        
        #(`clock) $display($time, "==> %b & 1 = %b", num1, res);

        // or
        #(`clock) 
        num1 = 8'b10101010;
        f = 3'b011;
        
        #(`clock) $display($time, "==> %b | 1 = %b", num1, res);

        // not
        #(`clock)  
        num1 = 8'b11110000;
        f = 3'b100;
        
        #(`clock) $display($time, "==> ~%8b = %b", num1, res);

        // <
        #(`clock) 
        num1 = 8'b10000001;
        f = 3'b101;
        
        #(`clock) $display($time, "==> %d < 1 = %d, bin: %b", num1, res,res);

        $stop;
    end
endmodule
