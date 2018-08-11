`ifndef src__slash__snow64_memory_bus_guard_defines_header_sv
`define src__slash__snow64_memory_bus_guard_defines_header_sv

// src/snow64_memory_bus_guard_defines.header.sv

`include "src/misc_defines.header.sv"
//`include "src/snow64_cpu_defines.header.sv"

`define WIDTH__SNOW64_MEMORY_BUS_GUARD__STATE 1
`define MSB_POS__SNOW64_MEMORY_BUS_GUARD__STATE \
	`WIDTH2MP(`WIDTH__SNOW64_MEMORY_BUS_GUARD__STATE)

`define WIDTH__SNOW64_MEMORY_BUS_GUARD__REQUEST_TYPE 2
`define MSB_POS__SNOW64_MEMORY_BUS_GUARD__REQUEST_TYPE \
	`WIDTH2MP(`WIDTH__SNOW64_MEMORY_BUS_GUARD__REQUEST_TYPE)


`endif		// src__slash__snow64_memory_bus_guard_defines_header_sv
