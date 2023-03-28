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

module median #(parameter DATA_WIDTH=8, parameter DATA_SIZE=9)
	(
		input logic clk_i,
		input logic rstn_i,
		input logic ready, 
		input logic [DATA_WIDTH-1:0] numbers_i [DATA_SIZE-1:0],       //Numbers given by the user
		output logic [DATA_WIDTH-1:0] numbers_o
		);

	logic [DATA_WIDTH-1:0] aux [DATA_SIZE-1:0];

	always_ff @(posedge clk_i, negedge rstn_i)
	begin
		if(!rstn_i) begin
			for (int i = 0; i < DATA_SIZE; i++) begin
				aux[i] <= 'd0;
			end
		end
		else begin
			aux <= numbers_i;
			numbers_o <= aux[(DATA_SIZE-1)>>1];
		end
	end
endmodule
