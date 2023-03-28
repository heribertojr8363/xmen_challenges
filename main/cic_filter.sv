// +PEMHDR----------------------------------------------------------------------
// Copyright (c) 2018 PEM-UFCG. All rights reserved
// PEM-UFCG Confidential Proprietary
//------------------------------------------------------------------------------
// FILE NAME            : cic_filter.sv
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

module cic_filter
	(	input logic clk_i;
		input logic rstn_i;
		input logic [7:0] x;
		output logic [7:0] y;
		);
//===================================================================
// Internal signals
//===================================================================
	logic [7:0] reg_x [3:0];
	logic [7:0] reg_y;
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
			for(int i = 0; i<4; i++)
				reg_x [i] <= 8'd0;
			reg_y <= 8'd0;
		end
		else
		begin
			reg_x[3] <= x;
			for(int i = 0; i < 3; i++)
				reg_x[i] <= reg_x[i+1];
			reg_y <= y;
			y <= reg_y + x - reg_x[0];
		end

	end
endmodule
