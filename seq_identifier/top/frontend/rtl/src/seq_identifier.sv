// FILE NAME            : seq_identifier.sv
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

module seq_identifier
	(
		input logic clk_i,
		input logic rstn_i,
		input logic bit_i,
		input logic [3:0] ref_i,       //Reference of sequence given by the user
		output logic flag_o 
		);

	logic [3:0] comp_i;                //Register to keep the value of bit_i to make a further comparison

	always_ff @(posedge clk_i, negedge rstn_i)
	begin
		if(!rstn_i)
		begin
			comp_i <= 'x;
		end
		else
		begin
			comp_i[0] <= bit_i;       //With this logic, we can verify in each clock if the sequence has been achieved using less registers and in a lower time
			comp_i[1] <= comp_i[0];
			comp_i[2] <= comp_i[1];
			comp_i[3] <= comp_i[2];
		end
	end

	always_comb begin
		if(comp_i == ref_i) flag_o = 1;

		else flag_o = 0;
	end

endmodule
