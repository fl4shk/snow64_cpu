`include "src/snow64_alu_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"

module DebugSnow64Alu
	(input logic [`MSB_POS__SNOW64_SIZE_64:0] in_a, in_b,
	input logic [`MSB_POS__SNOW64_ALU_OPER:0] in_oper,
	input logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] in_int_type_size,
	input logic in_signedness,

	output logic [`MSB_POS__SNOW64_SIZE_64:0] out_data);

	PkgSnow64ArithLog::PortIn_Alu __in_alu;
	PkgSnow64ArithLog::PortOut_Alu __out_alu;

	Snow64Alu __inst_alu(.in(__in_alu), .out(__out_alu));

	always @(*) __in_alu.a = in_a;
	always @(*) __in_alu.b = in_b;
	always @(*) __in_alu.oper = in_oper;
	always @(*) __in_alu.int_type_size = in_int_type_size;
	always @(*) __in_alu.type_signedness = in_signedness;

	always @(*) out_data = __out_alu.data;
endmodule


//module __Snow64SubAlu(input PkgSnow64ArithLog::PortIn_SubAlu in,
//	output PkgSnow64ArithLog::PortOut_SubAlu out);
//
//	localparam __MSB_POS__DATA_INOUT
//		= `MSB_POS__SNOW64_SUB_ALU_DATA_INOUT;
//
//	logic __in_actual_carry;
//	logic __out_lts;
//	logic __performing_subtract;
//
//	SetLessThanSigned __inst_slts
//		(.in_a_msb_pos(in.a[__MSB_POS__DATA_INOUT]),
//		.in_b_msb_pos(in.b[__MSB_POS__DATA_INOUT]),
//		.in_sub_result_msb_pos(out.data[__MSB_POS__DATA_INOUT]),
//		.out_data(__out_lts));
//
//	// Performing a subtract means that we need __in_actual_carry to
//	// be set to 1'b1 **if we're ignoring in.carry**.
//	assign __performing_subtract = ((in.oper == PkgSnow64ArithLog::OpSub)
//		|| (in.oper == PkgSnow64ArithLog::OpSlt));
//
//	always @(*)
//	begin
//		out.lts = __out_lts;
//	end
//
//	always @(*)
//	begin
//		case (in.int_type_size)
//		PkgSnow64Cpu::IntTypSz8:
//		begin
//			__in_actual_carry = __performing_subtract;
//		end
//
//		//PkgSnow64Cpu::IntTypSz16:
//		default:
//		begin
//			case (in.index[0])
//			0:
//			begin
//				__in_actual_carry = __performing_subtract;
//			end
//
//			//1:
//			default:
//			begin
//				__in_actual_carry = in.carry;
//			end
//			endcase
//		end
//		endcase
//
//	end
//
//	always @(*)
//	begin
//		case (in.oper)
//		PkgSnow64ArithLog::OpAdd:
//		begin
//			{out.carry, out.data} = in.a + in.b
//				+ {{`WIDTH__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
//				__in_actual_carry};
//		end
//
//		PkgSnow64ArithLog::OpSub:
//		begin
//			{out.carry, out.data} = {1'b0, in.a} + {1'b0, (~in.b)}
//				+ {{`WIDTH__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
//				__in_actual_carry};
//		end
//
//		// Just repeat the "OpSub" stuff here.
//		PkgSnow64ArithLog::OpSlt:
//		begin
//			{out.carry, out.data} = {1'b0, in.a} + {1'b0, (~in.b)}
//				+ {{`WIDTH__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
//				__in_actual_carry};
//		end
//		PkgSnow64ArithLog::OpAnd:
//		begin
//			{out.carry, out.data} = in.a & in.b;
//		end
//		PkgSnow64ArithLog::OpOrr:
//		begin
//			{out.carry, out.data} = in.a | in.b;
//		end
//		PkgSnow64ArithLog::OpXor:
//		begin
//			{out.carry, out.data} = in.a ^ in.b;
//		end
//		PkgSnow64ArithLog::OpInv:
//		begin
//			{out.carry, out.data} = ~in.a;
//		end
//		//PkgSnow64ArithLog::OpNot:
//		//begin
//		//	// This is only used for 8-bit stuff
//		//	{out.carry, out.data} = !in.a;
//		//end
//
//		// Just repeat the "OpAdd" stuff here.
//		PkgSnow64ArithLog::OpAddAgain:
//		begin
//			{out.carry, out.data} = in.a + in.b
//				+ {{`MSB_POS__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
//				__in_actual_carry};
//		end
//
//		default:
//		begin
//			{out.carry, out.data} = 0;
//		end
//		endcase
//	end
//
//
//endmodule
//
//module Snow64Alu(input PkgSnow64ArithLog::PortIn_Alu in,
//	output PkgSnow64ArithLog::PortOut_Alu out);
//
//	// Local variables, module instantiations, and assignments
//	PkgSnow64SlicedData::SlicedData8 __in_a_sliced_8, __in_b_sliced_8,
//		__temp_data_sliced_8;
//	PkgSnow64SlicedData::SlicedData16 __in_a_sliced_16, __in_b_sliced_16,
//		__temp_data_sliced_16;
//	PkgSnow64SlicedData::SlicedData32 __in_a_sliced_32, __in_b_sliced_32,
//		__temp_data_sliced_32;
//
//	// ...slicing a 64-bit thing into 64-bit components means you're not
//	// really doing anything.
//	PkgSnow64SlicedData::SlicedData64 __in_a_sliced_64, __in_b_sliced_64,
//		__temp_data_sliced_64;
//
//	logic [PkgSnow64ArithLog::MSB_POS__OF_8:0]
//		__out_lsl_data_sliced_8_7, __out_lsl_data_sliced_8_6,
//		__out_lsl_data_sliced_8_5, __out_lsl_data_sliced_8_4,
//		__out_lsl_data_sliced_8_3, __out_lsl_data_sliced_8_2,
//		__out_lsl_data_sliced_8_1, __out_lsl_data_sliced_8_0,
//
//		__out_lsr_data_sliced_8_7, __out_lsr_data_sliced_8_6,
//		__out_lsr_data_sliced_8_5, __out_lsr_data_sliced_8_4,
//		__out_lsr_data_sliced_8_3, __out_lsr_data_sliced_8_2,
//		__out_lsr_data_sliced_8_1, __out_lsr_data_sliced_8_0,
//
//		__out_asr_data_sliced_8_7, __out_asr_data_sliced_8_6,
//		__out_asr_data_sliced_8_5, __out_asr_data_sliced_8_4,
//		__out_asr_data_sliced_8_3, __out_asr_data_sliced_8_2,
//		__out_asr_data_sliced_8_1, __out_asr_data_sliced_8_0;
//
//	logic [PkgSnow64ArithLog::MSB_POS__OF_16:0]
//		__out_lsl_data_sliced_16_3, __out_lsl_data_sliced_16_2,
//		__out_lsl_data_sliced_16_1, __out_lsl_data_sliced_16_0,
//
//		__out_lsr_data_sliced_16_3, __out_lsr_data_sliced_16_2,
//		__out_lsr_data_sliced_16_1, __out_lsr_data_sliced_16_0,
//
//		__out_asr_data_sliced_16_3, __out_asr_data_sliced_16_2,
//		__out_asr_data_sliced_16_1, __out_asr_data_sliced_16_0;
//
//	logic [PkgSnow64ArithLog::MSB_POS__OF_32:0]
//
//		__out_lsl_data_sliced_32_1, __out_lsl_data_sliced_32_0,
//		__out_lsr_data_sliced_32_1, __out_lsr_data_sliced_32_0,
//		__out_asr_data_sliced_32_1, __out_asr_data_sliced_32_0;
//
//	logic __out_slts_data_sliced_32_1, __out_slts_data_sliced_32_0;
//
//	logic [PkgSnow64ArithLog::MSB_POS__OF_64:0]
//		__out_lsl_data_sliced_64_0,
//		__out_lsr_data_sliced_64_0,
//		__out_asr_data_sliced_64_0;
//
//	logic __out_slts_data_sliced_64_0;
//
//	assign __in_a_sliced_8 = in.a;
//	assign __in_b_sliced_8 = in.b;
//
//	assign __in_a_sliced_16 = in.a;
//	assign __in_b_sliced_16 = in.b;
//
//	assign __in_a_sliced_32 = in.a;
//	assign __in_b_sliced_32 = in.b;
//
//	assign __in_a_sliced_64 = in.a;
//	assign __in_b_sliced_64 = in.b;
//
//	`define MAKE_BIT_SHIFTERS(some_width, some_num) \
//	LogicalShiftLeft``some_width __inst_lsl_``some_width``__``some_num \
//		(.in_to_shift(__in_a_sliced_``some_width``.data_``some_num), \
//		.in_amount(__in_b_sliced_``some_width``.data_``some_num), \
//		.out_data(__out_lsl_data_sliced_``some_width``_``some_num)); \
//	LogicalShiftRight``some_width __inst_lsr_``some_width``__``some_num \
//		(.in_to_shift(__in_a_sliced_``some_width``.data_``some_num), \
//		.in_amount(__in_b_sliced_``some_width``.data_``some_num), \
//		.out_data(__out_lsr_data_sliced_``some_width``_``some_num)); \
//	ArithmeticShiftRight``some_width \
//		__inst_asr_``some_width``__``some_num \
//		(.in_to_shift(__in_a_sliced_``some_width``.data_``some_num), \
//		.in_amount(__in_b_sliced_``some_width``.data_``some_num), \
//		.out_data(__out_asr_data_sliced_``some_width``_``some_num));
//
//	`MAKE_BIT_SHIFTERS(8, 7)
//	`MAKE_BIT_SHIFTERS(8, 6)
//	`MAKE_BIT_SHIFTERS(8, 5)
//	`MAKE_BIT_SHIFTERS(8, 4)
//	`MAKE_BIT_SHIFTERS(8, 3)
//	`MAKE_BIT_SHIFTERS(8, 2)
//	`MAKE_BIT_SHIFTERS(8, 1)
//	`MAKE_BIT_SHIFTERS(8, 0)
//
//	`MAKE_BIT_SHIFTERS(16, 3)
//	`MAKE_BIT_SHIFTERS(16, 2)
//	`MAKE_BIT_SHIFTERS(16, 1)
//	`MAKE_BIT_SHIFTERS(16, 0)
//
//	`MAKE_BIT_SHIFTERS(32, 1)
//	`MAKE_BIT_SHIFTERS(32, 0)
//
//	`MAKE_BIT_SHIFTERS(64, 0)
//
//	`undef MAKE_BIT_SHIFTERS
//
//	logic
//		__sub_alu_0_in_carry, __sub_alu_1_in_carry,
//		__sub_alu_2_in_carry, __sub_alu_3_in_carry,
//		__sub_alu_4_in_carry, __sub_alu_5_in_carry,
//		__sub_alu_6_in_carry, __sub_alu_7_in_carry;
//
//	logic [`MSB_POS__SNOW64_SUB_ALU_INDEX:0]
//		__sub_alu_0_in_index, __sub_alu_1_in_index,
//		__sub_alu_2_in_index, __sub_alu_3_in_index,
//		__sub_alu_4_in_index, __sub_alu_5_in_index,
//		__sub_alu_6_in_index, __sub_alu_7_in_index;
//
//	assign __sub_alu_0_in_carry = 0;
//	assign __sub_alu_1_in_carry = __out_sub_alu_0.carry;
//	assign __sub_alu_2_in_carry = __out_sub_alu_1.carry;
//	assign __sub_alu_3_in_carry = __out_sub_alu_2.carry;
//	assign __sub_alu_4_in_carry = __out_sub_alu_3.carry;
//	assign __sub_alu_5_in_carry = __out_sub_alu_4.carry;
//	assign __sub_alu_6_in_carry = __out_sub_alu_5.carry;
//	assign __sub_alu_7_in_carry = __out_sub_alu_6.carry;
//
//	assign __sub_alu_0_in_index = 0;
//	assign __sub_alu_1_in_index = 1;
//	assign __sub_alu_2_in_index = 2;
//	assign __sub_alu_3_in_index = 3;
//	assign __sub_alu_4_in_index = 4;
//	assign __sub_alu_5_in_index = 5;
//	assign __sub_alu_6_in_index = 6;
//	assign __sub_alu_7_in_index = 7;
//
//
//
//	PkgSnow64ArithLog::PortIn_SubAlu 
//		__in_sub_alu_0, __in_sub_alu_1, __in_sub_alu_2, __in_sub_alu_3,
//		__in_sub_alu_4, __in_sub_alu_5, __in_sub_alu_6, __in_sub_alu_7;
//	PkgSnow64ArithLog::PortOut_SubAlu 
//		__out_sub_alu_0, __out_sub_alu_1, __out_sub_alu_2, __out_sub_alu_3,
//		__out_sub_alu_4, __out_sub_alu_5, __out_sub_alu_6, __out_sub_alu_7;
//
//	`define ASSIGN_TO_SUB_ALU_INPUTS(some_num) \
//	always @(*) __in_sub_alu_``some_num.a \
//		= __in_a_sliced_8.data_``some_num; \
//	always @(*) __in_sub_alu_``some_num.b \
//		= __in_b_sliced_8.data_``some_num; \
//	always @(*) __in_sub_alu_``some_num.carry \
//		= __sub_alu_``some_num``_in_carry; \
//	always @(*) __in_sub_alu_``some_num``.index \
//		= __sub_alu_``some_num``_in_index; \
//	always @(*) __in_sub_alu_``some_num``.int_type_size = in.int_type_size; \
//	always @(*) __in_sub_alu_``some_num``.oper = in.oper;
//
//	`ASSIGN_TO_SUB_ALU_INPUTS(0)
//	`ASSIGN_TO_SUB_ALU_INPUTS(1)
//	`ASSIGN_TO_SUB_ALU_INPUTS(2)
//	`ASSIGN_TO_SUB_ALU_INPUTS(3)
//	`ASSIGN_TO_SUB_ALU_INPUTS(4)
//	`ASSIGN_TO_SUB_ALU_INPUTS(5)
//	`ASSIGN_TO_SUB_ALU_INPUTS(6)
//	`ASSIGN_TO_SUB_ALU_INPUTS(7)
//
//	`undef ASSIGN_TO_SUB_ALU_INPUTS
//
//	__Snow64SubAlu __inst_sub_alu_0(.in(__in_sub_alu_0),
//		.out(__out_sub_alu_0));
//	__Snow64SubAlu __inst_sub_alu_1(.in(__in_sub_alu_1),
//		.out(__out_sub_alu_1));
//	__Snow64SubAlu __inst_sub_alu_2(.in(__in_sub_alu_2),
//		.out(__out_sub_alu_2));
//	__Snow64SubAlu __inst_sub_alu_3(.in(__in_sub_alu_3),
//		.out(__out_sub_alu_3));
//	__Snow64SubAlu __inst_sub_alu_4(.in(__in_sub_alu_4),
//		.out(__out_sub_alu_4));
//	__Snow64SubAlu __inst_sub_alu_5(.in(__in_sub_alu_5),
//		.out(__out_sub_alu_5));
//	__Snow64SubAlu __inst_sub_alu_6(.in(__in_sub_alu_6),
//		.out(__out_sub_alu_6));
//	__Snow64SubAlu __inst_sub_alu_7(.in(__in_sub_alu_7),
//		.out(__out_sub_alu_7));
//
//	SetLessThanSigned __inst_slts_32_1
//		(.in_a_msb_pos(__in_a_sliced_32.data_1
//		[`MSB_POS__SNOW64_SIZE_32]),
//		.in_b_msb_pos(__in_b_sliced_32.data_1
//		[`MSB_POS__SNOW64_SIZE_32]),
//		.in_sub_result_msb_pos(__temp_data_sliced_32.data_1
//		[`MSB_POS__SNOW64_SIZE_32]),
//		.out_data(__out_slts_data_sliced_32_1));
//	SetLessThanSigned __inst_slts_32_0
//		(.in_a_msb_pos(__in_a_sliced_32.data_0
//		[`MSB_POS__SNOW64_SIZE_32]),
//		.in_b_msb_pos(__in_b_sliced_32.data_0
//		[`MSB_POS__SNOW64_SIZE_32]),
//		.in_sub_result_msb_pos(__temp_data_sliced_32.data_0
//		[`MSB_POS__SNOW64_SIZE_32]),
//		.out_data(__out_slts_data_sliced_32_0));
//	SetLessThanSigned __inst_slts_64_0
//		(.in_a_msb_pos(__in_a_sliced_64.data_0
//		[`MSB_POS__SNOW64_SIZE_64]),
//		.in_b_msb_pos(__in_b_sliced_64.data_0
//		[`MSB_POS__SNOW64_SIZE_64]),
//		.in_sub_result_msb_pos(__temp_data_sliced_64.data_0
//		[`MSB_POS__SNOW64_SIZE_64]),
//		.out_data(__out_slts_data_sliced_64_0));
//
//
//	always @(*)
//	begin
//		case (in.int_type_size)
//		PkgSnow64Cpu::IntTypSz8:
//		begin
//			out.data = __temp_data_sliced_8;
//		end
//
//		PkgSnow64Cpu::IntTypSz16:
//		begin
//			out.data = __temp_data_sliced_16;
//		end
//
//		PkgSnow64Cpu::IntTypSz32:
//		begin
//			if ((in.oper == PkgSnow64ArithLog::OpSlt) && in.type_signedness)
//			begin
//				out.data 
//					= {`ZERO_EXTEND(32, 1, __out_slts_data_sliced_32_1),
//					`ZERO_EXTEND(32, 1, __out_slts_data_sliced_32_0)};
//			end
//
//			else
//			begin
//				out.data = __temp_data_sliced_32;
//			end
//		end
//
//		PkgSnow64Cpu::IntTypSz64:
//		begin
//			if ((in.oper == PkgSnow64ArithLog::OpSlt) && in.type_signedness)
//			begin
//				out.data = __out_slts_data_sliced_64_0;
//			end
//
//			else
//			begin
//				out.data = __temp_data_sliced_64;
//			end
//		end
//		endcase
//	end
//
//	// 8-bit stuff
//	always @(*)
//	begin
//		case (in.oper)
//		PkgSnow64ArithLog::OpSlt:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_8
//					= {`ZERO_EXTEND(8, 1, !__out_sub_alu_7.carry),
//					`ZERO_EXTEND(8, 1, !__out_sub_alu_6.carry),
//					`ZERO_EXTEND(8, 1, !__out_sub_alu_5.carry),
//					`ZERO_EXTEND(8, 1, !__out_sub_alu_4.carry),
//					`ZERO_EXTEND(8, 1, !__out_sub_alu_3.carry),
//					`ZERO_EXTEND(8, 1, !__out_sub_alu_2.carry),
//					`ZERO_EXTEND(8, 1, !__out_sub_alu_1.carry),
//					`ZERO_EXTEND(8, 1, !__out_sub_alu_0.carry)};
//			end
//
//			1:
//			begin
//				__temp_data_sliced_8
//					= {`ZERO_EXTEND(8, 1, __out_sub_alu_7.lts),
//					`ZERO_EXTEND(8, 1, __out_sub_alu_6.lts),
//					`ZERO_EXTEND(8, 1, __out_sub_alu_5.lts),
//					`ZERO_EXTEND(8, 1, __out_sub_alu_4.lts),
//					`ZERO_EXTEND(8, 1, __out_sub_alu_3.lts),
//					`ZERO_EXTEND(8, 1, __out_sub_alu_2.lts),
//					`ZERO_EXTEND(8, 1, __out_sub_alu_1.lts),
//					`ZERO_EXTEND(8, 1, __out_sub_alu_0.lts)};
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpShl:
//		begin
//			__temp_data_sliced_8
//				= {__out_lsl_data_sliced_8_7,
//				__out_lsl_data_sliced_8_6,
//				__out_lsl_data_sliced_8_5,
//				__out_lsl_data_sliced_8_4,
//				__out_lsl_data_sliced_8_3,
//				__out_lsl_data_sliced_8_2,
//				__out_lsl_data_sliced_8_1,
//				__out_lsl_data_sliced_8_0};
//		end
//
//		PkgSnow64ArithLog::OpShr:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_8
//					= {__out_lsr_data_sliced_8_7,
//					__out_lsr_data_sliced_8_6,
//					__out_lsr_data_sliced_8_5,
//					__out_lsr_data_sliced_8_4,
//					__out_lsr_data_sliced_8_3,
//					__out_lsr_data_sliced_8_2,
//					__out_lsr_data_sliced_8_1,
//					__out_lsr_data_sliced_8_0};
//			end
//
//			1:
//			begin
//				__temp_data_sliced_8
//					= {__out_asr_data_sliced_8_7,
//					__out_asr_data_sliced_8_6,
//					__out_asr_data_sliced_8_5,
//					__out_asr_data_sliced_8_4,
//					__out_asr_data_sliced_8_3,
//					__out_asr_data_sliced_8_2,
//					__out_asr_data_sliced_8_1,
//					__out_asr_data_sliced_8_0};
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpNot:
//		begin
//			__temp_data_sliced_8
//				= {`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_7),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_6),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_5),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_4),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_3),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_2),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_1),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_0)};
//		end
//
//		default:
//		begin
//			__temp_data_sliced_8
//				= {__out_sub_alu_7.data, __out_sub_alu_6.data,
//				__out_sub_alu_5.data, __out_sub_alu_4.data,
//				__out_sub_alu_3.data, __out_sub_alu_2.data,
//				__out_sub_alu_1.data, __out_sub_alu_0.data};
//		end
//		endcase
//	end
//
//	// 16-bit stuff
//	always @(*)
//	begin
//		case (in.oper)
//		PkgSnow64ArithLog::OpSlt:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_16
//					= {`ZERO_EXTEND(16, 1, !__out_sub_alu_7.carry),
//					`ZERO_EXTEND(16, 1, !__out_sub_alu_5.carry),
//					`ZERO_EXTEND(16, 1, !__out_sub_alu_3.carry),
//					`ZERO_EXTEND(16, 1, !__out_sub_alu_1.carry)};
//			end
//
//			1:
//			begin
//				__temp_data_sliced_16
//					= {`ZERO_EXTEND(16, 1, __out_sub_alu_7.lts),
//					`ZERO_EXTEND(16, 1, __out_sub_alu_5.lts),
//					`ZERO_EXTEND(16, 1, __out_sub_alu_3.lts),
//					`ZERO_EXTEND(16, 1, __out_sub_alu_1.lts)};
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpShl:
//		begin
//			__temp_data_sliced_16
//				= {__out_lsl_data_sliced_16_3,
//				__out_lsl_data_sliced_16_2,
//				__out_lsl_data_sliced_16_1,
//				__out_lsl_data_sliced_16_0};
//		end
//
//		PkgSnow64ArithLog::OpShr:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_16
//					= {__out_lsr_data_sliced_16_3,
//					__out_lsr_data_sliced_16_2,
//					__out_lsr_data_sliced_16_1,
//					__out_lsr_data_sliced_16_0};
//			end
//
//			1:
//			begin
//				__temp_data_sliced_16
//					= {__out_asr_data_sliced_16_3,
//					__out_asr_data_sliced_16_2,
//					__out_asr_data_sliced_16_1,
//					__out_asr_data_sliced_16_0};
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpNot:
//		begin
//			__temp_data_sliced_16
//				= {`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_3),
//				`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_2),
//				`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_1),
//				`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_0)};
//		end
//
//		default:
//		begin
//			__temp_data_sliced_16
//				= {__out_sub_alu_7.data, __out_sub_alu_6.data,
//				__out_sub_alu_5.data, __out_sub_alu_4.data,
//				__out_sub_alu_3.data, __out_sub_alu_2.data,
//				__out_sub_alu_1.data, __out_sub_alu_0.data};
//		end
//		endcase
//	end
//
//	// 32-bit stuff
//	always @(*)
//	begin
//		case (in.oper)
//		PkgSnow64ArithLog::OpAdd:
//		begin
//			__temp_data_sliced_32
//				= {(__in_a_sliced_32.data_1 + __in_b_sliced_32.data_1),
//				(__in_a_sliced_32.data_0 + __in_b_sliced_32.data_0)};
//		end
//
//		PkgSnow64ArithLog::OpSub:
//		begin
//			__temp_data_sliced_32
//				= {(__in_a_sliced_32.data_1 - __in_b_sliced_32.data_1),
//				(__in_a_sliced_32.data_0 - __in_b_sliced_32.data_0)};
//		end
//
//		PkgSnow64ArithLog::OpSlt:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_32
//					= {`ZERO_EXTEND(32, 1, 
//					(__in_a_sliced_32.data_1 < __in_b_sliced_32.data_1)),
//					`ZERO_EXTEND(32, 1, 
//					(__in_a_sliced_32.data_0 < __in_b_sliced_32.data_0))};
//			end
//
//			1:
//			begin
//				__temp_data_sliced_32
//					= {(__in_a_sliced_32.data_1 - __in_b_sliced_32.data_1),
//					(__in_a_sliced_32.data_0 - __in_b_sliced_32.data_0)};
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpShl:
//		begin
//			__temp_data_sliced_32
//				= {__out_lsl_data_sliced_32_1, __out_lsl_data_sliced_32_0};
//		end
//		PkgSnow64ArithLog::OpShr:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_32
//					= {__out_lsr_data_sliced_32_1, 
//					__out_lsr_data_sliced_32_0};
//			end
//
//			1:
//			begin
//				__temp_data_sliced_32
//					= {__out_asr_data_sliced_32_1, 
//					__out_asr_data_sliced_32_0};
//			end
//			endcase
//		end
//		PkgSnow64ArithLog::OpNot:
//		begin
//			__temp_data_sliced_32
//				= {`ZERO_EXTEND(32, 1, !__in_a_sliced_32.data_1),
//				`ZERO_EXTEND(32, 1, !__in_a_sliced_32.data_0)};
//		end
//
//		PkgSnow64ArithLog::OpAddAgain:
//		begin
//			__temp_data_sliced_32
//				= {(__in_a_sliced_32.data_1 + __in_b_sliced_32.data_1),
//				(__in_a_sliced_32.data_0 + __in_b_sliced_32.data_0)};
//		end
//
//		// Operations that don't have any relation to the carry flag can
//		// just use the outputs from the 8-bit ALUs
//		default:
//		begin
//			__temp_data_sliced_32
//				= {__out_sub_alu_7.data, __out_sub_alu_6.data,
//				__out_sub_alu_5.data, __out_sub_alu_4.data,
//				__out_sub_alu_3.data, __out_sub_alu_2.data,
//				__out_sub_alu_1.data, __out_sub_alu_0.data};
//		end
//		endcase
//	end
//
//	// 64-bit stuff
//	always @(*)
//	begin
//		case (in.oper)
//		PkgSnow64ArithLog::OpAdd:
//		begin
//			__temp_data_sliced_64.data_0
//				= __in_a_sliced_64.data_0 + __in_b_sliced_64.data_0;
//		end
//
//		PkgSnow64ArithLog::OpSub:
//		begin
//			__temp_data_sliced_64.data_0
//				= __in_a_sliced_64.data_0 - __in_b_sliced_64.data_0;
//		end
//
//		PkgSnow64ArithLog::OpSlt:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_64.data_0
//					= __in_a_sliced_64.data_0 < __in_b_sliced_64.data_0;
//			end
//
//			1:
//			begin
//				__temp_data_sliced_64.data_0
//					= __in_a_sliced_64.data_0 - __in_b_sliced_64.data_0;
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpShl:
//		begin
//			__temp_data_sliced_64.data_0 = __out_lsl_data_sliced_64_0;
//		end
//
//		PkgSnow64ArithLog::OpShr:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_64.data_0 = __out_lsr_data_sliced_64_0;
//			end
//
//			1:
//			begin
//				__temp_data_sliced_64.data_0 = __out_asr_data_sliced_64_0;
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpNot:
//		begin
//			__temp_data_sliced_64.data_0 = !__in_a_sliced_64.data_0;
//		end
//
//		PkgSnow64ArithLog::OpAddAgain:
//		begin
//			__temp_data_sliced_64.data_0
//				= __in_a_sliced_64.data_0 + __in_b_sliced_64.data_0;
//		end
//
//		// Operations that don't have any relation to the carry flag can
//		// just use the outputs from the 8-bit ALUs
//		default:
//		begin
//			__temp_data_sliced_64
//				= {__out_sub_alu_7.data, __out_sub_alu_6.data,
//				__out_sub_alu_5.data, __out_sub_alu_4.data,
//				__out_sub_alu_3.data, __out_sub_alu_2.data,
//				__out_sub_alu_1.data, __out_sub_alu_0.data};
//		end
//		endcase
//	end
//
//
//endmodule


