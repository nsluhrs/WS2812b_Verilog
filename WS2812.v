// synopsys translate_off
`timescale 1 ns  / 100 ps
// synopsys translate_on

module WS2812(iSIGNAL_CLOCK,iDATA_CLOCK,dR, dG, dB,oCTRL_OUT, LED_IDX, ext_reset);
	input 		iSIGNAL_CLOCK;//100 MHz clock for signal timing
	input 		iDATA_CLOCK;//clock driven by data input
	input [7:0]	dR, dG, dB;
	input [8:0] LED_IDX;
	input ext_reset;
	output 		oCTRL_OUT;
	
	//the following is times specified by the ws2812b datasheet
	//units are in clock periods 10ns in this case
	parameter T0H = 40;
	parameter T1H = 80; 
	parameter T0L = 85;
	parameter T1L = 45;
	parameter TRS = 5100;

	

//signal declarations
wire [23:0] wRamData;

wire [23:0] wCDATA;
wire true;

//register declarations
reg wRCLK;
reg [8:0] read_address;
reg [8:0] ledCount;
reg [12:0] signal_timer;
reg [4:0] bit_counter;
reg [23:0] srCDATA;
reg rCTRL_OUT;
reg sig_reset;
reg [6:0] TH;
reg [6:0] TE;
//assignments
assign true=1;
assign oCTRL_OUT=rCTRL_OUT;
assign wRamData={dG,dR,dB};


RAM2P ram(
	.data(wRamData),
	.wraddress(LED_IDX),
	.wrclock(iDATA_CLOCK),
	.wren(true),
	
	.rdaddress(read_address),
	.rdclock(iSIGNAL_CLOCK),
	.q(wCDATA)
);


/*
not 100% sure how to do this but the idea is that the higher the number
of LEDs indexed the larger the number of LEDs the program will loop through
this should give the fastest possible write rate Should probably impliment
a reset. basicaly this needs work
*/
always @(posedge iDATA_CLOCK) //makes it so the led count only gets updated when data is entered
begin
	if (LED_IDX+1 > ledCount && LED_IDX)
	begin
		ledCount <= LED_IDX+1;
	end
end





always @(posedge ext_reset) begin
	read_address=0;
	ledCount=0;
	bit_counter=0;
	signal_timer=0;
	rCTRL_OUT=0;
	sig_reset=0;
end


always @(posedge iSIGNAL_CLOCK)
begin
	if (signal_timer==0 && ~sig_reset)
	begin
		rCTRL_OUT<=1;
	end
	if (~sig_reset) begin
		if (srCDATA[23])
		begin
			TH<=T1H;
			TE<=T1H+T1L;
		end
		else
		begin
			TH<=T0H;
			TE<=T0H+T0L;
		end
		rCTRL_OUT=(signal_timer < TH)?1:0;//toggles control line
		if (signal_timer >= TE)
		begin
			srCDATA<=srCDATA<<1;
			if (bit_counter == 11) begin//change read address here
				if (read_address >= ledCount) begin
					read_address<=0;
				end
				else begin
					read_address<=read_address+1;
				end
			end
			if (bit_counter == 23)//read from ram output here
			begin
				bit_counter <= 0;
				srCDATA <= wCDATA;
				if (read_address == 0) begin// decide if need to enter reset mode here
					sig_reset <= 1;
				end
			end
			else
			begin
				bit_counter<=bit_counter+1;
			end
		end
	end
	if (sig_reset && signal_timer>TRS) begin// impliment reset timer
		signal_timer <= 0;
		sig_reset <= 0;
		srCDATA <= wCDATA;
	end
	else begin
		if (signal_timer >= TE) begin
			signal_timer <= 0;
		end
		else begin
			signal_timer <= signal_timer+1; 
		end
	end
end




endmodule
	
