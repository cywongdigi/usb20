class wb_agent extends uvm_agent;
	wb_mon mon;
	wb_driver driver;
	wb_sqr sqr;
	wb_cov cov;
	`uvm_component_utils(wb_agent)
	function new(string name="", uvm_component parent);
		super.new(name, parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon = wb_mon::type_id::create("mon", this);
		driver = wb_driver::type_id::create("driver", this);
		sqr = wb_sqr::type_id::create("sqr", this);
		cov = wb_cov::type_id::create("cov", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		driver.seq_item_port.connect(sqr.seq_item_export);
		mon.ap.connect(cov.analysis_export);
	endfunction
endclass

