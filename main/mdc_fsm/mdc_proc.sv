module mdc_proc(
    input logic clk,
    input logic rstn_i,
    input logic busy_o,
    input logic sel_x,
    input logic sel_y,
    input logic enb_x,
    input logic enb_y,
    input logic enb_o,
    input logic [7:0] dtx_i,
    input logic [7:0] dty_i,

    output logic x_diff_y,
    output logic x_minus_y,
    output logic [7:0] dt_o
);

// INTERNAL SIGNS
logic [7:0] reg_x;
logic [7:0] reg_y;
logic [7:0] reg_res;

// ================ REGISTERS ================
  always_ff@(posedge clk or negedge rstn_i) begin
    if(~rstn_i) begin
      reg_x      <= 8'd0;
      reg_y      <= 8'd0;
      reg_res    <= 8'd0;
      end 
    else begin  
      if(~busy_o) begin
        reg_x <= dtx_i;
        reg_y <= dty_i;
      end
      
      if(enb_x) begin  
        case (sel_x)
          0: reg_x <= dtx_i;
          1: reg_x <= (reg_x - reg_y);
          default : reg_x <= 8'd0;
        endcase
      end
      
      if(enb_y) begin
        case (sel_y)
          0: reg_y <= dty_i;
          1: reg_y <= (reg_y - reg_x);
          default : reg_x <= 8'd0;
        endcase
      end
      
      if (enb_o)
	     reg_res <= reg_x;
	  dt_o = reg_res;
    end
  end
// ============= COMBINATIONAL LOGIC ========
  always_comb begin
	if(reg_x != reg_y) begin
    	x_diff_y = 1'd1;
		if(reg_x < reg_y)
    			x_minus_y = 1'd1;
  		else
    			x_minus_y = 1'd0;
	end
  else
    x_diff_y = 1'd0;

  end  
endmodule
