// +PEMHDR----------------------------------------------------------------------
// Copyright (c) 2018 PEM-UFCG. All rights reserved
// PEM-UFCG Confidential Proprietary
//------------------------------------------------------------------------------
// FILE NAME            : fifo.sv
// AUTHOR               : Heriberto Fonseca
// AUTHOR'S E-MAIL      : heriberto.fonseca@embedded.ufcg.edu.br
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR              DESCRIPTION
// 0.1      2021-05-06  heriberto.fonseca   Initial version
// -----------------------------------------------------------------------------
// KEYWORDS: RTL
// -----------------------------------------------------------------------------
// PURPOSE: 
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Other: N/A
// -PEMHDR----------------------------------------------------------------------

module fifo(
	input clk_i,
	input rstn_i,
	input logic valid_i,
	input logic ready_i,
	input logic [7:0] data_i,

	output logic valid_o,
	output logic ready_o,
	output logic [7:0] data_o
	);

logic [7:0] registrador [7:0];
logic [2:0] contador;
logic [2:0] contador_i; 
logic [2:0] contador_o;
logic empty;
logic full;
logic p_full;

always_ff @(posedge clk_i or negedge rstn_i) begin
	if(~rstn_i) begin
		for(int i=0; i<8; i++)
			registrador [i] <= 0;
		contador    <= 0;
		contador_i  <= 0;
		contador_o  <= 0;
		data_o      <= 0;
	end else begin
		if(ready_o & valid_i) begin
			if(p_full) begin
				registrador [contador_i] <= data_i;
				contador_i <= contador_i + 1;
			end
			else begin
				registrador [contador_i] <= data_i;
				contador_i <= contador_i + 1;
				contador <= contador + 1;
			end
		end
		if(ready_i & valid_o) begin
			if(p_full) begin
				data_o <= registrador [contador_o];
				contador_o <= contador_o + 1;
			end
			else begin
				data_o <= registrador [contador_o];
				contador_o <= contador_o + 1;
				contador <= contador - 1;
			end
		end
	end
end

always_comb begin
	if(contador == 7) begin
		full = 1;
		p_full = 0;
		empty = 0;
	end
	else if (contador == 0) begin
		full = 0;
		p_full = 0;
		empty = 1;
	end
	else begin
		full = 0;
		p_full = 1;
		empty = 0;
	end
	if(empty) begin
		valid_o = 0;
		ready_o = 1;
	end
	else if(p_full) begin
		valid_o = 1;
		ready_o = 1;
	end
	else if (full) begin
		valid_o = 1;
		ready_o = 0;
	end
	else begin
		valid_o = 0;
		ready_o = 0;
	end
end

endmodule