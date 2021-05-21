`timescale 1ns/1ps
module controller (
    input wire [31:0]instr,zero,
    output wire regwrite,regdst,alusrc,branch,memWrite,memtoReg,jump,pcsrc,
    output wire [2:0]alucontrol
);
    wire [1:0]aluop;
    assign pcsrc = zero & branch;
    main_dec main_dec(
        .op(instr[31:26]),
        .regwrite(regwrite),
        .regdst(regdst),
        .alusrc(alusrc),
        .branch(branch),
        .memWrite(memWrite),
        .memtoReg(memtoReg),
        .jump(jump),
        .aluop(aluop)
    );

    alu_dec alu_dec(
        .aluop(aluop),
        .funct(instr[5:0]),
        .alucontrol(alucontrol)
    );
    
endmodule



module main_dec (
    input wire[5:0]op,
    output wire regwrite,regdst,alusrc,branch,memWrite,memtoReg,jump,
    output wire [1:0]aluop
);
    wire [8:0]temp;
    assign  temp =  (op==6'b000000) ? 9'b110000100: //最后一位是jump
                    (op==6'b100011) ? 9'b101001000: 
                    (op==6'b101011) ? 9'b001010000: 
                    (op==6'b000100) ? 9'b000100010: 
                    (op==6'b001000) ? 9'b101000000: 
                    (op==6'b000010) ? 9'b000000001:
                    9'b000000000; // 注意：这里的X信号，全部视为0
    assign {regwrite,regdst,alusrc,branch,memWrite,memtoReg,aluop,jump} = temp;
endmodule


module alu_dec (
    input wire[1:0]aluop,
    input wire[5:0]funct,
    output wire[2:0]alucontrol
);
    assign alucontrol = (aluop==2'b00) ? 3'b010: // add
                        (aluop==2'b01) ? 3'b110: // sub
                        (aluop==2'b10) ? 
                            (funct==6'b100000) ? 3'b010:
                            (funct==6'b100010) ? 3'b110:
                            (funct==6'b100100) ? 3'b000:
                            (funct==6'b100101) ? 3'b001:
                            (funct==6'b101010) ? 3'b111:
                            3'b000:
                        3'b000; // default
endmodule