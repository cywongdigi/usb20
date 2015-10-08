// CY Wong
// 06 AUG 2015
// USB2.0 Project
// Test Bench

`include "timescale.v"
`include "usbf_defines.v"

module USBF_TOP_TB();

reg  rstp_i;
wire rstn_i;
reg  clk_60mhz_i;

initial begin
  clk_60mhz_i = 1'b0;
end

// 60MHZ
always
//    #16.677 clk_60mhz_i = !clk_60mhz_i;
    #5 clk_60mhz_i = !clk_60mhz_i; // 100mhz

assign rstn_i = !rstp_i;


wire [7:0]  wb_adr_host;
wire [31:0] wb_din_host;
wire [31:0] wb_dout_host;
wire        wb_cyc_host;
wire        wb_stb_host;
wire        wb_we_host;
wire        wb_ack_host;


wire                       intr_o;
wire                       usb_rst_o;
wire [17:0]                wb_adr_core;
wire [31:0]                wb_din_core;
wire [31:0]                wb_dout_core;
wire                       wb_cyc_core;
wire                       wb_stb_core;
wire                       wb_we_core;
wire                       wb_ack_core;
wire 	                   inta_o;
wire 	                   intb_o;
wire [15:0]	               dma_req_o;
wire 	                   susp_o;
wire 	                   phy_rst_pad_o;
wire [7:0]	           utmi_data_o;
wire 	                   utmi_txvalid_o;
wire 	                   utmi_txready_i;
wire [7:0]	           utmi_data_i;
wire 	                   utmi_rxvalid_i;
wire 	                   utmi_rxactive_i;
wire 	                   utmi_rxerror_i;
wire [1:0]                 utmi_linestate_i;
wire 	                   XcvSelect_pad_o;
wire 	                   TermSel_pad_o;
wire 	                   SuspendM_pad_o;
wire [1:0]                 OpMode_pad_o;
wire 	                   VControl_Load_pad_o;
wire [3:0]	           VControl_pad_o;



wire [14:0]                sram_adr_o;
wire [31:0]                sram_data_i;
wire [31:0]                sram_data_o;
wire                       sram_re_o;
wire                       sram_we_o;



wire [14:0]                rom_adr_o;
wire [31:0]                rom_data_i;
wire [31:0]                rom_data_o;
wire                       rom_re_o;
wire                       rom_we_o;


wb_master_model #(32,8) WB_MASTER_MODEL_HOST_U
(
  .clk_i(clk_60mhz_i),
  .rst_i(rstp_i),
  .adr_o(wb_adr_host),
  .din_i(wb_din_host),
  .dout_o(wb_dout_host),
  .cyc_o(wb_cyc_host),
  .stb_o(wb_stb_host),
  .we_o(wb_we_host),
  .ack_i(wb_ack_host),
  .sel_o()
);


