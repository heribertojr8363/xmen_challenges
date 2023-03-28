// +PEMHDR----------------------------------------------------------------------
// Copyright (c) 2018 PEM-UFCG. All rights reserved
// PEM-UFCG Confidential Proprietary
//------------------------------------------------------------------------------
// FILE NAME            : sad.sv
// AUTHOR               : Heriberto Fonseca
// AUTHOR'S E-MAIL      : heriberto.fonseca@embedded.ufcg.edu.br
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR              DESCRIPTION
// 0.1      2021-04-04  heriberto.fonseca   Initial version
// -----------------------------------------------------------------------------
// KEYWORDS: RTL
// -----------------------------------------------------------------------------
// PURPOSE: 
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Other: N/A
// -PEMHDR----------------------------------------------------------------------

module sad(
	input clk,
	input rstn_i,
	input logic enb_i,
	input logic [7:0] dta_i,
    input logic [7:0] dtb_i,

    output logic busy_o,
    output logic [31:0] dt_o
	);

    logic  i_inc;
    logic  i_clr;
    logic  sum_ld; 
    logic  sum_clr;
    logic  sad_reg_ld;
    logic  i_it_256;

sad_ctrl ctrl(
	.clk        (clk),
    .rstn_i     (rstn_i),
    .enb_i      (enb_i),
    .i_it_256   (i_it_256),
    .busy_o     (busy_o),
    .i_inc      (i_inc),
    .i_clr      (i_clr),
    .sum_ld     (sum_ld),
    .sum_clr    (sum_clr),
    .sad_reg_ld (sad_reg_ld)
);

sad_proc proc(
	.clk        (clk),
    .rstn_i     (rstn_i),
    .i_inc      (i_inc),
    .i_clr      (i_clr),
    .sum_ld     (sum_ld),
    .sum_clr    (sum_clr),
    .sad_reg_ld (sad_reg_ld),
    .dta_i      (dta_i),
    .dtb_i      (dtb_i),
    .i_it_256   (i_it_256),
    .dt_o       (dt_o)
);

endmodule
