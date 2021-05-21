`timescale 1ns / 1ps
// done_TODO 实验重点 13点20分
module datapath (
    input wire clk,rst,
    input wire regwriteW,regdstE,alusrcE,branchD,memWriteM,memtoRegW,jumpD,
    input wire [2:0]alucontrolE,
    // 数据冒险添加信号
    input wire regwriteE,regwriteM,memtoRegE,
    input wire [31:0]instr,data_ram_rdata,
    output wire [31:0]instrD,pc_now,data_ram_waddr,data_ram_wdataM
);

// pc
wire [31:0]pc_plus4,pc_branch,pc_next,instr_sl2,pc_next_jump;
// sign extend
wire [31:0]sign_imm,sign_imm_sl2;
// regfile
wire[5:0] wa3;
wire[31:0]rd1,rd2,wd3;
// alu
wire [31:0]srcB;
// control
wire pcsrcD,zero,clear,ena;
assign clear = 1'b0;
assign ena = 1'b1;

// ====================================== Fetch ======================================
mux2 mux2_branch(
    .a(pc_plus4),
    .b(pc_branchM),
    .sel(pcsrcD),
    .y(pc_next)
);

mux2 mux2_jump(
    .a(pc_next),
    .b({pc_plus4[31:28],instr_sl2[27:0]}),
    .sel(jumpD),
    .y(pc_next_jump)
);

pc pc(
    .clk(clk),
    .rst(rst),
    .ena(~stallF),
    .din(pc_next_jump),
    .dout(pc_now)
);

adder adder(
    .a(pc_now),
    .b(32'd4),
    .y(pc_plus4)
);

// ====================================== Decoder ======================================
wire [31:0]instrD,pc_plus4D;
wire [4:0]rtD,rdD,rsD;
assign rtD = instrD[20:16];
assign rdD = instrD[15:11];
assign rsD = instrD[25:21];

flopenrc dff1D(clk,rst,clear,~stallD,instr,instrD);
flopenrc dff2D(clk,rst,clear,~stallD,pc_plus4,pc_plus4D);

regfile regfile(
	.clk(clk),
	.we3(regwriteW),
	.ra1(instrD[25:21]), 
    .ra2(instrD[20:16]),
    .wa3(wa3),
	.wd3(wd3), 
	.rd1(rd1),
    .rd2(rd2)
);

// ************************************* 控制冒险 ***************************************
// 在 regfile 输出后添加一个判断相等的模块，即可提前判断 beq，以将分支指令提前到Decode阶段
wire [31:0]rd1_branch,rd2_branch;
mux2 mux2_rs1Branch(rd1,alu_resM,forwardAD,rd1_branch);
mux2 mux2_rs2Branch(rd2,alu_resM,forwardBD,rd2_branch);
wire equalD;
assign equalD = (rd1_branch == rd2_branch);
assign pcsrcD = equalD & branchD;


signext sign_extend(
    .a(instrD[15:0]), // input wire [15:0]a
    .y(sign_imm) // output wire [31:0]y
);

// ====================================== Execute ======================================
wire [31:0]rd1E,rd2E, sign_immE, pc_plus4E;
wire [4:0]rtE,rdE,rsE,reg_waddrE;
flopenrc dff1E(clk,rst,flushE,ena,rd1,rd1E);
flopenrc dff2E(clk,rst,flushE,ena,rd2,rd2E);
flopenrc dff3E(clk,rst,flushE,ena,sign_imm,sign_immE);
flopenrc dff4E(clk,rst,flushE,ena,pc_plus4D,pc_plus4E);
flopenrc #(5) dff5E(clk,rst,flushE,ena,rtD,rtE);
flopenrc #(5) dff6E(clk,rst,flushE,ena,rdD,rdE);
flopenrc #(5) dff7E(clk,rst,flushE,ena,rsD,rsE);

mux2 #(5) mux2_regDst(
    .a(rtE),
    .b(rdE),
    .sel(regdstE),
    .y(reg_waddrE)
);

sl2 sl2_signImm(
    .a(sign_immE),
    .y(sign_imm_sl2)
);

// FIXME 这里jump设置的是，Decoder阶段返回
sl2 sl2_instr(
    .a(instrD),
    .y(instr_sl2)
);

adder adder_branch(
    .a(sign_imm_sl2),
    .b(pc_plus4E),
    .y(pc_branch)
);

mux2 mux2_aluSrc(
    .a(rd2E_sel),
    .b(sign_immE),
    .sel(alusrcE),
    .y(srcB)
);

// 00原结果，01写回结果_W， 10计算结果_M
wire [31:0]rd1E_sel,rd2E_sel;
mux3 #(32) mux3_rd1E(rd1E,wd3,alu_resM,forwardAE,rd1E_sel);
mux3 #(32) mux3_rd2E(rd2E,wd3,alu_resM,forwardBE,rd2E_sel);

alu alu(
    .a(rd1E_sel),
    .b(srcB),
    .f(alucontrolE),
    .y(alu_res),
    .overflow(),
    .zero(zero)
);

// ====================================== Memory ======================================
// wire zeroM; ==> 控制冒险，已将分支指令提前到Decode阶段
wire [31:0]alu_resM,data_ram_wdataM,pc_branchM;
wire [4:0]reg_waddrM;
flopenrc dff1M(clk,rst,clear,ena,alu_res,alu_resM);
flopenrc dff2M(clk,rst,clear,ena,rd2E,data_ram_wdataM);
flopenrc dff3M(clk,rst,clear,ena,pc_branch,pc_branchM);
// flopenrc #(1) dff4M(clk,rst,clear,ena,zero,zeroM);  ==> 控制冒险，已将分支指令提前到Decode阶段
flopenrc #(5) dff5M(clk,rst,clear,ena,reg_waddrE,reg_waddrM);

assign data_ram_waddr = alu_resM;
// assign pcsrcM = zeroM & branchM;  ==> 控制冒险，已将分支指令提前到Decode阶段

// ====================================== WriteBack ======================================
wire [31:0]alu_resW,data_ram_rdataW;
wire [4:0]reg_waddrW;
flopenrc dff1W(clk,rst,clear,ena,alu_resM,alu_resW);
flopenrc dff2W(clk,rst,clear,ena,data_ram_rdata,data_ram_rdataW);
flopenrc #(5) dff3W(clk,rst,clear,ena,reg_waddrM,reg_waddrW);

mux2 mux2_memtoReg(
    .a(alu_resW),
    .b(data_ram_rdataW),
    .sel(memtoRegW),
    .y(wd3)
);

// ************************************* Hazard *****************************************
// done_TODO reg_waddrM，reg_waddrW这两个地址哪里来
wire [1:0]forwardAE,forwardBE;
wire stallF,stallD,flushE,forwardAD,forwardBD;
hazard hazard(
    regwriteE,regwriteM,regwriteW,memtoRegE,branchD, // input wire 控制信号--control
    rsD,rtD,rsE,rtE,reg_waddrM,reg_waddrW,reg_waddrE, // input wire [4:0]
    stallF,stallD,flushE,forwardAD,forwardBD, // output wire 
    forwardAE, forwardBE // output wire[1:0] 
);

endmodule