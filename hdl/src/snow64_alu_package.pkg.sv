`include "src/snow64_alu_defines.header.sv"

package PkgSnow64Alu;

typedef enum logic [`MSB_POS__SNOW64_ALU_OPER:0]
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

typedef enum logic [`MSB_POS__SNOW64_ALU_TYPE_SIZE:0]
{
	TypSz8,
	TypSz16,
	TypSz32,
	TypSz64
} AluTypeSize;


typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] a, b;
	logic [`MSB_POS__SNOW64_ALU_OPER:0] oper;
	logic [`MSB_POS__SNOW64_ALU_TYPE_SIZE:0] type_size;
	logic signedness;
} PortIn_Alu;
typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] data;
} PortOut_Alu;


typedef struct packed
{
	logic [`MSB_POS__SNOW64_SUB_ALU_DATA_INOUT:0] a, b;
	logic carry;
	logic [`MSB_POS__SNOW64_ALU_OPER:0] oper;
	logic [`MSB_POS__SNOW64_ALU_TYPE_SIZE:0] type_size;
	logic signedness;
	logic [`MSB_POS__SNOW64_SUB_ALU_INDEX:0] index;
} PortIn_SubAlu;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_8_DATA_INOUT:0] data;
	logic slts, carry;
} PortOut_SubAlu;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_8_DATA_INOUT:0] 
		data_7, data_6, data_5, data_4, data_3, data_2, data_1, data_0;
} SlicedAlu8DataInout;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_16_DATA_INOUT:0] 
		data_3, data_2, data_1, data_0;
} SlicedAlu16DataInout;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_32_DATA_INOUT:0] data_1, data_0;
} SlicedAlu32DataInout;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] to_shift, amount;
} PortIn_Asr64;
typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] data;
} PortOut_Asr64;
typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_32_DATA_INOUT:0] to_shift, amount;
} PortIn_Asr32;
typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_32_DATA_INOUT:0] data;
} PortOut_Asr32;
typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_16_DATA_INOUT:0] to_shift, amount;
} PortIn_Asr16;
typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_16_DATA_INOUT:0] data;
} PortOut_Asr16;
typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_8_DATA_INOUT:0] to_shift, amount;
} PortIn_Asr8;
typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_8_DATA_INOUT:0] data;
} PortOut_Asr8;

localparam WIDTH__OF_64 = 64;
localparam MSB_POS__OF_64 = `WIDTH2MP(WIDTH__OF_64);
localparam WIDTH__OF_32 = 32;
localparam MSB_POS__OF_32 = `WIDTH2MP(WIDTH__OF_32);
localparam WIDTH__OF_16 = 16;
localparam MSB_POS__OF_16 = `WIDTH2MP(WIDTH__OF_16);
localparam WIDTH__OF_8 = 8;
localparam MSB_POS__OF_8 = `WIDTH2MP(WIDTH__OF_8);



endpackage : PkgSnow64Alu
