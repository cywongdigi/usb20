class wb_tx extends uvm_sequence_item;
	rand bit [31:0] addr;
	rand bit [31:0] data;
	rand bit we;
	`uvm_object_utils_begin(wb_tx)
		`uvm_field_int(addr, UVM_ALL_ON)
		`uvm_field_int(data, UVM_ALL_ON)
		`uvm_field_int(we, UVM_ALL_ON)
	`uvm_object_utils_end
	function new(string name="");
		super.new(name);
	endfunction
endclass

