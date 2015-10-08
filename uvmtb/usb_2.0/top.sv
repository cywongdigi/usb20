module top;
reg wb_clk, wb_rst;
reg utmi_clk;
usb_config usb_cfg;
//dut instnace
usbf_top dut(
	// WISHBONE Interface signal connection
		.clk_i(wvif.clk_i), .rst_i(wvif.rst_i), .wb_addr_i(wvif.wb_addr_i), .wb_data_i(wvif.wb_data_i), .wb_data_o(wvif.wb_data_o),
		.wb_ack_o(wvif.wb_ack_o), .wb_we_i(wvif.wb_we_i), .wb_stb_i(wvif.wb_stb_i), .wb_cyc_i(wvif.wb_cyc_i), .inta_o(wvif.inta_o), .intb_o(wvif.intb_o),
		.dma_req_o(wvif.dma_req_o), .dma_ack_i(wvif.dma_ack_i), .susp_o(wvif.susp_o), .resume_req_i(wvif.resume_req_i),

		// UTMI Interface
		.phy_clk_pad_i(uvif.phy_clk_i), .phy_rst_pad_o(uvif.phy_rst_o),
		.DataOut_pad_o(uvif.DataOut_o), .TxValid_pad_o(uvif.TxValid_o), .TxReady_pad_i(uvif.TxReady_i),

		.RxValid_pad_i(uvif.RxValid_i), .RxActive_pad_i(uvif.RxActive_i), .RxError_pad_i(uvif.RxError_i),
		.DataIn_pad_i(uvif.DataIn_i), .XcvSelect_pad_o(uvif.XcvSelect_o), .TermSel_pad_o(uvif.TermSel_o),
		.SuspendM_pad_o(uvif.SuspendM_o), .LineState_pad_i(uvif.LineState_i),

		.OpMode_pad_o(uvif.OpMode_o), .usb_vbus_pad_i(uvif.usb_vbus_i),
		.VControl_Load_pad_o(uvif.VControl_Load_o), .VControl_pad_o(uvif.VControl_o), .VStatus_pad_i(uvif.VStatus_i),

		// Buffer Memory Interface
		.sram_adr_o(svif.sram_adr_o), .sram_data_i(svif.sram_data_i), .sram_data_o(svif.sram_data_o), .sram_re_o(svif.sram_re_o), .sram_we_o(svif.sram_we_o)
		);


//interface instance
wb_intf wvif(wb_clk, wb_rst);
utmi_intf uvif(utmi_clk);

initial begin
	uvm_config_db#(virtual utmi_intf)::set(uvm_root::get(), "*", "utmi_vif", uvif);
	uvm_config_db#(virtual wb_intf)::set(uvm_root::get(), "*", "wb_vif", wvif);
end

initial begin
	wb_clk = 0;
	forever #5ns wb_clk = ~wb_clk;
end
initial begin
	utmi_clk = 0;
	forever #8.33ns utmi_clk = ~utmi_clk;
end

initial begin
	wb_rst = 0;
	wvif.wb_addr_i = 0;
	wvif.wb_data_i = 0;
	wvif.wb_we_i = 0;
	wvif.wb_stb_i = 0;
	wvif.wb_cyc_i = 0;
	wvif.dma_ack_i = 0;
	wvif.resume_req_i = 0;

	uvif.TxReady_i = 0;
	uvif.DataIn_i = 0;
	uvif.RxValid_i = 0;
	uvif.RxActive_i = 0;
	uvif.RxError_i = 0;
	uvif.LineState_i = 0;
	uvif.usb_vbus_i = 0;
	uvif.VStatus_i = 0;

	repeat(10) @(posedge wb_clk);
	wb_rst = 1;
end

`include "test_lib.sv"

initial begin
	run_test();
end

initial begin
	usb_cfg = new();
	uvm_config_db#(usb_config)::set(uvm_root::get(), "*", "config", usb_cfg);
end


endmodule
//60MHZ = 60 * 10^6 = 1/6*10^7 = 100/6ns = 16.66ns Time period
//100MHZ = 100 * 10^6 = 1/10*10^7 = 100/6ns = 10ns Time period
