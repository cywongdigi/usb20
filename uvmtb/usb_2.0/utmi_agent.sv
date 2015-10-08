class utmi_agent extends uvm_agent;
	utmi_mon mon;
	utmi_driver driver;
	utmi_sqr sqr;
	utmi_cov cov;
	`uvm_component_utils(utmi_agent)
	function new(string name="", uvm_component parent);
		super.new(name, parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		mon = utmi_mon::type_id::create("mon", this);
		driver = utmi_driver::type_id::create("driver", this);
		sqr = utmi_sqr::type_id::create("sqr", this);
		cov = utmi_cov::type_id::create("cov", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		driver.seq_item_port.connect(sqr.seq_item_export);
		mon.ap.connect(cov.analysis_export);
	endfunction
endclass
