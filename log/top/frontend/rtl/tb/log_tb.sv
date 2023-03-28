// FILE NAME            : log_tb.sv
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

	logic clk, rst;
	logic [DATA_WIDTH - 1:0] num_i;
	logic [DATA_WIDTH - 1:0] num_o, maior;
	logic [DATA_WIDTH-1:0] number [0:254];
	logic [DATA_WIDTH-1:0] erro [0:254];

	int n = 10;

	log #(.DATA_WIDTH(DATA_WIDTH)) dut
	(
		.clk_i (clk),
		.rstn_i (rst),
		.number_i(num_i),
		.number_o (num_o)
		);


	initial
	begin
		$readmemb("/home/heriberto.fonseca/Desktop/Microeletronica/Desafios_BRXMEN/log/top/frontend/rtl/tb/tabela_log2.txt", number);
		reset_module();
		//test(n, 0);
		//$display("LOG2 (REFMOD): INDETERMINADO. LOG2 (DUT): %f \n", ($itor(num_o*0.03125))); 
		for (int i = 1; i < 256 ; i++) begin
			test(n,i);
			$display("LOG2 (REFMOD): %f. LOG2 (DUT): %f \n",($itor((number[i-1])*0.03125)), ($itor(num_o*0.03125)));
			erro_rel(i);
			$display("ERRO RELATIVO: %f \n",($itor(erro[i-1]*0.03125)));
			//maior_rel(i);
		end
		//$display("MAIOR ERRO RELATIVO: %f \n",($itor(maior*0.03125)));
		$finish();
	end


	task test (int k, int l);
		
		#10ns clk = ~clk;
		num_i = l;
		$display("NUMBER_I = %d",num_i);
		#10ns clk = ~clk;


		for(int i=0; i<n+1; i++)
		begin
			#10ns clk = ~clk;
			#10ns clk = ~clk;
		end
	endtask

	task erro_rel (int l);
		if(number[l-1] > num_o)
			erro[l-1] = number[l-1] - num_o;
		else
			erro[l-1] = num_o - number[l-1];
	endtask

	/*task maior_rel (int l);
		if(erro[l] > erro[l-1])
			maior = erro[l];
		else
			maior = erro[l-1];
	endtask*/

	task reset_module;
		clk = 1'b0;
		#10ns rst = 1'b0;
		#10ns rst = 1'b1;
	endtask 
endmodule
