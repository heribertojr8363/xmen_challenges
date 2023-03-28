// +PEMHDR----------------------------------------------------------------------
// Copyright (c) 2018 PEM-UFCG. All rights reserved
// PEM-UFCG Confidential Proprietary
//------------------------------------------------------------------------------
// FILE NAME            : behaviour_sqrt.sv
// AUTHOR               : Heriberto Fonseca
// AUTHOR'S E-MAIL      : heriberto.fonseca@embedded.ufcg.edu.br
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR              DESCRIPTION
// 0.1      2021-03-29  heriberto.fonseca         Initial version
// -----------------------------------------------------------------------------
// KEYWORDS: RTL
// -----------------------------------------------------------------------------
// PURPOSE: 
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Other: N/A
// -PEMHDR----------------------------------------------------------------------

module behaviour_sqrt
	(
		input logic clk_i,
		input logic rstn_i,
		input logic enb_i,
		input logic [7:0] dt_i,
		output logic [7:0] dt_o 
		);

	logic [4:0] d;
	logic [8:0] s;

	always_ff @(posedge clk_i, negedge rstn_i)
	begin
		if(!rstn_i)
		begin
			d <= 5'b00010; 
			s <= 9'b000000100;
		end
		else
		begin
			if (enb_i)
			begin
				if (dt_i == 8'd0) 
				begin
					dt_o <= 8'd0;
				end
				if (s <= dt_i)
				begin
					d <= (d + 2'd2);
					s <= (s + (d + 2'd2) + 1'd1);
				end
				else
				begin
					dt_o <= (d>>1);
					d <= 5'b00010; 
					s <= 9'b000000100;
				end
			end 
		end
	end

endmodule
