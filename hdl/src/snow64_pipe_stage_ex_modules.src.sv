`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"
`include "src/snow64_pipe_stage_structs.header.sv"


// This file is the epitome of why Icarus Verilog should **definitely**
// support EASY ability to put a packed struct inside another packed
// struct.  At the time of this writing, Icarus Verilog's support for
// *synthesizable* SystemVerilog is soooo incomplete.  It just causes all
// kinds of problems.  You're almost better off not using SystemVerilog
// with Icarus Verilog (though that may have changed by the time you're
// reading this)....

`define WIDTH__SNOW64_PIPE_STAGE_EX_STATE 3
`define MSB_POS__SNOW64_PIPE_STAGE_EX_STATE \
	`WIDTH2MP(`WIDTH__SNOW64_PIPE_STAGE_EX_STATE)

`define WIDTH__SNOW64_PIPE_STAGE_EX_NEEDED_CAST_TYPE 2
`define MSB_POS__SNOW64_PIPE_STAGE_EX_NEEDED_CAST_TYPE \
	`WIDTH2MP(`WIDTH__SNOW64_PIPE_STAGE_EX_NEEDED_CAST_TYPE)

`define WIDTH__SNOW64_PIPE_STAGE_EX_MULTI_CYCLE_OP_TYPE 2
`define MSB_POS__SNOW64_PIPE_STAGE_EX_MULTI_CYCLE_OP_TYPE \
	`WIDTH2MP(`WIDTH__SNOW64_PIPE_STAGE_EX_MULTI_CYCLE_OP_TYPE)

package PkgSnow64PsEx;

typedef enum logic [`MSB_POS__SNOW64_PIPE_STAGE_EX_STATE:0]
{
	StRegular,

	StWaitForScalarCaster,
	StWaitForVectorCaster,
	StInjectCastedScalars,

	StUseCastedDataSingleCycle,
	StUseCastedDataMultiCycle,
	//StUseUncastedDataMultiCycle,
	StWaitForMultiCycleOp,
	StBad
} State;

typedef enum logic [`MSB_POS__SNOW64_PIPE_STAGE_EX_MULTI_CYCLE_OP_TYPE:0]
{
	MultiCycOpTypNone,
	MultiCycOpTypMul,
	MultiCycOpTypDiv,
	MultiCycOpTypFpu
} MultiCycleOpType;

typedef struct packed
{
	logic valid;
	logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0] base_addr;
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] computed_data;
} Results;


typedef struct packed
{
	logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET:0] data_offset;
	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] data_type;
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;

	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] data;
	logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0] base_addr;
} TrueLarData;

