`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"

// Instruction cache, LAR file, and Memory Bus Guard
module Snow64MemoryAccessors(input logic clk,
	input PkgSnow64InstrCache::PartialPortIn_InstrCache_ReqRead
		in_instr_cache__req_read,

	input PkgSnow64LarFile::PartialPortIn_LarFile_Read
		in_lar_file__rd_a, in_lar_file__rd_b, in_lar_file__rd_c,
	input PkgSnow64LarFile::PartialPortIn_LarFile_Write in_lar_file__wr,

	input PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_MemAccess
		in_mem_bus_guard,

	output PkgSnow64InstrCache::PartialPortOut_InstrCache_ReqRead
		out_instr_cache__req_read,

	output PkgSnow64LarFile::PartialPortOut_LarFile_ReadMetadata
		out_lar_file__rd_metadata_a, out_lar_file__rd_metadata_b,
		out_lar_file__rd_metadata_c,
	output PkgSnow64LarFile::PartialPortOut_LarFile_ReadShareddata
		out_lar_file__rd_shareddata_a, out_lar_file__rd_shareddata_b,
		out_lar_file__rd_shareddata_c,
	output PkgSnow64LarFile::PartialPortOut_LarFile_Write out_lar_file__wr,

	output PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_MemAccess
		out_mem_bus_guard);




	// instruction cache
	PkgSnow64InstrCache::PartialPortIn_InstrCache_MemAccess
		__in_inst_instr_cache__mem_access;


	PkgSnow64InstrCache::PartialPortOut_InstrCache_MemAccess
		__out_inst_instr_cache__mem_access;

	Snow64InstrCache __inst_instr_cache(.clk(clk),
		.in_req_read(in_instr_cache__req_read),
		.in_mem_access(__in_inst_instr_cache__mem_access),

		.out_req_read(out_instr_cache__req_read),
		.out_mem_access(__out_inst_instr_cache__mem_access));



	// LAR file
	PkgSnow64LarFile::PortIn_LarFile __in_inst_lar_file;
	PkgSnow64LarFile::PortOut_LarFile __out_inst_lar_file;

	Snow64LarFile __inst_lar_file(.clk(clk), .in(__in_inst_lar_file),
		.out(__out_inst_lar_file));

	PkgSnow64LarFile::PartialPortIn_LarFile_MemRead
		__in_inst_lar_file__mem_read;
	PkgSnow64LarFile::PartialPortIn_LarFile_MemWrite
		__in_inst_lar_file__mem_write;

	PkgSnow64LarFile::PartialPortOut_LarFile_MemRead
		__out_inst_lar_file__mem_read;
	PkgSnow64LarFile::PartialPortOut_LarFile_MemWrite
		__out_inst_lar_file__mem_write;

	assign __in_inst_lar_file
		= {in_lar_file__rd_a, in_lar_file__rd_b, in_lar_file__rd_c,
		in_lar_file__wr,
		__in_inst_lar_file__mem_read, __in_inst_lar_file__mem_write};

	assign {out_lar_file__rd_metadata_a, out_lar_file__rd_metadata_b,
		out_lar_file__rd_metadata_c,
		out_lar_file__rd_shareddata_a, out_lar_file__rd_shareddata_b,
		out_lar_file__rd_shareddata_c,
		out_lar_file__wr,
		__out_inst_lar_file__mem_read,
		__out_inst_lar_file__mem_write} = __out_inst_lar_file;




	// Memory access via FIFOs
	PkgSnow64MemoryAccessFifo::PartialPortIn_ReadFifo_ReqRead
		__in_inst_read_fifo__instr__req_read,
		__in_inst_read_fifo__data__req_read;
	PkgSnow64MemoryAccessFifo::PartialPortIn_WriteFifo_ReqWrite
		__in_inst_write_fifo__data__req_write;


	PkgSnow64MemoryAccessFifo::PartialPortOut_ReadFifo_ReqRead
		__out_inst_read_fifo__instr__req_read,
		__out_inst_read_fifo__data__req_read;
	PkgSnow64MemoryAccessFifo::PartialPortOut_WriteFifo_ReqWrite
		__out_inst_write_fifo__data__req_write;


	Snow64MemoryAccessViaFifos __inst_memory_access_via_fifos(.clk(clk),
		.in_mem_acc_read_fifo__instr__req_read
		(__in_inst_read_fifo__instr__req_read),
		.in_mem_acc_read_fifo__data__req_read
		(__in_inst_read_fifo__data__req_read),
		.in_mem_acc_write_fifo__data__req_write
		(__in_inst_write_fifo__data__req_write),

		.in_mem_bus_guard__mem_access(in_mem_bus_guard),

		.out_mem_acc_read_fifo__instr__req_read
		(__out_inst_read_fifo__instr__req_read),
		.out_mem_acc_read_fifo__data__req_read
		(__out_inst_read_fifo__data__req_read),
		.out_mem_acc_write_fifo__data__req_write
		(__out_inst_write_fifo__data__req_write),

		.out_mem_bus_guard__mem_access(out_mem_bus_guard));


	// Connections between the instruction cache and
	// Snow64MemoryAccessViaFifos.


	// FIFOs -> Instruction cache
	// typedef struct packed
	// {
	// 	logic valid;
	// 	LineData data;
	// } PartialPortIn_InstrCache_MemAccess;
	// 
	// typedef struct packed
	// {
	// 	logic valid, busy;
	// 	LarData data;
	// } PartialPortOut_ReadFifo_ReqRead;
	assign __in_inst_instr_cache__mem_access
		= {__out_inst_read_fifo__instr__req_read.valid,
		__out_inst_read_fifo__instr__req_read.data};


	// Instruction cache -> FIFOs
	// typedef struct packed
	// {
	// 	logic req;
	// 	CpuAddr addr;
	// } PartialPortOut_InstrCache_MemAccess;
	// 
	// typedef struct packed
	// {
	// 	logic req;
	// 	// This address is generally aligned to the size of LarData.
	// 	CpuAddr addr;
	// } PartialPortIn_ReadFifo_ReqRead;
	assign __in_inst_read_fifo__instr__req_read
		= __out_inst_instr_cache__mem_access;



	// Connections between the LAR file and Snow64MemoryAccessViaFifos.
	// FIFOs -> LAR file

	// typedef struct packed
	// {
	// 	logic valid;
	// 	LarData data;
	// } PartialPortIn_LarFile_MemRead;
	// 
	// typedef struct packed
	// {
	// 	logic valid, busy;
	// 	LarData data;
	// } PartialPortOut_ReadFifo_ReqRead;
	assign __in_inst_lar_file__mem_read
		= {__out_inst_read_fifo__data__req_read.valid,
		__out_inst_read_fifo__data__req_read.data};

	// typedef struct packed
	// {
	// 	logic valid;
	// } PartialPortIn_LarFile_MemWrite;
	// 
	// typedef struct packed
	// {
	// 	logic valid, busy;
	// } PartialPortOut_WriteFifo_ReqWrite;
	assign __in_inst_lar_file__mem_write
		= __out_inst_write_fifo__data__req_write.valid;


	// LAR file -> FIFOs


	// typedef struct packed
	// {
	// 	logic req;
	// 	LarBaseAddr base_addr;
	// } PartialPortOut_LarFile_MemRead;
	// 
	// typedef struct packed
	// {
	// 	logic req;
	// 	// This address is generally aligned to the size of LarData.
	// 	CpuAddr addr;
	// } PartialPortIn_ReadFifo_ReqRead;
	assign __in_inst_read_fifo__data__req_read
		= {__out_inst_lar_file__mem_read.req,
		{__out_inst_lar_file__mem_read.base_addr,
		{`WIDTH__SNOW64_LAR_FILE_METADATA_DATA_OFFSET{1'b0}}}};



	// typedef struct packed
	// {
	// 	logic req;
	// 	LarData data;
	// 	LarBaseAddr base_addr;
	// } PartialPortOut_LarFile_MemWrite;
	// 
	// typedef struct packed
	// {
	// 	logic req;
	// 	// This address is generally aligned to the size of LarData.
	// 	CpuAddr addr;
	// 	LarData data;
	// } PartialPortIn_WriteFifo_ReqWrite;
	assign __in_inst_write_fifo__data__req_write
		= {__out_inst_lar_file__mem_write.req,
		{__out_inst_lar_file__mem_write.base_addr,
		{`WIDTH__SNOW64_LAR_FILE_METADATA_DATA_OFFSET{1'b0}}},
		__out_inst_lar_file__mem_write.data};


endmodule
