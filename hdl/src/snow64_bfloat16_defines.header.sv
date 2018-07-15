`ifndef src__slash__snow64_bfloat16_defines_header_sv
`define src__slash__snow64_bfloat16_defines_header_sv

// src/snow64_bfloat16_defines.header.sv

`include "src/snow64_cpu_defines.header.sv"

`define WIDTH__SNOW64_BFLOAT16_ITSELF 16
`define MSB_POS__SNOW64_BFLOAT16_ITSELF \
	`WIDTH2MP(`WIDTH__SNOW64_BFLOAT16_ITSELF)

`define WIDTH__SNOW64_BFLOAT16_ENC_SIGN 1
`define MSB_POS__SNOW64_BFLOAT16_ENC_SIGN \
	`WIDTH2MP(`WIDTH__SNOW64_BFLOAT16_ENC_SIGN)

`define WIDTH__SNOW64_BFLOAT16_ENC_EXP 8
`define MSB_POS__SNOW64_BFLOAT16_ENC_EXP \
	`WIDTH2MP(`WIDTH__SNOW64_BFLOAT16_ENC_EXP)

`define WIDTH__SNOW64_BFLOAT16_ENC_MANTISSA 7
`define MSB_POS__SNOW64_BFLOAT16_ENC_MANTISSA \
	`WIDTH2MP(`WIDTH__SNOW64_BFLOAT16_ENC_MANTISSA)

// That's right, here we have a state machine for the BFloat16 adder... we
// don't get to have single cycle execution for bfloat16s.
`define WIDTH__SNOW64_BFLOAT16_ADD_STATE 3
`define MSB_POS__SNOW64_BFLOAT16_ADD_STATE \
	`WIDTH2MP(`WIDTH__SNOW64_BFLOAT16_ADD_STATE)


`define BFLOAT16_IS_NORMAL(x) \
	((x.enc_exp != PkgSnow64BFloat16::NON_NORMAL_ENC_EXP_A) \
	&& (x.enc_exp != PkgSnow64BFloat16::NON_NORMAL_ENC_EXP_B))

`define BFLOAT16_FRAC(x) \
	(`BFLOAT16_IS_NORMAL(x) \
	? {1'b1, x.enc_mantissa} \
	: {{PkgSnow64BFloat16::WIDTH__FRAC{1'b0}}})


`endif		// src__slash__snow64_bfloat16_defines_header_sv
