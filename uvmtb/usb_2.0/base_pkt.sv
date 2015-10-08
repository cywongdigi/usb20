class base_pkt extends uvm_transaction;

rand bit phy_rst_o;
rand bit [7:0]	DataOut_o;
rand bit TxValid_o;
rand bit TxReady_i;
rand bit [7:0]	DataIn_i;
rand bit RxValid_i;
rand bit RxActive_i;
rand bit RxError_i;
rand bit XcvSelect_o;
rand bit TermSel_o;
rand bit SuspendM_o;
rand bit [1:0]	LineState_i;
rand bit [1:0]	OpMode_o;
rand bit usb_vbus_i;
rand bit VControl_Load_o;
rand bit [3:0]	VControl_o;
rand bit [7:0]	VStatus_i;
	
       
	function new(string name="");
		super.new(name);
	endfunction

        `uvm_object_utils(base_pkt) begin
        `uvm_field_int(phy_rst_o, UVM_ALL_ON|UVM_NOPACK) 
        `uvm_field_int(DataOut_o, UVM_ALL_ON|UVM_NOPACK)
        `uvm_field_int(TxValid_o, UVM_ALL_ON|UVM_NOPACK)
        `uvm_field_int(TxReady_i, UVM_ALL_ON|UVM_NOPACK)
        `uvm_field_int(DataIn_i, UVM_ALL_ON|UVM_NOPACK)
	`uvm_field_int(RxValid_i, UVM_ALL_ON|UVM_NOPACK)
	`uvm_field_int(RxActive_i, UVM_ALL_ON|UVM_NOPACK)
	`uvm_field_int(RxError_i, UVM_ALL_ON|UVM_NOPACK)
	`uvm_field_int(XcvSelect_o, UVM_ALL_ON|UVM_NOPACK)
	`uvm_field_int(TermSel_o, UVM_ALL_ON|UVM_NOPACK)
	`uvm_field_int(SuspendM_o, UVM_ALL_ON|UVM_NOPACK)
	`uvm_field_int(LineState_i, UVM_ALL_ON|UVM_NOPACK)
	`uvm_field_int(OpMode_o, UVM_ALL_ON|UVM_NOPACK)
	`uvm_field_int(usb_vbus_i, UVM_ALL_ON|UVM_NOPACK)
	`uvm_field_int(VControl_Load_o, UVM_ALL_ON|UVM_NOPACK)
	`uvm_field_int(VControl_o, UVM_ALL_ON|UVM_NOPACK)
	`uvm_field_int(VStatus_i, UVM_ALL_ON|UVM_NOPACK)
        `uvm_object_utils_end

endclass
