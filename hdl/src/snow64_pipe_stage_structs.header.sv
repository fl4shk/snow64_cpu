`ifndef src__slash__snow64_pipe_stage_structs_header_sv
`define src__slash__snow64_pipe_stage_structs_header_sv

// src/snow64_pipe_stage_structs.header.sv

`include "src/misc_defines.header.sv"


// Stage ID/ID
typedef struct packed
{
	PkgSnow64InstrDecoder::InstrRegIndex ra_index, rb_index, rc_index;
} PortOut_Snow64PipeStageIfId_ToControlUnit;


typedef struct packed
{
	logic valid;
	PkgSnow64InstrCache::Instr instr;
} PortIn_Snow64PipeStageIfId_FromInstrCache;

typedef struct packed
{
	logic req;
	PkgSnow64Cpu::CpuAddr addr;
} PortOut_Snow64PipeStageIfId_ToInstrCache;


typedef struct packed
{
	logic stall;
} PortIn_Snow64PipeStageIfId_FromPipeStageEx;


typedef struct packed
{
	logic `STRUCTDIM(PkgSnow64InstrDecoder::PortOut_InstrDecoder)
		decoded_instr;
} PortOut_Snow64PipeStageIfId_ToPipeStageEx;


typedef struct packed
{
	logic stall;
} PortIn_Snow64PipeStageIfId_FromPipeStageWb;



// Stage EX
typedef struct packed
{
	logic `STRUCTDIM(PkgSnow64LarFile::PartialPortOut_LarFile_ReadMetadata)
		lar_file_rd_metadata_a, lar_file_rd_metadata_b,
		lar_file_rd_metadata_c;
	logic
		`STRUCTDIM(PkgSnow64LarFile::PartialPortOut_LarFile_ReadShareddata)
		lar_file_rd_shareddata_a, lar_file_rd_shareddata_b,
		lar_file_rd_shareddata_c;
} PortIn_Snow64PipeStageEx_FromControlUnit;

typedef PortIn_Snow64PipeStageIfId_FromPipeStageEx
	PortOut_Snow64PipeStageEx_ToPipeStageIfId;
typedef PortOut_Snow64PipeStageIfId_ToPipeStageEx
	PortIn_Snow64PipeStageEx_FromPipeStageIfId;


typedef struct packed
{
	logic `STRUCTDIM(PkgSnow64InstrDecoder::PortOut_InstrDecoder)
		decoded_instr;

	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] computed_data;
} PortOut_Snow64PipeStageEx_ToPipeStageWb;


// Stage WB

typedef PortOut_Snow64PipeStageEx_ToPipeStageWb
	PortIn_Snow64PipeStageWb_FromPipeStageEx;

typedef PortIn_Snow64PipeStageIfId_FromPipeStageWb
	PortOut_Snow64PipeStageWb_ToPipeStageIfId;


typedef struct packed
{
	// Are we requesting a write at all?
	logic req;

	// The type of writing into the LAR file that we're doing.
	logic [`MSB_POS__SNOW64_LAR_FILE_WRITE_TYPE:0] write_type;

	// Which LAR are we writing to?
	logic [`MSB_POS__SNOW64_LAR_FILE_INDEX:0] index;

	// Data to write into the LAR file (not relevant for WriteTypLd or
	// WriteTypSt)
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] non_ldst_data;


	// Address to write into the LAR file (used for WriteTypLd and
	// WriteTypSt)
	logic [`MSB_POS__SNOW64_CPU_ADDR:0] ldst_addr;

	// New type of the LAR (relevant for all LarFileWriteType's except
	// WriteTypOnlyData)
	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] data_type;
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
} PortOut_Snow64PipeStageWb_ToControlUnit;



`endif		// src__slash__snow64_pipe_stage_structs_header_sv
