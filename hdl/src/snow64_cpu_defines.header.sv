`ifndef src__slash__snow64_cpu_defines_header_sv
`define src__slash__snow64_cpu_defines_header_sv

// src/snow64_cpu_defines.header.sv

`include "src/misc_defines.header.sv"

`define WIDTH__SNOW64_CPU_ADDR 64
`define MSB_POS__SNOW64_CPU_ADDR `WIDTH2MP(`WIDTH__SNOW64_CPU_ADDR)

`define WIDTH__SNOW64_CPU_TYPE_SIZE 2
`define MSB_POS__SNOW64_CPU_TYPE_SIZE \
	`WIDTH2MP(`WIDTH__SNOW64_CPU_TYPE_SIZE)

`endif		// src__slash__snow64_cpu_defines_header_sv
