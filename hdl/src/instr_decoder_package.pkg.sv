`include "src/instr_decoder_defines.header.sv"

package PkgInstrDecoder;

// Group 0 instructions:  ALU/FPU stuffs
typedef enum logic [`MSB_POS__SNOW64_IENC_OPCODE:0]
{
	Add_ThreeRegs,
	Sub_ThreeRegs,
	Slt_ThreeRegs,
	Mul_ThreeRegs,

	Div_ThreeRegs,
	And_ThreeRegs,
	Orr_ThreeRegs,
	Xor_ThreeRegs,

	Shl_ThreeRegs,
	Shr_ThreeRegs,
	Inv_ThreeRegs,
	Not_ThreeRegs,

	Add_OneRegOnePcOneSimm12,
	Bad0_Iog0,
	Bad1_Iog0,
	Bad2_Iog0
} Iog0Oper;

// Group 1 instructions:  control flow and interrupts stuff
typedef enum logic [`MSB_POS__SNOW64_IENC_OPCODE:0]
{
	Btru_OneRegOneSimm20,
	Bfal_OneRegOneSimm20,
	Jmp_OneReg,
	Ei_NoArgs,

	Di_NoArgs,
	Reti_NoArgs,
	Cpy_OneRegOneIe,
	Cpy_OneRegOneIreta,

	Cpy_OneRegOneIdsta,
	Cpy_OneIeOneReg,
	Cpy_OneIretaOneReg,
	Cpy_OneIdstaOneReg,

	Bad0_Iog1,
	Bad1_Iog1,
	Bad2_Iog1,
	Bad3_Iog1
} Iog1Oper;

// Group 2 instructions:  loads
typedef enum logic [`MSB_POS__SNOW64_IENC_OPCODE:0]
{
	LdU8_ThreeRegsOneSimm12,
	LdS8_ThreeRegsOneSimm12,
	LdU16_ThreeRegsOneSimm12,
	LdS16_ThreeRegsOneSimm12,

	LdU32_ThreeRegsOneSimm12,
	LdS32_ThreeRegsOneSimm12,
	LdU64_ThreeRegsOneSimm12,
	LdS64_ThreeRegsOneSimm12,

	LdF16_ThreeRegsOneSimm12,
	Bad0_Iog2,
	Bad1_Iog2,
	Bad2_Iog2,

	Bad3_Iog2,
	Bad4_Iog2,
	Bad5_Iog2,
	Bad6_Iog2
} Iog2Oper;

// Group 3 instructions:  stores
typedef enum logic [`MSB_POS__SNOW64_IENC_OPCODE:0]
{
	StU8_ThreeRegsOneSimm12,
	StS8_ThreeRegsOneSimm12,
	StU16_ThreeRegsOneSimm12,
	StS16_ThreeRegsOneSimm12,

	StU32_ThreeRegsOneSimm12,
	StS32_ThreeRegsOneSimm12,
	StU64_ThreeRegsOneSimm12,
	StS64_ThreeRegsOneSimm12,

	StF16_ThreeRegsOneSimm12,
	Bad0_Iog3,
	Bad1_Iog3,
	Bad2_Iog3,

	Bad3_Iog3,
	Bad4_Iog3,
	Bad5_Iog3,
	Bad6_Iog3
} Iog3Oper;

// Group 4 instructions:  port-mapped input and output
typedef enum logic [`MSB_POS__SNOW64_IENC_OPCODE:0]
{
	InU8_TwoRegsOneSimm16,
	InS8_TwoRegsOneSimm16,
	InU16_TwoRegsOneSimm16,
	InS16_TwoRegsOneSimm16,

	InU32_TwoRegsOneSimm16,
	InS32_TwoRegsOneSimm16,
	InU64_TwoRegsOneSimm16,
	InS64_TwoRegsOneSimm16,

	Out_TwoRegsOneSimm16,
	Bad0_Iog4,
	Bad1_Iog4,
	Bad2_Iog4,

	Bad3_Iog4,
	Bad4_Iog4,
	Bad5_Iog4,
	Bad6_Iog4
} Iog4Oper;

endpackage : PkgInstrDecoder
