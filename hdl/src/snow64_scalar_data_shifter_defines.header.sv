`ifndef src__slash__snow64_scalar_data_shifter_defines_header_sv
`define src__slash__snow64_scalar_data_shifter_defines_header_sv

// src/snow64_scalar_data_shifter_defines.header.sv

`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"

`define WIDTH__SNOW64_SCALAR_DATA `WIDTH__SNOW64_SIZE_64
`define MSB_POS__SNOW64_SCALAR_DATA `WIDTH2MP(`WIDTH__SNOW64_SCALAR_DATA)

`endif		// src__slash__snow64_scalar_data_shifter_defines_header_sv
