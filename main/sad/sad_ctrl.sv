module sad_ctrl(
    input  logic clk,
    input  logic rstn_i,
    input  logic enb_i,
    input  logic i_it_256,

    output logic busy_o,
    output logic i_inc,
    output logic i_clr,
    output logic sum_ld,
    output logic sum_clr,
    output logic sad_reg_ld
);

// ================== FSM ==================

typedef enum logic [2:0] 
{
  S0,     //00
  S1,     //01
  S2,     //02
  S3,     //03
  S4      //04
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
        if (enb_i)    next = S1;
        else          next = S0;
        end
    S1: begin
        next = S2;
        end 
    S2: begin
        if(i_it_256)  next = S3;
        else          next = S4;
        end
    S3: begin
        next = S2 ;
        end
    S4: begin
        next = S0;
        end
    default : next = S0;
  endcase
end

// ================ STATES ==================
always_comb begin
  case(current)
    S1: begin
        sum_clr = 1;  i_clr = 1;
        sum_ld = 0;   i_inc = 0;
        sad_reg_ld = 0;   
        busy_o = 1; 
        end
    S3: begin
        sum_clr = 0;  i_clr = 0; 
        sum_ld = 1;   i_inc = 1;
        sad_reg_ld = 0;   
        busy_o = 1; 
        end
    S4: begin
        sum_clr = 0;  i_clr = 0; 
        sum_ld = 0;   i_inc = 0;
        sad_reg_ld = 1;   
        busy_o = 0;
        end
    default: 
        begin
        sum_clr = 0;  i_clr = 0; 
        sum_ld = 0;   i_inc = 0;
        sad_reg_ld = 0;   
        busy_o = 1; 
        end
    endcase
end

endmodule
