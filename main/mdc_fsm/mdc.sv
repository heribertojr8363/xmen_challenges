// +PEMHDR----------------------------------------------------------------------
// Copyright (c) 2018 PEM-UFCG. All rights reserved
// PEM-UFCG Confidential Proprietary
//------------------------------------------------------------------------------
// FILE NAME            : mdc.sv
// AUTHOR               : Heriberto Fonseca
// AUTHOR'S E-MAIL      : heriberto.fonseca@embedded.ufcg.edu.br
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR              DESCRIPTION
// 0.1      2021-04-12  heriberto.fonseca   Initial version
// -----------------------------------------------------------------------------
// KEYWORDS: RTL
// -----------------------------------------------------------------------------
// PURPOSE: 
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Other: N/A
// -PEMHDR----------------------------------------------------------------------

module mdc(
	input clk,
	input rstn_i,
	input logic enb_i,
	input logic [7:0] dtx_i,
    input logic [7:0] dty_i,

    output logic busy_o,
    output logic [7:0] dt_o
	);

logic x_diff_y;
logic x_minus_y;
logic sel_x;
logic sel_y;
logic enb_x;
logic enb_y;
logic enb_o;

mdc_ctrl ctrl(
	.clk        (clk),
    .rstn_i     (rstn_i),
    .enb_i      (enb_i),
    .x_diff_y   (x_diff_y),
    .x_minus_y  (x_minus_y),
    .sel_x      (sel_x),
    .sel_y      (sel_y),
    .enb_x      (enb_x),
    .enb_y      (enb_y),
    .enb_o      (enb_o),
    .busy_o     (busy_o)
);

mdc_proc proc(
	.clk        (clk),
    .rstn_i     (rstn_i),
    .busy_o     (busy_o),
    .sel_x      (sel_x),
    .sel_y      (sel_y),
    .enb_x      (enb_x),
    .enb_y      (enb_y),
    .enb_o      (enb_o),
    .dtx_i      (dtx_i),
    .dty_i      (dty_i),
    .x_diff_y   (x_diff_y),
    .x_minus_y  (x_minus_y),
    .dt_o       (dt_o)
);

endmodule
