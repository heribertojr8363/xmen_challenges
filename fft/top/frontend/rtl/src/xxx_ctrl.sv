// +PEMHDR----------------------------------------------------------------------
// Copyright (c) 2018 PEM-UFCG. All rights reserved
// PEM-UFCG Confidential Proprietary
//------------------------------------------------------------------------------
// FILE NAME            : xxx_ctrl.v
// AUTHOR               : Bruno Silva
// AUTHOR'S E-MAIL      : bruno.silva@embedded.ufcg.edu.br
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR              DESCRIPTION
// 0.1      2019-03-01  bruno.silva         Initial version
// -----------------------------------------------------------------------------
// KEYWORDS: RTL, FSM and clock gating 
// -----------------------------------------------------------------------------
// PURPOSE: FSM and clock gating examples
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Other: N/A
// -PEMHDR----------------------------------------------------------------------

module xxx_ctrl(
    dft_tm_i,
    clk_cg_i,
    xxx_en_i,
    xxx_dt_valid_o,    
    enb_cg_o,
    rst_b_o
);
// ========================================================================================
// Interface
// ========================================================================================
input  wire        dft_tm_i;
input  wire        clk_cg_i;
input  wire        xxx_en_i;
output wire        xxx_dt_valid_o;
output wire        enb_cg_o;
output wire        rst_b_o;
// ========================================================================================
// List of states 
// ========================================================================================

parameter ACT_TX_ST = 2'h0; // Actives the reply 
parameter XXX_DT_ST = 2'h1; // reply -> rn16
parameter DCT_TX_ST = 2'h2; // disable the reply

// ========================================================================================
// Internal signals
// ========================================================================================
wire               enb_cg_w;
wire               rst_b_w;
reg  [1:0]         state;
reg  [1:0]         next_state;
reg                xxx_dt_valid_w;    
// ========================================================================================
// Main logic
// ========================================================================================
assign enb_cg_w     = xxx_en_i;
assign rst_b_w      = (dft_tm_i == 1'b0)? enb_cg_w : 1'b1;
assign enb_cg_o     = enb_cg_w;
assign rst_b_o      = rst_b_w;
// ========================================================================================
// Controller -> FSM
// ========================================================================================
always @(posedge clk_cg_i, negedge rst_b_w) begin
  if( rst_b_w == 1'b0 ) 
      state <= ACT_TX_ST;
  else begin
    if( enb_cg_w == 1'b1 ) 
        state <= next_state;
    else 
        state <= state;
  end
end

always @(
	 state,
	 enb_cg_w
	 ) begin
         case(state)
	  // ========================================================================================
	  // Initialize 
	  // ========================================================================================      
	  ACT_TX_ST:  begin
			next_state = XXX_DT_ST;            
		      end      
	  // ========================================================================================
	  // Initial processing
	  // ========================================================================================
	  XXX_DT_ST:  begin                                      
			next_state = DCT_TX_ST;                
		      end
	  // ========================================================================================
	  // processing ..
	  // ========================================================================================  
	  DCT_TX_ST:  begin    
	                if( enb_cg_w == 1'b1 )
			    next_state = DCT_TX_ST;     
			else    
			    next_state = ACT_TX_ST;
		      end
		      
	  default:    next_state = ACT_TX_ST;
      endcase
end

always @(
	 state
	 ) begin
         case(state)
	  // ========================================================================================
	  // Initialize 
	  // ========================================================================================
	  ACT_TX_ST:  begin
			xxx_dt_valid_w  = 1'b0;                        
		      end
	  // ========================================================================================
	  // Initial processing
	  // ========================================================================================
	  XXX_DT_ST:  begin                                        
			xxx_dt_valid_w  = 1'b0; 
		      end
		                    
	  // ========================================================================================
	  // processing ..
	  // ========================================================================================      
	  DCT_TX_ST:  begin                                       
			xxx_dt_valid_w  = 1'b1; 
		      end   
		      
	  default:    begin
			xxx_dt_valid_w  = 1'b0;    
		      end
      endcase
end

assign xxx_dt_valid_o  = xxx_dt_valid_w;

endmodule
