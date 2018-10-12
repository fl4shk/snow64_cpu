`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"
`include "src/snow64_pipe_stage_structs.header.sv"



// This is the top-level CPU module.
// As you can see, this module itself is really simple.
module Snow64Cpu(input logic clk, input PkgSnow64Cpu::PortIn_Cpu in,
	output PkgSnow64Cpu::PortOut_Cpu out);


	PkgSnow64InstrCache::PartialPortIn_InstrCache_ReqRead
		__in_inst_fake_instr_cache__req_read;

	PkgSnow64LarFile::PartialPortIn_LarFile_Read
		__in_inst_lar_file__rd_a, __in_inst_lar_file__rd_b,
		__in_inst_lar_file__rd_c;
	PkgSnow64LarFile::PartialPortIn_LarFile_Write __in_inst_lar_file__wr;


	PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_MemAccess
		__in_inst_mem_bus_guard;

	PkgSnow64InstrCache::PartialPortOut_InstrCache_ReqRead
		__out_inst_fake_instr_cache__req_read;

	PkgSnow64LarFile::PartialPortOut_LarFile_ReadMetadata
		__out_inst_lar_file__rd_metadata_a,
		__out_inst_lar_file__rd_metadata_b,
		__out_inst_lar_file__rd_metadata_c;
	PkgSnow64LarFile::PartialPortOut_LarFile_ReadShareddata
		__out_inst_lar_file__rd_shareddata_a,
		__out_inst_lar_file__rd_shareddata_b,
		__out_inst_lar_file__rd_shareddata_c;
	PkgSnow64LarFile::PartialPortOut_LarFile_Write __out_inst_lar_file__wr;


	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_MemAccess
		__out_inst_mem_bus_guard;


	Snow64MemoryAccessors __inst_mem_accessors(.clk(clk),
		.in_fake_instr_cache__req_read
			(__in_inst_fake_instr_cache__req_read),
		.in_lar_file__rd_a(__in_inst_lar_file__rd_a),
		.in_lar_file__rd_b(__in_inst_lar_file__rd_b),
		.in_lar_file__rd_c(__in_inst_lar_file__rd_c),
		.in_lar_file__wr(__in_inst_lar_file__wr),
		.in_mem_bus_guard(__in_inst_mem_bus_guard),
		.out_fake_instr_cache__req_read
			(__out_inst_fake_instr_cache__req_read),
		.out_lar_file__rd_metadata_a(__out_inst_lar_file__rd_metadata_a),
		.out_lar_file__rd_metadata_b(__out_inst_lar_file__rd_metadata_b),
		.out_lar_file__rd_metadata_c(__out_inst_lar_file__rd_metadata_c),
		.out_lar_file__rd_shareddata_a
			(__out_inst_lar_file__rd_shareddata_a),
		.out_lar_file__rd_shareddata_b
			(__out_inst_lar_file__rd_shareddata_b),
		.out_lar_file__rd_shareddata_c
			(__out_inst_lar_file__rd_shareddata_c),
		.out_lar_file__wr(__out_inst_lar_file__wr),
		.out_mem_bus_guard(__out_inst_mem_bus_guard));

	PortIn_Snow64PipeStageIfId_FromInstrCache
		__in_inst_pipe_stage_if_id__from_instr_cache;
	PortIn_Snow64PipeStageIfId_FromPipeStageEx
		__in_inst_pipe_stage_if_id__from_pipe_stage_ex;
	PortIn_Snow64PipeStageIfId_FromPipeStageWb
		__in_inst_pipe_stage_if_id__from_pipe_stage_wb;
	PortOut_Snow64PipeStageIfId_ToCtrlUnit
		__out_inst_pipe_stage_if_id__to_ctrl_unit;
	PortOut_Snow64PipeStageIfId_ToInstrCache
		__out_inst_pipe_stage_if_id__to_instr_cache;
	PortOut_Snow64PipeStageIfId_ToPipeStageEx
		__out_inst_pipe_stage_if_id__to_pipe_stage_ex;
	// module Snow64PipeStageIfId(input logic clk,
	// 	input PortIn_Snow64PipeStageIfId_FromInstrCache
	// 		in_from_instr_cache,
	// 	input PortIn_Snow64PipeStageIfId_FromPipeStageEx
	// 		in_from_pipe_stage_ex,
	// 	input PortIn_Snow64PipeStageIfId_FromPipeStageWb
	// 		in_from_pipe_stage_wb,
	// 	output PortOut_Snow64PipeStageIfId_ToCtrlUnit out_to_ctrl_unit,
	// 	output PortOut_Snow64PipeStageIfId_ToInstrCache out_to_instr_cache,
	// 	output PortOut_Snow64PipeStageIfId_ToPipeStageEx
	// 		out_to_pipe_stage_ex);
	Snow64PipeStageIfId __inst_pipe_stage_if_id(.clk(clk),
		.in_from_instr_cache(__in_inst_pipe_stage_if_id__from_instr_cache),
	
		.in_from_pipe_stage_ex
			(__in_inst_pipe_stage_if_id__from_pipe_stage_ex),
	
		.in_from_pipe_stage_wb
			(__in_inst_pipe_stage_if_id__from_pipe_stage_wb),
		.out_to_ctrl_unit(__out_inst_pipe_stage_if_id__to_ctrl_unit),
		.out_to_instr_cache(__out_inst_pipe_stage_if_id__to_instr_cache),
		.out_to_pipe_stage_ex
			(__out_inst_pipe_stage_if_id__to_pipe_stage_ex));



	PortIn_Snow64PipeStageEx_FromCtrlUnit
		__in_inst_pipe_stage_ex__from_ctrl_unit;
	PortIn_Snow64PipeStageEx_FromPipeStageIfId
		__in_inst_pipe_stage_ex__from_pipe_stage_if_id;
	PortOut_Snow64PipeStageEx_ToPipeStageIfId
		__out_inst_pipe_stage_ex__to_pipe_stage_if_id;
	PortOut_Snow64PipeStageEx_ToPipeStageWb
		__out_inst_pipe_stage_ex__to_pipe_stage_wb;

	// module Snow64PipeStageEx(input logic clk,
	// 	input PortIn_Snow64PipeStageEx_FromCtrlUnit in_from_ctrl_unit,
	// 	input PortIn_Snow64PipeStageEx_FromPipeStageIfId
	// 		in_from_pipe_stage_if_id,
	// 	output PortOut_Snow64PipeStageEx_ToPipeStageIfId
	// 		out_to_pipe_stage_if_id,
	// 	output PortOut_Snow64PipeStageEx_ToPipeStageWb
	// 		out_to_pipe_stage_wb);
	Snow64PipeStageEx __inst_pipe_stage_ex(.clk(clk),
		.in_from_ctrl_unit(__in_inst_pipe_stage_ex__from_ctrl_unit),
		.in_from_pipe_stage_if_id
			(__in_inst_pipe_stage_ex__from_pipe_stage_if_id),
		.out_to_pipe_stage_if_id
			(__out_inst_pipe_stage_ex__to_pipe_stage_if_id),
		.out_to_pipe_stage_wb(__out_inst_pipe_stage_ex__to_pipe_stage_wb));

	
	PortIn_Snow64PipeStageWb_FromCtrlUnit
		__in_inst_pipe_stage_wb__from_ctrl_unit;
	PortIn_Snow64PipeStageWb_FromPipeStageEx
		__in_inst_pipe_stage_wb__from_pipe_stage_ex;
	PortOut_Snow64PipeStageWb_ToPipeStageIfId
		__out_inst_pipe_stage_wb__to_pipe_stage_if_id;
	PortOut_Snow64PipeStageWb_ToCtrlUnit
		__out_inst_pipe_stage_wb__to_ctrl_unit;
	// module Snow64PipeStageWb(input logic clk,
	// 	input PortIn_Snow64PipeStageWb_FromCtrlUnit in_from_ctrl_unit,
	// 	input PortIn_Snow64PipeStageWb_FromPipeStageEx
	// 		in_from_pipe_stage_ex,
	// 	output PortOut_Snow64PipeStageWb_ToPipeStageIfId
	// 		out_to_pipe_stage_if_id,
	// 	output PortOut_Snow64PipeStageWb_ToCtrlUnit out_to_ctrl_unit);
	Snow64PipeStageWb __inst_pipe_stage_wb(.clk(clk),
		.in_from_ctrl_unit(__in_inst_pipe_stage_wb__from_ctrl_unit),
		.in_from_pipe_stage_ex
			(__in_inst_pipe_stage_wb__from_pipe_stage_ex),
		.out_to_pipe_stage_if_id
			(__out_inst_pipe_stage_wb__to_pipe_stage_if_id),
		.out_to_ctrl_unit(__out_inst_pipe_stage_wb__to_ctrl_unit));



	// Connect the memory bus guard to the outside world
	assign __in_inst_mem_bus_guard = in;
	assign out = __out_inst_mem_bus_guard;


	// Connect pipeline stage IF/ID to the instruction cache
	assign __in_inst_pipe_stage_if_id__from_instr_cache
		= __out_inst_fake_instr_cache__req_read;
	assign __in_inst_fake_instr_cache__req_read
		= __out_inst_pipe_stage_if_id__to_instr_cache;

	// Connect pipeline stage IF/ID to the LAR file
	assign __in_inst_lar_file__rd_a
		= __out_inst_pipe_stage_if_id__to_ctrl_unit.ra_index;
	assign __in_inst_lar_file__rd_b
		= __out_inst_pipe_stage_if_id__to_ctrl_unit.rb_index;
	assign __in_inst_lar_file__rd_c
		= __out_inst_pipe_stage_if_id__to_ctrl_unit.rc_index;

	// Connect pipeline stage EX to the LAR file
	assign __in_inst_pipe_stage_ex__from_ctrl_unit
		= {__out_inst_lar_file__rd_metadata_a,
		__out_inst_lar_file__rd_metadata_b,
		__out_inst_lar_file__rd_metadata_c,
		__out_inst_lar_file__rd_shareddata_a,
		__out_inst_lar_file__rd_shareddata_b,
		__out_inst_lar_file__rd_shareddata_c};


	// Connect pipeline stage WB to the LAR file
	assign __in_inst_pipe_stage_wb__from_ctrl_unit
		= __out_inst_lar_file__wr;
	assign __in_inst_lar_file__wr = __out_inst_pipe_stage_wb__to_ctrl_unit;



	`define ASSIGN_SUBMODULE_PORT(src, dst) \
	assign __in_inst_``dst``__from_``src \
		= __out_inst_``src``__to_``dst;

	`ASSIGN_SUBMODULE_PORT(pipe_stage_if_id, pipe_stage_ex)
	`ASSIGN_SUBMODULE_PORT(pipe_stage_ex, pipe_stage_if_id)
	`ASSIGN_SUBMODULE_PORT(pipe_stage_ex, pipe_stage_wb)
	`ASSIGN_SUBMODULE_PORT(pipe_stage_wb, pipe_stage_if_id)

	`undef ASSIGN_SUBMODULE_PORT

	//always @(posedge clk)
	//begin
	//	//$display("Snow64Cpu LAR file read ports:  %h, %h, %h",
	//	//	__in_inst_lar_file__rd_a.index,
	//	//	__in_inst_lar_file__rd_b.index,
	//	//	__in_inst_lar_file__rd_c.index);
	//	$display("Snow64Cpu LAR file metadata tag:  %h, %h, %h",
	//		__out_inst_lar_file__rd_metadata_a.tag,
	//		__out_inst_lar_file__rd_metadata_b.tag,
	//		__out_inst_lar_file__rd_metadata_c.tag);
	//	//$display("Snow64Cpu LAR file shareddata data:  %h, %h, %h",
	//	//	__out_inst_lar_file__rd_shareddata_a.data,
	//	//	__out_inst_lar_file__rd_shareddata_b.data,
	//	//	__out_inst_lar_file__rd_shareddata_c.data);
	//	//$display("Snow64Cpu LAR file metadata int_type_size:  %h, %h, %h",
	//	//	__out_inst_lar_file__rd_metadata_a.int_type_size,
	//	//	__out_inst_lar_file__rd_metadata_b.int_type_size,
	//	//	__out_inst_lar_file__rd_metadata_c.int_type_size);
	//end


endmodule
