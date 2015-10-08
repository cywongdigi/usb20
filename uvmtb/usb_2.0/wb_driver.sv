class wb_driver extends uvm_driver#(wb_tx);
	`uvm_component_utils(wb_driver)
	virtual wb_intf vif;
	usb_config usb_cfg;
	function new(string name="", uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual wb_intf)::get(this, "", "wb_vif", vif);
		uvm_config_db#(usb_config)::get(this, "", "config", usb_cfg);
		usb_cfg.vif = vif;
	endfunction

	task run_phase(uvm_phase phase);
	wait(vif.rst_i == 1);
	`uvm_info("WB_DRV", "run_phase", UVM_LOW);
	while(1) begin
		seq_item_port.get_next_item(req);
		drive_transfer(req); 
		seq_item_port.item_done();
	end
	endtask

	task drive_transfer(wb_tx tx);
		@(posedge vif.clk_i);
		vif.wb_addr_i = tx.addr;
		vif.wb_we_i = tx.we;
		vif.wb_cyc_i = 1'b1;
		vif.wb_stb_i = 1'b1;
		//vif.wb_sel_i = 4'hF;
		if (tx.we == 1) begin
			vif.wb_data_i = tx.data;
		end
		@(posedge vif.wb_ack_o);
		vif.wb_cyc_i = 1'b0;
		vif.wb_stb_i = 1'b0;
		vif.wb_data_i = 32'b0;
		tx.data = vif.wb_data_o;
		tx.print();
	endtask
endclass


