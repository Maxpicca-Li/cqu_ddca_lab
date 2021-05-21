`timescale 1ns / 1ps

module mips(
	input wire clk,rst,
	input wire[31:0] instr,data_ram_rdata, // 前in 后out
	output wire memWrite, 
	output wire[31:0] pc,data_ram_waddr,data_ram_wdata
);
	
	wire regwriteW,regdstE,alusrcE,branchM,memWriteM,memtoRegW,jumpD;
	wire[2:0] alucontrolE;
	wire [31:0]pc_now,instrD;
	
	assign pc = pc_now;

	// 注意：这里的指令就是直接来源于datapath中提供的instrD
	controller controller(
		instrD, // 前in - 后out
		regwriteW,regdstE,alusrcE,branchD,memWriteM,memtoRegW,jumpD, // input wire 
    	// 数据冒险添加信号
		regwriteE,regwriteM,memtoRegE, // input wire 
		alucontrolE
	);

	datapath datapath(
		clk,rst, // input wire 
		regwriteW,regdstE,alusrcE,branchD,memWriteM,memtoRegW,jumpD, // input wire 
		alucontrolE, // input wire [2:0]
		// 数据冒险添加信号
		regwriteE,regwriteM,memtoRegE, // input wire 
		instr,data_ram_rdata, // input wire [31:0]
		instrD,pc_now,data_ram_waddr,data_ram_wdataM // output wire [31:0]
	);
	
endmodule
