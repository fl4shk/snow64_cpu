`include "src/snow64_alu_defines.header.sv"

package PkgSnow64Alu;

typedef enum logic [`MSB_POS__SNOW64_CPU_ALU_OPER:0]
{
	OpAdd,
	OpSub,
	OpSlt,
	OpDummy0,

	OpDummy1,
	OpAnd,
	OpOrr,
	OpXor,

	OpShl,
	OpShr,
	OpInv,
	OpNot,

	OpAddAgain,
	OpDummy2,
	OpDummy3,
	OpDummy4
} AluOper;



typedef struct packed
{
	logic [`MSB_POS__SNOW64_CPU_ALU_64_DATA_INOUT:0] a, b;
	logic [`MSB_POS__SNOW64_CPU_ALU_OPER:0] oper;
	logic unsgn_or_sgn;
} PortIn_Alu64;
typedef struct packed
{
	logic [`MSB_POS__SNOW64_CPU_ALU_64_DATA_INOUT:0] data;
} PortOut_Alu64;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_CPU_ALU_32_DATA_INOUT:0] a, b;
	logic [`MSB_POS__SNOW64_CPU_ALU_OPER:0] oper;
	logic unsgn_or_sgn;
} PortIn_Alu32;
typedef struct packed
{
	logic [`MSB_POS__SNOW64_CPU_ALU_32_DATA_INOUT:0] data;
} PortOut_Alu32;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_CPU_ALU_16_DATA_INOUT:0] a, b;
	logic [`MSB_POS__SNOW64_CPU_ALU_OPER:0] oper;
	logic unsgn_or_sgn;
} PortIn_Alu16;
typedef struct packed
{
	logic [`MSB_POS__SNOW64_CPU_ALU_16_DATA_INOUT:0] data;
} PortOut_Alu16;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_CPU_ALU_8_DATA_INOUT:0] a, b;
	logic [`MSB_POS__SNOW64_CPU_ALU_OPER:0] oper;
	logic unsgn_or_sgn;
} PortIn_Alu8;
typedef struct packed
{
	logic [`MSB_POS__SNOW64_CPU_ALU_8_DATA_INOUT:0] data;
} PortOut_Alu8;

//typedef struct packed
//{
//	logic [`MSB_POS__SNOW64_CPU_ALU_SHIFT_DATA_INOUT:0] to_shift;
//	logic [`MSB_POS__SNOW64_CPU_ALU_SHIFT_AMOUNT:0] amount;
//} PortIn_Shift;
//
//typedef struct packed
//{
//	logic [`MSB_POS__SNOW64_CPU_ALU_SHIFT_DATA_INOUT:0] data;
//} PortOut_Shift;

localparam WIDTH__OF_64 = 64;
localparam MSB_POS__OF_64 = `WIDTH2MP(WIDTH__OF_64);
localparam WIDTH__OF_32 = 32;
localparam MSB_POS__OF_32 = `WIDTH2MP(WIDTH__OF_32);
localparam WIDTH__OF_16 = 16;
localparam MSB_POS__OF_16 = `WIDTH2MP(WIDTH__OF_16);
localparam WIDTH__OF_8 = 8;
localparam MSB_POS__OF_8 = `WIDTH2MP(WIDTH__OF_8);

endpackage : PkgSnow64Alu
