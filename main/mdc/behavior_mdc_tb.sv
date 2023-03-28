module behavior_mdc_tb;

//=========================================================
// Interface
//=========================================================
	logic clk, rst, enb;
	logic [7:0] dtx_i, dty_i, dt_o;
	int mdc, mdc_b;

//=========================================================
// DUT Instanciation
//=========================================================
	behavior_mdc dut(
		.clk_i (clk),
		.rstn_i (rst),
		.enb_i (enb),
		.dtx_i (dtx_i),
		.dty_i (dty_i),
		.dt_o (dt_o)
		);


//=========================================================
// Inital Block
//=========================================================
	initial
	begin
		reset_module();
		for (int i = 0; i < 256; i++) begin
			for (int j = 0; j < 256; j++) begin
				test_mdc(i,j);
				if (dt_o != mdc)
					$display("*ERROR MDC* - DTX_I IS %d. DTY_I IS %d. DT_O IS %d. MDC IS %d. \n", dtx_i, dty_i, dt_o, mdc);
			end
		end
		for (int i = 0; i < 256; i++) begin
			for (int j = 0; j < 256; j++) begin
				enb = 1'd1;
				test_enb(i,j); 
			end
		end
		$finish();
	end

//=========================================================
// Tasks & Functions
//=========================================================
	task reset_module;
		enb = 1'd1;
		clk = 1'b0;
		#10ns rst = 1'b0;
		#10ns rst = 1'b1;
	endtask
	task mdc_refmod(int x, int y);
		if (x == 0 | y == 0) 
		begin
			if (x!=0)
				mdc = x;
			else if (y!=0)
				mdc = y;
			else
				mdc = 0;
		end
		else 
		begin
			while (x != y) begin
				if(x > y)
					x = x - y;
				else
					y = y - x;
			end
			mdc = x;
		end
	endtask
	task test_mdc(int x, int y);
			dtx_i = x;
			dty_i = y;
			mdc_refmod(x,y);
			for(int k=0; k<500; k++)
			begin
				#10ns clk = ~clk;
				#10ns clk = ~clk;
			end
	endtask
	task test_enb (int x, int y);
		test_mdc(x, y);
		mdc_b = dt_o;
		enb = 1'd0;
		if ((x != 255) && (y != 255))
			test_mdc((x+1),(y+1));
		else
			test_mdc(0,0);
		if(dt_o != mdc_b)
			$display("*ERROR ENB* - DTX_I IS %d. DTY_I IS %d. DT_O IS %d. DT_B IS %d \n", dtx_i, dty_i, dt_o, mdc_b);
	endtask
endmodule
