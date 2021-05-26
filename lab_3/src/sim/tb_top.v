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
		#50;
		rst <= 0;
	end


	always #10 begin clk <= ~clk; end
	always @(negedge clk) begin
		if(memWrite) begin
			/* code */
			if(data_ram_waddr === 84 & data_ram_wdata === 7) begin
				/* code */
				$display("Simulation succeeded");
				$stop;
			end else if(data_ram_waddr !== 80) begin
				/* code */
				$display("Simulation Failed");
				$stop;
			end
		end
	end
endmodule
