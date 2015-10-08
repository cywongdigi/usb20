`include "timescale.v"

module usbf_ssram
#(
    parameter USBF_SSRAM_HADR=14
)
(
  input                        clk_i,
  input  [USBF_SSRAM_HADR:0]   address_i,
  input  [31:0]                data_i,
  output [31:0]                data_o,
  input                        we_i,
  input                        re_i           
);

parameter RAM_DEPTH = 1 << USBF_SSRAM_HADR;

reg [31:0] data_out;
reg [31:0] mem [0:RAM_DEPTH-1];

assign data_o = data_out;


always @ (posedge clk_i) begin
   if(we_i)begin
     mem[address_i] <= data_i;
   end
end


always @ (posedge clk_i) begin
  if(!we_i && re_i)begin
    data_out <= mem[address_i];
  end
end


endmodule
