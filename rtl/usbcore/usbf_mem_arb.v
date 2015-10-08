/////////////////////////////////////////////////////////////////////
////                                                             ////
////  Memory Buffer Arbiter                                      ////
////  Arbitrates between the internal DMA and external bus       ////
////  interface for the internal buffer memory                   ////
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
//  $Id: usbf_mem_arb.v,v 1.3 2003-10-17 02:36:57 rudi Exp $
//
//  $Date: 2003-10-17 02:36:57 $
//  $Revision: 1.3 $
//  $Author: rudi $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: not supported by cvs2svn $
//               Revision 1.2  2001/11/04 12:22:45  rudi
//
//               - Fixed previous fix (brocke something else ...)
//               - Majore Synthesis cleanup
//
//               Revision 1.1  2001/08/03 05:30:09  rudi
//
//
//               1) Reorganized directory structure
//
//               Revision 1.2  2001/03/31 13:00:51  rudi
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
//               Revision 0.1.0.1  2001/02/28 08:10:52  rudi
//               Initial Release
//
//

`include "timescale.v"
`include "usbf_defines.v"

module usbf_mem_arb(	phy_clk, wclk, rst,

		// SSRAM Interface
		sram_adr, sram_din, sram_dout, sram_re, sram_we,
                rom_start_adr, rom_adr, rom_din, rom_dout, rom_re, rom_we,
                ep_sel,
                ctrl_setup, ctrl_in, ctrl_out,

		// IDMA Memory Interface
		madr, mdout, mdin, mwe, mreq, mack,

		// WISHBONE Memory Interface
		wadr, wdout, wdin, wwe, wreq, wack

		);




parameter	SSRAM_HADR = 14;

input		phy_clk, wclk, rst;

output	[SSRAM_HADR:0]	sram_adr;
input	[31:0]	sram_din;
output	[31:0]	sram_dout;
output		sram_re, sram_we;



input   [SSRAM_HADR:0]  rom_start_adr;
output	[SSRAM_HADR:0]	rom_adr;
input	[31:0]	rom_din;
output	[31:0]	rom_dout;
output		rom_re; 
output          rom_we;


input   [3:0]   ep_sel;

input ctrl_setup;
input ctrl_in;
input ctrl_out;








input	[SSRAM_HADR:0]	madr;
output	[31:0]	mdout;
input	[31:0]	mdin;
input		mwe;
input		mreq;
output		mack;

input	[SSRAM_HADR:0]	wadr;
output	[31:0]	wdout;
input	[31:0]	wdin;
input		wwe;
input		wreq;
output		wack;

///////////////////////////////////////////////////////////////////
//
// Local Wires and Registers
//

wire		wsel;



wire	[SSRAM_HADR:0]	sram_adr;
wire	[31:0]	sram_dout;
wire		sram_we;


wire	[SSRAM_HADR:0]	rom_adr;
wire	[31:0]	rom_dout;
wire		rom_we;







wire		mack;
wire		mcyc;
reg		wack_r;

///////////////////////////////////////////////////////////////////
//
// Memory Arbiter Logic
//

// IDMA has always first priority

// -----------------------------------------
// Ctrl Signals

assign wsel = (wreq | wack) & !mreq;

// -----------------------------------------
// SSRAM Specific
// Data Path

reg ctrl_transfer2rom_en;


always @ (posedge phy_clk or negedge rst) begin

  if(!rst)
    ctrl_transfer2rom_en <= 1'b0;
  else if(ctrl_setup)
    ctrl_transfer2rom_en <= 1'b0;
  else if(ctrl_in | ctrl_out)
    ctrl_transfer2rom_en <= 1'b1;
  else
    ctrl_transfer2rom_en <= ctrl_transfer2rom_en;

end


assign rom_dout  = (ctrl_transfer2rom_en) ? (wsel) ? ((ep_sel==4'b0)? wdin : 32'hx) : ((ep_sel==4'b0)? mdin : 32'hx) : 32'hx;
assign sram_dout = (wsel) ? ((ep_sel==4'b0)? 32'hx : wdin) : ((ep_sel==4'b0)? 32'hx : mdin);

assign rom_adr   = (ctrl_transfer2rom_en) ? (wsel) ? ((ep_sel==4'b0)? (wadr + rom_start_adr) : 14'hx) : ((ep_sel==4'b0)? (madr + rom_start_adr) : 14'hx) : 14'hx;
assign sram_adr  = (wsel) ? ((ep_sel==4'b0)? 14'hx : wadr) : ((ep_sel==4'b0)? 14'hx : madr);

assign rom_we    = (ctrl_transfer2rom_en) ? (wsel) ? ((ep_sel==4'b0)? (wreq & wwe) : 1'hx) : ((ep_sel==4'b0)? (mwe & mcyc) : 1'hx) : 1'hx;
assign sram_we   = (wsel) ? ((ep_sel==4'b0)? 1'hx : (wreq & wwe)) : ((ep_sel==4'b0)? 1'hx : (mwe & mcyc));




// // Data Out
// always @(wsel or wadr or madr)
// 	if(wsel)	ep==4'b0 ? rom_dout = wdin : sram_dout = wdin;
// 	else		ep==4'b0 ? rom_dout = mdin : sram_dout = mdin;
// // Address Path
// always @(wsel or wadr or madr)
// 	if(wsel)	ep==4'b0 ? rom_adr = wadr : sram_adr = wadr;
// 	else		ep==4'b0 ? rom_adr = madr : sram_adr = madr;
// 
// // Write Enable Path
// always @(wsel or wwe or wreq or mwe or mcyc)
// 	if(wsel)	ep==4'b0 ? rom_we = wreq & wwe : sram_we = wreq & wwe;
// 	else		ep==4'b0 ? rom_we = wreq & wwe : sram_we = mwe & mcyc;

assign sram_re = 1'b1;
assign rom_re  = 1'b1;

// -----------------------------------------
// IDMA specific

assign mdout = ep_sel==4'b0 ? rom_din : sram_din;

assign mack = mreq;

assign mcyc = mack;	// Qualifier for writes

// -----------------------------------------
// WISHBONE specific
assign wdout = (ep_sel==4'b0) ? rom_din : sram_din;

assign wack = wack_r & !mreq;

`ifdef USBF_ASYNC_RESET
always @(posedge phy_clk or negedge rst)
`else
always @(posedge phy_clk)
`endif
	if(!rst)	wack_r <= 1'b0;
	else		wack_r <= wreq & !mreq & !wack;

endmodule

