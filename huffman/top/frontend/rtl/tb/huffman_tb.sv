// FILE NAME            : huffman_tb.sv
// AUTHOR               : Heriberto Fonseca
// AUTHOR'S E-MAIL      : heriberto.fonseca@embedded.ufcg.edu.br
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR              DESCRIPTION
// 0.1      2023-03-13  heriberto.fonseca         Initial version
// -----------------------------------------------------------------------------
// KEYWORDS: RTL
// -----------------------------------------------------------------------------
// PURPOSE: 
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Other: N/A

module tb;
	parameter DATA_WIDTH = 8;

	logic clk, rst, serial,val, rdy;
	logic [4:0] symbol;

	

	huffman #(.DATA_WIDTH(DATA_WIDTH)) dut
	(
		.clk_i (clk),
		.rstn_i (rst),
		.serial_i(serial),
		.symbol_o (symbol),
		.ready(rdy),
		.valid(val)
		);


	initial
	begin
		reset_module();
		for (int i = 0; i < 10 ; i++) begin
			test();
		end
		$finish();
	end


	task test;
		for (int j = 0; j < 20; j++) begin
			#10ns clk = ~clk;
			if(rdy) begin
				serial = $urandom_range(0,1);
				$display("SERIAL_I = %d", serial);
			end
			#10ns clk = ~clk;
			if(val)
				$display("SYMBOL_O = %d", symbol); 
		end
	endtask

	task reset_module;
		clk = 1'b0;
		#10ns rst = 1'b0;
		#10ns rst = 1'b1;
	endtask 
endmodule
