module source_sink_tb;

parameter DELAYSOURCE = 4;
parameter DELAYSINK = 2;

//=========================================================
// Interface
//=========================================================
	logic 		 clk;
	logic 		 rst_i;
	logic        ready;
	logic        valid;
	logic [7:0]  data;
  	
    int comp, test_num, errors_num, data_tb,delayhs;
  
//=========================================================
// DUT Instanciation
//=========================================================
	source dut_1(
		.clk_i(clk),
        .rstn_i(rst_i),
		.ready_i(ready),
		.valid_o(valid),
		.data_o(data)
    );

    sink dut_2(
		.clk_i(clk),
        .rstn_i(rst_i),
		.valid_i(valid),
		.data_i(data),
		.ready_o(ready)
    );
  
//=========================================================
// Inital Block
//=========================================================
	initial begin
	if(DELAYSOURCE >= DELAYSINK)
		delayhs = DELAYSOURCE;
	else
		delayhs = DELAYSINK;
      test_num = 0;
	  errors_num = 0;

	  rst_module;
	$display("delayHS = %d", delayhs);
      $display("\n========= BEM-VINDO AO TESTE ==========\n");
      for(int i = 0; i<256; i++) begin
		clock(2*(delayhs+1));
		data_tb = refmod(i+1);
		comp = comparator(data, data_tb);
        if(!comp) 
       	begin
        	$display("ERRO|data = %d; data_tb = %d|",data, data_tb);
			errors_num = errors_num + 1;
		end
		test_num = i+1;
	  end
        $display("\n###### FIM DE TESTES ######\n");
        $display("Número de Testes:\t %d", test_num);
		$display("Número de Erros:\t %d", errors_num);
	end

//=========================================================
// Tasks & Functions
//=========================================================
	task rst_module;
		clk = 1'd0;
		#5ns rst_i = 1'd0;
		#5ns rst_i = 1'd1;
	endtask

	task clock(int i);
		repeat(i)
			#10ns clk = ~clk;
	endtask

  	function int refmod(int x);
		return x;
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
      $sdf_annotate("../../timing/sqrt.sdf",dut1, ,"../../logs/gatesim/gatesim_sdf_backannotate_sqrt.log","MAXIMUM");
      $sdf_annotate("../../timing/sink.sdf",dut2, ,"../../logs/gatesim/gatesim_sdf_backannotate_sink.log","MAXIMUM");
  end 
`endif*/
endmodule
