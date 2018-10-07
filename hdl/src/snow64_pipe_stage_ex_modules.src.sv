`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"
`include "src/snow64_pipe_stage_structs.header.sv"


`define WIDTH__SNOW64_PIPE_STAGE_EX_STATE 3
`define MSB_POS__SNOW64_PIPE_STAGE_EX_STATE \
	`WIDTH2MP(`WIDTH__SNOW64_PIPE_STAGE_EX_STATE)

`define WIDTH__SNOW64_PIPE_STAGE_EX_NEEDED_CAST_TYPE 2
`define MSB_POS__SNOW64_PIPE_STAGE_EX_NEEDED_CAST_TYPE \
	`WIDTH2MP(`WIDTH__SNOW64_PIPE_STAGE_EX_NEEDED_CAST_TYPE)

package PkgSnow64PsEx;

typedef enum logic [`MSB_POS__SNOW64_PIPE_STAGE_EX_STATE:0]
{
	StRegular,
	//StWaitForBFloat16CastFromInt,
	//StWaitForBFloat16CastToInt,
	StWaitForScalarCaster,
	StWaitForVectorCaster,
	StInjectCastedScalarsAndRotate,

	StUseCastedScalars,
	StUseCastedVectors,
	StWaitForMultiCycleIntegerSubmodule,
	StWaitForBFloat16VectorFpu
} State;

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
	NeededCastTypIntToInt,
	NeededCastTypIntToBFloat16,
	NeededCastTypBFloat16ToInt,
	NeededCastTypNone
} NeededCastType;

endpackage : PkgSnow64PsEx

module Snow64PsExOperandForwarder(input logic clk,
	input PortIn_Snow64PipeStageEx_FromCtrlUnit in_from_ctrl_unit,
	input PkgSnow64PsEx::Results in_curr_results,
	output Snow64Pipeline_LarFileReadMetadata
		out_from_lar_file__rd_metadata_a, out_from_lar_file__rd_metadata_b,
		out_from_lar_file__rd_metadata_c,
	output Snow64Pipeline_LarFileReadShareddata
		out_from_lar_file__rd_shareddata_a,
		out_from_lar_file__rd_shareddata_b,
		out_from_lar_file__rd_shareddata_c,
	output PkgSnow64PsEx::TrueLarData
		out_true_ra_data, out_true_rb_data, out_true_rc_data);


	localparam __WIDTH__OPERAND_FORWARDING_CHECK = 3;
	localparam __MSB_POS__OPERAND_FORWARDING_CHECK
		= `WIDTH2MP(__WIDTH__OPERAND_FORWARDING_CHECK);


	assign {out_from_lar_file__rd_metadata_a,
		out_from_lar_file__rd_metadata_b,
		out_from_lar_file__rd_metadata_c,
		out_from_lar_file__rd_shareddata_a,
		out_from_lar_file__rd_shareddata_b,
		out_from_lar_file__rd_shareddata_c}
		= in_from_ctrl_unit;


	wire [__MSB_POS__OPERAND_FORWARDING_CHECK:0]
		__operand_forwarding_check__ra, __operand_forwarding_check__rb,
		__operand_forwarding_check__rc;

	assign __operand_forwarding_check__ra
		= {(__past_results_0.valid && (__past_results_0.base_addr
		== out_from_lar_file__rd_shareddata_a.base_addr)),
		(__past_results_1.valid && (__past_results_1.base_addr
		== out_from_lar_file__rd_shareddata_a.base_addr)),
		(__past_results_2.valid && (__past_results_2.base_addr
		== out_from_lar_file__rd_shareddata_a.base_addr))};
	assign __operand_forwarding_check__rb
		= {(__past_results_0.valid && (__past_results_0.base_addr
		== out_from_lar_file__rd_shareddata_b.base_addr)),
		(__past_results_1.valid && (__past_results_1.base_addr
		== out_from_lar_file__rd_shareddata_b.base_addr)),
		(__past_results_2.valid && (__past_results_2.base_addr
		== out_from_lar_file__rd_shareddata_b.base_addr))};
	assign __operand_forwarding_check__rc
		= {(__past_results_0.valid && (__past_results_0.base_addr
		== out_from_lar_file__rd_shareddata_c.base_addr)),
		(__past_results_1.valid && (__past_results_1.base_addr
		== out_from_lar_file__rd_shareddata_c.base_addr)),
		(__past_results_2.valid && (__past_results_2.base_addr
		== out_from_lar_file__rd_shareddata_c.base_addr))};


	PkgSnow64PsEx::Results
		__past_results_0, __past_results_1, __past_results_2;



	`define PERF_OPERAND_FORWARDING(which_reg) \
	always @(*) \
	begin \
		case (__operand_forwarding_check__r``which_reg) \
		3'b111: {out_true_r``which_reg``_data.data, \
			out_true_r``which_reg``_data.base_addr} \
			= {__past_results_0.computed_data, \
			__past_results_0.base_addr}; \
		3'b110: {out_true_r``which_reg``_data.data, \
			out_true_r``which_reg``_data.base_addr} \
			= {__past_results_0.computed_data, \
			__past_results_0.base_addr}; \
		3'b101: {out_true_r``which_reg``_data.data, \
			out_true_r``which_reg``_data.base_addr} \
			= {__past_results_0.computed_data, \
			__past_results_0.base_addr}; \
		3'b100: {out_true_r``which_reg``_data.data, \
			out_true_r``which_reg``_data.base_addr} \
			= {__past_results_0.computed_data, \
			__past_results_0.base_addr}; \
		3'b011: {out_true_r``which_reg``_data.data, \
			out_true_r``which_reg``_data.base_addr} \
			= {__past_results_1.computed_data, \
			__past_results_1.base_addr}; \
		3'b010: {out_true_r``which_reg``_data.data, \
			out_true_r``which_reg``_data.base_addr} \
			= {__past_results_1.computed_data, \
			__past_results_1.base_addr}; \
		3'b001: {out_true_r``which_reg``_data.data, \
			out_true_r``which_reg``_data.base_addr} \
			= {__past_results_2.computed_data, \
			__past_results_2.base_addr}; \
		3'b000: {out_true_r``which_reg``_data.data, \
			out_true_r``which_reg``_data.base_addr} \
			= {out_from_lar_file__rd_shareddata_``which_reg.data, \
			out_from_lar_file__rd_shareddata_``which_reg.base_addr}; \
		endcase \
	end

	`PERF_OPERAND_FORWARDING(a)
	`PERF_OPERAND_FORWARDING(b)
	`PERF_OPERAND_FORWARDING(c)
	`undef PERF_OPERAND_FORWARDING

	`define ASSIGN_NON_FORWARDED_TRUE_REG_DATA(which_reg) \
		always @(*) out_true_r``which_reg``_data.data_offset \
			= out_from_lar_file__rd_metadata_``which_reg.data_offset; \
		always @(*) out_true_r``which_reg``_data.data_type \
			= out_from_lar_file__rd_metadata_``which_reg.data_type; \
		always @(*) out_true_r``which_reg``_data.int_type_size \
			= out_from_lar_file__rd_metadata_``which_reg.int_type_size;

	`ASSIGN_NON_FORWARDED_TRUE_REG_DATA(a)
	`ASSIGN_NON_FORWARDED_TRUE_REG_DATA(b)
	`ASSIGN_NON_FORWARDED_TRUE_REG_DATA(c)
	`undef ASSIGN_NON_FORWARDED_TRUE_REG_DATA


	initial
	begin
		{__past_results_0, __past_results_1, __past_results_2} = 0;
	end

	always_ff @(posedge clk)
	begin
		__past_results_0 <= in_curr_results;
		__past_results_1 <= __past_results_0;
		__past_results_2 <= __past_results_1;
	end

endmodule

module Snow64PsExRotateLarData
	(input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		in_any_dsrc0_data, in_any_dsrc1_data,
	input logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET:0]
		in_dsrc0_data_offset, in_dsrc1_data_offset, in_ddest_data_offset,
	input logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] in_type_size,
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
		(.in_to_rotate(in_any_dsrc0_data),
		.in_src_data_offset(in_dsrc0_data_offset),
		.in_dest_data_offset(in_ddest_data_offset),
		.out_data_8(__out_inst_dsrc0_rotate_lar_data__data_8),
		.out_data_16(__out_inst_dsrc0_rotate_lar_data__data_16),
		.out_data_32(__out_inst_dsrc0_rotate_lar_data__data_32),
		.out_data_64(__out_inst_dsrc0_rotate_lar_data__data_64));
	Snow64RotateLarData __inst_dsrc1_rotate_lar_data
		(.in_to_rotate(in_any_dsrc1_data),
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
		case (in_type_size)
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
	input logic in_start,
	input PkgSnow64PsEx::TrueLarData
		in_true_ra_data, in_true_rb_data, in_true_rc_data,
	input logic [`MSB_POS__SNOW64_SCALAR_DATA:0]
		in_uncasted_rb_scalar_data, in_uncasted_rc_scalar_data,
	output logic [`MSB_POS__SNOW64_SCALAR_DATA:0]
		out_casted_rb_scalar_data, out_casted_rc_scalar_data,
	output logic out_valid);

	enum logic
	{
		StNoWait,
		StWaitForBFloat16Caster
	} __state;


	wire [`MSB_POS__SNOW64_SCALAR_DATA:0]
		__dsrc0__uncasted_scalar_data = in_uncasted_rb_scalar_data,
		__dsrc1__uncasted_scalar_data = in_uncasted_rc_scalar_data;
	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__ddest__int_type_size = in_true_ra_data.int_type_size,
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


	logic __dsrc0_start_bfloat16_cast_from_int,
		__dsrc1_start_bfloat16_cast_from_int,
		__dsrc0_start_bfloat16_cast_to_int,
		__dsrc1_start_bfloat16_cast_to_int;

	logic [`MSB_POS__SNOW64_PIPE_STAGE_EX_NEEDED_CAST_TYPE:0]
		__dsrc0_needed_cast_type, __dsrc1_needed_cast_type;

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
		__state = StNoWait;

		{__dsrc0_start_bfloat16_cast_from_int,
			__dsrc1_start_bfloat16_cast_from_int,
			__dsrc0_start_bfloat16_cast_to_int,
			__dsrc1_start_bfloat16_cast_to_int} = 0;

		{__dsrc0_needed_cast_type, __dsrc1_needed_cast_type} = 0;

		{out_casted_rb_scalar_data, out_casted_rc_scalar_data} = 0;
		out_valid = 0;
	end


	`define SET_NEEDED_CAST_TYPE(some_true_lar_data, out) \
		case (in_true_ra_data.data_type) \
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
				out = PkgSnow64PsEx::NeededCastTypIntToInt; \
			end \
			endcase \
		end \
		endcase

	always @(*)
	begin
		`SET_NEEDED_CAST_TYPE(in_true_rb_data, __dsrc0_needed_cast_type)
	end

	always @(*)
	begin
		`SET_NEEDED_CAST_TYPE(in_true_rc_data, __dsrc1_needed_cast_type)
	end
	`undef SET_NEEDED_CAST_TYPE


	always_ff @(posedge clk)
	begin
	end



