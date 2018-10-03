`include "src/snow64_pipe_stage_structs.header.sv"

module Snow64PipeStageWb(input logic clk,
	input PortIn_Snow64PipeStageWb_FromCtrlUnit in_from_ctrl_unit,
	input PortIn_Snow64PipeStageWb_FromPipeStageEx in_from_pipe_stage_ex,
	output PortOut_Snow64PipeStageWb_ToPipeStageIfId
		out_to_pipe_stage_if_id,
	output PortOut_Snow64PipeStageWb_ToCtrlUnit out_to_ctrl_unit);

	enum logic
	{
		StIdle,
		StWaitForLarFileValid
	} __state;

	PkgSnow64InstrDecoder::PortOut_InstrDecoder __curr_decoded_instr;
	assign __curr_decoded_instr = in_from_pipe_stage_ex.decoded_instr;

endmodule
