class wb_sqr extends uvm_sequencer#(wb_tx);
	`uvm_component_utils(wb_sqr)
	function new(string name="", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
endclass



