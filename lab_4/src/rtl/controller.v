`timescale 1ns/1ps
module controller (
    input wire [31:0]instrD,
    output wire regwriteW,regdstE,alusrcE,branchD,memWriteM,memtoRegW,jumpD, // input wire 
    // 数据冒险添加信号
    output wire regwriteE,regwriteM,memtoRegE, // input wire 
    output wire [2:0]alucontrolE
);
    
    assign regwriteW = signsW[6];
    assign regwriteE = signsE[6];
    assign regwriteM = signsM[6];
    assign regdstE = signsE[5];
    assign alusrcE = signsE[4];
    assign branchD = signsD[3];
    assign memWriteM = signsM[2];
    assign memtoRegW = signsW[1];
    assign memtoRegE = signsE[1];
    assign jumpD = signsD[0];

    wire [1:0]aluop;
    wire [6:0]signsD; // signsD = {6regwrite,5regdst,4alusrc,3branch,2memWrite,1memtoReg,0jump}
    wire [2:0]alucontrolD;

// ====================================== Decoder ======================================
    main_dec main_dec(
        .op(instrD[31:26]),
        .signs(signsD),
        .aluop(aluop)
    );

    alu_dec alu_dec(
        .aluop(aluop),
        .funct(instrD[5:0]),
        .alucontrol(alucontrolD)
    );

// ====================================== Execute ======================================
wire [6:0]signsE;
wire [2:0]alucontrolE;
flopenr #(7) dff1E(clk,rst,clear,signsD,signsE);
flopenr #(3) dff2E(clk,rst,clear,alucontrolD,alucontrolE);

// ====================================== Memory ======================================
wire [6:0]signsM;
flopenr #(7) dff1M(clk,rst,clear,signsE,signsM);

// ====================================== WriteBack ======================================
wire [6:0]signsW;
flopenr #(7) dff1W(clk,rst,clear,signsM,signsW);


endmodule



module main_dec (
    input wire[5:0]op,
    // output wire regwrite,regdst,alusrc,branch,memWrite,memtoReg,jump,
    output wire [6:0]signs,
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
    // assign {regwrite,regdst,alusrc,branch,memWrite,memtoReg,aluop,jump} = temp;
    assign {signs[6:1],aluop,signs[0]} = temp;
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