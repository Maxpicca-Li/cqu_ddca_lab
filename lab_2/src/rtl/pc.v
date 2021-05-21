`timescale 1ns/1ps
// PC模块，一个D触发器
module pc (
    input wire clk,rst,
    input wire[31:0]din,
    output reg[31:0]dout,
    output wire instr_ce
);
    initial begin
        dout = 32'b0;
    end
    always @(posedge clk) begin
        if(rst) dout = 32'b0;
        else dout = din;
    end
    assign instr_ce = 1'b1; // instr_ram的使能信号，此处一直使能
endmodule