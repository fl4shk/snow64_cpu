`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"
`include "src/snow64_pipe_stage_structs.header.sv"




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
	assign __in_inst_mem_bus_guard = in;

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
	assign out = __out_inst_mem_bus_guard;


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




endmodule
