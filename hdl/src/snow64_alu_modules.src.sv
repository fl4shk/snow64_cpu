`include "src/snow64_alu_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"

//module DebugSnow64Alu
//	(input logic [`MSB_POS__SNOW64_SIZE_64:0] in_a, in_b,
//	input logic [`MSB_POS__SNOW64_ALU_OPER:0] in_oper,
//	input logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] in_int_type_size,
//	input logic in_signedness,
//
//	output logic [`MSB_POS__SNOW64_SIZE_64:0] out_data);
//
//	PkgSnow64ArithLog::PortIn_Alu __in_alu;
//	PkgSnow64ArithLog::PortOut_Alu __out_alu;
//
//	Snow64Alu __inst_alu(.in(__in_alu), .out(__out_alu));
//
//	always @(*) __in_alu.a = in_a;
//	always @(*) __in_alu.b = in_b;
//	always @(*) __in_alu.oper = in_oper;
//	always @(*) __in_alu.int_type_size = in_int_type_size;
//	always @(*) __in_alu.type_signedness = in_signedness;
//
//	always @(*) out_data = __out_alu.data;
//endmodule

module DebugSnow64Alu(input PkgSnow64ArithLog::PortIn_Alu in,
	output PkgSnow64ArithLog::PortOut_Alu out);

	Snow64Alu __inst_alu(.in(in), .out(out));
endmodule


//module __Snow64SubAlu(input PkgSnow64ArithLog::PortIn_SubAlu in,
//	output PkgSnow64ArithLog::PortOut_SubAlu out);
//
//	localparam __MSB_0 = (0 * 8) + 7;
//	localparam __MSB_1 = (1 * 8) + 7;
//	localparam __MSB_2 = (2 * 8) + 7;
//	localparam __MSB_3 = (3 * 8) + 7;
//	localparam __MSB_4 = (4 * 8) + 7;
//	localparam __MSB_5 = (5 * 8) + 7;
//	localparam __MSB_6 = (6 * 8) + 7;
//	localparam __MSB_7 = (7 * 8) + 7;
//
//	wire [`WIDTH__SNOW64_SIZE_64:0] __adc_result
//		= {1'b0, in.a} + {1'b0, in.b} + 1'b1;
//	wire [`MSB_POS__SNOW64_SIZE_64:0] __t0
//		= __adc_result[`MSB_POS__SNOW64_SIZE_64:0];
//
//	wire [`MSB_POS__SNOW64_SUB_ALU_OUT_SLT_8:0] __last_carry_in
//		= {__t0[__MSB_7], __t0[__MSB_6], __t0[__MSB_5], __t0[__MSB_4],
//		__t0[__MSB_3], __t0[__MSB_2], __t0[__MSB_1], __t0[__MSB_0]};
//
//	wire [`MSB_POS__SNOW64_SUB_ALU_OUT_SLT_8:0] __carry_out
//		= (((in.msbs_of_a ^ in.msbs_of_b) & __last_carry_in)
//		| (in.msbs_of_a & in.msbs_of_b));
//
//	assign out.slt_8
//		= {`ZERO_EXTEND(8, 1, ~__carry_out[7]),
//		`ZERO_EXTEND(8, 1, ~__carry_out[6]),
//		`ZERO_EXTEND(8, 1, ~__carry_out[5]),
//		`ZERO_EXTEND(8, 1, ~__carry_out[4]),
//		`ZERO_EXTEND(8, 1, ~__carry_out[3]),
//		`ZERO_EXTEND(8, 1, ~__carry_out[2]),
//		`ZERO_EXTEND(8, 1, ~__carry_out[1]),
//		`ZERO_EXTEND(8, 1, ~__carry_out[0])};
//	assign out.slt_16
//		= {`ZERO_EXTEND(16, 1, ~__carry_out[7]),
//		`ZERO_EXTEND(16, 1, ~__carry_out[5]),
//		`ZERO_EXTEND(16, 1, ~__carry_out[3]),
//		`ZERO_EXTEND(16, 1, ~__carry_out[1])};
//	assign out.slt_32
//		= {`ZERO_EXTEND(32, 1, ~__carry_out[7]),
//		`ZERO_EXTEND(32, 1, ~__carry_out[3])};
//	assign out.slt_64 = {`ZERO_EXTEND(64, 1, ~__carry_out[7])};
//
//	assign out.data = __t0;
//
//
//endmodule

