// +PEMHDR----------------------------------------------------------------------
// Copyright (c) 2018 PEM-UFCG. All rights reserved
// PEM-UFCG Confidential Proprietary
//------------------------------------------------------------------------------
// FILE NAME            : xxx_proc.v
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

module xxx_proc(
    clk_cg_i,
    enb_cg_i,
    rst_b_i,
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
input  wire                   clk_cg_i;
input  wire                   enb_cg_i;
input  wire                   rst_b_i;
output wire [ADDR_WIDTH-1:0]  xxx_addr_o;
output wire [DATA_WIDTH-1:0]  xxx_dt_o;
// ========================================================================================
// Internal signals
// ========================================================================================
reg [ADDR_WIDTH-1:0]          xxx_addr_ff;

always @(posedge clk_cg_i, negedge rst_b_i) begin
  if( rst_b_i == 1'b0 )
      xxx_addr_ff <= {ADDR_WIDTH{1'b0}};
  else begin    
    if( enb_cg_i == 1'b1 )          // ex: clock gating enabled
        xxx_addr_ff <= xxx_addr_ff + 1'b1;
    else
	xxx_addr_ff <= xxx_addr_ff; // clock disable
  end    
end

assign xxx_addr_o = xxx_addr_ff; 
assign xxx_dt_o   = (enb_cg_i == 1'b1)? {DATA_WIDTH{1'b1}} : {DATA_WIDTH{1'b0}};

endmodule