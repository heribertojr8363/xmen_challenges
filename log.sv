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

module log #(parameter DATA_WIDTH = 8, parameter ITERATIONS = 16, PRECISION = 13)
	(
		input logic clk_i,
		input logic rstn_i,
		input logic [DATA_WIDTH-1:0] number_i,       //Numbers given by the user
		output logic [DATA_WIDTH-1:0] number_o
		);

	shortreal aux_mf;
	int aux_mi;

	logic [DATA_WIDTH-1:0] m, aux_2, aux_3;
	logic [(DATA_WIDTH*2) - 1:0] aux_1;
	logic [1:0] c2;
	logic [2:0] e;
	logic [DATA_WIDTH-4:0] z;
	logic [DATA_WIDTH-1:0] c1;
	logic valid;

	always_ff @(posedge clk_i, negedge rstn_i)
	begin
		if(!rstn_i)
		begin
			aux_1 <= 'd0;
			aux_2 <= 'd0;
			aux_3 <= 'd0;
			z <= 'd0;
			c1 <= 'd0;
			c2 <= 'd0;
		end
		else begin
			if(number_i == 0) 
			begin
				number_o = 0;
			end

			if(valid) 
			begin
				number_o[7:5] <= e[2:0];
				number_o[4:0] <= z[4:0];
				c1 <= 0;
				c2 <= 0;
			end

			else
			begin
				if(c1==0) begin
					aux_2 <= m;
					z <= 0;
					aux_3 <= 0;
					aux_1 <= 0;
					c2 <= c2 +1;
				end
				
				else begin
					aux_1 <= aux_2*aux_2;

					aux_3 <= aux_1[12:5];
			
					if(c2 == 3) begin
						if(aux_3[7:5] >= 2) begin
							z <= z + 1;
							aux_2 <= (aux_3>>1);
							//$display("ENTREI NO IF");
						end
						else if(c1 < ITERATIONS-3) begin
							//$display("ESTOU AQ");
							if(z >= 16)
								z <= (z>>1);
						end
						c2 <= 1;
					end
					else begin
						if (c2 == 2) begin
							z <= z*2;
						end
						c2 <= c2+1;
					end
				end
				c1 <= c1+1;
			end
		end
	end

	always_comb begin
		if (number_i < 2**(1)) begin
			e = 0;
		end
		else if (number_i < 2**(2)) begin
			e = 1;
		end
		else if (number_i < 2**(3)) begin
			e = 2;
		end
		else if (number_i < 2**(4)) begin
			e = 3;
		end
		else if (number_i < 2**(5)) begin
			e = 4;
		end
		else if (number_i < 2**(6)) begin
			e = 5;
		end
		else if (number_i < 2**(7)) begin
			e = 6;
		end
		else if(number_i < 2**(8))
			e = 7;
		else 
			e = 7;

		/*aux_mf = (number_i/1.0)/(2**e);
		aux_mi = aux_mf*(2**PRECISION);*/

		//$display("AUX_MF = %f",aux_mf);
		//$display("AUX_MI = %f", $itor(aux_mi*0.03125));
		

		m = {number_i,5'b00000} >> e;

		if(c1 == (ITERATIONS-1))
			valid = 1;
		else
			valid = 0;

	end
endmodule
