`ifndef src__slash__snow64_instr_decoder_defines_header_sv
`define src__slash__snow64_instr_decoder_defines_header_sv

// src/snow64_instr_decoder_defines.header.sv

`include "src/misc_defines.header.sv"

// A maximum of 8 basic instruction groups.  If necessary, "extended"
// instruction groups may be added.
`define WIDTH__SNOW64_IENC_GROUP 3
`define MSB_POS__SNOW64_IENC_GROUP `WIDTH2MP(`WIDTH__SNOW64_IENC_GROUP)

`define WIDTH__SNOW64_IENC_REG_INDEX 4
`define MSB_POS__SNOW64_IENC_REG_INDEX \
	`WIDTH2MP(`WIDTH__SNOW64_IENC_REG_INDEX)

`define WIDTH__SNOW64_IENC_OPCODE 4
`define MSB_POS__SNOW64_IENC_OPCODE `WIDTH2MP(`WIDTH__SNOW64_IENC_OPCODE)

`define WIDTH__SNOW64_IENC_IOG0_SIMM12 12
`define MSB_POS__SNOW64_IENC_IOG0_SIMM12 \
	`WIDTH2MP(`WIDTH__SNOW64_IENC_IOG0_SIMM12)

`define WIDTH__SNOW64_IENC_IOG1_SIMM20 20
`define MSB_POS__SNOW64_IENC_IOG1_SIMM20 \
	`WIDTH2MP(`WIDTH__SNOW64_IENC_IOG1_SIMM20)

`define WIDTH__SNOW64_IENC_IOG2_SIMM12 12
`define MSB_POS__SNOW64_IENC_IOG2_SIMM12 \
	`WIDTH2MP(`WIDTH__SNOW64_IENC_IOG2_SIMM12)

`define WIDTH__SNOW64_IENC_IOG3_SIMM12 12
`define MSB_POS__SNOW64_IENC_IOG3_SIMM12 \
	`WIDTH2MP(`WIDTH__SNOW64_IENC_IOG3_SIMM12)

`define WIDTH__SNOW64_IENC_IOG4_SIMM16 16
`define MSB_POS__SNOW64_IENC_IOG4_SIMM16 \
	`WIDTH2MP(`WIDTH__SNOW64_IENC_IOG4_SIMM16)

`endif		// src__slash__snow64_instr_decoder_defines_header_sv
