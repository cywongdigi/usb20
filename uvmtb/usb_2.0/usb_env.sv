class usb_env extends uvm_env;
	utmi_agent utmi_agent_i;
	wb_agent wb_agent_i;
	usb_sbd usb_sbd_i;
	`uvm_component_utils(usb_env)
	function new(string name="", uvm_component parent);
		super.new(name, parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		utmi_agent_i = utmi_agent::type_id::create("utmi_agent_i", this);
		wb_agent_i = wb_agent::type_id::create("wb_agent_i", this);
		usb_sbd_i = usb_sbd::type_id::create("usb_sbd_i", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		//utmi_agent_i.mon.ap.connect(usb_sbd_i.imp_utmi);
		//wb_agent_i.mon.ap.connect(usb_sbd_i.imp_wb);
	endfunction

endclass
