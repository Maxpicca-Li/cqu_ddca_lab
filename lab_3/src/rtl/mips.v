`timescale 1ns / 1ps

module mips(
	input wire clk,rst,
	input wire[31:0] instr,data_ram_rdata, // 前in 后out
	output wire memWrite, 
	output wire[31:0] pc,data_ram_waddr,data_ram_wdata
);
	
	wire regwrite,regdst,alusrc,branch,memWrite,memtoReg,jump;
	wire[2:0] alucontrol;
	wire [31:0]pc_now,alu_res;
	
	assign pc = pc_now;
	assign data_ram_waddr = alu_res;

	controller controller(
		instr, // 前in - 后out
		regwrite,regdst,alusrc,branch,memWrite,memtoReg,jump,
		alucontrol
	);

	datapath datapath(
		clk,rst,
		regwrite,regdst,alusrc,branch,memWrite,memtoReg,jump,
		alucontrol, 
		instr,data_ram_rdata, // 前in - 后out
		pc_now,alu_res,data_ram_wdata
	);
	
endmodule
