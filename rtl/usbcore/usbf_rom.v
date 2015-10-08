`include "timescale.v"
`include "usbf_defines.v"


module usbf_rom
#(
    parameter USBF_SSRAM_HADR=14
)
(
  clk_i,
  rst_i,
  address_i,
  data_i,
  data_o,
  we_i,
  re_i,
  we_ctrl_i,
  data_ctrl_i,
  address_ctrl_i,
  index_ctrl_i,
  frm_nat_i,
  bRequest_i
);


input                       clk_i;
input                       rst_i;
input  [USBF_SSRAM_HADR:0]  address_i;
input  [31:0]               data_i;
output [31:0]               data_o;
input                       we_i;
input                       re_i; 
input                       we_ctrl_i;
input  [7:0]                data_ctrl_i;
input  [USBF_SSRAM_HADR:0]  address_ctrl_i;
input  [ 1:0]               index_ctrl_i;
input  [31:0]               frm_nat_i;
input  [7:0]                bRequest_i;


wire  [31:0]               frm_nat_i;             


parameter RAM_DEPTH = 1 << USBF_SSRAM_HADR;
parameter GET_CONFIG     = 8'h08;
parameter GET_INTERFACE  = 8'h0a;

reg [31:0] data_out;
reg [31:0] mem [0:RAM_DEPTH-1];

assign data_o = data_out;


