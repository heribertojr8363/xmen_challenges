module fft_16_4 #(
int INPUT_WIDTH = 8,
int OUTPUT_WIDTH = INPUT_WIDTH + 4
)
(
output logic o_valid,
output logic signed [OUTPUT_WIDTH-1:0] o_data[16][2],
input logic i_valid,
input logic signed [INPUT_WIDTH-1:0] i_data[4][2],
input logic clk,
input logic rst_sync_n
);
// seu design aqui

    
endmodule