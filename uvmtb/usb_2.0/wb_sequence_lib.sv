class wb_base_seq extends uvm_sequence#(wb_tx);
	`uvm_object_utils(wb_base_seq)
	uvm_reg regs[$];
	usb_config usb_cfg;
	usb_reg_block usb_rm;
	rand  uvm_reg_data_t data; 
	rand  uvm_reg_data_t ref_data; 
	uvm_status_e status;       
	function new(string name="");
		super.new(name);
	endfunction
	task pre_body();
		if (this.starting_phase != null) begin
			this.starting_phase.raise_objection(this);
		end
	endtask
	task post_body();
		if (this.starting_phase != null) begin
			this.starting_phase.drop_objection(this);
		end
	endtask
endclass

class wb_config_seq extends wb_base_seq;
	`uvm_object_utils(wb_config_seq)
	function new(string name="");
		super.new(name);
	endfunction
	task body();
		`uvm_info("WB_CONFIG_SEQ", "body", UVM_LOW);
		uvm_config_db#(usb_config)::get(null, get_full_name(), "config", usb_cfg);
		usb_rm = usb_cfg.usb_rm;
		this.randomize();
  		usb_rm.fa.write(status, data, .parent(this));
		this.randomize();
  		usb_rm.int_msk.write(status, data, .parent(this));
		this.randomize();
  		usb_rm.ep_buf0[8].write(status, data, .parent(this));
		this.randomize();
  		usb_rm.ep_buf1[10].write(status, data, .parent(this));

  		usb_rm.int_msk.read(status, data, .parent(this));
  		usb_rm.fa.read(status, data, .parent(this));
  		usb_rm.ep_buf1[10].read(status, data, .parent(this));
  		usb_rm.ep_buf0[8].read(status, data, .parent(this));
	endtask
endclass

class wb_reset_seq extends wb_base_seq;
	`uvm_object_utils(wb_reset_seq)
	function new(string name="");
		super.new(name);
	endfunction
	task body();
		`uvm_info("WB_RESET_SEQ", "body", UVM_LOW);
		uvm_config_db#(usb_config)::get(null, get_full_name(), "config", usb_cfg);
		usb_rm = usb_cfg.usb_rm;
		usb_rm.get_registers(regs);
		foreach(regs[i]) begin
			ref_data = regs[i].get_reset();
			regs[i].read(status, data, .parent(this));
    			if(ref_data != data) begin
      				`uvm_error("REG_TEST_SEQ:", $sformatf("Reset read error for %s: Expected: %0h Actual: %0h", regs[i].get_name(), ref_data, data))
      				//errors++;
    			end
		end
	endtask
endclass

class wb_wr_rd_seq extends wb_base_seq;
	`uvm_object_utils(wb_wr_rd_seq)
	function new(string name="");
		super.new(name);
	endfunction
	task body();
		`uvm_info("WB_RESET_SEQ", "body", UVM_LOW);
		uvm_config_db#(usb_config)::get(null, get_full_name(), "config", usb_cfg);
		usb_rm = usb_cfg.usb_rm;
		usb_rm.get_registers(regs);
		foreach(regs[i]) begin
  			if(!this.randomize()) begin
    				`uvm_error("body", "Randomization error for this")
  			end
			regs[i].write(status, data, .parent(this));
		end
		//regs.shuffle();
		foreach(regs[i]) begin
			regs[i].read(status, data, .parent(this));
			ref_data = regs[i].get();
    			if(ref_data != data) begin
      				`uvm_error("REG_TEST_SEQ:", $sformatf("Reset read error for %s: Expected: %0h Actual: %0h", regs[i].get_name(), ref_data, data))
    			end
		end
	endtask
endclass

class wb_bulk_config_seq extends wb_base_seq;
	`uvm_object_utils(wb_bulk_config_seq)
	function new(string name="");
		super.new(name);
	endfunction
	task body();
		`uvm_info("WB_BULK_CONFIG_SEQ", "body", UVM_LOW);
		uvm_config_db#(usb_config)::get(null, get_full_name(), "config", usb_cfg);
		usb_rm = usb_cfg.usb_rm;

		//FA : h'29
		data = 32'h29;
  		usb_rm.fa.write(status, data, .parent(this));

		this.randomize();
  		usb_rm.int_msk.write(status, data, .parent(this));

		//EP0, EP1, EP2
		data = {4'b0, 2'b0, 2'b11, 2'b0, 4'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 2'b0, 11'h080}; //EP0_CSR
  		usb_rm.ep_csr[0].write(status, data, .parent(this));

		data = {1'b0, 14'h1000, 17'h0}; //EP0_BUF0
  		usb_rm.ep_buf0_reg_i.write(status, data, .parent(this));

		data = {1'b0, 14'h1000, 17'h1000}; //EP0_BUF1
  		usb_rm.ep_buf1[0].write(status, data, .parent(this));

		//EP1
		data = {4'b0, 2'b01, 2'b10, 2'b0, 4'b01, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 2'b0, 11'h00A}; //EP1_CSR
		//data = {4'b0, 2'b01, 2'b10, 2'b0, 4'b01, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 2'b0, 11'h080}; //EP1_CSR
  		usb_rm.ep_csr[1].write(status, data, .parent(this));

		data = {1'b0, 14'h1000, 17'h2000}; //EP1_BUF0
  		usb_rm.ep_buf0[1].write(status, data, .parent(this));

		data = {1'b0, 14'h1000, 17'h3000}; //EP1_BUF1
  		usb_rm.ep_buf1[1].write(status, data, .parent(this));

		//EP2
		data = {4'b0, 2'b10, 2'b10, 2'b0, 4'b10, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 2'b0, 11'h00A}; //EP2_CSR
		//data = {4'b0, 2'b10, 2'b10, 2'b0, 4'b10, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 2'b0, 11'h080}; //EP2_CSR
  		usb_rm.ep_csr[2].write(status, data, .parent(this));

		data = {1'b0, 14'h1000, 17'h4000}; //EP2_BUF0
  		usb_rm.ep_buf0[2].write(status, data, .parent(this));

		data = {1'b0, 14'h1000, 17'h5000}; //EP2_BUF1
  		usb_rm.ep_buf1[2].write(status, data, .parent(this));
	endtask
endclass

class wb_int_seq extends wb_base_seq;
	`uvm_object_utils(wb_int_seq)
	virtual wb_intf vif;

	function new(string name="");
		super.new(name);
	endfunction
	task body();
		//uvm_config_db#(virtual wb_intf)::get(this, get_full_name(), "wb_vif", vif);
		uvm_config_db#(usb_config)::get(null, get_full_name(), "config", usb_cfg);
		usb_rm = usb_cfg.usb_rm;
		vif = usb_cfg.vif;
		`uvm_info("WB_INT_SEQ", "body", UVM_LOW);
		while(1) begin
			@(posedge vif.clk_i);
			if (vif.inta_o || vif.intb_o) begin
				usb_rm.int_src.read(status, data, .parent(this));
				$display("int_src data = %h", data);
			end
		end
	endtask
endclass

