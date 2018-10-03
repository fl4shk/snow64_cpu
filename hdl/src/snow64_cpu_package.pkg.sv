`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"

package PkgSnow64Cpu;

typedef logic [`MSB_POS__SNOW64_CPU_ADDR:0] CpuAddr;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] LarData;

typedef enum logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0]
{
	// Put "DataTypUnsgnInt" and "DataTypSgnInt" in this order so that we
	// can just do "some_data_type[0]" to get the value for the
	// "type_signedness" input that some modules have.
	DataTypUnsgnInt,
	DataTypSgnInt,

	// Snow64 only has BFloat16's for its floating point numbers.
	DataTypBFloat16,

	// We don't really have another format here.  A future data LARs
	// machine may support, for example, fixed-point numbers in the
	// hardware.  (I have some ideas for that myself, but I'm not going
	// into that here).
	// 
	// Another alternative might be to change "DataTypBFloat16" to
	// "DataTypFloat32" and also to change "DataTypReserved" to
	// "DataTypFloat64" if both binary32 and binary64 floats are supported,
	// but no other floating point types are supported.
	DataTypReserved
} DataType;

// Integers are the only types that rely on this "enum"... though perhaps
// that will change.
typedef enum logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
{
	IntTypSz8,
	IntTypSz16,
	IntTypSz32,
	IntTypSz64
} IntTypeSize;


`ifdef FORMAL
typedef enum logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
{
	FormalVecMulIntTypSz1,
	FormalVecMulIntTypSz2,
	FormalVecMulIntTypSz4,
	FormalVecMulIntTypSz8
} FormalMulIntTypeSize;
`endif		// FORMAL



typedef enum logic
{
	MemAccTypRead,
	MemAccTypWrite
} MemAccessType;


// Used for memory access 
typedef struct packed
{
	logic valid;
	LarData data;
} PortIn_Cpu;

//typedef struct packed
//{
//	logic req;
//
//	logic access_type;
//
//	CpuAddr addr;
//	LarData data;
//} PortOut_Cpu;

typedef struct packed
{
	logic req;
	CpuAddr addr;
	LarData data;
	// Are we requesting a read or a write?
	logic mem_acc_type;
} PortOut_Cpu;


// Used for operand forwarding
typedef struct packed
{
	logic valid;
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] data;
	logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0] base_addr;
} ComputedData;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET:0] data_offset;
	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] data_type;
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;

	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] data;
	logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0] base_addr;
} TrueLarData;


endpackage : PkgSnow64Cpu
