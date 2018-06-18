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


//module TestBenchCarryBreakAlu;
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

//interface InterfAdder #(parameter WIDTH__DATA_INOUT=64)
//	(input logic [__MSB_POS__DATA_INOUT:0] in_a, in_b,
//	output logic [__MSB_POS__DATA_INOUT:0] out_data);
//
//	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(WIDTH__DATA_INOUT);
//
//	//task operate(output logic [__MSB_POS__DATA_INOUT:0] some_out);
//	//	some_out = in_a + in_b;
//	//endtask
//
//	//function add();
//	//	return in_a + in_b;
//	//endfunction
//	task operate;
//		out_data = in_a + in_b;
//	endtask
//
//endinterface
//
//
//module TestBenchInterfAdder
//	(input logic [__MSB_POS__TEST_ADDER_DATA_INOUT:0] in_a, in_b);
//
//	localparam __WIDTH__TEST_ADDER_DATA_INOUT = 8;
//	localparam __MSB_POS__TEST_ADDER_DATA_INOUT
//		= `WIDTH2MP(__WIDTH__TEST_ADDER_DATA_INOUT);
//
//	//logic __clk, __rst_n;
//	struct packed
//	{
//		logic [__MSB_POS__TEST_ADDER_DATA_INOUT:0] a, b;
//	} __in_test_adder;
//
//	struct packed
//	{
//		logic [__MSB_POS__TEST_ADDER_DATA_INOUT:0] data;
//	} __out_test_adder;
//
//	assign __in_test_adder.a = in_a;
//	assign __in_test_adder.b = in_b;
//
//	//InterfAdder #(.WIDTH__DATA_INOUT(__WIDTH__TEST_ADDER_DATA_INOUT))
//	//	__interf_test_adder(.in_a(__in_test_adder.a), 
//	//	.in_b(__in_test_adder.b), .out_data(__out_test_adder.data));
//	InterfAdder #(.WIDTH__DATA_INOUT(__WIDTH__TEST_ADDER_DATA_INOUT))
//		__interf_test_adder();
//
//	assign __interf_test_adder.in_a = __in_test_adder.a;
//	assign __interf_test_adder.in_b = __in_test_adder.b;
//
//	//always @(*)
//	////always_comb
//	//begin
//	//	//__interf_test_adder.out_data
//	//	//	= __interf_test_adder.in_a + __interf_test_adder.in_b;
//	//	__interf_test_adder.operate(__interf_test_adder.out_data);
//	//end
//	//always @(*)
//	//always @(__interf_test_adder.in_a, __interf_test_adder.in_b)
//	//begin
//	//	__interf_test_adder.out_data = __interf_test_adder.add();
//	//end
//
//	//always_comb
//	//always @(__in_test_adder)
//	//always_comb
//	//always @(*)
//	always @(__in_test_adder)
//	begin
//		__interf_test_adder.operate();
//	end
//
//endmodule


