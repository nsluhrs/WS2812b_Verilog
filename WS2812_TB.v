
// synopsys translate_off
`timescale 1 ns  / 100 ps
// synopsys translate_on
module WS2812_TB();
	
	
	reg 		iSIGNAL_CLOCK;//100 MHz clock for signal timing
	reg 		iDATA_CLOCK;//clock driven by data input
	reg [7:0]	dR, dG, dB;
	reg [8:0] LED_IDX;
	wire oCTRL_OUT;
	reg reset;
	
	initial begin
	iSIGNAL_CLOCK=0;
	iDATA_CLOCK=0;
	reset=0;
	reset=1;
	#20 reset=0;
	
	dR=255;
	dG=170;
	dB=240;
	LED_IDX=0;
	#20 iDATA_CLOCK=1;
	#20 iDATA_CLOCK=0;
	LED_IDX=1;
	dR=15;
	dG=85;
	dB=0;
	#20 iDATA_CLOCK=1;
	#20 iDATA_CLOCK=0;
	
	#2 dR=231;
	#4 dG=195;
	#8 LED_IDX=2;
	#7 dB=136;
	#20 iDATA_CLOCK=1;
	#20 iDATA_CLOCK=0;
	end
	
	
	always begin
	#5 iSIGNAL_CLOCK=~iSIGNAL_CLOCK;
	end
	
	WS2812 ledCtrl(
	.iSIGNAL_CLOCK(iSIGNAL_CLOCK),
	.iDATA_CLOCK(iDATA_CLOCK),
	.dR(dR),
	.dG(dG),
	.dB(dB),
	.LED_IDX(LED_IDX),
	.ext_reset(reset),
	.oCTRL_OUT(oCTRL_OUT));
	
endmodule
