`ifndef src__slash__snow64_pipe_stage_structs_header_sv
`define src__slash__snow64_pipe_stage_structs_header_sv

// src/snow64_pipe_stage_structs.header.sv

`include "src/misc_defines.header.sv"
`include "src/snow64_instr_decoder_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"

// Stage ID/ID
typedef struct packed
{
	PkgSnow64InstrDecoder::InstrRegIndex ra_index, rb_index, rc_index;
} PortOut_Snow64PipeStageIfId_ToCtrlUnit;


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

	logic [`MSB_POS__SNOW64_CPU_ADDR:0] computed_pc;
} PortIn_Snow64PipeStageIfId_FromPipeStageEx;

typedef struct packed
{
	//logic `STRUCTDIM(PkgSnow64InstrDecoder::PortOut_InstrDecoder)
	//	decoded_instr;
	logic [`MSB_POS__SNOW64_IENC_GROUP:0] group;
	logic op_type;
	logic [`MSB_POS__SNOW64_IENC_REG_INDEX:0] ra_index, rb_index, rc_index;
	logic [`MSB_POS__SNOW64_IENC_OPCODE:0] oper;

	// Simply sign extend the immediate value encoded into each
	// instruction.
	// The size of that sign-extended immediate varies by instruction
	// group.
	logic [`MSB_POS__SNOW64_CPU_ADDR:0] signext_imm;


	// If this instruction should be treated as a nop.
	logic nop;

	// If this instruction only uses 64-bit integers
	logic forced_64_bit_integers;

	logic [`MSB_POS__SNOW64_DECODED_STALL_TYPE:0] decoded_stall_type;
} Snow64Pipeline_DecodedInstr;

typedef struct packed
{
	logic `STRUCTDIM(Snow64Pipeline_DecodedInstr) decoded_instr;

	logic [`MSB_POS__SNOW64_CPU_ADDR:0] pc_val;
} PortOut_Snow64PipeStageIfId_ToPipeStageEx;


typedef struct packed
{
	logic stall;
} PortIn_Snow64PipeStageIfId_FromPipeStageWb;


typedef struct packed
{
	logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0] tag;
	logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET:0] data_offset;
	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] data_type;
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
} Snow64Pipeline_LarFileReadMetadata;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] data;
	logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0] base_addr;
} Snow64Pipeline_LarFileReadShareddata;

// Stage EX
typedef struct packed
{
	logic `STRUCTDIM(Snow64Pipeline_LarFileReadMetadata)
		out_inst_lar_file__rd_metadata_a, out_inst_lar_file__rd_metadata_b,
		out_inst_lar_file__rd_metadata_c;
	logic `STRUCTDIM(Snow64Pipeline_LarFileReadShareddata)
		out_inst_lar_file__rd_shareddata_a,
		out_inst_lar_file__rd_shareddata_b,
		out_inst_lar_file__rd_shareddata_c;
} PortIn_Snow64PipeStageEx_FromCtrlUnit;


typedef PortIn_Snow64PipeStageIfId_FromPipeStageEx
	PortOut_Snow64PipeStageEx_ToPipeStageIfId;
typedef PortOut_Snow64PipeStageIfId_ToPipeStageEx
	PortIn_Snow64PipeStageEx_FromPipeStageIfId;


typedef struct packed
{
	logic `STRUCTDIM(Snow64Pipeline_DecodedInstr) decoded_instr;

	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] computed_data;
	//logic [`MSB_POS__SNOW64_CPU_ADDR:0] pc_val;
	logic [`MSB_POS__SNOW64_CPU_ADDR:0] ldst_addr;
} PortOut_Snow64PipeStageEx_ToPipeStageWb;


// Stage WB

typedef PortOut_Snow64PipeStageEx_ToPipeStageWb
	PortIn_Snow64PipeStageWb_FromPipeStageEx;

typedef PortIn_Snow64PipeStageIfId_FromPipeStageWb
	PortOut_Snow64PipeStageWb_ToPipeStageIfId;

typedef struct packed
{
	logic out_inst_lar_file__wr__valid;
} PortIn_Snow64PipeStageWb_FromCtrlUnit;

// Just a copy of PartialPortIn_LarFile_Write
typedef struct packed
{
	// Are we requesting a write at all?
	logic in_inst_lar_file__wr__req;

	// The type of writing into the LAR file that we're doing.
	logic [`MSB_POS__SNOW64_LAR_FILE_WRITE_TYPE:0]
		in_inst_lar_file__wr__write_type;

	// Which LAR are we writing to?
	logic [`MSB_POS__SNOW64_LAR_FILE_INDEX:0] in_inst_lar_file__wr__index;

	// Data to write into the LAR file (not relevant for WriteTypLd or
	// WriteTypSt)
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		in_inst_lar_file__wr__non_ldst_data;

	// Address to write into the LAR file (used for WriteTypLd and
	// WriteTypSt)
	logic [`MSB_POS__SNOW64_CPU_ADDR:0] in_inst_lar_file__wr__ldst_addr;

	// New type of the LAR (relevant for all LarFileWriteType's except
	// WriteTypOnlyData)
	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0]
		in_inst_lar_file__wr__data_type;
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		in_inst_lar_file__wr__int_type_size;
} PortOut_Snow64PipeStageWb_ToCtrlUnit;

`endif		// src__slash__snow64_pipe_stage_structs_header_sv
