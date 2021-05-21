`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 20:58:45
// Design Name: 
// Module Name: stallable_pipeline_adder
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


module stallable_pipeline_adder #(parameter WIDTH = 32)(
    // TODO 刷新第X级，是指第X级及其之前的置零，还是之后的置零？
    input wire clk,rst,
    input wire valid_in, out_allow,
    input wire [3:0]pause,
    input wire [3:0]refresh,
    input wire c_in,
    input wire [WIDTH-1:0]data_a,
    input wire [WIDTH-1:0]data_b,
    output wire c_out,
    output wire vaild_out,
    output wire [WIDTH-1:0] sum_out
    );


    // ===================pipline stage 1=======================
    reg pip1_vaild;
    reg c_out1;
    reg [7:0]sum_out1;
    wire pip1_allowin;
    wire pip1_ready_go;
    wire pip1_to_pip2_vaild;
    
    assign pip1_ready_go = !pause[0];
    assign pip1_allowin = !pip1_vaild || pip1_ready_go && pip2_allowin;
    assign pip1_to_pip2_vaild = pip1_vaild && pip1_ready_go;
    always @(posedge clk) begin
        if(rst || refresh[3:0]>=1'b1) pip1_vaild <= 1'b0;
        else if(pip1_allowin) pip1_vaild <= valid_in;
        if(valid_in && pip1_allowin)
            {c_out1,sum_out1} <= {1'b0, data_a[7:0]}+{1'b0,data_b[7:0]}+c_in;
        // else  // FIXME 这一句要写吗？
        //     {c_out1,sum_out1} <= 1'b0;
        // FIXME 或者不要if条件，直接赋值，由vaild来外交
        // {c_out1,sum_out1} <= {1'b0, data_a[7:0]}+{1'b0,data_b[7:0]}+c_in;
    end



    // =======================pipline stage 2=======================
    reg pip2_vaild;
    reg c_out2;
    reg [7:0]sum_out2;
    wire pip2_allowin;
    wire pip2_ready_go;
    wire pip2_to_pip3_vaild;
    
    assign pip2_ready_go = !pause[1];
    assign pip2_allowin = !pip2_vaild || pip2_ready_go && pip3_allowin;
    assign pip2_to_pip3_vaild = pip2_vaild && pip2_ready_go;
    always @(posedge clk) begin
        if(rst || refresh[3:1]>=1'b1) pip2_vaild <= 1'b0;
        else if(pip2_allowin) pip2_vaild <= pip1_to_pip2_vaild;

        if(pip1_to_pip2_vaild && pip2_allowin)
            {c_out2,sum_out2} <= {1'b0, data_a[15:8]}+{1'b0,data_b[15:8]}+c_out1;
            // reg [15:0]sum_out2;
            // {c_out2,sum_out2} <= {{1'b0, data_a[15:8]}+{1'b0,data_b[15:8]}+c_out1, sum_out1};
    end


    // =========================pipline stage 3=========================
    reg pip3_vaild;
    reg c_out3;
    reg [7:0]sum_out3;
    wire pip3_allowin;
    wire pip3_ready_go;
    wire pip3_to_pip3_vaild;
    
    assign pip3_ready_go = 1'b1;
    assign pip3_allowin = !pip3_vaild || pip3_ready_go && pip4_allowin;
    assign pip3_to_pip4_vaild = pip3_vaild && pip3_ready_go;

    always @(posedge clk) begin
        if(rst || refresh[3:2]>=1'b1) pip3_vaild <= 1'b0;
        else if(pip3_allowin) pip3_vaild <= pip2_to_pip3_vaild;

        if(pip2_to_pip3_vaild && pip3_allowin)
            {c_out3,sum_out3} <= {1'b0, data_a[23:16]}+{1'b0,data_b[23:16]}+c_out2;
            // reg [23:0]sum_out3;
            // {c_out3,sum_out3} <= {{1'b0, data_a[23:16]}+{1'b0,data_b[23:16]}+c_out2,sum_out2};
    end

    
    // ===========================pipline stage 4===========================
    reg pip4_vaild;
    reg c_out4;
    reg [7:0]sum_out4;
    wire pip4_allowin;
    wire pip4_ready_go;
    
    assign pip4_ready_go = 1'b1;
    assign pip4_allowin = !pip4_vaild || pip4_ready_go && out_allow;

    always @(posedge clk) begin
        if(rst || refresh[3]) pip4_vaild <= 1'b0;
        else if(pip4_allowin) pip4_vaild <= pip2_to_pip3_vaild;

        if(pip2_to_pip3_vaild && pip3_allowin)
            {c_out4,sum_out4} <= {1'b0, data_a[31:24]}+{1'b0,data_b[31:24]}+c_out3;
            // reg [31:0]sum_out4;
            // {c_out4,sum_out4} <= {{1'b0, data_a[31:24]}+{1'b0,data_b[31:24]}+c_out3,sum_out3};
    end

    assign sum_out = {sum_out4,sum_out3,sum_out2,sum_out1};
    assign c_out = c_out4;
    assign vaild_out = pip4_vaild && pip4_ready_go;

endmodule
