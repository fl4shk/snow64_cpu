`ifndef src__slash__snow64_instr_cache_defines_header_sv
`define src__slash__snow64_instr_cache_defines_header_sv

// src/snow64_instr_cache_defines.header.sv

`include "src/misc_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"

// "Base address" here is similar to that of a data LAR.
// The top `WIDTH__SNOW64_ICACHE_BASE_ADDR bits of an address are used for
// the index into the icache.
`define WIDTH__SNOW64_ICACHE_BASE_ADDR 15
`define MSB_POS__SNOW64_ICACHE_BASE_ADDR \
	`WIDTH2MP(`WIDTH__SNOW64_ICACHE_BASE_ADDR)

// 32 kiB instruction cache
`define ARR_SIZE__SNOW64_ICACHE_NUM_ENTRIES \
	(1 << `WIDTH__SNOW64_ICACHE_BASE_ADDR)
`define LAST_INDEX__SNOW64_ICACHE_NUM_ENTRIES \
	`ARR_SIZE_TO_LAST_INDEX(ARR_SIZE__SNOW64_ICACHE_NUM_ENTRIES)

// A single icache line is as long as a single LAR
`define WIDTH__SNOW64_ICACHE_LINE `WIDTH__SNOW64_LAR_FILE_DATA
`define MSB_POS__SNOW64_ICACHE_LINE \
	`WIDTH2MP(`WIDTH__SNOW64_ICACHE_LINE)

`endif		// src__slash__snow64_instr_cache_defines_header_sv
