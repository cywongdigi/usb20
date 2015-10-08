`include "timescale.v"
`include "usbf_defines.v"

module usbf_ctrl
(
  clk,
  rst,
  ctrl_setup,
  ctrl_in,
  ctrl_out,
  ep0_din,
  mreq,
  mwe,
  rom_start_adr,
  ctrl_wr_en,
  ctrl_rd_en,
  ctrl_adr_i,
  ctrl_din_o,
  ctrl_dout_i,
  ctrl_ack_o,
  wLength_o,
  ctrl_mode_o,
  we_ctrl_o,
  data_ctrl_o,
  address_ctrl_o,
  index_ctrl_o,
  bRequest_o
);

input         clk;
input         rst;
input         ctrl_setup;
input         ctrl_in;
input         ctrl_out;
input [31:0]  ep0_din;

input           mreq;
input           mwe;
output [14:0]   rom_start_adr;
output [10:0]   wLength_o;
output          ctrl_mode_o;
output          ctrl_wr_en;
output          ctrl_rd_en;

output [`USBF_UFC_HADR:0]   ctrl_adr_i;
input  [31:0]               ctrl_din_o;
output [31:0]               ctrl_dout_i;
input                       ctrl_ack_o;
output                      we_ctrl_o;
output [7:0]                data_ctrl_o;
output [`USBF_SSRAM_HADR:0] address_ctrl_o;
output [1:0]                index_ctrl_o;
output [7:0]                bRequest_o;



parameter GET_STATUS     = 8'h00;
parameter CLEAR_FEATURE  = 8'h01;
parameter SET_FEATURE    = 8'h03;
parameter SET_ADDRESS    = 8'h05;
parameter GET_DESCRIPTOR = 8'h06;
parameter SET_DESCRIPTOR = 8'h07;
parameter GET_CONFIG     = 8'h08;
parameter SET_CONFIG     = 8'h09;
parameter GET_INTERFACE  = 8'h0a;
parameter SET_INTERFACE  = 8'h0b;
parameter SYNCH_FRAME    = 8'h0c;



parameter WAIT_RST          = 20'd0;
parameter EP0_CSR_INIT      = 20'd1;
parameter EP0_CSR_INIT_W    = 20'd2;
parameter EP1_CSR_INIT      = 20'd3;
parameter EP1_CSR_INIT_W    = 20'd4;
parameter EP2_CSR_INIT      = 20'd5;
parameter EP2_CSR_INIT_W    = 20'd6;
parameter EP3_CSR_INIT      = 20'd7;
parameter EP3_CSR_INIT_W    = 20'd8;
parameter EP4_CSR_INIT      = 20'd9;
parameter EP4_CSR_INIT_W    = 20'd10;
parameter EP5_CSR_INIT      = 20'd11;
parameter EP5_CSR_INIT_W    = 20'd12;
parameter EP6_CSR_INIT      = 20'd13;
parameter EP6_CSR_INIT_W    = 20'd14;
parameter EP7_CSR_INIT      = 20'd15;
parameter EP7_CSR_INIT_W    = 20'd16;
parameter EP8_CSR_INIT      = 20'd17;
parameter EP8_CSR_INIT_W    = 20'd18;
parameter EP9_CSR_INIT      = 20'd19;
parameter EP9_CSR_INIT_W    = 20'd20;
parameter EP10_CSR_INIT     = 20'd21;
parameter EP10_CSR_INIT_W   = 20'd22;
parameter EP11_CSR_INIT     = 20'd23;
parameter EP11_CSR_INIT_W   = 20'd24;
parameter EP12_CSR_INIT     = 20'd25;
parameter EP12_CSR_INIT_W   = 20'd26;
parameter EP13_CSR_INIT     = 20'd27;
parameter EP13_CSR_INIT_W   = 20'd28;
parameter EP14_CSR_INIT     = 20'd29;
parameter EP14_CSR_INIT_W   = 20'd30;
parameter EP15_CSR_INIT     = 20'd31;
parameter EP15_CSR_INIT_W   = 20'd32;
parameter EP0_BUF0_INIT     = 20'd51;
parameter EP0_BUF0_INIT_W   = 20'd52;
parameter EP0_BUF1_INIT     = 20'd53;
parameter EP0_BUF1_INIT_W   = 20'd54;
parameter EP1_BUF0_INIT     = 20'd55;
parameter EP1_BUF0_INIT_W   = 20'd56;
parameter EP1_BUF1_INIT     = 20'd57;
parameter EP1_BUF1_INIT_W   = 20'd58;
parameter EP2_BUF0_INIT     = 20'd59;
parameter EP2_BUF0_INIT_W   = 20'd60;
parameter EP2_BUF1_INIT     = 20'd61;
parameter EP2_BUF1_INIT_W   = 20'd62;
parameter EP3_BUF0_INIT     = 20'd63;
parameter EP3_BUF0_INIT_W   = 20'd64;
parameter EP3_BUF1_INIT     = 20'd65;
parameter EP3_BUF1_INIT_W   = 20'd66;
parameter EP4_BUF0_INIT     = 20'd67;
parameter EP4_BUF0_INIT_W   = 20'd68;
parameter EP4_BUF1_INIT     = 20'd69;
parameter EP4_BUF1_INIT_W   = 20'd70;
parameter EP5_BUF0_INIT     = 20'd71;
parameter EP5_BUF0_INIT_W   = 20'd72;
parameter EP5_BUF1_INIT     = 20'd73;
parameter EP5_BUF1_INIT_W   = 20'd74;
parameter EP6_BUF0_INIT     = 20'd75;
parameter EP6_BUF0_INIT_W   = 20'd76;
parameter EP6_BUF1_INIT     = 20'd77;
parameter EP6_BUF1_INIT_W   = 20'd78;
parameter EP7_BUF0_INIT     = 20'd79;
parameter EP7_BUF0_INIT_W   = 20'd80;
parameter EP7_BUF1_INIT     = 20'd81;
parameter EP7_BUF1_INIT_W   = 20'd82;
parameter EP8_BUF0_INIT     = 20'd83;
parameter EP8_BUF0_INIT_W   = 20'd84;
parameter EP8_BUF1_INIT     = 20'd85;
parameter EP8_BUF1_INIT_W   = 20'd86;
parameter EP9_BUF0_INIT     = 20'd87;
parameter EP9_BUF0_INIT_W   = 20'd88;
parameter EP9_BUF1_INIT     = 20'd89;
parameter EP9_BUF1_INIT_W   = 20'd90;
parameter EP10_BUF0_INIT    = 20'd91;
parameter EP10_BUF0_INIT_W  = 20'd92;
parameter EP10_BUF1_INIT    = 20'd93;
parameter EP10_BUF1_INIT_W  = 20'd94;
parameter EP11_BUF0_INIT    = 20'd95;
parameter EP11_BUF0_INIT_W  = 20'd96;
parameter EP11_BUF1_INIT    = 20'd97;
parameter EP11_BUF1_INIT_W  = 20'd98;
parameter EP12_BUF0_INIT    = 20'd99;
parameter EP12_BUF0_INIT_W  = 20'd100;
parameter EP12_BUF1_INIT    = 20'd101;
parameter EP12_BUF1_INIT_W  = 20'd102;
parameter EP13_BUF0_INIT    = 20'd103;
parameter EP13_BUF0_INIT_W  = 20'd104;
parameter EP13_BUF1_INIT    = 20'd105;
parameter EP13_BUF1_INIT_W  = 20'd106;
parameter EP14_BUF0_INIT    = 20'd107;
parameter EP14_BUF0_INIT_W  = 20'd108;
parameter EP14_BUF1_INIT    = 20'd109;
parameter EP14_BUF1_INIT_W  = 20'd110;
parameter EP15_BUF0_INIT    = 20'd111;
parameter EP15_BUF0_INIT_W  = 20'd112;
parameter EP15_BUF1_INIT    = 20'd113;
parameter EP15_BUF1_INIT_W  = 20'd114;

