// FILE NAME            : seq_identifier_tb.sv
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
	logic clk, rst, enb;
	logic [3:0] ref_u;
	logic bit_u;
	logic flag;
	seq_identifier dut(
		.clk_i (clk),
		.rstn_i (rst),
		.bit_i (bit_u),
		.ref_i (ref_u),
		.flag_o (flag)
		);
	initial
	begin
		for(int i = 0; i < 10; i++) begin
			reset_module();
			ref_u = $urandom_range(0,15);
			$display("SEQUÊNCIA DE REFERÊNCIA: %b \n", ref_u);
			for (int j = 0; j < 20; j++) begin
				bit_u = $urandom_range(0,1);
				if (flag == 1)
					$display("SEQUÊNCIA IDENTIFICADA: %b \n", ref_u); 
				#10ns clk = ~clk;
				#10ns clk = ~clk;
				$display("%b \n", bit_u);
			end
		end
		$finish();
	end
	task reset_module;
		clk = 1'b0;
		#10ns rst = 1'b0;
		#10ns rst = 1'b1;
	endtask
endmodule
