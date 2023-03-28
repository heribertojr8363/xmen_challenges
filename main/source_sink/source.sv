// +PEMHDR----------------------------------------------------------------------
// Copyright (c) 2018 PEM-UFCG. All rights reserved
// PEM-UFCG Confidential Proprietary
//------------------------------------------------------------------------------
// FILE NAME            : source.sv
// AUTHOR               : Heriberto Fonseca
// AUTHOR'S E-MAIL      : heriberto.fonseca@embedded.ufcg.edu.br
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR              DESCRIPTION
// 0.1      2021-05-01  heriberto.fonseca   Initial version
// -----------------------------------------------------------------------------
// KEYWORDS: RTL
// -----------------------------------------------------------------------------
// PURPOSE: 
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Other: N/A
// -PEMHDR----------------------------------------------------------------------

module source(
	input clk_i,
	input rstn_i,
	input logic ready_i,

	output logic valid_o,
	output logic [7:0] data_o
	);

parameter ATRASO = 4;

logic [7:0] cont;

always_ff@(posedge clk_i or negedge rstn_i) begin
	if(~rstn_i) begin
		cont <= 8'd0;
		valid_o <= 1'd0;
		data_o <= 8'd0;
	end

	else begin
		if(!ATRASO) begin
			valid_o <= 1'd1;
			if((valid_o & ready_i))
				data_o <= data_o + 1'd1;
		end
		else begin
			cont <= cont + 1'd1;
			if(cont + 1'd1 == ATRASO) begin
				cont <= 8'd0;
				valid_o <= 1'd1;
			end
			if ((valid_o & ready_i)) begin
				valid_o <= 1'd0;
				data_o <= data_o + 1'd1;
				cont <= 8'd0;
			end
		end
	end
end
endmodule
