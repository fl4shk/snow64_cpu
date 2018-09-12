`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_bfloat16_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"

package PkgSnow64IntCaster;
	typedef logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] LarData;



	typedef struct packed
	{
		LarData to_cast;

		logic src_signedness;
		logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
			src_int_type_size, dst_int_type_size;
	} PortIn_IntCaster;

	typedef struct packed
	{
		LarData data;
	} PortOut_IntCaster;

endpackage : PkgSnow64IntCaster