usbh USBH_U
(
  .clk_i(clk_60mhz_i),
  .rst_i(rstp_i),
  .intr_o(intr_o),
  .addr_i(wb_adr_host),
  .data_i(wb_dout_host),
  .data_o(wb_din_host),
  .we_i(wb_we_host),
  .stb_i(wb_stb_host),

  .utmi_data_o(utmi_data_o),
  .utmi_txvalid_o(utmi_txvalid_o),
  .utmi_txready_i(1'b1),
  .utmi_data_i(utmi_data_i),
  .utmi_rxvalid_i(utmi_rxvalid_i),
  .utmi_rxactive_i(utmi_rxvalid_i),
  .utmi_rxerror_i(1'b0),
  .utmi_linestate_i(2'b01),
  .usb_rst_o(usb_rst_o)
);


usbf_top USBF_TOP_U
(
  .clk_i(clk_60mhz_i),
  .rst_i(rstn_i),
  .inta_o(inta_o),
  .intb_o(intb_o),
  .dma_req_o(dma_req_o),
  .dma_ack_i(16'b0),
  .susp_o(susp_o),
  .resume_req_i(1'b0),

  // UTMI Interface
  .phy_clk_pad_i(clk_60mhz_i),
  .phy_rst_pad_o(phy_rst_pad_o),

  .DataOut_pad_o(utmi_data_i),
  .TxValid_pad_o(utmi_rxvalid_i),
  .TxReady_pad_i(1'b1),

  .DataIn_pad_i(utmi_data_o),
  .RxValid_pad_i(utmi_txvalid_o),
  .RxActive_pad_i(utmi_txvalid_o),
  .RxError_pad_i(1'b0),
  .LineState_pad_i(2'b01),

  .XcvSelect_pad_o(XcvSelect_pad_o),
  .TermSel_pad_o(TermSel_pad_o),
  .SuspendM_pad_o(SuspendM_pad_o),
  .OpMode_pad_o(OpMode_pad_o),
  .usb_vbus_pad_i(1'b1),
  .VControl_Load_pad_o(VControl_Load_pad_o),
  .VControl_pad_o(VControl_pad_o),
  .VStatus_pad_i(8'b0),

  .sram_adr_o(sram_adr_o),
  .sram_data_i(sram_data_i),
  .sram_data_o(sram_data_o),
  .sram_re_o(sram_re_o),
  .sram_we_o(sram_we_o)
);


usbf_ssram #(.USBF_SSRAM_HADR(14)) USBF_SSRAM_U
(
  .clk_i(clk_60mhz_i),
  .address_i(sram_adr_o),
  .data_i(sram_data_o),
  .data_o(sram_data_i),
  .re_i(sram_re_o),
  .we_i(sram_we_o)
);


parameter EP0_CSR  = 18'h40;
parameter EP0_BUF0 = 18'h48;
parameter EP0_BUF1 = 18'h4C;
parameter EP1_CSR  = 18'h50;
parameter EP1_BUF0 = 18'h58;
parameter EP1_BUF1 = 18'h5C;
parameter EP2_CSR  = 18'h60;
parameter EP2_BUF0=18'h68;
parameter EP2_BUF1=18'h6C;
parameter EP3_CSR=18'h70;
parameter EP3_BUF0=18'h78;
parameter EP3_BUF1=18'h7C;
parameter EP4_CSR=18'h80;
parameter EP4_BUF0=18'h88;
parameter EP4_BUF1=18'h8C;
parameter EP5_CSR=18'h90;
parameter EP5_BUF0=18'h98;
parameter EP5_BUF1=18'h9C;
parameter EP6_CSR=18'hA0;
parameter EP6_BUF0=18'hA8;
parameter EP6_BUF1=18'hAC;
parameter EP7_CSR=18'hB0;
parameter EP7_BUF0=18'hB8;
parameter EP7_BUF1=18'hBC;
parameter EP8_CSR=18'hC0;
parameter EP8_BUF0=18'hC8;
parameter EP8_BUF1=18'hCC;
parameter EP9_CSR=18'hD0;
parameter EP9_BUF0=18'hD8;
parameter EP9_BUF1=18'hDC;
parameter EP10_CSR=18'hE0;
parameter EP10_BUF0=18'hE8;
parameter EP10_BUF1=18'hEC;
parameter EP11_CSR=18'hF0;
parameter EP11_BUF0=18'hF8;
parameter EP11_BUF1=18'hFC;
parameter EP12_CSR=18'h100;
parameter EP12_BUF0=18'h108;
parameter EP12_BUF1=18'h10C;
parameter EP13_CSR=18'h110;
parameter EP13_BUF0=18'h118;
parameter EP13_BUF1=18'h11C;
parameter EP14_CSR=18'h120;
parameter EP14_BUF0=18'h128;
parameter EP14_BUF1=18'h12C;
parameter EP15_CSR=18'h130;
parameter EP15_BUF0=18'h138;
parameter EP15_BUF1=18'h13C;


parameter CSR=18'h0;        //RW
parameter FA=18'h4;         //RW
parameter INT_MSK=18'h8;    //RW
parameter INT_SRC=18'hc;    //ROC
parameter FRM_NAT=18'h10;   //RO
parameter UTMI_VEND=18'h14; //RW

reg [31:0] wb_master_model_core_dout;

parameter PID_OUT   = 8'hE1;
parameter PID_IN    = 8'h69;
parameter PID_SOF   = 8'hA5;
parameter PID_SETUP = 8'h2D;
parameter PID_DATA0 = 8'hC3;
parameter PID_DATA1 = 8'h4B;
parameter PID_ACK   = 8'hD2; // Successful
parameter PID_NAK   = 8'h5A;
parameter PID_STALL = 8'h1E;


parameter USB_CTRL       = 8'h00;
parameter USB_IRQ_ACK    = 8'h04;
parameter USB_IRQ_MASK   = 8'h08;
parameter USB_XFER_DATA  = 8'h0c;
parameter USB_XFER_TOKEN = 8'h10;
parameter USB_WR_DATA    = 8'h18;
parameter USB_RD_DATA    = 8'h18;

parameter DATA0 = 1'b0;
parameter DATA1 = 1'b1;


reg [13:0] EPBUF_SIZE;
reg [16:0] EPBUF_PTR;

parameter EP0=4'h0;
parameter EP1=4'h1;
parameter EP2=4'h2;
parameter EP3=4'h3;
parameter EP4=4'h4;
parameter EP5=4'h5;
parameter EP6=4'h6;
parameter EP7=4'h7;
parameter EP8=4'h8;
parameter EP9=4'h9;
parameter EP10=4'hA;
parameter EP11=4'hB;
parameter EP12=4'hC;
parameter EP13=4'hD;
parameter EP14=4'hE;
parameter EP15=4'hF;

// Endpoint CSR Parameter
parameter BUF0=2'b00;
parameter BUF1=2'b01;

parameter CTRL=2'b00;
parameter IN=2'b01;
parameter OUT=2'b10;

parameter INT=2'b00;
parameter ISO=2'b01;
parameter BULK=2'b10;


// Low Speed
// Full Speed
// High Speed



reg [1:0]  UC_BSEL;
reg [1:0]  EP_TYPE;
reg [1:0]  TR_TYPE;
reg [10:0] MAX_PL_SZ;





// SFS - Standard Feature Selector
parameter SFS_DEVICE_REMOTE_WAKEUP = 8'h01;
parameter SFS_ENDPOINT_HALT = 8'h00;
parameter SFS_TEST_MODE = 8'h02;





// Descriptor Types
parameter DT_DEV=8'h01;
parameter DT_CONFIG=8'h02;
parameter DT_STRING=8'h03;
parameter DT_INTERFACE=8'h04;
parameter DT_EP=8'h05;
parameter DT_DEV_QUALIFIER=8'h06;
parameter DT_SPEED_CONFIG=8'h07;
parameter DT_INTERFACE_POWER=8'h08;
parameter DT_OTG=8'h09;



wire        ctrl_wr_en;
wire        ctrl_rd_en;
wire [31:0] ctrl_adr_i;
wire [31:0] ctrl_din_o;
wire [31:0] ctrl_dout_i;

reg [7:0] FUNCT_ADR;
reg [7:0] NEW_FUNCT_ADR;

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


//parameter GET_STATUS     = 8'h00;
//parameter CLEAR_FEATURE  = 8'h01;
//parameter SET_FEATURE    = 8'h03;
//parameter SET_ADDRESS    = 8'h05;
//parameter GET_DESCRIPTOR = 8'h06;
//parameter SET_DESCRIPTOR = 8'h07;
//parameter GET_CONFIG     = 8'h08;
//parameter SET_CONFIG     = 8'h09;
//parameter GET_INTERFACE  = 8'h0a;
//parameter SET_INTERFACE  = 8'h0b;
//parameter SYNCH_FRAME    = 8'h0c;

parameter transfer_delay = 2000;

reg [7:0] k,p,y,z;

integer i;
integer j;
integer m;
integer n;
integer x;

reg [7:0] utmi_data_i_reg [0:1200];   
reg [7:0] utmi_data_o_reg [0:1200];


// CTRL TRANSFER Descriptor
reg [7:0] device_descriptor [0:17];
reg [7:0] configuration_descriptor [0:8];
reg [7:0] devicequalifier_descriptor [0:9];
reg [7:0] otherspeedconfiguration_descriptor [0:8];
reg [7:0] interface0_descriptor [0:8];
reg [7:0] interface1_descriptor [0:8]; 
reg [7:0] interface2_descriptor [0:8]; 
reg [7:0] interface3_descriptor [0:8]; 
reg [7:0] interface4_descriptor [0:8]; 
reg [7:0] interface5_descriptor [0:8]; 
reg [7:0] interface6_descriptor [0:8]; 
reg [7:0] interface7_descriptor [0:8];
reg [7:0] endpoint1_descriptor [0:6];
reg [7:0] endpoint2_descriptor [0:6];
reg [7:0] endpoint3_descriptor [0:6];
reg [7:0] endpoint4_descriptor [0:6];
reg [7:0] endpoint5_descriptor [0:6];
reg [7:0] endpoint6_descriptor [0:6];
reg [7:0] endpoint7_descriptor [0:6];
reg [7:0] endpoint8_descriptor [0:6];
reg [7:0] endpoint9_descriptor [0:6];
reg [7:0] endpoint10_descriptor [0:6];
reg [7:0] endpoint11_descriptor [0:6];
reg [7:0] endpoint12_descriptor [0:6];
reg [7:0] endpoint13_descriptor [0:6];
reg [7:0] endpoint14_descriptor [0:6];
reg [7:0] endpoint15_descriptor [0:6];

reg [7:0] total_interface_number;
reg [7:0] endpoint_number[0:7];

wire        ep_transfer_direction [0:15];
wire [ 1:0] ep_transfer_type [0:15];
wire [15:0] wMaxPacketSize [0:15];

assign ep_transfer_type[ 1]=endpoint1_descriptor[3][1:0];
assign ep_transfer_type[ 2]=endpoint2_descriptor[3][1:0];
assign ep_transfer_type[ 3]=endpoint3_descriptor[3][1:0];
assign ep_transfer_type[ 4]=endpoint4_descriptor[3][1:0];
assign ep_transfer_type[ 5]=endpoint5_descriptor[3][1:0];
assign ep_transfer_type[ 6]=endpoint6_descriptor[3][1:0];
assign ep_transfer_type[ 7]=endpoint7_descriptor[3][1:0];
assign ep_transfer_type[ 8]=endpoint8_descriptor[3][1:0];
assign ep_transfer_type[ 9]=endpoint9_descriptor[3][1:0];
assign ep_transfer_type[10]=endpoint10_descriptor[3][1:0];
assign ep_transfer_type[11]=endpoint11_descriptor[3][1:0];
assign ep_transfer_type[12]=endpoint12_descriptor[3][1:0];
assign ep_transfer_type[13]=endpoint13_descriptor[3][1:0];
assign ep_transfer_type[14]=endpoint14_descriptor[3][1:0];
assign ep_transfer_type[15]=endpoint15_descriptor[3][1:0];

assign ep_transfer_direction[ 1]=endpoint1_descriptor[2][7];
assign ep_transfer_direction[ 2]=endpoint2_descriptor[2][7];
assign ep_transfer_direction[ 3]=endpoint3_descriptor[2][7];
assign ep_transfer_direction[ 4]=endpoint4_descriptor[2][7];
assign ep_transfer_direction[ 5]=endpoint5_descriptor[2][7];
assign ep_transfer_direction[ 6]=endpoint6_descriptor[2][7];
assign ep_transfer_direction[ 7]=endpoint7_descriptor[2][7];
assign ep_transfer_direction[ 8]=endpoint8_descriptor[2][7];
assign ep_transfer_direction[ 9]=endpoint9_descriptor[2][7];
assign ep_transfer_direction[10]=endpoint10_descriptor[2][7];
assign ep_transfer_direction[11]=endpoint11_descriptor[2][7];
assign ep_transfer_direction[12]=endpoint12_descriptor[2][7];
assign ep_transfer_direction[13]=endpoint13_descriptor[2][7];
assign ep_transfer_direction[14]=endpoint14_descriptor[2][7];
assign ep_transfer_direction[15]=endpoint15_descriptor[2][7];

assign wMaxPacketSize[ 1] = {endpoint1_descriptor[5],  endpoint1_descriptor[4]};
assign wMaxPacketSize[ 2] = {endpoint2_descriptor[5],  endpoint2_descriptor[4]};
assign wMaxPacketSize[ 3] = {endpoint3_descriptor[5],  endpoint3_descriptor[4]};
assign wMaxPacketSize[ 4] = {endpoint4_descriptor[5],  endpoint4_descriptor[4]};
assign wMaxPacketSize[ 5] = {endpoint5_descriptor[5],  endpoint5_descriptor[4]};
assign wMaxPacketSize[ 6] = {endpoint6_descriptor[5],  endpoint6_descriptor[4]};
assign wMaxPacketSize[ 7] = {endpoint7_descriptor[5],  endpoint7_descriptor[4]};
assign wMaxPacketSize[ 8] = {endpoint8_descriptor[5],  endpoint8_descriptor[4]};
assign wMaxPacketSize[ 9] = {endpoint9_descriptor[5],  endpoint9_descriptor[4]};
assign wMaxPacketSize[10] = {endpoint10_descriptor[5], endpoint10_descriptor[4]};
assign wMaxPacketSize[11] = {endpoint11_descriptor[5], endpoint11_descriptor[4]};
assign wMaxPacketSize[12] = {endpoint12_descriptor[5], endpoint12_descriptor[4]};
assign wMaxPacketSize[13] = {endpoint13_descriptor[5], endpoint13_descriptor[4]};
assign wMaxPacketSize[14] = {endpoint14_descriptor[5], endpoint14_descriptor[4]};
assign wMaxPacketSize[15] = {endpoint15_descriptor[5], endpoint15_descriptor[4]};











   
//`define STDOUT_DISPLAY

// Main
initial begin

  rstp_i = 1'b1;
  #300;
  rstp_i = 1'b0;

  USBHOST_INIT;

  #4000;

  // Range 1-127
  FUNCT_ADR = 8'd0;
  NEW_FUNCT_ADR=$urandom_range(1,127);
  
  // SET_ADDRESS
  CTRL_SET_ADDRESS(FUNCT_ADR, NEW_FUNCT_ADR);
  FUNCT_ADR=NEW_FUNCT_ADR;
  
  CTRL_TRANSFER_TEST;
  
  // SET_ADDRESS
  NEW_FUNCT_ADR=$urandom_range(1,127);
  CTRL_SET_ADDRESS(FUNCT_ADR, NEW_FUNCT_ADR);
  FUNCT_ADR=NEW_FUNCT_ADR;  
  
  GET_ALL_DESCRIPTOR;
  
  // Endpoint Transfer Test
  // EP1-EP14  
    
  k=8'd1;
  
  while(k<8'd15)begin
  	FIFO_RAND(wMaxPacketSize[k]);
  	if(ep_transfer_direction[k])begin
  	  case(ep_transfer_type[k])
  	    BULK:    begin 
  	    	         BULK_IN_TRANSFER(wMaxPacketSize[k], k);
  	    	         TRANSFER_COMPARE_DATA(wMaxPacketSize[k]);
  	             end
  	                   
  	    ISO:     begin 
  	    	         ISO_IN_TRANSFER(wMaxPacketSize[k], k);
  	    	         TRANSFER_COMPARE_DATA(wMaxPacketSize[k]);
  	    	       end
  	    
  	    INT:     begin 
  	    	        INT_IN_TRANSFER(wMaxPacketSize[k], k);
  	    	        TRANSFER_COMPARE_DATA(wMaxPacketSize[k]);
  	    	       end
  	    
  	    default: ;
      endcase
    end
    else begin
  	  case(ep_transfer_type[k])
  	    BULK:    BULK_OUT_TRANSFER(wMaxPacketSize[k], k);
  	    ISO:     ISO_OUT_TRANSFER(wMaxPacketSize[k], k);
  	    INT:     INT_OUT_TRANSFER(wMaxPacketSize[k], k);
  	    default:                                       ;
      endcase          	
    end
    k=k+8'd1;
  end
  
  
  $finish;


end


reg [15:0] a;
reg [31:0] fifo_rd_o;


task TRANSFER_COMPARE_DATA;
input [15:0] wMaxPacketSize;
begin
	
  $display("\n");
  $display("TRANSFER COMPARE DATA");
  $display("=====================");
  $display("wMaxPacketSize: %0d", wMaxPacketSize);	
	
	a=16'd0;

	while(a<wMaxPacketSize)begin
		FIFO_RD(fifo_rd_o);
		if(fifo_rd_o[7:0] != utmi_data_i_reg[16'd1+a])begin 
		  $display("ERROR: DATA_IN[%0d]: %2h NOT EQUAL DATA_OUT[%0d]: %2h", a, fifo_rd_o[7:0], a, utmi_data_i_reg[16'd1+a]);
	    $finish;
	  end
		else begin
		  $display("DATA_IN[%0d]: %2h == DATA_OUT[%0d]: %2h", a, fifo_rd_o[7:0], a, utmi_data_i_reg[16'd1+a]);			
		end
		a=a+16'd1;
	end
	
	$display("\n\n********TRANSFER COMPARE DATA SUCCESS********\n\n"); 
	
	#(transfer_delay);
	
end
endtask


task BULK_IN_TRANSFER;
input [15:0] wMaxPacketSize;
input [ 7:0] endpoint_no;
begin
	
   $display("\n");
   $display("BULK IN TRANSFER");
   $display("================");
   $display("Endpoint Number: %0d, wMaxPacketSize: %0d", endpoint_no[3:0],wMaxPacketSize);

   //SETUP STAGE
   m=0;
   HOST_XFER_SIZE({16'h0, wMaxPacketSize});
   USB_FUNC(1'b1, 1'b1, 1'b1, DATA0, PID_IN, FUNCT_ADR, endpoint_no[3:0]);

   WAIT_ACK_OUT;
      
   #(transfer_delay);

end
endtask


task BULK_OUT_TRANSFER;
input [15:0] wMaxPacketSize;
input [ 7:0] endpoint_no;
begin
	
   $display("\n");
   $display("BULK OUT TRANSFER");
   $display("=================");
   $display("Endpoint Number: %0d, wMaxPacketSize: %0d", endpoint_no[3:0],wMaxPacketSize);

   //SETUP STAGE
   HOST_XFER_SIZE({16'h0, wMaxPacketSize});
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_OUT, FUNCT_ADR, endpoint_no[3:0]);

   WAIT_ACK_IN;
      
   #(transfer_delay);	

end
endtask


task ISO_IN_TRANSFER;
input [15:0] wMaxPacketSize;
input [ 7:0] endpoint_no;
begin
	
   $display("\n");
   $display("ISO IN TRANSFER");
   $display("===============");
   $display("Endpoint Number: %0d, wMaxPacketSize: %0d", endpoint_no[3:0],wMaxPacketSize);

   //SETUP STAGE
   m=0;
   HOST_XFER_SIZE({16'h0, wMaxPacketSize});
   USB_FUNC(1'b1, 1'b1, 1'b0, DATA1, PID_IN, FUNCT_ADR, endpoint_no[3:0]);
      
   #(transfer_delay);

end
endtask


task ISO_OUT_TRANSFER;
input [15:0] wMaxPacketSize;
input [ 7:0] endpoint_no;
begin
	
   $display("\n");
   $display("ISO OUT TRANSFER");
   $display("================");
   $display("Endpoint Number: %0d, wMaxPacketSize: %0d", endpoint_no[3:0],wMaxPacketSize);

   //SETUP STAGE
   HOST_XFER_SIZE({16'h0, wMaxPacketSize});
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_OUT, FUNCT_ADR, endpoint_no[3:0]);
      
   #(transfer_delay);	

end
endtask


task INT_IN_TRANSFER;
input [15:0] wMaxPacketSize;
input [ 7:0] endpoint_no;
begin
	
   $display("\n");
   $display("INT IN TRANSFER");
   $display("===============");
   $display("Endpoint Number: %0d, wMaxPacketSize: %0d", endpoint_no[3:0],wMaxPacketSize);

   //SETUP STAGE
   m=0;
   HOST_XFER_SIZE({16'h0, wMaxPacketSize});
   USB_FUNC(1'b1, 1'b1, 1'b1, DATA1, PID_IN, FUNCT_ADR, endpoint_no[3:0]);

   WAIT_ACK_OUT;
      
   #(transfer_delay);

end
endtask


task INT_OUT_TRANSFER;
input [15:0] wMaxPacketSize;
input [ 7:0] endpoint_no;
begin
	
   $display("\n");
   $display("INT OUT TRANSFER");
   $display("================");
   $display("Endpoint Number: %0d, wMaxPacketSize: %0d", endpoint_no[3:0],wMaxPacketSize);

   //SETUP STAGE
   HOST_XFER_SIZE({16'h0, wMaxPacketSize});
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_OUT, FUNCT_ADR, endpoint_no[3:0]);

   WAIT_ACK_IN;
      
   #(transfer_delay);	

end
endtask


// Standard Device Requests
// Standard Interface Requests
// Standard Endpoint Requests


//parameter GET_STATUS     = 8'h00;
//parameter CLEAR_FEATURE  = 8'h01;
//parameter SET_FEATURE    = 8'h03;
//parameter SET_ADDRESS    = 8'h05;
//parameter GET_DESCRIPTOR = 8'h06;
//parameter SET_DESCRIPTOR = 8'h07;
//parameter GET_CONFIG     = 8'h08;
//parameter SET_CONFIG     = 8'h09;
//parameter GET_INTERFACE  = 8'h0a;
//parameter SET_INTERFACE  = 8'h0b;
//parameter SYNCH_FRAME    = 8'h0c;


reg [8:0] test_r;

reg [7:0] test0_o;
reg [7:0] test1_o;
reg [7:0] test2_o;
reg [7:0] test3_o;
reg [7:0] test4_o;
reg [7:0] test5_o;
reg [7:0] test6_o;
reg [7:0] test7_o;
reg [7:0] test8_o;
reg [7:0] test9_o;
reg [7:0] test10_o;
reg [7:0] test11_o;
reg [7:0] test12_o;
reg [7:0] test13_o;
reg [7:0] test14_o;
reg [7:0] test15_o;
reg [7:0] test16_o;
reg [7:0] test17_o;


reg [7:0] test0_tmp;
reg [7:0] test1_tmp;
reg [7:0] test2_tmp;
reg [7:0] test3_tmp;
reg [7:0] test4_tmp;
reg [7:0] test5_tmp;
reg [7:0] test6_tmp;
reg [7:0] test7_tmp;
reg [7:0] test8_tmp;
reg [7:0] test9_tmp;
reg [7:0] test10_tmp;
reg [7:0] test11_tmp;
reg [7:0] test12_tmp;
reg [7:0] test13_tmp;
reg [7:0] test14_tmp;
reg [7:0] test15_tmp;
reg [7:0] test16_tmp;
reg [7:0] test17_tmp;

reg [7:0] test_tmp [0:17];

task GET_ALL_DESCRIPTOR;
begin

  CTRL_GET_DESCRIPTOR(DEVICE_DES, 8'h0, 8'd18, 
    test_tmp[ 0],  test_tmp[ 1], test_tmp[ 2], test_tmp[ 3],
    test_tmp[ 4],  test_tmp[ 5], test_tmp[ 6], test_tmp[ 7],
    test_tmp[ 8],  test_tmp[ 9], test_tmp[10], test_tmp[11],
    test_tmp[12],  test_tmp[13], test_tmp[14], test_tmp[15], 
    test_tmp[16],  test_tmp[17]
  );
  
  x=0;
  while(x<18)begin
  	device_descriptor[x] =test_tmp[x];
  	x=x+1;
  end                       
  	
  CTRL_GET_DESCRIPTOR(CONFIGURATION_DES, 8'h0, 8'd9, 
    test_tmp[ 0],  test_tmp[ 1], test_tmp[ 2], test_tmp[ 3],
    test_tmp[ 4],  test_tmp[ 5], test_tmp[ 6], test_tmp[ 7],
    test_tmp[ 8],  test_tmp[ 9], test_tmp[10], test_tmp[11],
    test_tmp[12],  test_tmp[13], test_tmp[14], test_tmp[15], 
    test_tmp[16],  test_tmp[17]
  );
  
  x=0;
  while(x<9)begin
  	configuration_descriptor[x] =test_tmp[x];
  	x=x+1;
  end
  total_interface_number=configuration_descriptor[4];
  $display("\ntotal_interface_number = %0d", total_interface_number);   

  CTRL_GET_DESCRIPTOR(DEVICE_QUALIFIER_DES, 8'h0, 8'd10, 
    test_tmp[ 0],  test_tmp[ 1], test_tmp[ 2], test_tmp[ 3],
    test_tmp[ 4],  test_tmp[ 5], test_tmp[ 6], test_tmp[ 7],
    test_tmp[ 8],  test_tmp[ 9], test_tmp[10], test_tmp[11],
    test_tmp[12],  test_tmp[13], test_tmp[14], test_tmp[15], 
    test_tmp[16],  test_tmp[17]
  );
  
  x=0;
  while(x<10)begin
  	devicequalifier_descriptor[x] =test_tmp[x];
  	x=x+1;
  end
  
  CTRL_GET_DESCRIPTOR(OTHER_SPEED_CONFIGURATION_DES, 8'h0, 8'd9, 
    test_tmp[ 0],  test_tmp[ 1], test_tmp[ 2], test_tmp[ 3],
    test_tmp[ 4],  test_tmp[ 5], test_tmp[ 6], test_tmp[ 7],
    test_tmp[ 8],  test_tmp[ 9], test_tmp[10], test_tmp[11],
    test_tmp[12],  test_tmp[13], test_tmp[14], test_tmp[15], 
    test_tmp[16],  test_tmp[17]
  );
  
  x=0;
  while(x<9)begin
  	otherspeedconfiguration_descriptor[x] =test_tmp[x];
  	x=x+1;
  end
    
  k=8'd0;
  
  while(k<total_interface_number)begin
    CTRL_GET_DESCRIPTOR(INTERFACE_DES, k, 8'd9, 
      test_tmp[ 0],  test_tmp[ 1], test_tmp[ 2], test_tmp[ 3],
      test_tmp[ 4],  test_tmp[ 5], test_tmp[ 6], test_tmp[ 7],
      test_tmp[ 8],  test_tmp[ 9], test_tmp[10], test_tmp[11],
      test_tmp[12],  test_tmp[13], test_tmp[14], test_tmp[15], 
      test_tmp[16],  test_tmp[17]
    );

    x=0;
    while(x<9)begin
      case(k)
        8'd0:    interface0_descriptor[k]= test_tmp[x];
        8'd1:    interface1_descriptor[k]= test_tmp[x]; 
        8'd2:    interface2_descriptor[k]= test_tmp[x];
        8'd3:    interface3_descriptor[k]= test_tmp[x];
        8'd4:    interface4_descriptor[k]= test_tmp[x];
        8'd5:    interface5_descriptor[k]= test_tmp[x];
        8'd6:    interface6_descriptor[k]= test_tmp[x];
        8'd7:    interface7_descriptor[k]= test_tmp[x];
        default:                                      ;
      endcase
      x=x+1;
    end

    case(k)
      8'd0:    endpoint_number[k]= test_tmp[4];
      8'd1:    endpoint_number[k]= test_tmp[4]; 
      8'd2:    endpoint_number[k]= test_tmp[4];
      8'd3:    endpoint_number[k]= test_tmp[4];
      8'd4:    endpoint_number[k]= test_tmp[4];
      8'd5:    endpoint_number[k]= test_tmp[4];
      8'd6:    endpoint_number[k]= test_tmp[4];
      8'd7:    endpoint_number[k]= test_tmp[4];
      default:                                ;
    endcase
    
    $display("\nendpoint_number[%0d] = %0d", k, test_tmp[4]);    	

    k=k+8'd1;
  end

  k=8'd0;
  y=8'd1;
  
  while(k<total_interface_number)begin
  	z=8'd0;
  	while(z<endpoint_number[k])begin
  	  CTRL_GET_DESCRIPTOR(ENDPOINT_DES, y, 8'd7, 
        test_tmp[ 0],  test_tmp[ 1], test_tmp[ 2], test_tmp[ 3],
        test_tmp[ 4],  test_tmp[ 5], test_tmp[ 6], test_tmp[ 7],
        test_tmp[ 8],  test_tmp[ 9], test_tmp[10], test_tmp[11],
        test_tmp[12],  test_tmp[13], test_tmp[14], test_tmp[15], 
        test_tmp[16],  test_tmp[17]
      );
      
      x=0;
      while(x<7)begin
        case(y)                      
          8'd1:  endpoint1_descriptor[x]  = test_tmp[x];
          8'd2:  endpoint2_descriptor[x]  = test_tmp[x];
          8'd3:  endpoint3_descriptor[x]  = test_tmp[x];
          8'd4:  endpoint4_descriptor[x]  = test_tmp[x];
          8'd5:  endpoint5_descriptor[x]  = test_tmp[x];
          8'd6:  endpoint6_descriptor[x]  = test_tmp[x];
          8'd7:  endpoint7_descriptor[x]  = test_tmp[x];
          8'd8:  endpoint8_descriptor[x]  = test_tmp[x];
          8'd9:  endpoint9_descriptor[x]  = test_tmp[x];
          8'd10: endpoint10_descriptor[x] = test_tmp[x];
          8'd11: endpoint11_descriptor[x] = test_tmp[x];
          8'd12: endpoint12_descriptor[x] = test_tmp[x];
          8'd13: endpoint13_descriptor[x] = test_tmp[x];
          8'd14: endpoint14_descriptor[x] = test_tmp[x];
          8'd15: endpoint15_descriptor[x] = test_tmp[x];
        endcase
        x=x+1;
      end
      z=z+8'd1;
      y=y+8'd1;      
  	end
  	k=k+8'd1;
  end
  	
end
endtask

task CTRL_TRANSFER_TEST;
begin

  // Test - SET_INTERFACE, GET_INTERFACE

  $display("\n\n********START CTRL TRANSFER TEST********\n\n"); 
  
  $display("Start Test - SET_INTERFACE, GET_INTERFACE");
  
  test_r=9'd0;
  while(test_r < 9'd256)begin
  	k=8'd0;
    while(k<8)begin 	
    	CTRL_SET_INTERFACE(test_r[7:0], k);
    	CTRL_GET_INTERFACE(k, test0_o);
    	
    	if(test_r[7:0] != test0_o)begin
    	  $display("Error: SET_INTERFACE %d, %h, %h", k, test_r[7:0], test0_o);
    	  $finish;
    	end
    	  	  	  	
      k=k+8'd1;
    end           
    test_r = test_r + 9'd1;
  end
  
  $display("End Test - SET_INTERFACE, GET_INTERFACE");

  $display("Start Test - SET_FEATURE, CLEAR_FEATURE, INTERFACE");
  k=8'd0;
  
  while(k<8'd8)begin
    CTRL_SET_FEATURE(INTERFACE, 8'h0, k);  	  	
  	CTRL_CLEAR_FEATURE(INTERFACE, 8'h0, k);	  		
    k=k+8'd1;
  end
  
  $display("End Test - SET_FEATURE, CLEAR_FEATURE, INTERFACE");

  $display("Start Test - SET_FEATURE, CLEAR_FEATURE, GET_STATUS, ENDPOINT");
  k=8'd1;
  
  while(k<8'd16)begin
    CTRL_SET_FEATURE(ENDPOINT, SFS_ENDPOINT_HALT, k);
  	CTRL_GET_STATUS(ENDPOINT, k, test0_o, test1_o);
  	if(test0_o[0] != 1'b1)begin
    	$display("Error: SET_FEATURE ENDPOINT, SFS_ENDPOINT_HALT, %d %b", k, test0_o[0]);
    	$finish;
    end
  	  	
  	CTRL_CLEAR_FEATURE(ENDPOINT, SFS_ENDPOINT_HALT, k);
  	CTRL_GET_STATUS(ENDPOINT, k, test0_o, test1_o);
  	if(test0_o[0] != 1'b0)begin
    	$display("Error: SET_FEATURE ENDPOINT, SFS_ENDPOINT_HALT, %d %b", k, test0_o[0]);
    	$finish;
    end  	
  		
    k=k+8'd1;
  end
  
  $display("End Test - SET_FEATURE, CLEAR_FEATURE, GET_STATUS, ENDPOINT");
  
  $display("Start Test - SYNC_FRAME");
  k=8'd1;
  
  while(k<8'd16)begin
    CTRL_SYNCH_FRAME(k, test0_o, test1_o);
  	if(test0_o!= 8'h00 || test1_o!= 8'h00)begin
    	$display("Error: SYNCH_FRAME ENDPOINT, %d %h %h", k, test0_o, test1_o);
    	$finish;
    end 	
  		
    k=k+8'd1;
  end
  
  $display("End Test - SYNC_FRAME");      

  $display("Start Test - SET_FEATURE, CLEAR_FEATURE, GET_STATUS, DEVICE");

  CTRL_SET_FEATURE(DEVICE, SFS_DEVICE_REMOTE_WAKEUP, 8'h0);
  CTRL_GET_STATUS(DEVICE, 8'h0, test0_o, test1_o);
  if(test0_o[1] != 1'b1)begin
  	$display("Error: SET_FEATURE DEVICE, SFS_DEVICE_REMOTE_WAKEUP, %d %b", k, test0_o[1]);
  	$finish;
  end
    	
  CTRL_CLEAR_FEATURE(DEVICE, SFS_DEVICE_REMOTE_WAKEUP, 8'h0);
  CTRL_GET_STATUS(DEVICE, 8'h0, test0_o, test1_o);
  if(test0_o[1] != 1'b0)begin
  	$display("Error: SET_FEATURE DEVICE, SFS_DEVICE_REMOTE_WAKEUP, %d %b", k, test0_o[1]);
  	$finish;
  end  	
  
  $display("End Test - SET_FEATURE, CLEAR_FEATURE, GET_STATUS, DEVICE"); 
  
  $display("Start Test - SET_CONFIG, GET_CONFIG, DEVICE");

  test_r=9'd0;
  while(test_r < 9'd256)begin
    CTRL_SET_CONFIG(test_r[7:0]);
    CTRL_GET_CONFIG(test0_o);
    
    if(test_r[7:0] != test0_o)begin
      $display("Error: SET_CONFIG %h, %h", test_r[7:0], test0_o);
      $finish;
    end
        
    test_r = test_r + 9'd1;
  end

  $display("End Test - SET_CONFIG, GET_CONFIG, DEVICE");  
  
  $display("Start Test - SET_DESCRIPTOR, GET_DESCRIPTOR, DEVICE_DES");
  DESCRIPTOR_TEST(DEVICE_DES, 8'd0, 8'd18);  
  $display("End Test - SET_DESCRIPTOR, GET_DESCRIPTOR, DEVICE_DES");

  $display("Start Test - SET_DESCRIPTOR, GET_DESCRIPTOR, CONFIGURATION_DES");  
  DESCRIPTOR_TEST(CONFIGURATION_DES, 8'd0, 8'd9);    
  $display("End Test - SET_DESCRIPTOR, GET_DESCRIPTOR, CONFIGURATION_DES");

  $display("Start Test - SET_DESCRIPTOR, GET_DESCRIPTOR, DEVICE_QUALIFIER_DES");
  DESCRIPTOR_TEST(DEVICE_QUALIFIER_DES, 8'd0, 8'd10);
  $display("End Test - SET_DESCRIPTOR, GET_DESCRIPTOR, DEVICE_QUALIFIER_DES");

  $display("Start Test - SET_DESCRIPTOR, GET_DESCRIPTOR, OTHER_SPEED_CONFIGURATION_DES");
  DESCRIPTOR_TEST(OTHER_SPEED_CONFIGURATION_DES, 8'd0, 8'd9);
  $display("End Test - SET_DESCRIPTOR, GET_DESCRIPTOR, OTHER_SPEED_CONFIGURATION_DES");
  
  k=8'd0;
  
  while(k<8'd8)begin
    $display("Start Test - SET_DESCRIPTOR, GET_DESCRIPTOR, INTERFACE_DES %d", k);
    DESCRIPTOR_TEST(INTERFACE_DES, k, 8'd9);
    $display("End Test - SET_DESCRIPTOR, GET_DESCRIPTOR, INTERFACE_DES %d", k); 	  		
    k=k+8'd1;
  end
  
  k=8'd1;
  
  while(k<8'd16)begin
    $display("Start Test - SET_DESCRIPTOR, GET_DESCRIPTOR, ENDPOINT_DES %d", k);
    DESCRIPTOR_TEST(ENDPOINT_DES, k, 8'd7);
    $display("End Test - SET_DESCRIPTOR, GET_DESCRIPTOR, ENDPOINT_DES %d", k); 	  		
    k=k+8'd1;
  end
  
  $display("\n\n********ALL CTRL TRANSFER TEST PASSED********\n\n");  

 	
end
endtask


task DESCRIPTOR_TEST;
input [7:0] descriptor_type;
input [7:0] wIndex;
input [7:0] wLength;
begin

  CTRL_GET_DESCRIPTOR(descriptor_type, wIndex, wLength, 
    test0_tmp,  test1_tmp,  test2_tmp,  test3_tmp,
    test4_tmp,  test5_tmp,  test6_tmp,  test7_tmp,
    test8_tmp,  test9_tmp,  test10_tmp, test11_tmp,
    test12_tmp, test13_tmp, test14_tmp, test15_tmp, 
    test16_tmp, test17_tmp
  );

  CTRL_SET_DESCRIPTOR                                             
  (                                                               
    descriptor_type, wIndex, wLength,                      
    8'h55, 8'haa, 8'h55, 8'haa,                                     
    8'h55, 8'haa, 8'h55, 8'haa,                                     
    8'h55, 8'haa, 8'h55, 8'haa,                                     
    8'h55, 8'haa, 8'h55, 8'haa,                                     
    8'h55, 8'haa                                                      	 
  );                                                              	
                                                                  	
  CTRL_GET_DESCRIPTOR(descriptor_type, wIndex, wLength, 
    test0_o,  test1_o,  test2_o,  test3_o,
    test4_o,  test5_o,  test6_o,  test7_o,
    test8_o,  test9_o,  test10_o, test11_o,
    test12_o, test13_o, test14_o, test15_o, 
    test16_o, test17_o
  );
  
  if(test0_o!=8'h55  || test1_o!=8'haa  || test2_o!=8'h55 || test3_o!=8'haa ||
     test4_o!=8'h55  || test5_o!=8'haa  || test6_o!=8'h55 || test7_o!=8'haa ||
     test8_o!=8'h55  || test9_o!=8'haa  || test10_o!=8'h55 || test11_o!=8'haa ||
     test12_o!=8'h55 || test13_o!=8'haa || test14_o!=8'h55 || test15_o!=8'haa ||
     test16_o!=8'h55 || test17_o!=8'haa)begin
     $display("Error: SET_DESCRIPTOR, GET_DESCRIPTOR, %d %d %d", descriptor_type, wIndex, wLength);
     $finish; 	
  end
  
  CTRL_SET_DESCRIPTOR(descriptor_type, wIndex, wLength, 
    test0_tmp,  test1_tmp,  test2_tmp,  test3_tmp,
    test4_tmp,  test5_tmp,  test6_tmp,  test7_tmp,
    test8_tmp,  test9_tmp,  test10_tmp, test11_tmp,
    test12_tmp, test13_tmp, test14_tmp, test15_tmp, 
    test16_tmp, test17_tmp
  );
  
  CTRL_GET_DESCRIPTOR(descriptor_type, wIndex, wLength, 
    test0_o,  test1_o,  test2_o,  test3_o,
    test4_o,  test5_o,  test6_o,  test7_o,
    test8_o,  test9_o,  test10_o, test11_o,
    test12_o, test13_o, test14_o, test15_o, 
    test16_o, test17_o
  ); 	

end
endtask


task CTRL_GET_STATUS;
input [4:0] recipient;
input [7:0] wIndex;
output [7:0] dout0;
output [7:0] dout1;
begin

   $display("\n");
   $display("CTRL > GET_STATUS");
   $display("=================");
   $display("Recipient: %d, wIndex: %d", recipient, wIndex);

   //SETUP STAGE
   CTRL_INIT({{3'b100, recipient}, 8'h00, 8'h00, 8'h00, wIndex, 8'h00, 8'd02, 8'd00});
   HOST_XFER_SIZE(32'd8);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_SETUP, FUNCT_ADR, EP0);

   WAIT_ACK_IN;

   //DATA STAGE
   m=0;
   HOST_XFER_SIZE(32'd2);
   USB_FUNC(1'b1, 1'b1, 1'b1, DATA1, PID_IN, FUNCT_ADR,EP0);

   WAIT_ACK_OUT;
   
   dout0=utmi_data_i_reg[1];
   dout1=utmi_data_i_reg[2];
   $display("Status = %h %h", utmi_data_i_reg[2], utmi_data_i_reg[1]);

   //STATUS STAGE
   HOST_XFER_SIZE(32'd0);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_OUT, FUNCT_ADR, EP0);

   WAIT_ACK_IN;
   
   #(transfer_delay);

end
endtask


task CTRL_CLEAR_FEATURE;
input [4:0] recipient;
input [7:0] feature_selector;
input [7:0] wIndex;
begin

   $display("\n");
   $display("CTRL > CLEAR_FEATURE");
   $display("====================");
   $display("Recipient: %d, Feature Selector: %h, wIndex: %d", recipient, feature_selector, wIndex);

   //SETUP STAGE
   CTRL_INIT({{3'b0, recipient}, 8'h01, feature_selector, 8'h00, wIndex, 8'h00, 8'd00, 8'h00});
   HOST_XFER_SIZE(32'd8);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_SETUP, FUNCT_ADR, EP0);

   WAIT_ACK_IN;

   //DATA STAGE
   HOST_XFER_SIZE(32'd0);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_OUT, FUNCT_ADR, EP0);

   WAIT_ACK_IN;

   //STATUS STAGE
   HOST_XFER_SIZE(32'd0);
   USB_FUNC(1'b1, 1'b1, 1'b1, DATA1, PID_IN, FUNCT_ADR, EP0);

   WAIT_ACK_OUT;
   
   #(transfer_delay);   

end
endtask


task CTRL_SET_FEATURE;
input [4:0] recipient;
input [7:0] feature_selector;
input [7:0] wIndex;
begin

   $display("\n");
   $display("CTRL > SET_FEATURE");
   $display("==================");
   $display("Recipient: %d, Feature Selector: %h, wIndex: %d", recipient, feature_selector, wIndex);

   //SETUP STAGE
   CTRL_INIT({{3'b0, recipient}, 8'h03, feature_selector, 8'h00, wIndex, 8'h00, 8'd00, 8'h00});
   HOST_XFER_SIZE(32'd8);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_SETUP, FUNCT_ADR, EP0);

   WAIT_ACK_IN;

   //DATA STAGE
   HOST_XFER_SIZE(32'd0);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_OUT, FUNCT_ADR, EP0);

   WAIT_ACK_IN;

   //STATUS STAGE
   HOST_XFER_SIZE(32'd0);
   USB_FUNC(1'b1, 1'b1, 1'b1, DATA1, PID_IN, FUNCT_ADR, EP0);

   WAIT_ACK_OUT;
   
   #(transfer_delay);   

end
endtask


task CTRL_SET_ADDRESS;
input [7:0] cur_address;
input [7:0] new_address;
begin

    $display("\n");
    $display("CTRL > SET_ADDRESS - %3d", new_address);
    $display("========================");

    // SETUP STAGE
    CTRL_INIT({8'h00, 8'h05, new_address, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00});
    HOST_XFER_SIZE(32'd8);
    USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_SETUP, cur_address, EP0);

    WAIT_ACK_IN;

    // DATA STAGE
    HOST_XFER_SIZE(32'd0);
    USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_OUT, cur_address, EP0);

    WAIT_ACK_IN;

    // STATUS STAGE
    HOST_XFER_SIZE(32'd0);
    USB_FUNC(1'b1, 1'b1, 1'b1, DATA1, PID_IN, cur_address, EP0);

    WAIT_ACK_OUT;
    
   #(transfer_delay);    

end
endtask


task CTRL_GET_DESCRIPTOR;
input [7:0] descriptor_type;
input [7:0] wIndex;
input [7:0] wLength;
output [7:0] dout0;
output [7:0] dout1;
output [7:0] dout2;
output [7:0] dout3;
output [7:0] dout4;
output [7:0] dout5;
output [7:0] dout6;
output [7:0] dout7;
output [7:0] dout8;
output [7:0] dout9;
output [7:0] dout10;
output [7:0] dout11;
output [7:0] dout12;
output [7:0] dout13;
output [7:0] dout14;
output [7:0] dout15;
output [7:0] dout16;
output [7:0] dout17;
begin
	
	 dout0=8'h55;
	 dout1=8'haa;
	 dout2=8'h55;
	 dout3=8'haa;
	 dout4=8'h55;
	 dout5=8'haa;
	 dout6=8'h55;
	 dout7=8'haa;
	 dout8=8'h55;
	 dout9=8'haa;
	 dout10=8'h55;
	 dout11=8'haa;
	 dout12=8'h55;
	 dout13=8'haa;
	 dout14=8'h55;	 
	 dout15=8'haa;
	 dout16=8'h55;
	 dout17=8'haa;	  
	 	 	 	 
   $display("\n");
   $display("CTRL > GET_DESCRIPTOR");
   $display("=====================");
   $display("Descriptor Type: %d, Index: %d, Length: %d",descriptor_type, wIndex, wLength);

   //SETUP STAGE
   CTRL_INIT({8'h80, 8'h06, 8'h00, descriptor_type, wIndex, 8'h00, wLength, 8'd00});
   HOST_XFER_SIZE(32'd8);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_SETUP, FUNCT_ADR, EP0);

   WAIT_ACK_IN;

   //DATA STAGE
   m=0;
   HOST_XFER_SIZE({24'h0, wLength});
   USB_FUNC(1'b1, 1'b1, 1'b1, DATA1, PID_IN, FUNCT_ADR,EP0);

   WAIT_ACK_OUT;
   
   p=8'd0;
   
   while(p<wLength)begin   	 
   	 case(p)
   	   8'd0:    dout0=utmi_data_i_reg[1+p];
   	   8'd1:    dout1=utmi_data_i_reg[1+p];
   	   8'd2:    dout2=utmi_data_i_reg[1+p];
   	   8'd3:    dout3=utmi_data_i_reg[1+p];
   	   8'd4:    dout4=utmi_data_i_reg[1+p];
   	   8'd5:    dout5=utmi_data_i_reg[1+p];
   	   8'd6:    dout6=utmi_data_i_reg[1+p];
   	   8'd7:    dout7=utmi_data_i_reg[1+p];
   	   8'd8:    dout8=utmi_data_i_reg[1+p];
   	   8'd9:    dout9=utmi_data_i_reg[1+p];
   	   8'd10:   dout10=utmi_data_i_reg[1+p];
   	   8'd11:   dout11=utmi_data_i_reg[1+p];
   	   8'd12:   dout12=utmi_data_i_reg[1+p];
   	   8'd13:   dout13=utmi_data_i_reg[1+p];
   	   8'd14:   dout14=utmi_data_i_reg[1+p];
   	   8'd15:   dout15=utmi_data_i_reg[1+p];
   	   8'd16:   dout16=utmi_data_i_reg[1+p];
   	   8'd17:   dout17=utmi_data_i_reg[1+p];  	         	   
   	   default: dout0=utmi_data_i_reg[1+p];
     endcase
   	 
   	 $display("Descriptor[%2d] = %2h", p, utmi_data_i_reg[1+p]);
   	 p=p+8'd1;
   end
   
   //STATUS STAGE
   HOST_XFER_SIZE(32'd0);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_OUT, FUNCT_ADR, EP0);

   WAIT_ACK_IN;
   
   #(transfer_delay);   

end
endtask





task CTRL_SET_DESCRIPTOR;
input [7:0] descriptor_type;
input [7:0] wIndex;
input [7:0] wLength;
input [7:0] din0; 
input [7:0] din1; 
input [7:0] din2; 
input [7:0] din3; 
input [7:0] din4; 
input [7:0] din5; 
input [7:0] din6; 
input [7:0] din7; 
input [7:0] din8; 
input [7:0] din9; 
input [7:0] din10;
input [7:0] din11;
input [7:0] din12;
input [7:0] din13;
input [7:0] din14;
input [7:0] din15;
input [7:0] din16;
input [7:0] din17;     
begin

   $display("\n");
   $display("CTRL > SET_DESCRIPTOR");
   $display("=====================");
   $display("Descriptor Type: %d, Index: %d, Length: %d", descriptor_type, wIndex, wLength);
   
  

   //SETUP STAGE
   CTRL_INIT({8'h00, 8'h07, 8'h00, descriptor_type, wIndex, 8'h00, wLength, 8'h00});
   HOST_XFER_SIZE(32'd8);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_SETUP, FUNCT_ADR, EP0);

   WAIT_ACK_IN;
   
   WB_MASTER_MODEL_HOST_U.wb_write(1, USB_CTRL, 32'h4);
   WB_MASTER_MODEL_HOST_U.wb_write(1, USB_CTRL, 32'h0);
   FIFO_WR({24'h0,din0});
   FIFO_WR({24'h0,din1});   
   FIFO_WR({24'h0,din2});
   FIFO_WR({24'h0,din3});
   FIFO_WR({24'h0,din4});   
   FIFO_WR({24'h0,din5});
   FIFO_WR({24'h0,din6});
   FIFO_WR({24'h0,din7});   
   FIFO_WR({24'h0,din8});
   FIFO_WR({24'h0,din9});
   FIFO_WR({24'h0,din10});   
   FIFO_WR({24'h0,din11});
   FIFO_WR({24'h0,din12});
   FIFO_WR({24'h0,din13});   
   FIFO_WR({24'h0,din14});            
   FIFO_WR({24'h0,din15});
   FIFO_WR({24'h0,din16});   
   FIFO_WR({24'h0,din17});   

   //DATA STAGE
   HOST_XFER_SIZE({24'h0, wLength});
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_OUT, FUNCT_ADR, EP0);

   WAIT_ACK_IN;

   //STATUS STAGE
   HOST_XFER_SIZE(32'd0);
   USB_FUNC(1'b1, 1'b1, 1'b1, DATA1, PID_IN, FUNCT_ADR, EP0);

   WAIT_ACK_OUT;
   
   #(transfer_delay);   

end
endtask


task CTRL_GET_CONFIG;
output [7:0] dout0;
begin

   $display("\n");
   $display("CTRL > DEVICE > GET_CONFIG");
   $display("==========================");

   //SETUP STAGE
   CTRL_INIT({8'h80, 8'h08, 8'h00, 8'h00, 8'h00, 8'h00, 8'h01, 8'd00});
   HOST_XFER_SIZE(32'd8);
   
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_SETUP, FUNCT_ADR, EP0);

   WAIT_ACK_IN;

   //DATA STAGE
   m=0;
   HOST_XFER_SIZE(32'd1);
   USB_FUNC(1'b1, 1'b1, 1'b1, DATA1, PID_IN, FUNCT_ADR,EP0);

   WAIT_ACK_OUT;
   
   dout0=utmi_data_i_reg[1];
   $display("Config Value = %h", utmi_data_i_reg[1]);

   //STATUS STAGE
   HOST_XFER_SIZE(32'd0);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_OUT, FUNCT_ADR, EP0);

   WAIT_ACK_IN;
   
   #(transfer_delay);   

end
endtask


task CTRL_SET_CONFIG;
input [7:0] config_value;
begin

	 $display("\n");
   $display("CTRL - SET_CONFIG");
   $display("=================");
   $display("Config Value: %2h", config_value);

   //SETUP STAGE
   CTRL_INIT({8'h00, 8'h09, config_value, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00});
   HOST_XFER_SIZE(32'd8);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_SETUP, FUNCT_ADR, EP0);

   WAIT_ACK_IN;

   //DATA STAGE
   n=0;
   HOST_XFER_SIZE(32'd0);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_OUT, FUNCT_ADR, EP0);

   WAIT_ACK_IN;
   
   $display("Config Value = %h", utmi_data_o_reg[4]);

   //STATUS STAGE
   HOST_XFER_SIZE(32'd0);
   USB_FUNC(1'b1, 1'b1, 1'b1, DATA1, PID_IN, FUNCT_ADR, EP0);

   WAIT_ACK_OUT;
   
   #(transfer_delay);   

end
endtask


task CTRL_GET_INTERFACE;
input  [7:0] interface_no;
output [7:0] alternate_setting_o;
begin

   $display("\n");
   $display("CTRL > GET_INTERFACE");
   $display("================================");
   $display("Interface: %d",interface_no);

   //SETUP STAGE
   CTRL_INIT({8'h81, 8'h0a, 8'h00, 8'h00,interface_no, 8'h00, 8'd01, 8'h00});
   HOST_XFER_SIZE(32'd8);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_SETUP, FUNCT_ADR, EP0);

   WAIT_ACK_IN;

   //DATA STAGE
   m=0;
   HOST_XFER_SIZE(32'd1);
   USB_FUNC(1'b1, 1'b1, 1'b1, DATA1, PID_IN, FUNCT_ADR,EP0);

   WAIT_ACK_OUT;
   alternate_setting_o = utmi_data_i_reg[1];   
   $display("Alternate Setting = %h", utmi_data_i_reg[1]);

   //STATUS STAGE
   HOST_XFER_SIZE(32'd0);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_OUT, FUNCT_ADR, EP0);

   WAIT_ACK_IN;
   
   #(transfer_delay);   

end
endtask


task CTRL_SET_INTERFACE;
input [7:0] alternate_setting;
input [7:0] interface_no;
begin

   $display("\n");
   $display("CTRL > SET_INTERFACE");
   $display("================================");
   $display("Interface: %d",interface_no);

   //SETUP STAGE
   n=0;
   CTRL_INIT({8'h01, 8'h0b, alternate_setting, 8'h00,interface_no, 8'h00, 8'd00, 8'h00});
   HOST_XFER_SIZE(32'd8);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_SETUP, FUNCT_ADR, EP0);

   WAIT_ACK_IN;

   $display("Alternate Setting = %h", utmi_data_o_reg[6]);   

   //DATA STAGE
   HOST_XFER_SIZE(32'd0);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_OUT, FUNCT_ADR, EP0);

   WAIT_ACK_IN;
   
   //STATUS STAGE
   HOST_XFER_SIZE(32'd0);
   USB_FUNC(1'b1, 1'b1, 1'b1, DATA1, PID_IN, FUNCT_ADR, EP0);

   WAIT_ACK_OUT;
   
   #(transfer_delay);   

end
endtask


task CTRL_SYNCH_FRAME;
input  [7:0] endpoint_no;
output [7:0] dout0;
output [7:0] dout1;
begin
	
   $display("\n");
   $display("CTRL > SYNCH_FRAME");
   $display("==================");
   $display("Endpoint: %d",endpoint_no);

   //SETUP STAGE
   CTRL_INIT({8'h82, 8'h12, 8'h00, 8'h00,endpoint_no, 8'h00, 8'd02, 8'd00});
   HOST_XFER_SIZE(32'd8);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_SETUP, FUNCT_ADR, EP0);

   WAIT_ACK_IN;

   //DATA STAGE
   m=0;
   HOST_XFER_SIZE(32'd2);
   USB_FUNC(1'b1, 1'b1, 1'b1, DATA1, PID_IN, FUNCT_ADR,EP0);

   WAIT_ACK_OUT;
   
   dout0=utmi_data_i_reg[1];
   dout1=utmi_data_i_reg[2];   
   $display("Frame Number = %h %h", utmi_data_i_reg[2], utmi_data_i_reg[1]); 

   //STATUS STAGE
   HOST_XFER_SIZE(32'd0);
   USB_FUNC(1'b1, 1'b0, 1'b0, DATA0, PID_OUT, FUNCT_ADR, EP0);

   WAIT_ACK_IN;

   #(transfer_delay);   
   
end
endtask


integer break_while;


task WAIT_ACK_IN;
begin

  break_while=0;

  while(break_while==0)begin
    @(posedge clk_60mhz_i)
    if(utmi_rxvalid_i)begin
      if(utmi_data_i===8'hd2)begin
        break_while=1;
        `ifdef STDOUT_DISPLAY
         $display("%0t CTRL_OUT - ACK Received: %h", $time, utmi_data_i);
        `endif
      end
      else begin
        break_while=0;
        `ifdef STDOUT_DISPLAY
         $display("%0t Error Code: %h", $time, utmi_data_i);
        `endif
      end
    end
  end

end
endtask


task WAIT_ACK_OUT;
begin

  break_while=0;

  while(break_while==0)begin
    @(posedge clk_60mhz_i)
    if(utmi_txvalid_o)begin
      if(utmi_data_o===8'hd2)begin
        break_while=1;
        `ifdef STDOUT_DISPLAY
         $display("%0t CTRL_IN - ACK Sent: %h", $time, utmi_data_o);
        `endif
      end
    end
  end

end
endtask


integer fh_i;
integer fh_o;


initial begin
  fh_o = $fopen("../log/result_o.log");
  fh_i = $fopen("../log/result_i.log");
end   






always @ (posedge clk_60mhz_i)begin

  if(utmi_rxvalid_i)begin
    $fdisplay(fh_o, "%d", utmi_data_i);
    utmi_data_i_reg[m] <= utmi_data_i;
    m=m+1;
    `ifdef STDOUT_DISPLAY
     $write("RX=%h\n", utmi_data_i);
    `endif    
    //$display("RX = %h", utmi_data_i);
  end

  if(utmi_txvalid_o)begin
    $fdisplay(fh_i, "%d", utmi_data_o);
    utmi_data_o_reg[n] <= utmi_data_o;
    n=n+1;
    `ifdef STDOUT_DISPLAY
     $write("TX=%h\n", utmi_data_o);
    `endif
    //$display("TX = %h", utmi_data_o);
  end

end


task CTRL_INIT;
input [63:0] din;
begin
  WB_MASTER_MODEL_HOST_U.wb_write(1, USB_CTRL, 32'h4);
  WB_MASTER_MODEL_HOST_U.wb_write(1, USB_CTRL, 32'h0);
  FIFO_WR({24'h0,din[63:56]});
  FIFO_WR({24'h0,din[55:48]});
  FIFO_WR({24'h0,din[47:40]});
  FIFO_WR({24'h0,din[39:32]});
  FIFO_WR({24'h0,din[31:24]});
  FIFO_WR({24'h0,din[23:16]});
  FIFO_WR({24'h0,din[15:8]});
  FIFO_WR({24'h0,din[7:0]});
end
endtask


task USBHOST_INIT;
begin
  #20;
  WB_MASTER_MODEL_HOST_U.wb_write(1, USB_CTRL, 32'h5); // USB Reset
  #20;
  WB_MASTER_MODEL_HOST_U.wb_write(1, USB_CTRL, 32'h4); // USB Reset
  WB_MASTER_MODEL_HOST_U.wb_write(1, USB_IRQ_ACK, 32'h0);
  WB_MASTER_MODEL_HOST_U.wb_write(1, USB_IRQ_MASK, 32'h0);
  WB_MASTER_MODEL_HOST_U.wb_write(1, USB_XFER_DATA, 32'd1024);
end
endtask


task HOST_XFER_SIZE;
input [31:0] size;
begin
  WB_MASTER_MODEL_HOST_U.wb_write(1, USB_XFER_DATA, size);
end
endtask


parameter  EP_DIS   = 2'b00;
parameter  LRG_OK   = 1'b1;
parameter  SML_OK   = 1'b1;
parameter  DMAEN    = 1'b1;
parameter  OTS_STOP = 1'b1;
parameter  TR_FR    = 2'b00;


task USB_FUNC;
input       USB_XFER_START;
input       USB_XFER_IN;
input       USB_XFER_ACK;
input       USB_XFER_PID_DATAX;
input [7:0] USB_XFER_PID_BITS;
input [7:0] USB_XFER_DEV_ADDR;
input [3:0] USB_XFER_EP_ADDR;
begin

WB_MASTER_MODEL_HOST_U.wb_write(1, USB_XFER_TOKEN, {USB_XFER_START,USB_XFER_IN,USB_XFER_ACK,USB_XFER_PID_DATAX,{4{1'b0}},USB_XFER_PID_BITS,USB_XFER_DEV_ADDR[6:0],USB_XFER_EP_ADDR,{5{1'b0}}});

end
endtask


task FIFO_RD;
output [31:0] dout;
begin

WB_MASTER_MODEL_HOST_U.wb_read(1, USB_RD_DATA, dout);

end
endtask



task FIFO_WR;
input [31:0] din;
begin

WB_MASTER_MODEL_HOST_U.wb_write(1, USB_WR_DATA, din);

end
endtask

reg [31:0] counter;

task FIFO_INIT;
begin
	
  counter = 32'h0;

  repeat(256) begin
    FIFO_WR(counter);
    counter = counter + 32'h1;
  end

  counter = 32'd255;

  repeat(256) begin
    FIFO_WR(counter);
    counter = counter - 32'h1;
  end

  counter = 32'h0;

  repeat(256) begin
    FIFO_WR(counter);
    counter = counter + 32'h1;
  end

  counter = 32'd255;

  repeat(256) begin
    FIFO_WR(counter);
    counter = counter - 32'h1;
  end
  
end
endtask


task FIFO_RAND;
input [15:0] wMaxPacketSize;
begin
	
  counter = 32'h0;
  
  while(counter<{16'h0, wMaxPacketSize})begin
  	FIFO_WR({24'h0, $random});
  	counter=counter+32'h1;
  end
  
end
endtask




endmodule

