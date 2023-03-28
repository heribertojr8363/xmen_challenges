module sqrt_ctrl(
    input  logic clk,
    input  logic rstn_i,
    input  logic enb_i,
    input  logic [16:0] bus_proc,

    output logic [9:0] bus_ctrl,
    output logic busy_o
);

// ================== FSM ==================

typedef enum logic [3:0] 
{
  ENB,     //00
  RG0,     //01
  RG1,     //02
  RG2,     //03
  RG3,     //04
  RG4,     //05
  RG5,     //06
  RG6,     //07
  SQT      //08
} state;

state current, next;

always_ff @(posedge clk or negedge rstn_i) begin
  if(~rstn_i) begin
    current <= ENB;
  end else begin
    current <= next;
  end
end

// =========== NEXT STATE LOGIC =============

always_comb begin
  case (current)
    ENB: begin
        if (enb_i)     next = RG0;
        else           next = ENB;
        end
    RG0: begin
	if(bus_proc [8:0] <= bus_proc [16:9])   next = RG1;
        else                                    next = SQT;
        end 
    RG1: begin
        if(bus_proc [8:0] <= bus_proc [16:9])   next = RG2;
        else                                    next = SQT;
        end
    RG2: begin
        next = RG3;
        end 
    RG3: begin
        next = RG4;
        end
    RG4: begin
        next = RG5;
        end
    RG5: begin
        next = RG6;
        end
    RG6: begin
        if(bus_proc [8:0] <= bus_proc [16:9])   next = RG1;
        else                                    next = SQT;
        end
    SQT: begin
        next = ENB;
        end
    default : next = ENB;
  endcase
end

// ================ STATES ==================
always_comb begin
  case(current)
    ENB: begin
        bus_ctrl[0] = 1;      bus_ctrl[1] = 0;      bus_ctrl[2] = 0;
        bus_ctrl[3] = 0;      bus_ctrl[4] = 0;      bus_ctrl[5] = 0;
        busy_o = 0;           bus_ctrl[9:6] = 4'd0;
        end
    RG0: begin
        bus_ctrl[0] = 0;      bus_ctrl[1] = 0;      bus_ctrl[2] = 0;
        bus_ctrl[3] = 0;      bus_ctrl[4] = 1;      bus_ctrl[5] = 0;
        busy_o = 1;           bus_ctrl[9:6] = 4'd1;
        end
    RG1: begin
        bus_ctrl[0] = 0;      bus_ctrl[1] = 0;      bus_ctrl[2] = 0;
        bus_ctrl[3] = 0;      bus_ctrl[4] = 0;      bus_ctrl[5] = 1;
        busy_o = 1;           bus_ctrl[9:6] = 4'd2;
	end
    RG2: begin
        bus_ctrl[0] = 0;      bus_ctrl[1] = 0;      bus_ctrl[2] = 1;
        bus_ctrl[3] = 0;      bus_ctrl[4] = 1;      bus_ctrl[5] = 0;
        busy_o = 1;           bus_ctrl[9:6] = 4'd4; 
        end
    RG3: begin
        bus_ctrl[0] = 0;      bus_ctrl[1] = 0;      bus_ctrl[2] = 0;
        bus_ctrl[3] = 0;      bus_ctrl[4] = 0;      bus_ctrl[5] = 1;
        busy_o = 1;           bus_ctrl[9:6] = 4'd1;
	end
    RG4: begin
        bus_ctrl[0] = 0;      bus_ctrl[1] = 1;      bus_ctrl[2] = 0;
        bus_ctrl[3] = 0;      bus_ctrl[4] = 0;      bus_ctrl[5] = 1;
        busy_o = 1;           bus_ctrl[9:6] = 4'd8;
	end
    RG5: begin
        bus_ctrl[0] = 0;      bus_ctrl[1] = 0;      bus_ctrl[2] = 0;
        bus_ctrl[3] = 0;      bus_ctrl[4] = 1;      bus_ctrl[5] = 0;
        busy_o = 1;           bus_ctrl[9:6] = 4'd4;
	end
    RG6: begin
        bus_ctrl[0] = 0;      bus_ctrl[1] = 1;      bus_ctrl[2] = 0;
        bus_ctrl[3] = 0;      bus_ctrl[4] = 1;      bus_ctrl[5] = 0;
        busy_o = 1;           bus_ctrl[9:6] = 4'd1;
	end
    SQT: begin
        bus_ctrl[0] = 0;      bus_ctrl[1] = 0;      bus_ctrl[2] = 0;
        bus_ctrl[3] = 1;      bus_ctrl[4] = 0;      bus_ctrl[5] = 0;
        busy_o = 1;           bus_ctrl[9:6] = 4'd0;
	end
    default: 
        begin
        bus_ctrl[0] = 0;      bus_ctrl[1] = 0;      bus_ctrl[2] = 0;
        bus_ctrl[3] = 0;      bus_ctrl[4] = 0;      bus_ctrl[5] = 0;
        busy_o = 1;           bus_ctrl[9:6] = 4'd0; 
     	end
    endcase
end

endmodule


/* bus_ctrl[0] = clr; bus_ctrl[1] = s_ld; bus_ctrl[2] = d_ld; bus_ctrl[3] = r_ld; bus_ctrl[4] = reg1_ld; bus_ctrl[5] = reg2_ld; bus_ctrl[9:6] = selector;*/
