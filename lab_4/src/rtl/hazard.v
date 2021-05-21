`timescale 1ns/1ps
module hazard (
    input wire regwriteE,regwriteM,regwriteW,memtoRegE,branchD,
    input wire [4:0]rsD,rtD,rsE,rtE,reg_waddrM,reg_waddrW,reg_waddrE,
    output wire stallF,stallD,flushE,forwardAD,forwardBD,
    output wire[1:0] forwardAE, forwardBE
);

    // 数据冒险
    assign forwardAE =  ((rsE != 5'b0) & (rsE == reg_waddrM) & regwriteM) ? 2'b10: // 前推计算结果
                        ((rsE != 5'b0) & (rsE == reg_waddrW) & regwriteW) ? 2'b01: // 前推写回结果
                        2'b00; // 原结果
    assign forwardBE =  ((rtE != 5'b0) & (rtE == reg_waddrM) & regwriteM) ? 2'b10: // 前推计算结果
                        ((rtE != 5'b0) & (rtE == reg_waddrW) & regwriteW) ? 2'b01: // 前推写回结果
                        2'b00; // 原结果
    
    wire lwstall; // lw指令导致阻塞
    // 判断 decode 阶段 rs 或 rt 的地址是否是 lw 指令要写入的地址；
    assign lwstall = ((rsD == rtE) | (rtD == rsE)) & memtoRegE; // FIXME 不是很懂这句话诶
    

    // 控制冒险产生的写冲突
    // 0 原结果， 1 写回结果
    assign forwardAD = (rsD != 5'b0) & (rsD == reg_waddrM) & regwriteM;
    assign forwardBD = (rtD != 5'b0) & (rtD == reg_waddrM) & regwriteM;

    wire branch_stall; // branch 指令导致阻塞
    assign branch_stall =   (branchD & regwriteE & ((rsD == reg_waddrE)|(rtD == reg_waddrE))) |
                            (branchD & memtoRegE & ((rsD == reg_waddrM)|(rtD == reg_waddrM))); // FIXME 不是很懂这里的memtoRegE 
    assign stallF = lwstall | branch_stall;
    assign stallD = lwstall | branch_stall;
    assign flushE = lwstall | branch_stall;
endmodule