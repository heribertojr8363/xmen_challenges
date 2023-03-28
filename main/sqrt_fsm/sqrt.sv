// +PEMHDR----------------------------------------------------------------------
// Copyright (c) 2018 PEM-UFCG. All rights reserved
// PEM-UFCG Confidential Proprietary
//------------------------------------------------------------------------------
// FILE NAME            : sqrt.sv
// AUTHOR               : Heriberto Fonseca
// AUTHOR'S E-MAIL      : heriberto.fonseca@embedded.ufcg.edu.br
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR              DESCRIPTION
// 0.1      2021-04-08  heriberto.fonseca   Initial version
// -----------------------------------------------------------------------------
// KEYWORDS: RTL
// -----------------------------------------------------------------------------
// PURPOSE: 
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Other: N/A
// -PEMHDR----------------------------------------------------------------------

module sqrt(
	input clk,
	input rstn_i,
	input logic enb_i,
	input logic [7:0] dt_i,

    output logic busy_o,
    output logic [7:0] dt_o
	);

logic [9:0] bus_ctrl;
logic [16:0] bus_proc;

sqrt_ctrl ctrl(
	.clk        (clk),
    .rstn_i     (rstn_i),
    .enb_i      (enb_i),
    .bus_proc   (bus_proc),
    .bus_ctrl   (bus_ctrl),
    .busy_o     (busy_o)
);

sqrt_proc proc(
	.clk        (clk),
    .rstn_i     (rstn_i),
    .busy_o     (busy_o),
    .bus_ctrl   (bus_ctrl),
    .dt_i       (dt_i),
    .bus_proc   (bus_proc),
    .dt_o       (dt_o)
);

endmodule
