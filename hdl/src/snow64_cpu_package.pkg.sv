`include "src/snow64_cpu_defines.header.sv"

package PkgSnow64Cpu;


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

endpackage : PkgSnow64Cpu
