`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"
`include "src/snow64_pipe_stage_structs.header.sv"

module Snow64RotateLarData
	(input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] in_to_rotate,
	input logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET:0]
		in_amount, in_ddest_data_offset,
	input logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] in_type_size,
	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] out_data, out_mask);


	localparam __MSB_POS__DATA = `MSB_POS__SNOW64_LAR_FILE_DATA;

	localparam __MSB_POS__DATA_OFFSET
		= `MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET;

	localparam __LSB_POS__DATA_OFFSET_8 = 0;
	localparam __LSB_POS__DATA_OFFSET_16 = 1;
	localparam __LSB_POS__DATA_OFFSET_32 = 2;
	localparam __LSB_POS__DATA_OFFSET_64 = 3;



	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__rotated_data_8, __rotated_data_16,
		__rotated_data_32, __rotated_data_64,
		__mask_8, __mask_16, __mask_32, __mask_64;

	always @(*)
	begin
		case (in_type_size)
		PkgSnow64Cpu::IntTypSz8:
			{out_data, out_mask} = {__rotated_data_8, __mask_8};
		PkgSnow64Cpu::IntTypSz16:
			{out_data, out_mask} = {__rotated_data_16, __mask_16};
		PkgSnow64Cpu::IntTypSz32:
			{out_data, out_mask} = {__rotated_data_32, __mask_32};
		PkgSnow64Cpu::IntTypSz64:
			{out_data, out_mask} = {__rotated_data_64, __mask_64};
		endcase
	end


	`define PERF_ROTATE(width, num) \
		num: __rotated_data_``width \
			= {in_to_rotate[`WIDTH2MP(256 - (num * width)):0], \
			in_to_rotate[`WIDTH2MP(256):(256 - (num * width))]}

	// Rotate left
	always @(*)
	begin
		case (in_amount[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_8])
		0: __rotated_data_8 = in_to_rotate;
		`PERF_ROTATE(8, 1);
		`PERF_ROTATE(8, 2);
		`PERF_ROTATE(8, 3);
		`PERF_ROTATE(8, 4);
		`PERF_ROTATE(8, 5);
		`PERF_ROTATE(8, 6);
		`PERF_ROTATE(8, 7);
		`PERF_ROTATE(8, 8);
		`PERF_ROTATE(8, 9);
		`PERF_ROTATE(8, 10);
		`PERF_ROTATE(8, 11);
		`PERF_ROTATE(8, 12);
		`PERF_ROTATE(8, 13);
		`PERF_ROTATE(8, 14);
		`PERF_ROTATE(8, 15);
		`PERF_ROTATE(8, 16);
		`PERF_ROTATE(8, 17);
		`PERF_ROTATE(8, 18);
		`PERF_ROTATE(8, 19);
		`PERF_ROTATE(8, 20);
		`PERF_ROTATE(8, 21);
		`PERF_ROTATE(8, 22);
		`PERF_ROTATE(8, 23);
		`PERF_ROTATE(8, 24);
		`PERF_ROTATE(8, 25);
		`PERF_ROTATE(8, 26);
		`PERF_ROTATE(8, 27);
		`PERF_ROTATE(8, 28);
		`PERF_ROTATE(8, 29);
		`PERF_ROTATE(8, 30);
		`PERF_ROTATE(8, 31);
		endcase
	end

	always @(*)
	begin
		case (in_amount[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_16])
		0: __rotated_data_16 = in_to_rotate;
		`PERF_ROTATE(16, 1);
		`PERF_ROTATE(16, 2);
		`PERF_ROTATE(16, 3);
		`PERF_ROTATE(16, 4);
		`PERF_ROTATE(16, 5);
		`PERF_ROTATE(16, 6);
		`PERF_ROTATE(16, 7);
		`PERF_ROTATE(16, 8);
		`PERF_ROTATE(16, 9);
		`PERF_ROTATE(16, 10);
		`PERF_ROTATE(16, 11);
		`PERF_ROTATE(16, 12);
		`PERF_ROTATE(16, 13);
		`PERF_ROTATE(16, 14);
		`PERF_ROTATE(16, 15);
		endcase
	end

	always @(*)
	begin
		case (in_amount[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_32])
		0: __rotated_data_32 = in_to_rotate;
		`PERF_ROTATE(32, 1);
		`PERF_ROTATE(32, 2);
		`PERF_ROTATE(32, 3);
		`PERF_ROTATE(32, 4);
		`PERF_ROTATE(32, 5);
		`PERF_ROTATE(32, 6);
		`PERF_ROTATE(32, 7);
		endcase
	end

	always @(*)
	begin
		case (in_amount[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_64])
		0: __rotated_data_64 = in_to_rotate;
		`PERF_ROTATE(64, 1);
		`PERF_ROTATE(64, 2);
		`PERF_ROTATE(64, 3);
		endcase
	end
	`undef PERF_ROTATE



	`define MASK_8(x) (256'hff << (x * 8))
	`define MASK_16(x) (256'hffff << (x * 16))
	`define MASK_32(x) (256'hffff_ffff << (x * 32))
	`define MASK_64(x) (256'hffff_ffff_ffff_ffff << (x * 64))

	`define PERF_MASK(width, num) \
		num: __mask_``width = `MASK_``width(num)

	always @(*)
	begin
		case (in_ddest_data_offset
			[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_8])
		`PERF_MASK(8, 0);
		`PERF_MASK(8, 1);
		`PERF_MASK(8, 2);
		`PERF_MASK(8, 3);
		`PERF_MASK(8, 4);
		`PERF_MASK(8, 5);
		`PERF_MASK(8, 6);
		`PERF_MASK(8, 7);
		`PERF_MASK(8, 8);
		`PERF_MASK(8, 9);
		`PERF_MASK(8, 10);
		`PERF_MASK(8, 11);
		`PERF_MASK(8, 12);
		`PERF_MASK(8, 13);
		`PERF_MASK(8, 14);
		`PERF_MASK(8, 15);
		`PERF_MASK(8, 16);
		`PERF_MASK(8, 17);
		`PERF_MASK(8, 18);
		`PERF_MASK(8, 19);
		`PERF_MASK(8, 20);
		`PERF_MASK(8, 21);
		`PERF_MASK(8, 22);
		`PERF_MASK(8, 23);
		`PERF_MASK(8, 24);
		`PERF_MASK(8, 25);
		`PERF_MASK(8, 26);
		`PERF_MASK(8, 27);
		`PERF_MASK(8, 28);
		`PERF_MASK(8, 29);
		`PERF_MASK(8, 30);
		`PERF_MASK(8, 31);
		endcase
	end

	always @(*)
	begin
		case (in_ddest_data_offset
			[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_16])
		`PERF_MASK(16, 0);
		`PERF_MASK(16, 1);
		`PERF_MASK(16, 2);
		`PERF_MASK(16, 3);
		`PERF_MASK(16, 4);
		`PERF_MASK(16, 5);
		`PERF_MASK(16, 6);
		`PERF_MASK(16, 7);
		`PERF_MASK(16, 8);
		`PERF_MASK(16, 9);
		`PERF_MASK(16, 10);
		`PERF_MASK(16, 11);
		`PERF_MASK(16, 12);
		`PERF_MASK(16, 13);
		`PERF_MASK(16, 14);
		`PERF_MASK(16, 15);
		endcase
	end

	always @(*)
	begin
		case (in_ddest_data_offset
			[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_32])
		`PERF_MASK(32, 0);
		`PERF_MASK(32, 1);
		`PERF_MASK(32, 2);
		`PERF_MASK(32, 3);
		`PERF_MASK(32, 4);
		`PERF_MASK(32, 5);
		`PERF_MASK(32, 6);
		`PERF_MASK(32, 7);
		endcase
	end

	always @(*)
	begin
		case (in_ddest_data_offset
			[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_64])
		`PERF_MASK(64, 0);
		`PERF_MASK(64, 1);
		`PERF_MASK(64, 2);
		`PERF_MASK(64, 3);
		endcase
	end

	`undef MASK_8
	`undef MASK_16
	`undef MASK_32
	`undef MASK_64

endmodule


module Snow64PipeStageEx(input logic clk,
	input PortIn_Snow64PipeStageEx_FromCtrlUnit in_from_ctrl_unit,
	input PortIn_Snow64PipeStageEx_FromPipeStageIfId
		in_from_pipe_stage_if_id,
	output PortOut_Snow64PipeStageEx_ToPipeStageIfId
		out_to_pipe_stage_if_id,
	output PortOut_Snow64PipeStageEx_ToPipeStageWb out_to_pipe_stage_wb);


	localparam __NUM_BYTES__INSTR = `WIDTH__SNOW64_INSTR / 8;

	localparam __WIDTH__OPERAND_FORWARDING_CHECK = 3;
	localparam __MSB_POS__OPERAND_FORWARDING_CHECK
		= `WIDTH2MP(__WIDTH__OPERAND_FORWARDING_CHECK);


	localparam __WIDTH__STATE = 2;
	localparam __MSB_POS__STATE = `WIDTH2MP(__WIDTH__STATE);

	typedef enum logic [__MSB_POS__STATE:0]
	{
		StRegular,
		StUseCastedResults,
		StWaitForSubmodule,
		StBad
	} State;
	
	logic [__MSB_POS__STATE:0] __state, __next_state;


	Snow64Pipeline_LarFileReadMetadata
		__from_lar_file__rd_metadata_a, __from_lar_file__rd_metadata_b,
		__from_lar_file__rd_metadata_c;
	Snow64Pipeline_LarFileReadShareddata
		__from_lar_file__rd_shareddata_a, __from_lar_file__rd_shareddata_b,
		__from_lar_file__rd_shareddata_c;
	assign {__from_lar_file__rd_metadata_a, __from_lar_file__rd_metadata_b,
		__from_lar_file__rd_metadata_c, __from_lar_file__rd_shareddata_a,
		__from_lar_file__rd_shareddata_b, __from_lar_file__rd_shareddata_c}
		= in_from_ctrl_unit;

	Snow64Pipeline_DecodedInstr __curr_decoded_instr;
	assign __curr_decoded_instr = in_from_pipe_stage_if_id.decoded_instr;



	// Arithmetic/logic vector units
	PkgSnow64ArithLog::PortIn_VectorAlu __in_inst_vector_alu;
	PkgSnow64ArithLog::PortOut_VectorAlu __out_inst_vector_alu;
	Snow64VectorAlu __inst_vector_alu(.in(__in_inst_vector_alu),
		.out(__out_inst_vector_alu));

	PkgSnow64ArithLog::PortIn_VectorMul __in_inst_vector_mul;
	PkgSnow64ArithLog::PortOut_VectorMul __out_inst_vector_mul;
	Snow64VectorMul __inst_vector_mul(.clk(clk), .in(__in_inst_vector_mul),
		.out(__out_inst_vector_mul));

	PkgSnow64ArithLog::PortIn_VectorDiv __in_inst_vector_div;
	PkgSnow64ArithLog::PortOut_VectorDiv __out_inst_vector_div;
	Snow64VectorDiv __inst_vector_div(.clk(clk), .in(__in_inst_vector_div),
		.out(__out_inst_vector_div));

	PkgSnow64BFloat16::PortIn_VectorFpu __in_inst_vector_fpu;
	PkgSnow64BFloat16::PortOut_VectorFpu __out_inst_vector_fpu;
	Snow64BFloat16VectorFpu __inst_vector_fpu(.clk(clk),
		.in(__in_inst_vector_fpu), .out(__out_inst_vector_fpu));


	// Scalar data extractors
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


	// dDest scalar data injector
	PkgSnow64ScalarDataExtractOrInject::PortIn_ScalarDataInjector
		__in_inst_ddest_scalar_data_injector;
	PkgSnow64ScalarDataExtractOrInject::PortOut_ScalarDataInjector
		__out_inst_ddest_scalar_data_injector;
	Snow64ScalarDataInjector __inst_ddest_scalar_data_injector
		(.in(__in_inst_ddest_scalar_data_injector),
		.out(__out_inst_ddest_scalar_data_injector));

	// Casters
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

	PkgSnow64Cpu::TrueLarData
		__true_ra_data, __true_rb_data, __true_rc_data;

	`define ASSIGN_NON_FORWARDED_TRUE_REG_DATA(which_reg) \
		always @(*) __true_r``which_reg``_data.data_offset \
			= __from_lar_file__rd_metadata_``which_reg.data_offset; \
		always @(*) __true_r``which_reg``_data.data_type \
			= __from_lar_file__rd_metadata_``which_reg.data_type; \
		always @(*) __true_r``which_reg``_data.int_type_size \
			= __from_lar_file__rd_metadata_``which_reg.int_type_size;

	`ASSIGN_NON_FORWARDED_TRUE_REG_DATA(a)
	`ASSIGN_NON_FORWARDED_TRUE_REG_DATA(b)
	`ASSIGN_NON_FORWARDED_TRUE_REG_DATA(c)
	`undef ASSIGN_NON_FORWARDED_TRUE_REG_DATA

	`define ASSIGN_TO_SCALAR_DATA_EXTRACTOR_INPUTS(which_r, which_e) \
		always @(*) \
			__in_inst_``which_e``_scalar_data_extractor.to_shift \
			= __true_r``which_r``_data.data; \
		always @(*) \
			__in_inst_``which_e``_scalar_data_extractor.data_type \
			= __true_r``which_r``_data.data_type; \
		always @(*) \
			__in_inst_``which_e``_scalar_data_extractor.int_type_size \
			= __true_r``which_r``_data.int_type_size; \
		always @(*) \
			__in_inst_``which_e``_scalar_data_extractor.data_offset \
			= __true_r``which_r``_data.data_offset;

	`ASSIGN_TO_SCALAR_DATA_EXTRACTOR_INPUTS(a, ddest)
	`ASSIGN_TO_SCALAR_DATA_EXTRACTOR_INPUTS(b, dsrc0)
	`ASSIGN_TO_SCALAR_DATA_EXTRACTOR_INPUTS(c, dsrc1)
	`undef ASSIGN_TO_SCALAR_DATA_EXTRACTOR_INPUTS



	// Stuff for operand forwarding
	struct packed
	{
		logic valid;
		logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0] base_addr;
		logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] computed_data;
	} __curr_results, __past_results_0, __past_results_1, __past_results_2;

	// ONLY ALU/FPU instructions can produce (__curr_results.valid == 1'b1)
	always @(*) __curr_results.valid
		= ((__from_lar_file__rd_metadata_a.tag != 0)
		&& (__curr_decoded_instr.group == 0)
		&& (__next_state == StRegular));
	always @(*) __curr_results.base_addr
		= __from_lar_file__rd_shareddata_a.base_addr;

	//always @(*)
	//begin
	//	case (__curr_decoded_instr.op_type)
	//	PkgSnow64InstrDecoder::OpTypeScalar:
	//	begin
	//		__curr_results.data
	//			= __out_inst_ddest_scalar_data_injector.data;
	//	end

	//	PkgSnow64InstrDecoder::OpTypeVector:
	//	begin
	//		case (__)
	//		endcase
	//	end
	//	endcase
	//end


	wire [__MSB_POS__OPERAND_FORWARDING_CHECK:0]
		__operand_forwarding_check__ra, __operand_forwarding_check__rb,
		__operand_forwarding_check__rc;

	assign __operand_forwarding_check__ra
		= {(__past_results_0.valid && (__past_results_0.base_addr
		== __from_lar_file__rd_shareddata_a.base_addr)),
		(__past_results_1.valid && (__past_results_1.base_addr
		== __from_lar_file__rd_shareddata_a.base_addr)),
		(__past_results_2.valid && (__past_results_2.base_addr
		== __from_lar_file__rd_shareddata_a.base_addr))};
	assign __operand_forwarding_check__rb
		= {(__past_results_0.valid && (__past_results_0.base_addr
		== __from_lar_file__rd_shareddata_b.base_addr)),
		(__past_results_1.valid && (__past_results_1.base_addr
		== __from_lar_file__rd_shareddata_b.base_addr)),
		(__past_results_2.valid && (__past_results_2.base_addr
		== __from_lar_file__rd_shareddata_b.base_addr))};
	assign __operand_forwarding_check__rc
		= {(__past_results_0.valid && (__past_results_0.base_addr
		== __from_lar_file__rd_shareddata_c.base_addr)),
		(__past_results_1.valid && (__past_results_1.base_addr
		== __from_lar_file__rd_shareddata_c.base_addr)),
		(__past_results_2.valid && (__past_results_2.base_addr
		== __from_lar_file__rd_shareddata_c.base_addr))};



	// Whenever the next state is NOT going to be StRegular, we are not
	// going to be ready to accept a new instruction on the next cycle.
	always @(*) out_to_pipe_stage_if_id.stall
		= (__next_state != StRegular);


	always @(*)
	begin
		case (__curr_decoded_instr.oper)
		PkgSnow64InstrDecoder::Btru_OneRegOneSimm20:
		begin
			out_to_pipe_stage_if_id.computed_pc
				= (__out_inst_ddest_scalar_data_extractor.data != 0)
				? (in_from_pipe_stage_if_id.pc_val
				+ __curr_decoded_instr.signext_imm)
				: in_from_pipe_stage_if_id.pc_val;
		end

		PkgSnow64InstrDecoder::Bfal_OneRegOneSimm20:
		begin
			out_to_pipe_stage_if_id.computed_pc
				= (__out_inst_ddest_scalar_data_extractor.data == 0)
				? (in_from_pipe_stage_if_id.pc_val
				+ __curr_decoded_instr.signext_imm)
				: in_from_pipe_stage_if_id.pc_val;
		end

		//PkgSnow64InstrDecoder::Jmp_OneReg:
		default:
		begin
			out_to_pipe_stage_if_id.computed_pc
				= __out_inst_ddest_scalar_data_extractor.data;
		end

		//default:
		//begin
		//	out_to_pipe_stage_if_id.computed_pc = 0;
		//end
		endcase
	end



	initial
	begin
		out_to_pipe_stage_if_id = 0;
		out_to_pipe_stage_wb = 0;

		__state = StRegular;
		__next_state = StRegular;

		__in_inst_vector_alu = 0;
		__in_inst_vector_mul = 0;
		__in_inst_vector_div = 0;
		__in_inst_vector_fpu = 0;

		{__in_inst_ddest_scalar_data_extractor,
			__in_inst_dsrc0_scalar_data_extractor,
			__in_inst_dsrc1_scalar_data_extractor} = 0;
		__in_inst_ddest_scalar_data_injector = 0;

		{__in_inst_dsrc0_int_scalar_caster,
			__in_inst_dsrc1_int_scalar_caster} = 0;
		{__in_inst_dsrc0_int_vector_caster,
			__in_inst_dsrc1_int_vector_caster} = 0;

		{__in_inst_dsrc0_bfloat16_cast_from_int,
			__in_inst_dsrc1_bfloat16_cast_from_int} = 0;
		{__in_inst_dsrc0_bfloat16_cast_to_int,
			__in_inst_dsrc1_bfloat16_cast_to_int} = 0;
		{__in_inst_dsrc0_tof_bfloat16_vector_caster,
			__in_inst_dsrc1_tof_bfloat16_vector_caster} = 0;

		{__true_ra_data, __true_rb_data, __true_rc_data} = 0;

		{__past_results_0, __past_results_1, __past_results_2} = 0;
	end


	`define PERF_OPERAND_FORWARDING(which_reg) \
	always @(*) \
	begin \
		case (__operand_forwarding_check__r``which_reg) \
		3'b111: {__true_r``which_reg``_data.data, \
			__true_r``which_reg``_data.base_addr} \
			= {__past_results_0.computed_data, \
			__past_results_0.base_addr}; \
		3'b110: {__true_r``which_reg``_data.data, \
			__true_r``which_reg``_data.base_addr} \
			= {__past_results_0.computed_data, \
			__past_results_0.base_addr}; \
		3'b101: {__true_r``which_reg``_data.data, \
			__true_r``which_reg``_data.base_addr} \
			= {__past_results_0.computed_data, \
			__past_results_0.base_addr}; \
		3'b100: {__true_r``which_reg``_data.data, \
			__true_r``which_reg``_data.base_addr} \
			= {__past_results_0.computed_data, \
			__past_results_0.base_addr}; \
		3'b011: {__true_r``which_reg``_data.data, \
			__true_r``which_reg``_data.base_addr} \
			= {__past_results_1.computed_data, \
			__past_results_1.base_addr}; \
		3'b010: {__true_r``which_reg``_data.data, \
			__true_r``which_reg``_data.base_addr} \
			= {__past_results_1.computed_data, \
			__past_results_1.base_addr}; \
		3'b001: {__true_r``which_reg``_data.data, \
			__true_r``which_reg``_data.base_addr} \
			= {__past_results_2.computed_data, \
			__past_results_2.base_addr}; \
		3'b000: {__true_r``which_reg``_data.data, \
			__true_r``which_reg``_data.base_addr} \
			= {__from_lar_file__rd_shareddata_``which_reg.data, \
			__from_lar_file__rd_shareddata_``which_reg.base_addr}; \
		endcase \
	end

	`PERF_OPERAND_FORWARDING(a)
	`PERF_OPERAND_FORWARDING(b)
	`PERF_OPERAND_FORWARDING(c)
	`undef PERF_OPERAND_FORWARDING

	always_ff @(posedge clk)
	begin
		__past_results_0 <= __curr_results;
		__past_results_1 <= __past_results_0;
		__past_results_2 <= __past_results_1;
	end

	// Compute __next_state
	//always @(*)
	//begin
	//	case (__state)
	//	StRegular:
	//	begin
	//	end

	//	StUseCastedResults:
	//	begin
	//	end

	//	StWaitForSubmodule:
	//	begin:
	//	end

	//	// This shouldn't happen!
	//	StBad:
	//	begin
	//		__next_state = StBad;
	//	end
	//	endcase
	//end


	// Send __next_state 
	always_ff @(posedge clk)
	begin
		__state <= __next_state;
	end


endmodule
