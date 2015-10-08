class wb_mon extends uvm_monitor;
	`uvm_component_utils(wb_mon)
	virtual wb_intf vif;
	uvm_analysis_port#(wb_tx) ap;
	function new(string name="", uvm_component parent);
		super.new(name, parent);
		ap = new("ap", this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db#(virtual wb_intf)::get(this, "", "wb_vif", vif);
	endfunction

	task run_phase(uvm_phase phase);
		`uvm_info("WB_MON", "run_phase", UVM_LOW);
                collect_data_wb();
	endtask

        task collect_data_wb();
           reg [31:0] data_w_wb;
           reg [31:0] data_r_wb;
        
                @posedge vif.clk_i);
                if(vif.wb_we_i == 1) begin
                data_w_wb = vif.wb_data_i;
                end 
                else begin
                data_r_wb = vif.wb_data_o
                end
        endtask
                
endclass

