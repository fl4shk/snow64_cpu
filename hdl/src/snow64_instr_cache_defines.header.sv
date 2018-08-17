`ifndef src__slash__snow64_instr_cache_defines_header_sv
`define src__slash__snow64_instr_cache_defines_header_sv

// src/snow64_instr_cache_defines.header.sv

`include "src/misc_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"
`include "src/snow64_instr_decoder_defines.header.sv"



// A single icache line is as long as a single LAR
`define WIDTH__SNOW64_ICACHE_LINE_DATA `WIDTH__SNOW64_LAR_FILE_DATA
`define MSB_POS__SNOW64_ICACHE_LINE_DATA \
	`WIDTH2MP(`WIDTH__SNOW64_ICACHE_LINE_DATA)

`define WIDTH__SNOW64_ICACHE_LINE_PACKED_OUTER_DIM `WIDTH__SNOW64_INSTR
`define MSB_POS__SNOW64_ICACHE_LINE_PACKED_OUTER_DIM \
	`WIDTH2MP(`WIDTH__SNOW64_ICACHE_LINE_PACKED_OUTER_DIM)

`define WIDTH__SNOW64_ICACHE_LINE_PACKED_INNER_DIM \
	(`WIDTH__SNOW64_ICACHE_LINE_DATA \
	/ `WIDTH__SNOW64_ICACHE_LINE_PACKED_OUTER_DIM)
`define MSB_POS__SNOW64_ICACHE_LINE_PACKED_INNER_DIM \
	`WIDTH2MP(`WIDTH__SNOW64_ICACHE_LINE_PACKED_INNER_DIM)

// "Base address" here is similar to that of a data LAR.
// The top `WIDTH__SNOW64_ICACHE_BASE_ADDR bits of an address are used for
// the index into the icache.
`define WIDTH__SNOW64_ICACHE_INCOMING_ADDR__BASE_ADDR 15
`define MSB_POS__SNOW64_ICACHE_INCOMING_ADDR__BASE_ADDR \
	`WIDTH2MP(`WIDTH__SNOW64_ICACHE_INCOMING_ADDR__BASE_ADDR)

`define WIDTH__SNOW64_ICACHE_INCOMING_ADDR__LINE_INDEX \
	($clog2(`WIDTH__SNOW64_ICACHE_LINE_PACKED_INNER_DIM))
`define MSB_POS__SNOW64_ICACHE_INCOMING_ADDR__LINE_INDEX \
	`WIDTH2MP(`WIDTH__SNOW64_ICACHE_INCOMING_ADDR__LINE_INDEX)

`define WIDTH__SNOW64_ICACHE_LINE_BYTE_INDEX \
	$clog2(`WIDTH__SNOW64_ICACHE_LINE_PACKED_INNER_DIM)
`define MSB_POS__SNOW64_ICACHE_LINE_BYTE_INDEX \
	`WIDTH2MP(`WIDTH__SNOW64_ICACHE_LINE_BYTE_INDEX)

`define WIDTH__SNOW64_ICACHE_INCOMING_ADDR__DONT_CARE \
	`MSB_POS__SNOW64_ICACHE_LINE_BYTE_INDEX \
	- $clog2(`WIDTH__SNOW64_ICACHE_LINE_PACKED_INNER_DIM / 8)
`define MSB_POS__SNOW64_ICACHE_INCOMING_ADDR__DONT_CARE \
	`WIDTH2MP(`WIDTH__SNOW64_ICACHE_INCOMING_ADDR__DONT_CARE)

`define WIDTH__SNOW64_ICACHE_INCOMING_ADDR__TAG \
	(`WIDTH__SNOW64_CPU_ADDR \
	- `WIDTH__SNOW64_ICACHE_INCOMING_ADDR__BASE_ADDR \
	- `WIDTH__SNOW64_ICACHE_INCOMING_ADDR__LINE_INDEX \
	- `WIDTH__SNOW64_ICACHE_INCOMING_ADDR__DONT_CARE)
`define MSB_POS__SNOW64_ICACHE_INCOMING_ADDR__TAG \
	`WIDTH2MP(`WIDTH__SNOW64_ICACHE_INCOMING_ADDR__TAG)

// 32 kiB instruction cache
`define ARR_SIZE__SNOW64_ICACHE_NUM_LINES \
	((1 << `WIDTH__SNOW64_ICACHE_INCOMING_ADDR__BASE_ADDR) \
	/ (`WIDTH__SNOW64_ICACHE_LINE_PACKED_OUTER_DIM))
`define LAST_INDEX__SNOW64_ICACHE_NUM_LINES \
	`ARR_SIZE_TO_LAST_INDEX(ARR_SIZE__SNOW64_ICACHE_NUM_LINES)

`endif		// src__slash__snow64_instr_cache_defines_header_sv
