module freq_divider
	(
		input logic clk_i,
		input logic rst_i,
		input logic [1:0] selector_i,
		output logic clk_o
		);
	logic [3:0] counter;
	always_ff @(posedge clk_i, posedge rst_i)
	begin
		if(rst_i)
			counter <= 4'h0;
		else
			counter <= counter + 4'h1;
	end
	always_comb
	begin
		case(selector_i)
			2'b00: clk_o = counter [0];
			2'b01: clk_o = counter [1];
			2'b10: clk_o = counter [2];
			2'b11: clk_o = counter [3];
		endcase
	end
endmodule


