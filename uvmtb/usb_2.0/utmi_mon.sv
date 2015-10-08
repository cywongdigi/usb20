class utmi_mon extends uvm_monitor;
	`uvm_component_utils(utmi_mon)
	virtual utmi_intf vif;
	uvm_analysis_port#(base_pkt) ap;
	function new(string name="", uvm_component parent);
		super.new(name, parent);
		ap = new("ap", this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual utmi_intf)::get(this, "", "utmi_vif", vif);
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info("UTMI_MON", "run_phase", UVM_LOW);
             collect_data_utmi();
	endtask

        task collect_data_utmi();
           reg [7:0] if_data_utmi;
             @(posedge vif.phy_clk_i);
             if(vif.TxValid_o) begin
             if_data_utmi = vif.DataOut_o;
             end
        endtask
             
endclass
