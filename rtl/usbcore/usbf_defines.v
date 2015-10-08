/////////////////////////////////////////////////////////////////////
////                                                             ////
////  USB function defines file                                  ////
////                                                             ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
////                                                             ////
////  Downloaded from: http://www.opencores.org/cores/usb/       ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2000-2003 Rudolf Usselmann                    ////
////                         www.asics.ws                        ////
////                         rudi@asics.ws                       ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

//  CVS Log
//
//  $Id: usbf_defines.v,v 1.6 2003-10-17 02:36:57 rudi Exp $
//
//  $Date: 2003-10-17 02:36:57 $
//  $Revision: 1.6 $
//  $Author: rudi $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: not supported by cvs2svn $
//               Revision 1.5  2001/11/04 12:22:43  rudi
//
//               - Fixed previous fix (brocke something else ...)
//               - Majore Synthesis cleanup
//
//               Revision 1.4  2001/09/23 08:39:33  rudi
//
//               Renamed DEBUG and VERBOSE_DEBUG to USBF_DEBUG and USBF_VERBOSE_DEBUG ...
//
//               Revision 1.3  2001/09/13 13:14:02  rudi
//
//               Fixed a problem that would sometimes prevent the core to come out of
//               reset and immediately be operational ...
//
//               Revision 1.2  2001/08/10 08:48:33  rudi
//
//               - Changed IO names to be more clear.
//               - Uniquifyed define names to be core specific.
//
//               Revision 1.1  2001/08/03 05:30:09  rudi
//
//
//               1) Reorganized directory structure
//
//               Revision 1.2  2001/03/31 13:00:52  rudi
//
//               - Added Core configuration
//               - Added handling of OUT packets less than MAX_PL_SZ in DMA mode
//               - Modified WISHBONE interface and sync logic
//               - Moved SSRAM outside the core (added interface)
//               - Many small bug fixes ...
//
//               Revision 1.0  2001/03/07 09:17:12  rudi
//
//
//               Changed all revisions to revision 1.0. This is because OpenCores CVS
//               interface could not handle the original '0.1' revision ....
//
//               Revision 0.2  2001/03/07 09:08:13  rudi
//
//               Added USB control signaling (Line Status) block. Fixed some minor
//               typos, added resume bit and signal.
//
//               Revision 0.1.0.1  2001/02/28 08:11:35  rudi
//               Initial Release
//
//


// Uncomment the lines below to get various levels of debugging
// verbosity ...
`define USBF_DEBUG
//`define USBF_VERBOSE_DEBUG

// Uncomment the line below to run the test bench
// Comment it out to use your own address parameters ...
`define USBF_TEST_IMPL

// For each endpoint that should actually be instantiated,
// set the below define value to a one. Uncomment the define
// statement for unused endpoints. The endpoints should be
// sequential, e.q. 1,2,3. I have not tested what happens if
// you select endpoints in a non sequential manner e.g. 1,4,6
// Actual (logical) endpoint IDs are set by the software. There
// is no correlation between the physical endpoint number (below)
// and the actual (logical) endpoint number.
`ifdef USBF_TEST_IMPL
		// Do not modify this section
		// this is to run the test bench
		`define	USBF_HAVE_EP1	1
		`define	USBF_HAVE_EP2	1
		`define	USBF_HAVE_EP3	1
		`define	USBF_HAVE_EP4	1
		`define	USBF_HAVE_EP5	1
		`define	USBF_HAVE_EP6	1
		`define	USBF_HAVE_EP7	1
		`define	USBF_HAVE_EP8	1
		`define	USBF_HAVE_EP9	1
		`define	USBF_HAVE_EP10	1
		`define	USBF_HAVE_EP11	1
		`define	USBF_HAVE_EP12	1
		`define	USBF_HAVE_EP13	1
		`define	USBF_HAVE_EP14	1
		`define	USBF_HAVE_EP15	1
`else
		// Modify this section to suit your implementation
		`define	USBF_HAVE_EP1	1
		`define	USBF_HAVE_EP2	1
		`define	USBF_HAVE_EP3	1
		`define	USBF_HAVE_EP4	1
		`define	USBF_HAVE_EP5	1
		`define	USBF_HAVE_EP6	1
		`define	USBF_HAVE_EP7	1
		`define	USBF_HAVE_EP8	1
		`define	USBF_HAVE_EP9	1
		`define	USBF_HAVE_EP10	1
		`define	USBF_HAVE_EP11	1
		`define	USBF_HAVE_EP12	1
		`define	USBF_HAVE_EP13	1
		`define	USBF_HAVE_EP14	1
		`define	USBF_HAVE_EP15	1
`endif



