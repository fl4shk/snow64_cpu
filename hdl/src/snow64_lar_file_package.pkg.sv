`include "src/snow64_lar_file_defines.header.sv"


package PkgSnow64LarFile;
typedef logic [`MSB_POS__SNOW64_SCALAR_DATA:0] ScalarData;

typedef logic [`MSB_POS__SNOW64_LAR_FILE_INDEX:0] LarIndex;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_8:0]
	LarAddrBasePtr8;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_8:0] LarAddrOffset8;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_16:0]
	LarAddrBasePtr16;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_16:0] LarAddrOffset16;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_32:0]
	LarAddrBasePtr32;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_32:0] LarAddrOffset32;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_64:0]
	LarAddrBasePtr64;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_64:0] LarAddrOffset64;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0] LarTag;

typedef logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] LarData;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0]
	LarBaseAddr;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_REF_COUNT:0]
	LarRefCount;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_DIRTY:0] LarDirty;

typedef enum logic [`MSB_POS__SNOW64_LAR_FILE_WRITE_TYPE:0]
{
	// Mostly ALU/FPU operations.
	WriteTypOnlyData,

	// (Would have been) used for port-mapped input instructions
	WriteTypDataAndType,

	WriteTypLd,

	WriteTypSt
} LarFileWriteType;

typedef enum logic [`MSB_POS__SNOW64_LAR_FILE_WRITE_STATE:0]
{
	WrStIdle,
	WrStStartLdSt,
	WrStWaitForJustMemRead,
	WrStWaitForJustMemWrite,

	WrStWaitForMemReadAndMemWrite,
	WrStBad0,
	WrStBad1,
	WrStBad2
} WriteState;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_LAR_FILE_INDEX:0] index;
} PartialPortIn_LarFile_Read;


typedef struct packed
{
	// Are we requesting a write at all?
	logic req;

	// The type of writing into the LAR file that we're doing.
	logic [`MSB_POS__SNOW64_LAR_FILE_WRITE_TYPE:0] write_type;

	// Which LAR are we writing to?
	LarIndex index;

	// Data to write into the LAR file (not relevant for WriteTypLd or
	// WriteTypSt)
	LarData non_ldst_data;

	// Address to write into the LAR file (used for WriteTypLd and
	// WriteTypSt)
	PkgSnow64Cpu::CpuAddr ldst_addr;

	// New type of the LAR (relevant for all LarFileWriteType's except
	// WriteTypOnlyData)
	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] data_type;
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
} PartialPortIn_LarFile_Write;

typedef struct packed
{
	logic valid;
	LarData data;
} PartialPortIn_LarFile_MemRead;

typedef struct packed
{
	logic valid;
} PartialPortIn_LarFile_MemWrite;

//typedef struct packed
//{
//	LarData data;
//	ScalarData scalar_data;
//
//	PkgSnow64Cpu::CpuAddr addr;
//
//	LarTag tag;
//
//	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] data_type;
//
//	// Same int_type_size goodness as in other modules.
//	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
//
//	// It turns out that nobody besides the LAR file needs to know which
//	// LARs are dirty!
//} PartialPortOut_LarFile_Read;

typedef struct packed
{
	LarTag tag;

	logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET:0] data_offset;

	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] data_type;
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
} PartialPortOut_LarFile_ReadMetadata;

typedef struct packed
{
	LarData data;
	//ScalarData scalar_data;

	//PkgSnow64Cpu::CpuAddr addr;
	LarBaseAddr base_addr;
} PartialPortOut_LarFile_ReadShareddata;

typedef struct packed
{
	logic valid;
} PartialPortOut_LarFile_Write;

// Tell the outside world when we want to read from memory.
typedef struct packed
{
	logic req;
	LarBaseAddr base_addr;
} PartialPortOut_LarFile_MemRead;

// Tell the outside world when we want to write to memory.
typedef struct packed
{
	logic req;
	LarData data;
	LarBaseAddr base_addr;
} PartialPortOut_LarFile_MemWrite;


typedef struct packed
{
	logic `STRUCTDIM(PartialPortIn_LarFile_Read) rd_a, rd_b, rd_c;
	logic `STRUCTDIM(PartialPortIn_LarFile_Write) wr;
	logic `STRUCTDIM(PartialPortIn_LarFile_MemRead) mem_read;
	logic `STRUCTDIM(PartialPortIn_LarFile_MemWrite) mem_write;
} PortIn_LarFile;

typedef struct packed
{
	logic `STRUCTDIM(PartialPortOut_LarFile_ReadMetadata)
		rd_metadata_a, rd_metadata_b, rd_metadata_c;
	logic `STRUCTDIM(PartialPortOut_LarFile_ReadShareddata)
		rd_shareddata_a, rd_shareddata_b, rd_shareddata_c;
	logic `STRUCTDIM(PartialPortOut_LarFile_Write) wr;
	logic `STRUCTDIM(PartialPortOut_LarFile_MemRead) mem_read;
	logic `STRUCTDIM(PartialPortOut_LarFile_MemWrite) mem_write;
} PortOut_LarFile;


typedef struct packed
{
	LarAddrBasePtr8 base_ptr;
	LarAddrOffset8 offset;
} LarAddr8;


typedef struct packed
{
	LarAddrBasePtr16 base_ptr;
	LarAddrOffset16 offset;
} LarAddr16;


typedef struct packed
{
	LarAddrBasePtr32 base_ptr;
	LarAddrOffset32 offset;
} LarAddr32;


typedef struct packed
{
	LarAddrBasePtr64 base_ptr;
	LarAddrOffset64 offset;
} LarAddr64;

// Used to grab the base_addr from an incoming address
typedef struct packed
{
	LarBaseAddr base_addr;
	logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET:0] data_offset;
} LarIncomingBaseAddr;


endpackage : PkgSnow64LarFile
