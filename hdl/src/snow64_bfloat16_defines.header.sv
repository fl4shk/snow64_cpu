`ifndef src__slash__snow64_bfloat16_defines_header_sv
`define src__slash__snow64_bfloat16_defines_header_sv

// src/snow64_bfloat16_defines.header.sv

`include "src/snow64_cpu_defines.header.sv"

`define WIDTH__SNOW64_BFLOAT16_FPU_OPER 4
`define MSB_POS__SNOW64_BFLOAT16_FPU_OPER \
	`WIDTH2MP(`WIDTH__SNOW64_BFLOAT16_FPU_OPER)

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
`define WIDTH__SNOW64_BFLOAT16_ADD_STATE 2
`define MSB_POS__SNOW64_BFLOAT16_ADD_STATE \
	`WIDTH2MP(`WIDTH__SNOW64_BFLOAT16_ADD_STATE)

`define WIDTH__SNOW64_BFLOAT16_MUL_STATE 1
`define MSB_POS__SNOW64_BFLOAT16_MUL_STATE \
	`WIDTH2MP(`WIDTH__SNOW64_BFLOAT16_MUL_STATE)

`define WIDTH__SNOW64_BFLOAT16_DIV_STATE 2
`define MSB_POS__SNOW64_BFLOAT16_DIV_STATE \
	`WIDTH2MP(`WIDTH__SNOW64_BFLOAT16_DIV_STATE)

`define SNOW64_BFLOAT16_BIAS 8'd127
//`define SNOW64_BFLOAT16_MODDED_BIAS (`SNOW64_BFLOAT16_BIAS + 8'd7)
`define SNOW64_BFLOAT16_MODDED_BIAS (8'd134)
`define SNOW64_BFLOAT16_MAX_ENC_EXP `WIDTH__SNOW64_BFLOAT16_ENC_EXP'hff
`define SNOW64_BFLOAT16_MAX_SATURATED_ENC_EXP \
	`WIDTH__SNOW64_BFLOAT16_ENC_EXP'hfe
`define SNOW64_BFLOAT16_MAX_SATURATED_DATA_ABS \
	`WIDTH__SNOW64_BFLOAT16_ITSELF'h7f7f

`define WIDTH__SNOW64_BFLOAT16_FRAC \
	(`WIDTH__SNOW64_BFLOAT16_ENC_MANTISSA + 1)
`define MSB_POS__SNOW64_BFLOAT16_FRAC \
	`WIDTH2MP(`WIDTH__SNOW64_BFLOAT16_FRAC)

`define SNOW64_BFLOAT16_MUL_SIGNIFICAND_NUM_BUFFER_BITS 7

`define SNOW64_BFLOAT16_NON_NORMAL_ENC_EXP_A 8'd0
`define SNOW64_BFLOAT16_NON_NORMAL_ENC_EXP_B 8'd255

`define SNOW64_BFLOAT16_IS_NORMAL(x) \
	((x.enc_exp != `SNOW64_BFLOAT16_NON_NORMAL_ENC_EXP_A) \
	&& (x.enc_exp != `SNOW64_BFLOAT16_NON_NORMAL_ENC_EXP_B))

`define SNOW64_BFLOAT16_FRAC(x) \
	(`SNOW64_BFLOAT16_IS_NORMAL(x) \
	? {1'b1, x.enc_mantissa} \
	: {{`WIDTH__SNOW64_BFLOAT16_FRAC{1'b0}}})

`define SNOW64_ABS(val, high_bit) \
	val[high_bit] ? (-val[high_bit:0]) : val[high_bit:0]

`endif		// src__slash__snow64_bfloat16_defines_header_sv