`define EP0_CSR   18'h40
`define EP0_BUF0  18'h48
`define EP0_BUF1  18'h4C
`define EP1_CSR   18'h50
`define EP1_BUF0  18'h58
`define EP1_BUF1  18'h5C
`define EP2_CSR   18'h60
`define EP2_BUF0  18'h68
`define EP2_BUF1  18'h6C
`define EP3_CSR   18'h70
`define EP3_BUF0  18'h78
`define EP3_BUF1  18'h7C
`define EP4_CSR   18'h80
`define EP4_BUF0  18'h88
`define EP4_BUF1  18'h8C
`define EP5_CSR   18'h90
`define EP5_BUF0  18'h98
`define EP5_BUF1  18'h9C
`define EP6_CSR   18'hA0
`define EP6_BUF0  18'hA8
`define EP6_BUF1  18'hAC
`define EP7_CSR   18'hB0
`define EP7_BUF0  18'hB8
`define EP7_BUF1  18'hBC
`define EP8_CSR   18'hC0
`define EP8_BUF0  18'hC8
`define EP8_BUF1  18'hCC
`define EP9_CSR   18'hD0
`define EP9_BUF0  18'hD8
`define EP9_BUF1  18'hDC
`define EP10_CSR  18'hE0
`define EP10_BUF0 18'hE8
`define EP10_BUF1 18'hEC
`define EP11_CSR  18'hF0
`define EP11_BUF0 18'hF8
`define EP11_BUF1 18'hFC
`define EP12_CSR  18'h100
`define EP12_BUF0 18'h108
`define EP12_BUF1 18'h10C
`define EP13_CSR  18'h110
`define EP13_BUF0 18'h118
`define EP13_BUF1 18'h11C
`define EP14_CSR  18'h120
`define EP14_BUF0 18'h128
`define EP14_BUF1 18'h12C
`define EP15_CSR  18'h130
`define EP15_BUF0 18'h138
`define EP15_BUF1 18'h13C




`define EP0_CSR_INIT_VALUE  32'b00_00_00_10_00_0000_1_1_0_0_0_00_000_0000_0000
`define EP1_CSR_INIT_VALUE  32'b00_00_10_10_00_0001_1_1_0_0_0_00_010_0000_0000 // BULK IN  512B
`define EP2_CSR_INIT_VALUE  32'b00_00_01_10_00_0010_1_1_0_0_0_00_010_0000_0000 // BULK OUT 512B
`define EP3_CSR_INIT_VALUE  32'b00_00_10_01_00_0011_1_1_0_0_0_00_100_0000_0000 // ISO IN   1024B
`define EP4_CSR_INIT_VALUE  32'b00_00_01_01_00_0100_1_1_0_0_0_00_100_0000_0000 // ISO OUT  1024B
`define EP5_CSR_INIT_VALUE  32'b00_00_10_11_00_0101_1_1_0_0_0_00_100_0000_0000 // INT IN   1024B 
`define EP6_CSR_INIT_VALUE  32'b00_00_01_11_00_0110_1_1_0_0_0_00_100_0000_0000 // INT OUT  1024B

`define EP7_CSR_INIT_VALUE  32'b00_00_10_10_00_0111_1_1_0_0_0_00_010_0000_0000
`define EP8_CSR_INIT_VALUE  32'b00_00_01_10_00_1000_1_1_0_0_0_00_010_0000_0000
`define EP9_CSR_INIT_VALUE  32'b00_00_10_01_00_1001_1_1_0_0_0_00_100_0000_0000
`define EP10_CSR_INIT_VALUE 32'b00_00_01_01_00_1010_1_1_0_0_0_00_100_0000_0000
`define EP11_CSR_INIT_VALUE 32'b00_00_10_11_00_1011_1_1_0_0_0_00_100_0000_0000
`define EP12_CSR_INIT_VALUE 32'b00_00_01_11_00_1100_1_1_0_0_0_00_100_0000_0000
`define EP13_CSR_INIT_VALUE 32'b00_00_10_10_00_1101_1_1_0_0_0_00_010_0000_0000
`define EP14_CSR_INIT_VALUE 32'b00_00_01_10_00_1110_1_1_0_0_0_00_010_0000_0000
`define EP15_CSR_INIT_VALUE 32'b00_00_10_10_00_1111_1_1_0_0_0_00_010_0000_0000

