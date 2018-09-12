`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_bfloat16_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"

package PkgSnow64IntCaster;
	typedef logic [`MSB_POS__SNOW64_SCALAR_DATA:0] ScalarData;
	typedef logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] VectorData;

	typedef struct packed
	{
		ScalarData to_cast;
		logic src_signedness;

		logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
			src_int_type_size, dst_int_type_size;
	} PortIn_SubIntCaster;

	typedef struct packed
	{
		ScalarData data;
	} PortOut_SubIntCaster;


	typedef enum logic
	{
		IntCastTypScalar,
		IntCastTypVector
	} IntCastType;

	typedef struct packed
	{
		logic int_cast_type;

		ScalarData scalar_data;
		VectorData vector_data;

		logic src_signedness;
		logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
			src_int_type_size, dst_int_type_size;
	} PortIn_IntCaster;

	typedef struct packed
	{
		ScalarData scalar_data;
		VectorData vector_data;
	} PortOut_IntCaster;

endpackage : PkgSnow64IntCaster
