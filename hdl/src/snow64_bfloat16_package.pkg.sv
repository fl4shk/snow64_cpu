`include "src/snow64_bfloat16_defines.header.sv"

package PkgSnow64BFloat16;


typedef enum logic [`MSB_POS__SNOW64_BFLOAT16_ADD_STATE:0]
{
	StAddIdle,

	StAddStarting,

	StAddEffAdd,

	StAddEffSub
} StateAdd;

typedef enum logic [`MSB_POS__SNOW64_BFLOAT16_MUL_STATE:0]
{
	StMulIdle,

	StMulFinishing
} StateMul;

typedef enum logic [`MSB_POS__SNOW64_BFLOAT16_DIV_STATE:0]
{
	StDivIdle,

	StDivStartingLongDiv,

	StDivInner0,
	StDivInner1,
	StDivInner2,
	StDivInner3,
	StDivInner4,

	StDivFinishing
} StateDiv;

// Helper class
typedef struct packed
{
	logic [`MSB_POS__SNOW64_BFLOAT16_ENC_SIGN:0] sign;
	logic [`MSB_POS__SNOW64_BFLOAT16_ENC_EXP:0] enc_exp;
	logic [`MSB_POS__SNOW64_BFLOAT16_ENC_MANTISSA:0] enc_mantissa;
} BFloat16;


// All BFloat16 operations can use the same style of inputs and outputs
typedef struct packed
{
	logic start;
	logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] a, b;
} PortIn_BinOp;
typedef struct packed
{
	logic data_valid, can_accept_cmd;
	logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] data;
} PortOut_Oper;



endpackage : PkgSnow64BFloat16
