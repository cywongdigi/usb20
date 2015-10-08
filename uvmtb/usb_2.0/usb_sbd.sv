class usb_sbd extends uvm_scoreboard;
	
        uvm_analysis_export   # (wb_tx) wb_export ;
        uvm_analysis_export   # (base_pkt) utmi_export;
        uvm_tlm_analysis_fifo # (wb_tx) wb_fifo;
        uvm_tlm_analysis_fifo # (base_pkt) utmi_fifo;

        wb_tx trans_wb;
        base_pkt trans_utmi;
        wb_tx trans_wb_q[$]; 
        base_pkt trans_utmi_q[$];

        `uvm_component_utils(usb_sbd)

	function new(string name="", uvm_component parent);
		super.new(name, parent);
	endfunction

        function void build phase(uvm_phase phase);
                super.build-phase(phase);
                `uvm_info("build_phase","Entered...",UVM_HIGH);
                // Analysis port creation
                wb_export = new ("wb_export",this);
                utmi_export  = new ("utmi_port",this);
                wb_fifo   = new("wb_fifo", this);
                utmi_fifo    = new("utmi_fifo", this);  
                `uvm_info("build_phase","Exit...",UVM_HIGH) 
        endfunction : build_phase

        function void connect_phase(uvm_phase phase);
                super.connect_phase(phase);
                wb_export.connect(wb_fifo.analysis_export);
                utmi_export.connect(utmi_fifo.analysis_export);
        endfunction : connect_phase

        function void check_phase(uvm_phase phase);
                `uvm_info("check_phase", "Entered...", UVM_HIGH) 
                `uvm_info("check_phase", "Exit...", UVM_HIGH)  
        endfunction : check_phase

        task run_phase(uvm_phase phase);
                super.run_phase(phase);
                forever begin
                    fork 
                       begin
                        wait(trans_wb_q.size()>0);
                        trans_wb = trans_wb_q.pop_front();
                       end
                       begin
                        wait(trans_utmi_q.size()>0);
                        trans_utmi = trans_utmi_q.pop_front();
                       end
                    join

                    if(trans_wb.compare(trans_utmi))
                       begin
                       `uvm_info("Transactions are Matched", "TEST CASE PASSED", UVM_LOW)
                       end
                    else 
                       begin
                       `uvm_error("Transactions are not matched", "TEST CASE FAILED")
                       end
                end

       endtask : run_phase

       function void report_phase(uvm_phase phase);
       endfunction : report_phase
        
endclass
