`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"
`include "src/snow64_pipe_stage_structs.header.sv"





module Snow64PipeStageIfId(input logic clk,
	input PortIn_Snow64PipeStageIfId_FromInstrCache in_from_instr_cache,
	input PortIn_Snow64PipeStageIfId_FromPipeStageEx in_from_pipe_stage_ex,
	input PortIn_Snow64PipeStageIfId_FromPipeStageWb in_from_pipe_stage_wb,
	output PortOut_Snow64PipeStageIfId_ToControlUnit out_to_ctrl_unit,
	output PortOut_Snow64PipeStageIfId_ToInstrCache out_to_instr_cache,
	output PortOut_Snow64PipeStageIfId_ToPipeStageEx out_to_pipe_stage_ex);


	// Instruction decoder
	PkgSnow64InstrDecoder::PortOut_InstrDecoder __out_inst_instr_decoder;

	Snow64InstrDecoder __inst_instr_decoder(.in(in_from_instr_cache.instr),
		.out(__out_inst_instr_decoder));

endmodule
