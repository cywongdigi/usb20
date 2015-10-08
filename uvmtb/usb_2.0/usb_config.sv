`define	SOF  4'b0101
`define	IN  4'b1001
`define	OUT  4'b0001
`define	SETUP  4'b1101
class usb_config;
	usb_reg_block usb_rm;
	virtual wb_intf vif;
endclass
