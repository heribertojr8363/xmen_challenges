// +PEMHDR----------------------------------------------------------------------
// Copyright (c) 2018 PEM-UFCG. All rights reserved
// PEM-UFCG Confidential Proprietary
//------------------------------------------------------------------------------
// FILE NAME            : sink.sv
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

module sink(
	input clk_i,
	input rstn_i,
	input logic valid_i,
	input logic [7:0] data_i,

	output logic ready_o
	);

parameter ATRASO = 2;
logic [7:0] registrador;
logic [7:0] contador;

always_ff @(posedge clk_i or negedge rstn_i) begin
	if(~rstn_i) begin
		 registrador <= 8'd0;
		 contador <= 8'd0;
		 ready_o <= 1'd0;
		end
	else begin
		if(!ATRASO) begin
			ready_o <= 1'd1;
			if(valid_i & ready_o)
				registrador <= data_i;
		end
		else begin
			contador <= contador + 1'd1;
			if(contador + 1'd1 == ATRASO) begin
				contador <= 8'd0;
				ready_o <= 1'd1;
			end
        	if((valid_i & ready_o)) begin
				registrador <= data_i;
				contador <= 8'd0;
				ready_o <= 1'd0;
			end
		end
	end
end
endmodule
