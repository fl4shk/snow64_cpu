`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"
`include "src/snow64_pipe_stage_structs.header.sv"





module Snow64PipeStageEx(input logic clk,
	input PortIn_Snow64PipeStageEx_FromControlUnit in_from_ctrl_unit,
	input PortIn_Snow64PipeStageEx_FromPipeStageIfId
		in_from_pipe_stage_if_id,
	output PortOut_Snow64PipeStageEx_ToPipeStageIfId
		out_to_pipe_stage_if_id);


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
		{__in_inst_dsrc0_tof_bfloat16_vector_caster,
			__in_inst_dsrc1_tof_bfloat16_vector_caster} = 0;
	end

endmodule
