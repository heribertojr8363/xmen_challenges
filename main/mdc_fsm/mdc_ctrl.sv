module mdc_ctrl(
    input  logic clk,
    input  logic rstn_i,
    input  logic enb_i,
    input  logic x_diff_y,
    input  logic x_minus_y,

    output logic sel_x,
    output logic sel_y,
    output logic enb_x,
    output logic enb_y,
    output logic enb_o,
    output logic busy_o
);

// ================== FSM ==================

typedef enum logic [2:0] 
{
  S0,     //00
  S1,     //01
  S2,     //02
  S3      //03
} state;

state current, next;

always_ff @(posedge clk or negedge rstn_i) begin
  if(~rstn_i) begin
    current <= S0;
  end else begin
    current <= next;
  end
end

// =========== NEXT STATE LOGIC =============

always_comb begin
  case (current)
    S0: begin
        if (enb_i)         next = S1;
        else               next = S0;
        end
    S1: begin
        if(!x_diff_y)      next = S3;
        else               next = S2;
        end
    S2: begin
        next = S1;
        end
    S3: begin
	next = S0;
	end
    default : next = S0;
  endcase
end

// ================ STATES ==================
always_comb begin
  case(current)
    S0: begin
        sel_x = 0;      sel_y = 0;      enb_x = 1;
        enb_y = 1;      enb_o = 0;      busy_o = 0;
        end
    S1: begin
        sel_x = 0;      sel_y = 0;      enb_x = 0;
        enb_y = 0;      enb_o = 0;      busy_o = 1;
	end
    S2: begin
        if(x_minus_y) begin
            sel_y = 1;
	    	sel_x = 0;
	    	enb_y = 1;
            enb_x = 0;
        end
        else begin
            sel_x = 1; 
            sel_y = 0;
            enb_x = 1;
            enb_y = 0; 
        end 
        enb_o = 0;      busy_o = 1;
        end
    S3: begin
        sel_x = 0;      sel_y = 0;      enb_x = 0;
        enb_y = 0;      enb_o = 1;      busy_o = 1;
	end
    default: 
        begin
        sel_x = 0;      sel_y = 0;      enb_x = 0;
        enb_y = 0;      enb_o = 0;      busy_o = 1;
     	end
    endcase
end

endmodule
