`ifndef src__slash__snow64_lar_file_defines_header_sv
`define src__slash__snow64_lar_file_defines_header_sv

// src/snow64_lar_file_defines.header.sv

//`include "src/misc_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"

`define ARR_SIZE__SNOW64_LAR_FILE_NUM_LARS 16
`define LAST_INDEX__SNOW64_LAR_FILE_NUM_LARS  \
	`ARR_SIZE_TO_LAST_INDEX(`ARR_SIZE__SNOW64_LAR_FILE_NUM_LARS)

`define WIDTH__SNOW64_LAR_FILE_DATA 256
`define MSB_POS__SNOW64_LAR_FILE_DATA \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_DATA)

`define WIDTH__SNOW64_LAR_FILE_INDEX 4
`define MSB_POS__SNOW64_LAR_FILE_INDEX \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_INDEX)

// 8-bit
`define WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_8 5
`define MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_8 \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_8)

`define WIDTH__SNOW64_LAR_FILE_ADDR_BASE_PTR_8 \
	(`WIDTH__SNOW64_CPU_ADDR - `WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_8)
`define MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_8 \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_ADDR_BASE_PTR_8)


// 16-bit
`define WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_16 4
`define MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_16 \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_16)

`define WIDTH__SNOW64_LAR_FILE_ADDR_BASE_PTR_16 \
	(`WIDTH__SNOW64_CPU_ADDR - `WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_16)
`define MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_16 \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_ADDR_BASE_PTR_16)


// 32-bit
`define WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_32 3
`define MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_32 \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_32)

`define WIDTH__SNOW64_LAR_FILE_ADDR_BASE_PTR_32 \
	(`WIDTH__SNOW64_CPU_ADDR - `WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_32)
`define MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_32 \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_ADDR_BASE_PTR_32)


// 64-bit
`define WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_64 2
`define MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_64 \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_64)

`define WIDTH__SNOW64_LAR_FILE_ADDR_BASE_PTR_64 \
	(`WIDTH__SNOW64_CPU_ADDR - `WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_64)
`define MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_64 \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_ADDR_BASE_PTR_64)


// Metadata stuff
`define WIDTH__SNOW64_LAR_FILE_METADATA_DATA_OFFSET \
	`WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_8
`define MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_METADATA_DATA_OFFSET)

// A "tag" in this case is which refers to the index of the shared data
// that this LAR cares about.
`define WIDTH__SNOW64_LAR_FILE_METADATA_TAG `WIDTH__SNOW64_LAR_FILE_INDEX
`define MSB_POS__SNOW64_LAR_FILE_METADATA_TAG \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_METADATA_TAG)


// Shared data stuff
`define WIDTH__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR \
	`WIDTH__SNOW64_LAR_FILE_ADDR_BASE_PTR_8
`define MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR)


`define WIDTH__SNOW64_LAR_FILE_SHAREDDATA_DATA `WIDTH__SNOW64_LAR_FILE_DATA
`define MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_DATA \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_SHAREDDATA_DATA)


// It is technically possible for all the non-dzero LARs' metadata to point
// to the same shared data, though this is uncommon in practice.
`define WIDTH__SNOW64_LAR_FILE_SHAREDDATA_REF_COUNT \
	`WIDTH__SNOW64_LAR_FILE_METADATA_TAG
`define MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_REF_COUNT \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_SHAREDDATA_REF_COUNT)


`define WIDTH__SNOW64_LAR_FILE_SHAREDDATA_DIRTY 1
`define MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_DIRTY \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_SHAREDDATA_DIRTY)

`define WIDTH__SNOW64_LAR_FILE_WRITE_TYPE 2
`define MSB_POS__SNOW64_LAR_FILE_WRITE_TYPE \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_WRITE_TYPE)

`define SNOW64_LAR_FILE_BASE_ADDR_TO_ADDR(some_base_addr) \
	{(some_base_addr), \
	{`WIDTH__SNOW64_LAR_FILE_METADATA_DATA_OFFSET{1'b0}}}

`define WIDTH__SNOW64_LAR_FILE_WRITE_LOAD_STATE 2
`define MSB_POS__SNOW64_LAR_FILE_WRITE_LOAD_STATE \
	`WIDTH2MP(`WIDTH__SNOW64_LAR_FILE_WRITE_LOAD_STATE)

`endif		// src__slash__snow64_lar_file_defines_header_sv
