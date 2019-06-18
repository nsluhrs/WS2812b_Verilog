
// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module WS2812_TB();
	
	
	reg 		iSIGNAL_CLOCK;//100 MHz clock for signal timing
	reg 		iDATA_CLOCK;//clock driven by data input
	reg [7:0]	dR, dG, dB;
	reg [8:0] LED_IDX;
	wire oCTRL_OUT;
	
	initial begin
	dR=0;
	dG=25;
	dB=50;
	LED_IDX=0;
	iSIGNAL_CLOCK=1;
	iDATA_CLOCK=0;
	#50 iDATA_CLOCK=1;
	#60 iDATA_CLOCK=0;

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
	.oCTRL_OUT(oCTRL_OUT));
	
endmodule