module Snow64Alu(input PkgSnow64ArithLog::PortIn_Alu in,
	output PkgSnow64ArithLog::PortOut_Alu out);

	// Local variables, module instantiations, and assignments

	PkgSnow64SlicedData::SlicedData8 
		__in_a_sliced_8, __in_b_sliced_8, __out_data_sliced_8;
	PkgSnow64SlicedData::SlicedData16 
		__in_a_sliced_16, __in_b_sliced_16, __out_data_sliced_16;
	PkgSnow64SlicedData::SlicedData32 
		__in_a_sliced_32, __in_b_sliced_32, __out_data_sliced_32;
	PkgSnow64SlicedData::SlicedData64 
		__in_a_sliced_64, __in_b_sliced_64, __out_data_sliced_64;


	assign __in_a_sliced_8 = in.a;
	assign __in_b_sliced_8 = in.b;

	assign __in_a_sliced_16 = in.a;
	assign __in_b_sliced_16 = in.b;

	assign __in_a_sliced_32 = in.a;
	assign __in_b_sliced_32 = in.b;

	assign __in_a_sliced_64 = in.a;
	assign __in_b_sliced_64 = in.b;


	////`define MAKE_BIT_SHIFTERS(some_width, some_id_inst) \
	////	LogicalShiftLeft``some_width __inst_lsl``some_id_inst \
	////		(.in_amount(__zero_ext``some_id_inst``_in_a), \
	////		.in_to_shift(__zero_ext``some_id_inst``_in_b), \
	////		.out_data(__out_lsl``some_id_inst``_data)); \
	////	LogicalShiftRight``some_width __inst_lsr``some_id_inst \
	////		(.in_amount(__zero_ext``some_id_inst``_in_a), \
	////		.in_to_shift(__zero_ext``some_id_inst``_in_b), \
	////		.out_data(__out_lsr``some_id_inst``_data)); \
	////	ArithmeticShiftRight``some_width __inst_asr``some_id_inst \
	////		(.in_amount(__sign_ext``some_id_inst``_in_a), \
	////		.in_to_shift(__zero_ext``some_id_inst``_in_b), \
	////		.out_data(__out_asr``some_id_inst``_data));
	//`define MAKE_INST_LSL(some_width, some_inst_lsl_name, 
	//	some_in_to_shift, some_in_amount, some_out_lsl_data) \
	//	LogicalShiftLeft``some_width some_inst_lsl_name \
	//		(.in_to_shift(some_in_to_shift), \
	//		.in_amount(some_in_amount), \
	//		.out_data(some_out_lsl_data)); \

	//`define MAKE_INST_LSR(some_width, some_inst_lsr_name,
	//	some_in_to_shift, some_in_amount, some_out_lsr_data) \
	//	LogicalShiftRight``some_width some_inst_lsr_name \
	//		(.in_to_shift(some_in_to_shift), \
	//		.in_amount(some_in_amount), \
	//		.out_data(some_out_lsr_data)); \

	//`define MAKE_INST_ASR(some_width, some_inst_asr_name,
	//	some_in_to_shift, some_in_amount, some_out_asr_data) \
	//	ArithmeticShiftRight``some_width some_inst_asr_name \
	//		(.in_to_shift(some_in_to_shift), \
	//		.in_amount(some_in_amount), \
	//		.out_data(some_out_asr_data)); \

	logic [`MSB_POS__INST_8__7__DATA_INOUT:0]
		`INST_8__7_S(__zero_ext, _in_a), `INST_8__7_S(__zero_ext, _in_b),
		`INST_8__7_S(__sign_ext, _in_a), `INST_8__7_S(__sign_ext, _in_b),
		`INST_8__7_S(__out_lsl, _data),
		`INST_8__7_S(__out_lsr, _data),
		`INST_8__7_S(__out_asr, _data),
		`INST_8__7_S(__out_slts, _data);
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__7__DATA_INOUT))
	//	`INST_8__7(__inst_slts) (.in_a(`INST_8__7_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__7_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__7_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__7__DATA_INOUT, `INST_8__7(__inst_lsl), 
	//	`INST_8__7_S(__zero_ext, _in_a), `INST_8__7_S(__zero_ext, _in_b),
	//	`INST_8__7_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__7__DATA_INOUT, `INST_8__7(__inst_lsr), 
	//	`INST_8__7_S(__zero_ext, _in_a), `INST_8__7_S(__zero_ext, _in_b),
	//	`INST_8__7_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__7__DATA_INOUT, `INST_8__7(__inst_asr), 
	//	`INST_8__7_S(__sign_ext, _in_a), `INST_8__7_S(__zero_ext, _in_b),
	//	`INST_8__7_S(__out_asr, _data))

	logic [`MSB_POS__INST_8__6__DATA_INOUT:0]
		`INST_8__6_S(__zero_ext, _in_a), `INST_8__6_S(__zero_ext, _in_b),
		`INST_8__6_S(__sign_ext, _in_a), `INST_8__6_S(__sign_ext, _in_b),
		`INST_8__6_S(__out_lsl, _data),
		`INST_8__6_S(__out_lsr, _data),
		`INST_8__6_S(__out_asr, _data),
		`INST_8__6_S(__out_slts, _data);
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__6__DATA_INOUT))
	//	`INST_8__6(__inst_slts) (.in_a(`INST_8__6_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__6_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__6_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__6__DATA_INOUT, `INST_8__6(__inst_lsl), 
	//	`INST_8__6_S(__zero_ext, _in_a), `INST_8__6_S(__zero_ext, _in_b),
	//	`INST_8__6_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__6__DATA_INOUT, `INST_8__6(__inst_lsr), 
	//	`INST_8__6_S(__zero_ext, _in_a), `INST_8__6_S(__zero_ext, _in_b),
	//	`INST_8__6_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__6__DATA_INOUT, `INST_8__6(__inst_asr), 
	//	`INST_8__6_S(__sign_ext, _in_a), `INST_8__6_S(__zero_ext, _in_b),
	//	`INST_8__6_S(__out_asr, _data))

	logic [`MSB_POS__INST_8__5__DATA_INOUT:0]
		`INST_8__5_S(__zero_ext, _in_a), `INST_8__5_S(__zero_ext, _in_b),
		`INST_8__5_S(__sign_ext, _in_a), `INST_8__5_S(__sign_ext, _in_b),
		`INST_8__5_S(__out_lsl, _data),
		`INST_8__5_S(__out_lsr, _data),
		`INST_8__5_S(__out_asr, _data),
		`INST_8__5_S(__out_slts, _data);
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__5__DATA_INOUT))
	//	`INST_8__5(__inst_slts) (.in_a(`INST_8__5_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__5_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__5_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__5__DATA_INOUT, `INST_8__5(__inst_lsl), 
	//	`INST_8__5_S(__zero_ext, _in_a), `INST_8__5_S(__zero_ext, _in_b),
	//	`INST_8__5_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__5__DATA_INOUT, `INST_8__5(__inst_lsr), 
	//	`INST_8__5_S(__zero_ext, _in_a), `INST_8__5_S(__zero_ext, _in_b),
	//	`INST_8__5_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__5__DATA_INOUT, `INST_8__5(__inst_asr), 
	//	`INST_8__5_S(__sign_ext, _in_a), `INST_8__5_S(__zero_ext, _in_b),
	//	`INST_8__5_S(__out_asr, _data))

	logic [`MSB_POS__INST_8__4__DATA_INOUT:0]
		`INST_8__4_S(__zero_ext, _in_a), `INST_8__4_S(__zero_ext, _in_b),
		`INST_8__4_S(__sign_ext, _in_a), `INST_8__4_S(__sign_ext, _in_b),
		`INST_8__4_S(__out_lsl, _data),
		`INST_8__4_S(__out_lsr, _data),
		`INST_8__4_S(__out_asr, _data),
		`INST_8__4_S(__out_slts, _data);
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__4__DATA_INOUT))
	//	`INST_8__4(__inst_slts) (.in_a(`INST_8__4_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__4_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__4_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__4__DATA_INOUT, `INST_8__4(__inst_lsl), 
	//	`INST_8__4_S(__zero_ext, _in_a), `INST_8__4_S(__zero_ext, _in_b),
	//	`INST_8__4_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__4__DATA_INOUT, `INST_8__4(__inst_lsr), 
	//	`INST_8__4_S(__zero_ext, _in_a), `INST_8__4_S(__zero_ext, _in_b),
	//	`INST_8__4_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__4__DATA_INOUT, `INST_8__4(__inst_asr), 
	//	`INST_8__4_S(__sign_ext, _in_a), `INST_8__4_S(__zero_ext, _in_b),
	//	`INST_8__4_S(__out_asr, _data))

	logic [`MSB_POS__INST_8__3__DATA_INOUT:0]
		`INST_8__3_S(__zero_ext, _in_a), `INST_8__3_S(__zero_ext, _in_b),
		`INST_8__3_S(__sign_ext, _in_a), `INST_8__3_S(__sign_ext, _in_b),
		`INST_8__3_S(__out_lsl, _data),
		`INST_8__3_S(__out_lsr, _data),
		`INST_8__3_S(__out_asr, _data),
		`INST_8__3_S(__out_slts, _data);
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__3__DATA_INOUT))
	//	`INST_8__3(__inst_slts) (.in_a(`INST_8__3_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__3_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__3_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__3__DATA_INOUT, `INST_8__3(__inst_lsl), 
	//	`INST_8__3_S(__zero_ext, _in_a), `INST_8__3_S(__zero_ext, _in_b),
	//	`INST_8__3_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__3__DATA_INOUT, `INST_8__3(__inst_lsr), 
	//	`INST_8__3_S(__zero_ext, _in_a), `INST_8__3_S(__zero_ext, _in_b),
	//	`INST_8__3_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__3__DATA_INOUT, `INST_8__3(__inst_asr), 
	//	`INST_8__3_S(__sign_ext, _in_a), `INST_8__3_S(__zero_ext, _in_b),
	//	`INST_8__3_S(__out_asr, _data))

	logic [`MSB_POS__INST_8__2__DATA_INOUT:0]
		`INST_8__2_S(__zero_ext, _in_a), `INST_8__2_S(__zero_ext, _in_b),
		`INST_8__2_S(__sign_ext, _in_a), `INST_8__2_S(__sign_ext, _in_b),
		`INST_8__2_S(__out_lsl, _data),
		`INST_8__2_S(__out_lsr, _data),
		`INST_8__2_S(__out_asr, _data),
		`INST_8__2_S(__out_slts, _data);
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__2__DATA_INOUT))
	//	`INST_8__2(__inst_slts) (.in_a(`INST_8__2_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__2_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__2_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__2__DATA_INOUT, `INST_8__2(__inst_lsl), 
	//	`INST_8__2_S(__zero_ext, _in_a), `INST_8__2_S(__zero_ext, _in_b),
	//	`INST_8__2_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__2__DATA_INOUT, `INST_8__2(__inst_lsr), 
	//	`INST_8__2_S(__zero_ext, _in_a), `INST_8__2_S(__zero_ext, _in_b),
	//	`INST_8__2_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__2__DATA_INOUT, `INST_8__2(__inst_asr), 
	//	`INST_8__2_S(__sign_ext, _in_a), `INST_8__2_S(__zero_ext, _in_b),
	//	`INST_8__2_S(__out_asr, _data))

	logic [`MSB_POS__INST_8__1__DATA_INOUT:0]
		`INST_8__1_S(__zero_ext, _in_a), `INST_8__1_S(__zero_ext, _in_b),
		`INST_8__1_S(__sign_ext, _in_a), `INST_8__1_S(__sign_ext, _in_b),
		`INST_8__1_S(__out_lsl, _data),
		`INST_8__1_S(__out_lsr, _data),
		`INST_8__1_S(__out_asr, _data),
		`INST_8__1_S(__out_slts, _data);
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__1__DATA_INOUT))
	//	`INST_8__1(__inst_slts) (.in_a(`INST_8__1_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__1_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__1_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__1__DATA_INOUT, `INST_8__1(__inst_lsl), 
	//	`INST_8__1_S(__zero_ext, _in_a), `INST_8__1_S(__zero_ext, _in_b),
	//	`INST_8__1_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__1__DATA_INOUT, `INST_8__1(__inst_lsr), 
	//	`INST_8__1_S(__zero_ext, _in_a), `INST_8__1_S(__zero_ext, _in_b),
	//	`INST_8__1_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__1__DATA_INOUT, `INST_8__1(__inst_asr), 
	//	`INST_8__1_S(__sign_ext, _in_a), `INST_8__1_S(__zero_ext, _in_b),
	//	`INST_8__1_S(__out_asr, _data))

	logic [`MSB_POS__INST_8__0__DATA_INOUT:0]
		`INST_8__0_S(__zero_ext, _in_a), `INST_8__0_S(__zero_ext, _in_b),
		`INST_8__0_S(__sign_ext, _in_a), `INST_8__0_S(__sign_ext, _in_b),
		`INST_8__0_S(__out_lsl, _data),
		`INST_8__0_S(__out_lsr, _data),
		`INST_8__0_S(__out_asr, _data),
		`INST_8__0_S(__out_slts, _data);
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__0__DATA_INOUT))
	//	`INST_8__0(__inst_slts) (.in_a(`INST_8__0_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__0_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__0_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__0__DATA_INOUT, `INST_8__0(__inst_lsl), 
	//	`INST_8__0_S(__zero_ext, _in_a), `INST_8__0_S(__zero_ext, _in_b),
	//	`INST_8__0_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__0__DATA_INOUT, `INST_8__0(__inst_lsr), 
	//	`INST_8__0_S(__zero_ext, _in_a), `INST_8__0_S(__zero_ext, _in_b),
	//	`INST_8__0_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__0__DATA_INOUT, `INST_8__0(__inst_asr), 
	//	`INST_8__0_S(__sign_ext, _in_a), `INST_8__0_S(__zero_ext, _in_b),
	//	`INST_8__0_S(__out_asr, _data))

	`define MAKE_BIT_SHIFTERS_AND_SLTS(some_width, some_num) \
	ArithmeticShiftRight``some_width \
		__inst_asr_``some_width``__``some_num \
		(.in_to_shift(__in_a_sliced_``some_width``.data_``some_num), \
		.in_amount(__in_b_sliced_``some_width``.data_``some_num), \
		.out_data(__out_asr_data_sliced_``some_width``_``some_num)); \
	SetLessThanSigned #(.WIDTH__DATA_INOUT(some_width)) \
		__inst_slts_``some_width``__``some_num \
		(.in_a(__in_a_sliced_``some_width``.data_``some_num), \
		.in_b(__in_b_sliced_``some_width``.data_``some_num), \
		.out_data(__out_slts_data_sliced_``some_width``_``some_num));


	logic [PkgSnow64ArithLog::MSB_POS__OF_8:0]
		__out_slts_data_sliced_8_7,
		__out_slts_data_sliced_8_6,
		__out_slts_data_sliced_8_5,
		__out_slts_data_sliced_8_4,
		__out_slts_data_sliced_8_3,
		__out_slts_data_sliced_8_2,
		__out_slts_data_sliced_8_1,
		__out_slts_data_sliced_8_0,

		__out_asr_data_sliced_8_7,
		__out_asr_data_sliced_8_6,
		__out_asr_data_sliced_8_5,
		__out_asr_data_sliced_8_4,
		__out_asr_data_sliced_8_3,
		__out_asr_data_sliced_8_2,
		__out_asr_data_sliced_8_1,
		__out_asr_data_sliced_8_0;

	logic [PkgSnow64ArithLog::MSB_POS__OF_16:0]
		__out_slts_data_sliced_16_3,
		__out_slts_data_sliced_16_2,
		__out_slts_data_sliced_16_1,
		__out_slts_data_sliced_16_0,

		__out_asr_data_sliced_16_3,
		__out_asr_data_sliced_16_2,
		__out_asr_data_sliced_16_1,
		__out_asr_data_sliced_16_0;

	logic [PkgSnow64ArithLog::MSB_POS__OF_32:0]
		__out_slts_data_sliced_32_1,
		__out_slts_data_sliced_32_0,

		__out_asr_data_sliced_32_1,
		__out_asr_data_sliced_32_0;

	logic [PkgSnow64ArithLog::MSB_POS__OF_64:0]
		__out_slts_data_sliced_64_0,

		__out_asr_data_sliced_64_0;

	`MAKE_BIT_SHIFTERS_AND_SLTS(8, 7)
	`MAKE_BIT_SHIFTERS_AND_SLTS(8, 6)
	`MAKE_BIT_SHIFTERS_AND_SLTS(8, 5)
	`MAKE_BIT_SHIFTERS_AND_SLTS(8, 4)
	`MAKE_BIT_SHIFTERS_AND_SLTS(8, 3)
	`MAKE_BIT_SHIFTERS_AND_SLTS(8, 2)
	`MAKE_BIT_SHIFTERS_AND_SLTS(8, 1)
	`MAKE_BIT_SHIFTERS_AND_SLTS(8, 0)

	`MAKE_BIT_SHIFTERS_AND_SLTS(16, 3)
	`MAKE_BIT_SHIFTERS_AND_SLTS(16, 2)
	`MAKE_BIT_SHIFTERS_AND_SLTS(16, 1)
	`MAKE_BIT_SHIFTERS_AND_SLTS(16, 0)

	`MAKE_BIT_SHIFTERS_AND_SLTS(32, 1)
	`MAKE_BIT_SHIFTERS_AND_SLTS(32, 0)

	`MAKE_BIT_SHIFTERS_AND_SLTS(64, 0)

	`undef MAKE_BIT_SHIFTERS_AND_SLTS


	//// Zero extend and sign extend the inputs
	//always @(*)
	//begin
	//	case (in.int_type_size)
	//	PkgSnow64Cpu::IntTypSz8:
	//	begin
	//		{`INST_8__7_S(__zero_ext, _in_a),
	//			`INST_8__7_S(__zero_ext, _in_b),
	//			`INST_8__7_S(__sign_ext, _in_a),
	//			`INST_8__7_S(__sign_ext, _in_b)}
	//			= {`ZERO_EXTEND(`WIDTH__INST_8__7__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_7),
	//			`ZERO_EXTEND(`WIDTH__INST_8__7__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_7),
	//			`SIGN_EXTEND(`WIDTH__INST_8__7__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_7),
	//			`SIGN_EXTEND(`WIDTH__INST_8__7__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_7)};
	//	end

	//	PkgSnow64Cpu::IntTypSz16:
	//	begin
	//		{`INST_16__3_S(__zero_ext, _in_a),
	//			`INST_16__3_S(__zero_ext, _in_b),
	//			`INST_16__3_S(__sign_ext, _in_a),
	//			`INST_16__3_S(__sign_ext, _in_b)}
	//			= {`ZERO_EXTEND(`WIDTH__INST_16__3__DATA_INOUT, 16,
	//			__in_a_sliced_16.data_3),
	//			`ZERO_EXTEND(`WIDTH__INST_16__3__DATA_INOUT, 16,
	//			__in_b_sliced_16.data_3),
	//			`SIGN_EXTEND(`WIDTH__INST_16__3__DATA_INOUT, 16,
	//			__in_a_sliced_16.data_3),
	//			`SIGN_EXTEND(`WIDTH__INST_16__3__DATA_INOUT, 16,
	//			__in_b_sliced_16.data_3)};
	//	end

	//	PkgSnow64Cpu::IntTypSz32:
	//	begin
	//		{`INST_32__1_S(__zero_ext, _in_a),
	//			`INST_32__1_S(__zero_ext, _in_b),
	//			`INST_32__1_S(__sign_ext, _in_a),
	//			`INST_32__1_S(__sign_ext, _in_b)}
	//			= {`ZERO_EXTEND(`WIDTH__INST_32__1__DATA_INOUT, 32,
	//			__in_a_sliced_32.data_1),
	//			`ZERO_EXTEND(`WIDTH__INST_32__1__DATA_INOUT, 32,
	//			__in_b_sliced_32.data_1),
	//			`SIGN_EXTEND(`WIDTH__INST_32__1__DATA_INOUT, 32,
	//			__in_a_sliced_32.data_1),
	//			`SIGN_EXTEND(`WIDTH__INST_32__1__DATA_INOUT, 32,
	//			__in_b_sliced_32.data_1)};
	//	end

	//	PkgSnow64Cpu::IntTypSz64:
	//	begin
	//		{`INST_64__0_S(__zero_ext, _in_a),
	//			`INST_64__0_S(__zero_ext, _in_b),
	//			`INST_64__0_S(__sign_ext, _in_a),
	//			`INST_64__0_S(__sign_ext, _in_b)}
	//			= {__in_a_sliced_64.data_0,
	//			__in_b_sliced_64.data_0,
	//			__in_a_sliced_64.data_0,
	//			__in_b_sliced_64.data_0};
	//	end
	//	endcase
	//end

	//always @(*)
	//begin
	//	case (in.int_type_size)
	//	PkgSnow64Cpu::IntTypSz8:
	//	begin
	//		{`INST_8__6_S(__zero_ext, _in_a),
	//			`INST_8__6_S(__zero_ext, _in_b),
	//			`INST_8__6_S(__sign_ext, _in_a),
	//			`INST_8__6_S(__sign_ext, _in_b)}
	//			= {`ZERO_EXTEND(`WIDTH__INST_8__6__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_6),
	//			`ZERO_EXTEND(`WIDTH__INST_8__6__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_6),
	//			`SIGN_EXTEND(`WIDTH__INST_8__6__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_6),
	//			`SIGN_EXTEND(`WIDTH__INST_8__6__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_6)};
	//	end

	//	PkgSnow64Cpu::IntTypSz16:
	//	begin
	//		{`INST_16__2_S(__zero_ext, _in_a),
	//			`INST_16__2_S(__zero_ext, _in_b),
	//			`INST_16__2_S(__sign_ext, _in_a),
	//			`INST_16__2_S(__sign_ext, _in_b)}
	//			= {`ZERO_EXTEND(`WIDTH__INST_16__2__DATA_INOUT, 16,
	//			__in_a_sliced_16.data_2),
	//			`ZERO_EXTEND(`WIDTH__INST_16__2__DATA_INOUT, 16,
	//			__in_b_sliced_16.data_2),
	//			`SIGN_EXTEND(`WIDTH__INST_16__2__DATA_INOUT, 16,
	//			__in_a_sliced_16.data_2),
	//			`SIGN_EXTEND(`WIDTH__INST_16__2__DATA_INOUT, 16,
	//			__in_b_sliced_16.data_2)};
	//	end

	//	//PkgSnow64Cpu::IntTypSz32:
	//	default:
	//	begin
	//		{`INST_32__0_S(__zero_ext, _in_a),
	//			`INST_32__0_S(__zero_ext, _in_b),
	//			`INST_32__0_S(__sign_ext, _in_a),
	//			`INST_32__0_S(__sign_ext, _in_b)}
	//			= { __in_a_sliced_32.data_0,
	//			__in_b_sliced_32.data_0,
	//			__in_a_sliced_32.data_0,
	//			__in_b_sliced_32.data_0};
	//	end
	//	endcase
	//end

	//always @(*)
	//begin
	//	case (in.int_type_size)
	//	PkgSnow64Cpu::IntTypSz8:
	//	begin
	//		{`INST_8__5_S(__zero_ext, _in_a),
	//			`INST_8__5_S(__zero_ext, _in_b),
	//			`INST_8__5_S(__sign_ext, _in_a),
	//			`INST_8__5_S(__sign_ext, _in_b)}
	//			= {`ZERO_EXTEND(`WIDTH__INST_8__5__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_5),
	//			`ZERO_EXTEND(`WIDTH__INST_8__5__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_5),
	//			`SIGN_EXTEND(`WIDTH__INST_8__5__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_5),
	//			`SIGN_EXTEND(`WIDTH__INST_8__5__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_5)};
	//	end

	//	//PkgSnow64Cpu::IntTypSz16:
	//	default:
	//	begin
	//		{`INST_16__1_S(__zero_ext, _in_a),
	//			`INST_16__1_S(__zero_ext, _in_b),
	//			`INST_16__1_S(__sign_ext, _in_a),
	//			`INST_16__1_S(__sign_ext, _in_b)}
	//			= {__in_a_sliced_16.data_1, 
	//			__in_b_sliced_16.data_1, 
	//			__in_a_sliced_16.data_1, 
	//			__in_b_sliced_16.data_1};
	//	end
	//	endcase
	//end

	//always @(*)
	//begin
	//	case (in.int_type_size)
	//	PkgSnow64Cpu::IntTypSz8:
	//	begin
	//		{`INST_8__4_S(__zero_ext, _in_a),
	//			`INST_8__4_S(__zero_ext, _in_b),
	//			`INST_8__4_S(__sign_ext, _in_a),
	//			`INST_8__4_S(__sign_ext, _in_b)}
	//			= {`ZERO_EXTEND(`WIDTH__INST_8__4__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_4),
	//			`ZERO_EXTEND(`WIDTH__INST_8__4__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_4),
	//			`SIGN_EXTEND(`WIDTH__INST_8__4__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_4),
	//			`SIGN_EXTEND(`WIDTH__INST_8__4__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_4)};
	//	end

	//	//PkgSnow64Cpu::IntTypSz16:
	//	default:
	//	begin
	//		{`INST_16__0_S(__zero_ext, _in_a),
	//			`INST_16__0_S(__zero_ext, _in_b),
	//			`INST_16__0_S(__sign_ext, _in_a),
	//			`INST_16__0_S(__sign_ext, _in_b)}
	//			= {__in_a_sliced_16.data_0,
	//			__in_b_sliced_16.data_0,
	//			__in_a_sliced_16.data_0,
	//			__in_b_sliced_16.data_0};
	//	end
	//	endcase
	//end

	//always @(*)
	//begin
	//	{`INST_8__3_S(__zero_ext, _in_a),
	//		`INST_8__3_S(__zero_ext, _in_b),
	//		`INST_8__3_S(__sign_ext, _in_a),
	//		`INST_8__3_S(__sign_ext, _in_b)}
	//		= {__in_a_sliced_8.data_3,
	//		__in_b_sliced_8.data_3,
	//		__in_a_sliced_8.data_3,
	//		__in_b_sliced_8.data_3};
	//end
	//always @(*)
	//begin
	//	{`INST_8__2_S(__zero_ext, _in_a),
	//		`INST_8__2_S(__zero_ext, _in_b),
	//		`INST_8__2_S(__sign_ext, _in_a),
	//		`INST_8__2_S(__sign_ext, _in_b)}
	//		= {__in_a_sliced_8.data_2,
	//		__in_b_sliced_8.data_2,
	//		__in_a_sliced_8.data_2,
	//		__in_b_sliced_8.data_2};
	//end
	//always @(*)
	//begin
	//	{`INST_8__1_S(__zero_ext, _in_a),
	//		`INST_8__1_S(__zero_ext, _in_b),
	//		`INST_8__1_S(__sign_ext, _in_a),
	//		`INST_8__1_S(__sign_ext, _in_b)}
	//		= {__in_a_sliced_8.data_1,
	//		__in_b_sliced_8.data_1,
	//		__in_a_sliced_8.data_1,
	//		__in_b_sliced_8.data_1};
	//end
	//always @(*)
	//begin
	//	{`INST_8__0_S(__zero_ext, _in_a),
	//		`INST_8__0_S(__zero_ext, _in_b),
	//		`INST_8__0_S(__sign_ext, _in_a),
	//		`INST_8__0_S(__sign_ext, _in_b)}
	//		= {__in_a_sliced_8.data_0,
	//		__in_b_sliced_8.data_0,
	//		__in_a_sliced_8.data_0,
	//		__in_b_sliced_8.data_0};
	//end

	// Non-shift bitwise operations treat "in.a" and "in.b" as if they're
	// just 64-bit bit vectors, and so every "in.int_type_size" value will
	// cause the same result to occur.  This allows me to slightly shrink
	// the ALU.
	logic [PkgSnow64ArithLog::MSB_POS__OF_64:0] __out_non_shift_bitwise_data;

	always @(*)
	begin
		case (in.oper)
		PkgSnow64ArithLog::OpAnd:
		begin
			__out_non_shift_bitwise_data = in.a & in.b;
		end

		PkgSnow64ArithLog::OpOrr:
		begin
			__out_non_shift_bitwise_data = in.a | in.b;
		end

		PkgSnow64ArithLog::OpXor:
		begin
			__out_non_shift_bitwise_data = in.a ^ in.b;
		end

		PkgSnow64ArithLog::OpInv:
		begin
			__out_non_shift_bitwise_data = ~in.a;
		end

		default:
		begin
			__out_non_shift_bitwise_data = 0;
		end
		endcase
	end

	always @(*)
	begin
		case (in.oper)
		PkgSnow64ArithLog::OpAdd:
		begin
			__out_data_sliced_8
				= {(__in_a_sliced_8.data_7 + __in_b_sliced_8.data_7),
				(__in_a_sliced_8.data_6 + __in_b_sliced_8.data_6),
				(__in_a_sliced_8.data_5 + __in_b_sliced_8.data_5),
				(__in_a_sliced_8.data_4 + __in_b_sliced_8.data_4),
				(__in_a_sliced_8.data_3 + __in_b_sliced_8.data_3),
				(__in_a_sliced_8.data_2 + __in_b_sliced_8.data_2),
				(__in_a_sliced_8.data_1 + __in_b_sliced_8.data_1),
				(__in_a_sliced_8.data_0 + __in_b_sliced_8.data_0)};
		end

		PkgSnow64ArithLog::OpSub:
		begin
			__out_data_sliced_8
				= {(__in_a_sliced_8.data_7 - __in_b_sliced_8.data_7),
				(__in_a_sliced_8.data_6 - __in_b_sliced_8.data_6),
				(__in_a_sliced_8.data_5 - __in_b_sliced_8.data_5),
				(__in_a_sliced_8.data_4 - __in_b_sliced_8.data_4),
				(__in_a_sliced_8.data_3 - __in_b_sliced_8.data_3),
				(__in_a_sliced_8.data_2 - __in_b_sliced_8.data_2),
				(__in_a_sliced_8.data_1 - __in_b_sliced_8.data_1),
				(__in_a_sliced_8.data_0 - __in_b_sliced_8.data_0)};
		end

		PkgSnow64ArithLog::OpSlt:
		begin
			case (in.type_signedness)
			0:
			begin
				__out_data_sliced_8
					= {`ZERO_EXTEND(8, 1, 
					__in_a_sliced_8.data_7 < __in_b_sliced_8.data_7),
					`ZERO_EXTEND(8, 1, 
					__in_a_sliced_8.data_6 < __in_b_sliced_8.data_6),
					`ZERO_EXTEND(8, 1, 
					__in_a_sliced_8.data_5 < __in_b_sliced_8.data_5),
					`ZERO_EXTEND(8, 1, 
					__in_a_sliced_8.data_4 < __in_b_sliced_8.data_4),
					`ZERO_EXTEND(8, 1, 
					__in_a_sliced_8.data_3 < __in_b_sliced_8.data_3),
					`ZERO_EXTEND(8, 1, 
					__in_a_sliced_8.data_2 < __in_b_sliced_8.data_2),
					`ZERO_EXTEND(8, 1, 
					__in_a_sliced_8.data_1 < __in_b_sliced_8.data_1),
					`ZERO_EXTEND(8, 1, 
					__in_a_sliced_8.data_0 < __in_b_sliced_8.data_0)};
			end

			1:
			begin
				//__out_data_sliced_8
				//	= {`INST_8__7_S(__out_slts, _data)[7:0],
				//	`INST_8__6_S(__out_slts, _data)[7:0],
				//	`INST_8__5_S(__out_slts, _data)[7:0],
				//	`INST_8__4_S(__out_slts, _data)[7:0],
				//	`INST_8__3_S(__out_slts, _data)[7:0],
				//	`INST_8__2_S(__out_slts, _data)[7:0],
				//	`INST_8__1_S(__out_slts, _data)[7:0],
				//	`INST_8__0_S(__out_slts, _data)[7:0]};
				__out_data_sliced_8
					= {__out_slts_data_sliced_8_7,
					__out_slts_data_sliced_8_6,
					__out_slts_data_sliced_8_5,
					__out_slts_data_sliced_8_4,
					__out_slts_data_sliced_8_3,
					__out_slts_data_sliced_8_2,
					__out_slts_data_sliced_8_1,
					__out_slts_data_sliced_8_0};
			end
			endcase
		end

		PkgSnow64ArithLog::OpAnd:
		begin
			__out_data_sliced_8 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpOrr:
		begin
			__out_data_sliced_8 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpXor:
		begin
			__out_data_sliced_8 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpShl:
		begin
			//__out_data_sliced_8
			//	= {`INST_8__7_S(__out_lsl, _data)[7:0],
			//	`INST_8__6_S(__out_lsl, _data)[7:0],
			//	`INST_8__5_S(__out_lsl, _data)[7:0],
			//	`INST_8__4_S(__out_lsl, _data)[7:0],
			//	`INST_8__3_S(__out_lsl, _data)[7:0],
			//	`INST_8__2_S(__out_lsl, _data)[7:0],
			//	`INST_8__1_S(__out_lsl, _data)[7:0],
			//	`INST_8__0_S(__out_lsl, _data)[7:0]};
			__out_data_sliced_8
				= {(__in_a_sliced_8.data_7 << __in_b_sliced_8.data_7),
				(__in_a_sliced_8.data_6 << __in_b_sliced_8.data_6),
				(__in_a_sliced_8.data_5 << __in_b_sliced_8.data_5),
				(__in_a_sliced_8.data_4 << __in_b_sliced_8.data_4),
				(__in_a_sliced_8.data_3 << __in_b_sliced_8.data_3),
				(__in_a_sliced_8.data_2 << __in_b_sliced_8.data_2),
				(__in_a_sliced_8.data_1 << __in_b_sliced_8.data_1),
				(__in_a_sliced_8.data_0 << __in_b_sliced_8.data_0)};
		end

		PkgSnow64ArithLog::OpShr:
		begin
			case (in.type_signedness)
			0:
			begin
				//__out_data_sliced_8
				//	= {`INST_8__7_S(__out_lsr, _data)[7:0],
				//	`INST_8__6_S(__out_lsr, _data)[7:0],
				//	`INST_8__5_S(__out_lsr, _data)[7:0],
				//	`INST_8__4_S(__out_lsr, _data)[7:0],
				//	`INST_8__3_S(__out_lsr, _data)[7:0],
				//	`INST_8__2_S(__out_lsr, _data)[7:0],
				//	`INST_8__1_S(__out_lsr, _data)[7:0],
				//	`INST_8__0_S(__out_lsr, _data)[7:0]};
				__out_data_sliced_8
					= {(__in_a_sliced_8.data_7 >> __in_b_sliced_8.data_7),
					(__in_a_sliced_8.data_6 >> __in_b_sliced_8.data_6),
					(__in_a_sliced_8.data_5 >> __in_b_sliced_8.data_5),
					(__in_a_sliced_8.data_4 >> __in_b_sliced_8.data_4),
					(__in_a_sliced_8.data_3 >> __in_b_sliced_8.data_3),
					(__in_a_sliced_8.data_2 >> __in_b_sliced_8.data_2),
					(__in_a_sliced_8.data_1 >> __in_b_sliced_8.data_1),
					(__in_a_sliced_8.data_0 >> __in_b_sliced_8.data_0)};
			end

			1:
			begin
				//__out_data_sliced_8
				//	= {`INST_8__7_S(__out_asr, _data)[7:0],
				//	`INST_8__6_S(__out_asr, _data)[7:0],
				//	`INST_8__5_S(__out_asr, _data)[7:0],
				//	`INST_8__4_S(__out_asr, _data)[7:0],
				//	`INST_8__3_S(__out_asr, _data)[7:0],
				//	`INST_8__2_S(__out_asr, _data)[7:0],
				//	`INST_8__1_S(__out_asr, _data)[7:0],
				//	`INST_8__0_S(__out_asr, _data)[7:0]};
				__out_data_sliced_8
					= {__out_asr_data_sliced_8_7,
					__out_asr_data_sliced_8_6,
					__out_asr_data_sliced_8_5,
					__out_asr_data_sliced_8_4,
					__out_asr_data_sliced_8_3,
					__out_asr_data_sliced_8_2,
					__out_asr_data_sliced_8_1,
					__out_asr_data_sliced_8_0};
			end
			endcase
		end

		PkgSnow64ArithLog::OpInv:
		begin
			__out_data_sliced_8 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpNot:
		begin
			__out_data_sliced_8
				= {`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_7),
				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_6),
				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_5),
				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_4),
				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_3),
				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_2),
				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_1),
				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_0)};
		end

		PkgSnow64ArithLog::OpAddAgain:
		begin
			__out_data_sliced_8
				= {(__in_a_sliced_8.data_7 + __in_b_sliced_8.data_7),
				(__in_a_sliced_8.data_6 + __in_b_sliced_8.data_6),
				(__in_a_sliced_8.data_5 + __in_b_sliced_8.data_5),
				(__in_a_sliced_8.data_4 + __in_b_sliced_8.data_4),
				(__in_a_sliced_8.data_3 + __in_b_sliced_8.data_3),
				(__in_a_sliced_8.data_2 + __in_b_sliced_8.data_2),
				(__in_a_sliced_8.data_1 + __in_b_sliced_8.data_1),
				(__in_a_sliced_8.data_0 + __in_b_sliced_8.data_0)};
		end

		default:
		begin
			__out_data_sliced_8 = 0;
		end

		endcase
	end

	always @(*)
	begin
		case (in.oper)
		PkgSnow64ArithLog::OpAdd:
		begin
			__out_data_sliced_16
				= {(__in_a_sliced_16.data_3 + __in_b_sliced_16.data_3),
				(__in_a_sliced_16.data_2 + __in_b_sliced_16.data_2),
				(__in_a_sliced_16.data_1 + __in_b_sliced_16.data_1),
				(__in_a_sliced_16.data_0 + __in_b_sliced_16.data_0)};
		end

		PkgSnow64ArithLog::OpSub:
		begin
			__out_data_sliced_16
				= {(__in_a_sliced_16.data_3 - __in_b_sliced_16.data_3),
				(__in_a_sliced_16.data_2 - __in_b_sliced_16.data_2),
				(__in_a_sliced_16.data_1 - __in_b_sliced_16.data_1),
				(__in_a_sliced_16.data_0 - __in_b_sliced_16.data_0)};
		end

		PkgSnow64ArithLog::OpSlt:
		begin
			case (in.type_signedness)
			0:
			begin
				__out_data_sliced_16
					= {`ZERO_EXTEND(16, 1, 
					__in_a_sliced_16.data_3 < __in_b_sliced_16.data_3),
					`ZERO_EXTEND(16, 1, 
					__in_a_sliced_16.data_2 < __in_b_sliced_16.data_2),
					`ZERO_EXTEND(16, 1, 
					__in_a_sliced_16.data_1 < __in_b_sliced_16.data_1),
					`ZERO_EXTEND(16, 1, 
					__in_a_sliced_16.data_0 < __in_b_sliced_16.data_0)};
			end

			1:
			begin
				//__out_data_sliced_16
				//	= {`INST_16__3_S(__out_slts, _data)[15:0],
				//	`INST_16__2_S(__out_slts, _data)[15:0],
				//	`INST_16__1_S(__out_slts, _data)[15:0],
				//	`INST_16__0_S(__out_slts, _data)[15:0]};
				__out_data_sliced_16
					= {__out_slts_data_sliced_16_3,
					__out_slts_data_sliced_16_2,
					__out_slts_data_sliced_16_1,
					__out_slts_data_sliced_16_0};
			end
			endcase
		end

		PkgSnow64ArithLog::OpAnd:
		begin
			__out_data_sliced_16 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpOrr:
		begin
			__out_data_sliced_16 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpXor:
		begin
			__out_data_sliced_16 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpShl:
		begin
			//__out_data_sliced_16
			//	= {`INST_16__3_S(__out_lsl, _data)[15:0],
			//	`INST_16__2_S(__out_lsl, _data)[15:0],
			//	`INST_16__1_S(__out_lsl, _data)[15:0],
			//	`INST_16__0_S(__out_lsl, _data)[15:0]};
			__out_data_sliced_16
				= {(__in_a_sliced_16.data_3 << __in_b_sliced_16.data_3),
				(__in_a_sliced_16.data_2 << __in_b_sliced_16.data_2),
				(__in_a_sliced_16.data_1 << __in_b_sliced_16.data_1),
				(__in_a_sliced_16.data_0 << __in_b_sliced_16.data_0)};
		end

		PkgSnow64ArithLog::OpShr:
		begin
			case (in.type_signedness)
			0:
			begin
				//__out_data_sliced_16
				//	= {`INST_16__3_S(__out_lsr, _data)[15:0],
				//	`INST_16__2_S(__out_lsr, _data)[15:0],
				//	`INST_16__1_S(__out_lsr, _data)[15:0],
				//	`INST_16__0_S(__out_lsr, _data)[15:0]};
				__out_data_sliced_16
					= {(__in_a_sliced_16.data_3
					>> __in_b_sliced_16.data_3),
					(__in_a_sliced_16.data_2
					>> __in_b_sliced_16.data_2),
					(__in_a_sliced_16.data_1
					>> __in_b_sliced_16.data_1),
					(__in_a_sliced_16.data_0
					>> __in_b_sliced_16.data_0)};
			end

			1:
			begin
				//__out_data_sliced_16
				//	= {`INST_16__3_S(__out_asr, _data)[15:0],
				//	`INST_16__2_S(__out_asr, _data)[15:0],
				//	`INST_16__1_S(__out_asr, _data)[15:0],
				//	`INST_16__0_S(__out_asr, _data)[15:0]};
				//__out_data_sliced_16
				//	= {($signed(__in_a_sliced_16.data_3)
				//	>>> __in_b_sliced_16.data_3),
				//	($signed(__in_a_sliced_16.data_2)
				//	>>> __in_b_sliced_16.data_2),
				//	($signed(__in_a_sliced_16.data_1)
				//	>>> __in_b_sliced_16.data_1),
				//	($signed(__in_a_sliced_16.data_0)
				//	>>> __in_b_sliced_16.data_0)};
				__out_data_sliced_16
					= {__out_asr_data_sliced_16_3,
					__out_asr_data_sliced_16_2,
					__out_asr_data_sliced_16_1,
					__out_asr_data_sliced_16_0};
			end
			endcase
		end

		PkgSnow64ArithLog::OpInv:
		begin
			__out_data_sliced_16 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpNot:
		begin
			__out_data_sliced_16
				= {`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_3),
				`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_2),
				`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_1),
				`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_0)};
		end

		PkgSnow64ArithLog::OpAddAgain:
		begin
			__out_data_sliced_16
				= {(__in_a_sliced_16.data_3 + __in_b_sliced_16.data_3),
				(__in_a_sliced_16.data_2 + __in_b_sliced_16.data_2),
				(__in_a_sliced_16.data_1 + __in_b_sliced_16.data_1),
				(__in_a_sliced_16.data_0 + __in_b_sliced_16.data_0)};
		end

		default:
		begin
			__out_data_sliced_16 = 0;
		end

		endcase
	end

	always @(*)
	begin
		case (in.oper)
		PkgSnow64ArithLog::OpAdd:
		begin
			__out_data_sliced_32
				= {(__in_a_sliced_32.data_1 + __in_b_sliced_32.data_1),
				(__in_a_sliced_32.data_0 + __in_b_sliced_32.data_0)};
		end

		PkgSnow64ArithLog::OpSub:
		begin
			__out_data_sliced_32
				= {(__in_a_sliced_32.data_1 - __in_b_sliced_32.data_1),
				(__in_a_sliced_32.data_0 - __in_b_sliced_32.data_0)};
		end

		PkgSnow64ArithLog::OpSlt:
		begin
			case (in.type_signedness)
			0:
			begin
				__out_data_sliced_32
					= {`ZERO_EXTEND(32, 1, 
					__in_a_sliced_32.data_1 < __in_b_sliced_32.data_1),
					`ZERO_EXTEND(32, 1, 
					__in_a_sliced_32.data_0 < __in_b_sliced_32.data_0)};
			end

			1:
			begin
				//__out_data_sliced_32
				//	= {`INST_32__1_S(__out_slts, _data)[31:0],
				//	`INST_32__0_S(__out_slts, _data)[31:0]};
				__out_data_sliced_32
					= {__out_slts_data_sliced_32_1,
					__out_slts_data_sliced_32_0};
			end
			endcase
		end

		PkgSnow64ArithLog::OpAnd:
		begin
			__out_data_sliced_32 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpOrr:
		begin
			__out_data_sliced_32 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpXor:
		begin
			__out_data_sliced_32 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpShl:
		begin
			//__out_data_sliced_32
			//	= {`INST_32__1_S(__out_lsl, _data)[31:0],
			//	`INST_32__0_S(__out_lsl, _data)[31:0]};
			__out_data_sliced_32
				= {(__in_a_sliced_32.data_1 << __in_b_sliced_32.data_1),
				(__in_a_sliced_32.data_0 << __in_b_sliced_32.data_0)};
		end

		PkgSnow64ArithLog::OpShr:
		begin
			case (in.type_signedness)
			0:
			begin
				//__out_data_sliced_32
				//	= {`INST_32__1_S(__out_lsr, _data)[31:0],
				//	`INST_32__0_S(__out_lsr, _data)[31:0]};
				__out_data_sliced_32
					= {(__in_a_sliced_32.data_1
					>> __in_b_sliced_32.data_1),
					(__in_a_sliced_32.data_0
					>> __in_b_sliced_32.data_0)};
			end

			1:
			begin
				//__out_data_sliced_32
				//	= {`INST_32__1_S(__out_asr, _data)[31:0],
				//	`INST_32__0_S(__out_asr, _data)[31:0]};
				//__out_data_sliced_32
				//	= {($signed(__in_a_sliced_32.data_1)
				//	>>> __in_b_sliced_32.data_1),
				//	($signed(__in_a_sliced_32.data_0)
				//	>> __in_b_sliced_32.data_0)};
				__out_data_sliced_32
					= {__out_asr_data_sliced_32_1,
					__out_asr_data_sliced_32_0};
			end
			endcase
		end

		PkgSnow64ArithLog::OpInv:
		begin
			__out_data_sliced_32 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpNot:
		begin
			__out_data_sliced_32
				= {`ZERO_EXTEND(32, 1, !__in_a_sliced_32.data_1),
				`ZERO_EXTEND(32, 1, !__in_a_sliced_32.data_0)};
		end

		PkgSnow64ArithLog::OpAddAgain:
		begin
			__out_data_sliced_32
				= {(__in_a_sliced_32.data_1 + __in_b_sliced_32.data_1),
				(__in_a_sliced_32.data_0 + __in_b_sliced_32.data_0)};
		end

		default:
		begin
			__out_data_sliced_32 = 0;
		end

		endcase
	end

	always @(*)
	begin
		case (in.oper)
		PkgSnow64ArithLog::OpAdd:
		begin
			__out_data_sliced_64
				= {(__in_a_sliced_64.data_0 + __in_b_sliced_64.data_0)};
		end

		PkgSnow64ArithLog::OpSub:
		begin
			__out_data_sliced_64
				= {(__in_a_sliced_64.data_0 - __in_b_sliced_64.data_0)};
		end

		PkgSnow64ArithLog::OpSlt:
		begin
			case (in.type_signedness)
			0:
			begin
				__out_data_sliced_64
					= {`ZERO_EXTEND(64, 1, 
					__in_a_sliced_64.data_0 < __in_b_sliced_64.data_0)};
			end

			1:
			begin
				//__out_data_sliced_64
				//	= {`INST_64__0_S(__out_slts, _data)[63:0]};
				__out_data_sliced_64
					= {__out_slts_data_sliced_64_0};
			end
			endcase
		end

		PkgSnow64ArithLog::OpAnd:
		begin
			__out_data_sliced_64 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpOrr:
		begin
			__out_data_sliced_64 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpXor:
		begin
			__out_data_sliced_64 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpShl:
		begin
			//__out_data_sliced_64
			//	= {`INST_64__0_S(__out_lsl, _data)[63:0]};
			__out_data_sliced_64.data_0
				= __in_a_sliced_64.data_0 << __in_b_sliced_64.data_0;
		end

		PkgSnow64ArithLog::OpShr:
		begin
			case (in.type_signedness)
			0:
			begin
				//__out_data_sliced_64
				//	= {`INST_64__0_S(__out_lsr, _data)[63:0]};
				__out_data_sliced_64.data_0
					= __in_a_sliced_64.data_0 >> __in_b_sliced_64.data_0;
			end

			1:
			begin
				//__out_data_sliced_64
				//	= {`INST_64__0_S(__out_asr, _data)[63:0]};
				//__out_data_sliced_64.data_0
				//	= $signed($signed(__in_a_sliced_64.data_0) 
				//	>>> __in_b_sliced_64.data_0);
				__out_data_sliced_64
					= {__out_asr_data_sliced_64_0};
			end
			endcase
		end

		PkgSnow64ArithLog::OpInv:
		begin
			__out_data_sliced_64 = __out_non_shift_bitwise_data;
		end

		PkgSnow64ArithLog::OpNot:
		begin
			__out_data_sliced_64
				= {`ZERO_EXTEND(64, 1, !__in_a_sliced_64.data_0)};
		end

		PkgSnow64ArithLog::OpAddAgain:
		begin
			__out_data_sliced_64
				= {(__in_a_sliced_64.data_0 + __in_b_sliced_64.data_0)};
		end

		default:
		begin
			__out_data_sliced_64 = 0;
		end

		endcase
	end

	always @(*)
	begin
		case (in.int_type_size)
		PkgSnow64Cpu::IntTypSz8:
		begin
			out.data = __out_data_sliced_8;
		end

		PkgSnow64Cpu::IntTypSz16:
		begin
			out.data = __out_data_sliced_16;
		end

		PkgSnow64Cpu::IntTypSz32:
		begin
			out.data = __out_data_sliced_32;
		end

		PkgSnow64Cpu::IntTypSz64:
		begin
			out.data = __out_data_sliced_64;
		end
		endcase
	end


endmodule

module Snow64VectorAlu(input PkgSnow64ArithLog::PortIn_VectorAlu in,
	output PkgSnow64ArithLog::PortOut_VectorAlu out);

	PkgSnow64ArithLog::PortIn_Alu __in_inst_alu_0, __in_inst_alu_1,
		__in_inst_alu_2, __in_inst_alu_3;
	PkgSnow64ArithLog::PortOut_Alu __out_inst_alu_0, __out_inst_alu_1,
		__out_inst_alu_2, __out_inst_alu_3;
	Snow64Alu __inst_alu_0(.in(__in_inst_alu_0), .out(__out_inst_alu_0));
	Snow64Alu __inst_alu_1(.in(__in_inst_alu_1), .out(__out_inst_alu_1));
	Snow64Alu __inst_alu_2(.in(__in_inst_alu_2), .out(__out_inst_alu_2));
	Snow64Alu __inst_alu_3(.in(__in_inst_alu_3), .out(__out_inst_alu_3));

	assign __in_inst_alu_0 = {in.a[0 * 64 +: 64], in.b[0 * 64 +: 64],
		in.oper, in.int_type_size, in.type_signedness};
	assign __in_inst_alu_1 = {in.a[1 * 64 +: 64], in.b[1 * 64 +: 64],
		in.oper, in.int_type_size, in.type_signedness};
	assign __in_inst_alu_2 = {in.a[2 * 64 +: 64], in.b[2 * 64 +: 64],
		in.oper, in.int_type_size, in.type_signedness};
	assign __in_inst_alu_3 = {in.a[3 * 64 +: 64], in.b[3 * 64 +: 64],
		in.oper, in.int_type_size, in.type_signedness};


	assign out.data = {__out_inst_alu_3.data, __out_inst_alu_2.data,
		__out_inst_alu_1.data, __out_inst_alu_0.data};

endmodule
