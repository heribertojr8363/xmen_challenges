module sqrt_proc(
    input logic clk,
    input logic rstn_i,
    input logic busy_o,
    input logic [9:0] bus_ctrl,
    input logic [7:0] dt_i,

    output logic [16:0] bus_proc,
    output logic [7:0] dt_o
);

// INTERNAL SIGNS
logic [8:0] s;
logic [7:0] x;
logic [4:0] d;
logic [7:0] r;
logic [8:0] reg1;
logic [8:0] reg2;
logic [1:0] aux_1;
logic [1:0] aux_2;
logic [8:0] signal;

// ================ REGISTERS ================
  always_ff@(posedge clk or negedge rstn_i) begin
    if(~rstn_i) begin
      s       <= 9'd4;
      x       <= 8'd0;
      d       <= 5'd2;
      r       <= 8'd0;
      reg1    <= 9'd0;
      reg2    <= 9'd0;
      aux_1   <= 2'd1;
      aux_2   <= 2'd2;
    end 
    else begin
      if (~busy_o)
        x <= dt_i;

      if (bus_ctrl [0]) begin
        s    <= 9'd4;
        d    <= 5'd2; 
        r    <= 8'd0;
	reg1    <= 9'd0;
        reg2    <= 9'd0;
	aux_1   <= 2'd1;
	aux_2   <= 2'd2;
      end
      
      if (bus_ctrl [4]) begin
        reg1 <= signal;
      end

      if (bus_ctrl [5]) begin
        reg2 <= signal;
      end

      if (bus_ctrl [1])
        s <= reg1+reg2;
      if (bus_ctrl [2])
        d <= reg1+reg2;
      if (bus_ctrl [3])
	begin
        r    <= (d>>1);
	dt_o <= (d>>1);
	end

    end
  end
// ============= COMBINATIONAL LOGIC ========
  always_comb begin
	if(bus_ctrl [6])
		signal = d;
	else begin
		if(bus_ctrl [7])
			signal = aux_2;
    		else begin
			if(bus_ctrl [8])
				signal = s;
			else begin
				if(bus_ctrl [9])
					signal = aux_1;
				else
					signal = 9'bz;
			     end
                     end
             end   	
					
    bus_proc [8:0]   = s;
    bus_proc [16:9]  = x;	
  end  
endmodule
