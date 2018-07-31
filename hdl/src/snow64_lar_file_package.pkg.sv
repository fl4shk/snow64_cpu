`include "src/snow64_lar_file_defines.header.sv"


package PkgSnow64LarFile;

typedef struct packed
{
	// This is used to tell the LAR file to stop
	logic pause;
} PortIn_LarFile_Ctrl;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_LAR_FILE_INDEX:0] index;
} PortIn_LarFile_Read;

typedef enum logic [`MSB_POS__SNOW64_LAR_FILE_WRITE_TYPE:0]
{
	// Mostly ALU/FPU operations.
	WriteTypOnlyData,

	// Used for port-mapped inputs
	WriteTypDataAndType,

	// Loads and stores, in general, change EVERYTHING.
	// They also affect reference counts.
	WriteTypLdSt,

	// Don't use this!
	WriteTypReserved
} LarFileWriteType;

typedef struct packed
{
	// Are we requesting a write at all?
	logic req;

	// Actually a LarFileWriteType
	logic write_type;

	// Which LAR are we writing to?
	logic [`MSB_POS__SNOW64_LAR_FILE_INDEX:0] index;

	// Data to write into the LAR file
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] data;

	// Address to write into the LAR file (relevant for WriteTypLdSt)
	logic [`MSB_POS__SNOW64_CPU_ADDR:0] addr;

	// New data type of the LAR (relevant for WriteTypLdSt
	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] data_type;
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
} PortIn_LarFile_Write;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] data;
	logic [`MSB_POS__SNOW64_CPU_ADDR:0] addr;

	// Outside the LAR file itself, this "tag" is used for operand
	// forwarding by the control unit or whatever you want to call it.
	// This is very much akin to how I implemented operand forwarding in my
	// first pipelined CPU, but in that case, I had used the register
	// indices directly.  Of course, with a DLARs machine, that's not
	// really a valid option because two registers may actually point to
	// the same data.
	logic [`MSB_POS__SNOW64_LAR_FILE_META_DA_TAG:0] tag;

	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] data_type;

	// Same int_type_size goodness as in other modules.
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
} PortOut_LarFile_Read;

typedef struct packed
{
	logic req;
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] data;
	logic [`MSB_POS__SNOW64_LAR_FILE_SH_DA_BASE_ADDR:0] base_addr;
} PortOut_LarFile_MemWrite;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_8:0] base_ptr;
	logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_8:0] offset;
} LarAddr8;


typedef struct packed
{
	logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_16:0] base_ptr;
	logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_16:0] offset;
} LarAddr16;


typedef struct packed
{
	logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_32:0] base_ptr;
	logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_32:0] offset;
} LarAddr32;


typedef struct packed
{
	logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_64:0] base_ptr;
	logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_64:0] offset;
} LarAddr64;

// Used to grab the base_addr from an incoming address
typedef struct packed
{
	logic [`MSB_POS__SNOW64_LAR_FILE_SH_DA_BASE_ADDR:0] base_addr;
	logic [`MSB_POS__SNOW64_LAR_FILE_META_DA_DATA_OFFSET:0] fill;
} LarBaseAddr;



//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_8:0]
//	LarAddr8BasePtr;
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_8:0]
//	LarAddr8DataOffset;
//
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_16:0]
//	LarAddr16BasePtr;
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_16:0]
//	LarAddr16DataOffset;
//
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_32:0]
//	LarAddr32BasePtr;
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_32:0]
//	LarAddr32DataOffset;
//
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_64:0]
//	LarAddr64BasePtr;
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_64:0]
//	LarAddr64DataOffset;



// LAR Metadata stuff


//typedef logic [`MSB_POS__SNOW64_LAR_FILE_META_DA_DATA_OFFSET:0]
//	LarMetaDaDataOffset;

//// The LAR's tag... specifies which shared data is used by this LAR.
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_META_DA_TAG:0] LarMetaDaTag;

//// See PkgSnow64Cpu::DataType.
//typedef logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] LarMetaDaDataType;

//// See PkgSnow64Cpu::IntTypeSize.
//typedef logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] LarMetaDaIntTypeSize;


// LAR Shared Data stuff

//// The base address, used for associativity between LARs.
//// We really do only need one copy of this.
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_SH_DA_BASE_ADDR:0]
//	LarShDaBaseAddr;

//// The data itself.
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_SH_DA_DATA:0] LarShDaData;

//// The reference count.
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_SH_DA_REF_COUNT:0]
//	LarShDaRefCount;

//// The "dirty" flag.  Used to determine if we should write back to memory.
//typedef logic LarShDaDirty;

endpackage : PkgSnow64LarFile
