module tb;
	logic clk, rst, div_clk;
	logic [1:0] divisor;
	freq_divider dut(
		.clk_i (clk ),
		.rst_i (rst ),
		.selector_i (divisor ),
		.clk_o (div_clk )
		);
	initial
	begin
		reset_module();
		$monitor("DIV_CLK IS %b @TIME:%3dns.\n", div_clk, $time);
		test(0);
		test(1);
		test(2);
		test(3);
		$finish();
	end
	task reset_module;
		clk = 1'b1;
		#10ns rst = 1'b1;
		#10ns rst = 1'b0;
	endtask
	task test(int test_number);
		divisor = test_number;
		for(int i=0; i<32; i++)
		begin
			#10ns clk = ~clk;
			#10ns clk = ~clk;
		end
	endtask
endmodule