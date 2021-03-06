`include "src/snow64_instr_decoder_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"

package PkgSnow64InstrDecoder;

typedef logic [`MSB_POS__SNOW64_IENC_GROUP:0] InstrGroup;
typedef logic [`MSB_POS__SNOW64_IENC_REG_INDEX:0] InstrRegIndex;
typedef logic [`MSB_POS__SNOW64_IENC_OPCODE:0] InstrOper;
typedef logic [`MSB_POS__SNOW64_CPU_ADDR:0] CpuAddr;


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
	Inv_TwoRegs,
	Not_TwoRegs,

	Addi_OneRegOnePcOneSimm12,
	Addi_TwoRegsOneSimm12,
	SimSyscall_ThreeRegsOneSimm12,
	Bad_Iog0
} Iog0Oper;

// Group 1 instructions:  control flow and interrupts stuff
typedef enum logic [`MSB_POS__SNOW64_IENC_OPCODE:0]
{
	Bnz_OneRegOneSimm20,
	Bzo_OneRegOneSimm20,
	Jmp_OneReg,
	Bad0_Iog1,

	Bad1_Iog1,
	Bad2_Iog1,
	Bad3_Iog1,
	Bad4_Iog1,


	Bad5_Iog1,
	Bad6_Iog1,
	Bad7_Iog1,
	Bad8_Iog1,

	Bad9_Iog1,
	Bad10_Iog1,
	Bad11_Iog1,
	Bad12_Iog1
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


typedef enum logic
{
	OpTypeScalar,
	OpTypeVector
} OperationType;

localparam WIDTH__INSTR = `WIDTH__SNOW64_INSTR;
localparam MSB_POS__INSTR = `WIDTH2MP(WIDTH__INSTR);
localparam WIDTH__ADDR = `WIDTH__SNOW64_CPU_ADDR;
localparam MSB_POS__ADDR = `WIDTH2MP(WIDTH__ADDR);

localparam WIDTH__IOG0_SIMM12 = `WIDTH__SNOW64_IENC_IOG0_SIMM12;
localparam WIDTH__IOG1_SIMM20 = `WIDTH__SNOW64_IENC_IOG1_SIMM20;
localparam WIDTH__IOG2_SIMM12 = `WIDTH__SNOW64_IENC_IOG2_SIMM12;
localparam WIDTH__IOG3_SIMM12 = `WIDTH__SNOW64_IENC_IOG3_SIMM12;
//localparam WIDTH__IOG4_SIMM16 = `WIDTH__SNOW64_IENC_IOG4_SIMM16;

typedef enum logic [`MSB_POS__SNOW64_DECODED_STALL_TYPE:0]
{
	DecStalTypNone,
	DecStalTypEndsInEx,
	DecStalTypEndsInWb,
	DecStalTypBad
} DecodedStallType;

typedef struct packed
{
	InstrGroup group;
	logic op_type;
	InstrRegIndex ra_index, rb_index, rc_index;
	InstrOper oper;

	// Simply sign extend the immediate value encoded into each
	// instruction.
	// The size of that sign-extended immediate varies by instruction
	// group.
	CpuAddr signext_imm;


	// If this instruction should be treated as a nop.
	logic nop;

	// If this instruction only uses 64-bit integers
	logic forced_64_bit_integers;

	logic [`MSB_POS__SNOW64_DECODED_STALL_TYPE:0] decoded_stall_type;
} PortOut_InstrDecoder;


// Simple instruction decoding mechanism:  "cast" the input to the
// instruction decoder to these structs, and use the fields from the struct
// that has the same group as that struct would.
typedef struct packed
{
	// "group" should be 3'b000
	InstrGroup group;
	logic op_type;
	InstrRegIndex ra_index, rb_index, rc_index;
	logic [`MSB_POS__SNOW64_IENC_OPCODE:0] oper;
	logic [`MSB_POS__SNOW64_IENC_IOG0_SIMM12:0] simm12;
} Iog0Instr;

typedef struct packed
{
	InstrGroup group;
	logic fill;
	InstrRegIndex ra_index;
	InstrOper oper;
	logic [`MSB_POS__SNOW64_IENC_IOG1_SIMM20:0] simm20;
} Iog1Instr;

typedef struct packed
{
	InstrGroup group;
	logic fill;
	InstrRegIndex ra_index, rb_index, rc_index;
	InstrOper oper;
	logic [`MSB_POS__SNOW64_IENC_IOG2_SIMM12:0] simm12;
} Iog2Instr;

typedef struct packed
{
	InstrGroup group;
	logic fill;
	InstrRegIndex ra_index, rb_index, rc_index;
	InstrOper oper;
	logic [`MSB_POS__SNOW64_IENC_IOG3_SIMM12:0] simm12;
} Iog3Instr;


endpackage : PkgSnow64InstrDecoder
