module sad_tb;

//=========================================================
// Interface
//=========================================================
	logic 		 clk;
	logic 		 rst_i;
	logic 		 enb_i;
	logic [7:0]  dta_i;
	logic [7:0]  dtb_i;
	logic        busy_o;
	logic [31:0] dt_o;
  	
  	/*logic  		 i_inc;
    logic  	 	 i_clr;
    logic    	 sum_ld; 
    logic  	 	 sum_clr;
    logic  		 sad_reg_ld;
    logic  		 i_it_256;*/

    int comp, pos, test_num, errors_num, dto_tb;
    int x_i[256], y_i[256];
  
//=========================================================
// DUT Instanciation
//=========================================================
	sad dut(
		.clk(clk),
        .rstn_i(rst_i),
		.enb_i(enb_i),
		.dta_i(dta_i),
		.dtb_i(dtb_i),
		.dt_o(dt_o),
		.busy_o(busy_o)
    );
  
//=========================================================
// Inital Block
//=========================================================
	initial begin
      test_num = 0;
	  errors_num = 0;
	  pos = 0;

	  for(int i=0; i<256; i++)
	  begin
	  	 x_i[i] = 0;
	  	 y_i[i] = 0;
	  end

	  rst_module;
      $display("\n========= BEM-VINDO AO TESTE ==========\n");
      for(int m=0;m<256;m++) 
      	begin //////////////////////////////////////////////
          for(int n=0;n<256;n++)
          	begin
		if(!pos)
			clock(2);
            	stimulus(n,m);
            	x_i [pos] = dta_i;
            	y_i [pos] = dtb_i;
		if (!pos)
			clock(6);
		else
			clock(4);
		pos++;
            	if(pos == 256)
            		pos = 0;
          	end
		clock(4);
		dto_tb = refmod(x_i, y_i);
		comp = comparator(dt_o, dto_tb);
          	if(!comp) 
          	begin
              	$display("ERRO|m = %d; dt_o = %d; dto_tb = %d|", m, dt_o, dto_tb);
			  	errors_num = errors_num + 1;
			end
            test_num = (m+1);
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
		#10ns rst_i = 1'd0;
		#10ns rst_i = 1'd1;
	endtask

	task clock(int i);
		repeat(i)
			#10ns clk = ~clk;
	endtask

    task stimulus(int j, int k);
      dta_i = j;
      dtb_i = k;
	endtask

  	function int refmod(int x[256], int y[256]);
		int soma;
		int i;
		int abs;			

		i = 0;
		soma = 0;

    	while(i < 256) begin
			if(x[i] > y[i])
				abs = x[i] - y[i];
			else
				abs = y[i] - x[i];
			soma = soma + abs;
			i++;
		end
        
        return soma;
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
      $sdf_annotate("../../timing/sad.sdf",dut, ,"../../logs/gatesim/gatesim_sdf_backannotate_sad.log","MAXIMUM");
  end 
`endif
endmodule