endmodule


module Snow64PsExCastVectors(input logic clk,
	input logic in_start,
	input PkgSnow64PsEx::TrueLarData
		in_true_ra_data, in_true_rb_data, in_true_rc_data,
	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		out_casted_rb_data, out_casted_rc_data,
	output wire out_valid);
endmodule




//module Snow64PsExPerfVectorOperation(input logic clk,
//	input Snow64Pipeline_DecodedInstr in_curr_decoded_instr,
//	input PkgSnow64PsEx::TrueLarData in_true_ra_data,
//	input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
//		in_any_dsrc0_data, in_any_dsrc1_data,
//	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] out_data,
//	output wire out_multi_cycle_op_valid);
//
//	// Arithmetic/logic vector units
//	PkgSnow64ArithLog::PortIn_VectorAlu __in_inst_vector_alu;
//	PkgSnow64ArithLog::PortOut_VectorAlu __out_inst_vector_alu;
//	Snow64VectorAlu __inst_vector_alu(.in(__in_inst_vector_alu),
//		.out(__out_inst_vector_alu));
//
//	PkgSnow64ArithLog::PortIn_VectorMul __in_inst_vector_mul;
//	PkgSnow64ArithLog::PortOut_VectorMul __out_inst_vector_mul;
//	Snow64VectorMul __inst_vector_mul(.clk(clk), .in(__in_inst_vector_mul),
//		.out(__out_inst_vector_mul));
//
//	PkgSnow64ArithLog::PortIn_VectorDiv __in_inst_vector_div;
//	PkgSnow64ArithLog::PortOut_VectorDiv __out_inst_vector_div;
//	Snow64VectorDiv __inst_vector_div(.clk(clk), .in(__in_inst_vector_div),
//		.out(__out_inst_vector_div));
//
//	PkgSnow64BFloat16::PortIn_VectorFpu __in_inst_vector_fpu;
//	PkgSnow64BFloat16::PortOut_VectorFpu __out_inst_vector_fpu;
//	Snow64BFloat16VectorFpu __inst_vector_fpu(.clk(clk),
//		.in(__in_inst_vector_fpu), .out(__out_inst_vector_fpu));
//
//	assign out_multi_cycle_op_valid = (__out_inst_vector_mul.valid
//		|| __out_inst_vector_div.valid || __out_inst_vector_fpu.valid);
//
//	initial
//	begin
//		__in_inst_vector_alu = 0;
//		__in_inst_vector_mul = 0;
//		__in_inst_vector_div = 0;
//		__in_inst_vector_fpu = 0;
//
//		out_data = 0;
//	end
//
//endmodule