always @ (posedge clk_i) begin
  if(!rst_i)
    data_out <= 32'h0;
  else if(!we_i && re_i)begin
    if(address_i==`DEVICE_GET_STATUS_ROM_ADDR)
      data_out <= {30'h0, mem[`DEVICE_GET_STATUS_ROM_ADDR][0], mem[`DEVICE_GET_STATUS_ROM_ADDR+1][0]};
    else if((address_i>=`INTERFACE0_DES_ROM_ADDR && address_i<=`INTERFACE7_DES_ROM_ADDR) && bRequest_i==GET_INTERFACE)
      data_out <= {24'h0, mem[address_i][31:24]};
    else if(address_i==`CONFIGURATION_DES_ROM_ADDR && bRequest_i==GET_CONFIG)
      data_out <= {24'h0, mem[`CONFIGURATION_DES_ROM_ADDR+1][15:8]};
    else if(address_i==`EP_FRM_NAT) // FRM_NAT
      data_out <= frm_nat_i;
    else
      data_out <= mem[address_i];
  end
  else
    data_out <= data_out;
end


always@(posedge clk_i) begin
  if(!rst_i)begin

    // Device Descriptor - 18 Bytes
    mem[`DEVICE_DES_ROM_ADDR  ] = {8'h01, 8'h00, 8'h01, 8'h18};
    mem[`DEVICE_DES_ROM_ADDR+1] = {8'h64, 8'hff, 8'h00, 8'hff};
    mem[`DEVICE_DES_ROM_ADDR+2] = {8'h56, 8'h78, 8'h12, 8'h34};
    mem[`DEVICE_DES_ROM_ADDR+3] = {8'h00, 8'h00, 8'h00, 8'h10};
    mem[`DEVICE_DES_ROM_ADDR+4] = {8'h00, 8'h00, 8'h01, 8'h00};

    // Configuration Descriptor - 9 Bytes
    // Configuration Descriptor - Configuration Value, 5th Byte
    mem[`CONFIGURATION_DES_ROM_ADDR  ] = {8'h00, 8'h53, 8'h02, 8'h09};
    mem[`CONFIGURATION_DES_ROM_ADDR+1] = {8'h40, 8'h00, 8'h01, 8'h07};
    mem[`CONFIGURATION_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};
    
    // Device Qualifier Descriptor - 10 Bytes
    mem[`DEVICE_QUALIFIER_DES_ROM_ADDR  ] = {8'h02, 8'h00, 8'h06, 8'h0A};
    mem[`DEVICE_QUALIFIER_DES_ROM_ADDR+1] = {8'h40, 8'h00, 8'h00, 8'h00};
    mem[`DEVICE_QUALIFIER_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h01};
    
    // Other Speed Configuration Descriptor - 9 Bytes
    mem[`OTHER_SPEED_CONFIGURATION_DES_ROM_ADDR  ] = {8'h00, 8'h20, 8'h07, 8'h09};
    mem[`OTHER_SPEED_CONFIGURATION_DES_ROM_ADDR+1] = {8'h80, 8'h00, 8'h01, 8'h01};
    mem[`OTHER_SPEED_CONFIGURATION_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'hFA};    

    // Interface Descriptor 0 - 9 Bytes
    mem[`INTERFACE0_DES_ROM_ADDR  ] = {8'h00, 8'h00, 8'h04, 8'h09};
    mem[`INTERFACE0_DES_ROM_ADDR+1] = {8'hff, 8'h01, 8'hff, 8'h02};
    mem[`INTERFACE0_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};

    // Interface Descriptor 1 - 9 Bytes            
    mem[`INTERFACE1_DES_ROM_ADDR  ] = {8'h00, 8'h00, 8'h04, 8'h09};    
    mem[`INTERFACE1_DES_ROM_ADDR+1] = {8'hff, 8'h01, 8'hff, 8'h02};    
    mem[`INTERFACE1_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};

    // Interface Descriptor 2 - 9 Bytes             
    mem[`INTERFACE2_DES_ROM_ADDR  ] = {8'h00, 8'h00, 8'h04, 8'h09};     
    mem[`INTERFACE2_DES_ROM_ADDR+1] = {8'hff, 8'h01, 8'hff, 8'h02};     
    mem[`INTERFACE2_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};     

    // Interface Descriptor 3 - 9 Bytes     
    mem[`INTERFACE3_DES_ROM_ADDR  ] = {8'h00, 8'h00, 8'h04, 8'h09}; 
    mem[`INTERFACE3_DES_ROM_ADDR+1] = {8'hff, 8'h01, 8'hff, 8'h02}; 
    mem[`INTERFACE3_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00}; 

    // Interface Descriptor 4 - 9 Bytes     
    mem[`INTERFACE4_DES_ROM_ADDR  ] = {8'h00, 8'h00, 8'h04, 8'h09}; 
    mem[`INTERFACE4_DES_ROM_ADDR+1] = {8'hff, 8'h01, 8'hff, 8'h02}; 
    mem[`INTERFACE4_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00}; 

    // Interface Descriptor 5 - 9 Bytes     
    mem[`INTERFACE5_DES_ROM_ADDR  ] = {8'h00, 8'h00, 8'h04, 8'h09}; 
    mem[`INTERFACE5_DES_ROM_ADDR+1] = {8'hff, 8'h01, 8'hff, 8'h02}; 
    mem[`INTERFACE5_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00}; 

    // Interface Descriptor 6 - 9 Bytes     
    mem[`INTERFACE6_DES_ROM_ADDR  ] = {8'h00, 8'h00, 8'h04, 8'h09}; 
    mem[`INTERFACE6_DES_ROM_ADDR+1] = {8'hff, 8'h01, 8'hff, 8'h02}; 
    mem[`INTERFACE6_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00}; 
    
    // Interface Descriptor 7 - 9 Bytes     
    mem[`INTERFACE7_DES_ROM_ADDR  ] = {8'h00, 8'h00, 8'h04, 8'h09}; 
    mem[`INTERFACE7_DES_ROM_ADDR+1] = {8'hff, 8'h01, 8'hff, 8'h01}; 
    mem[`INTERFACE7_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};    
    
    `ifdef USBF_HAVE_EP1
      // Endpoint 1 Descriptor - 7 Bytes // BULK IN 512B
      mem[`EP1_DES_ROM_ADDR  ] = {8'h02, 8'h01, 8'h05, 8'h07};
      mem[`EP1_DES_ROM_ADDR+1] = {8'h00, 8'h01, 8'h02, 8'h00};
      // EP1 - GET_STATUS                   
      mem[`EP1_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};      
    `endif

    `ifdef USBF_HAVE_EP2
      // Endpoint 2 Descriptor - 7 Bytes // BULK OUT 512B
      mem[`EP2_DES_ROM_ADDR  ] = {8'h02, 8'h82, 8'h05, 8'h07};
      mem[`EP2_DES_ROM_ADDR+1] = {8'h00, 8'h01, 8'h02, 8'h00};
      // EP2 - GET_STATUS                   
      mem[`EP2_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};      
    `endif

    `ifdef USBF_HAVE_EP3
      // Endpoint 3 Descriptor - 7 Bytes // ISO IN 1024B
      mem[`EP3_DES_ROM_ADDR  ] = {8'h01, 8'h03, 8'h05, 8'h07};
      mem[`EP3_DES_ROM_ADDR+1] = {8'h00, 8'h01, 8'h04, 8'h00};
      // EP3 - GET_STATUS                   
      mem[`EP3_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};
    `endif

    `ifdef USBF_HAVE_EP4
      // Endpoint 4 Descriptor - 7 Bytes // ISO OUT 1024B
      mem[`EP4_DES_ROM_ADDR  ] = {8'h01, 8'h84, 8'h05, 8'h07};
      mem[`EP4_DES_ROM_ADDR+1] = {8'h00, 8'h01, 8'h04, 8'h00};
      // EP4 - GET_STATUS                   
      mem[`EP4_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};      
    `endif

    `ifdef USBF_HAVE_EP5
      // Endpoint 5 Descriptor - 7 Bytes // INT IN 1024B
      mem[`EP5_DES_ROM_ADDR  ] = {8'h03, 8'h05, 8'h05, 8'h07};
      mem[`EP5_DES_ROM_ADDR+1] = {8'h00, 8'h01, 8'h04, 8'h00};
      // EP5 - GET_STATUS                   
      mem[`EP5_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};      
    `endif

    `ifdef USBF_HAVE_EP6
      // Endpoint 6 Descriptor - 7 Bytes // INT OUT 1024B
      mem[`EP6_DES_ROM_ADDR  ] = {8'h03, 8'h86, 8'h05, 8'h07};
      mem[`EP6_DES_ROM_ADDR+1] = {8'h00, 8'h01, 8'h04, 8'h00};
      // EP6 - GET_STATUS                   
      mem[`EP6_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};      
    `endif

    `ifdef USBF_HAVE_EP7
      // Endpoint 7 Descriptor - 7 Bytes
      mem[`EP7_DES_ROM_ADDR  ] = {8'h02, 8'h07, 8'h05, 8'h07};
      mem[`EP7_DES_ROM_ADDR+1] = {8'h00, 8'h01, 8'h02, 8'h00};
      // EP7 - GET_STATUS                   
      mem[`EP7_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};      
    `endif

    `ifdef USBF_HAVE_EP8
      // Endpoint 8 Descriptor - 7 Bytes
      mem[`EP8_DES_ROM_ADDR  ] = {8'h02, 8'h88, 8'h05, 8'h07};
      mem[`EP8_DES_ROM_ADDR+1] = {8'h00, 8'h01, 8'h02, 8'h00};
      // EP8 - GET_STATUS                   
      mem[`EP8_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};      
    `endif

    `ifdef USBF_HAVE_EP9
      // Endpoint 9 Descriptor - 7 Bytes
      mem[`EP9_DES_ROM_ADDR  ] = {8'h01, 8'h09, 8'h05, 8'h07};
      mem[`EP9_DES_ROM_ADDR+1] = {8'h00, 8'h01, 8'h04, 8'h00};
      // EP9 - GET_STATUS                   
      mem[`EP9_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};      
    `endif

    `ifdef USBF_HAVE_EP10
      // Endpoint 10 Descriptor - 7 Bytes
      mem[`EP10_DES_ROM_ADDR  ] = {8'h01, 8'h8A, 8'h05, 8'h07};
      mem[`EP10_DES_ROM_ADDR+1] = {8'h00, 8'h01, 8'h04, 8'h00};
      // EP10 - GET_STATUS                   
      mem[`EP10_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};      
    `endif

    `ifdef USBF_HAVE_EP11
      // Endpoint 11 Descriptor - 7 Bytes
      mem[`EP11_DES_ROM_ADDR  ] = {8'h03, 8'h0B, 8'h05, 8'h07};
      mem[`EP11_DES_ROM_ADDR+1] = {8'h00, 8'h01, 8'h04, 8'h00};
      // EP11 - GET_STATUS                   
      mem[`EP11_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};      
    `endif

    `ifdef USBF_HAVE_EP12
      // Endpoint 12 Descriptor - 7 Bytes
      mem[`EP12_DES_ROM_ADDR  ] = {8'h03, 8'h8C, 8'h05, 8'h07};
      mem[`EP12_DES_ROM_ADDR+1] = {8'h00, 8'h01, 8'h04, 8'h00};
      // EP12 - GET_STATUS                   
      mem[`EP12_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};      
    `endif

    `ifdef USBF_HAVE_EP13
      // Endpoint 13 Descriptor - 7 Bytes
      mem[`EP13_DES_ROM_ADDR  ] = {8'h02, 8'h0D, 8'h05, 8'h07};
      mem[`EP13_DES_ROM_ADDR+1] = {8'h00, 8'h01, 8'h02, 8'h00};
      // EP13 - GET_STATUS                   
      mem[`EP13_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};      
    `endif

    `ifdef USBF_HAVE_EP14
      // Endpoint 14 Descriptor - 7 Bytes
      mem[`EP14_DES_ROM_ADDR  ] = {8'h02, 8'h8E, 8'h05, 8'h07};
      mem[`EP14_DES_ROM_ADDR+1] = {8'h00, 8'h01, 8'h02, 8'h00};
      // EP14 - GET_STATUS                   
      mem[`EP14_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};      
    `endif

    `ifdef USBF_HAVE_EP15
      // Endpoint 15 Descriptor - 7 Bytes
      mem[`EP15_DES_ROM_ADDR  ] = {8'h02, 8'h0F, 8'h05, 8'h07};
      mem[`EP15_DES_ROM_ADDR+1] = {8'h00, 8'h01, 8'h02, 8'h00};
      // EP15 - GET_STATUS                     
      mem[`EP15_DES_ROM_ADDR+2] = {8'h00, 8'h00, 8'h00, 8'h00};       
    `endif
 
    // DEVICE_GET_STATUS
    mem[`DEVICE_GET_STATUS_ROM_ADDR  ] = {8'h00, 8'h00, 8'h00, 8'h00}; // Remote Wakeup
    mem[`DEVICE_GET_STATUS_ROM_ADDR+1] = {8'h00, 8'h00, 8'h00, 8'h00}; // Self Powered

    // INTERFACE_GET_STATUS
    mem[`INTERFACE_GET_STATUS_ROM_ADDR] = {8'h00, 8'h00, 8'h00, 8'h00};
        
    // FRM_NAT
    mem[`EP_FRM_NAT] = {8'h00, 8'h00, 8'h00, 8'h00};
    
  end
  else if(we_ctrl_i)begin
    if(index_ctrl_i==2'd0)
      mem[address_ctrl_i] = {mem[address_ctrl_i][31:8], data_ctrl_i};
    else if(index_ctrl_i==2'd1)
      mem[address_ctrl_i] = {mem[address_ctrl_i][31:16], data_ctrl_i, mem[address_ctrl_i][7:0]};
    else if(index_ctrl_i==2'd2)
      mem[address_ctrl_i] = {mem[address_ctrl_i][31:24], data_ctrl_i, mem[address_ctrl_i][15:0]};
    else if(index_ctrl_i==2'd3)
      mem[address_ctrl_i] = {data_ctrl_i, mem[address_ctrl_i][23:0]};      
  end
  else if(we_i)
    mem[address_i] <= data_i;

end


endmodule

