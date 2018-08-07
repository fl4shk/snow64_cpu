`ifndef src__slash__snow64_cpu_defines_header_sv
`define src__slash__snow64_cpu_defines_header_sv

// src/snow64_cpu_defines.header.sv

`include "src/misc_defines.header.sv"

`define WIDTH__SNOW64_CPU_ADDR 64
`define MSB_POS__SNOW64_CPU_ADDR `WIDTH2MP(`WIDTH__SNOW64_CPU_ADDR)

`define WIDTH__SNOW64_CPU_DATA_TYPE 2
`define MSB_POS__SNOW64_CPU_DATA_TYPE \
	`WIDTH2MP(`WIDTH__SNOW64_CPU_DATA_TYPE)

`define WIDTH__SNOW64_CPU_INT_TYPE_SIZE 2
`define MSB_POS__SNOW64_CPU_INT_TYPE_SIZE \
	`WIDTH2MP(`WIDTH__SNOW64_CPU_INT_TYPE_SIZE)

`define WIDTH__SNOW64_SIZE_64 64
`define MSB_POS__SNOW64_SIZE_64 \
	`WIDTH2MP(`WIDTH__SNOW64_SIZE_64)
`define WIDTH__SNOW64_SIZE_32 32
`define MSB_POS__SNOW64_SIZE_32 \
	`WIDTH2MP(`WIDTH__SNOW64_SIZE_32)
`define WIDTH__SNOW64_SIZE_16 16
`define MSB_POS__SNOW64_SIZE_16 \
	`WIDTH2MP(`WIDTH__SNOW64_SIZE_16)
`define WIDTH__SNOW64_SIZE_8 8
`define MSB_POS__SNOW64_SIZE_8 \
	`WIDTH2MP(`WIDTH__SNOW64_SIZE_8)


`endif		// src__slash__snow64_cpu_defines_header_sv
