`include "src/snow64_instr_decoder_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_alu_defines.header.sv"



//module TestBenchAsr;
//
//	localparam __WIDTH__DATA_INOUT = 8;
//	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(__WIDTH__DATA_INOUT);
//
//	struct packed
//	{
//		logic [__MSB_POS__DATA_INOUT:0] to_shift, amount;
//	} __in_asr;
//
//	struct packed
//	{
//		logic [__MSB_POS__DATA_INOUT:0] data;
//	} __out_asr;
//
//	DebugArithmeticShiftRight #(.WIDTH__DATA_INOUT(__WIDTH__DATA_INOUT))
//		__inst_asr(.in_to_shift(__in_asr.to_shift),
//		.in_amount(__in_asr.amount), .out_data(__out_asr.data));
//
//	logic [__WIDTH__DATA_INOUT:0] __i, __j;
//
//	logic [__MSB_POS__DATA_INOUT:0] __oracle_asr_out_data;
//
//	initial
//	begin
//		for (__i=0; !__i[__WIDTH__DATA_INOUT]; __i=__i+1)
//		begin
//			for (__j=0; !__j[__WIDTH__DATA_INOUT]; __j=__j+1)
//			//for (__j=0; !__j[$clog2(__WIDTH__DATA_INOUT)]; __j=__j+1)
//			begin
//				__in_asr.to_shift = __i;
//				__in_asr.amount = __j;
//				#1
//
//				__oracle_asr_out_data 
//					= $signed(__in_asr.to_shift) >>> __in_asr.amount;
//
//				#1
//				if (__oracle_asr_out_data != __out_asr.data)
//				begin
//					$display("asr wrong output data:  %h >>> %h, %h, %h",
//						__in_asr.to_shift, __in_asr.amount,
//						__out_asr.data, __oracle_asr_out_data);
//				end
//			end
//		end
//	end
//
//
//endmodule




//module TestBenchSltu;
//
//
//	localparam __WIDTH__DATA_INOUT = 8;
//	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(__WIDTH__DATA_INOUT);
//
//	struct packed
//	{
//		logic [__MSB_POS__DATA_INOUT:0] a, b;
//	} __in_sltu;
//
//	struct packed
//	{
//		logic data;
//	} __out_sltu;
//
//	SetLessThanUnsigned #(.WIDTH__DATA_INOUT(__WIDTH__DATA_INOUT))
//		__inst_sltu(.in_a(__in_sltu.a), .in_b(__in_sltu.b),
//		.out_data(__out_sltu.data));
//
//	logic [__WIDTH__DATA_INOUT:0] __i, __j;
//
//	logic __oracle_sltu_out_data;
//
//	initial
//	begin
//		for (__i=0; !__i[__WIDTH__DATA_INOUT]; __i=__i+1)
//		begin
//			for (__j=0; !__j[__WIDTH__DATA_INOUT]; __j=__j+1)
//			begin
//				__in_sltu.a = __i;
//				__in_sltu.b = __j;
//				#1
//
//				__oracle_sltu_out_data = __in_sltu.a < __in_sltu.b;
//
//				#1
//				if (__oracle_sltu_out_data != __out_sltu.data)
//				begin
//					$display("sltu wrong output data:  %h < %h, %h, %h",
//						__in_sltu.a, __in_sltu.b,
//						__out_sltu.data, __oracle_sltu_out_data);
//				end
//			end
//		end
//	end
//
//endmodule

//module TestBenchSlts;
//
//
//	localparam __WIDTH__DATA_INOUT = 8;
//	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(__WIDTH__DATA_INOUT);
//
//	struct packed
//	{
//		logic [__MSB_POS__DATA_INOUT:0] a, b;
//	} __in_slts;
//
//	struct packed
//	{
//		logic data;
//	} __out_slts;
//
//	SetLessThanSigned #(.WIDTH__DATA_INOUT(__WIDTH__DATA_INOUT))
//		__inst_slts(.in_a(__in_slts.a), .in_b(__in_slts.b),
//		.out_data(__out_slts.data));
//
//	logic [__WIDTH__DATA_INOUT:0] __i, __j;
//
//	logic __oracle_slts_out_data;
//
//	initial
//	begin
//		for (__i=0; !__i[__WIDTH__DATA_INOUT]; __i=__i+1)
//		begin
//			for (__j=0; !__j[__WIDTH__DATA_INOUT]; __j=__j+1)
//			begin
//				__in_slts.a = __i;
//				__in_slts.b = __j;
//				#1
//
//				__oracle_slts_out_data 
//					= $signed(__in_slts.a) < $signed(__in_slts.b);
//
//				#1
//				if (__oracle_slts_out_data != __out_slts.data)
//				begin
//					$display("slts wrong output data:  %h < %h, %h, %h",
//						__in_slts.a, __in_slts.b,
//						__out_slts.data, __oracle_slts_out_data);
//				end
//			end
//		end
//	end
//
//endmodule

//module TestBenchAlu;
//
//	logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] __in_alu_a, __in_alu_b;
//	logic [`MSB_POS__SNOW64_ALU_OPER:0] __in_alu_oper;
//	logic [`MSB_POS__SNOW64_CPU_TYPE_SIZE:0] __in_alu_type_size;
//	logic __in_alu_signedness;
//
//	logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] __out_alu_data;
//
//
//	DebugSnow64Alu __inst_debug_alu(.in_a(__in_alu_a), .in_b(__in_alu_b),
//		.in_oper(__in_alu_oper), .in_type_size(__in_alu_type_size),
//		.in_signedness(__in_alu_signedness), .out_data(__out_alu_data));
//
//	assign __in_alu_oper = PkgSnow64Alu::OpShr;
//	assign __in_alu_type_size = PkgSnow64Cpu::TypSz8;
//	assign __in_alu_signedness = 1;
//
//	logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] __oracle_alu_out_data;
//
//	initial
//	begin
//		for (longint i=0; i<(1 << 8); i=i+1)
//		begin
//			for (longint j=0; j<(1 << 8); j=j+1)
//			begin
//				__in_alu_a = i;
//				__in_alu_b = j;
//
//				#1
//				__oracle_alu_out_data[7:0] 
//					= $signed(__in_alu_a[7:0]) >>> __in_alu_b[7:0];
//
//				#1
//				if (__out_alu_data[7:0] != __oracle_alu_out_data[7:0])
//				begin
//				$display("TestBenchAlu:  Wrong data!:  %h >>> %h, %h, %h",
//					__in_alu_a, __in_alu_b, __out_alu_data,
//					__oracle_alu_out_data);
//				end
//
//				$display("TestBenchAlu stuffs:  %h, %h,   %h, %h",
//					__in_alu_a, __in_alu_b, 
//					__out_alu_data, __oracle_alu_out_data);
//			end
//		end
//	end
//
//
//endmodule

module TestBenchCountLeadingZeros16;

	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_IN:0] __in_clz16;
	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_OUT:0] __out_clz16;
	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_OUT:0] __oracle;

	logic __did_find_zero;

	Snow64CountLeadingZeros16 __inst_clz16(.in(__in_clz16),
		.out(__out_clz16));


	initial
	begin
		for (longint i=0; 
			i<(1 << `WIDTH__SNOW64_COUNT_LEADING_ZEROS_16_IN);
			i=i+1)
		begin
			__in_clz16 = i;
			__oracle = 0;
			__did_find_zero = 0;

			#1
			for (longint j
				=(1 << `WIDTH__SNOW64_COUNT_LEADING_ZEROS_16_IN) - 1;
				j>=0;
				--j)
			begin
				if (!__in_clz16[j])
				begin
					if (!__did_find_zero)
					begin
						__oracle = __oracle + 1;
					end
				end
				else
				begin
					//break;
					__did_find_zero = 1;
				end
			end
			if (__in_clz16 == 0)
			begin
				__oracle = 16;
			end

			#1
			if (__out_clz16 != __oracle)
			begin
				$display("Eek!  %h:  %d, %d", __in_clz16, __out_clz16,
					__oracle);
			end
		end

		$finish;
	end

endmodule
