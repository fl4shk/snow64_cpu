`include "src/snow64_bfloat16_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"

package PkgSnow64BFloat16;

typedef enum logic [`MSB_POS__SNOW64_BFLOAT16_FPU_OPER:0]
{
	OpAdd,
	OpSub,
	OpSlt,
	OpMul,

	OpDiv,
	OpDummy0,
	OpDummy1,
	OpDummy2,

	OpDummy3,
	OpDummy4,
	OpDummy5,
	OpDummy6,

	OpAddAgain,
	OpDummy8,
	OpDummy9,
	OpDummy10
} FpuOper;

typedef struct packed
{
	logic start;
	logic [`MSB_POS__SNOW64_BFLOAT16_FPU_OPER:0] oper;
	logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] a, b;
} PortIn_Fpu;

typedef struct packed
{
	logic valid, can_accept_cmd;
	logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] data;
} PortOut_Fpu;

typedef struct packed
{
	logic start;
	logic [`MSB_POS__SNOW64_BFLOAT16_FPU_OPER:0] oper;
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] a, b;
} PortIn_VectorFpu;

typedef struct packed
{
	logic valid;
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] data;
} PortOut_VectorFpu;

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

	StDivAfterLongDiv,

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
	logic valid, can_accept_cmd;
	logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] data;
} PortOut_BinOp;


// For casting an integer to a BFloat16
typedef struct packed
{
	logic start;
	logic [`MSB_POS__SNOW64_SIZE_64:0] to_cast;
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
	logic type_signedness;
} PortIn_CastFromInt;

typedef struct packed
{
	logic valid, can_accept_cmd;
	logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] data;
} PortOut_CastFromInt;


// For casting a BFloat16 to an integer 
typedef struct packed
{
	logic start;
	logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] to_cast;
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
	logic type_signedness;
} PortIn_CastToInt;

typedef struct packed
{
	logic valid, can_accept_cmd;
	logic [`MSB_POS__SNOW64_SIZE_64:0] data;
} PortOut_CastToInt;




endpackage : PkgSnow64BFloat16
