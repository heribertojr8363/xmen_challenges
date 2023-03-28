module mem_controller_tb;


//=========================================================
// Interface
//=========================================================
	logic 		 clk;
	logic        clk1;
	logic 		 rst_i;
	logic        memx_rd_i;
	logic        memx_wr_i;
	logic [9:0]  memx_adr_i;
	logic [15:0] memx_wdt_i;
	logic [15:0] model_data;
	logic        memx_busy_o;
	logic [9:0]  model_adr;
	logic [15:0] memx_rdt_o;
	logic [15:0] model_wdt;
	logic        memx_wok_o;
	logic        memx_wr_o;
	logic        model_wr;
	logic [7:0]  data_i;
	logic [7:0]  data_o;
  	
    int errors ,loop, looptimes;
  
//=========================================================
// DUT Instanciation
//=========================================================
	mem_controller dut_1(
		.clk_i(clk),
        .rstn_i(rst_i),
		.memx_rd_i (memx_rd_i),
		.memx_wr_i (memx_wr_i),
		.memx_adr_i (memx_adr_i),
		.memx_wdt_i (memx_wdt_i),
		.model_data_i (model_data),
		.memx_busy_o (memx_busy_o),
		.model_adr_o (model_adr),
		.memx_rdt_o (memx_rdt_o),
		.model_wdt_o (model_wdt),
		.memx_wok_o (memx_wok_o),
		.memx_wr_o (memx_wr_o),
		.model_wr_o (model_wr)
    );

    mem_model dut_2(
		.clk_i(clk1),
        .wr_i(model_wr),
		.addr_i(model_adr),
		.data_i(model_wdt),
		.data_o(model_data)
    );
  
//=========================================================
// Inital Block
//=========================================================
	initial begin
	errors = 0;

	rst_module;
	
      $display("\n========= BEM-VINDO AO TESTE ==========\n");
      for(loop=0;loop<10;loop++) begin
			//#1ns IDLEverify_rtl();
			#1ns READverify_rtl();
			//#1ns WRITEverify_rtl();
		end
		#300ms for(loop=0;loop<looptimes;loop++)
			$display("Memoria[%d] = %d",loop,dut_2.data_vector[loop]);
		//===============================================================	
		$display("looptimes = %d",looptimes);
        $display("\n###### FIM DE TESTES ######\n");
		$display("Número de Erros:\t %d", errors);
	end


//=========================================================
// Tasks & Functions
//=========================================================
	task rst_module;
		clk = 1'd0;
		clk1 = 1'd0;
		#5ns rst_i = 1'd0;
		#5ns rst_i = 1'd1;
	endtask

	task clock (input int a);
		repeat( a ) begin
			#10ns begin 
				
				clk = ~clk;
				clk1 = ~clk1;

			end
			#10ns begin 
				
				clk = ~clk;
			end
			#10ns begin 
				
				clk = ~clk;
			end
			
		end
	endtask

  	task READverify_rtl(); //Verificar se envia e recebe os dados corretamente, olhar waves
		looptimes = looptimes + 1 ;
		memx_adr_i = loop ;
		memx_wr_i = 1'd0 ;
		memx_rd_i = 1'd1 ;
		clock(3200);
		if( memx_rdt_o != loop )
			errors++;
	
		$display("Valor da memoria = %d ",memx_rdt_o);
	endtask 


	task WRITEverify_rtl(); //Verificar se envia e recebe os dados corretamente, olhar waves
		memx_adr_i = loop ;
		memx_wr_i = 1'd1 ;
		memx_rd_i  = 1'd0 ;
		memx_wdt_i = 6;
		clocks(508000);
		looptimes++;

	endtask

//SDF annotation for the gatelevel simulation 

/*`ifdef NETLIST
  initial begin
      $sdf_annotate("../../timing/sqrt.sdf",dut1, ,"../../logs/gatesim/gatesim_sdf_backannotate_sqrt.log","MAXIMUM");
      $sdf_annotate("../../timing/sink.sdf",dut2, ,"../../logs/gatesim/gatesim_sdf_backannotate_sink.log","MAXIMUM");
  end 
`endif*/
endmodule