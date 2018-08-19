`ifndef src__slash__snow64_memory_access_fifo_defines_header_sv
`define src__slash__snow64_memory_access_fifo_defines_header_sv

// src/snow64_memory_access_fifo_defines.header.sv

//`include "src/misc_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"

`define WIDTH__SNOW64_MEMORY_ACCESS_FIFO__DATA `WIDTH__SNOW64_LAR_FILE_DATA
`define MSB_POS__SNOW64_MEMORY_ACCESS_FIFO__DATA \
	`WIDTH2MP(`WIDTH__SNOW64_MEMORY_ACCESS_FIFO__DATA)


`endif		// src__slash__snow64_memory_access_fifo_defines_header_sv
