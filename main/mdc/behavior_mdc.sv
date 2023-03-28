// +PEMHDR----------------------------------------------------------------------
// Copyright (c) 2018 PEM-UFCG. All rights reserved
// PEM-UFCG Confidential Proprietary
//------------------------------------------------------------------------------
// FILE NAME            : behaviour_mdc.sv
// AUTHOR               : Heriberto Fonseca
// AUTHOR'S E-MAIL      : heriberto.fonseca@embedded.ufcg.edu.br
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR              DESCRIPTION
// 0.1      2021-04-02  heriberto.fonseca   Initial version
// -----------------------------------------------------------------------------
// KEYWORDS: RTL
// -----------------------------------------------------------------------------
// PURPOSE: 
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Other: N/A
// -PEMHDR----------------------------------------------------------------------

module behavior_mdc
	(
		input logic clk_i,
		input logic rstn_i,
		input logic enb_i,
		input logic [7:0] dtx_i,
		input logic [7:0] dty_i,
		output logic [7:0] dt_o 
		);
//===================================================================
// Internal signals
//===================================================================
	logic [7:0] x_i, y_i;
	logic i;
// ==================================================================
// SUB-BLOCK PROC_COMB
// ==================================================================

// ========================================================================================
// SUB-BLOCK PROC_REG
// ========================================================================================
	always_ff @(posedge clk_i, negedge rstn_i)
	begin
		if(!rstn_i)
		begin
			x_i <= 8'd0; 
			y_i <= 8'd0;
			i <= 1'd1;
		end
		else
		begin
			if (enb_i)
			begin
				if(i)
				begin
					x_i <= dtx_i;
					y_i <= dty_i;
					i <= 1'd0;
				end
				if(x_i == 0 || y_i == 0)
				begin
					if(x_i != 0)
					begin
						dt_o <= x_i;
						i <= 1'd1;
					end
					else if (y_i != 0)
					begin
						dt_o <= y_i;
						i <= 1'd1;
					end
					else
					begin
						dt_o <= 8'd0;
						i <= 1'd1;
					end
				end
				else
				begin 
					if (x_i != y_i)
					begin
						if(x_i > y_i)
							x_i <= (x_i - y_i);
						else
							y_i <= (y_i - x_i);
					end
					else
					begin
						dt_o <= x_i;
						i <= 1'd1;
					end		
				end
			end 
		end
	end
endmodule
