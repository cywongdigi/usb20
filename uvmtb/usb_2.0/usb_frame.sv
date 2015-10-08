class base_pkt extends uvm_object;
	rand bit [7:0] pid;
	`uvm_object_utils(base_pkt)
	function new(string name="");
		super.new(name);
	endfunction

	constraint pid_c {pid[7:4] == ~pid[3:0];};
	constraint pid_c1 {pid[3:0] != 4'h0;};

	function bit [4:0] calculateCRC5(bit [10:0] data, bit [4:0] poly);
		integer i, j;
		bit [4:0] remainder; 
		bit [7:0] swap_crc; 
		bit rem0, din;
		bit [4:0] crc;
        	remainder = 5'h1F; // Initial CRC value
        	for(j=0; j < 11; j= j + 1 ) begin
            		din = data[j];
            		rem0 = din ^ remainder[4];
            		for(i=4; i>=1; i= i - 1 ) begin
                		remainder[i] = poly[i]==1'b1 ? rem0 ^  remainder[i-1] :  remainder[i-1];
            		end
            		remainder[0] = poly[0]==1'b1 ? rem0 : din;
        	end
        	swap_crc = swap_data(remainder);
        	crc = ~swap_crc[7:3];
		return crc;
	endfunction

	function bit [7:0] swap_data(bit [7:0] one_byte) ;
		bit [7:0] tmp_data;
		integer i, j = 0;
        	for( i = 7 ; i >= 0 ; i= i - 1) begin
                	tmp_data[j] = one_byte[i];
                	j = j+1;
        	end
        	return tmp_data;
	endfunction


	function bit [15:0] calculateCRC16(bit [15:0] crc_in, bit [7:0] data, bit [15:0] poly);
		bit [15:0] swap_crc;
		integer i, j;
		bit [15:0] remainder;
		bit [15:0] rem2;
		bit  rem0;
		bit  din;
        	remainder = crc_in;
        	rem2 = crc_in;
	        for(i=0;i<8 ; i=i+1) begin
            		din = data[i];
            		rem0 = din ^ rem2[15];
            		for(j = 15 ; j > 0; j = j-1) begin
               			 rem2[j]      = (poly[j] == 1'b1) ? rem2[j-1] ^ rem0 : rem2[j-1] ;
            		end
            		rem2[0] = poly[0]==1'b1 ? rem0 : din;
        	end
		return rem2;
    endfunction

    function bit [15:0] swap16Bits(bit [15:0] indata);
    reg [15:0] tmp_data;
    integer i, j;
    begin
        j = 0;
        for( i = 15 ; i >= 0 ; i= i - 1)
        begin
                tmp_data[j] = indata[i];
                j = j+1;
        end
        swap16Bits = tmp_data;
    end
    endfunction
endclass

class sof_pkt extends base_pkt;
	rand bit [10:0] frame_no;
	     bit [4:0] crc;

	`uvm_object_utils_begin(sof_pkt)
	   `uvm_field_int(pid, UVM_ALL_ON)
	   `uvm_field_int(frame_no, UVM_ALL_ON)
	   `uvm_field_int(crc, UVM_ALL_ON)
	`uvm_object_utils_end

	constraint sof_pid_c {
		pid[3:0] == 4'b0101;
	}

	function new(string name="");
		super.new(name);
	endfunction

	function void post_randomize();
		crc = calculateCRC5(frame_no, 5'h05); //poly : 5'h05
	endfunction
endclass

class token_pkt extends base_pkt;
	rand bit [6:0] addr;
	rand bit [3:0] ep_no;
             bit [4:0] crc;

	`uvm_object_utils_begin(token_pkt)
	   `uvm_field_int(pid, UVM_ALL_ON)
	   `uvm_field_int(addr, UVM_ALL_ON)
	   `uvm_field_int(ep_no, UVM_ALL_ON)
	   `uvm_field_int(crc, UVM_ALL_ON)
	`uvm_object_utils_end

	constraint token_pid_c {
		pid[3:0] inside {4'b0001, 4'b1001, 4'b1101};
		addr == 7'h29;
	}

	function new(string name="");
		super.new(name);
	endfunction

	function void post_randomize();
		crc = calculateCRC5({ep_no, addr}, 5'h05); //poly : 5'h05
	endfunction
endclass

class data_pkt extends base_pkt;
	rand byte dataQ[$];
	     bit [15:0] crc;

	`uvm_object_utils_begin(data_pkt)
	   `uvm_field_int(pid, UVM_ALL_ON)
	   `uvm_field_queue_int(dataQ, UVM_ALL_ON)
	   `uvm_field_int(crc, UVM_ALL_ON)
	`uvm_object_utils_end

	constraint data_pid_c {
		pid[3:0] inside {4'b0011, 4'b1011, 4'b0111, 4'b1111};
	}

	function new(string name="");
		super.new(name);
	endfunction

	constraint dataQ_c { dataQ.size() >= 20; dataQ.size() <= 30;};

	function void post_randomize();
    		bit [15:0] crc_in = 16'hFFFF;
		bit [15:0] crc_in_t;

		//Fill the data
		//for (int i = 0; i < 32; i++) begin
		foreach(dataQ[i]) begin
			dataQ[i] = $random;
		end

		foreach (dataQ[i]) begin
			crc_in_t = calculateCRC16(crc_in, dataQ[i], 16'h8005);
			crc_in = crc_in_t;
			//$display("crc_in = %h", crc_in);
		end
                //crc16 = swap16Bits(crc_in);
                crc = crc_in;

		/*
			crc_in_t = calculateCRC16(crc_in, crc[15:8], 16'h8005);
			crc_in = crc_in_t;
			crc_in_t = calculateCRC16(crc_in, crc[7:0], 16'h8005);
			crc_in = crc_in_t;
			*/
			//$display("####### CRC #########");
			//$display("crc = %h", crc);
			//$display("crc_in = %h", crc_in);
			//$display("####### CRC #########");
	endfunction
endclass

class hs_pkt extends base_pkt;
	`uvm_object_utils_begin(hs_pkt)
	   `uvm_field_int(pid, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name="");
		super.new(name);
	endfunction

	constraint hs_pid_c {
		pid[3:0] inside {4'b0010, 4'b1010, 4'b1110, 4'b0110};
	}
endclass

class usb_frame extends uvm_sequence_item;
	rand sof_pkt sof;
	rand token_pkt tokenA[$];
	rand data_pkt dataA[$];
	rand hs_pkt hsA[$];

	rand token_pkt token;
	rand data_pkt data;
	rand hs_pkt hs;

	`uvm_object_utils_begin(usb_frame)
	   `uvm_field_object(sof, UVM_ALL_ON)
	   `uvm_field_queue_object(tokenA, UVM_ALL_ON)
	   `uvm_field_queue_object(dataA, UVM_ALL_ON)
	   `uvm_field_queue_object(hsA, UVM_ALL_ON)
	`uvm_object_utils_end

	constraint pkt_size_c {
		tokenA.size() == 1;
		dataA.size() == 1;
		hsA.size() == 1;
	};

	function new(string name="");
		super.new(name);
		sof = new();
	endfunction

	function void pre_randomize();
		sof = new();
		for (int i =0 ; i < 2; i++) begin
			token = new();
			tokenA.push_back(token);
			data = new();
			dataA.push_back(data);
			hs = new();
			hsA.push_back(hs);
		end
	endfunction

	function get_sof(output sof_pkt sof_l);
		sof_l = this.sof;
	endfunction
	function get_token(output token_pkt token);
		//`uvm_info("usb_frame", $psprintf("size = %d", tokenA.size()), UVM_LOW);
		$display("SIZE = %d", tokenA.size());
		token = tokenA.pop_front();
	endfunction
	function get_data(output data_pkt data);
		data = dataA.pop_front();
	endfunction
	function get_hs(output hs_pkt hs);
		hs = hsA.pop_front();
	endfunction
endclass
