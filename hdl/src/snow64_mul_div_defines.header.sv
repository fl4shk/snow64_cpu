`ifndef src__slash__snow64_mul_div_defines_header_sv
`define src__slash__snow64_mul_div_defines_header_sv

// src/snow64_mul_div_defines.header.sv

`include "src/snow64_alu_defines.header.sv"

`define WIDTH__SNOW64_REGULAR_SUB_MUL_SMALL_DATA `WIDTH__SNOW64_SIZE_16
`define WIDTH__SNOW64_REGULAR_SUB_MUL_MEDIUM_DATA `WIDTH__SNOW64_SIZE_32
`define WIDTH__SNOW64_REGULAR_SUB_MUL_LARGE_DATA `WIDTH__SNOW64_SIZE_64

`define WIDTH__SNOW64_FORMAL_SUB_MUL_SMALL_DATA `WIDTH__SNOW64_SIZE_2
`define WIDTH__SNOW64_FORMAL_SUB_MUL_MEDIUM_DATA `WIDTH__SNOW64_SIZE_4
`define WIDTH__SNOW64_FORMAL_SUB_MUL_LARGE_DATA `WIDTH__SNOW64_SIZE_8



//`ifdef FORMAL
//`define FORMAL_TINY_MUL
//`endif		// FORMAL


`ifdef FORMAL_TINY_MUL
`define WIDTH__SNOW64_SUB_MUL_SMALL_DATA \
	`WIDTH__SNOW64_FORMAL_SUB_MUL_SMALL_DATA
`define WIDTH__SNOW64_SUB_MUL_MEDIUM_DATA \
	`WIDTH__SNOW64_FORMAL_SUB_MUL_MEDIUM_DATA
`define WIDTH__SNOW64_SUB_MUL_LARGE_DATA \
	`WIDTH__SNOW64_FORMAL_SUB_MUL_LARGE_DATA
`else // if !defined(FORMAL_TINY_MUL)
`define WIDTH__SNOW64_SUB_MUL_SMALL_DATA \
	`WIDTH__SNOW64_REGULAR_SUB_MUL_SMALL_DATA
`define WIDTH__SNOW64_SUB_MUL_MEDIUM_DATA \
	`WIDTH__SNOW64_REGULAR_SUB_MUL_MEDIUM_DATA
`define WIDTH__SNOW64_SUB_MUL_LARGE_DATA \
	`WIDTH__SNOW64_REGULAR_SUB_MUL_LARGE_DATA
`endif		// FORMAL_TINY_MUL

`define MSB_POS__SNOW64_SUB_MUL_SMALL_DATA \
	`WIDTH2MP(`WIDTH__SNOW64_SUB_MUL_SMALL_DATA)
`define MSB_POS__SNOW64_SUB_MUL_MEDIUM_DATA \
	`WIDTH2MP(`WIDTH__SNOW64_SUB_MUL_MEDIUM_DATA)
`define MSB_POS__SNOW64_SUB_MUL_LARGE_DATA \
	`WIDTH2MP(`WIDTH__SNOW64_SUB_MUL_LARGE_DATA)

`define WIDTH__SNOW64_MUL_DATA_IN `WIDTH__SNOW64_SUB_MUL_LARGE_DATA
`define MSB_POS__SNOW64_MUL_DATA_IN `WIDTH2MP(`WIDTH__SNOW64_MUL_DATA_IN)

`define WIDTH__SNOW64_MUL_DATA_OUT `WIDTH__SNOW64_SUB_MUL_MEDIUM_DATA
`define MSB_POS__SNOW64_MUL_DATA_OUT `WIDTH2MP(`WIDTH__SNOW64_MUL_DATA_OUT)


`endif		// src__slash__snow64_mul_div_defines_header_sv
