module huffman#(parameter DATA_WIDTH = 8)
(
    input  logic clk_i,
    input  logic rstn_i,
    input  logic serial_i,

    output logic [4:0] symbol_o,
    output logic ready,
    output logic valid
);


// ================== FSM ==================

typedef enum logic [5:0] 
{
S0, S_A, S1, S2, S_B, S3, S_C, S4, S_D, S_E, S_F, S5, S6, S_G, S7, S_H, S8, S9, S_I, S_J, S_K, S10, S11, S_L, S12, S13, S_M, S_N, S14, S15, S_O, S16, S_P, S17, S18
} state;

state current, next;

always_ff @(posedge clk_i or negedge rstn_i) begin
  if(~rstn_i) begin
    current <= S0;
  end 
  else begin
    current <= next;
  end
end

// =========== NEXT STATE LOGIC =============

always_comb begin
  case (current)
    S0: begin
        valid = 0;
        ready = 1;
        if (!serial_i) next = S_A;        
        else if (serial_i) next = S_B;
        else next = S0;
        end
    S_A: begin
        if (!serial_i) next = S1;        
        else next = S2;
        end
    S1: begin
        ready = 0;
        valid = 1;
        symbol_o = 1;
        next = S0;
        end
    S2: begin
        ready = 0;
        valid = 1;
        symbol_o = 2;
        next = S0;
        end
    S_B: begin
        if (!serial_i) next = S3;        
        else next = S_C;
        end
    S3: begin
        ready = 0;
        valid = 1;
        symbol_o = 3;
        next = S0;
        end
    S_C: begin
        if (!serial_i) next = S4;        
        else next = S_D;
        end
    S4: begin
        ready = 0;
        valid = 1;
        symbol_o = 4;
        next = S0;
        end
    S_D: begin
        if (!serial_i) next = S_E;        
        else next = S_I;
        end
    S_E: begin
        if (!serial_i) next = S_F;        
        else next = S_G;
        end
    S_F: begin
        if (!serial_i) next = S5;        
        else next = S6;
        end
    S5: begin
        ready = 0;
        valid = 1;
        symbol_o = 5;
        next = S0;
        end
    S6: begin
        ready = 0;
        valid = 1;
        symbol_o = 6;
        next = S0;
        end
    S_G: begin
        if (!serial_i) next = S7;        
        else next = S_H;
        end
    S7: begin
        ready = 0;
        valid = 1;
        symbol_o = 7;
        next = S0;
        end
    S_H: begin
        if (!serial_i) next = S8;        
        else next = S9;
        end
    S8: begin
        ready = 0;
        valid = 1;
        symbol_o = 8;
        next = S0;
        end
    S9: begin
        ready = 0;
        valid = 1;
        symbol_o = 9;
        next = S0;
        end
    S_I: begin
        if (!serial_i) next = S_J;        
        else next = S_M;
        end
    S_J: begin
        if (!serial_i) next = S_K;        
        else next = S_L;
        end
    S_K: begin
        if (!serial_i) next = S10;        
        else next = S11;
        end
    S10: begin
        ready = 0;
        valid = 1;
        symbol_o = 10;
        next = S0;
        end
    S11: begin
        ready = 0;
        valid = 1;
        symbol_o = 11;
        next = S0;
        end
    S_L: begin
        if (!serial_i) next = S12;        
        else next = S13;
        end
    S12: begin
        ready = 0;
        valid = 1;
        symbol_o = 12;
        next = S0;
        end
    S13: begin
        ready = 0;
        valid = 1;
        symbol_o = 13;
        next = S0;
        end
    S_M: begin
        if (!serial_i) next = S_N;        
        else next = S_O;
        end
    S_N: begin
        if (!serial_i) next = S14;        
        else next = S15;
        end
    S14: begin
        ready = 0;
        valid = 1;
        symbol_o = 14;
        next = S0;
        end
    S15: begin
        ready = 0;
        valid = 1;
        symbol_o = 15;
        next = S0;
        end
    S_O: begin
        if (!serial_i) next = S16;        
        else next = S_P;
        end
    S16: begin
        ready = 0;
        valid = 1;
        symbol_o = 16;
        next = S0;
        end
    S_P: begin
        if (!serial_i) next = S17;        
        else next = S18;
        end
    S17: begin
        ready = 0;
        valid = 1;
        symbol_o = 17;
        next = S0;
        end
    S18: begin
        ready = 0;
        valid = 1;
        symbol_o = 18;
        next = S0;
        end
    default : next = S0;
  endcase
end
endmodule
