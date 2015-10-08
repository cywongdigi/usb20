class usb_base_seq extends uvm_sequence;
	`uvm_object_utils(usb_base_seq)
	`uvm_declare_p_sequencer(usb_top_sqr)
	wb_bulk_config_seq  cfg_seq;
	utmi_bulk_seq  bulk_seq;
	wb_int_seq     int_seq;

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

class usb_bulk_seq extends usb_base_seq;
	`uvm_object_utils(usb_bulk_seq)
	function new(string name="");
		super.new(name);
	endfunction

	task body();
		`uvm_do_on(cfg_seq, p_sequencer.wsqr);
		fork
			`uvm_do_on(bulk_seq, p_sequencer.usqr);
			`uvm_do_on(int_seq, p_sequencer.wsqr);
		join
	endtask
endclass

