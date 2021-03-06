`include "src/snow64_instr_decoder_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_alu_defines.header.sv"
`include "src/snow64_instr_cache_defines.header.sv"



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
//	logic [`MSB_POS__SNOW64_SIZE_64:0] __in_alu_a, __in_alu_b;
//	logic [`MSB_POS__SNOW64_ALU_OPER:0] __in_alu_oper;
//	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] __in_alu_type_size;
//	logic __in_alu_signedness;
//
//	logic [`MSB_POS__SNOW64_SIZE_64:0] __out_alu_data;
//
//
//	DebugSnow64Alu __inst_debug_alu(.in_a(__in_alu_a), .in_b(__in_alu_b),
//		.in_oper(__in_alu_oper), .in_type_size(__in_alu_type_size),
//		.in_signedness(__in_alu_signedness), .out_data(__out_alu_data));
//
//	assign __in_alu_oper = PkgSnow64ArithLog::OpShr;
//	assign __in_alu_type_size = PkgSnow64Cpu::IntTypSz8;
//	assign __in_alu_signedness = 1;
//
//	logic [`MSB_POS__SNOW64_SIZE_64:0] __oracle_alu_out_data;
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

//module TestBenchCountLeadingZeros16;
//
//	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_IN:0] __in_clz16;
//	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_OUT:0] __out_clz16;
//	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_OUT:0] __oracle;
//
//	logic __did_find_zero;
//
//	Snow64CountLeadingZeros16 __inst_clz16(.in(__in_clz16),
//		.out(__out_clz16));
//
//
//	initial
//	begin
//		for (longint i=0; 
//			i<(1 << `WIDTH__SNOW64_COUNT_LEADING_ZEROS_16_IN);
//			i=i+1)
//		begin
//			__in_clz16 = i;
//			__oracle = 0;
//			__did_find_zero = 0;
//
//			#1
//			for (longint j=15; j>=0; --j)
//			begin
//				//#1
//				//$display("j:  ", j);
//				if (!__in_clz16[j])
//				begin
//					if (!__did_find_zero)
//					begin
//						__oracle = __oracle + 1;
//					end
//				end
//				else
//				begin
//					__did_find_zero = 1;
//				end
//			end
//
//			if (__in_clz16 == 0)
//			begin
//				__oracle = 16;
//			end
//
//			#1
//			if (__out_clz16 != __oracle)
//			begin
//				$display("Eek!  %h:  %d, %d", __in_clz16, __out_clz16,
//					__oracle);
//			end
//		end
//
//		$finish;
//	end
//
//endmodule

//module ShowBFloat16Div;
//
//	logic __clk;
//
//	initial
//	begin
//		__clk = 0;
//	end
//
//	always
//	begin
//		#1
//		__clk = !__clk;
//	end
//
//	logic __dummy;
//	logic __in_bfloat16_div_start;
//	PkgSnow64BFloat16::BFloat16 __in_bfloat16_div_a, __in_bfloat16_div_b;
//
//	PkgSnow64BFloat16::PortIn_Oper __in_bfloat16_div;
//	PkgSnow64BFloat16::PortOut_BinOp __out_bfloat16_div;
//
//	assign __in_bfloat16_div.start = __in_bfloat16_div_start;
//	assign __in_bfloat16_div.a = __in_bfloat16_div_a;
//	assign __in_bfloat16_div.b = __in_bfloat16_div_b;
//
//	Snow64BFloat16Div __inst_bfloat16_div(.clk(__clk),
//		.in(__in_bfloat16_div), .out(__out_bfloat16_div));
//
//
//	initial
//	begin
//		for (longint i=0; i<20; i=i+1)
//		begin
//		__dummy = 0;
//		__in_bfloat16_div_start = 0;
//		//__in_bfloat16_div_a = 'h81;
//		//__in_bfloat16_div_b = 'hb0b5;
//		//__in_bfloat16_div_a = 'h4080;
//		//__in_bfloat16_div_b = 'h80;
//		__in_bfloat16_div_a = 'h80;
//		__in_bfloat16_div_b = 'h80 + i;
//
//
//		#2
//		__in_bfloat16_div_start = 1;
//
//		#2
//		__in_bfloat16_div_start = 0;
//
//		while (!__out_bfloat16_div.valid)
//		begin
//			#2
//			__dummy = !__dummy;
//		end
//		//#2
//		//#2
//		//#2
//		//#2
//		//#2
//		//#2
//
//		#2
//		$display("__out_bfloat16_div.data:  %h",
//			__out_bfloat16_div.data);
//		#2
//		$display("__out_bfloat16_div.data:  %h",
//			__out_bfloat16_div.data);
//
//		//#2
//		//$display("__out_bfloat16_div.data:  %h",
//		//	__out_bfloat16_div.data);
//
//		//for (longint i=0; i<(1 << `WIDTH__SNOW64_BFLOAT16_ITSELF); i=i+1)
//		//begin
//		//	__in_bfloat16_div_a = i;
//
//		//	for (longint j=0;
//		//		j<(1 << `WIDTH__SNOW64_BFLOAT16_ITSELF);
//		//		j=j+1)
//		//	begin
//		//		__in_bfloat16_div_start = 1;
//		//		__in_bfloat16_div_b = j;
//
//		//		#2
//		//		__in_bfloat16_div_start = 0;
//
//		//		#2
//		//		#2
//		//		$display("%d",
//		//			__out_bfloat16_div.data);
//		//	end
//		//end
//		end
//
//		$finish;
//	end
//
//
//endmodule

