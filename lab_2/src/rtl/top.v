`timescale 1ns/1ps
module top #(parameter rate = 32'd1_0000_0000)(
    input wire bclk,rst,
    output wire [10:0]led,
    output wire [6:0]seg,
    output wire [7:0]ans
);

wire regwrite,regdst,alusrc,branch,memWrite,memtoReg,jump,zero,pcsrc;
wire [2:0]alucontrol;
wire [31:0]pc_plus4,pc_now,instr;
wire myclk;

assign zero = 1'b0; // 此处恒为0，这是alu计算的结果
assign led = {alucontrol,branch,jump,regwrite,regdst,alusrc,pcsrc,memWrite,memtoReg};

fdivider fdivider(
    .clk(bclk),
    .rate(rate),
    .myclk(myclk)
);

pc pc(
    .clk(myclk),
    .rst(rst),
    .din(pc_plus4),
    .dout(pc_now),
    .instr_ce(instr_rom_ena)
);

// done_FIXME pcnow的初始化问题 ==> 必须要先使用rst进行初始化
// done_FIXME pc+4,读地址时，从pc_now[11:2]读起
adder adder(
    .a(pc_now),
    .b(32'd4),
    .y(pc_plus4)
);

always @(posedge myclk) begin
    $display("instruction: 32'h%h, memtoReg: %b, memWrite: %b, pcsrc: %b, alusrc: %b, regdst: %b, regwrite: %b, jump: %b, branch: %b, alucontrol: %b", instr, memtoReg, memWrite,pcsrc,alusrc,regdst,regwrite,jump,branch,alucontrol);
end

controller controller(
    .instr(instr),
    .zero(zero),
    .regwrite(regwrite),
    .regdst(regdst),
    .alusrc(alusrc),
    .branch(branch),
    .memWrite(memWrite),
    .memtoReg(memtoReg),
    .jump(jump),
    .pcsrc(pcsrc),
    .alucontrol(alucontrol)
);

display display(
    .clk(bclk), // 注意，这里使用的默认clk
    .reset(rst),
    .s(instr),
    .seg(seg),
    .ans(ans)
);

// instr_rom
blk_mem_gen_0 instr_rom (
    .clka(myclk),    // input wire clka
    .ena(instr_rom_ena),      // input wire ena
    .addra(pc_now[11:2]),  // input wire [9 : 0] addra
    .douta(instr)  // output wire [31 : 0] douta
);

endmodule