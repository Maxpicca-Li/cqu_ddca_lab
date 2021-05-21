`timescale 1ns / 1ps
`define T 10
`define halfT 5

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/10 08:22:07
// Design Name: 
// Module Name: tb_pipeline
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



module tb_pipeline();
    parameter WIDTH = 32;
    reg clk,rst,valid_in,out_allow,c_in;
    reg [3:0]pause;
    reg [3:0]refresh;
    reg [WIDTH-1:0]data_a;
    reg [WIDTH-1:0]data_b;
    wire c_out;
    wire vaild_out;
    wire [WIDTH-1:0] sum_out;

    stallable_pipeline_adder pipeline_test(
    .clk(clk),.rst(rst),
    .valid_in(valid_in), .out_allow(out_allow),
    .pause(pause),
    .refresh(refresh),
    .c_in(c_in),
    .data_a(data_a),
    .data_b(data_b),
    .c_out(c_out),
    .vaild_out(vaild_out),
    .sum_out(sum_out)
    );

    // parameter i = 0;
    
    always #(`halfT) begin clk = ~clk; end

    initial begin
        clk = 0;
        rst = 0;
        valid_in = 1;
        out_allow = 1;
        c_in = 0;
        pause = 4'b0000;
        refresh = 4'b0000;
        data_a = 32'd18;
        data_b = 32'd13;

        repeat(10) begin 
            #(`T) ; 
        end
        // for (i=0;i<10;i=i+1) begin
        //     #(`T) 
        // end

        pause[1] = 1'b1;
        repeat(2) begin #(`T) ; end
        pause[1] = 1'b0;

        repeat(3) begin  #(`T) ; end
        refresh[2] = 1'b1;

        repeat(2) begin #(`T); end
        refresh[2] = 1'b0;

        repeat(5) begin #(`T); end

        $stop;
    end
endmodule
