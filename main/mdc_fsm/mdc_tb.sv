module mdc_tb;

//=========================================================
// Interface
//=========================================================
	logic 		 clk;
	logic 		 rst_i;
	logic 		 enb_i;
	logic [7:0]  dtx_i;
	logic [7:0]  dty_i;
	logic        busy_o;
	logic [7:0]  dt_o;
  	
    int comp, test_num, errors_num, dto_tb;
  
//=========================================================
// DUT Instanciation
//=========================================================
	mdc dut(
		.clk(clk),
        .rstn_i(rst_i),
		.enb_i(enb_i),
		.dtx_i(dtx_i),
		.dty_i(dty_i),
		.dt_o(dt_o),
		.busy_o(busy_o)
    );
  
//=========================================================
// Inital Block
//=========================================================
	initial begin
      test_num = 0;
	  errors_num = 0;

	  rst_module;

      $display("\n========= BEM-VINDO AO TESTE ==========\n");
      for(int i = 1; i < 256; i++) begin //////////////////////////////////////////////
        for (int j = 1; j < 256; j++) begin
        	stimulus(i, j);
			clock(2000);
			dto_tb = refmod(i, j);
			comp = comparator(dt_o, dto_tb);
        	if(!comp) 
       		begin
        		$display("ERRO|dtx_i = %d; dty_i = %d; dt_o = %d; dto_tb = %d|", i, j, dt_o, dto_tb);
				errors_num = errors_num + 1;
			end
		test_num = i*j;
		end
      end////////////////////////////////////////////////
        $display("\n###### FIM DE TESTES ######\n");
        $display("Número de Testes:\t %d", test_num);
		$display("Número de Erros:\t %d", errors_num);
	end

//=========================================================
// Tasks & Functions
//=========================================================
	task rst_module;
		clk = 1'd0;
		enb_i = 1;
		#5ns rst_i = 1'd0;
		#5ns rst_i = 1'd1;
	endtask

	task clock(int i);
		repeat(i)
			#10ns clk = ~clk;
	endtask

    task stimulus(int i, int j);
      dtx_i = i;
      dty_i = j;
	endtask

  	function int refmod(int x, int y);
		int mdc;
		while (x != y) begin
			if(x > y)
				x = x - y;
			else
				y = y - x;
		end
		mdc = x;
		return mdc;
	endfunction

  	function int comparator(int dt_o, int dto_tb);
		if(dto_tb==dt_o)
			return 1;
		else
			return 0;
	endfunction

//SDF annotation for the gatelevel simulation 

/*`ifdef NETLIST
  initial begin
      $sdf_annotate("../../timing/sqrt.sdf",dut, ,"../../logs/gatesim/gatesim_sdf_backannotate_sqrt.log","MAXIMUM");
  end 
`endif*/
endmodule
