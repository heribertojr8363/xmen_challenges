module tb;
	logic clk, rst, enb;
	logic [7:0] num_i, sqt_o;
	int sqt_num, sqt_b;
	behaviour_sqrt dut(
		.dt_i (num_i),
		.clk_i (clk),
		.rstn_i (rst),
		.enb_i (enb),
		.dt_o (sqt_o)
		);
	initial
	begin
		reset_module();
		for (int j = 0; j < 256; j++) begin
			test_sqt(j);
			if (sqt_o != sqt_num)
				$display("*ERROR SQRT* - DT_I IS %d. DT_O IS %d \n", num_i, sqt_o); 
		end
		for (int k = 0; k < 256; k++) begin
			enb = 1'd1;
			test_enb(k); 
		end
		$finish();
	end
	task reset_module;
		enb = 1'd1;
		clk = 1'b0;
		#10ns rst = 1'b0;
		#10ns rst = 1'b1;
	endtask
	task sqt_py(int test_number);
		int d,s;
		d=2;
		s=4;
		while (s<=test_number) begin
			d = d + 2;
			s = s + d + 1;
		end
		if (test_number == 0) begin
			sqt_num = 0;
		end
		else
			sqt_num = d/2;
	endtask
	task test_sqt(int test_number);
			num_i = test_number;
			sqt_py(test_number);
			for(int i=0; i<15; i++)
			begin
				#10ns clk = ~clk;
				#10ns clk = ~clk;
			end
	endtask
	task test_enb (int test_number);
		test_sqt(test_number);
		sqt_b = sqt_o;
		enb = 1'd0;
		if (test_number != 255)
			test_sqt(test_number+1);
		else
			test_sqt(0);
		if(sqt_o != sqt_b)
			$display("*ERROR ENB* - DT_I IS %d. DT_O IS %d. DT_B IS %d \n", num_i, sqt_o, sqt_b);
	endtask
endmodule
