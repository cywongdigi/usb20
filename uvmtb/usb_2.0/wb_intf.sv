interface wb_intf(input logic clk_i, rst_i);
logic	[`USBF_UFC_HADR:0]	wb_addr_i;
logic	[31:0]	wb_data_i;
logic	[31:0]	wb_data_o;
logic		wb_ack_o;
logic		wb_we_i;
logic		wb_stb_i;
logic		wb_cyc_i;
logic		inta_o;
logic		intb_o;
logic	[15:0]	dma_req_o;
logic	[15:0]	dma_ack_i;
logic		susp_o;
logic		resume_req_i;
endinterface
