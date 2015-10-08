// CY Wong
// 06 AUG 2015
// USB2.0 Project

`include "timescale.v"

module USBF_TOP_TB();

reg rstp_i;
wire rstn_i;
reg clk_60mhz_i;

initial begin
    clk_60mhz_i = 1'b0;
end

// 60MHZ
always
//     #16.677 clk_60mhz_i = !clk_60mhz_i;
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
wire [17:0]                 wb_adr_core;
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

reg       USB_XFER_START;       
reg       USB_XFER_IN;          
reg       USB_XFER_ACK;         
reg       USB_XFER_PID_DATAX;   
reg [7:0] USB_XFER_PID_BITS;  
reg [3:0] USB_XFER_EP_ADDR;

parameter USB_XFER_DEV_ADDR=7'h1;

parameter EP1_BUF0=18'h58;
parameter EP1_BUF1=18'h5c;
parameter EP13_CSR=18'h110;
parameter EP13_BUF0=18'h118;
parameter EP13_BUF1=18'h11c;
parameter EP14_CSR=18'h120;
parameter EP14_BUF0=18'h128;
parameter EP14_BUF1=18'h12c;






parameter CSR=18'h0;        //RW
parameter FA=18'h4;         //RW
parameter INT_MSK=18'h8;    //RW
parameter INT_SRC=18'hc;    //ROC
parameter FRM_NAT=18'h10;   //RO
parameter UTMI_VEND=18'h14; //RW

reg [31:0] wb_master_model_core_dout;

parameter PID_OUT          = 8'hE1;
parameter PID_IN           = 8'h69;
parameter PID_SOF          = 8'hA5;
parameter PID_SETUP        = 8'h2D;
parameter PID_DATA0        = 8'hC3;
parameter PID_DATA1        = 8'h4B;
parameter PID_ACK          = 8'hD2; // Successful
// BT
// If the endpoint buffer is not empty due to processing a previous packet, then the function returns an NAK
parameter PID_NAK          = 8'h5A;

// BT
// However if the endpoint has had an error and its halt bit has been set, it returns a STALL
parameter PID_STALL        = 8'h1E;


parameter USB_CTRL       = 8'h00;
parameter USB_IRQ_ACK    = 8'h04;
parameter USB_IRQ_MASK   = 8'h08;
parameter USB_XFER_DATA  = 8'h0c;
parameter USB_XFER_TOKEN = 8'h10;
parameter USB_WR_DATA    = 8'h18;

parameter DATA0 = 1'b0;
parameter DATA1 = 1'b1;  

 
reg [13:0] EPBUF_SIZE;
reg [16:0] EPBUF_PTR;




reg [15:0] crc_sum_q_host;
reg [15:0] crc_sum_q_core;
reg [15:0] crc_sum_q_device;
reg [7:0]  crc_data_in_w_host;
reg [7:0]  crc_data_in_w_core;
reg [7:0]  crc_data_in_w_device;
wire [15:0] crc_out_w_host;
wire [15:0] crc_out_w_core;
wire [15:0] crc_out_w_device; 

usbh_crc16
u_crc16_host
(
  .crc_i(crc_sum_q_host),
  .data_i(crc_data_in_w_host),
  .crc_o(crc_out_w_host)
);

usbf_crc16
u_crc16_core
(
    .crc_in(crc_sum_q_core),
    .din({crc_data_in_w_core[0],crc_data_in_w_core[1],crc_data_in_w_core[2],crc_data_in_w_core[3],crc_data_in_w_core[4],crc_data_in_w_core[5],crc_data_in_w_core[6],crc_data_in_w_core[7]}),
//    .din(crc_data_in_w_core),
    .crc_out(crc_out_w_core)
);


usbf_crc16_device
u_crc16_device
(
    .crc_in(crc_sum_q_device),
    .din(crc_data_in_w_device),
    .crc_out(crc_out_w_device)
);


initial begin

  #100

  #10
//   crc_sum_q_host = 16'h0000; crc_data_in_w_host = 8'h00;
//   crc_sum_q_core = 16'h0000; crc_data_in_w_core = 8'h00;

//   crc_sum_q_host = 16'hffff; crc_data_in_w_host = 8'h00;
//   crc_sum_q_core = 16'hffff; crc_data_in_w_core = 8'h01; 

  #10 crc_sum_q_host = 16'hffff; crc_data_in_w_host = 8'h00;
  #10 crc_sum_q_host = crc_out_w_host; crc_data_in_w_host = 8'h01;
  #10 crc_sum_q_host = crc_out_w_host; crc_data_in_w_host = 8'h02;
  #10 crc_sum_q_host = crc_out_w_host; crc_data_in_w_host = 8'h03;
  #10 crc_sum_q_host = crc_out_w_host; crc_data_in_w_host = 8'h04;
//  #10 crc_sum_q_host = crc_out_w_host; crc_data_in_w_host = 8'h05;
   
  #10 crc_sum_q_device = 16'hffff; crc_data_in_w_device = 8'h00;
  #10 crc_sum_q_device = crc_out_w_device; crc_data_in_w_device = 8'h01;
  #10 crc_sum_q_device = crc_out_w_device; crc_data_in_w_device = 8'h02;
  #10 crc_sum_q_device = crc_out_w_device; crc_data_in_w_device = 8'h03;
  #10 crc_sum_q_device = crc_out_w_device; crc_data_in_w_device = 8'h04;
//  #10 crc_sum_q_device = crc_out_w_device; crc_data_in_w_device = 8'h05;
  #10 crc_sum_q_device = crc_out_w_device; crc_data_in_w_device = 8'h7A;
  #10 crc_sum_q_device = crc_out_w_device; crc_data_in_w_device = 8'hF0;





  #10 crc_sum_q_core = 16'hffff; crc_data_in_w_core = 8'h00;
  #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'h01;
  #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'h02;
  #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'h03;
  #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'h04;
//  #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'h05;
  #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'h7A;
  #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'hF0;



//   #10
//   crc_sum_q_host = crc_out_w_host; crc_data_in_w_host = 8'h01;
//   crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'hc1; 
// 
//   #10
//   crc_sum_q_host = crc_out_w_host; crc_data_in_w_host = 8'h02;
//   crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'hc0;
// 
// 
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'hc0;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'hc1;
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'hc1;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'hc0;
// 
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'h80;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'h7E;
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'h7E;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'h80;
// 
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'h01;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'h00;
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'h00;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'h01;
// 
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'h10;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'h21;
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'h21;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'h10;
// 
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'hF1;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'hD1;
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'hD1;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'hF1;
// 
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'hDC;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'hBD;
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'hBD;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'hDC;
// 
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'h89;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'h11;
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'h11;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'h89;
// 
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'hA1;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'hC9;
// #10 crc_sum_q_core = 16'h7d07; crc_data_in_w_core = 8'hC9;
// #10 crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'hA1;









// 
//   #10
//   crc_sum_q_host = crc_out_w_host; crc_data_in_w_host = 8'h03;
//   crc_sum_q_core = crc_out_w_core; crc_data_in_w_core = 8'h20;

//  #100 $finish;

// 0000 0000 0010 1101

// 1000 0000 0010 1000
// 8 0 2 8
// 1000 0000 0111 0000
// 8 0 7 0

// 1110 0000 0000 0100
// E004
// 2007


// 1010 0000 0100 1110
// A 0 4 E
// 5 0 2 7

// B001
// 1011

end


initial begin

  rstp_i = 1'b1;
  #300;
  rstp_i = 1'b0;

  USBHOST_INIT;
  USBCORE_INIT;
  FIFO_INIT;



//   // ISO WR
// 
//   WB_MASTER_MODEL_CORE_U.wb_read(1, EP14_CSR, wb_master_model_core_dout);
//   WB_MASTER_MODEL_CORE_U.wb_write(1, EP14_CSR, 32'b00_00_10_01_00_1110_1_1_0_0_0_00_100_0000_0000);
//   WB_MASTER_MODEL_CORE_U.wb_write(1, EP14_BUF0, 32'h08000000);
//   WB_MASTER_MODEL_CORE_U.wb_write(1, EP14_BUF1, 32'h08000000);
// 
//   // BT PID_OUT
//   USB_XFER_START = 1'b1;
//   USB_XFER_IN = 1'b0;
//   USB_XFER_ACK = 1'b0;    
//   USB_XFER_PID_DATAX = DATA0;   
//   USB_XFER_PID_BITS = PID_OUT;   
//   USB_XFER_EP_ADDR = 4'b1110;
//   USB_FUNC;
// 
//   #20000
// 
//   // ISO RD
//   WB_MASTER_MODEL_CORE_U.wb_read(1, EP13_CSR, wb_master_model_core_dout);
//   WB_MASTER_MODEL_CORE_U.wb_write(1, EP13_CSR, 32'b00_00_01_01_00_1101_1_1_0_0_0_00_100_0000_0000);
//   WB_MASTER_MODEL_CORE_U.wb_write(1, EP13_BUF0, 32'h08000000);
//   WB_MASTER_MODEL_CORE_U.wb_write(1, EP13_BUF1, 32'h08000000);
// 
//   // PID_IN
//   USB_XFER_START = 1'b1;
//   USB_XFER_IN = 1'b1;   
//   USB_XFER_ACK = 1'b1;    
//   USB_XFER_PID_DATAX = DATA0;   
//   USB_XFER_PID_BITS = PID_IN;   
//   USB_XFER_EP_ADDR = 4'b1101;
//   USB_FUNC;





  // BULK WR
  WB_MASTER_MODEL_CORE_U.wb_read(1, EP14_CSR, wb_master_model_core_dout);
  WB_MASTER_MODEL_CORE_U.wb_write(1, EP14_CSR, 32'b00_00_10_10_00_1110_1_1_0_0_0_00_100_0000_0000);
  WB_MASTER_MODEL_CORE_U.wb_write(1, EP14_BUF0, 32'h08000000);
  WB_MASTER_MODEL_CORE_U.wb_write(1, EP14_BUF1, 32'h08000000);

  // BT PID_OUT
  USB_XFER_START = 1'b1;
  USB_XFER_IN = 1'b0;
  USB_XFER_ACK = 1'b0;    
  USB_XFER_PID_DATAX = DATA0;   
  USB_XFER_PID_BITS = PID_OUT;   
  USB_XFER_EP_ADDR = 4'b1110;
  USB_FUNC;

  #20000

  // BULK RD
  WB_MASTER_MODEL_CORE_U.wb_read(1, EP13_CSR, wb_master_model_core_dout);
  WB_MASTER_MODEL_CORE_U.wb_write(1, EP13_CSR, 32'b00_00_01_10_00_1101_1_1_0_0_0_00_100_0000_0000);
  WB_MASTER_MODEL_CORE_U.wb_write(1, EP13_BUF0, 32'h08000000);
  WB_MASTER_MODEL_CORE_U.wb_write(1, EP13_BUF1, 32'h08000000);

  // PID_IN
  USB_XFER_START = 1'b1;
  USB_XFER_IN = 1'b1;   
  USB_XFER_ACK = 1'b1;    
  USB_XFER_PID_DATAX = DATA0;   
  USB_XFER_PID_BITS = PID_IN;   
  USB_XFER_EP_ADDR = 4'b1101;
  USB_FUNC;









  

// INT WR
// INT RD
// CTRL WR
// CTRL RD





// # 5000
// 
// 
//   USB_XFER_START = 1'b1;
//   USB_XFER_IN = 1'b0;     
//   USB_XFER_ACK = 1'b0;    
//   USB_XFER_PID_DATAX = 1'b0;   
//   USB_XFER_PID_BITS = PID_DATA0;   
//   USB_XFER_DEV_ADDR = 7'b000_0001;
//   USB_XFER_EP_ADDR = 4'b1110;
//   USB_FUNC;


  













//   // PID_OUT
//   USB_XFER_START = 1'b1;
//   USB_XFER_IN = 1'b0;     
//   USB_XFER_ACK = 1'b0;    
//   USB_XFER_PID_DATAX = 1'b0;   
//   USB_XFER_PID_BITS = PID_OUT;   
//   USB_XFER_DEV_ADDR = 7'b000_0001;
//   USB_XFER_EP_ADDR = 4'b1110;
//   USB_FUNC;
//   
//   // PID_IN
//   USB_XFER_START = 1'b1;
//   USB_XFER_IN = 1'b0;     
//   USB_XFER_ACK = 1'b0;    
//   USB_XFER_PID_DATAX = 1'b0;   
//   USB_XFER_PID_BITS = PID_IN;   
//   USB_XFER_DEV_ADDR = 7'b000_0001;
//   USB_XFER_EP_ADDR = 4'b1110;
//   USB_FUNC;
// 
//   // PID_DATA0
//   USB_XFER_START = 1'b1;
//   USB_XFER_IN = 1'b0;     
//   USB_XFER_ACK = 1'b0;    
//   USB_XFER_PID_DATAX = 1'b0;   
//   USB_XFER_PID_BITS = PID_DATA0;   
//   USB_XFER_DEV_ADDR = 7'b000_0001;
//   USB_XFER_EP_ADDR = 4'b1110;
//   USB_FUNC;
// 
//   // PID_DATA1
//   USB_XFER_START = 1'b1;
//   USB_XFER_IN = 1'b0;    
//   USB_XFER_ACK = 1'b0;   
//   USB_XFER_PID_DATAX = 1'b1;  
//   USB_XFER_PID_BITS = PID_DATA1;   
//   USB_XFER_DEV_ADDR = 7'b000_0001;
//   USB_XFER_EP_ADDR = 4'b1110;
//   USB_FUNC;

//   USB_XFER_START = 1'b1;  
//   USB_XFER_IN = 1'b0;        
//   USB_XFER_ACK = 1'b0;    
//   USB_XFER_PID_DATAX = 1'b0;   
//   USB_XFER_PID_BITS = 8'h2d;   
//   USB_XFER_DEV_ADDR = 7'b000_0001;
//   USB_XFER_EP_ADDR = 4'b0000;
//   WB_MASTER_MODEL_HOST_U.wb_write(1, 8'h0c, 32'd1024);
//   WB_MASTER_MODEL_HOST_U.wb_write(1, 8'h10, {USB_XFER_START,USB_XFER_IN,USB_XFER_ACK,USB_XFER_PID_DATAX,{4{1'b0}},USB_XFER_PID_BITS,USB_XFER_DEV_ADDR,USB_XFER_EP_ADDR,{5{1'b0}}});
//   
//   USB_FUNC;
//   USB_FUNC;

  //#1000 $finish;

//   WB_MASTER_MODEL_CORE_U.wb_read(1, FRM_NAT, wb_master_model_core_dout);
//   WB_MASTER_MODEL_CORE_U.wb_write(1, UTMI_VEND, 32'h0);
//   WB_MASTER_MODEL_CORE_U.wb_read(1, UTMI_VEND, wb_master_model_core_dout);
// WB_MASTER_MODEL_CORE_U.wb_write(1, FA, 32'h5a5a5a5a);
//  WB_MASTER_MODEL_CORE_U.wb_write(1, CSR, 32'hee);
//   WB_MASTER_MODEL_CORE_U.wb_read(1, CSR, wb_master_model_core_dout);
//   WB_MASTER_MODEL_CORE_U.wb_read(1, INT_MSK, wb_master_model_core_dout);
//   #4000000
//   WB_MASTER_MODEL_CORE_U.wb_read(1, FRM_NAT, wb_master_model_core_dout);
// 
// // reg [13:0] EPBUF_SIZE;
// // reg [16:0] EPBUF_PTR;
// 
//   EPBUF_SIZE = 14'd1024;
//   EPBUF_PTR  = 17'd0;
//   WB_MASTER_MODEL_CORE_U.wb_write(1, EP1_BUF0, {1'b0, EPBUF_SIZE, EPBUF_PTR});
//   WB_MASTER_MODEL_CORE_U.wb_read(1, EP1_BUF0, wb_master_model_core_dout);












//  WB_MASTER_MODEL_CORE_U.wb_read(1, FA, wb_master_model_core_dout);
//  WB_MASTER_MODEL_CORE_U.wb_read(1, INT_MSK, wb_master_model_core_dout);
//  WB_MASTER_MODEL_CORE_U.wb_read(1, UTMI_VEND, wb_master_model_core_dout);






// parameter CSR=18'h0;        //RW
// parameter FA=18'h4;         //RW
// parameter INT_MSK=18'h8;    //RW
// parameter INT_SRC=18'hc;    //ROC
// parameter FRM_NAT=18'h10;   //RO
// parameter UTMI_VEND=18'h14; //RW

end



integer fh;

always @ (posedge clk_60mhz_i)begin
  if(utmi_rxvalid_i)begin
    $fdisplay(fh, "%d", utmi_data_i);
  end 

end

initial begin
  fh = $fopen("result.log");
end 

// final
//   $fclose(fh);

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


task USBCORE_INIT;
begin
  WB_MASTER_MODEL_CORE_U.wb_write(1, FA, 32'h00000001);
end
endtask


task USB_FUNC;
begin

WB_MASTER_MODEL_HOST_U.wb_write(1, 8'h10, {USB_XFER_START,USB_XFER_IN,USB_XFER_ACK,USB_XFER_PID_DATAX,{4{1'b0}},USB_XFER_PID_BITS,USB_XFER_DEV_ADDR,USB_XFER_EP_ADDR,{5{1'b0}}});

end
endtask



task FIFO_WR;
input [31:0] din;
begin

WB_MASTER_MODEL_HOST_U.wb_write(1, USB_WR_DATA, din);

end
endtask

reg [9:0] counter;

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


wb_master_model #(32,18) WB_MASTER_MODEL_CORE_U
(
  .clk_i(clk_60mhz_i),
  .rst_i(rstp_i),
  .adr_o(wb_adr_core),
  .din_i(wb_din_core),
  .dout_o(wb_dout_core),
  .cyc_o(wb_cyc_core),
  .stb_o(wb_stb_core),
  .we_o(wb_we_core),
  .ack_i(wb_ack_core),
  .sel_o()
);


usbf_top USBF_TOP_U
(
  .clk_i(clk_60mhz_i), 
  .rst_i(rstn_i),
  .wb_addr_i(wb_adr_core),
  .wb_data_i(wb_dout_core),
  .wb_data_o(wb_din_core),
  .wb_ack_o(wb_ack_core),
  .wb_we_i(wb_we_core),
  .wb_stb_i(wb_stb_core),
  .wb_cyc_i(wb_cyc_core),
  
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

// input		phy_clk_pad_i;
// output		phy_rst_pad_o;
// output	[7:0]	DataOut_pad_o;
// output		TxValid_pad_o;
// input		TxReady_pad_i;
// input	[7:0]	DataIn_pad_i;
// input		RxValid_pad_i;
// input		RxActive_pad_i;
// input		RxError_pad_i;
// input	[1:0]	LineState_pad_i;





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


ssram #(.USBF_SSRAM_HADR(14)) SSRAM_U 
(
  .clk_i(clk_60mhz_i),    /*input                        */ 
  .address_i(sram_adr_o), /*input  [USBF_SSRAM_HADR-1:0] */ 
  .data_i(sram_data_o),   /*input  [31:0]                */ 
  .data_o(sram_data_i),   /*output [31:0]                */ 
  .re_i(sram_re_o),       /*input                        */ 
  .we_i(sram_we_o)        /*input                        */
);

                                                    
endmodule