//module TestBFloat16CastFromInt;
//	logic __clk;
//
//	initial
//	begin
//		__clk = 0;
//	end
//
//	always
//	begin
//		#1
//		__clk = !__clk;
//	end
//
//	PkgSnow64BFloat16::PortIn_CastFromInt __in_bfloat16_cast_from_int;
//	PkgSnow64BFloat16::PortOut_CastFromInt __out_bfloat16_cast_from_int;
//
//	Snow64BFloat16CastFromInt(.clk(clk), .in(__in_bfloat16_cast_from_int),
//		.out(__out_bfloat16_cast_from_int));
//
//
//	initial
//	begin
//		__in_bfloat16_cast_from_int = 0;
//	end
//
//endmodule

//module TestBFloat16Fpu;
//
//	logic __clk;
//
//	initial
//	begin
//		__clk = 0;
//	end
//
//	always
//	begin
//		#1
//		__clk = !__clk;
//	end
//
//	PkgSnow64BFloat16::PortIn_Fpu __in_bfloat16_fpu;
//	PkgSnow64BFloat16::PortOut_Fpu __out_bfloat16_fpu;
//
//	Snow64BFloat16Fpu __inst_bfloat16_fpu(.clk(clk),
//		.in(__in_bfloat16_fpu), .out(__out_bfloat16_fpu));
//
//endmodule

//module TestLarFile;
//
//	logic __clk;
//
//	initial
//	begin
//		__clk = 0;
//	end
//
//	always
//	begin
//		#1
//		__clk = !__clk;
//	end
//
//	PkgSnow64LarFile::PortIn_LarFile_Ctrl __in_lar_file_ctrl;
//	PkgSnow64LarFile::PortIn_LarFile_Read __in_lar_file_rd_a,
//		__in_lar_file_rd_b, __in_lar_file_rd_c;
//	PkgSnow64LarFile::PortIn_LarFile_Write __in_lar_file_wr;
//
//	PkgSnow64LarFile::PortOut_LarFile_Read __out_lar_file_rd_a,
//		__out_lar_file_rd_b, __out_lar_file_rd_c;
//	PkgSnow64LarFile::PortOut_LarFile_MemWrite __out_lar_file_mem_write;
//
//	Snow64LarFile __inst_lar_file(.clk(__clk),
//		.in_ctrl(__in_lar_file_ctrl), .in_rd_a(__in_lar_file_rd_a),
//		.in_rd_b(__in_lar_file_rd_b), .in_rd_c(__in_lar_file_rd_c),
//		.in_wr(__in_lar_file_wr), .out_rd_a(__out_lar_file_rd_a),
//		.out_rd_b(__out_lar_file_rd_b), .out_rd_c(__out_lar_file_rd_c),
//		.out_mem_write(__out_lar_file_mem_write));
//
//	task inc_indices;
//		{__in_lar_file_rd_a.index, __in_lar_file_rd_b.index,
//			__in_lar_file_rd_c.index} 
//			= {__in_lar_file_rd_a.index, __in_lar_file_rd_b.index,
//			__in_lar_file_rd_c.index} + 1;
//	endtask : inc_indices
//
//	initial
//	begin
//		//__in_lar_file_ctrl.pause = 0;
//
//		//{__in_lar_file_rd_a.index, __in_lar_file_rd_b.index,
//		//	__in_lar_file_rd_c.index} = 0;
//	end
//
//endmodule

//module FakeInstrCacheTestBench;
//	import PkgSnow64InstrCache::MSB_POS__LINE;
//	import PkgSnow64InstrCache::MSB_POS__LINE_PACKED_OUTER_DIM;
//	import PkgSnow64InstrCache::MSB_POS__LINE_PACKED_INNER_DIM;
//	import PkgSnow64InstrCache::LAST_INDEX__NUM_LINES;
//
//	logic __clk;
//
//	initial
//	begin
//		__clk = 0;
//	end
//
//	always
//	begin
//		#1
//		__clk = !__clk;
//	end
//
//	PkgSnow64InstrCache::IncomingAddr test_incoming_addr;
//
//
//	logic [MSB_POS__LINE_PACKED_OUTER_DIM:0]
//		[MSB_POS__LINE_PACKED_INNER_DIM:0]
//		lines_arr[0 : LAST_INDEX__NUM_LINES];
//
//	always_ff @(posedge __clk)
//	begin
//		test_incoming_addr.base_addr <= 0;
//		test_incoming_addr.tag <= 0;
//		test_incoming_addr.line_index <= 0;
//		test_incoming_addr.dont_care <= 0;
//	end
//
//
//endmodule
