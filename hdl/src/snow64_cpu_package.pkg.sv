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





typedef struct packed
{
	// Request an interrrupt.
	logic req;
} PartialPortIn_Cpu_Interrupt;



typedef enum logic
{
	ExtDatAccTypRead,
	ExtDatAccTypWrite
} ExtDataAccessType;


// Used for both memory access and port-mapped IO.
// Just as an aside, "Ext" stands for "external".
typedef struct packed
{
	logic busy;
	LarData data;
} PartialPortIn_Cpu_ExtDataAccess;

typedef struct packed
{
	logic req;
	ExtDataAccessType access_type;

	// Both memory and port-mapped IO are assumed to use 64-bit addresses,
	// at least from the CPU's perspective.
	// 
	// It's still technically possible to use smaller memory.
	CpuAddr addr;

	// Output data.
	LarData data;
} PartialPortOut_Cpu_ExtDataAccess;



typedef struct packed
{
	logic [`MPOFTYPE(PartialPortIn_Cpu_Interrupt):0]
		interrupt;
	logic [`MPOFTYPE(PartialPortIn_Cpu_ExtDataAccess):0]
		ext_dat_acc_mem, ext_dat_acc_port_mapped_io;
} PortIn_Cpu;


typedef struct packed
{
	logic [`MPOFTYPE(PartialPortOut_Cpu_ExtDataAccess):0]
		ext_dat_acc_mem, ext_dat_acc_port_mapped_io;
} PortOut_Cpu;

endpackage : PkgSnow64Cpu
