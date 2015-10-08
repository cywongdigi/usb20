//TODO : hdl path for ep_int onwards
class csr_reg extends uvm_reg;
	`uvm_object_utils(csr_reg)
	uvm_reg_field line_state;
	uvm_reg_field intf_status;
	uvm_reg_field intf_speed;
	uvm_reg_field susp_mode;


      function new(string name = "csr_reg");
         super.new(name, 5, UVM_NO_COVERAGE);
      endfunction

      //--------------------------------------------------------------------
      // build
      //--------------------------------------------------------------------
      virtual function void build();
         line_state = uvm_reg_field::type_id::create("line_state");
         intf_status = uvm_reg_field::type_id::create("intf_status");
         intf_speed = uvm_reg_field::type_id::create("intf_speed");
         susp_mode = uvm_reg_field::type_id::create("susp_mode");
         line_state.configure(this, 2, 3, "RO", 1, 2'h0, 1, 1, 0);
         intf_status.configure(this, 1, 2, "RO", 1, 1'h0, 1, 1, 0);
         intf_speed.configure(this, 1, 1, "RO", 1, 1'h0, 1, 1, 0);
         susp_mode.configure(this, 1, 0, "RO", 1, 1'h0, 1, 1, 0);
      endfunction
endclass

class fa_reg extends uvm_reg;
	`uvm_object_utils(fa_reg)