typedef enum logic [`MSB_POS__SNOW64_PIPE_STAGE_EX_NEEDED_CAST_TYPE:0]
{
	NeededCastTypNone,
	NeededCastTypIntToInt,
	NeededCastTypIntToBFloat16,
	NeededCastTypBFloat16ToInt
} NeededCastType;

typedef enum logic
{
	CastStNoWait,
	CastStWaitForBFloat16Caster
} CastState;


endpackage : PkgSnow64PsEx

module Snow64PsExOperandForwarder(input logic clk,
	input PortIn_Snow64PipeStageEx_FromCtrlUnit in_from_ctrl_unit,
	input PkgSnow64PsEx::Results in_curr_results,
	output PkgSnow64PsEx::TrueLarData
		out_true_ra_data, out_true_rb_data, out_true_rc_data);


	localparam __WIDTH__OPERAND_FORWARDING_CHECK = 3;
	localparam __MSB_POS__OPERAND_FORWARDING_CHECK
		= `WIDTH2MP(__WIDTH__OPERAND_FORWARDING_CHECK);


	Snow64Pipeline_LarFileReadMetadata
		__from_lar_file__rd_metadata_a, __from_lar_file__rd_metadata_b,
		__from_lar_file__rd_metadata_c;
	Snow64Pipeline_LarFileReadShareddata
		__from_lar_file__rd_shareddata_a, __from_lar_file__rd_shareddata_b,
		__from_lar_file__rd_shareddata_c;
	assign {__from_lar_file__rd_metadata_a,
		__from_lar_file__rd_metadata_b,
		__from_lar_file__rd_metadata_c,
		__from_lar_file__rd_shareddata_a,
		__from_lar_file__rd_shareddata_b,
		__from_lar_file__rd_shareddata_c}
		= in_from_ctrl_unit;

	//always @(posedge clk)
	//begin
	//	$display("Snow64PsExOperandForwarder:  %h",
	//		__from_lar_file__rd_shareddata_a.data);
	//end

	wire [__MSB_POS__OPERAND_FORWARDING_CHECK:0]
		__operand_forwarding_check__ra, __operand_forwarding_check__rb,
		__operand_forwarding_check__rc;

	`define PARTIAL_OP_FORWARDING_CHECK(reg_letter, past_results_num) \
		(__past_results_``past_results_num``.valid \
		&& (__past_results_``past_results_num``.base_addr \
		== __from_lar_file__rd_shareddata_``reg_letter``.base_addr))

	`define ASSIGN_OPERAND_FORWARDING_CHECK(reg_letter) \
	assign __operand_forwarding_check__r``reg_letter \
		= {`PARTIAL_OP_FORWARDING_CHECK(reg_letter, 0), \
		`PARTIAL_OP_FORWARDING_CHECK(reg_letter, 1), \
		`PARTIAL_OP_FORWARDING_CHECK(reg_letter, 2)};

	`ASSIGN_OPERAND_FORWARDING_CHECK(a)
	`ASSIGN_OPERAND_FORWARDING_CHECK(b)
	`ASSIGN_OPERAND_FORWARDING_CHECK(c)

	`undef ASSIGN_OPERAND_FORWARDING_CHECK
	`undef PARTIAL_OP_FORWARDING_CHECK


	PkgSnow64PsEx::Results
		__past_results_0 = 0, __past_results_1 = 0, __past_results_2 = 0;


	// These two defines exist so that the PERF_OPERAND_FORWARDING `define
	// can look "cleaner", or something to that effect.
	`define FORWARD_FROM_PAST_RESULTS(reg_letter, past_results_num) \
		{out_true_r``reg_letter``_data.data, \
			out_true_r``reg_letter``_data.base_addr} \
			= {__past_results_``past_results_num``.computed_data, \
			__past_results_``past_results_num``.base_addr};
	`define FORWARD_FROM_LAR_FILE(reg_letter) \
		{out_true_r``reg_letter``_data.data, \
			out_true_r``reg_letter``_data.base_addr} \
			= {__from_lar_file__rd_shareddata_``reg_letter.data, \
			__from_lar_file__rd_shareddata_``reg_letter.base_addr};

	`define PERF_OPERAND_FORWARDING(reg_letter) \
	always @(*) \
	begin \
		case (__operand_forwarding_check__r``reg_letter) \
		3'b111: `FORWARD_FROM_PAST_RESULTS(reg_letter, 0) \
		3'b110: `FORWARD_FROM_PAST_RESULTS(reg_letter, 0) \
		3'b101: `FORWARD_FROM_PAST_RESULTS(reg_letter, 0) \
		3'b100: `FORWARD_FROM_PAST_RESULTS(reg_letter, 0) \
		3'b011: `FORWARD_FROM_PAST_RESULTS(reg_letter, 1) \
		3'b010: `FORWARD_FROM_PAST_RESULTS(reg_letter, 1) \
		3'b001: `FORWARD_FROM_PAST_RESULTS(reg_letter, 2) \
		3'b000: `FORWARD_FROM_LAR_FILE(reg_letter) \
		endcase \
	end

	`PERF_OPERAND_FORWARDING(a)
	`PERF_OPERAND_FORWARDING(b)
	`PERF_OPERAND_FORWARDING(c)
	`undef PERF_OPERAND_FORWARDING
	`undef FORWARD_FROM_PAST_RESULTS
	`undef FORWARD_FROM_LAR_FILE

	`define ASSIGN_NON_FORWARDED_TRUE_REG_DATA(which_reg) \
		always @(*) out_true_r``which_reg``_data.data_offset \
			= __from_lar_file__rd_metadata_``which_reg.data_offset; \
		always @(*) out_true_r``which_reg``_data.data_type \
			= __from_lar_file__rd_metadata_``which_reg.data_type; \
		always @(*) out_true_r``which_reg``_data.int_type_size \
			= __from_lar_file__rd_metadata_``which_reg.int_type_size;

	`ASSIGN_NON_FORWARDED_TRUE_REG_DATA(a)
	`ASSIGN_NON_FORWARDED_TRUE_REG_DATA(b)
	`ASSIGN_NON_FORWARDED_TRUE_REG_DATA(c)
	`undef ASSIGN_NON_FORWARDED_TRUE_REG_DATA

	initial
	begin
		{out_true_ra_data, out_true_rb_data, out_true_rc_data} = 0;
	end


	always @(posedge clk)
	begin
		//$display("Snow64PsExOperandForwarder stuff:  %h, %h, %h",
		//	__past_results_0.valid,
		//	__past_results_1.valid,
		//	__past_results_2.valid);
		__past_results_0 <= in_curr_results;
		__past_results_1 <= __past_results_0;
		__past_results_2 <= __past_results_1;
	end

endmodule

module Snow64PsExRotateLarData
	(input PkgSnow64PsEx::TrueLarData in_true_ra_data,
	input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		in_dsrc0_data, in_dsrc1_data,
	input logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET:0]
		in_dsrc0_data_offset, in_dsrc1_data_offset, in_ddest_data_offset,
	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		out_rotated_dsrc0_data, out_rotated_dsrc1_data,
		out_mask, out_inv_mask);



	localparam __MSB_POS__DATA = `MSB_POS__SNOW64_LAR_FILE_DATA;

	localparam __MSB_POS__DATA_OFFSET
		= `MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET;

	localparam __LSB_POS__DATA_OFFSET_8 = 0;
	localparam __LSB_POS__DATA_OFFSET_16 = 1;
	localparam __LSB_POS__DATA_OFFSET_32 = 2;
	localparam __LSB_POS__DATA_OFFSET_64 = 3;


	// We don't care about PkgSnow64Cpu::DataTypReserved, so we'll pretend
	// it doesn't exist.
	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] __ddest_type_size
		= (in_true_ra_data.data_type == PkgSnow64Cpu::DataTypBFloat16)
		? PkgSnow64Cpu::IntTypSz16 : in_true_ra_data.int_type_size;


	wire [__MSB_POS__DATA:0]
		__out_inst_dsrc0_rotate_lar_data__data_8,
		__out_inst_dsrc0_rotate_lar_data__data_16,
		__out_inst_dsrc0_rotate_lar_data__data_32,
		__out_inst_dsrc0_rotate_lar_data__data_64,
		__out_inst_dsrc1_rotate_lar_data__data_8,
		__out_inst_dsrc1_rotate_lar_data__data_16,
		__out_inst_dsrc1_rotate_lar_data__data_32,
		__out_inst_dsrc1_rotate_lar_data__data_64;

	Snow64RotateLarData __inst_dsrc0_rotate_lar_data
		(.in_to_rotate(in_dsrc0_data),
		.in_src_data_offset(in_dsrc0_data_offset),
		.in_dest_data_offset(in_ddest_data_offset),
		.out_data_8(__out_inst_dsrc0_rotate_lar_data__data_8),
		.out_data_16(__out_inst_dsrc0_rotate_lar_data__data_16),
		.out_data_32(__out_inst_dsrc0_rotate_lar_data__data_32),
		.out_data_64(__out_inst_dsrc0_rotate_lar_data__data_64));
	Snow64RotateLarData __inst_dsrc1_rotate_lar_data
		(.in_to_rotate(in_dsrc1_data),
		.in_src_data_offset(in_dsrc1_data_offset),
		.in_dest_data_offset(in_ddest_data_offset),
		.out_data_8(__out_inst_dsrc1_rotate_lar_data__data_8),
		.out_data_16(__out_inst_dsrc1_rotate_lar_data__data_16),
		.out_data_32(__out_inst_dsrc1_rotate_lar_data__data_32),
		.out_data_64(__out_inst_dsrc1_rotate_lar_data__data_64));

	logic [__MSB_POS__DATA:0]
		__mask_8, __mask_16, __mask_32, __mask_64,
		__inv_mask_8, __inv_mask_16, __inv_mask_32, __inv_mask_64;


	always @(*)
	begin
		case (__ddest_type_size)
		PkgSnow64Cpu::IntTypSz8:
		begin
			{out_rotated_dsrc0_data, out_rotated_dsrc1_data,
				out_mask, out_inv_mask}
				= {__out_inst_dsrc0_rotate_lar_data__data_8,
				__out_inst_dsrc1_rotate_lar_data__data_8,
				__mask_8, __inv_mask_8};
		end

		PkgSnow64Cpu::IntTypSz16:
		begin
			{out_rotated_dsrc0_data, out_rotated_dsrc1_data,
				out_mask, out_inv_mask}
				= {__out_inst_dsrc0_rotate_lar_data__data_16,
				__out_inst_dsrc1_rotate_lar_data__data_16,
				__mask_16, __inv_mask_16};
		end

		PkgSnow64Cpu::IntTypSz32:
		begin
			{out_rotated_dsrc0_data, out_rotated_dsrc1_data,
				out_mask, out_inv_mask}
				= {__out_inst_dsrc0_rotate_lar_data__data_32,
				__out_inst_dsrc1_rotate_lar_data__data_32,
				__mask_32, __inv_mask_32};
		end

		PkgSnow64Cpu::IntTypSz64:
		begin
			{out_rotated_dsrc0_data, out_rotated_dsrc1_data,
				out_mask, out_inv_mask}
				= {__out_inst_dsrc0_rotate_lar_data__data_64,
				__out_inst_dsrc1_rotate_lar_data__data_64,
				__mask_64, __inv_mask_64};
		end
		endcase
	end


	`define MASK_8(x) (256'hff << (x * 8))
	`define MASK_16(x) (256'hffff << (x * 16))
	`define MASK_32(x) (256'hffff_ffff << (x * 32))
	`define MASK_64(x) (256'hffff_ffff_ffff_ffff << (x * 64))

	`define PERF_MASK(width, num) \
		num: {__mask_``width, __inv_mask_``width} \
			= {`MASK_``width(num), ~`MASK_``width(num)}

	always @(*)
	begin
		case (in_ddest_data_offset
			[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_8])
		`PERF_MASK(8, 0); `PERF_MASK(8, 1);
		`PERF_MASK(8, 2); `PERF_MASK(8, 3);
		`PERF_MASK(8, 4); `PERF_MASK(8, 5);
		`PERF_MASK(8, 6); `PERF_MASK(8, 7);
		`PERF_MASK(8, 8); `PERF_MASK(8, 9);
		`PERF_MASK(8, 10); `PERF_MASK(8, 11);
		`PERF_MASK(8, 12); `PERF_MASK(8, 13);
		`PERF_MASK(8, 14); `PERF_MASK(8, 15);
		`PERF_MASK(8, 16); `PERF_MASK(8, 17);
		`PERF_MASK(8, 18); `PERF_MASK(8, 19);
		`PERF_MASK(8, 20); `PERF_MASK(8, 21);
		`PERF_MASK(8, 22); `PERF_MASK(8, 23);
		`PERF_MASK(8, 24); `PERF_MASK(8, 25);
		`PERF_MASK(8, 26); `PERF_MASK(8, 27);
		`PERF_MASK(8, 28); `PERF_MASK(8, 29);
		`PERF_MASK(8, 30); `PERF_MASK(8, 31);
		endcase
	end

	always @(*)
	begin
		case (in_ddest_data_offset
			[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_16])
		`PERF_MASK(16, 0); `PERF_MASK(16, 1);
		`PERF_MASK(16, 2); `PERF_MASK(16, 3);
		`PERF_MASK(16, 4); `PERF_MASK(16, 5);
		`PERF_MASK(16, 6); `PERF_MASK(16, 7);
		`PERF_MASK(16, 8); `PERF_MASK(16, 9);
		`PERF_MASK(16, 10); `PERF_MASK(16, 11);
		`PERF_MASK(16, 12); `PERF_MASK(16, 13);
		`PERF_MASK(16, 14); `PERF_MASK(16, 15);
		endcase
	end

	always @(*)
	begin
		case (in_ddest_data_offset
			[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_32])
		`PERF_MASK(32, 0); `PERF_MASK(32, 1);
		`PERF_MASK(32, 2); `PERF_MASK(32, 3);
		`PERF_MASK(32, 4); `PERF_MASK(32, 5);
		`PERF_MASK(32, 6); `PERF_MASK(32, 7);
		endcase
	end

	always @(*)
	begin
		case (in_ddest_data_offset
			[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_64])
		`PERF_MASK(64, 0); `PERF_MASK(64, 1);
		`PERF_MASK(64, 2); `PERF_MASK(64, 3);
		endcase
	end

	`undef MASK_8
	`undef MASK_16
	`undef MASK_32
	`undef MASK_64

endmodule


module Snow64PsExCastScalars(input logic clk,
	input logic in_start, in_forced_64_bit_integers,
	input PkgSnow64PsEx::TrueLarData
		in_true_ra_data, in_true_rb_data, in_true_rc_data,
	input logic [`MSB_POS__SNOW64_PIPE_STAGE_EX_NEEDED_CAST_TYPE:0]
		in_dsrc0_needed_cast_type, in_dsrc1_needed_cast_type,
	input logic [`MSB_POS__SNOW64_SCALAR_DATA:0]
		in_uncasted_rb_scalar_data, in_uncasted_rc_scalar_data,
	output logic [`MSB_POS__SNOW64_SCALAR_DATA:0]
		out_casted_rb_scalar_data, out_casted_rc_scalar_data,
	output logic out_valid);

	logic __state;


	wire [`MSB_POS__SNOW64_SCALAR_DATA:0]
		__dsrc0__uncasted_scalar_data = in_uncasted_rb_scalar_data,
		__dsrc1__uncasted_scalar_data = in_uncasted_rc_scalar_data;
	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__ddest__int_type_size = in_forced_64_bit_integers
			? PkgSnow64Cpu::IntTypSz64
			: in_true_ra_data.int_type_size,
		__dsrc0__int_type_size = in_true_rb_data.int_type_size,
		__dsrc1__int_type_size = in_true_rc_data.int_type_size;

	wire [`MSB_POS__SNOW64_CPU_DATA_TYPE:0]
		__ddest__data_type = in_true_ra_data.data_type,
		__dsrc0__data_type = in_true_rb_data.data_type,
		__dsrc1__data_type = in_true_rc_data.data_type;

	//wire __ddest__is_signed_int
	//	= (__ddest__data_type == PkgSnow64Cpu::DataTypSgnInt);
	wire __dsrc0__is_signed_int
		= (__dsrc0__data_type == PkgSnow64Cpu::DataTypSgnInt);
	wire __dsrc1__is_signed_int
		= (__dsrc1__data_type == PkgSnow64Cpu::DataTypSgnInt);



	wire __dsrc0_start_bfloat16_cast_from_int,
		__dsrc1_start_bfloat16_cast_from_int,
		__dsrc0_start_bfloat16_cast_to_int,
		__dsrc1_start_bfloat16_cast_to_int;

	wire __starting_any_cast = (in_start
		&& (__state == PkgSnow64PsEx::CastStNoWait));

	assign __dsrc0_start_bfloat16_cast_from_int
		= (__starting_any_cast && (in_dsrc0_needed_cast_type
		== PkgSnow64PsEx::NeededCastTypIntToBFloat16));
	assign __dsrc1_start_bfloat16_cast_from_int
		= (__starting_any_cast && (in_dsrc1_needed_cast_type
		== PkgSnow64PsEx::NeededCastTypIntToBFloat16));
	assign __dsrc0_start_bfloat16_cast_to_int
		= (__starting_any_cast && (in_dsrc0_needed_cast_type
		== PkgSnow64PsEx::NeededCastTypBFloat16ToInt));
	assign __dsrc1_start_bfloat16_cast_to_int
		= (__starting_any_cast && (in_dsrc1_needed_cast_type
		== PkgSnow64PsEx::NeededCastTypBFloat16ToInt));
	wire __starting_bfloat16_cast
		= (__dsrc0_start_bfloat16_cast_from_int
		|| __dsrc1_start_bfloat16_cast_from_int
		|| __dsrc0_start_bfloat16_cast_to_int
		|| __dsrc1_start_bfloat16_cast_to_int);


	PkgSnow64Caster::PortIn_IntScalarCaster
		__in_inst_dsrc0_int_scalar_caster,
		__in_inst_dsrc1_int_scalar_caster;
	PkgSnow64Caster::PortOut_IntScalarCaster
		__out_inst_dsrc0_int_scalar_caster,
		__out_inst_dsrc1_int_scalar_caster;
	Snow64IntScalarCaster __inst_dsrc0_int_scalar_caster(.clk(clk),
		.in(__in_inst_dsrc0_int_scalar_caster),
		.out(__out_inst_dsrc0_int_scalar_caster));
	Snow64IntScalarCaster __inst_dsrc1_int_scalar_caster(.clk(clk),
		.in(__in_inst_dsrc1_int_scalar_caster),
		.out(__out_inst_dsrc1_int_scalar_caster));

	// typedef struct packed
	// {
	// 	ScalarData to_cast;

	// 	logic src_type_signedness;
	// 	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
	// 		src_int_type_size, dst_int_type_size;
	// } PortIn_IntScalarCaster;
	assign __in_inst_dsrc0_int_scalar_caster
		= {__dsrc0__uncasted_scalar_data,
		__dsrc0__is_signed_int,
		__dsrc0__int_type_size,
		__ddest__int_type_size};
	assign __in_inst_dsrc1_int_scalar_caster
		= {__dsrc1__uncasted_scalar_data,
		__dsrc1__is_signed_int,
		__dsrc1__int_type_size,
		__ddest__int_type_size};

	PkgSnow64BFloat16::PortIn_CastFromInt
		__in_inst_dsrc0_bfloat16_cast_from_int,
		__in_inst_dsrc1_bfloat16_cast_from_int;
	PkgSnow64BFloat16::PortOut_CastFromInt
		__out_inst_dsrc0_bfloat16_cast_from_int,
		__out_inst_dsrc1_bfloat16_cast_from_int;
	Snow64BFloat16CastFromInt __inst_dsrc0_bfloat16_cast_from_int
		(.clk(clk), .in(__in_inst_dsrc0_bfloat16_cast_from_int),
		.out(__out_inst_dsrc0_bfloat16_cast_from_int));
	Snow64BFloat16CastFromInt __inst_dsrc1_bfloat16_cast_from_int
		(.clk(clk), .in(__in_inst_dsrc1_bfloat16_cast_from_int),
		.out(__out_inst_dsrc1_bfloat16_cast_from_int));


	// // For casting an integer to a BFloat16
	// typedef struct packed
	// {
	// 	logic start;
	// 	logic [`MSB_POS__SNOW64_SIZE_64:0] to_cast;
	// 	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
	// 	logic type_signedness;
	// } PortIn_CastFromInt;
	assign __in_inst_dsrc0_bfloat16_cast_from_int
		= {__dsrc0_start_bfloat16_cast_from_int,
		__dsrc0__uncasted_scalar_data,
		__dsrc0__int_type_size,
		__dsrc0__is_signed_int};
	assign __in_inst_dsrc1_bfloat16_cast_from_int
		= {__dsrc1_start_bfloat16_cast_from_int,
		__dsrc1__uncasted_scalar_data,
		__dsrc1__int_type_size,
		__dsrc1__is_signed_int};



	PkgSnow64BFloat16::PortIn_CastToInt
		__in_inst_dsrc0_bfloat16_cast_to_int,
		__in_inst_dsrc1_bfloat16_cast_to_int;
	PkgSnow64BFloat16::PortOut_CastToInt
		__out_inst_dsrc0_bfloat16_cast_to_int,
		__out_inst_dsrc1_bfloat16_cast_to_int;
	Snow64BFloat16CastToInt __inst_dsrc0_bfloat16_cast_to_int
		(.clk(clk), .in(__in_inst_dsrc0_bfloat16_cast_to_int),
		.out(__out_inst_dsrc0_bfloat16_cast_to_int));
	Snow64BFloat16CastToInt __inst_dsrc1_bfloat16_cast_to_int
		(.clk(clk), .in(__in_inst_dsrc1_bfloat16_cast_to_int),
		.out(__out_inst_dsrc1_bfloat16_cast_to_int));

	// // For casting a BFloat16 to an integer 
	// typedef struct packed
	// {
	// 	logic start;
	// 	logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] to_cast;
	// 	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
	// 	logic type_signedness;
	// } PortIn_CastToInt;
	assign __in_inst_dsrc0_bfloat16_cast_to_int
		= {__dsrc0_start_bfloat16_cast_to_int,
		__dsrc0__uncasted_scalar_data,
		__dsrc0__int_type_size,
		__dsrc0__is_signed_int};
	assign __in_inst_dsrc1_bfloat16_cast_to_int
		= {__dsrc1_start_bfloat16_cast_to_int,
		__dsrc1__uncasted_scalar_data,
		__dsrc1__int_type_size,
		__dsrc1__is_signed_int};




	initial
	begin
		__state = PkgSnow64PsEx::CastStNoWait;


		{out_casted_rb_scalar_data, out_casted_rc_scalar_data} = 0;
		out_valid = 0;
	end



	`define SET_OUT_CASTED_SCALAR_DATA(reg_name, dsrc_num) \
	always @(*) \
	begin \
		case (out_valid) \
		1'b0: \
		begin \
			out_casted_``reg_name``_scalar_data = 0; \
		end \
		\
		1'b1: \
		begin \
			case (in_dsrc``dsrc_num``_needed_cast_type) \
			PkgSnow64PsEx::NeededCastTypNone: \
			begin \
				out_casted_``reg_name``_scalar_data \
					= in_uncasted_``reg_name``_scalar_data; \
			end \
			PkgSnow64PsEx::NeededCastTypIntToInt: \
			begin \
				out_casted_``reg_name``_scalar_data \
					= __out_inst_dsrc``dsrc_num``_int_scalar_caster.data; \
			end \
			\
			PkgSnow64PsEx::NeededCastTypIntToBFloat16: \
			begin \
				out_casted_``reg_name``_scalar_data \
					= __out_inst_dsrc``dsrc_num``_bfloat16_cast_from_int \
					.data; \
			end \
			\
			PkgSnow64PsEx::NeededCastTypBFloat16ToInt: \
			begin \
				out_casted_``reg_name``_scalar_data \
					= __out_inst_dsrc``dsrc_num``_bfloat16_cast_to_int \
					.data; \
			end \
			\
			endcase \
		end \
		endcase \
	end

	`SET_OUT_CASTED_SCALAR_DATA(rb, 0)
	`SET_OUT_CASTED_SCALAR_DATA(rc, 1)
	`undef SET_OUT_CASTED_SCALAR_DATA


	always_ff @(posedge clk)
	begin
		case (__state)
		PkgSnow64PsEx::CastStNoWait:
		begin
			case (__starting_bfloat16_cast)
			1'b0:
			begin
				out_valid <= __starting_any_cast;
			end

			1'b1:
			begin
				__state <= PkgSnow64PsEx::CastStWaitForBFloat16Caster;
				out_valid <= 1'b0;
			end
			endcase
		end

		PkgSnow64PsEx::CastStWaitForBFloat16Caster:
		begin
			if (__out_inst_dsrc0_bfloat16_cast_from_int.valid
				|| __out_inst_dsrc1_bfloat16_cast_from_int.valid
				|| __out_inst_dsrc0_bfloat16_cast_to_int.valid
				|| __out_inst_dsrc1_bfloat16_cast_to_int.valid)
			begin
				__state <= PkgSnow64PsEx::CastStNoWait;
				out_valid <= 1'b1;
			end
		end
		endcase
	end



endmodule


module Snow64PsExCastVectors(input logic clk,
	input logic in_start, in_forced_64_bit_integers,
	input PkgSnow64PsEx::TrueLarData
		in_true_ra_data, in_true_rb_data, in_true_rc_data,
	input logic [`MSB_POS__SNOW64_PIPE_STAGE_EX_NEEDED_CAST_TYPE:0]
		in_dsrc0_needed_cast_type, in_dsrc1_needed_cast_type,
	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		out_casted_rb_vector_data, out_casted_rc_vector_data,
	output logic out_valid);


	logic __state;

	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__dsrc0__data = in_true_rb_data.data,
		__dsrc1__data = in_true_rc_data.data;

	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__ddest__int_type_size = in_forced_64_bit_integers
			? PkgSnow64Cpu::IntTypSz64
			: in_true_ra_data.int_type_size,
		__dsrc0__int_type_size = in_true_rb_data.int_type_size,
		__dsrc1__int_type_size = in_true_rc_data.int_type_size;

	wire [`MSB_POS__SNOW64_CPU_DATA_TYPE:0]
		__ddest__data_type = in_true_ra_data.data_type,
		__dsrc0__data_type = in_true_rb_data.data_type,
		__dsrc1__data_type = in_true_rc_data.data_type;

	wire __ddest__is_signed_int
		= (__ddest__data_type == PkgSnow64Cpu::DataTypSgnInt);
	wire __dsrc0__is_signed_int
		= (__dsrc0__data_type == PkgSnow64Cpu::DataTypSgnInt);
	wire __dsrc1__is_signed_int
		= (__dsrc1__data_type == PkgSnow64Cpu::DataTypSgnInt);

	wire __dsrc0_start_bfloat16_cast_from_int,
		__dsrc1_start_bfloat16_cast_from_int,
		__dsrc0_start_bfloat16_cast_to_int,
		__dsrc1_start_bfloat16_cast_to_int;

	wire __starting_any_cast = (in_start
		&& (__state == PkgSnow64PsEx::CastStNoWait));

	assign __dsrc0_start_bfloat16_cast_from_int
		= (__starting_any_cast && (in_dsrc0_needed_cast_type
		== PkgSnow64PsEx::NeededCastTypIntToBFloat16));
	assign __dsrc1_start_bfloat16_cast_from_int
		= (__starting_any_cast && (in_dsrc1_needed_cast_type
		== PkgSnow64PsEx::NeededCastTypIntToBFloat16));
	assign __dsrc0_start_bfloat16_cast_to_int
		= (__starting_any_cast && (in_dsrc0_needed_cast_type
		== PkgSnow64PsEx::NeededCastTypBFloat16ToInt));
	assign __dsrc1_start_bfloat16_cast_to_int
		= (__starting_any_cast && (in_dsrc1_needed_cast_type
		== PkgSnow64PsEx::NeededCastTypBFloat16ToInt));
	wire __starting_bfloat16_cast
		= (__dsrc0_start_bfloat16_cast_from_int
		|| __dsrc1_start_bfloat16_cast_from_int
		|| __dsrc0_start_bfloat16_cast_to_int
		|| __dsrc1_start_bfloat16_cast_to_int);


	PkgSnow64Caster::PortIn_IntVectorCaster
		__in_inst_dsrc0_int_vector_caster,
		__in_inst_dsrc1_int_vector_caster;
	PkgSnow64Caster::PortOut_IntVectorCaster
		__out_inst_dsrc0_int_vector_caster,
		__out_inst_dsrc1_int_vector_caster;
	Snow64IntVectorCaster __inst_dsrc0_int_vector_caster(.clk(clk),
		.in(__in_inst_dsrc0_int_vector_caster),
		.out(__out_inst_dsrc0_int_vector_caster));
	Snow64IntVectorCaster __inst_dsrc1_int_vector_caster(.clk(clk),
		.in(__in_inst_dsrc1_int_vector_caster),
		.out(__out_inst_dsrc1_int_vector_caster));

	// typedef struct packed
	// {
	// 	LarData to_cast;

	// 	logic src_type_signedness;
	// 	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
	// 		src_int_type_size, dst_int_type_size;
	// } PortIn_IntVectorCaster;
	assign __in_inst_dsrc0_int_vector_caster
		= {__dsrc0__data,
		__dsrc0__is_signed_int,
		__dsrc0__int_type_size,
		__ddest__int_type_size};
	assign __in_inst_dsrc1_int_vector_caster
		= {__dsrc1__data,
		__dsrc1__is_signed_int,
		__dsrc1__int_type_size,
		__ddest__int_type_size};


	PkgSnow64Caster::PortIn_ToOrFromBFloat16VectorCaster
		__in_inst_dsrc0_tof_bfloat16_vector_caster,
		__in_inst_dsrc1_tof_bfloat16_vector_caster;
	PkgSnow64Caster::PortOut_ToOrFromBFloat16VectorCaster
		__out_inst_dsrc0_tof_bfloat16_vector_caster,
		__out_inst_dsrc1_tof_bfloat16_vector_caster;
	Snow64ToOrFromBFloat16VectorCaster
		__inst_dsrc0_tof_bfloat16_vector_caster(.clk(clk),
		.in(__in_inst_dsrc0_tof_bfloat16_vector_caster),
		.out(__out_inst_dsrc0_tof_bfloat16_vector_caster));
	Snow64ToOrFromBFloat16VectorCaster
		__inst_dsrc1_tof_bfloat16_vector_caster(.clk(clk),
		.in(__in_inst_dsrc1_tof_bfloat16_vector_caster),
		.out(__out_inst_dsrc1_tof_bfloat16_vector_caster));

	// typedef struct packed
	// {
	// 	logic start, from_int_or_to_int;

	// 	LarData to_cast;
	// 	logic type_signedness;
	// 	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
	// } PortIn_ToOrFromBFloat16VectorCaster;
	assign __in_inst_dsrc0_tof_bfloat16_vector_caster
		= {(__dsrc0_start_bfloat16_cast_from_int
		|| __dsrc0_start_bfloat16_cast_to_int),
		__dsrc0_start_bfloat16_cast_to_int,
		__dsrc0__data,

		// To int:  dsrc0 is BFloat16, ddest is integer
		(__dsrc0_start_bfloat16_cast_to_int
		? __ddest__is_signed_int : __dsrc0__is_signed_int),
		(__dsrc0_start_bfloat16_cast_to_int
		? __ddest__int_type_size : __dsrc0__int_type_size)};
	assign __in_inst_dsrc1_tof_bfloat16_vector_caster
		= {(__dsrc1_start_bfloat16_cast_from_int
		|| __dsrc1_start_bfloat16_cast_to_int),
		__dsrc1_start_bfloat16_cast_to_int,
		__dsrc1__data,

		// To int:  dsrc1 is BFloat16, ddest is integer
		(__dsrc1_start_bfloat16_cast_to_int
		? __ddest__is_signed_int : __dsrc1__is_signed_int),
		(__dsrc1_start_bfloat16_cast_to_int
		? __ddest__int_type_size : __dsrc1__int_type_size)};

	initial
	begin
		__state = PkgSnow64PsEx::CastStNoWait;

		{out_casted_rb_vector_data, out_casted_rc_vector_data} = 0;
		out_valid = 0;
	end


	`define OUT_INST_TOF_BFLOAT16_VECTOR_CASTER(dsrc_num) \
		__out_inst_dsrc``dsrc_num``_tof_bfloat16_vector_caster \

	`define SET_OUT_CASTED_VECTOR_DATA(reg_name, dsrc_num) \
	always @(*) \
	begin \
		case (out_valid) \
		1'b0: \
		begin \
			out_casted_``reg_name``_vector_data = 0; \
		end \
		\
		1'b1: \
		begin \
			case (in_dsrc``dsrc_num``_needed_cast_type) \
			PkgSnow64PsEx::NeededCastTypNone: \
			begin \
				out_casted_``reg_name``_vector_data \
					= in_true_``reg_name``_data.data; \
			end \
			\
			PkgSnow64PsEx::NeededCastTypIntToInt: \
			begin \
				out_casted_``reg_name``_vector_data \
					= __out_inst_dsrc``dsrc_num``_int_vector_caster.data; \
			end \
			\
			PkgSnow64PsEx::NeededCastTypIntToBFloat16: \
			begin \
				out_casted_``reg_name``_vector_data \
					= `OUT_INST_TOF_BFLOAT16_VECTOR_CASTER(dsrc_num) \
					.data; \
			end \
			\
			PkgSnow64PsEx::NeededCastTypBFloat16ToInt: \
			begin \
				out_casted_``reg_name``_vector_data \
					= `OUT_INST_TOF_BFLOAT16_VECTOR_CASTER(dsrc_num) \
					.data; \
			end \
			endcase \
		end \
		endcase \
	end

	`SET_OUT_CASTED_VECTOR_DATA(rb, 0)
	`SET_OUT_CASTED_VECTOR_DATA(rc, 1)
	`undef SET_OUT_CASTED_VECTOR_DATA
	`undef OUT_INST_TOF_BFLOAT16_VECTOR_CASTER

	always_ff @(posedge clk)
	begin
		case (__state)
		PkgSnow64PsEx::CastStNoWait:
		begin
			case (__starting_bfloat16_cast)
			1'b0:
			begin
				out_valid <= __starting_any_cast;
			end

			1'b1:
			begin
				__state <= PkgSnow64PsEx::CastStWaitForBFloat16Caster;
				out_valid <= 1'b0;
			end
			endcase
		end

		PkgSnow64PsEx::CastStWaitForBFloat16Caster:
		begin
			if (__out_inst_dsrc0_tof_bfloat16_vector_caster.valid
				|| __out_inst_dsrc1_tof_bfloat16_vector_caster.valid)
			begin
				__state <= PkgSnow64PsEx::CastStNoWait;
				out_valid <= 1'b1;
			end
		end
		endcase
	end

endmodule




module Snow64PsExExtractScalarData
	(input PkgSnow64PsEx::TrueLarData
		in_true_ra_data, in_true_rb_data, in_true_rc_data,
	output logic [`MSB_POS__SNOW64_SCALAR_DATA:0]
		out_ra_scalar_data, out_rb_scalar_data, out_rc_scalar_data);

	PkgSnow64ScalarDataExtractOrInject::PortIn_ScalarDataExtractor
		__in_inst_ddest_scalar_data_extractor,
		__in_inst_dsrc0_scalar_data_extractor,
		__in_inst_dsrc1_scalar_data_extractor;
	PkgSnow64ScalarDataExtractOrInject::PortOut_ScalarDataExtractor
		__out_inst_ddest_scalar_data_extractor,
		__out_inst_dsrc0_scalar_data_extractor,
		__out_inst_dsrc1_scalar_data_extractor;

	Snow64ScalarDataExtractor __inst_ddest_scalar_data_extractor
		(.in(__in_inst_ddest_scalar_data_extractor),
		.out(__out_inst_ddest_scalar_data_extractor));
	Snow64ScalarDataExtractor __inst_dsrc0_scalar_data_extractor
		(.in(__in_inst_dsrc0_scalar_data_extractor),
		.out(__out_inst_dsrc0_scalar_data_extractor));
	Snow64ScalarDataExtractor __inst_dsrc1_scalar_data_extractor
		(.in(__in_inst_dsrc1_scalar_data_extractor),
		.out(__out_inst_dsrc1_scalar_data_extractor));

	// typedef struct packed
	// {
	// 	LarData to_shift;
	// 	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] data_type;
	// 	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
	// 	DataOffset data_offset;
	// } PortIn_ScalarDataExtractor;
	assign __in_inst_ddest_scalar_data_extractor
		= {in_true_ra_data.data,
		in_true_ra_data.data_type,
		in_true_ra_data.int_type_size,
		in_true_ra_data.data_offset};
	assign __in_inst_dsrc0_scalar_data_extractor
		= {in_true_rb_data.data,
		in_true_rb_data.data_type,
		in_true_rb_data.int_type_size,
		in_true_rb_data.data_offset};
	assign __in_inst_dsrc1_scalar_data_extractor
		= {in_true_rc_data.data,
		in_true_rc_data.data_type,
		in_true_rc_data.int_type_size,
		in_true_rc_data.data_offset};


	assign out_ra_scalar_data
		= __out_inst_ddest_scalar_data_extractor.data;
	assign out_rb_scalar_data
		= __out_inst_dsrc0_scalar_data_extractor.data;
	assign out_rc_scalar_data
		= __out_inst_dsrc1_scalar_data_extractor.data;

endmodule

// For when, for a scalar ALU/FPU instruction, there's a type mismatch
// between dDest and either of dSrc0 and dSrc1 (or both)
module Snow64PsExInjectCastedScalarData
	(input PkgSnow64PsEx::TrueLarData in_true_ra_data,
	input logic [`MSB_POS__SNOW64_SCALAR_DATA:0]
		in_casted_rb_scalar_data, in_casted_rc_scalar_data,
	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		out_injected_rb_vector_data, out_injected_rc_vector_data);

	PkgSnow64ScalarDataExtractOrInject::PortIn_ScalarDataInjector
		__in_inst_dsrc0_scalar_data_injector,
		__in_inst_dsrc1_scalar_data_injector;
	PkgSnow64ScalarDataExtractOrInject::PortOut_ScalarDataInjector
		__out_inst_dsrc0_scalar_data_injector,
		__out_inst_dsrc1_scalar_data_injector;
	Snow64ScalarDataInjector __inst_dsrc0_scalar_data_injector
		(.in(__in_inst_dsrc0_scalar_data_injector),
		.out(__out_inst_dsrc0_scalar_data_injector));
	Snow64ScalarDataInjector __inst_dsrc1_scalar_data_injector
		(.in(__in_inst_dsrc1_scalar_data_injector),
		.out(__out_inst_dsrc1_scalar_data_injector));

	// typedef struct packed
	// {
	// 	LarData to_modify;
	// 	ScalarData to_shift;
	// 	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] data_type;
	// 	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
	// 	DataOffset data_offset;
	// } PortIn_ScalarDataInjector;
	// It doesn't really matter what the "to_modify" field is in this case
	// since we're just going to mask off everything irrelevant after using
	// the vector unit.
	assign __in_inst_dsrc0_scalar_data_injector
		= {`WIDTH__SNOW64_LAR_FILE_DATA'h00,
		in_casted_rb_scalar_data,
		in_true_ra_data.data_type,
		in_true_ra_data.int_type_size,
		in_true_ra_data.data_offset};
	assign __in_inst_dsrc1_scalar_data_injector
		= {`WIDTH__SNOW64_LAR_FILE_DATA'h00,
		in_casted_rc_scalar_data,
		in_true_ra_data.data_type,
		in_true_ra_data.int_type_size,
		in_true_ra_data.data_offset};



	assign out_injected_rb_vector_data
		= __out_inst_dsrc0_scalar_data_injector.data;
	assign out_injected_rc_vector_data
		= __out_inst_dsrc1_scalar_data_injector.data;

endmodule


	`define GET_OUT_DDEST_DATA(some_out_inst_module_data) \
	always @(*) \
	begin \
		case (in_curr_decoded_instr.op_type) \
		PkgSnow64InstrDecoder::OpTypeScalar: \
		begin \
			out_ddest_data = ((some_out_inst_module_data & in_mask) \
				| (in_true_ra_data.data & in_inv_mask)); \
		end \
		\
		PkgSnow64InstrDecoder::OpTypeVector: \
		begin \
			out_ddest_data = some_out_inst_module_data; \
		end \
		endcase \
	end

module Snow64PsExUseVectorAlu
	(input Snow64Pipeline_DecodedInstr in_curr_decoded_instr,
	input PkgSnow64PsEx::TrueLarData in_true_ra_data,
	input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		in_any_dsrc0_data, in_any_dsrc1_data, in_mask, in_inv_mask,
	input logic [`MSB_POS__SNOW64_CPU_ADDR:0] in_pc_val,
	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] out_ddest_data);


	wire [`MSB_POS__SNOW64_SIZE_64:0] __signext_imm
		= in_curr_decoded_instr.signext_imm;

	wire [`MSB_POS__SNOW64_SIZE_8:0]
		__scalar_pc_val_8, __scalar_signext_imm_8;
	wire [`MSB_POS__SNOW64_SIZE_16:0]
		__scalar_pc_val_16, __scalar_signext_imm_16;
	wire [`MSB_POS__SNOW64_SIZE_32:0]
		__scalar_pc_val_32, __scalar_signext_imm_32;
	wire [`MSB_POS__SNOW64_SIZE_64:0]
		__scalar_pc_val_64, __scalar_signext_imm_64;
	assign __scalar_pc_val_8 = in_pc_val[`WIDTH2MP(8):0];
	assign __scalar_signext_imm_8 = __signext_imm[`WIDTH2MP(8):0];
	assign __scalar_pc_val_16 = in_pc_val[`WIDTH2MP(16):0];
	assign __scalar_signext_imm_16 = __signext_imm[`WIDTH2MP(16):0];
	assign __scalar_pc_val_32 = in_pc_val[`WIDTH2MP(32):0];
	assign __scalar_signext_imm_32 = __signext_imm[`WIDTH2MP(32):0];
	assign __scalar_pc_val_64 = in_pc_val[`WIDTH2MP(64):0];
	assign __scalar_signext_imm_64 = __signext_imm[`WIDTH2MP(64):0];


	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__vector_pc_val_8, __vector_pc_val_16,
		__vector_pc_val_32, __vector_pc_val_64,
		__vector_signext_imm_8, __vector_signext_imm_16,
		__vector_signext_imm_32, __vector_signext_imm_64;

	assign __vector_pc_val_8[0 * 64 +: 64]
		= {__scalar_pc_val_8, __scalar_pc_val_8,
		__scalar_pc_val_8, __scalar_pc_val_8,
		__scalar_pc_val_8, __scalar_pc_val_8,
		__scalar_pc_val_8, __scalar_pc_val_8};
	assign __vector_pc_val_8[1 * 64 +: 64]
		= {__scalar_pc_val_8, __scalar_pc_val_8,
		__scalar_pc_val_8, __scalar_pc_val_8,
		__scalar_pc_val_8, __scalar_pc_val_8,
		__scalar_pc_val_8, __scalar_pc_val_8};
	assign __vector_pc_val_8[2 * 64 +: 64]
		= {__scalar_pc_val_8, __scalar_pc_val_8,
		__scalar_pc_val_8, __scalar_pc_val_8,
		__scalar_pc_val_8, __scalar_pc_val_8,
		__scalar_pc_val_8, __scalar_pc_val_8};
	assign __vector_pc_val_8[3 * 64 +: 64]
		= {__scalar_pc_val_8, __scalar_pc_val_8,
		__scalar_pc_val_8, __scalar_pc_val_8,
		__scalar_pc_val_8, __scalar_pc_val_8,
		__scalar_pc_val_8, __scalar_pc_val_8};

	assign __vector_pc_val_16[0 * 64 +: 64]
		= {__scalar_pc_val_16, __scalar_pc_val_16,
		__scalar_pc_val_16, __scalar_pc_val_16};
	assign __vector_pc_val_16[1 * 64 +: 64]
		= {__scalar_pc_val_16, __scalar_pc_val_16,
		__scalar_pc_val_16, __scalar_pc_val_16};
	assign __vector_pc_val_16[2 * 64 +: 64]
		= {__scalar_pc_val_16, __scalar_pc_val_16,
		__scalar_pc_val_16, __scalar_pc_val_16};
	assign __vector_pc_val_16[3 * 64 +: 64]
		= {__scalar_pc_val_16, __scalar_pc_val_16,
		__scalar_pc_val_16, __scalar_pc_val_16};

	assign __vector_pc_val_32[0 * 64 +: 64]
		= {__scalar_pc_val_32, __scalar_pc_val_32};
	assign __vector_pc_val_32[1 * 64 +: 64]
		= {__scalar_pc_val_32, __scalar_pc_val_32};
	assign __vector_pc_val_32[2 * 64 +: 64]
		= {__scalar_pc_val_32, __scalar_pc_val_32};
	assign __vector_pc_val_32[3 * 64 +: 64]
		= {__scalar_pc_val_32, __scalar_pc_val_32};
	assign __vector_pc_val_64[0 * 64 +: 64] = __scalar_pc_val_64;
	assign __vector_pc_val_64[1 * 64 +: 64] = __scalar_pc_val_64;
	assign __vector_pc_val_64[2 * 64 +: 64] = __scalar_pc_val_64;
	assign __vector_pc_val_64[3 * 64 +: 64] = __scalar_pc_val_64;

	assign __vector_signext_imm_8[0 * 64 +: 64]
		= {__scalar_signext_imm_8, __scalar_signext_imm_8,
		__scalar_signext_imm_8, __scalar_signext_imm_8,
		__scalar_signext_imm_8, __scalar_signext_imm_8,
		__scalar_signext_imm_8, __scalar_signext_imm_8};
	assign __vector_signext_imm_8[1 * 64 +: 64]
		= {__scalar_signext_imm_8, __scalar_signext_imm_8,
		__scalar_signext_imm_8, __scalar_signext_imm_8,
		__scalar_signext_imm_8, __scalar_signext_imm_8,
		__scalar_signext_imm_8, __scalar_signext_imm_8};
	assign __vector_signext_imm_8[2 * 64 +: 64]
		= {__scalar_signext_imm_8, __scalar_signext_imm_8,
		__scalar_signext_imm_8, __scalar_signext_imm_8,
		__scalar_signext_imm_8, __scalar_signext_imm_8,
		__scalar_signext_imm_8, __scalar_signext_imm_8};
	assign __vector_signext_imm_8[3 * 64 +: 64]
		= {__scalar_signext_imm_8, __scalar_signext_imm_8,
		__scalar_signext_imm_8, __scalar_signext_imm_8,
		__scalar_signext_imm_8, __scalar_signext_imm_8,
		__scalar_signext_imm_8, __scalar_signext_imm_8};

	assign __vector_signext_imm_16[0 * 64 +: 64]
		= {__scalar_signext_imm_16, __scalar_signext_imm_16,
		__scalar_signext_imm_16, __scalar_signext_imm_16};
	assign __vector_signext_imm_16[1 * 64 +: 64]
		= {__scalar_signext_imm_16, __scalar_signext_imm_16,
		__scalar_signext_imm_16, __scalar_signext_imm_16};
	assign __vector_signext_imm_16[2 * 64 +: 64]
		= {__scalar_signext_imm_16, __scalar_signext_imm_16,
		__scalar_signext_imm_16, __scalar_signext_imm_16};
	assign __vector_signext_imm_16[3 * 64 +: 64]
		= {__scalar_signext_imm_16, __scalar_signext_imm_16,
		__scalar_signext_imm_16, __scalar_signext_imm_16};

	assign __vector_signext_imm_32[0 * 64 +: 64]
		= {__scalar_signext_imm_32, __scalar_signext_imm_32};
	assign __vector_signext_imm_32[1 * 64 +: 64]
		= {__scalar_signext_imm_32, __scalar_signext_imm_32};
	assign __vector_signext_imm_32[2 * 64 +: 64]
		= {__scalar_signext_imm_32, __scalar_signext_imm_32};
	assign __vector_signext_imm_32[3 * 64 +: 64]
		= {__scalar_signext_imm_32, __scalar_signext_imm_32};
	assign __vector_signext_imm_64[0 * 64 +: 64] = __scalar_signext_imm_64;
	assign __vector_signext_imm_64[1 * 64 +: 64] = __scalar_signext_imm_64;
	assign __vector_signext_imm_64[2 * 64 +: 64] = __scalar_signext_imm_64;
	assign __vector_signext_imm_64[3 * 64 +: 64] = __scalar_signext_imm_64;


	PkgSnow64ArithLog::PortIn_VectorAlu __in_inst_vector_alu;
	PkgSnow64ArithLog::PortOut_VectorAlu __out_inst_vector_alu;

	Snow64VectorAlu __inst_vector_alu(.in(__in_inst_vector_alu),
		.out(__out_inst_vector_alu));

	always @(*) __in_inst_vector_alu.a = in_any_dsrc0_data;
	always @(*) __in_inst_vector_alu.int_type_size
		= in_true_ra_data.int_type_size;
	always @(*) __in_inst_vector_alu.type_signedness
		= (in_true_ra_data.data_type == PkgSnow64Cpu::DataTypSgnInt);

	always @(*) __in_inst_vector_alu.oper = in_curr_decoded_instr.oper;

	always @(*)
	begin
		case (in_curr_decoded_instr.oper)
		PkgSnow64InstrDecoder::Addi_OneRegOnePcOneSimm12:
		begin
			case (in_true_ra_data.int_type_size)
			PkgSnow64Cpu::IntTypSz8:
				__in_inst_vector_alu.b = __vector_pc_val_8;
			PkgSnow64Cpu::IntTypSz16:
				__in_inst_vector_alu.b = __vector_pc_val_16;
			PkgSnow64Cpu::IntTypSz32:
				__in_inst_vector_alu.b = __vector_pc_val_32;
			PkgSnow64Cpu::IntTypSz64:
				__in_inst_vector_alu.b = __vector_pc_val_64;
			endcase
		end

		PkgSnow64InstrDecoder::Addi_TwoRegsOneSimm12:
		begin
			case (in_true_ra_data.int_type_size)
			PkgSnow64Cpu::IntTypSz8:
				__in_inst_vector_alu.b = __vector_signext_imm_8;
			PkgSnow64Cpu::IntTypSz16:
				__in_inst_vector_alu.b = __vector_signext_imm_16;
			PkgSnow64Cpu::IntTypSz32:
				__in_inst_vector_alu.b = __vector_signext_imm_32;
			PkgSnow64Cpu::IntTypSz64:
				__in_inst_vector_alu.b = __vector_signext_imm_64;
			endcase
		end

		default:
		begin
			__in_inst_vector_alu.b = in_any_dsrc1_data;
		end
		endcase
	end

	`GET_OUT_DDEST_DATA(__out_inst_vector_alu.data)

endmodule



module Snow64PsExUseVectorMul(input logic clk,
	input logic in_start,
	input Snow64Pipeline_DecodedInstr in_curr_decoded_instr,
	input PkgSnow64PsEx::TrueLarData in_true_ra_data,
	input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		in_any_dsrc0_data, in_any_dsrc1_data, in_mask, in_inv_mask,
	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] out_ddest_data,
	output logic out_valid);

	PkgSnow64ArithLog::PortIn_VectorMul __in_inst_vector_mul;
	PkgSnow64ArithLog::PortOut_VectorMul __out_inst_vector_mul;
	Snow64VectorMul __inst_vector_mul(.clk(clk), .in(__in_inst_vector_mul),
		.out(__out_inst_vector_mul));

	// typedef struct packed
	// {
	// 	logic enable;

	// 	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;

	// 	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] a, b;
	// } PortIn_VectorMul;

	assign __in_inst_vector_mul
		= {in_start,
		in_true_ra_data.int_type_size,
		in_any_dsrc0_data,
		in_any_dsrc1_data};

	always @(*) out_valid = __out_inst_vector_mul.valid;
	`GET_OUT_DDEST_DATA(__out_inst_vector_mul.data)

endmodule

module Snow64PsExUseVectorDiv(input logic clk,
	input logic in_start,
	input Snow64Pipeline_DecodedInstr in_curr_decoded_instr,
	input PkgSnow64PsEx::TrueLarData in_true_ra_data,
	input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		in_any_dsrc0_data, in_any_dsrc1_data, in_mask, in_inv_mask,
	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] out_ddest_data,
	output logic out_valid);

	PkgSnow64ArithLog::PortIn_VectorDiv __in_inst_vector_div;
	PkgSnow64ArithLog::PortOut_VectorDiv __out_inst_vector_div;
	Snow64VectorDiv __inst_vector_div(.clk(clk), .in(__in_inst_vector_div),
		.out(__out_inst_vector_div));

	// typedef struct packed
	// {
	// 	logic enable;

	// 	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
	// 	logic type_signedness;

	// 	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] a, b;
	// } PortIn_VectorDiv;

	assign __in_inst_vector_div
		= {in_start,
		in_true_ra_data.int_type_size,
		(in_true_ra_data.data_type == PkgSnow64Cpu::DataTypSgnInt),
		in_any_dsrc0_data,
		in_any_dsrc1_data};

	always @(*) out_valid = __out_inst_vector_div.valid;
	`GET_OUT_DDEST_DATA(__out_inst_vector_div.data)

endmodule

module Snow64PsExUseVectorBFloat16Fpu(input logic clk,
	input logic in_start,
	input Snow64Pipeline_DecodedInstr in_curr_decoded_instr,
	input PkgSnow64PsEx::TrueLarData in_true_ra_data,
	input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		in_any_dsrc0_data, in_any_dsrc1_data, in_mask, in_inv_mask,
	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] out_ddest_data,
	output logic out_valid);

	PkgSnow64BFloat16::PortIn_VectorFpu __in_inst_vector_fpu;
	PkgSnow64BFloat16::PortOut_VectorFpu __out_inst_vector_fpu;
	Snow64BFloat16VectorFpu __inst_vector_fpu(.clk(clk),
		.in(__in_inst_vector_fpu), .out(__out_inst_vector_fpu));

	// typedef struct packed
	// {
	// 	logic start;
	// 	logic [`MSB_POS__SNOW64_BFLOAT16_FPU_OPER:0] oper;
	// 	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] a, b;
	// } PortIn_VectorFpu;
	assign __in_inst_vector_fpu
		= {in_start,
		in_curr_decoded_instr.oper,
		in_any_dsrc0_data,
		in_any_dsrc1_data};

	always @(*) out_valid = __out_inst_vector_fpu.valid;
	`GET_OUT_DDEST_DATA(__out_inst_vector_fpu.data)

endmodule

`undef GET_OUT_DDEST_DATA


module Snow64PsExPerfSimSyscall(input logic clk,
	input logic [`MSB_POS__SNOW64_CPU_ADDR:0] in_pc_val,
	input Snow64Pipeline_DecodedInstr in_curr_decoded_instr,
	input PkgSnow64PsEx::TrueLarData
		in_true_ra_data, in_true_rb_data, in_true_rc_data);

	localparam __WIDTH__SYSCALL_TYPE = 3;
	localparam __MSB_POS__SYSCALL_TYPE = `WIDTH2MP(__WIDTH__SYSCALL_TYPE);
	typedef enum logic [__MSB_POS__SYSCALL_TYPE:0]
	{
		SyscTypDispRegs,
		SyscTypFinish
	} SyscallType;
	
	wire [__MSB_POS__SYSCALL_TYPE:0] __syscall_type
		= in_curr_decoded_instr.signext_imm[__MSB_POS__SYSCALL_TYPE:0];

	task disp_reg(input PkgSnow64PsEx::TrueLarData to_disp);
		case (to_disp.data_type)
		PkgSnow64Cpu::DataTypBFloat16:
		begin
			$display("data_type:  BFloat16");
		end
		PkgSnow64Cpu::DataTypReserved:
		begin
			$display("data_type:  Reserved (Eek!)");
		end
		PkgSnow64Cpu::DataTypUnsgnInt:
		begin
			$display("data_type:  UnsgnInt");
		end
		PkgSnow64Cpu::DataTypSgnInt:
		begin
			$display("data_type:  SgnInt");
		end
		endcase

		case (to_disp.int_type_size)
		PkgSnow64Cpu::IntTypSz8:
		begin
			$display("int_type_size:  8");
		end
		PkgSnow64Cpu::IntTypSz16:
		begin
			$display("int_type_size:  16");
		end
		PkgSnow64Cpu::IntTypSz32:
		begin
			$display("int_type_size:  32");
		end
		PkgSnow64Cpu::IntTypSz64:
		begin
			$display("int_type_size:  64");
		end
		endcase

		$display("data_offset:  %h", to_disp.data_offset);
		$display("data:  %h", to_disp.data);
		$display("base_addr:  %h", to_disp.base_addr);
		$display("raw address:  %h", {to_disp.base_addr,
			to_disp.data_offset});
	endtask

	always @(posedge clk)
	begin
		if ((in_curr_decoded_instr.group == 0)
			&& (in_curr_decoded_instr.oper
			== PkgSnow64InstrDecoder::SimSyscall_ThreeRegsOneSimm12))
		begin
			$display("sim_syscall pc:  %h", in_pc_val);
			case (__syscall_type)
			SyscTypDispRegs:
			begin
				$display("rA:  ");
				disp_reg(in_true_ra_data);
				//$display();
				//$display("rB:  ");
				//disp_reg(in_true_rb_data);
				//$display();
				//$display("rC:  ");
				//disp_reg(in_true_rc_data);
			end

			SyscTypFinish:
			begin
				$display("EX:  Finishing.");
				$finish;
			end
			endcase
		end
	end

endmodule

// This is far less of a monster than I was thinking it'd be, but only
// because I separated out the submodules.
module Snow64PipeStageEx(input logic clk,
	input PortIn_Snow64PipeStageEx_FromCtrlUnit in_from_ctrl_unit,
	input PortIn_Snow64PipeStageEx_FromPipeStageIfId
		in_from_pipe_stage_if_id,
	output PortOut_Snow64PipeStageEx_ToPipeStageIfId
		out_to_pipe_stage_if_id,
	output PortOut_Snow64PipeStageEx_ToPipeStageWb out_to_pipe_stage_wb);



	logic [`MSB_POS__SNOW64_PIPE_STAGE_EX_STATE:0]
		__state = PkgSnow64PsEx::StRegular,
		__next_state = PkgSnow64PsEx::StRegular;

	wire __stall = (__next_state != PkgSnow64PsEx::StRegular);

	logic [`MSB_POS__SNOW64_PIPE_STAGE_EX_MULTI_CYCLE_OP_TYPE:0]
		__multi_cycle_op_type = PkgSnow64PsEx::MultiCycOpTypNone;


	Snow64Pipeline_DecodedInstr __curr_decoded_instr;
	assign __curr_decoded_instr = in_from_pipe_stage_if_id.decoded_instr;


	PkgSnow64PsEx::Results __curr_results = 0;



	//Snow64Pipeline_LarFileReadMetadata
	//	__from_lar_file__rd_metadata_a, __from_lar_file__rd_metadata_b,
	//	__from_lar_file__rd_metadata_c;
	//Snow64Pipeline_LarFileReadShareddata
	//	__from_lar_file__rd_shareddata_a, __from_lar_file__rd_shareddata_b,
	//	__from_lar_file__rd_shareddata_c;
	Snow64Pipeline_LarFileReadMetadata __from_lar_file__rd_metadata_a;
	assign __from_lar_file__rd_metadata_a
		= in_from_ctrl_unit.out_inst_lar_file__rd_metadata_a;
	PkgSnow64PsEx::TrueLarData
		__true_ra_data, __true_rb_data, __true_rc_data;

	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__rotated_dsrc0_data, __rotated_dsrc1_data,
		__mask_for_scalar_op, __inv_mask_for_scalar_op;

	wire [`MSB_POS__SNOW64_SCALAR_DATA:0]
		__curr_ddest_scalar_data, __curr_dsrc0_scalar_data,
		__curr_dsrc1_scalar_data;

	logic [`MSB_POS__SNOW64_PIPE_STAGE_EX_NEEDED_CAST_TYPE:0]
		__dsrc0_needed_cast_type = 0, __dsrc1_needed_cast_type = 0;

	wire [`MSB_POS__SNOW64_SCALAR_DATA:0]
		__dsrc0_casted_scalar_data, __dsrc1_casted_scalar_data;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__dsrc0_casted_vector_data, __dsrc1_casted_vector_data,
		__dsrc0_injected_vector_data, __dsrc1_injected_vector_data;

	// If the decoded instruction is entirely zero, then it is considered a
	// bubble.
	wire __need_any_cast = ((in_from_pipe_stage_if_id.decoded_instr != 0)
		&& {__dsrc0_needed_cast_type, __dsrc1_needed_cast_type});

	wire __in_inst_cast_scalars__start
		= ((__state == PkgSnow64PsEx::StRegular) && __need_any_cast
		&& (__curr_decoded_instr.op_type
		== PkgSnow64InstrDecoder::OpTypeScalar));
	wire __in_inst_cast_vectors__start
		= ((__state == PkgSnow64PsEx::StRegular) && __need_any_cast
		&& (__curr_decoded_instr.op_type
		== PkgSnow64InstrDecoder::OpTypeVector));
	wire __out_inst_cast_scalars__valid, __out_inst_cast_vectors__valid;

	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__dsrc0_data_to_use = 0, __dsrc1_data_to_use = 0;

	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__out_inst_use_vector_alu__data,
		__out_inst_use_vector_mul__data,
		__out_inst_use_vector_div__data,
		__out_inst_use_vector_bfloat16_fpu__data;

	wire __going_to_perf_multi_cycle_op
		= (__next_state == PkgSnow64PsEx::StWaitForMultiCycleOp);

	wire __in_inst_use_vector_mul__start
		= (__going_to_perf_multi_cycle_op
		&& (__multi_cycle_op_type == PkgSnow64PsEx::MultiCycOpTypMul));
	wire __in_inst_use_vector_div__start
		= (__going_to_perf_multi_cycle_op
		&& (__multi_cycle_op_type == PkgSnow64PsEx::MultiCycOpTypDiv));
	wire __in_inst_use_vector_bfloat16_fpu__start
		= (__going_to_perf_multi_cycle_op
		&& (__multi_cycle_op_type == PkgSnow64PsEx::MultiCycOpTypFpu));
	wire __out_inst_use_vector_mul__valid,
		__out_inst_use_vector_div__valid,
		__out_inst_use_vector_bfloat16_fpu__valid;

	wire __any_multi_cycle_op_out_valid
		= (__out_inst_use_vector_mul__valid
		|| __out_inst_use_vector_div__valid
		|| __out_inst_use_vector_bfloat16_fpu__valid);

	always @(*)
	begin
		case (__curr_decoded_instr.group)
		0:
		begin
			case (__true_ra_data.data_type)
			PkgSnow64Cpu::DataTypBFloat16:
			begin
				__multi_cycle_op_type = PkgSnow64PsEx::MultiCycOpTypFpu;
			end

			default:
			begin
				case (__curr_decoded_instr.oper)
				PkgSnow64InstrDecoder::Mul_ThreeRegs:
				begin
					__multi_cycle_op_type
						= PkgSnow64PsEx::MultiCycOpTypMul;
				end

				PkgSnow64InstrDecoder::Div_ThreeRegs:
				begin
					__multi_cycle_op_type
						= PkgSnow64PsEx::MultiCycOpTypDiv;
				end

				default:
				begin
					__multi_cycle_op_type
						= PkgSnow64PsEx::MultiCycOpTypNone;
				end
				endcase
			end
			endcase
		end

		default:
		begin
			__multi_cycle_op_type = PkgSnow64PsEx::MultiCycOpTypNone;
		end
		endcase
	end

	`define SET_DATA_TO_USE(reg_name, dsrc_num) \
	always @(*) \
	begin \
		case (__state) \
		PkgSnow64PsEx::StRegular: \
		begin \
			__dsrc``dsrc_num``_data_to_use \
				= (__curr_decoded_instr.op_type \
				== PkgSnow64InstrDecoder::OpTypeScalar) \
				? __rotated_dsrc``dsrc_num``_data \
				: __true_``reg_name``_data.data; \
		end \
		\
		/* PkgSnow64PsEx::StUseUncastedDataMultiCycle: */ \
		/* begin */ \
		/* 	__dsrc``dsrc_num``_data_to_use */ \
		/* 		= (__curr_decoded_instr.op_type */ \
		/* 		== PkgSnow64InstrDecoder::OpTypeScalar) */ \
		/* 		? __rotated_dsrc``dsrc_num``_data */ \
		/* 		: __true_``reg_name``_data.data; */ \
		/* end */ \
		\
		default: \
		begin \
			__dsrc``dsrc_num``_data_to_use \
				= (__curr_decoded_instr.op_type \
				== PkgSnow64InstrDecoder::OpTypeScalar) \
				? __dsrc``dsrc_num``_injected_vector_data \
				: __dsrc``dsrc_num``_casted_vector_data; \
		end \
		endcase \
	end

	`SET_DATA_TO_USE(rb, 0)
	`SET_DATA_TO_USE(rc, 1)
	`undef SET_DATA_TO_USE


	`define SET_NEEDED_CAST_TYPE(some_true_lar_data, out) \
	always @(*) \
	begin \
		case (__true_ra_data.data_type) \
		PkgSnow64Cpu::DataTypBFloat16: \
		begin \
			case (some_true_lar_data.data_type) \
			PkgSnow64Cpu::DataTypBFloat16: \
			begin \
				out = PkgSnow64PsEx::NeededCastTypNone; \
			end \
			\
			default: \
			begin \
				out = PkgSnow64PsEx::NeededCastTypIntToBFloat16; \
			end \
			endcase \
		end \
		\
		/* We don't care about PkgSnow64Cpu::DataTypReserved, so we'll */ \
		/* pretend it doesn't exist. */ \
		default: \
		begin \
			case (some_true_lar_data.data_type) \
			PkgSnow64Cpu::DataTypBFloat16: \
			begin \
				out = PkgSnow64PsEx::NeededCastTypBFloat16ToInt; \
			end \
			\
			default: \
			begin \
				out = (__true_ra_data.int_type_size \
					== some_true_lar_data.int_type_size) \
					? PkgSnow64PsEx::NeededCastTypNone \
					: PkgSnow64PsEx::NeededCastTypIntToInt; \
			end \
			endcase \
		end \
		endcase \
	end

	`SET_NEEDED_CAST_TYPE(__true_rb_data, __dsrc0_needed_cast_type)
	`SET_NEEDED_CAST_TYPE(__true_rc_data, __dsrc1_needed_cast_type)
	`undef SET_NEEDED_CAST_TYPE


	Snow64PsExPerfSimSyscall __inst_perf_sim_syscall(.clk(clk),
		.in_pc_val(in_from_pipe_stage_if_id.pc_val),
		.in_curr_decoded_instr(__curr_decoded_instr),
		.in_true_ra_data(__true_ra_data),
		.in_true_rb_data(__true_rb_data),
		.in_true_rc_data(__true_rc_data));


	// module Snow64PsExOperandForwarder(input logic clk,
	// 	input PortIn_Snow64PipeStageEx_FromCtrlUnit in_from_ctrl_unit,
	// 	input PkgSnow64PsEx::Results in_curr_results,
	// 	output PkgSnow64PsEx::TrueLarData
	// 		out_true_ra_data, out_true_rb_data, out_true_rc_data);
	Snow64PsExOperandForwarder __inst_operand_forwarder(.clk(clk),
		.in_from_ctrl_unit(in_from_ctrl_unit),
		.in_curr_results(__curr_results),
		.out_true_ra_data(__true_ra_data),
		.out_true_rb_data(__true_rb_data),
		.out_true_rc_data(__true_rc_data));

	//module Snow64PsExRotateLarData
	//	(input PkgSnow64PsEx::TrueLarData in_true_ra_data,
	//	input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
	//		in_dsrc0_data, in_dsrc1_data,
	//	input logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET:0]
	//		in_dsrc0_data_offset, in_dsrc1_data_offset,
	//		in_ddest_data_offset,
	//	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
	//		out_rotated_dsrc0_data, out_rotated_dsrc1_data,
	//		out_mask, out_inv_mask);
	Snow64PsExRotateLarData __inst_rotate_lar_data
		(.in_true_ra_data(__true_ra_data),
		.in_dsrc0_data(__true_rb_data.data),
		.in_dsrc1_data(__true_rc_data.data),
		.in_dsrc0_data_offset(__true_rb_data.data_offset),
		.in_dsrc1_data_offset(__true_rc_data.data_offset),
		.in_ddest_data_offset(__true_ra_data.data_offset),
		.out_rotated_dsrc0_data(__rotated_dsrc0_data),
		.out_rotated_dsrc1_data(__rotated_dsrc1_data),
		.out_mask(__mask_for_scalar_op),
		.out_inv_mask(__inv_mask_for_scalar_op));


	// module Snow64PsExCastScalars(input logic clk,
	// 	input logic in_start, in_forced_64_bit_integers,
	// 	input PkgSnow64PsEx::TrueLarData
	// 		in_true_ra_data, in_true_rb_data, in_true_rc_data,
	// 	input logic [`MSB_POS__SNOW64_PIPE_STAGE_EX_NEEDED_CAST_TYPE:0]
	// 		in_dsrc0_needed_cast_type, in_dsrc1_needed_cast_type,
	// 	input logic [`MSB_POS__SNOW64_SCALAR_DATA:0]
	// 		in_uncasted_rb_scalar_data, in_uncasted_rc_scalar_data,
	// 	output logic [`MSB_POS__SNOW64_SCALAR_DATA:0]
	// 		out_casted_rb_scalar_data, out_casted_rc_scalar_data,
	// 	output logic out_valid);
	Snow64PsExCastScalars __inst_cast_scalars(.clk(clk),
		.in_start(__in_inst_cast_scalars__start),
		.in_forced_64_bit_integers
			(__curr_decoded_instr.forced_64_bit_integers),
		.in_true_ra_data(__true_ra_data),
		.in_true_rb_data(__true_rb_data),
		.in_true_rc_data(__true_rc_data),
		.in_dsrc0_needed_cast_type(__dsrc0_needed_cast_type),
		.in_dsrc1_needed_cast_type(__dsrc1_needed_cast_type),
		.in_uncasted_rb_scalar_data(__curr_dsrc0_scalar_data),
		.in_uncasted_rc_scalar_data(__curr_dsrc1_scalar_data),
		.out_casted_rb_scalar_data(__dsrc0_casted_scalar_data),
		.out_casted_rc_scalar_data(__dsrc1_casted_scalar_data),
		.out_valid(__out_inst_cast_scalars__valid));


	// module Snow64PsExCastVectors(input logic clk,
	// 	input logic in_start, in_forced_64_bit_integers,
	// 	input PkgSnow64PsEx::TrueLarData
	// 		in_true_ra_data, in_true_rb_data, in_true_rc_data,
	// 	input logic [`MSB_POS__SNOW64_PIPE_STAGE_EX_NEEDED_CAST_TYPE:0]
	// 		in_dsrc0_needed_cast_type, in_dsrc1_needed_cast_type,
	// 	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
	// 		out_casted_rb_vector_data, out_casted_rc_vector_data,
	// 	output logic out_valid);
	Snow64PsExCastVectors __inst_cast_vectors(.clk(clk),
		.in_start(__in_inst_cast_vectors__start),
		.in_forced_64_bit_integers
			(__curr_decoded_instr.forced_64_bit_integers),
		.in_true_ra_data(__true_ra_data),
		.in_true_rb_data(__true_rb_data),
		.in_true_rc_data(__true_rc_data),
		.in_dsrc0_needed_cast_type(__dsrc0_needed_cast_type),
		.in_dsrc1_needed_cast_type(__dsrc1_needed_cast_type),
		.out_casted_rb_vector_data(__dsrc0_casted_vector_data),
		.out_casted_rc_vector_data(__dsrc1_casted_vector_data),
		.out_valid(__out_inst_cast_vectors__valid));




	// module Snow64PsExExtractScalarData
	// 	(input PkgSnow64PsEx::TrueLarData
	// 		in_true_ra_data, in_true_rb_data, in_true_rc_data,
	// 	output logic [`MSB_POS__SNOW64_SCALAR_DATA:0]
	// 		out_ra_scalar_data, out_rb_scalar_data, out_rc_scalar_data);
	Snow64PsExExtractScalarData __inst_extract_scalar_data
		(.in_true_ra_data(__true_ra_data),
		.in_true_rb_data(__true_rb_data),
		.in_true_rc_data(__true_rc_data),
		.out_ra_scalar_data(__curr_ddest_scalar_data),
		.out_rb_scalar_data(__curr_dsrc0_scalar_data),
		.out_rc_scalar_data(__curr_dsrc1_scalar_data));


	// module Snow64PsExInjectCastedScalarData
	// 	(input PkgSnow64PsEx::TrueLarData in_true_ra_data,
	// 	input logic [`MSB_POS__SNOW64_SCALAR_DATA:0]
	// 		in_casted_rb_scalar_data, in_casted_rc_scalar_data,
	// 	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
	// 		out_injected_rb_vector_data, out_injected_rc_vector_data);
	Snow64PsExInjectCastedScalarData __inst_inject_scalar_data
		(.in_true_ra_data(__true_ra_data),
		.in_casted_rb_scalar_data(__dsrc0_casted_scalar_data),
		.in_casted_rc_scalar_data(__dsrc1_casted_scalar_data),
		.out_injected_rb_vector_data(__dsrc0_injected_vector_data),
		.out_injected_rc_vector_data(__dsrc1_injected_vector_data));

	// module Snow64PsExUseVectorAlu
	// 	(input Snow64Pipeline_DecodedInstr in_curr_decoded_instr,
	// 	input PkgSnow64PsEx::TrueLarData in_true_ra_data,
	// 	input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
	// 		in_any_dsrc0_data, in_any_dsrc1_data, in_mask, in_inv_mask,
	// 	input logic [`MSB_POS__SNOW64_CPU_ADDR:0] in_pc_val,
	// 	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] out_ddest_data);
	Snow64PsExUseVectorAlu __inst_use_vector_alu
		(.in_curr_decoded_instr(__curr_decoded_instr),
		.in_true_ra_data(__true_ra_data),
		.in_any_dsrc0_data(__dsrc0_data_to_use),
		.in_any_dsrc1_data(__dsrc1_data_to_use),
		.in_mask(__mask_for_scalar_op),
		.in_inv_mask(__inv_mask_for_scalar_op),
		.in_pc_val(in_from_pipe_stage_if_id.pc_val),
		.out_ddest_data(__out_inst_use_vector_alu__data));

	// module Snow64PsExUseVectorMul(input logic clk,
	// 	input logic in_start,
	// 	input Snow64Pipeline_DecodedInstr in_curr_decoded_instr,
	// 	input PkgSnow64PsEx::TrueLarData in_true_ra_data,
	// 	input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
	// 		in_any_dsrc0_data, in_any_dsrc1_data, in_mask, in_inv_mask,
	// 	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] out_ddest_data,
	// 	output logic out_valid);
	Snow64PsExUseVectorMul __inst_use_vector_mul(.clk(clk),
		.in_start(__in_inst_use_vector_mul__start),
		.in_curr_decoded_instr(__curr_decoded_instr),
		.in_true_ra_data(__true_ra_data),
		.in_any_dsrc0_data(__dsrc0_data_to_use),
		.in_any_dsrc1_data(__dsrc1_data_to_use),
		.in_mask(__mask_for_scalar_op),
		.in_inv_mask(__inv_mask_for_scalar_op),
		.out_ddest_data(__out_inst_use_vector_mul__data),
		.out_valid(__out_inst_use_vector_mul__valid));
	//assign __out_inst_use_vector_mul__data = 0;
	//assign __out_inst_use_vector_mul__valid = 1;

	// module Snow64PsExUseVectorDiv(input logic clk,
	// 	input logic in_start,
	// 	input Snow64Pipeline_DecodedInstr in_curr_decoded_instr,
	// 	input PkgSnow64PsEx::TrueLarData in_true_ra_data,
	// 	input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
	// 		in_any_dsrc0_data, in_any_dsrc1_data, in_mask, in_inv_mask,
	// 	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] out_ddest_data,
	// 	output logic out_valid);
	Snow64PsExUseVectorDiv __inst_use_vector_div(.clk(clk),
		.in_start(__in_inst_use_vector_div__start),
		.in_curr_decoded_instr(__curr_decoded_instr),
		.in_true_ra_data(__true_ra_data),
		.in_any_dsrc0_data(__dsrc0_data_to_use),
		.in_any_dsrc1_data(__dsrc1_data_to_use),
		.in_mask(__mask_for_scalar_op),
		.in_inv_mask(__inv_mask_for_scalar_op),
		.out_ddest_data(__out_inst_use_vector_div__data),
		.out_valid(__out_inst_use_vector_div__valid));
	//assign __out_inst_use_vector_div__data = 0;
	//assign __out_inst_use_vector_div__valid = 1;

	// module Snow64PsExUseVectorBFloat16Fpu(input logic clk,
	// 	input logic in_start,
	// 	input Snow64Pipeline_DecodedInstr in_curr_decoded_instr,
	// 	input PkgSnow64PsEx::TrueLarData in_true_ra_data,
	// 	input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
	// 		in_any_dsrc0_data, in_any_dsrc1_data, in_mask, in_inv_mask,
	// 	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] out_ddest_data,
	// 	output logic out_valid);
	Snow64PsExUseVectorBFloat16Fpu __inst_use_vector_bfloat16_fpu
		(.clk(clk), .in_start(__in_inst_use_vector_bfloat16_fpu__start),
		.in_curr_decoded_instr(__curr_decoded_instr),
		.in_true_ra_data(__true_ra_data),
		.in_any_dsrc0_data(__dsrc0_data_to_use),
		.in_any_dsrc1_data(__dsrc1_data_to_use),
		.in_mask(__mask_for_scalar_op),
		.in_inv_mask(__inv_mask_for_scalar_op),
		.out_ddest_data(__out_inst_use_vector_bfloat16_fpu__data),
		.out_valid(__out_inst_use_vector_bfloat16_fpu__valid));
	//assign __out_inst_use_vector_bfloat16_fpu__data = 0;
	//assign __out_inst_use_vector_bfloat16_fpu__valid = 1;


	//always @(posedge clk)
	//begin
	//	$dis
	//end

	initial
	begin
		out_to_pipe_stage_wb = 0;
	end

	// ONLY ALU/FPU instructions can produce (__curr_results.valid == 1'b1)
	always @(*) __curr_results.valid
		= ((__from_lar_file__rd_metadata_a.tag != 0)
		&& (__curr_decoded_instr.group == 0)
		&& (__curr_decoded_instr.oper
		!= PkgSnow64InstrDecoder::SimSyscall_ThreeRegsOneSimm12)
		&& (!__stall));
	always @(*) __curr_results.base_addr
		= __true_ra_data.base_addr;

	always @(*)
	begin
		case (__multi_cycle_op_type)
		PkgSnow64PsEx::MultiCycOpTypNone:
		begin
			__curr_results.computed_data
				= __out_inst_use_vector_alu__data;
		end

		PkgSnow64PsEx::MultiCycOpTypMul:
		begin
			__curr_results.computed_data
				= __out_inst_use_vector_mul__data;
		end

		PkgSnow64PsEx::MultiCycOpTypDiv:
		begin
			__curr_results.computed_data
				= __out_inst_use_vector_div__data;
		end

		PkgSnow64PsEx::MultiCycOpTypFpu:
		begin
			__curr_results.computed_data
				= __out_inst_use_vector_bfloat16_fpu__data;
		end
		endcase
	end

	// Whenever the next state is NOT going to be StRegular, we are not
	// going to be ready to accept a new instruction on the next cycle.
	always @(*) out_to_pipe_stage_if_id.stall = __stall;

	always @(*)
	begin
		case (__curr_decoded_instr.oper)
		PkgSnow64InstrDecoder::Btru_OneRegOneSimm20:
		begin
			out_to_pipe_stage_if_id.computed_pc
				= (__curr_ddest_scalar_data != 0)
				? (in_from_pipe_stage_if_id.pc_val
				+ __curr_decoded_instr.signext_imm)
				: in_from_pipe_stage_if_id.pc_val;
		end

		PkgSnow64InstrDecoder::Bfal_OneRegOneSimm20:
		begin
			out_to_pipe_stage_if_id.computed_pc
				= (__curr_ddest_scalar_data == 0)
				? (in_from_pipe_stage_if_id.pc_val
				+ __curr_decoded_instr.signext_imm)
				: in_from_pipe_stage_if_id.pc_val;
		end

		default:
		begin
			out_to_pipe_stage_if_id.computed_pc = __curr_ddest_scalar_data;
		end
		endcase
	end

	// Compute __next_state
	always @(*)
	begin
		case (__state)
		PkgSnow64PsEx::StRegular:
		begin
			case (__curr_decoded_instr.group)
				0:
				begin
					case (__need_any_cast)
					1'b0:
					begin
						//__next_state = (__multi_cycle_op_type
						//	== PkgSnow64PsEx::MultiCycOpTypNone)
						//	? PkgSnow64PsEx::StRegular
						//	: PkgSnow64PsEx::StUseUncastedDataMultiCycle;
						__next_state = (__multi_cycle_op_type
							== PkgSnow64PsEx::MultiCycOpTypNone)
							? PkgSnow64PsEx::StRegular
							: PkgSnow64PsEx::StWaitForMultiCycleOp;
					end

					1'b1:
					begin
						__next_state = (__curr_decoded_instr.op_type
							== PkgSnow64InstrDecoder::OpTypeScalar)
							? PkgSnow64PsEx::StWaitForScalarCaster
							: PkgSnow64PsEx::StWaitForVectorCaster;
					end
					endcase
				end

				default:
				begin
					__next_state = PkgSnow64PsEx::StRegular;
				end
			endcase
		end

		PkgSnow64PsEx::StWaitForScalarCaster:
		begin
			__next_state = __out_inst_cast_scalars__valid
				? PkgSnow64PsEx::StInjectCastedScalars
				: PkgSnow64PsEx::StWaitForScalarCaster;
		end

		PkgSnow64PsEx::StWaitForVectorCaster:
		begin
			case (__out_inst_cast_vectors__valid)
			1'b0:
			begin
				__next_state = PkgSnow64PsEx::StWaitForVectorCaster;
			end

			1'b1:
			begin
				__next_state
					= (__multi_cycle_op_type
					== PkgSnow64PsEx::MultiCycOpTypNone)
					? PkgSnow64PsEx::StUseCastedDataSingleCycle
					: PkgSnow64PsEx::StUseCastedDataMultiCycle;
			end
			endcase
		end

		PkgSnow64PsEx::StInjectCastedScalars:
		begin
			__next_state
				= (__multi_cycle_op_type
				== PkgSnow64PsEx::MultiCycOpTypNone)
				? PkgSnow64PsEx::StUseCastedDataSingleCycle
				: PkgSnow64PsEx::StUseCastedDataMultiCycle;
		end

		PkgSnow64PsEx::StUseCastedDataSingleCycle:
		begin
			__next_state = PkgSnow64PsEx::StRegular;
		end

		PkgSnow64PsEx::StUseCastedDataMultiCycle:
		begin
			__next_state = PkgSnow64PsEx::StWaitForMultiCycleOp;
		end

		PkgSnow64PsEx::StWaitForMultiCycleOp:
		begin
			// Since there can only be one of these active at once, it's
			// fine to just do the ORing of the "valid" signals.
			__next_state = __any_multi_cycle_op_out_valid
				? PkgSnow64PsEx::StRegular
				: PkgSnow64PsEx::StWaitForMultiCycleOp;
		end

		PkgSnow64PsEx::StBad:
		begin
			// Eek!
			__next_state = PkgSnow64PsEx::StBad;
		end
		endcase
	end

	always @(posedge clk)
	begin
		//$display("EX:  %h, %h:  %h:  %h, %h, %h:  %h",
		//	__state, __next_state,
		//	__curr_decoded_instr.group,
		//	__true_ra_data.data,
		//	__true_rb_data.data,
		//	__true_rc_data.data,
		//	out_to_pipe_stage_wb.ldst_addr);
		//$display("EX:  %h, %h, %h",
		//	(__true_ra_data.data != 0),
		//	(__true_rb_data.data != 0),
		//	(__true_rc_data.data != 0));

		out_to_pipe_stage_wb.ldst_addr
			<= {__true_rb_data.base_addr, __true_rb_data.data_offset}
			+ __curr_dsrc1_scalar_data
			+ __curr_decoded_instr.signext_imm;
		out_to_pipe_stage_wb.computed_data <= __curr_results.data;

		case (__next_state)
		PkgSnow64PsEx::StRegular:
		begin
			out_to_pipe_stage_wb.decoded_instr <= __curr_decoded_instr;
		end

		default:
		begin
			// bubble
			out_to_pipe_stage_wb.decoded_instr <= 0;
		end
		endcase

		__state <= __next_state;
	end

endmodule