`define EP0_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h0}
`define EP0_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h0}
`define EP1_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h1000}
`define EP1_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h1000}
`define EP2_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h1000}
`define EP2_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h1000}
`define EP3_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h2000}
`define EP3_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h2000}
`define EP4_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h2000}
`define EP4_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h2000}
`define EP5_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h3000}
`define EP5_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h3000}
`define EP6_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h3000}
`define EP6_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h3000}
`define EP7_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h4000}
`define EP7_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h4000}
`define EP8_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h4000}
`define EP8_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h4000}
`define EP9_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h5000}
`define EP9_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h5000}
`define EP10_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h5000}
`define EP10_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h5000}
`define EP11_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h6000}
`define EP11_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h6000}
`define EP12_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h6000}
`define EP12_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h6000}
`define EP13_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h7000}
`define EP13_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h7000}
`define EP14_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h7000}
`define EP14_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h7000}
`define EP15_BUF0_INIT_VALUE {1'b0, 14'd4096, 17'h8000}
`define EP15_BUF1_INIT_VALUE {1'b0, 14'd4096, 17'h8000}

`define FA 18'h4


`define DEVICE_DES_ROM_ADDR 0
`define CONFIGURATION_DES_ROM_ADDR 5
`define DEVICE_QUALIFIER_DES_ROM_ADDR 8
`define OTHER_SPEED_CONFIGURATION_DES_ROM_ADDR 11
`define INTERFACE0_DES_ROM_ADDR 14
`define INTERFACE1_DES_ROM_ADDR 17
`define INTERFACE2_DES_ROM_ADDR 20
`define INTERFACE3_DES_ROM_ADDR 23
`define INTERFACE4_DES_ROM_ADDR 26
`define INTERFACE5_DES_ROM_ADDR 29
`define INTERFACE6_DES_ROM_ADDR 32
`define INTERFACE7_DES_ROM_ADDR 35
`define EP1_DES_ROM_ADDR 38
`define EP2_DES_ROM_ADDR 41
`define EP3_DES_ROM_ADDR 44
`define EP4_DES_ROM_ADDR 47
`define EP5_DES_ROM_ADDR 50
`define EP6_DES_ROM_ADDR 53
`define EP7_DES_ROM_ADDR 56
`define EP8_DES_ROM_ADDR 59
`define EP9_DES_ROM_ADDR 62
`define EP10_DES_ROM_ADDR 65
`define EP11_DES_ROM_ADDR 68
`define EP12_DES_ROM_ADDR 71
`define EP13_DES_ROM_ADDR 74
`define EP14_DES_ROM_ADDR 77
`define EP15_DES_ROM_ADDR 80
`define DEVICE_GET_STATUS_ROM_ADDR 83
`define INTERFACE_GET_STATUS_ROM_ADDR 85
`define EP_FRM_NAT 86



// Highest address line number that goes to the USB core
// Typically only A0 through A17 are needed, where A17
// selects between the internal buffer memory and the
// register file.
// Implementations may choose to have a more complex address
// decoding ....

`ifdef USBF_TEST_IMPL
		// Do not modify this section
		// this is to run the test bench
		`define USBF_UFC_HADR	17
		`define USBF_RF_SEL	(!wb_addr_i[17])
		`define USBF_MEM_SEL	(wb_addr_i[17])
		`define USBF_SSRAM_HADR	14
		//`define USBF_ASYNC_RESET

`else
		// Modify this section to suit your implementation
		`define USBF_UFC_HADR	12
		// Address Decoding for Register File select
		`define USBF_RF_SEL	(!wb_addr_i[12])
		// Address Decoding for Buffer Memory select
		`define USBF_MEM_SEL	(wb_addr_i[12])
		`define USBF_SSRAM_HADR	9
		// The next statement determines if reset is async or sync.
		// If the define is uncommented the reset will be ASYNC.
		//`define USBF_ASYNC_RESET
`endif


/////////////////////////////////////////////////////////////////////
//
// Items below this point should NOT be modified by the end user
// UNLESS you know exactly what you are doing !
// Modify at you own risk !!!
//
/////////////////////////////////////////////////////////////////////

`define	ROM_SIZE0	7'd018	// Device Descriptor Length
`define	ROM_SIZE1	7'd053	// Configuration Descriptor Length
`define	ROM_SIZE2A	7'd004	// Language ID Descriptor Start Length
`define	ROM_SIZE2B	7'd010	// String Descriptor Length
`define	ROM_SIZE2C	7'd010	// for future use
`define	ROM_SIZE2D	7'd010	// for future use

`define	ROM_START0	7'h00	// Device Descriptor Start Address
`define	ROM_START1	7'h12	// Configuration Descriptor Start Address
`define	ROM_START2A	7'h47	// Language ID Descriptor Start Address
`define	ROM_START2B	7'h50	// String Descriptor Start Address
`define	ROM_START2C	7'h60	// for future use
`define	ROM_START2D	7'h70	// for future use

// Endpoint Configuration Constants
`define IN	14'b00_001_000000000
`define OUT	14'b00_010_000000000
`define CTRL	14'b10_100_000000000
`define ISO	14'b01_000_000000000
`define BULK	14'b10_000_000000000
`define INT	14'b00_000_000000000

// PID Encodings
`define USBF_T_PID_OUT		4'b0001
`define USBF_T_PID_IN		4'b1001
`define USBF_T_PID_SOF		4'b0101
`define USBF_T_PID_SETUP	4'b1101
`define USBF_T_PID_DATA0	4'b0011
`define USBF_T_PID_DATA1	4'b1011
`define USBF_T_PID_DATA2	4'b0111
`define USBF_T_PID_MDATA	4'b1111
`define USBF_T_PID_ACK		4'b0010
`define USBF_T_PID_NACK		4'b1010
`define USBF_T_PID_STALL	4'b1110
`define USBF_T_PID_NYET		4'b0110
`define USBF_T_PID_PRE		4'b1100
`define USBF_T_PID_ERR		4'b1100
`define USBF_T_PID_SPLIT	4'b1000
`define USBF_T_PID_PING		4'b0100
`define USBF_T_PID_RES		4'b0000

// The HMS_DEL is a constant for the "Half Micro Second"
// Clock pulse generator. This constant specifies how many
// Phy clocks there are between two hms_clock pulses. This
// constant plus 2 represents the actual delay.
// Example: For a 60 Mhz (16.667 nS period) Phy Clock, the
// delay must be 30 phy clocks: 500ns / 16.667nS = 30 clocks
`define USBF_HMS_DEL		5'h1c

// After sending Data in response to an IN token from host, the
// host must reply with an ack. The host has 622nS in Full Speed
// mode and 400nS in High Speed mode to reply. RX_ACK_TO_VAL_FS
// and RX_ACK_TO_VAL_HS are the numbers of UTMI clock cycles
// minus 2 for Full and High Speed modes.
`define USBF_RX_ACK_TO_VAL_FS	8'd36
`define USBF_RX_ACK_TO_VAL_HS	8'd22


// After sending an OUT token the host must send a data packet.
// The host has 622nS in Full Speed mode and 400nS in High Speed
// mode to send the data packet.
// TX_DATA_TO_VAL_FS and TX_DATA_TO_VAL_HS are is the numbers of
// UTMI clock cycles minus 2.
`define USBF_TX_DATA_TO_VAL_FS	8'd36
`define USBF_TX_DATA_TO_VAL_HS	8'd22


// --------------------------------------------------
// USB Line state & Speed Negotiation Time Values


// Prescaler Clear value.
// The prescaler generates a 0.25uS pulse, from a nominal PHY clock of
// 60 Mhz. 250nS/16.667ns=15. The prescaler has to be cleared every 15
// cycles. Due to the pipeline, subtract 2 from 15, resulting in 13 cycles.
// !!! This is the only place that needs to be changed if a PHY with different
// !!! clock output is used.
`define	USBF_T1_PS_250_NS	4'd13

// uS counter representation of 2.5uS (2.5/0.25=10)
`define	USBF_T1_C_2_5_US	8'd10

// uS counter clear value
// The uS counter counts the time in 0.25uS intervals. It also generates
// a count enable to the mS counter, every 62.5 uS.
// The clear value is 62.5uS/0.25uS=250 cycles.
`define USBF_T1_C_62_5_US	8'd250

// mS counter representation of 3.0mS (3.0/0.0625=48)
`define USBF_T1_C_3_0_MS	8'd48

// mS counter representation of 3.125mS (3.125/0.0625=50)
`define USBF_T1_C_3_125_MS	8'd50

// mS counter representation of 5mS (5/0.0625=80)
`define USBF_T1_C_5_MS		8'd80

// Multi purpose Counter Prescaler, generate 2.5 uS period
// 2500/16.667ns=150 (minus 2 for pipeline)
`define	USBF_T2_C_2_5_US	8'd148

// Generate 0.5mS period from the 2.5 uS clock
// 500/2.5 = 200
`define	USBF_T2_C_0_5_MS	8'd200

// Indicate when internal wakeup has completed
// me_cnt counts 0.5 mS intervals. E.g.: 5.0mS are (5/0.5) 10 ticks
// Must be 0 =< 10 mS
`define USBF_T2_C_WAKEUP	8'd10

// Indicate when 100uS have passed
// me_ps2 counts 2.5uS intervals. 100uS are (100/2.5) 40 ticks
`define USBF_T2_C_100_US	8'd40

// Indicate when 1.0 mS have passed
// me_cnt counts 0.5 mS intervals. 1.0mS are (1/0.5) 2 ticks
`define USBF_T2_C_1_0_MS	8'd2

// Indicate when 1.2 mS have passed
// me_cnt counts 0.5 mS intervals. 1.2mS are (1.2/0.5) 2 ticks
`define USBF_T2_C_1_2_MS	8'd2

// Indicate when 100 mS have passed
// me_cnt counts 0.5 mS intervals. 100mS are (100/0.5) 200 ticks
`define USBF_T2_C_100_MS	8'd200

