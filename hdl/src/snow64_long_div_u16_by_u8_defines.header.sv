`ifndef src__slash__snow64_long_div_u16_by_u8_defines_header_sv
`define src__slash__snow64_long_div_u16_by_u8_defines_header_sv

// src/snow64_long_div_u16_by_u8_defines.header.sv

`include "src/misc_defines.header.sv"

`define WIDTH__SNOW64_LONG_DIV_U16_BY_U8_IN_A 16
`define MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_IN_A \
	`WIDTH2MP(`WIDTH__SNOW64_LONG_DIV_U16_BY_U8_IN_A)

`define WIDTH__SNOW64_LONG_DIV_U16_BY_U8_IN_B 8
`define MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_IN_B \
	`WIDTH2MP(`WIDTH__SNOW64_LONG_DIV_U16_BY_U8_IN_B)

`define WIDTH__SNOW64_LONG_DIV_U16_BY_U8_OUT_DATA 16
`define MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_OUT_DATA \
	`WIDTH2MP(`WIDTH__SNOW64_LONG_DIV_U16_BY_U8_OUT_DATA)

`endif		// src__slash__snow64_long_div_u16_by_u8_defines_header_sv