//module Snow64Alu(input PkgSnow64ArithLog::PortIn_Alu in,
//	output PkgSnow64ArithLog::PortOut_Alu out);
//
//	localparam __MSB_0 = (0 * 8) + 7;
//	localparam __MSB_1 = (1 * 8) + 7;
//	localparam __MSB_2 = (2 * 8) + 7;
//	localparam __MSB_3 = (3 * 8) + 7;
//	localparam __MSB_4 = (4 * 8) + 7;
//	localparam __MSB_5 = (5 * 8) + 7;
//	localparam __MSB_6 = (6 * 8) + 7;
//	localparam __MSB_7 = (7 * 8) + 7;
//
//	localparam __ADD_8_MASK = `WIDTH__SNOW64_SIZE_64'h7f7f_7f7f_7f7f_7f7f;
//	localparam __ADD_16_MASK = `WIDTH__SNOW64_SIZE_64'h7fff_7fff_7fff_7fff;
//	localparam __ADD_32_MASK = `WIDTH__SNOW64_SIZE_64'h7fff_ffff_7fff_ffff;
//	localparam __ADD_64_MASK = `WIDTH__SNOW64_SIZE_64'h7fff_ffff_ffff_ffff;
//
//	localparam __SUB_8_BIT_SETTER_THING = ~__ADD_8_MASK;
//	localparam __SUB_16_BIT_SETTER_THING = ~__ADD_16_MASK;
//	localparam __SUB_32_BIT_SETTER_THING = ~__ADD_32_MASK;
//	localparam __SUB_64_BIT_SETTER_THING = ~__ADD_64_MASK;
//
//
//	wire [`MSB_POS__SLICE_64_TO_8:0][`MSB_POS__SNOW64_SIZE_8:0]
//		__in_a_sliced_8 = in.a,
//		__in_b_sliced_8 = in.b,
//		__inv_in_b_sliced_8 = ~in.b;
//
//	wire [`MSB_POS__SLICE_64_TO_16:0][`MSB_POS__SNOW64_SIZE_16:0]
//		__in_a_sliced_16 = in.a,
//		__in_b_sliced_16 = in.b,
//		__inv_in_b_sliced_16 = ~in.b;
//
//	wire [`MSB_POS__SLICE_64_TO_32:0][`MSB_POS__SNOW64_SIZE_32:0]
//		__in_a_sliced_32 = in.a,
//		__in_b_sliced_32 = in.b,
//		__inv_in_b_sliced_32 = ~in.b;
//
//	wire [`MSB_POS__SLICE_64_TO_64:0][`MSB_POS__SNOW64_SIZE_64:0]
//		__in_a_sliced_64 = in.a,
//		__in_b_sliced_64 = in.b,
//		__inv_in_b_sliced_64 = ~in.b;
//
//
//	`define PERF_ADD(width) \
//		(((in.a & __ADD_``width``_MASK) + (in.b & __ADD_``width``_MASK)) \
//		^ ((in.a ^ in.b) & __SUB_``width``_BIT_SETTER_THING))
//
//	wire [`MSB_POS__SNOW64_SIZE_64:0] __add_8_result = `PERF_ADD(8);
//	wire [`MSB_POS__SNOW64_SIZE_64:0] __add_16_result = `PERF_ADD(16);
//	wire [`MSB_POS__SNOW64_SIZE_64:0] __add_32_result = `PERF_ADD(32);
//	wire [`MSB_POS__SNOW64_SIZE_64:0] __add_64_result = in.a + in.b;
//	`undef PERF_ADD
//
//
//	`define COMPUTE_SUB_T0(width) \
//		{1'b0, ((in.a & __ADD_``width``_MASK) \
//		| __SUB_``width``_BIT_SETTER_THING)} \
//		+ {1'b0, ((__inv_in_b_sliced_64 & __ADD_``width``_MASK) \
//		| __SUB_``width``_BIT_SETTER_THING)} \
//		+ 1'b1
//
//	wire [`WIDTH__SNOW64_SIZE_64:0] __sub_8_t0 = `COMPUTE_SUB_T0(8);
//	wire [`WIDTH__SNOW64_SIZE_64:0] __sub_16_t0 = `COMPUTE_SUB_T0(16);
//	wire [`WIDTH__SNOW64_SIZE_64:0] __sub_32_t0 = `COMPUTE_SUB_T0(32);
//	`undef COMPUTE_SUB_T0
//
//	wire [`MSB_POS__SLICE_64_TO_8:0][`MSB_POS__SNOW64_SIZE_8:0]
//		__sub_8_t0__sliced = __sub_8_t0;
//	wire [`MSB_POS__SLICE_64_TO_16:0][`MSB_POS__SNOW64_SIZE_16:0]
//		__sub_16_t0__sliced = __sub_16_t0;
//	wire [`MSB_POS__SLICE_64_TO_32:0][`MSB_POS__SNOW64_SIZE_32:0]
//		__sub_32_t0__sliced = __sub_32_t0;
//
//
//	`define COMPUTE_SUB_RESULT(width) \
//		(__sub_``width``_t0 ^ ((in.a ^ __inv_in_b_sliced_64) \
//		& __SUB_``width``_BIT_SETTER_THING))
//
//	wire [`MSB_POS__SNOW64_SIZE_64:0] __sub_8_result
//		= `COMPUTE_SUB_RESULT(8);
//	wire [`MSB_POS__SNOW64_SIZE_64:0] __sub_16_result
//		= `COMPUTE_SUB_RESULT(16);
//	wire [`MSB_POS__SNOW64_SIZE_64:0] __sub_32_result
//		= `COMPUTE_SUB_RESULT(32);
//	`undef COMPUTE_SUB_RESULT
//
//
//	wire [`WIDTH__SNOW64_SIZE_64:0] __sub_64_result
//		= {1'b0, in.a} + {1'b0, __inv_in_b_sliced_64} + 1'b1;
//
//
//	wire __sub_64_sltu = ~__sub_64_result[`WIDTH__SNOW64_SIZE_64];
//	wire __sub_64_slts;
//	__RawSetLessThanSigned __inst_raw_slts_64
//		(.in_a_msb_pos(__in_a_sliced_64[0][`MSB_POS__SNOW64_SIZE_64]),
//		.in_b_msb_pos(__in_b_sliced_64[0][`MSB_POS__SNOW64_SIZE_64]),
//		.in_sub_result_msb_pos(__sub_64_result[`MSB_POS__SNOW64_SIZE_64]),
//		.out_data(__sub_64_slts));
//
//
//	wire [`MSB_POS__SLICE_64_TO_8:0][`MSB_POS__SNOW64_SIZE_8:0]
//		__sub_8_result__sliced = __sub_8_result;
//	wire [`MSB_POS__SLICE_64_TO_16:0][`MSB_POS__SNOW64_SIZE_16:0]
//		__sub_16_result__sliced = __sub_16_result;
//	wire [`MSB_POS__SLICE_64_TO_32:0][`MSB_POS__SNOW64_SIZE_32:0]
//		__sub_32_result__sliced = __sub_32_result;
//
//
//
//
//	wire [`MSB_POS__SLICE_64_TO_8:0]
//		__a_msbs_8, __inv_b_msbs_8, __last_carries_in_8, __sub_8_sltu;
//	wire [`MSB_POS__SLICE_64_TO_16:0]
//		__a_msbs_16, __inv_b_msbs_16, __last_carries_in_16, __sub_16_sltu;
//	wire [`MSB_POS__SLICE_64_TO_32:0]
//		__a_msbs_32, __inv_b_msbs_32, __last_carries_in_32, __sub_32_sltu;
//
//	assign __a_msbs_8
//		= {__in_a_sliced_8[7][`MSB_POS__SNOW64_SIZE_8],
//		__in_a_sliced_8[6][`MSB_POS__SNOW64_SIZE_8],
//		__in_a_sliced_8[5][`MSB_POS__SNOW64_SIZE_8],
//		__in_a_sliced_8[4][`MSB_POS__SNOW64_SIZE_8],
//		__in_a_sliced_8[3][`MSB_POS__SNOW64_SIZE_8],
//		__in_a_sliced_8[2][`MSB_POS__SNOW64_SIZE_8],
//		__in_a_sliced_8[1][`MSB_POS__SNOW64_SIZE_8],
//		__in_a_sliced_8[0][`MSB_POS__SNOW64_SIZE_8]};
//	assign __inv_b_msbs_8
//		= {__inv_in_b_sliced_8[7][`MSB_POS__SNOW64_SIZE_8],
//		__inv_in_b_sliced_8[6][`MSB_POS__SNOW64_SIZE_8],
//		__inv_in_b_sliced_8[5][`MSB_POS__SNOW64_SIZE_8],
//		__inv_in_b_sliced_8[4][`MSB_POS__SNOW64_SIZE_8],
//		__inv_in_b_sliced_8[3][`MSB_POS__SNOW64_SIZE_8],
//		__inv_in_b_sliced_8[2][`MSB_POS__SNOW64_SIZE_8],
//		__inv_in_b_sliced_8[1][`MSB_POS__SNOW64_SIZE_8],
//		__inv_in_b_sliced_8[0][`MSB_POS__SNOW64_SIZE_8]};
//	assign __last_carries_in_8
//		= {__sub_8_t0__sliced[7][`MSB_POS__SNOW64_SIZE_8],
//		__sub_8_t0__sliced[6][`MSB_POS__SNOW64_SIZE_8],
//		__sub_8_t0__sliced[5][`MSB_POS__SNOW64_SIZE_8],
//		__sub_8_t0__sliced[4][`MSB_POS__SNOW64_SIZE_8],
//		__sub_8_t0__sliced[3][`MSB_POS__SNOW64_SIZE_8],
//		__sub_8_t0__sliced[2][`MSB_POS__SNOW64_SIZE_8],
//		__sub_8_t0__sliced[1][`MSB_POS__SNOW64_SIZE_8],
//		__sub_8_t0__sliced[0][`MSB_POS__SNOW64_SIZE_8]};
//
//	assign __a_msbs_16
//		= {__in_a_sliced_16[3][`MSB_POS__SNOW64_SIZE_16],
//		__in_a_sliced_16[2][`MSB_POS__SNOW64_SIZE_16],
//		__in_a_sliced_16[1][`MSB_POS__SNOW64_SIZE_16],
//		__in_a_sliced_16[0][`MSB_POS__SNOW64_SIZE_16]};
//	assign __inv_b_msbs_16
//		= {__inv_in_b_sliced_16[3][`MSB_POS__SNOW64_SIZE_16],
//		__inv_in_b_sliced_16[2][`MSB_POS__SNOW64_SIZE_16],
//		__inv_in_b_sliced_16[1][`MSB_POS__SNOW64_SIZE_16],
//		__inv_in_b_sliced_16[0][`MSB_POS__SNOW64_SIZE_16]};
//	assign __last_carries_in_16
//		= {__sub_16_t0__sliced[3][`MSB_POS__SNOW64_SIZE_16],
//		__sub_16_t0__sliced[2][`MSB_POS__SNOW64_SIZE_16],
//		__sub_16_t0__sliced[1][`MSB_POS__SNOW64_SIZE_16],
//		__sub_16_t0__sliced[0][`MSB_POS__SNOW64_SIZE_16]};
//
//	assign __a_msbs_32
//		= {__in_a_sliced_32[1][`MSB_POS__SNOW64_SIZE_32],
//		__in_a_sliced_32[0][`MSB_POS__SNOW64_SIZE_32]};
//	assign __inv_b_msbs_32
//		= {__inv_in_b_sliced_32[1][`MSB_POS__SNOW64_SIZE_32],
//		__inv_in_b_sliced_32[0][`MSB_POS__SNOW64_SIZE_32]};
//	assign __last_carries_in_32
//		= {__sub_32_t0__sliced[1][`MSB_POS__SNOW64_SIZE_32],
//		__sub_32_t0__sliced[0][`MSB_POS__SNOW64_SIZE_32]};
//
//
//	assign __sub_8_sltu
//		= ~(((__a_msbs_8 ^ __inv_b_msbs_8) & __last_carries_in_8)
//		| (__a_msbs_8 & __inv_b_msbs_8));
//	assign __sub_16_sltu
//		= ~(((__a_msbs_16 ^ __inv_b_msbs_16) & __last_carries_in_16)
//		| (__a_msbs_16 & __inv_b_msbs_16));
//	assign __sub_32_sltu
//		= ~(((__a_msbs_32 ^ __inv_b_msbs_32) & __last_carries_in_32)
//		| (__a_msbs_32 & __inv_b_msbs_32));
//
//
//	wire __sub_8_slts__0, __sub_8_slts__1,
//		__sub_8_slts__2, __sub_8_slts__3,
//		__sub_8_slts__4, __sub_8_slts__5,
//		__sub_8_slts__6, __sub_8_slts__7;
//	wire __sub_16_slts__0, __sub_16_slts__1,
//		__sub_16_slts__2, __sub_16_slts__3;
//	wire __sub_32_slts__0, __sub_32_slts__1;
//
//
//	wire [`MSB_POS__SNOW64_SIZE_8:0]
//		__out_inst_lsl8_0__data, __out_inst_lsl8_1__data,
//		__out_inst_lsl8_2__data, __out_inst_lsl8_3__data,
//		__out_inst_lsl8_4__data, __out_inst_lsl8_5__data,
//		__out_inst_lsl8_6__data, __out_inst_lsl8_7__data,
//
//		__out_inst_lsr8_0__data, __out_inst_lsr8_1__data,
//		__out_inst_lsr8_2__data, __out_inst_lsr8_3__data,
//		__out_inst_lsr8_4__data, __out_inst_lsr8_5__data,
//		__out_inst_lsr8_6__data, __out_inst_lsr8_7__data,
//
//		__out_inst_asr8_0__data, __out_inst_asr8_1__data,
//		__out_inst_asr8_2__data, __out_inst_asr8_3__data,
//		__out_inst_asr8_4__data, __out_inst_asr8_5__data,
//		__out_inst_asr8_6__data, __out_inst_asr8_7__data;
//
//	wire [`MSB_POS__SNOW64_SIZE_16:0]
//		__out_inst_lsl16_0__data, __out_inst_lsl16_1__data,
//		__out_inst_lsl16_2__data, __out_inst_lsl16_3__data,
//
//		__out_inst_lsr16_0__data, __out_inst_lsr16_1__data,
//		__out_inst_lsr16_2__data, __out_inst_lsr16_3__data,
//
//		__out_inst_asr16_0__data, __out_inst_asr16_1__data,
//		__out_inst_asr16_2__data, __out_inst_asr16_3__data;
//
//	wire [`MSB_POS__SNOW64_SIZE_32:0]
//		__out_inst_lsl32_0__data, __out_inst_lsl32_1__data,
//
//		__out_inst_lsr32_0__data, __out_inst_lsr32_1__data,
//
//		__out_inst_asr32_0__data, __out_inst_asr32_1__data;
//
//	wire [`MSB_POS__SNOW64_SIZE_64:0]
//		__out_inst_lsl64_0__data, __out_inst_lsr64_0__data,
//		__out_inst_asr64_0__data;
//
//
//	LogicalShiftLeft64 __inst_lsl64_0(.in_to_shift(in.a),
//		.in_amount(in.b), .out_data(__out_inst_lsl64_0__data));
//	LogicalShiftRight64 __inst_lsr64_0(.in_to_shift(in.a),
//		.in_amount(in.b), .out_data(__out_inst_lsr64_0__data));
//	ArithmeticShiftRight64 __inst_asr64_0(.in_to_shift(in.a),
//		.in_amount(in.b), .out_data(__out_inst_asr64_0__data));
//
//
//	`define X(which) \
//	__RawSetLessThanSigned __inst_raw_slts_8_``which \
//		(.in_a_msb_pos \
//			(__in_a_sliced_8[which][`MSB_POS__SNOW64_SIZE_8]), \
//		.in_b_msb_pos(__in_b_sliced_8[which][`MSB_POS__SNOW64_SIZE_8]), \
//		.in_sub_result_msb_pos(__sub_8_result__sliced[which] \
//			[`MSB_POS__SNOW64_SIZE_8]), \
//		.out_data(__sub_8_slts__``which)); \
//	LogicalShiftLeft8 __inst_lsl8_``which \
//		(.in_to_shift(__in_a_sliced_8[which]), \
//		.in_amount(__in_b_sliced_8[which]), \
//		.out_data(__out_inst_lsl8_``which``__data)); \
//	LogicalShiftRight8 __inst_lsr8_``which \
//		(.in_to_shift(__in_a_sliced_8[which]), \
//		.in_amount(__in_b_sliced_8[which]), \
//		.out_data(__out_inst_lsr8_``which``__data)); \
//	ArithmeticShiftRight8 __inst_asr8_``which \
//		(.in_to_shift(__in_a_sliced_8[which]), \
//		.in_amount(__in_b_sliced_8[which]), \
//		.out_data(__out_inst_asr8_``which``__data));
//	`X(0) `X(1) `X(2) `X(3) `X(4) `X(5) `X(6) `X(7)
//	`undef X
//	`define X(which) \
//	__RawSetLessThanSigned __inst_raw_slts_16_``which \
//		(.in_a_msb_pos \
//			(__in_a_sliced_16[which][`MSB_POS__SNOW64_SIZE_16]), \
//		.in_b_msb_pos(__in_b_sliced_16[which][`MSB_POS__SNOW64_SIZE_16]), \
//		.in_sub_result_msb_pos(__sub_16_result__sliced[which] \
//			[`MSB_POS__SNOW64_SIZE_16]), \
//		.out_data(__sub_16_slts__``which)); \
//	LogicalShiftLeft16 __inst_lsl16_``which \
//		(.in_to_shift(__in_a_sliced_16[which]), \
//		.in_amount(__in_b_sliced_16[which]), \
//		.out_data(__out_inst_lsl16_``which``__data)); \
//	LogicalShiftRight16 __inst_lsr16_``which \
//		(.in_to_shift(__in_a_sliced_16[which]), \
//		.in_amount(__in_b_sliced_16[which]), \
//		.out_data(__out_inst_lsr16_``which``__data)); \
//	ArithmeticShiftRight16 __inst_asr16_``which \
//		(.in_to_shift(__in_a_sliced_16[which]), \
//		.in_amount(__in_b_sliced_16[which]), \
//		.out_data(__out_inst_asr16_``which``__data));
//	`X(0) `X(1) `X(2) `X(3)
//	`undef X
//	`define X(which) \
//	__RawSetLessThanSigned __inst_raw_slts_32_``which \
//		(.in_a_msb_pos \
//			(__in_a_sliced_32[which][`MSB_POS__SNOW64_SIZE_32]), \
//		.in_b_msb_pos(__in_b_sliced_32[which][`MSB_POS__SNOW64_SIZE_32]), \
//		.in_sub_result_msb_pos(__sub_32_result__sliced[which] \
//			[`MSB_POS__SNOW64_SIZE_32]), \
//		.out_data(__sub_32_slts__``which)); \
//	LogicalShiftLeft32 __inst_lsl32_``which \
//		(.in_to_shift(__in_a_sliced_32[which]), \
//		.in_amount(__in_b_sliced_32[which]), \
//		.out_data(__out_inst_lsl32_``which``__data)); \
//	LogicalShiftRight32 __inst_lsr32_``which \
//		(.in_to_shift(__in_a_sliced_32[which]), \
//		.in_amount(__in_b_sliced_32[which]), \
//		.out_data(__out_inst_lsr32_``which``__data)); \
//	ArithmeticShiftRight32 __inst_asr32_``which \
//		(.in_to_shift(__in_a_sliced_32[which]), \
//		.in_amount(__in_b_sliced_32[which]), \
//		.out_data(__out_inst_asr32_``which``__data));
//	`X(0) `X(1)
//	`undef X
//
//	logic [`MSB_POS__SNOW64_SIZE_64:0]
//		__real_out_data_8, __real_out_data_16,
//		__real_out_data_32, __real_out_data_64;
//
//	always @(*)
//	begin
//		case (in.oper)
//		PkgSnow64ArithLog::OpAdd:
//		begin
//			__real_out_data_8 = __add_8_result;
//		end
//
//		PkgSnow64ArithLog::OpSub:
//		begin
//			__real_out_data_8 = __sub_8_result;
//		end
//
//		PkgSnow64ArithLog::OpSlt:
//		begin
//			case (in.type_signedness)
//			1'b0:
//			begin
//			  __real_out_data_8
//			  	= {`ZERO_EXTEND(8, 1, __sub_8_sltu[7]),
//			  	`ZERO_EXTEND(8, 1, __sub_8_sltu[6]),
//			  	`ZERO_EXTEND(8, 1, __sub_8_sltu[5]),
//			  	`ZERO_EXTEND(8, 1, __sub_8_sltu[4]),
//			  	`ZERO_EXTEND(8, 1, __sub_8_sltu[3]),
//			  	`ZERO_EXTEND(8, 1, __sub_8_sltu[2]),
//			  	`ZERO_EXTEND(8, 1, __sub_8_sltu[1]),
//			  	`ZERO_EXTEND(8, 1, __sub_8_sltu[0])};
//			end
//
//			1'b1:
//			begin
//				__real_out_data_8
//					= {`ZERO_EXTEND(8, 1, __sub_8_slts__7),
//					`ZERO_EXTEND(8, 1, __sub_8_slts__6),
//					`ZERO_EXTEND(8, 1, __sub_8_slts__5),
//					`ZERO_EXTEND(8, 1, __sub_8_slts__4),
//					`ZERO_EXTEND(8, 1, __sub_8_slts__3),
//					`ZERO_EXTEND(8, 1, __sub_8_slts__2),
//					`ZERO_EXTEND(8, 1, __sub_8_slts__1),
//					`ZERO_EXTEND(8, 1, __sub_8_slts__0)};
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpAnd:
//		begin
//			__real_out_data_8 = in.a & in.b;
//		end
//
//		PkgSnow64ArithLog::OpOrr:
//		begin
//			__real_out_data_8 = in.a | in.b;
//		end
//
//		PkgSnow64ArithLog::OpXor:
//		begin
//			__real_out_data_8 = in.a ^ in.b;
//		end
//
//		PkgSnow64ArithLog::OpShl:
//		begin
//			__real_out_data_8
//				= {__out_inst_lsl8_7__data,
//				__out_inst_lsl8_6__data,
//				__out_inst_lsl8_5__data,
//				__out_inst_lsl8_4__data,
//				__out_inst_lsl8_3__data,
//				__out_inst_lsl8_2__data,
//				__out_inst_lsl8_1__data,
//				__out_inst_lsl8_0__data};
//		end
//
//		PkgSnow64ArithLog::OpShr:
//		begin
//			case (in.type_signedness)
//			1'b0:
//			begin
//				__real_out_data_8
//					= {__out_inst_lsr8_7__data,
//					__out_inst_lsr8_6__data,
//					__out_inst_lsr8_5__data,
//					__out_inst_lsr8_4__data,
//					__out_inst_lsr8_3__data,
//					__out_inst_lsr8_2__data,
//					__out_inst_lsr8_1__data,
//					__out_inst_lsr8_0__data};
//			end
//
//			1'b1:
//			begin
//				__real_out_data_8
//					= {__out_inst_asr8_7__data,
//					__out_inst_asr8_6__data,
//					__out_inst_asr8_5__data,
//					__out_inst_asr8_4__data,
//					__out_inst_asr8_3__data,
//					__out_inst_asr8_2__data,
//					__out_inst_asr8_1__data,
//					__out_inst_asr8_0__data};
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpInv:
//		begin
//			__real_out_data_8 = ~in.a;
//		end
//
//		PkgSnow64ArithLog::OpNot:
//		begin
//			__real_out_data_8
//				= {`ZERO_EXTEND(8, 1, !__in_a_sliced_8[7]),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8[6]),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8[5]),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8[4]),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8[3]),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8[2]),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8[1]),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8[0])};
//		end
//
//		PkgSnow64ArithLog::OpAddAgain:
//		begin
//			__real_out_data_8 = __add_8_result;
//		end
//
//		default:
//		begin
//			__real_out_data_8 = 0;
//		end
//		endcase
//	end
//
//	always @(*)
//	begin
//		case (in.oper)
//		PkgSnow64ArithLog::OpAdd:
//		begin
//			__real_out_data_16 = __add_16_result;
//		end
//
//		PkgSnow64ArithLog::OpSub:
//		begin
//			__real_out_data_16 = __sub_16_result;
//		end
//
//		PkgSnow64ArithLog::OpSlt:
//		begin
//			case (in.type_signedness)
//			1'b0:
//			begin
//			  __real_out_data_16
//			  	= {`ZERO_EXTEND(16, 1, __sub_16_sltu[3]),
//			  	`ZERO_EXTEND(16, 1, __sub_16_sltu[2]),
//			  	`ZERO_EXTEND(16, 1, __sub_16_sltu[1]),
//			  	`ZERO_EXTEND(16, 1, __sub_16_sltu[0])};
//			end
//
//			1'b1:
//			begin
//				__real_out_data_16
//					= {`ZERO_EXTEND(16, 1, __sub_16_slts__3),
//					`ZERO_EXTEND(16, 1, __sub_16_slts__2),
//					`ZERO_EXTEND(16, 1, __sub_16_slts__1),
//					`ZERO_EXTEND(16, 1, __sub_16_slts__0)};
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpAnd:
//		begin
//			__real_out_data_16 = in.a & in.b;
//		end
//
//		PkgSnow64ArithLog::OpOrr:
//		begin
//			__real_out_data_16 = in.a | in.b;
//		end
//
//		PkgSnow64ArithLog::OpXor:
//		begin
//			__real_out_data_16 = in.a ^ in.b;
//		end
//
//		PkgSnow64ArithLog::OpShl:
//		begin
//			__real_out_data_16
//				= {__out_inst_lsl16_3__data,
//				__out_inst_lsl16_2__data,
//				__out_inst_lsl16_1__data,
//				__out_inst_lsl16_0__data};
//		end
//
//		PkgSnow64ArithLog::OpShr:
//		begin
//			case (in.type_signedness)
//			1'b0:
//			begin
//				__real_out_data_16
//					= {__out_inst_lsr16_3__data,
//					__out_inst_lsr16_2__data,
//					__out_inst_lsr16_1__data,
//					__out_inst_lsr16_0__data};
//			end
//
//			1'b1:
//			begin
//				__real_out_data_16
//					= {__out_inst_asr16_3__data,
//					__out_inst_asr16_2__data,
//					__out_inst_asr16_1__data,
//					__out_inst_asr16_0__data};
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpInv:
//		begin
//			__real_out_data_16 = ~in.a;
//		end
//
//		PkgSnow64ArithLog::OpNot:
//		begin
//			__real_out_data_16
//				= {`ZERO_EXTEND(16, 1, !__in_a_sliced_16[3]),
//				`ZERO_EXTEND(16, 1, !__in_a_sliced_16[2]),
//				`ZERO_EXTEND(16, 1, !__in_a_sliced_16[1]),
//				`ZERO_EXTEND(16, 1, !__in_a_sliced_16[0])};
//		end
//
//		PkgSnow64ArithLog::OpAddAgain:
//		begin
//			__real_out_data_16 = __add_16_result;
//		end
//
//		default:
//		begin
//			__real_out_data_16 = 0;
//		end
//		endcase
//	end
//
//	always @(*)
//	begin
//		case (in.oper)
//		PkgSnow64ArithLog::OpAdd:
//		begin
//			__real_out_data_32 = __add_32_result;
//		end
//
//		PkgSnow64ArithLog::OpSub:
//		begin
//			__real_out_data_32 = __sub_32_result;
//		end
//
//		PkgSnow64ArithLog::OpSlt:
//		begin
//			case (in.type_signedness)
//			1'b0:
//			begin
//			  __real_out_data_32
//			  	= {`ZERO_EXTEND(32, 1, __sub_32_sltu[1]),
//			  	`ZERO_EXTEND(32, 1, __sub_32_sltu[0])};
//			end
//
//			1'b1:
//			begin
//				__real_out_data_32
//					= {`ZERO_EXTEND(32, 1, __sub_32_slts__1),
//					`ZERO_EXTEND(32, 1, __sub_32_slts__0)};
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpAnd:
//		begin
//			__real_out_data_32 = in.a & in.b;
//		end
//
//		PkgSnow64ArithLog::OpOrr:
//		begin
//			__real_out_data_32 = in.a | in.b;
//		end
//
//		PkgSnow64ArithLog::OpXor:
//		begin
//			__real_out_data_32 = in.a ^ in.b;
//		end
//
//		PkgSnow64ArithLog::OpShl:
//		begin
//			__real_out_data_32
//				= {__out_inst_lsl32_1__data,
//				__out_inst_lsl32_0__data};
//		end
//
//		PkgSnow64ArithLog::OpShr:
//		begin
//			case (in.type_signedness)
//			1'b0:
//			begin
//				__real_out_data_32
//					= {__out_inst_lsr32_1__data,
//					__out_inst_lsr32_0__data};
//			end
//
//			1'b1:
//			begin
//				__real_out_data_32
//					= {__out_inst_asr32_1__data,
//					__out_inst_asr32_0__data};
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpInv:
//		begin
//			__real_out_data_32 = ~in.a;
//		end
//
//		PkgSnow64ArithLog::OpNot:
//		begin
//			__real_out_data_32
//				= {`ZERO_EXTEND(32, 1, !__in_a_sliced_32[1]),
//				`ZERO_EXTEND(32, 1, !__in_a_sliced_32[0])};
//		end
//
//		PkgSnow64ArithLog::OpAddAgain:
//		begin
//			__real_out_data_32 = __add_32_result;
//		end
//
//		default:
//		begin
//			__real_out_data_32 = 0;
//		end
//		endcase
//	end
//
//	always @(*)
//	begin
//		case (in.oper)
//		PkgSnow64ArithLog::OpAdd:
//		begin
//			__real_out_data_64 = __add_64_result;
//		end
//
//		PkgSnow64ArithLog::OpSub:
//		begin
//			__real_out_data_64 = __sub_64_result;
//		end
//
//		PkgSnow64ArithLog::OpSlt:
//		begin
//			case (in.type_signedness)
//			1'b0:
//			begin
//			  __real_out_data_64 = `ZERO_EXTEND(64, 1, __sub_64_sltu);
//			end
//
//			1'b1:
//			begin
//				__real_out_data_64 = `ZERO_EXTEND(64, 1, __sub_64_slts);
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpAnd:
//		begin
//			__real_out_data_64 = in.a & in.b;
//		end
//
//		PkgSnow64ArithLog::OpOrr:
//		begin
//			__real_out_data_64 = in.a | in.b;
//		end
//
//		PkgSnow64ArithLog::OpXor:
//		begin
//			__real_out_data_64 = in.a ^ in.b;
//		end
//
//		PkgSnow64ArithLog::OpShl:
//		begin
//			__real_out_data_64 = __out_inst_lsl64_0__data;
//		end
//
//		PkgSnow64ArithLog::OpShr:
//		begin
//			case (in.type_signedness)
//			1'b0:
//			begin
//				__real_out_data_64 = __out_inst_lsr64_0__data;
//			end
//
//			1'b1:
//			begin
//				__real_out_data_64 = __out_inst_asr64_0__data;
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpInv:
//		begin
//			__real_out_data_64 = ~in.a;
//		end
//
//		PkgSnow64ArithLog::OpNot:
//		begin
//			__real_out_data_64 = `ZERO_EXTEND(64, 1, !__in_a_sliced_64[0]);
//		end
//
//		PkgSnow64ArithLog::OpAddAgain:
//		begin
//			__real_out_data_64 = __add_64_result;
//		end
//
//		default:
//		begin
//			__real_out_data_64 = 0;
//		end
//		endcase
//	end
//
//	always @(*)
//	begin
//		case (in.int_type_size)
//		PkgSnow64Cpu::IntTypSz8:
//		begin
//			out.data = __real_out_data_8;
//		end
//
//		PkgSnow64Cpu::IntTypSz16:
//		begin
//			out.data = __real_out_data_16;
//		end
//
//		PkgSnow64Cpu::IntTypSz32:
//		begin
//			out.data = __real_out_data_32;
//		end
//
//		PkgSnow64Cpu::IntTypSz64:
//		begin
//			out.data = __real_out_data_64;
//		end
//		endcase
//	end
//
//endmodule

