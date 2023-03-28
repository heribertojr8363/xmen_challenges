// FILE NAME            : median_tb.sv
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
	parameter DATA_SIZE = 9;
	bit clk, rst, busy, ready;
	bit [DATA_WIDTH - 1:0] num_i [DATA_SIZE - 1:0];
	bit [DATA_WIDTH - 1:0] num_o [DATA_SIZE - 1:0];
	bit [DATA_WIDTH - 1:0] median_o; 
	int vector[];
	int median;
	int n = DATA_SIZE;
	ordenator #(.DATA_WIDTH(DATA_WIDTH),.DATA_SIZE(DATA_SIZE)) dut1
	(
		.clk_i (clk),
		.rstn_i (rst),
		.numbers_i (num_i),
		.numbers_o (num_o),
		.busy_o(busy),
		.ready(ready)
		);

	median #(.DATA_WIDTH(DATA_WIDTH),.DATA_SIZE(DATA_SIZE)) dut2
	(
		.clk_i (clk),
		.rstn_i (rst),
		.numbers_i (num_o),
		.numbers_o (median_o),
		.ready(ready)
		);

	initial
	begin
		reset_module();
		vector = new [n];
		for (int j = 0; j < n; j++) begin
			$display("%d ATTEMPT \n",j+1);
			for (int l = 0; l < n; l++) begin
				vector[l] = $urandom_range(0,255);
			end

			test_median(vector, n);

			for (int k = 0; k < n; k++) begin
				if (num_o[k] != vector[k])
					$display("*ERROR ORDER* - VECTOR[%d] IS %d. NUM_O[%d] IS %d \n",k, vector[k],k, num_o[k]); 
				else
					$display("*PASSED* - VECTOR[%d] IS %d. NUM_O[%d] IS %d \n",k, vector[k],k, num_o[k]);
			end

			if (median_o != median)
				$display("*ERROR ORDER* - MEDIAN(REF) IS %d. MEDIAN_O IS %d \n",median,median_o); 
			else
				$display("*PASSED* - MEDIAN(REF) IS %d. MEDIAN_O IS %d \n",median,median_o);
		end
		$finish();
	end
	task reset_module;
		clk = 1'b0;
		#10ns rst = 1'b0;
		#10ns rst = 1'b1;
	endtask
	task automatic bubblesort_median (ref int v [], int n);
    	int k, j, aux, aux_1;

    	for (k = 0; k < n-1; k++) begin
        	for (j = 0; j < n-1; j++) begin
            	if (v[j] > v[j + 1]) begin
                	aux          = v[j];
                	v[j]     = v[j + 1];
                	v[j + 1] = aux;
            	end
        	end
    	end
    	aux_1 = (n/2);
		median = v[aux_1];
	endtask

	task automatic test_median(ref int vector [], int n);

			for (int i = 0; i < n; i++) begin
				num_i[i] = vector[i];
			end
			for(int i=0; i<((n-1)*(n-1)); i++)
			begin
				#10ns clk = ~clk;
				#10ns clk = ~clk;
			end
			bubblesort_median(vector, n);
	endtask
endmodule
