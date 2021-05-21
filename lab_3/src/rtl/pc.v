`timescale 1ns/1ps
// PC模块，一个D触发器
module pc (
    input wire clk,rst,
    input wire[31:0]din,
    output reg[31:0]dout
);
    always @(posedge clk) begin
        if(rst) dout <= 32'b0;
        else dout <= din;
    end
endmodule