parameter IDLE              = 20'd33;
parameter GET_HDR           = 20'd34;
parameter SET_ADDRESS_S     = 20'd38;
parameter SET_ADDRESS_S_W   = 20'd115;
parameter STATUS_OUTIN_OUT  = 20'd 116;
parameter STATUS_OUTIN_IN   = 20'd 117;
parameter STATUS_INOUT_IN   = 20'd118;
parameter STATUS_INOUT_OUT  = 20'd119;


parameter STANDARD = 2'd0;
parameter CLASS    = 2'd1;
parameter VENDOR   = 2'd2;

parameter DEVICE    = 5'd0;
parameter INTERFACE = 5'd1;
parameter ENDPOINT  = 5'd2;   

parameter DEVICE_DES                    = 8'd1;        
parameter CONFIGURATION_DES             = 8'd2;  
parameter STRING_DES                    = 8'd3;  
parameter INTERFACE_DES                 = 8'd4;  
parameter ENDPOINT_DES                  = 8'd5;  
parameter DEVICE_QUALIFIER_DES          = 8'd6;  
parameter OTHER_SPEED_CONFIGURATION_DES = 8'd7;  


reg                    ctrl_wr_en_r;
reg                    ctrl_wr_en_en_r;
reg                    ctrl_rd_en_r;
reg [`USBF_UFC_HADR:0] ctrl_adr_r;
reg [31:0]             ctrl_dout_r;

reg [14:0]             rom_start_adr;

reg                      we_ctrl_r;
reg [7:0]                data_ctrl_r;
reg [`USBF_SSRAM_HADR:0] address_ctrl_r;
reg [1:0]                index_ctrl_r;
reg                      we_ctrl_en_r;


assign we_ctrl_o      = we_ctrl_r;
assign data_ctrl_o    = data_ctrl_r;
assign address_ctrl_o = address_ctrl_r;
assign index_ctrl_o   = index_ctrl_r;


wire [7:0] bmReqType;
wire [7:0] bRequest;







assign ctrl_wr_en  = ctrl_wr_en_r;
assign ctrl_rd_en  = ctrl_rd_en_r;
assign ctrl_adr_i  = ctrl_adr_r;
assign ctrl_dout_i = ctrl_dout_r;

always @ (posedge clk)begin
   if(!rst)
     ctrl_rd_en_r <= 1'b0;
   else
     ctrl_rd_en_r <= 1'b0;
end













wire [15:0] wValue;
wire [15:0] wIndex;
wire [15:0] wLength;
wire        bm_req_dir;
wire [1:0]  bm_req_type;
wire [4:0]  bm_req_recp;

reg set_address;


reg get_status;
reg clear_feature;
reg set_feature;







reg get_descriptor;
reg set_descriptor; 
reg get_config;
reg set_config;
reg get_configuration_descriptor;
reg get_interface; 
reg set_interface;
reg synch_frame;
reg hdr_done_r;
reg config_err;












reg  [19:0] state;
reg  [19:0] next_state;
reg         get_hdr;
wire        hdr_done;
reg  [1:0]  hdr_done_rr;

wire [7:0]  hdr0;
wire [7:0]  hdr1;
wire [7:0]  hdr2;
wire [7:0]  hdr3;
wire [7:0]  hdr4;
wire [7:0]  hdr5;
wire [7:0]  hdr6;
wire [7:0]  hdr7;
reg  [63:0] hdr;









