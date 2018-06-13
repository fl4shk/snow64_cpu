`include "src/snow64_instr_decoder_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_alu_defines.header.sv"


module TestBench;

	//struct packed
	//{
	//	logic clk;
	//} __locals;

	localparam __WIDTH__ASR8_DATA_INOUT = 8;
	localparam __MSB_POS__ASR8_DATA_INOUT
		= `WIDTH2MP(__WIDTH__ASR8_DATA_INOUT);

	struct packed
	{
		logic [__MSB_POS__ASR8_DATA_INOUT:0] to_shift, amount;
	} __in_asr8;

	struct packed
	{
		logic [__MSB_POS__ASR8_DATA_INOUT:0] data;
	} __out_asr8;

	ArithmeticShiftRight #(.WIDTH__DATA_INOUT(__WIDTH__ASR8_DATA_INOUT))
		__inst_asr8(.in_to_shift(__in_asr8.to_shift),
		.in_amount(__in_asr8.amount), .out_data(__out_asr8.data));

	logic [__WIDTH__ASR8_DATA_INOUT:0] __i, __j;

	logic [__MSB_POS__ASR8_DATA_INOUT:0] __oracle_asr8_out_data;

	initial
	begin
		for (__i=0; !__i[__WIDTH__ASR8_DATA_INOUT]; __i=__i+1)
		begin
			for (__j=0; !__j[__WIDTH__ASR8_DATA_INOUT]; __j=__j+1)
			begin
				__in_asr8.to_shift = __i;
				__in_asr8.amount = __j;
				#1

				__oracle_asr8_out_data 
					= $signed(__in_asr8.to_shift) >>> __in_asr8.amount;

				#1
				if (__oracle_asr8_out_data != __out_asr8.data)
				begin
					$display("asr8 wrong output data:  %h >>> %h, %h, %h",
						__in_asr8.to_shift, __in_asr8.amount,
						__out_asr8.data, __oracle_asr8_out_data);
				end
			end
		end
	end


endmodule
