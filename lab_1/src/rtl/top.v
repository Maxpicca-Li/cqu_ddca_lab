`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 19:26:52
// Design Name: 
// Module Name: top
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


module top(
    input wire clk,rst,
    input wire [7:0]num1,
    input wire [2:0]f,
    // output wire [31:0]res,
    output wire [6:0]seg,
    output wire [7:0]ans
    );

    wire [31:0]res;
    
    display display(
    .clk(clk),
    .reset(rst),
    .s(res),
    .seg(seg),
    .ans(ans)
    );

    alu alu(
    .a({24'b0,num1}),
    .b(32'h0001),
    .f(f),
    .y(res),
    .overflow()
    );

endmodule
