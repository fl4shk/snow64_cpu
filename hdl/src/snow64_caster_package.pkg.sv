`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_bfloat16_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"

package PkgSnow64Caster;
	typedef logic [`MSB_POS__SNOW64_SCALAR_DATA:0] ScalarData;
	typedef logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] LarData;

	typedef struct packed
	{
		ScalarData to_cast;

		logic src_type_signedness;
		logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
			src_int_type_size, dst_int_type_size;
	} PortIn_IntScalarCaster;

	typedef struct packed
	{
		ScalarData data;
	} PortOut_IntScalarCaster;



	typedef struct packed
	{
		LarData to_cast;

		logic src_type_signedness;
		logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
			src_int_type_size, dst_int_type_size;
	} PortIn_IntVectorCaster;

	typedef struct packed
	{
		LarData data;
	} PortOut_IntVectorCaster;

	typedef struct packed
	{
		logic start, from_int_or_to_int;

		LarData to_cast;
		logic type_signedness;
		logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
	} PortIn_ToOrFromBFloat16VectorCaster;

	typedef struct packed
	{
		logic valid;
		LarData data;
	} PortOut_ToOrFromBFloat16VectorCaster;

endpackage : PkgSnow64Caster
