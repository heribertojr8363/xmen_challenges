// +PEMHDR----------------------------------------------------------------------
// Copyright (c) 2018 PEM-UFCG. All rights reserved
// PEM-UFCG Confidential Proprietary
//------------------------------------------------------------------------------
// FILE NAME            : xxx.v
// AUTHOR               : Bruno Silva
// AUTHOR'S E-MAIL      : bruno.silva@embedded.ufcg.edu.br
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR              DESCRIPTION
// 0.1      2019-03-01  bruno.silva         Initial version
// -----------------------------------------------------------------------------
// KEYWORDS: RTL
// -----------------------------------------------------------------------------
// PURPOSE: 
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Other: N/A
// -PEMHDR----------------------------------------------------------------------

module xxx(
    dft_tm_i,
    clk_i,
    xxx_en_i, 
    xxx_dt_valid_o,
    xxx_addr_o,
    xxx_dt_o
);
// ========================================================================================
// Parameters
// ========================================================================================
parameter ADDR_WIDTH = 8;    
parameter DATA_WIDTH = 8; 
// ========================================================================================
// Interface
// ========================================================================================
input  wire                   dft_tm_i;
input  wire                   clk_i;
input  wire                   xxx_en_i;
output wire                   xxx_dt_valid_o;
output wire [ADDR_WIDTH -1:0] xxx_addr_o;
output wire [DATA_WIDTH -1:0] xxx_dt_o;
// ========================================================================================
// Internal signals
// ========================================================================================
wire                          enb_cg_w;
wire                          rst_b_w;
// ========================================================================================
// SUB-BLOCK XXX_CTRL
// ========================================================================================
xxx_ctrl xxx_ctrl(
    .dft_tm_i                (dft_tm_i),
    .clk_cg_i                (clk_i),
    .xxx_en_i                (xxx_en_i),      
    .xxx_dt_valid_o          (xxx_dt_valid_o),    
    .enb_cg_o                (enb_cg_w),
    .rst_b_o                 (rst_b_w)   
);
// ========================================================================================
// SUB-BLOCK XXX_PROC
// ========================================================================================
xxx_proc #(
	    .ADDR_WIDTH      (ADDR_WIDTH), 
	    .DATA_WIDTH      (DATA_WIDTH) 
    )xxx_proc(
    .clk_cg_i                (clk_i),
    .enb_cg_i                (enb_cg_w),
    .rst_b_i                 (rst_b_w),     
    .xxx_addr_o              (xxx_addr_o),
    .xxx_dt_o                (xxx_dt_o)
);

endmodule
