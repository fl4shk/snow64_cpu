`include "src/snow64_operand_manager_defines.header.sv"


package PkgSnow64OperandManager;

typedef logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] VectorData;
typedef logic [`MSB_POS__SNOW64_SCALAR_DATA:0] ScalarData;

typedef logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0] LarTag;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET:0]
	DataOffset;
typedef logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0]
	LarBaseAddr;
typedef logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] IntTypeSize;
typedef logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] DataType;

typedef struct packed
{
	LarTag tag;
	DataOffset data_offset;

	VectorData data;

	DataType data_type;
	IntTypeSize int_type_size;

} PartialPortIn_OperandManager_RegData;


typedef struct packed
{
	logic enable;
	logic perf_cast_rb, perf_cast_rc;
	logic op_type;

	PartialPortIn_OperandManager_RegData
		ra_curr_data, rb_curr_data, rc_curr_data;

	VectorData past_computed_data;

} PortIn_OperandManager;


typedef struct packed
{
	logic stall;
	VectorData ra_vector_data, rb_vector_data, rc_vector_data;
	ScalarData ra_scalar_data, rb_scalar_data, rc_scalar_data;
} PortOut_OperandManager;


endpackage : PkgSnow64OperandManager
