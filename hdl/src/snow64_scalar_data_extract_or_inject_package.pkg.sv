`include "src/snow64_scalar_data_extract_or_inject_defines.header.sv"

package PkgSnow64ScalarDataExtractOrInject;

typedef logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] LarData;
typedef logic [`MSB_POS__SNOW64_SCALAR_DATA:0] ScalarData;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET:0]
	DataOffset;

typedef struct packed
{
	LarData to_shift;
	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] data_type;
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
	DataOffset data_offset;
} PortIn_ScalarDataExtractor;

typedef struct packed
{
	ScalarData data;
} PortOut_ScalarDataExtractor;



typedef struct packed
{
	LarData to_modify;
	ScalarData to_shift;
	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] data_type;
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
	DataOffset data_offset;
} PortIn_ScalarDataInjector;

typedef struct packed
{
	LarData data;
} PortOut_ScalarDataInjector;


endpackage : PkgSnow64ScalarDataExtractOrInject
