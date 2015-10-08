class usb_base_test extends uvm_test;
	usb_env env;
	usb_reg_block usb_rm;
	usb_config usb_cfg;
	reg2wb_adapter reg2wb;
	usb_top_sqr top_sqr;
	`uvm_component_utils(usb_base_test)
	function new(string name="", uvm_component parent);
		super.new(name, parent);
	endfunction
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
    		reg2wb = reg2wb_adapter::type_id::create("reg2wb");
		env = usb_env::type_id::create("env", this);
		usb_rm = usb_reg_block::type_id::create("usb_rm");
		usb_rm.build();
		uvm_config_db#(usb_config)::get(this, "", "config", usb_cfg);
		usb_cfg.usb_rm = usb_rm;

		top_sqr = usb_top_sqr::type_id::create("top_sqr", this);
      		//usb_cfg.usb_rm.wb_map.set_sequencer(env.wb_agent_i.sqr, reg2wb);

		//uvm_config_db#(uvm_object_wrapper)::set(this, "env.wb_agent_i.sqr.configure_phase", "default_sequence", wb_config_seq::type_id::get());
		phase.phase_done.set_drain_time(this, 500);
	endfunction

	function void connect_phase(uvm_phase phase);
	   super.connect_phase(phase);
	   top_sqr.usqr = env.utmi_agent_i.sqr;
	   top_sqr.wsqr = env.wb_agent_i.sqr;
    	   if(usb_cfg.usb_rm.get_parent() == null) begin
		`uvm_info("TEST_LIB", "connect_phase", UVM_LOW);
      		usb_cfg.usb_rm.wb_map.set_sequencer(env.wb_agent_i.sqr, reg2wb);
    	   end
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info("TEST", "run_phase", UVM_LOW);
	endtask
endclass

class usb_reset_test extends usb_base_test;
	`uvm_component_utils(usb_reset_test)
	function new(string name="", uvm_component parent);
		super.new(name, parent);
	endfunction
	function void build_phase(uvm_phase phase);
		uvm_config_db#(uvm_object_wrapper)::set(this, "env.wb_agent_i.sqr.configure_phase", "default_sequence", wb_reset_seq::type_id::get());
		super.build_phase(phase);
	endfunction
endclass

class usb_wr_rd_test extends usb_base_test;
	`uvm_component_utils(usb_wr_rd_test)
	function new(string name="", uvm_component parent);
		super.new(name, parent);
	endfunction
	function void build_phase(uvm_phase phase);
		uvm_config_db#(uvm_object_wrapper)::set(this, "env.wb_agent_i.sqr.configure_phase", "default_sequence", wb_wr_rd_seq::type_id::get());
		super.build_phase(phase);
	endfunction
endclass


class usb_config_test extends usb_base_test;
	`uvm_component_utils(usb_config_test)
	function new(string name="", uvm_component parent);
		super.new(name, parent);
	endfunction
	function void build_phase(uvm_phase phase);
		uvm_config_db#(uvm_object_wrapper)::set(this, "env.wb_agent_i.sqr.configure_phase", "default_sequence", wb_config_seq::type_id::get());
		super.build_phase(phase);
	endfunction
endclass

/*
class usb_bulk_test extends usb_base_test;
	`uvm_component_utils(usb_bulk_test)
	function new(string name="", uvm_component parent);
		super.new(name, parent);
	endfunction
	function void build_phase(uvm_phase phase);
		uvm_config_db#(uvm_object_wrapper)::set(this, "env.wb_agent_i.sqr.configure_phase", "default_sequence", wb_bulk_config_seq::type_id::get());
		uvm_config_db#(uvm_object_wrapper)::set(this, "env.utmi_agent_i.sqr.configure_phase", "default_sequence", utmi_bulk_seq::type_id::get());
		super.build_phase(phase);
	endfunction
endclass
*/

class usb_bulk_test extends usb_base_test;
	`uvm_component_utils(usb_bulk_test)
	function new(string name="", uvm_component parent);
		super.new(name, parent);
	endfunction
	function void build_phase(uvm_phase phase);
		uvm_config_db#(uvm_object_wrapper)::set(this, "top_sqr.main_phase", "default_sequence", usb_bulk_seq::type_id::get());
		super.build_phase(phase);
	endfunction
endclass
