`timescale 1ns / 1ps
// done_TODO 实验重点 13点20分
module datapath (
    input wire clk,rst,
    input wire regwrite,regdst,alusrc,branch,memWrite,memtoReg,jump,
    input wire [2:0]alucontrol,
    input wire [31:0]instr,data_ram_rdata,
    output wire [31:0]pc_now,data_ram_waddr,data_ram_wdata
);

// pc
wire [31:0]pc_plus4,pc_branch,pc_next,instr_sl2,pc_next_jump;

// sign extend
wire [31:0]sign_imm,sign_imm_sl2;

// regfile
wire[5:0] wa3;
wire[31:0]rd1,rd2,wd3;

// alu
wire [31:0]srcB,alu_res;

// control
wire pcsrc,zero;

assign pcsrc = zero & branch;
assign data_ram_wdata = rd2;
mux2 mux2_branch(
    .a(pc_plus4),
    .b(pc_branch),
    .sel(pcsrc),
    .y(pc_next)
);

mux2 mux2_jump(
    .a(pc_next),
    .b({pc_plus4[31:28],instr_sl2[27:0]}),
    .sel(jump),
    .y(pc_next_jump)
);

pc pc(
    .clk(clk),
    .rst(rst),
    .din(pc_next_jump),
    .dout(pc_now)
);

adder adder(
    .a(pc_now),
    .b(32'd4),
    .y(pc_plus4)
);

mux2 #(5) mux2_regDst(
    .a(instr[20:16]),
    .b(instr[15:11]),
    .sel(regdst),
    .y(wa3)
);

regfile regfile(
	.clk(clk),
	.we3(regwrite),
	.ra1(instr[25:21]), 
    .ra2(instr[20:16]),
    .wa3(wa3),
	.wd3(wd3), 
	.rd1(rd1),
    .rd2(rd2)
);

signext sign_extend(
    .a(instr[15:0]), // input wire [15:0]a
    .y(sign_imm) // output wire [31:0]y
);

sl2 sl2_signImm(
    .a(sign_imm),
    .y(sign_imm_sl2)
);

sl2 sl2_instr(
    .a(instr),
    .y(instr_sl2)
);

adder adder_branch(
    .a(sign_imm_sl2),
    .b(pc_plus4),
    .y(pc_branch)
);

mux2 mux2_aluSrc(
    .a(rd2),
    .b(sign_imm),
    .sel(alusrc),
    .y(srcB)
);

alu alu(
    .a(rd1),
    .b(srcB),
    .f(alucontrol),
    .y(alu_res),
    .overflow(),
    .zero(zero)
);

mux2 mux2_memtoReg(
    .a(alu_res),
    .b(data_ram_rdata),
    .sel(memtoReg),
    .y(wd3)
);

assign data_ram_waddr = alu_res;

endmodule