`include "src/snow64_instr_decoder_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_alu_defines.header.sv"


module TestBench;

	//struct packed
	//{
	//	logic clk;
	//} __locals;

	localparam __WIDTH__ASR_DATA_INOUT = 16;
	localparam __MSB_POS__ASR_DATA_INOUT
		= `WIDTH2MP(__WIDTH__ASR_DATA_INOUT);

	struct packed
	{
		logic [__MSB_POS__ASR_DATA_INOUT:0] to_shift, amount;
	} __in_asr;

	struct packed
	{
		logic [__MSB_POS__ASR_DATA_INOUT:0] data;
	} __out_asr;

	DebugArithmeticShiftRight
		#(.WIDTH__DATA_INOUT(__WIDTH__ASR_DATA_INOUT))
		__inst_asr(.in_to_shift(__in_asr.to_shift),
		.in_amount(__in_asr.amount), .out_data(__out_asr.data));

	logic [__WIDTH__ASR_DATA_INOUT:0] __i, __j;

	logic [__MSB_POS__ASR_DATA_INOUT:0] __oracle_asr_out_data;

	initial
	begin
		for (__i=0; !__i[__WIDTH__ASR_DATA_INOUT]; __i=__i+1)
		begin
			for (__j=0; !__j[__WIDTH__ASR_DATA_INOUT]; __j=__j+1)
			begin
				__in_asr.to_shift = __i;
				__in_asr.amount = __j;
				#1

				__oracle_asr_out_data 
					= $signed(__in_asr.to_shift) >>> __in_asr.amount;

				#1
				if (__oracle_asr_out_data != __out_asr.data)
				begin
					$display("asr wrong output data:  %h >>> %h, %h, %h",
						__in_asr.to_shift, __in_asr.amount,
						__out_asr.data, __oracle_asr_out_data);
				end
			end
		end
	end


endmodule
