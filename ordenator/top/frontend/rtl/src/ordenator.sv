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

module ordenator #(parameter DATA_WIDTH = 8, DATA_SIZE = 9)
	(
		input logic clk_i,
		input logic rstn_i,
		input logic [DATA_WIDTH-1:0] numbers_i [DATA_SIZE-1:0],       //Numbers given by the user
		output logic [DATA_WIDTH-1:0] numbers_o [DATA_SIZE-1:0],
		output logic busy_o,
		output logic ready 
		);

	logic [DATA_WIDTH-1:0] aux [DATA_SIZE-1:0];
	logic [(DATA_SIZE-1)>>1:0] c1, c2;               //Counters to ensure that all the positions are correctly ordenated (worst case scenario). It could be optimized if the code isn't synthetizable.

	always_ff @(posedge clk_i, negedge rstn_i)
	begin
		if(!rstn_i)
		begin
			for (int i = 0; i < DATA_SIZE; i++) begin
				aux[i] <= 'd0;
			end
			c1 <= 'd0;
			c2 <= 'd0;
		end
		else
		begin
			if(aux[c1] > aux[c1+1]) begin  //With this logic, we can verify in each clock if the sequence has been achieved using less registers and in a lower time
				aux[c1] <= aux[c1+1];
				aux[c1+1] <= aux[c1];
			end 

			if(c1 != DATA_SIZE-2)	
				c1 <= c1+1;
			else begin
				c1 <= 0;
				if(c2 != DATA_SIZE-2) begin
					c2 <= c2 + 1;
				end
				else begin
					c2 <= 0;
				end
			end

			if(!busy_o) begin
				aux <= numbers_i;
			end
			if (ready) begin
				numbers_o <= aux;
			end
		end
	end

	always_comb begin
		if((c1+c2) == 0) begin
			busy_o = 0;
		end
		else begin
			busy_o = 1;
		end
		if(c2 == (DATA_SIZE-2) && c1 == 1)
			ready = 1;
		else
			ready = 0;
	end

endmodule
