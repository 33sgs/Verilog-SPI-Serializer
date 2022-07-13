module serializer (i_Clock, i_Data_Ready, i_Data, o_CS, o_MOSI, o_SCLK, o_Ready);
	parameter DATA_SIZE = 32; // Must be a power of 2
	
	input wire i_Clock; // Main input clock, serial clock will be half the frequency of this clock
	input wire i_Data_Ready; // Input that tells module to read data
	input wire [DATA_SIZE-1:0] i_Data; // Parallel data input lines
	
	output reg o_CS; // Active low chip select
	output reg o_MOSI; // Master data out
	output reg o_SCLK; // Idle low clock
	output reg o_Ready; // Serializer uses this to signal that it is ready for more data
	
	reg [DATA_SIZE-1:0] r_Data;
	reg [$clog2(DATA_SIZE)-1:0] r_Data_Index;
	reg [1:0] r_State;
	reg [1:0] r_Div;
	
	initial
	begin
			o_CS <= 1'b1;
			r_State <= 2'b00;
			o_MOSI <= 1'b0;
			o_SCLK <= 1'b0;
			o_Ready <= 1'b1;
			r_Data_Index <= 5'b00001;
			r_Div <= 1'b0;
	end
	
	always @(posedge i_Clock)
	begin
		r_Div <= r_Div + 1'b1;
		if(r_Div == 3)
		begin
			if(o_Ready && i_Data_Ready)
			begin
				r_Data <= i_Data;
				r_State <= 2'b00;
				o_Ready <= 1'b0;
				o_CS <= 1'b0;
			end
			else if (!o_Ready)
			begin
				if(r_State == 0)
				begin
					o_MOSI <= r_Data[0];
					r_State <= 1;
				end
				else if(r_State == 1)
				begin
					o_SCLK <= ~o_SCLK;
					if(o_SCLK)
					begin
						o_MOSI <= r_Data[r_Data_Index];
						if(r_Data_Index < (DATA_SIZE-1))
						begin
							r_Data_Index <= r_Data_Index + 1;
						end
						else
						begin
							r_State <= 2;
						end
					end
				end
				else if(r_State == 2)
				begin
					o_SCLK <= ~o_SCLK;
					r_State <= 3;
				end
				else if(r_State == 3)
				begin
					r_State <= 0;
					o_SCLK <= 1'b0;
					o_CS <= 1'b1;
					o_MOSI <= 1'b0;
					r_Data_Index <= 5'b00001;
					o_Ready <= 1'b1;
				end
			end
		end
	end
endmodule
