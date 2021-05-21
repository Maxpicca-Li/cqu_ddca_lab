`timescale 1ns / 1ns
module test_bench();
	
	reg rst;
	reg clk;
	wire [7:0] ans;
	wire [6:0] seg;
	wire [10:0] led;
	initial begin 
		clk = 1'b0;
		rst = 1'b1;
		#100;
		rst = 1'b0;
		#800;
		$stop;
	end
	always #1 clk = ~clk;

	top #(100) top(
		.bclk(clk),
		.rst(rst),
		.seg(seg),
	    .ans(ans),
	    .led(led)
		);
endmodule