module Snow64Alu(input PkgSnow64ArithLog::PortIn_Alu in,
	output PkgSnow64ArithLog::PortOut_Alu out);

	localparam __ADD_8_MASK = `WIDTH__SNOW64_SIZE_64'h7f7f_7f7f_7f7f_7f7f;
	localparam __ADD_16_MASK = `WIDTH__SNOW64_SIZE_64'h7fff_7fff_7fff_7fff;
	localparam __ADD_32_MASK = `WIDTH__SNOW64_SIZE_64'h7fff_ffff_7fff_ffff;
	localparam __ADD_64_MASK = `WIDTH__SNOW64_SIZE_64'h7fff_ffff_ffff_ffff;

	localparam __SUB_8_BIT_SETTER_THING = ~__ADD_8_MASK;
	localparam __SUB_16_BIT_SETTER_THING = ~__ADD_16_MASK;
	localparam __SUB_32_BIT_SETTER_THING = ~__ADD_32_MASK;
	localparam __SUB_64_BIT_SETTER_THING = ~__ADD_64_MASK;

	localparam __MSB_POS__SLICE_64_TO_8 = `MSB_POS__SLICE_64_TO_8;
	localparam __MSB_POS__SLICE_64_TO_16 = `MSB_POS__SLICE_64_TO_16;
	localparam __MSB_POS__SLICE_64_TO_32 = `MSB_POS__SLICE_64_TO_32;
	localparam __MSB_POS__SLICE_64_TO_64 = `MSB_POS__SLICE_64_TO_64;

	localparam __WIDTH__SIZE_8 = `WIDTH__SNOW64_SIZE_8;
	localparam __MSB_POS__SIZE_8 = `WIDTH2MP(__WIDTH__SIZE_8);
	localparam __WIDTH__SIZE_16 = `WIDTH__SNOW64_SIZE_16;
	localparam __MSB_POS__SIZE_16 = `WIDTH2MP(__WIDTH__SIZE_16);
	localparam __WIDTH__SIZE_32 = `WIDTH__SNOW64_SIZE_32;
	localparam __MSB_POS__SIZE_32 = `WIDTH2MP(__WIDTH__SIZE_32);
	localparam __WIDTH__SIZE_64 = `WIDTH__SNOW64_SIZE_64;
	localparam __MSB_POS__SIZE_64 = `WIDTH2MP(__WIDTH__SIZE_64);




	wire [__MSB_POS__SIZE_64:0]
		__to_add_8_a, __to_add_8_b, __to_add_16_a, __to_add_16_b,
		__to_add_32_a, __to_add_32_b, __to_add_64_a, __to_add_64_b,
		__to_sub_8_a, __to_sub_8_b, __to_sub_16_a, __to_sub_16_b,
		__to_sub_32_a, __to_sub_32_b, __to_sub_64_a, __to_sub_64_b;

	assign __to_add_8_a = (in.a & __ADD_8_MASK);
	assign __to_add_8_b = (in.b & __ADD_8_MASK);
	assign __to_add_16_a = (in.a & __ADD_16_MASK);
	assign __to_add_16_b = (in.b & __ADD_16_MASK);
	assign __to_add_32_a = (in.a & __ADD_32_MASK);
	assign __to_add_32_b = (in.b & __ADD_32_MASK);
	assign __to_add_64_a = (in.a & __ADD_64_MASK);
	assign __to_add_64_b = (in.b & __ADD_64_MASK);

	assign __to_sub_8_a
		= ((in.a & __ADD_8_MASK) | __SUB_8_BIT_SETTER_THING);
	assign __to_sub_8_b
		= (((~in.b) & __ADD_8_MASK) | __SUB_8_BIT_SETTER_THING);
	assign __to_sub_16_a
		= ((in.a & __ADD_16_MASK) | __SUB_16_BIT_SETTER_THING);
	assign __to_sub_16_b
		= (((~in.b) & __ADD_16_MASK) | __SUB_16_BIT_SETTER_THING);
	assign __to_sub_32_a
		= ((in.a & __ADD_32_MASK) | __SUB_32_BIT_SETTER_THING);
	assign __to_sub_32_b
		= (((~in.b) & __ADD_32_MASK) | __SUB_32_BIT_SETTER_THING);
	assign __to_sub_64_a
		= ((in.a & __ADD_64_MASK) | __SUB_64_BIT_SETTER_THING);
	assign __to_sub_64_b
		= (((~in.b) & __ADD_64_MASK) | __SUB_64_BIT_SETTER_THING);


	logic [__MSB_POS__SIZE_64:0]
		__to_add_a, __to_add_b, __to_sub_a, __to_sub_b,
		__addsub_msbs_mask;

	wire [__MSB_POS__SIZE_64:0] __add_result
		= (__to_add_a + __to_add_b) ^ ((in.a ^ in.b) & __addsub_msbs_mask);

	wire [__MSB_POS__SIZE_64:0] __sub_t0 = __to_sub_a + __to_sub_b + 1'b1;

	wire [__MSB_POS__SIZE_64:0] __sub_result
		= __sub_t0 ^ ((in.a ^ (~in.b)) & __addsub_msbs_mask);


	wire [__MSB_POS__SIZE_64:0] __raw_sltu_result
		= ((~(((in.a ^ (~in.b)) & __sub_t0) | (in.a & (~in.b))))
		& __addsub_msbs_mask);
	wire [__MSB_POS__SIZE_64:0] __raw_slts_result
		= ((~((((~in.a) ^ in.b) & __sub_t0) | ((~in.a) & in.b)))
		& __addsub_msbs_mask);


	wire [__MSB_POS__SIZE_64:0]
		__out_inst_lsl64__data, __out_inst_lsr64__data,
		__out_inst_asr64__data;
	LogicalShiftLeft64 __inst_lsl64(.in_to_shift(in.a), .in_amount(in.b),
		.out_data(__out_inst_lsl64__data));
	LogicalShiftRight64 __inst_lsr64(.in_to_shift(in.a), .in_amount(in.b),
		.out_data(__out_inst_lsr64__data));
	ArithmeticShiftRight64 __inst_asr64(.in_to_shift(in.a),
		.in_amount(in.b), .out_data(__out_inst_asr64__data));

	always @(*)
	begin
		case (in.int_type_size)
		PkgSnow64Cpu::IntTypSz8:
		begin
			{__to_add_a, __to_add_b, __to_sub_a, __to_sub_b,
				__addsub_msbs_mask}
				= {__to_add_8_a, __to_add_8_b,
				__to_sub_8_a, __to_sub_8_b,
				__SUB_8_BIT_SETTER_THING};
		end

		PkgSnow64Cpu::IntTypSz16:
		begin
			{__to_add_a, __to_add_b, __to_sub_a, __to_sub_b,
				__addsub_msbs_mask}
				= {__to_add_16_a, __to_add_16_b,
				__to_sub_16_a, __to_sub_16_b,
				__SUB_16_BIT_SETTER_THING};
		end

		PkgSnow64Cpu::IntTypSz32:
		begin
			{__to_add_a, __to_add_b, __to_sub_a, __to_sub_b,
				__addsub_msbs_mask}
				= {__to_add_32_a, __to_add_32_b,
				__to_sub_32_a, __to_sub_32_b,
				__SUB_32_BIT_SETTER_THING};
		end

		PkgSnow64Cpu::IntTypSz64:
		begin
			{__to_add_a, __to_add_b, __to_sub_a, __to_sub_b,
				__addsub_msbs_mask}
				= {__to_add_64_a, __to_add_64_b,
				__to_sub_64_a, __to_sub_64_b,
				__SUB_64_BIT_SETTER_THING};
		end
		endcase
	end

	always @(*)
	begin
		case (in.oper)
		PkgSnow64ArithLog::OpAdd:
		begin
			out.data = __add_result;
		end

		PkgSnow64ArithLog::OpSub:
		begin
			out.data = __sub_result;
		end

		PkgSnow64ArithLog::OpSlt:
		begin
			case (in.int_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				case (in.type_signedness)
				1'b0:
				begin
					out.data = __raw_sltu_result[63:7];
				end

				1'b1:
				begin
					out.data = __raw_slts_result[63:7];
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				case (in.type_signedness)
				1'b0:
				begin
					out.data = __raw_sltu_result[63:15];
				end

				1'b1:
				begin
					out.data = __raw_slts_result[63:15];
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				case (in.type_signedness)
				1'b0:
				begin
					out.data = __raw_sltu_result[63:31];
				end

				1'b1:
				begin
					out.data = __raw_slts_result[63:31];
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (in.type_signedness)
				1'b0:
				begin
					out.data = __raw_sltu_result[63:63];
				end

				1'b1:
				begin
					out.data = __raw_slts_result[63:63];
				end
				endcase
			end
			endcase
		end

		PkgSnow64ArithLog::OpAnd:
		begin
			out.data = in.a & in.b;
		end

		PkgSnow64ArithLog::OpOrr:
		begin
			out.data = in.a | in.b;
		end

		PkgSnow64ArithLog::OpXor:
		begin
			out.data = in.a ^ in.b;
		end

		PkgSnow64ArithLog::OpShl:
		begin
			//out.data = in.a << in.b;
			out.data = __out_inst_lsl64__data;
		end

		PkgSnow64ArithLog::OpShr:
		begin
			//out.data = in.a >> in.b;
			case (in.type_signedness)
			1'b0:
			begin
				out.data = __out_inst_lsr64__data;
			end

			1'b1:
			begin
				out.data = __out_inst_asr64__data;
			end
			endcase
		end

		PkgSnow64ArithLog::OpInv:
		begin
			out.data = ~in.a;
		end

		PkgSnow64ArithLog::OpNot:
		begin
			out.data = !in.a;
		end

		PkgSnow64ArithLog::OpAddAgain:
		begin
			out.data = __add_result;
		end

		default:
		begin
			out.data = 0;
		end
		endcase
	end

endmodule

//module Snow64Alu(input PkgSnow64ArithLog::PortIn_Alu in,
//	output PkgSnow64ArithLog::PortOut_Alu out);
//
//	wire [`MSB_POS__SNOW64_SIZE_64:0]
//		__out_sub_w_cmp__sub_result, __out_sub_w_cmp__sltu,
//		__out_sub_w_cmp__slts;
//
//	SubtractWithCompare #(.WIDTH__DATA_INOUT(`WIDTH__SNOW64_SIZE_64))
//		__inst_sub_w_cmp(.in_a(in.a), .in_b(in.b),
//		.out_sub_result(__out_sub_w_cmp__sub_result),
//		.out_sltu(__out_sub_w_cmp__sltu),
//		.out_slts(__out_sub_w_cmp__slts));
//
//	wire [`MSB_POS__SNOW64_SIZE_64:0]
//		__out_lsl64__data, __out_lsr64__data, __out_asr64__data;
//	LogicalShiftLeft64 __inst_lsl64(.in_to_shift(in.a), .in_amount(in.b),
//		.out_data(__out_lsl64__data));
//	LogicalShiftRight64 __inst_lsr64(.in_to_shift(in.a), .in_amount(in.b),
//		.out_data(__out_lsr64__data));
//	ArithmeticShiftRight64 __inst_asr64(.in_to_shift(in.a),
//		.in_amount(in.b), .out_data(__out_asr64__data));
//
//	always @(*)
//	begin
//		case (in.oper)
//		PkgSnow64ArithLog::OpAdd:
//		begin
//			out.data = in.a + in.b;
//		end
//
//		PkgSnow64ArithLog::OpSub:
//		begin
//			out.data = __out_sub_w_cmp__sub_result;
//		end
//
//		PkgSnow64ArithLog::OpSlt:
//		begin
//			case (in.type_signedness)
//			1'b0:
//			begin
//				out.data = __out_sub_w_cmp__sltu;
//			end
//
//			1'b1:
//			begin
//				out.data = __out_sub_w_cmp__slts;
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpAnd:
//		begin
//			out.data = in.a & in.b;
//		end
//
//		PkgSnow64ArithLog::OpOrr:
//		begin
//			out.data = in.a | in.b;
//		end
//
//		PkgSnow64ArithLog::OpXor:
//		begin
//			out.data = in.a ^ in.b;
//		end
//
//		PkgSnow64ArithLog::OpShl:
//		begin
//			out.data = __out_lsl64__data;
//		end
//
//		PkgSnow64ArithLog::OpShr:
//		begin
//			case (in.type_signedness)
//			1'b0:
//			begin
//				out.data = __out_lsr64__data;
//			end
//
//			1'b1:
//			begin
//				out.data = __out_asr64__data;
//			end
//			endcase
//		end
//
//		PkgSnow64ArithLog::OpInv:
//		begin
//			out.data = ~in.a;
//		end
//
//		PkgSnow64ArithLog::OpNot:
//		begin
//			out.data = !in.a;
//		end
//
//		default:
//		begin
//			out.data = 0;
//		end
//		endcase
//	end
//endmodule

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