always @ (posedge clk)begin
  if(!rst)begin
    we_ctrl_r <= 1'b0;
    data_ctrl_r <= 8'h0;
    address_ctrl_r <= 15'h0;
    index_ctrl_r <= 2'd0;
  end
  else if(we_ctrl_en_r)begin    
    if(bRequest == SET_CONFIG)begin
      we_ctrl_r      <= 1'b1;
      data_ctrl_r    <= wValue[7:0];
      address_ctrl_r <= `CONFIGURATION_DES_ROM_ADDR+1;
      index_ctrl_r   <= 2'd1;
    end
    else if(bRequest == SET_FEATURE && bm_req_recp==DEVICE) begin
      we_ctrl_r      <= 1'b1;
      data_ctrl_r    <= 8'h01;
      address_ctrl_r <= `DEVICE_GET_STATUS_ROM_ADDR;
      index_ctrl_r   <= 2'd0;
    end
    else if(bRequest == CLEAR_FEATURE && bm_req_recp==DEVICE) begin
      we_ctrl_r      <= 1'b1;
      data_ctrl_r    <= 8'h00;
      address_ctrl_r <= `DEVICE_GET_STATUS_ROM_ADDR;
      index_ctrl_r   <= 2'd0;
    end    
    else if(bRequest == SET_FEATURE && bm_req_recp==ENDPOINT) begin
      we_ctrl_r    <= 1'b1;
      data_ctrl_r  <= 8'h01;      
      index_ctrl_r <= 2'd0;
      
      case(wIndex[7:0])
        8'd1:    address_ctrl_r <= `EP1_DES_ROM_ADDR+2; 
        8'd2:    address_ctrl_r <= `EP2_DES_ROM_ADDR+2; 
        8'd3:    address_ctrl_r <= `EP3_DES_ROM_ADDR+2;        
        8'd4:    address_ctrl_r <= `EP4_DES_ROM_ADDR+2; 
        8'd5:    address_ctrl_r <= `EP5_DES_ROM_ADDR+2; 
        8'd6:    address_ctrl_r <= `EP6_DES_ROM_ADDR+2; 
        8'd7:    address_ctrl_r <= `EP7_DES_ROM_ADDR+2; 
        8'd8:    address_ctrl_r <= `EP8_DES_ROM_ADDR+2; 
        8'd9:    address_ctrl_r <= `EP9_DES_ROM_ADDR+2;
        8'd10:   address_ctrl_r <= `EP10_DES_ROM_ADDR+2;
        8'd11:   address_ctrl_r <= `EP11_DES_ROM_ADDR+2;
        8'd12:   address_ctrl_r <= `EP12_DES_ROM_ADDR+2;                            
        8'd13:   address_ctrl_r <= `EP13_DES_ROM_ADDR+2; 
        8'd14:   address_ctrl_r <= `EP14_DES_ROM_ADDR+2; 
        8'd15:   address_ctrl_r <= `EP15_DES_ROM_ADDR+2;                 
        default: address_ctrl_r <= `EP1_DES_ROM_ADDR+2;                             
      endcase
    end
    else if(bRequest == CLEAR_FEATURE && bm_req_recp==ENDPOINT) begin
      we_ctrl_r      <= 1'b1;
      data_ctrl_r    <= 8'h00;
      index_ctrl_r   <= 2'd0;
      
      case(wIndex[7:0])
        8'd1:    address_ctrl_r <= `EP1_DES_ROM_ADDR+2; 
        8'd2:    address_ctrl_r <= `EP2_DES_ROM_ADDR+2; 
        8'd3:    address_ctrl_r <= `EP3_DES_ROM_ADDR+2;        
        8'd4:    address_ctrl_r <= `EP4_DES_ROM_ADDR+2; 
        8'd5:    address_ctrl_r <= `EP5_DES_ROM_ADDR+2; 
        8'd6:    address_ctrl_r <= `EP6_DES_ROM_ADDR+2; 
        8'd7:    address_ctrl_r <= `EP7_DES_ROM_ADDR+2; 
        8'd8:    address_ctrl_r <= `EP8_DES_ROM_ADDR+2; 
        8'd9:    address_ctrl_r <= `EP9_DES_ROM_ADDR+2;
        8'd10:   address_ctrl_r <= `EP10_DES_ROM_ADDR+2;
        8'd11:   address_ctrl_r <= `EP11_DES_ROM_ADDR+2;
        8'd12:   address_ctrl_r <= `EP12_DES_ROM_ADDR+2;                            
        8'd13:   address_ctrl_r <= `EP13_DES_ROM_ADDR+2; 
        8'd14:   address_ctrl_r <= `EP14_DES_ROM_ADDR+2; 
        8'd15:   address_ctrl_r <= `EP15_DES_ROM_ADDR+2;                 
        default: address_ctrl_r <= `EP1_DES_ROM_ADDR+2;                             
      endcase      
    end
    else if(bRequest == SET_INTERFACE) begin
      we_ctrl_r      <= 1'b1;
      data_ctrl_r    <= wValue[7:0];
      index_ctrl_r   <= 2'd3;
      
      case(wIndex[7:0])
        8'd0:    address_ctrl_r <= `INTERFACE0_DES_ROM_ADDR;
        8'd1:    address_ctrl_r <= `INTERFACE1_DES_ROM_ADDR;
        8'd2:    address_ctrl_r <= `INTERFACE2_DES_ROM_ADDR;
        8'd3:    address_ctrl_r <= `INTERFACE3_DES_ROM_ADDR;       
        8'd4:    address_ctrl_r <= `INTERFACE4_DES_ROM_ADDR;
        8'd5:    address_ctrl_r <= `INTERFACE5_DES_ROM_ADDR;
        8'd6:    address_ctrl_r <= `INTERFACE6_DES_ROM_ADDR;
        8'd7:    address_ctrl_r <= `INTERFACE7_DES_ROM_ADDR;
        default: address_ctrl_r <= `INTERFACE0_DES_ROM_ADDR;                            
      endcase      
    end
    else begin
      we_ctrl_r      <= 1'b0;
      data_ctrl_r    <= data_ctrl_r;
      address_ctrl_r <= address_ctrl_r;
      index_ctrl_r   <= index_ctrl_r;
    end
  end
  else begin
    we_ctrl_r      <= 1'b0;
    data_ctrl_r    <= data_ctrl_r;
    address_ctrl_r <= address_ctrl_r;
    index_ctrl_r   <= index_ctrl_r;
  end
end


































assign hdr7 = hdr[63:56];
assign hdr6 = hdr[55:48];
assign hdr5 = hdr[47:40];
assign hdr4 = hdr[39:32];
assign hdr3 = hdr[31:24];
assign hdr2 = hdr[23:16];
assign hdr1 = hdr[15:8];
assign hdr0 = hdr[7:0];



always@(posedge clk) begin

   if(!rst)
     rom_start_adr <= 15'h0;
   else if((bRequest==SET_DESCRIPTOR || bRequest==GET_DESCRIPTOR) && bm_req_type==STANDARD && wValue[15:8]==INTERFACE_DES)begin
     case(wIndex[7:0])
       8'd0:    rom_start_adr <= `INTERFACE0_DES_ROM_ADDR;
       8'd1:    rom_start_adr <= `INTERFACE1_DES_ROM_ADDR;
       8'd2:    rom_start_adr <= `INTERFACE2_DES_ROM_ADDR;
       8'd3:    rom_start_adr <= `INTERFACE3_DES_ROM_ADDR;       
       8'd4:    rom_start_adr <= `INTERFACE4_DES_ROM_ADDR;
       8'd5:    rom_start_adr <= `INTERFACE5_DES_ROM_ADDR;
       8'd6:    rom_start_adr <= `INTERFACE6_DES_ROM_ADDR;
       8'd7:    rom_start_adr <= `INTERFACE7_DES_ROM_ADDR;
       default: rom_start_adr <= `INTERFACE0_DES_ROM_ADDR;                            
     endcase
   end
   else if((bRequest==SET_DESCRIPTOR || bRequest==GET_DESCRIPTOR) && bm_req_type==STANDARD && wValue[15:8]==ENDPOINT_DES)begin
     case(wIndex[7:0])
       8'd1:    rom_start_adr <= `EP1_DES_ROM_ADDR; 
       8'd2:    rom_start_adr <= `EP2_DES_ROM_ADDR; 
       8'd3:    rom_start_adr <= `EP3_DES_ROM_ADDR;        
       8'd4:    rom_start_adr <= `EP4_DES_ROM_ADDR; 
       8'd5:    rom_start_adr <= `EP5_DES_ROM_ADDR; 
       8'd6:    rom_start_adr <= `EP6_DES_ROM_ADDR; 
       8'd7:    rom_start_adr <= `EP7_DES_ROM_ADDR; 
       8'd8:    rom_start_adr <= `EP8_DES_ROM_ADDR; 
       8'd9:    rom_start_adr <= `EP9_DES_ROM_ADDR;
       8'd10:   rom_start_adr <= `EP10_DES_ROM_ADDR;
       8'd11:   rom_start_adr <= `EP11_DES_ROM_ADDR;
       8'd12:   rom_start_adr <= `EP12_DES_ROM_ADDR;                            
       8'd13:   rom_start_adr <= `EP13_DES_ROM_ADDR; 
       8'd14:   rom_start_adr <= `EP14_DES_ROM_ADDR; 
       8'd15:   rom_start_adr <= `EP15_DES_ROM_ADDR;                 
       default: rom_start_adr <= `EP1_DES_ROM_ADDR;                             
     endcase
   end 
   else if((bRequest==SET_DESCRIPTOR || bRequest==GET_DESCRIPTOR) && bm_req_type==STANDARD && wValue[15:8]!=INTERFACE_DES && wValue[15:8]!=ENDPOINT_DES)begin
     case(wValue[15:8])
       DEVICE_DES                   : rom_start_adr <= `DEVICE_DES_ROM_ADDR;                    // Device
       CONFIGURATION_DES            : rom_start_adr <= `CONFIGURATION_DES_ROM_ADDR;             // Configuration
       DEVICE_QUALIFIER_DES         : rom_start_adr <= `DEVICE_QUALIFIER_DES_ROM_ADDR;          // Device Qualifier
       OTHER_SPEED_CONFIGURATION_DES: rom_start_adr <= `OTHER_SPEED_CONFIGURATION_DES_ROM_ADDR; // Other Speed Configuration  
       default                      : rom_start_adr <= `DEVICE_DES_ROM_ADDR;
     endcase
   end
   else if(bRequest==GET_STATUS && bm_req_type==STANDARD && bm_req_recp==ENDPOINT)begin
     case(wIndex[7:0])
       8'd1:    rom_start_adr <= `EP1_DES_ROM_ADDR+2; 
       8'd2:    rom_start_adr <= `EP2_DES_ROM_ADDR+2; 
       8'd3:    rom_start_adr <= `EP3_DES_ROM_ADDR+2;        
       8'd4:    rom_start_adr <= `EP4_DES_ROM_ADDR+2; 
       8'd5:    rom_start_adr <= `EP5_DES_ROM_ADDR+2; 
       8'd6:    rom_start_adr <= `EP6_DES_ROM_ADDR+2; 
       8'd7:    rom_start_adr <= `EP7_DES_ROM_ADDR+2; 
       8'd8:    rom_start_adr <= `EP8_DES_ROM_ADDR+2; 
       8'd9:    rom_start_adr <= `EP9_DES_ROM_ADDR+2;
       8'd10:   rom_start_adr <= `EP10_DES_ROM_ADDR+2;
       8'd11:   rom_start_adr <= `EP11_DES_ROM_ADDR+2;
       8'd12:   rom_start_adr <= `EP12_DES_ROM_ADDR+2;                            
       8'd13:   rom_start_adr <= `EP13_DES_ROM_ADDR+2; 
       8'd14:   rom_start_adr <= `EP14_DES_ROM_ADDR+2; 
       8'd15:   rom_start_adr <= `EP15_DES_ROM_ADDR+2;                 
       default: rom_start_adr <= `EP1_DES_ROM_ADDR+2;                              
     endcase                                      
   end
   else if(bRequest==GET_INTERFACE && bm_req_type==STANDARD && bm_req_recp==INTERFACE)begin
     case(wIndex[7:0])
       8'd0:    rom_start_adr <= `INTERFACE0_DES_ROM_ADDR;
       8'd1:    rom_start_adr <= `INTERFACE1_DES_ROM_ADDR;
       8'd2:    rom_start_adr <= `INTERFACE2_DES_ROM_ADDR;
       8'd3:    rom_start_adr <= `INTERFACE3_DES_ROM_ADDR;       
       8'd4:    rom_start_adr <= `INTERFACE4_DES_ROM_ADDR;
       8'd5:    rom_start_adr <= `INTERFACE5_DES_ROM_ADDR;
       8'd6:    rom_start_adr <= `INTERFACE6_DES_ROM_ADDR;
       8'd7:    rom_start_adr <= `INTERFACE7_DES_ROM_ADDR;
       default: rom_start_adr <= `INTERFACE0_DES_ROM_ADDR;                            
     endcase                                     
   end
   else if(bRequest==GET_STATUS  && bm_req_type==STANDARD && bm_req_recp==DEVICE)
     rom_start_adr <= `DEVICE_GET_STATUS_ROM_ADDR;
   else if(bRequest==GET_STATUS  && bm_req_type==STANDARD && bm_req_recp==INTERFACE)
     rom_start_adr <= `INTERFACE_GET_STATUS_ROM_ADDR;
   else if(bRequest==GET_CONFIG  && bm_req_type==STANDARD && bm_req_recp==DEVICE)
     rom_start_adr <= `CONFIGURATION_DES_ROM_ADDR;          
   else if(bRequest==SYNCH_FRAME && bm_req_type==STANDARD && bm_req_recp==ENDPOINT)
     rom_start_adr <= `EP_FRM_NAT;
   else
     rom_start_adr <= rom_start_adr;

end



always@(posedge clk)begin
  if(!rst)
    hdr <= 64'h0;
  else if(get_hdr & mreq & mwe)
    hdr <= {ep0_din, hdr[63:32]};
  else
    hdr <= hdr;
end

always @ (posedge clk) begin
  if(!rst)
    hdr_done_rr <= 2'b00;
  else if(hdr_done_rr==2'b00 & get_hdr & mreq & mwe)
    hdr_done_rr <= 2'b001;
  else if(hdr_done_rr==2'b01 & get_hdr & mreq & mwe)
    hdr_done_rr <= 2'b10;
  else if(get_hdr)
    hdr_done_rr <= hdr_done_rr;
  else
    hdr_done_rr <= 2'b00;
end

assign hdr_done = hdr_done_rr[1];











assign bmReqType   = hdr0;
assign bm_req_dir  = bmReqType[7];   // 0-Host to device; 1-device to host
assign bm_req_type = bmReqType[6:5]; // 0-standard; 1-class; 2-vendor; 3-RESERVED
assign bm_req_recp = bmReqType[4:0]; // 0-device; 1-interface; 2-endpoint; 3-other
                                     // 4..31-reserved
assign bRequest   =  hdr1;
assign bRequest_o =  bRequest; 
assign wValue     = {hdr3, hdr2};
assign wIndex     = {hdr5, hdr4};
assign wLength    = {hdr7, hdr6};
assign wLength_o  = wLength[10:0];

always @(posedge clk)begin
  if(!rst)
    hdr_done_r <= #1 1'b0;
  else
    hdr_done_r <= #1 hdr_done;
end















always@(posedge clk)begin
   if(!rst)
     get_status <= #1 1'b0;
   else if(hdr_done & (bRequest == GET_STATUS) & (bm_req_type==STANDARD))
     get_status <= #1 1'b1;
   else
     get_status <= #1 1'b0;
end





always@(posedge clk)begin
	if(!rst)
	  set_feature <= #1 1'b0;
	else if(hdr_done & (bRequest == SET_FEATURE) & (bm_req_type==STANDARD))
	  set_feature <= #1 1'b1;
	else
	  set_feature <= #1 1'b0;
end


always@(posedge clk)begin
	if(!rst)
	  clear_feature <= #1 1'b0;
	else if(hdr_done & (bRequest == CLEAR_FEATURE) & (bm_req_type==STANDARD))
	  clear_feature <= #1 1'b1;
	else
	  clear_feature <= #1 1'b0;
end





always@(posedge clk)begin
	if(!rst)
	  set_address <= #1 1'b0;
	else if(hdr_done & (bRequest == SET_ADDRESS) & (bm_req_type==STANDARD))
	  set_address <= #1 1'b1;
	else
	  set_address <= #1 1'b0;
end                


always@(posedge clk)begin
	if(!rst) 
    get_descriptor <= #1 1'b0;
  else if(hdr_done & (bRequest == GET_DESCRIPTOR) & (bm_req_type==STANDARD))
    get_descriptor <= #1 1'b1;
  else
    get_descriptor <= #1 1'b0;
end
              

always@(posedge clk)begin
	if(!rst)
	  set_descriptor <= #1 1'b0;
	else if(hdr_done & (bRequest == SET_DESCRIPTOR) & (bm_req_type==STANDARD))
	  set_descriptor <= #1 1'b1;
	else
	  set_descriptor <= #1 1'b0;          
end
                

always@(posedge clk)begin
	if(!rst)
    get_config <= #1 1'b0;
  else if(hdr_done & (bRequest == GET_CONFIG) & (bm_req_type==STANDARD))
    get_config <= #1 1'b1;
  else
    get_config <= #1 1'b0;
end                

always@(posedge clk)begin
  if(!rst)
    set_config <= #1 1'b0;
  else if(hdr_done & (bRequest == SET_CONFIG) & (bm_req_type==STANDARD))
    set_config <= #1 1'b1;
  else
    set_config <= #1 1'b0;
end    
            

always@(posedge clk)begin
	if(!rst) 
    get_interface <= #1 1'b0;
  else if(hdr_done & (bRequest == GET_INTERFACE) & (bm_req_type==STANDARD))
    get_interface <= #1 1'b1;
  else
    get_interface <= #1 1'b0;
end                

always @(posedge clk)begin
	if(!rst)
    set_interface <= #1 1'b0;
  else if(hdr_done & (bRequest == SET_INTERFACE) & (bm_req_type==STANDARD))
    set_interface <= #1 1'b1;
  else
    set_interface <= #1 1'b0;            
end                

always @(posedge clk)begin
	if(!rst)
    synch_frame <= #1 1'b0;
  else if(hdr_done & (bRequest == SYNCH_FRAME) & (bm_req_type==STANDARD))
    synch_frame <= #1 1'b1;
  else
    synch_frame <= #1 1'b0;                
end   
















             
reg send_stall;

// A config err must cause the device to send a STALL for an ACK
always @(posedge clk)begin
  if(!rst)
    send_stall <= #1 1'b0;
  else if(hdr_done_r & !(get_status | clear_feature |
      set_feature | set_address | get_descriptor |
      set_descriptor | get_config | set_config |
      get_interface | set_interface | synch_frame))
    send_stall <= #1 1'b1;
  else
    send_stall <= #1 1'b0;
end      






always @ (posedge clk or negedge rst) begin
  if(!rst)
    ctrl_wr_en_r <= #1 1'b0;
  else if(ctrl_wr_en_en_r)
    ctrl_wr_en_r <= #1 1'b1;
  else
    ctrl_wr_en_r <= #1 1'b0;
end




reg ctrl_mode_r;
reg ctrl_mode_en;

assign ctrl_mode_o = ctrl_mode_r;

always @(posedge clk)begin
  if(!rst)
    ctrl_mode_r <= #1 1'b0; // 0-set, 1-get
  else if(ctrl_mode_en)
    ctrl_mode_r <= #1 1'b1;
  else
    ctrl_mode_r <= #1 ctrl_mode_r;
end









always @(posedge clk)begin
  if(!rst)
    state <= #1 WAIT_RST;
  else
    state <= #1 next_state;
end






always@(*) begin
  next_state = state;
  get_hdr  = 1'b0;
  we_ctrl_en_r = 1'b0;

  case(state)

    WAIT_RST:          begin
                         if(!rst)begin
                           ctrl_mode_en = 1'b0;
                           next_state = WAIT_RST;
                         end
                         else begin
                           ctrl_mode_en = 1'b0;
                           next_state = EP0_CSR_INIT;
                         end
                       end

    EP0_CSR_INIT:      begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP0_CSR;
                         ctrl_dout_r = `EP0_CSR_INIT_VALUE;
                         next_state  = EP0_CSR_INIT_W;
                       end

    EP0_CSR_INIT_W:    begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP0_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP1_CSR_INIT;
                         end
                       end

    EP1_CSR_INIT:      begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP1_CSR;
                         ctrl_dout_r = `EP1_CSR_INIT_VALUE;
                         next_state  = EP1_CSR_INIT_W;
                       end

    EP1_CSR_INIT_W:    begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP1_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP2_CSR_INIT;
                         end
                       end

    EP2_CSR_INIT:      begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP2_CSR;
                         ctrl_dout_r = `EP2_CSR_INIT_VALUE;
                         next_state  = EP2_CSR_INIT_W;
                       end

    EP2_CSR_INIT_W:    begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP2_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP3_CSR_INIT;
                         end
                       end

    EP3_CSR_INIT:      begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP3_CSR;
                         ctrl_dout_r = `EP3_CSR_INIT_VALUE;
                         next_state  = EP3_CSR_INIT_W;
                       end

    EP3_CSR_INIT_W:    begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP3_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP4_CSR_INIT;
                         end
                       end

    EP4_CSR_INIT:      begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP4_CSR;
                         ctrl_dout_r = `EP4_CSR_INIT_VALUE;
                         next_state  = EP4_CSR_INIT_W;
                       end

    EP4_CSR_INIT_W:    begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP4_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP5_CSR_INIT;
                         end
                       end

    EP5_CSR_INIT:      begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP5_CSR;
                         ctrl_dout_r = `EP5_CSR_INIT_VALUE;
                         next_state  = EP5_CSR_INIT_W;
                       end

    EP5_CSR_INIT_W:    begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP5_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP6_CSR_INIT;
                         end
                       end

    EP6_CSR_INIT:      begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP6_CSR;
                         ctrl_dout_r = `EP6_CSR_INIT_VALUE;
                         next_state  = EP6_CSR_INIT_W;
                       end

    EP6_CSR_INIT_W:    begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP6_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP7_CSR_INIT;
                         end
                       end

    EP7_CSR_INIT:      begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP7_CSR;
                         ctrl_dout_r = `EP7_CSR_INIT_VALUE;
                         next_state  = EP7_CSR_INIT_W;
                       end

    EP7_CSR_INIT_W:    begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP7_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP8_CSR_INIT;
                         end
                       end

    EP8_CSR_INIT:      begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP8_CSR;
                         ctrl_dout_r = `EP8_CSR_INIT_VALUE;
                         next_state  = EP8_CSR_INIT_W;
                       end

    EP8_CSR_INIT_W:    begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP8_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP9_CSR_INIT;
                         end
                       end

    EP9_CSR_INIT:      begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP9_CSR;
                         ctrl_dout_r = `EP9_CSR_INIT_VALUE;
                         next_state  = EP9_CSR_INIT_W;
                       end

    EP9_CSR_INIT_W:    begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP9_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP10_CSR_INIT;
                         end
                       end

    EP10_CSR_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP10_CSR;
                         ctrl_dout_r = `EP10_CSR_INIT_VALUE;
                         next_state  = EP10_CSR_INIT_W;
                       end

    EP10_CSR_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP10_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP11_CSR_INIT;
                         end
                       end

    EP11_CSR_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP11_CSR;
                         ctrl_dout_r = `EP11_CSR_INIT_VALUE;
                         next_state  = EP11_CSR_INIT_W;
                       end

    EP11_CSR_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP11_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP12_CSR_INIT;
                         end
                       end

    EP12_CSR_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP12_CSR;
                         ctrl_dout_r = `EP12_CSR_INIT_VALUE;
                         next_state  = EP12_CSR_INIT_W;
                       end

    EP12_CSR_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP12_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP13_CSR_INIT;
                         end
                       end

    EP13_CSR_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP13_CSR;
                         ctrl_dout_r = `EP13_CSR_INIT_VALUE;
                         next_state  = EP13_CSR_INIT_W;
                       end

    EP13_CSR_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP13_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP14_CSR_INIT;
                         end
                       end

    EP14_CSR_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP14_CSR;
                         ctrl_dout_r = `EP14_CSR_INIT_VALUE;
                         next_state  = EP14_CSR_INIT_W;
                       end

    EP14_CSR_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP14_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP15_CSR_INIT;
                         end
                       end

    EP15_CSR_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP15_CSR;
                         ctrl_dout_r = `EP15_CSR_INIT_VALUE;
                         next_state  = EP15_CSR_INIT_W;
                       end

    EP15_CSR_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP15_CSR_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP0_BUF0_INIT;
                         end
                       end

    EP0_BUF0_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP0_BUF0;
                         ctrl_dout_r = `EP0_BUF0_INIT_VALUE;
                         next_state  = EP0_BUF0_INIT_W;
                       end

    EP0_BUF0_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP0_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP0_BUF1_INIT;
                         end
                       end

    EP0_BUF1_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP0_BUF1;
                         ctrl_dout_r = `EP0_BUF1_INIT_VALUE;
                         next_state  = EP0_BUF1_INIT_W;
                       end

    EP0_BUF1_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP0_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP1_BUF0_INIT;
                         end
                       end

    EP1_BUF0_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP1_BUF0;
                         ctrl_dout_r = `EP1_BUF0_INIT_VALUE;
                         next_state  = EP1_BUF0_INIT_W;
                       end

    EP1_BUF0_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP1_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP1_BUF1_INIT;
                         end
                       end

    EP1_BUF1_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP1_BUF1;
                         ctrl_dout_r = `EP1_BUF1_INIT_VALUE;
                         next_state  = EP1_BUF1_INIT_W;
                       end

    EP1_BUF1_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP1_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP2_BUF0_INIT;
                         end
                       end

    EP2_BUF0_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP2_BUF0;
                         ctrl_dout_r = `EP2_BUF0_INIT_VALUE;
                         next_state  = EP2_BUF0_INIT_W;
                       end

    EP2_BUF0_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP2_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP2_BUF1_INIT;
                         end
                       end

    EP2_BUF1_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP2_BUF1;
                         ctrl_dout_r = `EP2_BUF1_INIT_VALUE;
                         next_state  = EP2_BUF1_INIT_W;
                       end

    EP2_BUF1_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP2_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP3_BUF0_INIT;
                         end
                       end

    EP3_BUF0_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP3_BUF0;
                         ctrl_dout_r = `EP3_BUF0_INIT_VALUE;
                         next_state  = EP3_BUF0_INIT_W;
                       end

    EP3_BUF0_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP3_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP3_BUF1_INIT;
                         end
                       end

    EP3_BUF1_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP3_BUF1;
                         ctrl_dout_r = `EP3_BUF1_INIT_VALUE;
                         next_state  = EP3_BUF1_INIT_W;
                       end

    EP3_BUF1_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP3_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP4_BUF0_INIT;
                         end
                       end

    EP4_BUF0_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP4_BUF0;
                         ctrl_dout_r = `EP4_BUF0_INIT_VALUE;
                         next_state  = EP4_BUF0_INIT_W;
                       end

    EP4_BUF0_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP4_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP4_BUF1_INIT;
                         end
                       end

    EP4_BUF1_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP4_BUF1;
                         ctrl_dout_r = `EP4_BUF1_INIT_VALUE;
                         next_state  = EP4_BUF1_INIT_W;
                       end

    EP4_BUF1_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP4_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP5_BUF0_INIT;
                         end
                       end

    EP5_BUF0_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP5_BUF0;
                         ctrl_dout_r = `EP5_BUF0_INIT_VALUE;
                         next_state  = EP5_BUF0_INIT_W;
                       end

    EP5_BUF0_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP5_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP5_BUF1_INIT;
                         end
                       end

    EP5_BUF1_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP5_BUF1;
                         ctrl_dout_r = `EP5_BUF1_INIT_VALUE;
                         next_state  = EP5_BUF1_INIT_W;
                       end

    EP5_BUF1_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP5_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP6_BUF0_INIT;
                         end
                       end

    EP6_BUF0_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP6_BUF0;
                         ctrl_dout_r = `EP6_BUF0_INIT_VALUE;
                         next_state  = EP6_BUF0_INIT_W;
                       end

    EP6_BUF0_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP6_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP6_BUF1_INIT;
                         end
                       end

    EP6_BUF1_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP6_BUF1;
                         ctrl_dout_r = `EP6_BUF1_INIT_VALUE;
                         next_state  = EP6_BUF1_INIT_W;
                       end

    EP6_BUF1_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP6_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP7_BUF0_INIT;
                         end
                       end

    EP7_BUF0_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP7_BUF0;
                         ctrl_dout_r = `EP7_BUF0_INIT_VALUE;
                         next_state  = EP7_BUF0_INIT_W;
                       end

    EP7_BUF0_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP7_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP7_BUF1_INIT;
                         end
                       end

    EP7_BUF1_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP7_BUF1;
                         ctrl_dout_r = `EP7_BUF1_INIT_VALUE;
                         next_state  = EP7_BUF1_INIT_W;
                       end

    EP7_BUF1_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP7_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP8_BUF0_INIT;
                         end
                       end

    EP8_BUF0_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP8_BUF0;
                         ctrl_dout_r = `EP8_BUF0_INIT_VALUE;
                         next_state  = EP8_BUF0_INIT_W;
                       end

    EP8_BUF0_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP8_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP8_BUF1_INIT;
                         end
                       end

    EP8_BUF1_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP8_BUF1;
                         ctrl_dout_r = `EP8_BUF1_INIT_VALUE;
                         next_state  = EP8_BUF1_INIT_W;
                       end

    EP8_BUF1_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP8_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP9_BUF0_INIT;
                         end
                       end

    EP9_BUF0_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP9_BUF0;
                         ctrl_dout_r = `EP9_BUF0_INIT_VALUE;
                         next_state  = EP9_BUF0_INIT_W;
                       end

    EP9_BUF0_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP9_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP9_BUF1_INIT;
                         end
                       end

    EP9_BUF1_INIT:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP9_BUF1;
                         ctrl_dout_r = `EP9_BUF1_INIT_VALUE;
                         next_state  = EP9_BUF1_INIT_W;
                       end

    EP9_BUF1_INIT_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP9_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP10_BUF0_INIT;
                         end
                       end

    EP10_BUF0_INIT:    begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP10_BUF0;
                         ctrl_dout_r = `EP10_BUF0_INIT_VALUE;
                         next_state  = EP10_BUF0_INIT_W;
                       end

    EP10_BUF0_INIT_W:  begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP10_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP10_BUF1_INIT;
                         end
                       end

    EP10_BUF1_INIT:    begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP10_BUF1;
                         ctrl_dout_r = `EP10_BUF1_INIT_VALUE;
                         next_state  = EP10_BUF1_INIT_W;
                       end

    EP10_BUF1_INIT_W:  begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP10_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP11_BUF0_INIT;
                         end
                       end

    EP11_BUF0_INIT:    begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP11_BUF0;
                         ctrl_dout_r = `EP11_BUF0_INIT_VALUE;
                         next_state  = EP11_BUF0_INIT_W;
                       end

    EP11_BUF0_INIT_W:  begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP11_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP11_BUF1_INIT;
                         end
                       end

    EP11_BUF1_INIT:    begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP11_BUF1;
                         ctrl_dout_r = `EP11_BUF1_INIT_VALUE;
                         next_state  = EP11_BUF1_INIT_W;
                       end

    EP11_BUF1_INIT_W:  begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP11_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP12_BUF0_INIT;
                         end
                       end

    EP12_BUF0_INIT:    begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP12_BUF0;
                         ctrl_dout_r = `EP12_BUF0_INIT_VALUE;
                         next_state  = EP12_BUF0_INIT_W;
                       end

    EP12_BUF0_INIT_W:  begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP12_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP12_BUF1_INIT;
                         end
                       end

    EP12_BUF1_INIT:    begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP12_BUF1;
                         ctrl_dout_r = `EP12_BUF1_INIT_VALUE;
                         next_state  = EP12_BUF1_INIT_W;
                       end

    EP12_BUF1_INIT_W:  begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP12_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP13_BUF0_INIT;
                         end
                       end

    EP13_BUF0_INIT:    begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP13_BUF0;
                         ctrl_dout_r = `EP13_BUF0_INIT_VALUE;
                         next_state  = EP13_BUF0_INIT_W;
                       end

    EP13_BUF0_INIT_W:  begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP13_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP13_BUF1_INIT;
                         end
                       end

    EP13_BUF1_INIT:    begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP13_BUF1;
                         ctrl_dout_r = `EP13_BUF1_INIT_VALUE;
                         next_state  = EP13_BUF1_INIT_W;
                       end

    EP13_BUF1_INIT_W:  begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP13_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP14_BUF0_INIT;
                         end
                       end

    EP14_BUF0_INIT:    begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP14_BUF0;
                         ctrl_dout_r = `EP14_BUF0_INIT_VALUE;
                         next_state  = EP14_BUF0_INIT_W;
                       end

    EP14_BUF0_INIT_W:  begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP14_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP14_BUF1_INIT;
                         end
                       end

    EP14_BUF1_INIT:    begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP14_BUF1;
                         ctrl_dout_r = `EP14_BUF1_INIT_VALUE;
                         next_state  = EP14_BUF1_INIT_W;
                       end

    EP14_BUF1_INIT_W:  begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP14_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP15_BUF0_INIT;
                         end
                       end

    EP15_BUF0_INIT:    begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP15_BUF0;
                         ctrl_dout_r = `EP15_BUF0_INIT_VALUE;
                         next_state  = EP15_BUF0_INIT_W;
                       end

    EP15_BUF0_INIT_W:  begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP15_BUF0_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = EP15_BUF1_INIT;
                         end
                       end

    EP15_BUF1_INIT:    begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r  = `EP15_BUF1;
                         ctrl_dout_r = `EP15_BUF1_INIT_VALUE;
                         next_state  = EP15_BUF1_INIT_W;
                       end

    EP15_BUF1_INIT_W:  begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = EP15_BUF1_INIT_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = IDLE;
                         end
                       end

    //33
    IDLE:              begin
                         if(ctrl_setup)begin 
                           next_state   = GET_HDR;
                           ctrl_mode_en = 1'b0; 
                         end
                         else if(set_address|set_feature|clear_feature|set_descriptor|set_config|set_interface)begin
                           next_state   = STATUS_OUTIN_OUT;
                           ctrl_mode_en = 1'b0;
                         end                                                  
                         else if(get_status|get_config|get_interface|synch_frame|get_descriptor)begin
                           next_state   = STATUS_INOUT_IN;
                           ctrl_mode_en = 1'b1;
                         end
                         else begin
                           next_state   = IDLE;
                           ctrl_mode_en = 1'b0;                          
                         end                                      
                       end

    //34
    GET_HDR:           begin
                         get_hdr = 1'b1;
                         if(hdr_done)
                           next_state = IDLE;
                         else
                           next_state = GET_HDR;
                       end

    //38
    SET_ADDRESS_S:     begin
                         ctrl_wr_en_en_r = 1'b1;
                         ctrl_adr_r      = `FA;
                         ctrl_dout_r     = {16'h0, wValue};
                         next_state      = SET_ADDRESS_S_W;
                       end

    //115
    SET_ADDRESS_S_W:   begin
                         ctrl_wr_en_en_r = 1'b0;
                         if(!ctrl_ack_o)begin
                           ctrl_adr_r  = ctrl_adr_r;
                           ctrl_dout_r = ctrl_dout_r;
                           next_state  = SET_ADDRESS_S_W;
                         end
                         else begin
                           ctrl_adr_r  = 18'h0;
                           ctrl_dout_r = 32'h0;
                           next_state  = IDLE;
                         end
                       end


    STATUS_OUTIN_OUT:  begin
                         if(ctrl_out)
                           next_state = STATUS_OUTIN_IN;
                         else
                           next_state = STATUS_OUTIN_OUT;
                       end

    STATUS_OUTIN_IN:   begin
                         if(ctrl_in)begin
                         	 case(bRequest)
                         	 
                         	   SET_ADDRESS:    begin                         	   	                            
                         	   	                 we_ctrl_en_r = 1'b0;
                         	   	                 next_state   = SET_ADDRESS_S;
                         	   	               end                   
                         	                               
                         	   SET_FEATURE:    begin
                         	   	                 if((bm_req_recp==DEVICE   && (wValue[7:0]==8'h01 || wValue[7:0]==8'h02)) ||
                         	   	                    (bm_req_recp==ENDPOINT &&  wValue[7:0]==8'h00))
                         	   	                   we_ctrl_en_r = 1'b1; 
                         	   	                 else                         	   	                            
                         	   	                   we_ctrl_en_r = 1'b0;
                         	   	                 next_state   = IDLE;
                         	   	               end
                         	   
                         	   CLEAR_FEATURE:  begin
                         	   	                 if((bm_req_recp==DEVICE   && (wValue[7:0]==8'h01 || wValue[7:0]==8'h02)) ||
                         	   	                    (bm_req_recp==ENDPOINT &&  wValue[7:0]==8'h00))
                         	   	                   we_ctrl_en_r = 1'b1; 
                         	   	                 else                         	   	                            
                         	   	                   we_ctrl_en_r = 1'b0;
                         	   	                 next_state   = IDLE;
                         	   	               end
                         	   
                         	   SET_DESCRIPTOR: begin
                         	   	               	 we_ctrl_en_r = 1'b0;         
                         	   	                 next_state   = IDLE;
                         	   	               end
                         	   	                             
                         	   SET_INTERFACE:  begin
                         	   	               	 we_ctrl_en_r = 1'b1;         
                         	   	                 next_state   = IDLE;
                         	   	               end

                         	   SET_CONFIG:     begin
                         	   	               	 we_ctrl_en_r = 1'b1;         
                         	   	                 next_state   = IDLE;
                         	   	               end
                         	   	               
                         	   default:        begin
                         	   	               	 we_ctrl_en_r = 1'b0;         
                         	   	                 next_state   = IDLE;                         	   	
                         	   	               end                           	   	                                        	 
                         	 
                           endcase
                         end
                         else begin
                         	 we_ctrl_en_r = 1'b0;
                           next_state   = STATUS_OUTIN_IN;
                         end
                       end

    STATUS_INOUT_IN:   begin
                         if(ctrl_in)
                           next_state = STATUS_INOUT_OUT;
                         else
                           next_state = STATUS_INOUT_IN;
                       end

    STATUS_INOUT_OUT:  begin
    	                   
                         if(ctrl_out)begin
                         	next_state = IDLE;
                         end                          
                         else begin
                           next_state = STATUS_INOUT_OUT;
                         end
                       end

     default:          begin
                         we_ctrl_en_r = 1'b0;
                         next_state   = IDLE;     	
     	                 end

  endcase
end

endmodule

