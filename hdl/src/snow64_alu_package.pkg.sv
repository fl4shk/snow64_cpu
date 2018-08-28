`include "src/snow64_alu_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"

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

localparam __DEBUG_ENUM__OP_ADD = OpAdd;
localparam __DEBUG_ENUM__OP_SUB = OpSub;
localparam __DEBUG_ENUM__OP_SLT = OpSlt;
localparam __DEBUG_ENUM__OP_DUMMY_0 = OpDummy0;
localparam __DEBUG_ENUM__OP_DUMMY_1 = OpDummy1;
localparam __DEBUG_ENUM__OP_AND = OpAnd;
localparam __DEBUG_ENUM__OP_ORR = OpOrr;
localparam __DEBUG_ENUM__OP_XOR = OpXor;
localparam __DEBUG_ENUM__OP_SHL = OpShl;
localparam __DEBUG_ENUM__OP_SHR = OpShr;
localparam __DEBUG_ENUM__OP_INV = OpInv;
localparam __DEBUG_ENUM__OP_NOT = OpNot;
localparam __DEBUG_ENUM__OP_ADD_AGAIN = OpAddAgain;
localparam __DEBUG_ENUM__OP_DUMMY_2 = OpDummy2;
localparam __DEBUG_ENUM__OP_DUMMY_3 = OpDummy3;
localparam __DEBUG_ENUM__OP_DUMMY_4 = OpDummy4;


localparam __DEBUG_PORT_MSB_POS__DATA_INOUT
	= `MSB_POS__SNOW64_SIZE_64;
localparam __DEBUG_PORT_MSB_POS__OPER = `MSB_POS__SNOW64_ALU_OPER;
localparam __DEBUG_PORT_MSB_POS__INT_TYPE_SIZE
	= `MSB_POS__SNOW64_CPU_INT_TYPE_SIZE;


typedef struct packed
{
	logic [`MSB_POS__SNOW64_SIZE_64:0] a, b;
	logic [`MSB_POS__SNOW64_ALU_OPER:0] oper;
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
	logic type_signedness;
} PortIn_Alu;
typedef struct packed
{
	logic [`MSB_POS__SNOW64_SIZE_64:0] data;
} PortOut_Alu;



//typedef struct packed
//{
//	logic [`MSB_POS__SNOW64_SUB_ALU_DATA_INOUT:0] a, b;
//	logic carry;
//	logic [`MSB_POS__SNOW64_ALU_OPER:0] oper;
//	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
//	//logic int_type_size;
//	//logic type_signedness;
//	logic [`MSB_POS__SNOW64_SUB_ALU_INDEX:0] index;
//} PortIn_SubAlu;
//
//typedef struct packed
//{
//	logic [`MSB_POS__SNOW64_SIZE_8:0] data;
//
//	// Note that "carry" also is equivalent to the "sltu" result.
//	logic carry, lts;
//} PortOut_SubAlu;




localparam WIDTH__OF_64 = 64;
localparam MSB_POS__OF_64 = `WIDTH2MP(WIDTH__OF_64);
localparam WIDTH__OF_32 = 32;
localparam MSB_POS__OF_32 = `WIDTH2MP(WIDTH__OF_32);
localparam WIDTH__OF_16 = 16;
localparam MSB_POS__OF_16 = `WIDTH2MP(WIDTH__OF_16);
localparam WIDTH__OF_8 = 8;
localparam MSB_POS__OF_8 = `WIDTH2MP(WIDTH__OF_8);




//typedef struct packed
//{
//	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;
//	logic [`MSB_POS__SNOW64_SIZE_64:0] to_slice;
//} PortIn_SliceAndExtend;
//
//typedef struct packed
//{
//	logic [`LAST_INDEX__SNOW64_ALU_SLICE_AND_EXTEND_OUT_DATA:0]
//		[`MSB_POS__SNOW64_SIZE_64:0] sliced_data;
//} PortOut_SliceAndExtend;


typedef struct packed
{
	logic enable;

	logic do_64_bit;

	logic [`MSB_POS__SNOW64_SIZE_64:0] a, b;
} PortIn_SubMul;

typedef struct packed
{
	logic enable;

	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] int_type_size;

	logic [`MSB_POS__SNOW64_SIZE_64:0] a, b;
} PortIn_VectorMul;

typedef struct packed
{
	logic can_accept_cmd, valid;
	//logic [`MSB_POS__SNOW64_SIZE_64:0] data;
	logic [`MSB_POS__SNOW64_SIZE_32:0] data_1, data_0;
} PortOut_Mul;


endpackage : PkgSnow64Alu
