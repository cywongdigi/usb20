interface utmi_intf(input logic phy_clk_i);
logic		phy_rst_o;

logic	[7:0]	DataOut_o;
logic		TxValid_o;
logic		TxReady_i;

logic	[7:0]	DataIn_i;
logic		RxValid_i;
logic		RxActive_i;
logic		RxError_i;

logic		XcvSelect_o;
logic		TermSel_o;
logic		SuspendM_o;
logic	[1:0]	LineState_i;
logic	[1:0]	OpMode_o;
logic		usb_vbus_i;
logic		VControl_Load_o;
logic	[3:0]	VControl_o;
logic	[7:0]	VStatus_i;
endinterface