rand 	uvm_reg_field fa;
      function new(string name = "fa_reg");
         super.new(name, 7, UVM_NO_COVERAGE);
      endfunction

      virtual function void build();
         fa = uvm_reg_field::type_id::create("fa");
         fa.configure(this, 7, 0, "RW", 1, 7'h0, 1, 1, 0);
      endfunction
endclass

class int_msk_reg extends uvm_reg;
	`uvm_object_utils(int_msk_reg)
	rand uvm_reg_field usb_reset_inta;
	rand uvm_reg_field rx_error_inta;
	rand uvm_reg_field detached_inta;
	rand uvm_reg_field attached_inta;
	rand uvm_reg_field leave_susp_inta;
	rand uvm_reg_field enter_susp_inta;
	rand uvm_reg_field no_ep_inta;
	rand uvm_reg_field pid_error_inta;
	rand uvm_reg_field crc_error_inta;

	rand uvm_reg_field usb_reset_intb;
	rand uvm_reg_field rx_error_intb;
	rand uvm_reg_field detached_intb;
	rand uvm_reg_field attached_intb;
	rand uvm_reg_field leave_susp_intb;
	rand uvm_reg_field enter_susp_intb;
	rand uvm_reg_field no_ep_intb;
	rand uvm_reg_field pid_error_intb;
	rand uvm_reg_field crc_error_intb;


      function new(string name = "int_msk_reg");
         super.new(name, 25, UVM_NO_COVERAGE);
      endfunction

      //--------------------------------------------------------------------
      // build
      //--------------------------------------------------------------------
      virtual function void build();
         usb_reset_inta = uvm_reg_field::type_id::create("usb_reset_inta");
         rx_error_inta = uvm_reg_field::type_id::create("rx_error_inta");
         detached_inta = uvm_reg_field::type_id::create("detached_inta");
         attached_inta = uvm_reg_field::type_id::create("attached_inta");
         leave_susp_inta = uvm_reg_field::type_id::create("leave_susp_inta");
         enter_susp_inta = uvm_reg_field::type_id::create("enter_susp_inta");
         no_ep_inta = uvm_reg_field::type_id::create("no_ep_inta");
         pid_error_inta = uvm_reg_field::type_id::create("pid_error_inta");
         crc_error_inta = uvm_reg_field::type_id::create("crc_error_inta");

         usb_reset_intb = uvm_reg_field::type_id::create("usb_reset_intb");
         rx_error_intb = uvm_reg_field::type_id::create("rx_error_intb");
         detached_intb = uvm_reg_field::type_id::create("detached_intb");
         attached_intb = uvm_reg_field::type_id::create("attached_intb");
         leave_susp_intb = uvm_reg_field::type_id::create("leave_susp_intb");
         enter_susp_intb = uvm_reg_field::type_id::create("enter_susp_intb");
         no_ep_intb = uvm_reg_field::type_id::create("no_ep_intb");
         pid_error_intb = uvm_reg_field::type_id::create("pid_error_intb");
         crc_error_intb = uvm_reg_field::type_id::create("crc_error_intb");

         usb_reset_inta.configure(this, 1, 24, "RW", 1, 1'h0, 1, 1, 0);
         rx_error_inta.configure(this, 1, 23, "RW", 1, 1'h0, 1, 1, 0);
         detached_inta.configure(this, 1, 22, "RW", 1, 1'h0, 1, 1, 0);
         attached_inta.configure(this, 1, 21, "RW", 1, 1'h0, 1, 1, 0);
         leave_susp_inta.configure(this, 1, 20, "RW", 1, 1'h0, 1, 1, 0);
         enter_susp_inta.configure(this, 1, 19, "RW", 1, 1'h0, 1, 1, 0);
         no_ep_inta.configure(this, 1, 18, "RW", 1, 1'h0, 1, 1, 0);
         pid_error_inta.configure(this, 1, 17, "RW", 1, 1'h0, 1, 1, 0);
         crc_error_inta.configure(this, 1, 16, "RW", 1, 1'h0, 1, 1, 0);

         usb_reset_intb.configure(this, 1, 8, "RW", 1, 1'h0, 1, 1, 0);
         rx_error_intb.configure(this, 1, 7, "RW", 1, 1'h0, 1, 1, 0);
         detached_intb.configure(this, 1, 6, "RW", 1, 1'h0, 1, 1, 0);
         attached_intb.configure(this, 1, 5, "RW", 1, 1'h0, 1, 1, 0);
         leave_susp_intb.configure(this, 1, 4, "RW", 1, 1'h0, 1, 1, 0);
         enter_susp_intb.configure(this, 1, 3, "RW", 1, 1'h0, 1, 1, 0);
         no_ep_intb.configure(this, 1, 2, "RW", 1, 1'h0, 1, 1, 0);
         pid_error_intb.configure(this, 1, 1, "RW", 1, 1'h0, 1, 1, 0);
         crc_error_intb.configure(this, 1, 0, "RW", 1, 1'h0, 1, 1, 0);
      endfunction
endclass

class int_src_reg extends uvm_reg;
	`uvm_object_utils(int_src_reg)
	rand uvm_reg_field usb_reset;
	rand uvm_reg_field rx_error;
	rand uvm_reg_field detached;
	rand uvm_reg_field attached;
	rand uvm_reg_field resume;
	rand uvm_reg_field suspend;
	rand uvm_reg_field no_ep;
	rand uvm_reg_field pid_error;
	rand uvm_reg_field crc_error;

	rand uvm_reg_field ep15_int;
	rand uvm_reg_field ep14_int;
	rand uvm_reg_field ep13_int;
	rand uvm_reg_field ep12_int;
	rand uvm_reg_field ep11_int;
	rand uvm_reg_field ep10_int;
	rand uvm_reg_field ep9_int;
	rand uvm_reg_field ep8_int;
	rand uvm_reg_field ep7_int;
	rand uvm_reg_field ep6_int;
	rand uvm_reg_field ep5_int;
	rand uvm_reg_field ep4_int;
	rand uvm_reg_field ep3_int;
	rand uvm_reg_field ep2_int;
	rand uvm_reg_field ep1_int;
	rand uvm_reg_field ep0_int;


      function new(string name = "int_src_reg");
         super.new(name, 29, UVM_NO_COVERAGE);
      endfunction

      //--------------------------------------------------------------------
      // build
      //--------------------------------------------------------------------
      virtual function void build();
         usb_reset = uvm_reg_field::type_id::create("usb_reset");
         rx_error = uvm_reg_field::type_id::create("rx_error");
         detached = uvm_reg_field::type_id::create("detached");
         attached = uvm_reg_field::type_id::create("attached");
         resume = uvm_reg_field::type_id::create("resume");
         suspend = uvm_reg_field::type_id::create("suspend");
         no_ep = uvm_reg_field::type_id::create("no_ep");
         pid_error= uvm_reg_field::type_id::create("pid_error");
         crc_error= uvm_reg_field::type_id::create("crc_error");

         ep15_int = uvm_reg_field::type_id::create("ep15_int");
         ep14_int = uvm_reg_field::type_id::create("ep14_int");
         ep13_int = uvm_reg_field::type_id::create("ep13_int");
         ep12_int = uvm_reg_field::type_id::create("ep12_int");
         ep11_int = uvm_reg_field::type_id::create("ep11_int");
         ep10_int = uvm_reg_field::type_id::create("ep10_int");
         ep9_int = uvm_reg_field::type_id::create("ep9_int");
         ep8_int = uvm_reg_field::type_id::create("ep8_int");
         ep7_int = uvm_reg_field::type_id::create("ep7_int");
         ep6_int = uvm_reg_field::type_id::create("ep6_int");
         ep5_int = uvm_reg_field::type_id::create("ep5_int");
         ep4_int = uvm_reg_field::type_id::create("ep4_int");
         ep3_int = uvm_reg_field::type_id::create("ep3_int");
         ep2_int = uvm_reg_field::type_id::create("ep2_int");
         ep1_int = uvm_reg_field::type_id::create("ep1_int");
         ep0_int = uvm_reg_field::type_id::create("ep0_int");

         usb_reset.configure(this, 1, 28, "RC", 1, 1'h0, 1, 1, 0);
         rx_error.configure(this, 1, 27, "RC", 1, 1'h0, 1, 1, 0);
         detached.configure(this, 1, 26, "RC", 1, 1'h0, 1, 1, 0);
         attached.configure(this, 1, 25, "RC", 1, 1'h0, 1, 1, 0);
         resume.configure(this, 1, 24, "RC", 1, 1'h0, 1, 1, 0);
         suspend.configure(this, 1, 23, "RC", 1, 1'h0, 1, 1, 0);
         no_ep.configure(this, 1, 22, "RC", 1, 1'h0, 1, 1, 0);
         pid_error.configure(this, 1, 21, "RC", 1, 1'h0, 1, 1, 0);
         crc_error.configure(this, 1, 20, "RC", 1, 1'h0, 1, 1, 0);

         ep15_int.configure(this, 1, 15, "RO", 1, 1'h0, 1, 1, 0);
         ep14_int.configure(this, 1, 14, "RO", 1, 1'h0, 1, 1, 0);
         ep13_int.configure(this, 1, 13, "RO", 1, 1'h0, 1, 1, 0);
         ep12_int.configure(this, 1, 12, "RO", 1, 1'h0, 1, 1, 0);
         ep11_int.configure(this, 1, 11, "RO", 1, 1'h0, 1, 1, 0);
         ep10_int.configure(this, 1, 10, "RO", 1, 1'h0, 1, 1, 0);
         ep9_int.configure(this, 1, 9, "RO", 1, 1'h0, 1, 1, 0);
         ep8_int.configure(this, 1, 8, "RO", 1, 1'h0, 1, 1, 0);
         ep7_int.configure(this, 1, 7, "RO", 1, 1'h0, 1, 1, 0);
         ep6_int.configure(this, 1, 6, "RO", 1, 1'h0, 1, 1, 0);
         ep5_int.configure(this, 1, 5, "RO", 1, 1'h0, 1, 1, 0);
         ep4_int.configure(this, 1, 4, "RO", 1, 1'h0, 1, 1, 0);
         ep3_int.configure(this, 1, 3, "RO", 1, 1'h0, 1, 1, 0);
         ep2_int.configure(this, 1, 2, "RO", 1, 1'h0, 1, 1, 0);
         ep1_int.configure(this, 1, 1, "RO", 1, 1'h0, 1, 1, 0);
         ep0_int.configure(this, 1, 0, "RO", 1, 1'h0, 1, 1, 0);
      endfunction
endclass

class frm_nat_reg extends uvm_reg;
	`uvm_object_utils(frm_nat_reg)
	rand uvm_reg_field num_frame_same_frame_no;
	rand uvm_reg_field cur_frame_no;
	rand uvm_reg_field time_since_last_sof;


      function new(string name = "frm_nat_reg");
         super.new(name, 32, UVM_NO_COVERAGE);
      endfunction

      //--------------------------------------------------------------------
      // build
      //--------------------------------------------------------------------
      virtual function void build();
         num_frame_same_frame_no = uvm_reg_field::type_id::create("num_frame_same_frame_no");
         cur_frame_no = uvm_reg_field::type_id::create("cur_frame_no");
         time_since_last_sof = uvm_reg_field::type_id::create("time_since_last_sof");
         num_frame_same_frame_no.configure(this, 4, 28, "RO", 1, 2'h0, 1, 1, 0);
         cur_frame_no.configure(this, 11, 16, "RO", 1, 1'h0, 1, 1, 0);
         time_since_last_sof.configure(this, 12, 0, "RO", 1, 1'h0, 1, 1, 0);
      endfunction
endclass

class ep_csr_reg extends uvm_reg;
	`uvm_object_utils(ep_csr_reg)
	rand uvm_reg_field uc_bsel;
	rand uvm_reg_field uc_dpd;
	rand uvm_reg_field ep_type;
	rand uvm_reg_field tr_type;
	rand uvm_reg_field ep_dis;
	rand uvm_reg_field ep_no;
	rand uvm_reg_field lrg_ok;
	rand uvm_reg_field sml_ok;
	rand uvm_reg_field dmaen;
	rand uvm_reg_field ots_stop;
	rand uvm_reg_field tr_fr;
	rand uvm_reg_field max_pl_sz;


      function new(string name = "ep_csr_reg");
         super.new(name, 32, UVM_NO_COVERAGE);
      endfunction

      //--------------------------------------------------------------------
      // build
      //--------------------------------------------------------------------
      virtual function void build();
         uc_bsel = uvm_reg_field::type_id::create("uc_bsel");
         uc_dpd = uvm_reg_field::type_id::create("uc_dpd");
         ep_type = uvm_reg_field::type_id::create("ep_type");
         tr_type = uvm_reg_field::type_id::create("tr_type");
         ep_dis = uvm_reg_field::type_id::create("ep_dis");
         ep_no = uvm_reg_field::type_id::create("ep_no");
         lrg_ok = uvm_reg_field::type_id::create("lrg_ok");
         sml_ok = uvm_reg_field::type_id::create("sml_ok");
         dmaen = uvm_reg_field::type_id::create("dmaen");
         ots_stop = uvm_reg_field::type_id::create("ots_stop");
         tr_fr = uvm_reg_field::type_id::create("tr_fr");
         max_pl_sz = uvm_reg_field::type_id::create("max_pl_sz");

         uc_bsel.configure(this, 2, 30, "RO", 1, 2'h0, 1, 1, 0);
         uc_dpd.configure(this, 2, 28, "RO", 1, 2'h0, 1, 1, 0);
         ep_type.configure(this, 2, 26, "RW", 1, 2'h0, 1, 1, 0);
         tr_type.configure(this, 2, 24, "RW", 1, 2'h0, 1, 1, 0);
         ep_dis.configure(this, 2, 22, "RW", 1, 2'h0, 1, 1, 0);
         ep_no.configure(this, 4, 18, "RW", 1, 4'h0, 1, 1, 0);
         lrg_ok.configure(this, 1, 17, "RW", 1, 1'h0, 1, 1, 0);
         sml_ok.configure(this, 1, 16, "RW", 1, 1'h0, 1, 1, 0);
         dmaen.configure(this, 1, 15, "RW", 1, 1'h0, 1, 1, 0);
         ots_stop.configure(this, 1, 13, "RW", 1, 1'h0, 1, 1, 0);
         tr_fr.configure(this, 2, 11, "RW", 1, 2'h0, 1, 1, 0);
         max_pl_sz.configure(this, 11, 0, "RW", 1, 11'h0, 1, 1, 0);
      endfunction
endclass

class ep_ims_reg extends uvm_reg;
	`uvm_object_utils(ep_ims_reg)
	rand uvm_reg_field out_sml_max_pl_sz_inta;
	rand uvm_reg_field pid_error_inta;
	rand uvm_reg_field buffer_full_empty_inta;
	rand uvm_reg_field pid_inta;
	rand uvm_reg_field crc16_inta;
	rand uvm_reg_field timeout_inta;
	rand uvm_reg_field out_sml_max_pl_sz_intb;
	rand uvm_reg_field pid_error_intb;
	rand uvm_reg_field buffer_full_empty_intb;
	rand uvm_reg_field pid_intb;
	rand uvm_reg_field crc16_intb;
	rand uvm_reg_field timeout_intb;

	rand uvm_reg_field out_sml_max_pl_sz;
	rand uvm_reg_field pid_error;
	rand uvm_reg_field buffer1_full_empty;
	rand uvm_reg_field buffer0_full_empty;
	rand uvm_reg_field pid;
	rand uvm_reg_field crc16;
	rand uvm_reg_field timeout;


      function new(string name = "ep_ims_reg");
         super.new(name, 30, UVM_NO_COVERAGE);
      endfunction

      //--------------------------------------------------------------------
      // build
      //--------------------------------------------------------------------
      virtual function void build();
         out_sml_max_pl_sz_inta = uvm_reg_field::type_id::create("out_sml_max_pl_sz_inta");
         pid_error_inta = uvm_reg_field::type_id::create("pid_error_inta");
         buffer_full_empty_inta = uvm_reg_field::type_id::create("buffer_full_empty_inta");
         pid_inta = uvm_reg_field::type_id::create("pid_inta");
         crc16_inta = uvm_reg_field::type_id::create("crc16_inta");
         timeout_inta = uvm_reg_field::type_id::create("timeout_inta");
         out_sml_max_pl_sz_intb = uvm_reg_field::type_id::create("out_sml_max_pl_sz_intb");
         pid_error_intb = uvm_reg_field::type_id::create("pid_error_intb");
         buffer_full_empty_intb = uvm_reg_field::type_id::create("buffer_full_empty_intb");
         pid_intb = uvm_reg_field::type_id::create("pid_intb");
         crc16_intb = uvm_reg_field::type_id::create("crc16_intb");
         timeout_intb = uvm_reg_field::type_id::create("timeout_intb");

         out_sml_max_pl_sz = uvm_reg_field::type_id::create("out_sml_max_pl_sz");
         pid_error = uvm_reg_field::type_id::create("pid_error");
         buffer0_full_empty = uvm_reg_field::type_id::create("buffer0_full_empty");
         buffer1_full_empty = uvm_reg_field::type_id::create("buffer1_full_empty");
         pid = uvm_reg_field::type_id::create("pid");
         crc16 = uvm_reg_field::type_id::create("crc16");
         timeout = uvm_reg_field::type_id::create("timeout");


         out_sml_max_pl_sz_inta.configure(this, 1, 29, "RW", 1, 1'h0, 1, 1, 0);
         pid_error_inta.configure(this, 1, 28, "RW", 1, 1'h0, 1, 1, 0);
         buffer_full_empty_inta.configure(this, 1, 27, "RW", 1, 1'h0, 1, 1, 0);
         pid_inta.configure(this, 1, 26, "RW", 1, 1'h0, 1, 1, 0);
         crc16_inta.configure(this, 1, 25, "RW", 1, 1'h0, 1, 1, 0);
         timeout_inta.configure(this, 1, 24, "RW", 1, 1'h0, 1, 1, 0);

         out_sml_max_pl_sz_intb.configure(this, 1, 21, "RW", 1, 1'h0, 1, 1, 0);
         pid_error_intb.configure(this, 1, 20, "RW", 1, 1'h0, 1, 1, 0);
         buffer_full_empty_intb.configure(this, 1, 19, "RW", 1, 1'h0, 1, 1, 0);
         pid_intb.configure(this, 1, 18, "RW", 1, 1'h0, 1, 1, 0);
         crc16_intb.configure(this, 1, 17, "RW", 1, 1'h0, 1, 1, 0);
         timeout_intb.configure(this, 1, 16, "RW", 1, 1'h0, 1, 1, 0);

         out_sml_max_pl_sz.configure(this, 1, 6, "RC", 1, 1'h0, 1, 1, 0);
         pid_error.configure(this, 1, 5, "RC", 1, 1'h0, 1, 1, 0);
         buffer0_full_empty.configure(this, 1, 4, "RC", 1, 1'h0, 1, 1, 0);
         buffer1_full_empty.configure(this, 1, 3, "RC", 1, 1'h0, 1, 1, 0);
         pid.configure(this, 1, 2, "RC", 1, 1'h0, 1, 1, 0);
         crc16.configure(this, 1, 1, "RC", 1, 1'h0, 1, 1, 0);
         timeout.configure(this, 1, 0, "RC", 1, 1'h0, 1, 1, 0);
      endfunction
endclass

class ep_buf0_reg extends uvm_reg;
	`uvm_object_utils(ep_buf0_reg)
	rand uvm_reg_field used;
	rand uvm_reg_field buf_sz;
	rand uvm_reg_field buf_ptr;


      function new(string name = "ep_buf0_reg");
         super.new(name, 32, UVM_NO_COVERAGE);
      endfunction

      //--------------------------------------------------------------------
      // build
      //--------------------------------------------------------------------
      virtual function void build();
         used = uvm_reg_field::type_id::create("used");
         buf_sz = uvm_reg_field::type_id::create("buf_sz");
         buf_ptr = uvm_reg_field::type_id::create("buf_ptr");
         used.configure(this, 1, 31, "RW", 1, 1'h0, 1, 1, 0);
         buf_sz.configure(this, 14, 17, "RW", 1, 14'h0, 1, 1, 0);
         buf_ptr.configure(this, 17, 0, "RW", 1, 17'h0, 1, 1, 0);
      endfunction
endclass

class ep_buf_reg extends uvm_reg;
	`uvm_object_utils(ep_buf_reg)
	rand uvm_reg_field used;
	rand uvm_reg_field buf_sz;
	rand uvm_reg_field buf_ptr;


      function new(string name = "ep_buf_reg");
         super.new(name, 32, UVM_NO_COVERAGE);
      endfunction

      //--------------------------------------------------------------------
      // build
      //--------------------------------------------------------------------
      virtual function void build();
         used = uvm_reg_field::type_id::create("used");
         buf_sz = uvm_reg_field::type_id::create("buf_sz");
         buf_ptr = uvm_reg_field::type_id::create("buf_ptr");
         used.configure(this, 1, 31, "RW", 1, 1'h1, 1, 1, 0);
         buf_sz.configure(this, 14, 17, "RW", 1, 14'h3FFF, 1, 1, 0);
         buf_ptr.configure(this, 17, 0, "RW", 1, 17'h1FFFF, 1, 1, 0);
      endfunction
endclass


class usb_reg_block extends uvm_reg_block;
      `uvm_object_utils(usb_reg_block)
rand 	csr_reg csr;
rand 	fa_reg fa;
rand 	int_msk_reg int_msk;
rand 	int_src_reg int_src;
rand 	frm_nat_reg frm_nat;
rand 	ep_csr_reg ep_csr[16];
rand 	ep_ims_reg ep_ims[16];

rand 	ep_buf0_reg ep_buf0_reg_i;

rand 	ep_buf_reg ep_buf0[15:1]; //1..15
rand 	ep_buf_reg ep_buf1[16];


      uvm_reg_map wb_map; // Block map

      function new(string name = "usb_reg_block");
         super.new(name, build_coverage(UVM_CVR_ADDR_MAP));
      endfunction

      virtual function void build();
         string s;

         csr = csr_reg::type_id::create("csr");
         csr.configure(this, null, "");
         csr.build();	 
         for(int i = 0; i < 5; i++) begin
           $sformat(s, "csr[%0d]", i);
           csr.add_hdl_path_slice(s, i, 1);
         end

         fa = fa_reg::type_id::create("fa");
         fa.configure(this, null, "");
         fa.build();	 
         for(int i = 0; i < 7; i++) begin
           $sformat(s, "funct_adr[%0d]", i);
           fa.add_hdl_path_slice(s, i, 1);
         end

         int_msk = int_msk_reg::type_id::create("int_msk");
         int_msk.configure(this, null, "");
         int_msk.build();	 
         for(int i = 16; i < 25; i++) begin
           $sformat(s, "intb_msk[%0d]", i);
           int_msk.add_hdl_path_slice(s, i, 1);
         end
         for(int i = 0; i < 9; i++) begin
           $sformat(s, "inta_msk[%0d]", i);
           int_msk.add_hdl_path_slice(s, i, 1);
         end

         int_src = int_src_reg::type_id::create("int_src");
         int_src.configure(this, null, "");
         int_src.build();	 

         frm_nat = frm_nat_reg::type_id::create("frm_nat");
         frm_nat.configure(this, null, "");
         frm_nat.build();	 

	 for (int i = 0; i < 16; i++) begin
           	$sformat(s, "ep_csr[%0d]", i);
         	ep_csr[i] = ep_csr_reg::type_id::create(s);
         	ep_csr[i].configure(this, null, "");
         	ep_csr[i].build();	 
 	 end

	 for (int i = 0; i < 16; i++) begin
           	$sformat(s, "ep_ims[%0d]", i);
         	ep_ims[i] = ep_ims_reg::type_id::create(s);
         	ep_ims[i].configure(this, null, "");
         	ep_ims[i].build();	 
 	 end

         	ep_buf0_reg_i = ep_buf0_reg::type_id::create(s);
         	ep_buf0_reg_i.configure(this, null, "");
         	ep_buf0_reg_i.build();	 

	 for (int i = 1; i < 16; i++) begin
           	$sformat(s, "ep_buf0[%0d]", i);
         	ep_buf0[i] = ep_buf_reg::type_id::create(s);
         	ep_buf0[i].configure(this, null, "");
         	ep_buf0[i].build();	 
 	 end

	 for (int i = 0; i < 16; i++) begin
           	$sformat(s, "ep_buf1[%0d]", i);
         	ep_buf1[i] = ep_buf_reg::type_id::create(s);
         	ep_buf1[i].configure(this, null, "");
         	ep_buf1[i].build();	 
 	 end

         wb_map = create_map("wb_map", 'h0, 4, UVM_LITTLE_ENDIAN);
         wb_map.add_reg(csr, 32'h00000000, "RO");
         wb_map.add_reg(fa, 32'h00000004, "RW");


         wb_map.add_reg(int_msk, 32'h00000008, "RW");
         wb_map.add_reg(int_src, 32'h0000000C, "RW");
         wb_map.add_reg(frm_nat, 32'h000000010, "RW");

         	wb_map.add_reg(ep_csr[0], 32'h40, "RW");
         	wb_map.add_reg(ep_ims[0], 32'h44, "RW");
         	wb_map.add_reg(ep_buf0_reg_i, 32'h48, "RW");
         	wb_map.add_reg(ep_buf1[0], 32'h4C, "RW");
         for(int i = 1; i < 16; i++) begin
         	wb_map.add_reg(ep_csr[i], 32'h40+i*16, "RW");
         	wb_map.add_reg(ep_ims[i], 32'h44+i*16, "RW");
         	wb_map.add_reg(ep_buf0[i], 32'h48+i*16, "RW");
         	wb_map.add_reg(ep_buf1[i], 32'h4C+i*16, "RW");
 	 end
         add_hdl_path("top.dut.u4", "RTL");
         lock_model();
	endfunction
endclass
