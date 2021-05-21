`timescale 1ns / 1ps

module tb_top();
	reg clk;
	reg rst;

	wire[31:0] data_ram_wdata,data_ram_waddr;
	wire memWrite;

	top test(
		clk,rst,
		data_ram_wdata,data_ram_waddr,
		memWrite
    );

	initial begin 
		clk <= 0;
		rst <= 1;
		#200;
		rst <= 0;
	end


	always #10 begin clk <= ~clk; end
	// TODO instr_ram之前忘记导入指令，在不重新构建的情况下如何导入指令
	always @(negedge clk) begin
		if(memwrite) begin
			/* code */
			if(dataadr === 84 & writedata === 7) begin
				/* code */
				$display("Simulation succeeded");
				$stop;
			end else if(dataadr !== 80) begin
				/* code */
				$display("Simulation Failed");
				$stop;
			end
		end
	end
endmodule
