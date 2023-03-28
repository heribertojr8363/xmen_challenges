module sad_proc(
    input logic clk,
    input logic rstn_i,
    input logic i_inc,
    input logic i_clr,
    input logic sum_ld,
    input logic sum_clr,
    input logic sad_reg_ld,
    input logic [7:0] dta_i,
    input logic [7:0] dtb_i,

    output logic i_it_256,
    output logic [31:0] dt_o
);

// INTERNAL SIGNS
logic [7:0] abs;
logic [8:0] i;
logic [31:0] sum;
logic [31:0] sad_reg;

// ================ REGISTERS ================
  always_ff@(posedge clk or negedge rstn_i) begin
    if(~rstn_i) begin
      i       <= 9'd0;
      sum     <= 32'd0;
      sad_reg <= 32'd0;
    end 
    else begin
        if (i_inc)
          i <= (i + 1);
        if (i_clr)
          i <= 9'd0;

        if (sum_ld)
          sum <= (sum + abs);
        if (sum_clr)
          sum <= 32'd0; 

        sad_reg <= sum;
	
    	if(sad_reg_ld)
      	  dt_o = sad_reg;	
    end
  end
// ============= COMBINATIONAL LOGIC ========
  always_comb begin
    i_it_256 = (i < 9'd256);

    if(dta_i < dtb_i)
      abs = (dtb_i - dta_i);
    else
      abs = (dta_i - dtb_i);	

  end  
endmodule
