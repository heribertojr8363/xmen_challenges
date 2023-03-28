// +PEMHDR----------------------------------------------------------------------
// Copyright (c) 2018 PEM-UFCG. All rights reserved
// PEM-UFCG Confidential Proprietary
//------------------------------------------------------------------------------
// FILE NAME            : memx.sv
// AUTHOR               : Heriberto Fonseca
// AUTHOR'S E-MAIL      : heriberto.fonseca@embedded.ufcg.edu.br
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR              DESCRIPTION
// 0.1      2021-05-24  heriberto.fonseca   Initial version
// -----------------------------------------------------------------------------
// KEYWORDS: RTL
// -----------------------------------------------------------------------------
// PURPOSE: 
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Other: N/A
// -PEMHDR----------------------------------------------------------------------

module mem_controller(
	input clk_i,
	input rstn_i,
	input logic memx_rd_i,
	input logic memx_wr_i,
	input logic [9:0] memx_adr_i,
	input logic [15:0] memx_wdt_i,
	input logic [15:0] model_data_i,

	output logic memx_busy_o,
	output logic [9:0] model_adr_o,
	output logic [15:0] memx_rdt_o,
	output logic [15:0] model_wdt_o,
	output logic memx_wok_o,
	output logic memx_wr_o,
	output logic model_wr_o
	);

logic [19:0] contador;
// ================== PARAMETERS ==================

parameter RAM_DATA_WIDTH = 16;
parameter RAM_ADDR_WIDTH = 10;
parameter RAM_READ_DELAY = 5000;
parameter RAM_WRITE_DELAY = 750000;
parameter RAM_READ_WRITE_DELAY = RAM_READ_DELAY + RAM_WRITE_DELAY;

// ================== FSM ==================

typedef enum logic [1:0] 
{
  ID,     //00
  RD,     //01
  WR      //02
} state;

state current, next;

// =========== NEXT STATE LOGIC =============

always_ff @(posedge clk_i or negedge rstn_i) begin
	if(~rstn_i) begin
		current <= ID;
		next <= ID;
	end else begin
		if((~memx_rd_i) & (~memx_wr_i)) begin
			current <= ID;
		end
		else
			current <= next;
	end
end

always_comb begin
	 case (current)
    ID: begin
    	if (memx_rd_i)                       next = RD;
       	else if (memx_wr_i)                  next = WR;
       	else                                 next = ID;
        end
    RD: begin
        if(contador == RAM_READ_DELAY)        next = ID;
        else                                  next = RD;
        end 
    WR: begin
        if(contador == RAM_READ_WRITE_DELAY)  next = ID;
        else                                  next = WR;
        end
    default : next = ID;
  endcase
end

// ================ STATES ==================
always_ff @(posedge clk_i or negedge rstn_i) begin
	if(~rstn_i) begin
		contador <= 0;
	end else begin
  		case(current)
  			ID: begin
  				model_wr_o <= 0;
  				contador <= 0;
  				memx_busy_o <= 0;
  				memx_wok_o <= 0;
  				end
    		RD: begin
    			model_wr_o <= 0;
    			memx_rdt_o <= model_data_i;
    			model_adr_o <= memx_adr_i;
    			contador <= contador + 1;
    			memx_busy_o <= 1;
    			memx_wok_o <= 0;
        		end
    		WR: begin
    			model_wr_o <= 1;
        		model_wdt_o <= memx_wdt_i;
        		model_adr_o <= memx_adr_i;
        		contador <= contador + 1;
        		memx_busy_o <= 1;
        		if(data_i == model_wdt_o)
    				memx_wok_o <= 1;
        		end
    		default: 
        		begin
        		model_wr_o <= 0;
  				contador <= 0;
  				memx_busy_o <= 0;
  				memx_wok_o <= 0;
        		end
    	endcase
    end
end


endmodule