//module Snow64PipeStageEx(input logic clk,
//	input PortIn_Snow64PipeStageEx_FromCtrlUnit in_from_ctrl_unit,
//	input PortIn_Snow64PipeStageEx_FromPipeStageIfId
//		in_from_pipe_stage_if_id,
//	output PortOut_Snow64PipeStageEx_ToPipeStageIfId
//		out_to_pipe_stage_if_id,
//	output PortOut_Snow64PipeStageEx_ToPipeStageWb out_to_pipe_stage_wb);
//
//
//
//
//
//	logic [`MSB_POS__SNOW64_PIPE_STAGE_EX_STATE:0] __state, __next_state;
//
//	logic __dsrc0_needs_casted, __dsrc1_needs_casted;
//
//	//logic __stall;
//	wire __stall = (__next_state != PkgSnow64PsEx::StRegular);
//
//	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] __size_of_casted_scalars;
//	logic __use_vector_fpu;
//
//	// Stuff for operand forwarding
//	PkgSnow64PsEx::TrueLarData
//		__true_ra_data, __true_rb_data, __true_rc_data;
//	PkgSnow64PsEx::Results __curr_results;
//
//	Snow64PsExOperandForwarder __inst_operand_forwarder(.clk(clk),
//		.in_from_ctrl_unit(in_from_ctrl_unit),
//		.in_curr_results(__curr_results),
//		.out_true_ra_data(__true_ra_data),
//		.out_true_rb_data(__true_rb_data),
//		.out_true_rc_data(__true_rc_data));
//
//
//
//	Snow64Pipeline_DecodedInstr __curr_decoded_instr;
//	assign __curr_decoded_instr = in_from_pipe_stage_if_id.decoded_instr;
//
//
//
//
//
//	// Scalar data extractors
//	PkgSnow64ScalarDataExtractOrInject::PortIn_ScalarDataExtractor
//		__in_inst_ddest_scalar_data_extractor,
//		__in_inst_dsrc0_scalar_data_extractor,
//		__in_inst_dsrc1_scalar_data_extractor;
//	PkgSnow64ScalarDataExtractOrInject::PortOut_ScalarDataExtractor
//		__out_inst_ddest_scalar_data_extractor,
//		__out_inst_dsrc0_scalar_data_extractor,
//		__out_inst_dsrc1_scalar_data_extractor;
//	Snow64ScalarDataExtractor __inst_ddest_scalar_data_extractor
//		(.in(__in_inst_ddest_scalar_data_extractor),
//		.out(__out_inst_ddest_scalar_data_extractor));
//	Snow64ScalarDataExtractor __inst_dsrc0_scalar_data_extractor
//		(.in(__in_inst_dsrc0_scalar_data_extractor),
//		.out(__out_inst_dsrc0_scalar_data_extractor));
//	Snow64ScalarDataExtractor __inst_dsrc1_scalar_data_extractor
//		(.in(__in_inst_dsrc1_scalar_data_extractor),
//		.out(__out_inst_dsrc1_scalar_data_extractor));
//
//	// Scalar data injectors
//	PkgSnow64ScalarDataExtractOrInject::PortIn_ScalarDataInjector
//		__in_inst_dsrc0_scalar_data_injector,
//		__in_inst_dsrc1_scalar_data_injector;
//	PkgSnow64ScalarDataExtractOrInject::PortOut_ScalarDataInjector
//		__out_inst_dsrc0_scalar_data_injector,
//		__out_inst_dsrc1_scalar_data_injector;
//	Snow64ScalarDataInjector __inst_dsrc0_scalar_data_injector
//		(.in(__in_inst_dsrc0_scalar_data_injector),
//		.out(__out_inst_dsrc0_scalar_data_injector));
//
//	// Casters
//	PkgSnow64Caster::PortIn_IntScalarCaster
//		__in_inst_dsrc0_int_scalar_caster,
//		__in_inst_dsrc1_int_scalar_caster;
//	PkgSnow64Caster::PortOut_IntScalarCaster
//		__out_inst_dsrc0_int_scalar_caster,
//		__out_inst_dsrc1_int_scalar_caster;
//	Snow64IntScalarCaster __inst_dsrc0_int_scalar_caster(.clk(clk),
//		.in(__in_inst_dsrc0_int_scalar_caster),
//		.out(__out_inst_dsrc0_int_scalar_caster));
//	Snow64IntScalarCaster __inst_dsrc1_int_scalar_caster(.clk(clk),
//		.in(__in_inst_dsrc1_int_scalar_caster),
//		.out(__out_inst_dsrc1_int_scalar_caster));
//
//	PkgSnow64Caster::PortIn_IntVectorCaster
//		__in_inst_dsrc0_int_vector_caster,
//		__in_inst_dsrc1_int_vector_caster;
//	PkgSnow64Caster::PortOut_IntVectorCaster
//		__out_inst_dsrc0_int_vector_caster,
//		__out_inst_dsrc1_int_vector_caster;
//	Snow64IntVectorCaster __inst_dsrc0_int_vector_caster(.clk(clk),
//		.in(__in_inst_dsrc0_int_vector_caster),
//		.out(__out_inst_dsrc0_int_vector_caster));
//	Snow64IntVectorCaster __inst_dsrc1_int_vector_caster(.clk(clk),
//		.in(__in_inst_dsrc1_int_vector_caster),
//		.out(__out_inst_dsrc1_int_vector_caster));
//
//	PkgSnow64BFloat16::PortIn_CastFromInt
//		__in_inst_dsrc0_bfloat16_cast_from_int,
//		__in_inst_dsrc1_bfloat16_cast_from_int;
//	PkgSnow64BFloat16::PortOut_CastFromInt
//		__out_inst_dsrc0_bfloat16_cast_from_int,
//		__out_inst_dsrc1_bfloat16_cast_from_int;
//	Snow64BFloat16CastFromInt __inst_dsrc0_bfloat16_cast_from_int
//		(.clk(clk), .in(__in_inst_dsrc0_bfloat16_cast_from_int),
//		.out(__out_inst_dsrc0_bfloat16_cast_from_int));
//	Snow64BFloat16CastFromInt __inst_dsrc1_bfloat16_cast_from_int
//		(.clk(clk), .in(__in_inst_dsrc1_bfloat16_cast_from_int),
//		.out(__out_inst_dsrc1_bfloat16_cast_from_int));
//
//	PkgSnow64BFloat16::PortIn_CastToInt
//		__in_inst_dsrc0_bfloat16_cast_to_int,
//		__in_inst_dsrc1_bfloat16_cast_to_int;
//	PkgSnow64BFloat16::PortOut_CastToInt
//		__out_inst_dsrc0_bfloat16_cast_to_int,
//		__out_inst_dsrc1_bfloat16_cast_to_int;
//	Snow64BFloat16CastToInt __inst_dsrc0_bfloat16_cast_to_int
//		(.clk(clk), .in(__in_inst_dsrc0_bfloat16_cast_to_int),
//		.out(__out_inst_dsrc0_bfloat16_cast_to_int));
//	Snow64BFloat16CastToInt __inst_dsrc1_bfloat16_cast_to_int
//		(.clk(clk), .in(__in_inst_dsrc1_bfloat16_cast_to_int),
//		.out(__out_inst_dsrc1_bfloat16_cast_to_int));
//
//	PkgSnow64Caster::PortIn_ToOrFromBFloat16VectorCaster
//		__in_inst_dsrc0_tof_bfloat16_vector_caster,
//		__in_inst_dsrc1_tof_bfloat16_vector_caster;
//	PkgSnow64Caster::PortOut_ToOrFromBFloat16VectorCaster
//		__out_inst_dsrc0_tof_bfloat16_vector_caster,
//		__out_inst_dsrc1_tof_bfloat16_vector_caster;
//	Snow64ToOrFromBFloat16VectorCaster
//		__inst_dsrc0_tof_bfloat16_vector_caster(.clk(clk),
//		.in(__in_inst_dsrc0_tof_bfloat16_vector_caster),
//		.out(__out_inst_dsrc0_tof_bfloat16_vector_caster));
//	Snow64ToOrFromBFloat16VectorCaster
//		__inst_dsrc1_tof_bfloat16_vector_caster(.clk(clk),
//		.in(__in_inst_dsrc1_tof_bfloat16_vector_caster),
//		.out(__out_inst_dsrc1_tof_bfloat16_vector_caster));
//
//	//logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
//	//	__in_inst_dsrc0_rotate__to_rotate,
//	//	__in_inst_dsrc1_rotate__to_rotate;
//	//logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
//	//	__in_inst_any_dsrc_rotate__type_size;
//	//wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
//	//	__out_inst_dsrc0_rotate__data, __out_inst_dsrc1_rotate__data,
//	//	__out_inst_dsrc0_rotate__mask, __out_inst_dsrc1_rotate__mask,
//	//	__out_inst_dsrc0_rotate__inv_mask,
//	//	__out_inst_dsrc1_rotate__inv_mask;
//	//Snow64RotateLarData __inst_dsrc0_rotate
//	//	(.in_to_rotate(__in_inst_dsrc0_rotate__to_rotate),
//	//	.in_src_data_offset(__from_lar_file__rd_metadata_b.data_offset),
//	//	.in_dest_data_offset(__from_lar_file__rd_metadata_a.data_offset),
//	//	.in_type_size(__in_inst_any_dsrc_rotate__type_size),
//	//	.out_data(__out_inst_dsrc0_rotate__data),
//	//	.out_mask(__out_inst_dsrc0_rotate__mask),
//	//	.out_inv_mask(__out_inst_dsrc0_rotate__inv_mask));
//	//Snow64RotateLarData __inst_dsrc1_rotate
//	//	(.in_to_rotate(__in_inst_dsrc1_rotate__to_rotate),
//	//	.in_src_data_offset(__from_lar_file__rd_metadata_c.data_offset),
//	//	.in_dest_data_offset(__from_lar_file__rd_metadata_a.data_offset),
//	//	.in_type_size(__in_inst_any_dsrc_rotate__type_size),
//	//	.out_data(__out_inst_dsrc1_rotate__data),
//	//	.out_mask(__out_inst_dsrc1_rotate__mask),
//	//	.out_inv_mask(__out_inst_dsrc1_rotate__inv_mask));
//
//
//	//always @(*)
//	//begin
//	//	case (__next_state)
//	//	StRegular:
//	//	begin
//	//		{__in_inst_dsrc0_rotate__to_rotate,
//	//			__in_inst_dsrc1_rotate__to_rotate}
//	//			= {__true_rb_data.data, __true_rc_data.data};
//	//	end
//
//	//	StWaitForBFloat16CastFromInt:
//	//	begin
//	//	end
//
//	//	StWaitForBFloat16CastToInt:
//	//	begin
//	//	end
//	//	endcase
//	//end
//
//	//always @(*)
//	//begin
//	//	case (__from_lar_file__rd_metadata_a.data_type)
//	//	PkgSnow64Cpu::DataTypBFloat16:
//	//	begin
//	//		__in_inst_any_dsrc_rotate__type_size
//	//			= PkgSnow64Cpu::IntTypSz16;
//	//	end
//
//	//	// We don't care about PkgSnow64Cpu::DataTypReserved
//	//	default:
//	//	begin
//	//		__in_inst_any_dsrc_rotate__type_size
//	//			= __from_lar_file__rd_metadata_c.int_type_size;
//	//	end
//	//	endcase
//	//end
//
//
//
//	`define ASSIGN_TO_SCALAR_DATA_EXTRACTOR_INPUTS(which_r, which_e) \
//		always @(*) \
//			__in_inst_``which_e``_scalar_data_extractor.to_shift \
//			= __true_r``which_r``_data.data; \
//		always @(*) \
//			__in_inst_``which_e``_scalar_data_extractor.data_type \
//			= __true_r``which_r``_data.data_type; \
//		always @(*) \
//			__in_inst_``which_e``_scalar_data_extractor.int_type_size \
//			= __true_r``which_r``_data.int_type_size; \
//		always @(*) \
//			__in_inst_``which_e``_scalar_data_extractor.data_offset \
//			= __true_r``which_r``_data.data_offset;
//
//	`ASSIGN_TO_SCALAR_DATA_EXTRACTOR_INPUTS(a, ddest)
//	`ASSIGN_TO_SCALAR_DATA_EXTRACTOR_INPUTS(b, dsrc0)
//	`ASSIGN_TO_SCALAR_DATA_EXTRACTOR_INPUTS(c, dsrc1)
//	`undef ASSIGN_TO_SCALAR_DATA_EXTRACTOR_INPUTS
//
//
//
//
//	// ONLY ALU/FPU instructions can produce (__curr_results.valid == 1'b1)
//	//always @(*) __curr_results.valid
//	//	= ((__from_lar_file__rd_metadata_a.tag != 0)
//	//	&& (__curr_decoded_instr.group == 0)
//	//	&& (__next_state == StRegular));
//	always @(*) __curr_results.valid
//		= ((__from_lar_file__rd_metadata_a.tag != 0)
//		&& (__curr_decoded_instr.group == 0)
//		&& (!__stall));
//	always @(*) __curr_results.base_addr
//		= __from_lar_file__rd_shareddata_a.base_addr;
//
//
//	//// Drive __curr_results.data
//	//always @(*)
//	//begin
//	//	case (__state)
//	//	PkgSnow64PsEx::StRegular:
//	//	begin
//	//		case (__curr_decoded_instr.op_type)
//	//		PkgSnow64InstrDecoder::OpTypeScalar:
//	//		begin
//	//			__curr_results.computed_data
//	//				= (__from_lar_file__rd_shareddata_a.data
//	//				& __out_inst_dsrc0_rotate__inv_mask)
//	//				| (__out_inst_vector_alu.data
//	//				& __out_inst_dsrc0_rotate__mask);
//	//		end
//
//	//		PkgSnow64InstrDecoder::OpTypeVector:
//	//		begin
//	//			__curr_results.computed_data = __out_inst_vector_alu.data;
//	//		end
//	//		endcase
//	//	end
//
//	//	// Temporary!
//	//	default:
//	//	begin
//	//		__curr_results.computed_data = 0;
//	//	end
//	//	endcase
//	//end
//
//
//
//
//
//	// Whenever the next state is NOT going to be StRegular, we are not
//	// going to be ready to accept a new instruction on the next cycle.
//	//always @(*) out_to_pipe_stage_if_id.stall
//	//	= (__next_state != StRegular);
//	always @(*) out_to_pipe_stage_if_id.stall = __stall;
//
//
//	always @(*)
//	begin
//		case (__curr_decoded_instr.oper)
//		PkgSnow64InstrDecoder::Btru_OneRegOneSimm20:
//		begin
//			out_to_pipe_stage_if_id.computed_pc
//				= (__out_inst_ddest_scalar_data_extractor.data != 0)
//				? (in_from_pipe_stage_if_id.pc_val
//				+ __curr_decoded_instr.signext_imm)
//				: in_from_pipe_stage_if_id.pc_val;
//		end
//
//		PkgSnow64InstrDecoder::Bfal_OneRegOneSimm20:
//		begin
//			out_to_pipe_stage_if_id.computed_pc
//				= (__out_inst_ddest_scalar_data_extractor.data == 0)
//				? (in_from_pipe_stage_if_id.pc_val
//				+ __curr_decoded_instr.signext_imm)
//				: in_from_pipe_stage_if_id.pc_val;
//		end
//
//		//PkgSnow64InstrDecoder::Jmp_OneReg:
//		default:
//		begin
//			out_to_pipe_stage_if_id.computed_pc
//				= __out_inst_ddest_scalar_data_extractor.data;
//		end
//
//		//default:
//		//begin
//		//	out_to_pipe_stage_if_id.computed_pc = 0;
//		//end
//		endcase
//	end
//
//
//
//	initial
//	begin
//		out_to_pipe_stage_if_id = 0;
//		out_to_pipe_stage_wb = 0;
//
//		__state = PkgSnow64PsEx::StRegular;
//		__next_state = PkgSnow64PsEx::StRegular;
//
//		{__dsrc0_needs_casted, __dsrc1_needs_casted} = 0;
//		__size_of_casted_scalars = 0;
//		__use_vector_fpu = 0;
//
//
//		{__in_inst_ddest_scalar_data_extractor,
//			__in_inst_dsrc0_scalar_data_extractor,
//			__in_inst_dsrc1_scalar_data_extractor} = 0;
//		//__in_inst_ddest_scalar_data_injector = 0;
//		{__in_inst_dsrc0_scalar_data_injector,
//			__in_inst_dsrc1_scalar_data_injector} = 0;
//
//		{__in_inst_dsrc0_int_scalar_caster,
//			__in_inst_dsrc1_int_scalar_caster} = 0;
//		{__in_inst_dsrc0_int_vector_caster,
//			__in_inst_dsrc1_int_vector_caster} = 0;
//
//		{__in_inst_dsrc0_bfloat16_cast_from_int,
//			__in_inst_dsrc1_bfloat16_cast_from_int} = 0;
//		{__in_inst_dsrc0_bfloat16_cast_to_int,
//			__in_inst_dsrc1_bfloat16_cast_to_int} = 0;
//		{__in_inst_dsrc0_tof_bfloat16_vector_caster,
//			__in_inst_dsrc1_tof_bfloat16_vector_caster} = 0;
//
//		__curr_results = 0;
//	end
//
//
//
//
//	// Compute __next_state
//	//always @(*)
//	//begin
//	//	case (__state)
//	//	StRegular:
//	//	begin
//	//	end
//
//	//	StWaitForBFloat16CastFromInt:
//	//	begin
//	//	end
//
//	//	StWaitForBFloat16CastToInt:
//	//	begin
//	//	end
//
//	//	StInjectCastedScalarsAndRotate:
//	//	begin
//	//	end
//
//	//	StUseCastedScalars:
//	//	begin
//	//	end
//
//	//	StUseCastedVectors:
//	//	begin
//	//	end
//
//	//	StWaitForMultiCycleIntegerSubmodule:
//	//	begin
//	//	end
//
//	//	StWaitForBFloat16VectorFpu:
//	//	begin
//	//		__next_state = __out_inst_vector_fpu.valid
//	//			? StWaitForBFloat16VectorFpu : StRegular;
//	//	end
//	//	endcase
//	//end
//
//
//	// Send __next_state 
//	always_ff @(posedge clk)
//	begin
//		__state <= __next_state;
//	end
//
//
//endmodule
