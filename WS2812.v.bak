// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on

module WS2812(iSIGNAL_CLOCK,iDATA_CLOCK,dR, dG, dB,oCTRL_OUT, LED_IDX);
	input 		iSIGNAL_CLOCK;//100 MHz clock for signal timing
	input 		iDATA_CLOCK;//clock driven by data input
	input [7:0]	dR, dG, dB;
	input [8:0] LED_IDX;
	
	output 		oCTRL_OUT;
	
	parameter T0H = 8;
	parameter T1H = 16; 
	parameter T0L = 17;
	parameter T1L = 9;
	parameter TRS = 110;
	

	

//signal declarations
wire [23:0] wRamData;
assign wRamData={dG,dR,dB};
wire [23:0] wCDATA;
wire true;
assign true=1;
reg wRCLK;
reg [8:0] read_address;
reg clk20;
RAM2P ram(
	.data(wRamData),
	.wraddress(LED_IDX),
	.wrclock(iDATA_CLOCK),
	.wren(true),
	
	.rdaddress(read_address),
	.rdclock(clk20),
	.q(wCDATA)
);

reg [8:0] ledCount;

always @(LED_IDX)
begin
	if (LED_IDX+1 > ledCount && LED_IDX)
	begin
		ledCount <= LED_IDX+1;
	end
end

reg [6:0] signal_timer;


reg [4:0] bit_counter;
reg [23:0] srCDATA;
reg rCTRL_OUT;
assign oCTRL_OUT=rCTRL_OUT;
reg sig_reset;
reg [2:0] clk_div;

initial 
begin
	clk_div=0;
end
always @(posedge iSIGNAL_CLOCK)
begin
	clk_div=clk_div+1;
	if (clk_div==5)
	begin
		clk_div=0;
	end
	clk20=(clk_div<3)?1:0;

end	
reg [6:0] TH;
reg [6:0] TE;

initial 
begin
read_address=0;
ledCount=0;
bit_counter=0;
signal_timer=0;
end
always @(posedge clk20)
begin
	if (signal_timer==0 && ~sig_reset)
	begin
		rCTRL_OUT<=1;
	end
	if (srCDATA[23])
	begin
		TH=T1H;
		TE=T1H+T1L;
	end
	else
	begin
		TH=T0H;
		TE=T0H+T0L;
	end
	rCTRL_OUT=(signal_timer < TH)?1:0;
	if (signal_timer >= TE)
	begin
		srCDATA<=srCDATA<<1;
		signal_timer<=0;
		if (bit_counter == 23)
		begin
			bit_counter <= 0;
			if (read_address >= ledCount)
			begin
				read_address<=0;
			end
			else
			begin
				read_address<=read_address+1;
			end
		end
		else
		begin
			bit_counter<=bit_counter+1;
		end
	end
		
	
	signal_timer=signal_timer+1;
end


always @(read_address)
begin
	wRCLK=1;
	#5 srCDATA = wCDATA;
	#10 wRCLK=0;
end

endmodule
	
