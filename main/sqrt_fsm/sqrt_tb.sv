module sqrt_tb;

//=========================================================
// Interface
//=========================================================
	logic 		 clk;
	logic 		 rst_i;
	logic 		 enb_i;
	logic [7:0]  dt_i;
	logic        busy_o;
	logic [7:0]  dt_o;
  	
    int comp, test_num, errors_num, dto_tb;
  
//=========================================================
// DUT Instanciation
//=========================================================
	sqrt dut(
		.clk(clk),
        .rstn_i(rst_i),
		.enb_i(enb_i),
		.dt_i(dt_i),
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
      for(int i=0;i<256;i++) 
      begin //////////////////////////////////////////////
        stimulus(i);
		clock(500);
		dto_tb = refmod(i);
		comp = comparator(dt_o, dto_tb);
        if(!comp) 
       	begin
        	$display("ERRO|dt_i = %d; dt_o = %d; dto_tb = %d|", i, dt_o, dto_tb);
			errors_num = errors_num + 1;
	end
			test_num = (i+1);
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

    task stimulus(int j);
      dt_i = j;
	endtask

  	function int refmod(int test_number);
		int d,s,r;
		d=2;
		s=4;
		while (s<=test_number) begin
			d = d + 2;
			s = s + d + 1;
		end
		r = d/2;
		return r;
	endfunction

  	function int comparator(int dt_o, int dto_tb);
		if(dto_tb==dt_o)
			return 1;
		else
			return 0;
	endfunction

//SDF annotation for the gatelevel simulation 

`ifdef NETLIST
  initial begin
      $sdf_annotate("../../timing/sqrt.sdf",dut, ,"../../logs/gatesim/gatesim_sdf_backannotate_sqrt.log","MAXIMUM");
  end 
`endif
endmodule
