`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"
`include "src/snow64_pipe_stage_structs.header.sv"



module Snow64PipeStageEx(input logic clk,
	input PortIn_Snow64PipeStageEx_FromCtrlUnit in_from_ctrl_unit,
	input PortIn_Snow64PipeStageEx_FromPipeStageIfId
		in_from_pipe_stage_if_id,
	output PortOut_Snow64PipeStageEx_ToPipeStageIfId
		out_to_pipe_stage_if_id);


	localparam __WIDTH__OPERAND_FORWARDING_CHECK = 3;
	localparam __MSB_POS__OPERAND_FORWARDING_CHECK
		= `WIDTH2MP(__WIDTH__OPERAND_FORWARDING_CHECK);

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

	// Stuff for operand forwarding
	struct packed
	{
		logic valid;
		logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0] base_addr;
		logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] computed_data;
	} __curr_results, __past_results_0, __past_results_1, __past_results_2;

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



	initial
	begin
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


endmodule
