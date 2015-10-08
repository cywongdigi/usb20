class usb_top_sqr extends uvm_sequencer;
	utmi_sqr usqr;
	wb_sqr wsqr;
	`uvm_component_utils(usb_top_sqr)
	function new(string name = "", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
endclass
