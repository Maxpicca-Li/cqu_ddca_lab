`timescale 1ns / 1ps

// TODO 视频中提到的那个问题，lw,sw都要单独占用一个周期

module top(
	input wire clk,rst,
	output wire[31:0] data_ram_wdata,data_ram_waddr,
	output wire memWrite
    );
	
wire[31:0] pc,instr,data_ram_rdata;
wire instr_ram_ena,data_ram_ena;

mips mips(
	clk,rst,
	instr,data_ram_rdata, // 前in 后out
	memWrite,
	pc,data_ram_waddr,data_ram_wdata
);

// TODO 这个可以直接写在这里，就不向mips的controll传递了吗
assign instr_ram_ena = 1'b1;
assign data_ram_ena = 1'b1;

instr_ram instr_ram (
  .clka(clk),    // input wire clka
  .ena(instr_ram_ena),      // input wire ena
  .wea(3'b0),      // input wire [3 : 0] wea 只读
  .addra(pc[9:2]),  // input wire [7 : 0] addra // FIXME pc+4的话，这里就应该是pc[9:2] 
  .dina(32'b0),    // input wire [31 : 0] dina 只读
  .douta(instr)  // output wire [31 : 0] douta
);

data_ram data_ram (
  .clka(clk),    // input wire clka
  .ena(data_ram_ena),      // input wire ena
  .wea({4{memWrite}}),      // input wire [3 : 0] wea
  .addra(data_ram_waddr[9:0]),  // input wire [9 : 0] addra
  .dina(data_ram_wdata),    // input wire [31 : 0] dina
  .douta(data_ram_rdata)  // output wire [31 : 0] douta
);
	
endmodule
