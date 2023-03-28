// AUTHOR               : Heriberto Fonseca
// AUTHOR'S E-MAIL      : heriberto.fonseca@embedded.ufcg.edu.br
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR              DESCRIPTION
// 0.1      2023-03-13  heriberto.fonseca         Initial version
// -----------------------------------------------------------------------------
// KEYWORDS: RTL
// -----------------------------------------------------------------------------
// PURPOSE: 
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Other: N/A

module log #(parameter DATA_WIDTH = 8)
	(
		input logic clk_i,
		input logic rstn_i,
		input logic [DATA_WIDTH-1:0] number_i,       //Numbers given by the user
		output logic [DATA_WIDTH-1:0] number_o
		);

	typedef enum logic [2:0] {
		IDLE, START, M_1, M_2, M_3, M_4, M_5, MED
	} state;

	state current, next;
	
	logic ready, valid, calc, calc_aux;
	logic [DATA_WIDTH-1:0] m;
	logic [(2*DATA_WIDTH)-1:0] aux;
	logic [2:0] e;
    logic [DATA_WIDTH-1:0] vector_i [5:0] = {33,33,35,38,45,0};
    logic [DATA_WIDTH-1:0] vector_c [5:0] = {1,31,29,27,23,0};
	logic [5:0] c;
	logic [3:0] i;

	always_ff @(posedge clk_i, negedge rstn_i)
	begin
		if(~rstn_i) begin
    		current <= IDLE;
            i <= 'd0;
			aux <= 'd0;
			m <= 'd0;
  		end 
  		else begin
    		current <= next;
			if(ready) begin
				m <= {number_i,5'b00000} >> e;
				aux <= ({number_i,5'b00000} >> e)*vector_c[i];
            end

			if(valid) begin
				number_o[7:5] = e;
				number_o[4:0] = c;
				//$display("NUMBER_O = %d", number_o);
			end


			if(calc) begin
				//$display("M = %d", m);
				//$display("VECTOR_I[%d] = %d" ,(i-1), vector_i[i-1]);
                if(m >= vector_i[i-1])begin
                    m <= (aux>>5);
					//$display("AUX = %d", aux);
					//$display("VECTOR_C[%d] = %d" ,(i-1), vector_c[i-1]);
				end
				//$display("M = %d", m);
				if(i == 6)
					i <= 0;
            end
			if(calc_aux) begin
				aux <= m*vector_c[i-1];
				i--;
			end
			i++;
  		end
		
	end

	always_comb begin
		if (number_i < 2) begin
			e = 0;
		end
		else if (number_i < 4) begin
			e = 1;
		end
		else if (number_i < 8) begin
			e = 2;
		end
		else if (number_i < 16) begin
			e = 3;
		end
		else if (number_i < 32) begin
			e = 4;
		end
		else if (number_i < 64) begin
			e = 5;
		end
		else if(number_i < 128)
			e = 6;
		else 
			e = 7;

		case(current)
			IDLE: begin
				valid = 0;
				ready = 0;
				calc = 0;
				calc_aux = 0;
			end
			START: begin
				valid = 0;
				ready = 1;
				calc = 0;
				calc_aux = 0;
			end
			M_1: begin
				if(m >= 45)
					c[4] = 1;
				else
					c[4] = 0;
				valid = 0;
				ready = 0;
				calc = 1;
				calc_aux = 0;
			end
			M_2: begin
				if(m >= 38)
					c[3] = 1;
				else
					c[3] = 0;
				valid = 0;
				ready = 0;
				calc = 1;
				calc_aux = 0;
			end
			M_3: begin
				if(m >= 35)
					c[2] = 1;
				else
					c[2] = 0;
				valid = 0;
				ready = 0;
				calc = 1;
				calc_aux = 0;
			end
			M_4: begin
				if(m >= 33)
					c[1] = 1;
				else
					c[1] = 0;
				valid = 0;
				ready = 0;
				calc = 1;
				calc_aux = 0;
			end
			M_5: begin
				if(m >= 33)
					c[0] = 1;
				else
					c[0] = 0;
				valid = 1;
				ready = 0;
				calc = 1;
				calc_aux = 0;
			end
			MED: begin
				valid = 1;
				ready = 0;
				calc = 0;
				calc_aux = 1;
			end
			default: begin
				valid = 0;
				ready = 0;
				calc = 0;
				calc_aux = 0;
			end
		endcase

	end

	always_comb begin
		case(current)
			IDLE: begin
                if (i == 0) next = START;        
                else next = IDLE;
			end
			START: begin
                if (i == 1) next = MED;        
                else next = IDLE;
			end
			M_1: begin
                if (i == 2) next = MED;        
                else next = IDLE;
			end
			M_2: begin
                if (i == 3) next = MED;        
                else next = IDLE;
			end
			M_3: begin
                if (i == 4) next = MED;        
                else next = IDLE;
			end
			M_4: begin
                if (i == 5) next = MED;        
                else next = IDLE;
			end
			M_5: begin
                if (i == 6) next = IDLE;        
                else next = IDLE;
			end
			MED: begin
				 if(i == 2) next = M_1;
				 else if(i == 3) next = M_2;
				 else if(i == 4) next = M_3;
				 else if(i == 5) next = M_4;
				 else if(i == 6) next = M_5;
				 else next = IDLE;
			end
			default: next = IDLE;
        endcase
	end

endmodule
