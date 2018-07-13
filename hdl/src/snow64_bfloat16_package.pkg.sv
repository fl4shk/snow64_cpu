`include "src/snow64_bfloat16_defines.header.sv"

package PkgSnow64BFloat16;

parameter BIAS = 127;
parameter MODDED_BIAS = BIAS + 7;
parameter MAX_ENC_EXP = `WIDTH__SNOW64_BFLOAT16_ENC_EXP'hff;
parameter MAX_SATURATED_ENC_EXP = MAX_ENC_EXP - 1;
parameter MAX_SATURATED_DATA_ABS = `WIDTH__SNOW64_BFLOAT16_ITSELF'h7f7f;

parameter MUL_SIGNIFICAND_NUM_BUFFER_BITS = 7;

typedef enum logic [`MSB_POS__SNOW64_BFLOAT16_ADD_STATE:0]
{
	StAddIdle,

	StAddEffAddPart0,
	StAddEffAddPart1,

	// Effective subtracts may need more parts
	StAddEffSubPart0,
	StAddEffSubPart1
} StateAdd;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_BFLOAT16_ENC_SIGN:0] sign;
	logic [`MSB_POS__SNOW64_BFLOAT16_ENC_EXP:0] enc_exp;
	logic [`MSB_POS__SNOW64_BFLOAT16_ENC_MANTISSA:0] enc_mantissa;
} BFloat16;

typedef struct packed
{
	logic start;
	logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] a, b;
} PortIn_Add;
typedef struct packed
{
	logic data_valid, can_accept_cmd;
	logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] data;
} PortOut_Add;



endpackage : PkgSnow64BFloat16
