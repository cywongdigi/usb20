`include "timescale.v"

module usbf_wb_master
(
  clk_i,
  rst_i,
  wr_en,
  rd_en,

  ctrl_adr_i,
  ctrl_din_o,
  ctrl_dout_i,
  ctrl_ack_o,

  core_adr_o,
  core_din_i,
  core_dout_o,

  cyc_o, 
  stb_o,
  we_o,
  ack_i
);


parameter dwidth = 32;
parameter awidth = 18;


input                  clk_i;
input                  rst_i;
input                  wr_en;
input                  rd_en;
input  [awidth   -1:0] ctrl_adr_i;
output [dwidth   -1:0] ctrl_din_o;
input  [dwidth   -1:0] ctrl_dout_i;
output                 ctrl_ack_o;
output [awidth   -1:0] core_adr_o;
input  [dwidth   -1:0] core_din_i;
output [dwidth   -1:0] core_dout_o;
output                 cyc_o;
output                 stb_o;
output                 we_o;  
input                  ack_i;

reg cyc_r;
reg stb_r;
reg we_r;


reg [awidth   -1:0] ctrl_adr_r;
reg [dwidth   -1:0] ctrl_dout_r;

assign we_o  = we_r;
assign cyc_o = cyc_r;
assign stb_o = stb_r;

assign ctrl_ack_o = ack_i;

assign core_adr_o = ctrl_adr_r;
assign core_din_i = ctrl_din_o;
assign core_dout_o = ctrl_dout_r;







always @ (posedge clk_i or negedge rst_i) begin

    if(!rst_i)
      ctrl_adr_r <= #1 18'h0;
    else if(wr_en & !rd_en)
      ctrl_adr_r <= #1 ctrl_adr_i;
    else
      ctrl_adr_r <= #1 ctrl_adr_r;

end


always @ (posedge clk_i or negedge rst_i) begin

    if(!rst_i)
      ctrl_dout_r <= #1 32'h0;
    else if(wr_en & !rd_en)
      ctrl_dout_r <= #1 ctrl_dout_i;
    else
      ctrl_dout_r <= #1 ctrl_dout_r;

end






always @ (posedge clk_i or negedge rst_i) begin

    if(!rst_i)
      we_r <= #1 1'bx;
    else if(wr_en & !rd_en)
      we_r <= #1 1'b1;
    else if(we_r  & ack_i)
      we_r <= #1 1'bx;
    else
      we_r <= #1 we_r;

end

always @ (posedge clk_i or negedge rst_i) begin

    if(!rst_i)
      cyc_r <= #1 1'b0;
    else if(wr_en | rd_en)
      cyc_r <= #1 1'b1;
    else if(cyc_r & ack_i)
      cyc_r <= #1 1'b0;
    else
      cyc_r <= #1 cyc_r; 

end


always @ (posedge clk_i or negedge rst_i) begin

    if(!rst_i)
      stb_r <= #1 1'b0;
    else if(wr_en | rd_en)
      stb_r <= #1 1'b1;
    else if(stb_r & ack_i)
      stb_r <= #1 1'bx;
    else
      stb_r <= #1 stb_r; 

end


endmodule
 
