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



typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] a, b;
	logic [`MSB_POS__SNOW64_ALU_OPER:0] oper;
	logic [`MSB_POS__SNOW64_CPU_TYPE_SIZE:0] type_size;
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
	logic [`MSB_POS__SNOW64_CPU_TYPE_SIZE:0] type_size;
	//logic signedness;
	logic [`MSB_POS__SNOW64_SUB_ALU_INDEX:0] index;
} PortIn_SubAlu;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_8_DATA_INOUT:0] data;

	// Note that "carry" also is equivalent to the "sltu" result.
	logic carry, lts;
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
	logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] data_0;
} SlicedAlu64DataInout;

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

typedef struct packed
{
	logic [`MSB_POS__SNOW64_CPU_TYPE_SIZE:0] type_size;
	logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] a, b;
} PortIn_ShiftForAlu;
typedef struct packed
{
	logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] data;
} PortOut_ShiftForAlu;

typedef struct packed
{
	logic [`MSB_POS__INST_8__7__DATA_INOUT:0] to_shift, amount;
} `INST_8__7(PortIn_InnerShiftForAlu);
typedef struct packed
{
	logic [`MSB_POS__INST_8__7__DATA_INOUT:0] data;
} `INST_8__7(PortOut_InnerShiftForAlu);

typedef struct packed
{
	logic [`MSB_POS__INST_8__6__DATA_INOUT:0] to_shift, amount;
} `INST_8__6(PortIn_InnerShiftForAlu);
typedef struct packed
{
	logic [`MSB_POS__INST_8__6__DATA_INOUT:0] data;
} `INST_8__6(PortOut_InnerShiftForAlu);

typedef struct packed
{
	logic [`MSB_POS__INST_8__5__DATA_INOUT:0] to_shift, amount;
} `INST_8__5(PortIn_InnerShiftForAlu);
typedef struct packed
{
	logic [`MSB_POS__INST_8__5__DATA_INOUT:0] data;
} `INST_8__5(PortOut_InnerShiftForAlu);

typedef struct packed
{
	logic [`MSB_POS__INST_8__4__DATA_INOUT:0] to_shift, amount;
} `INST_8__4(PortIn_InnerShiftForAlu);
typedef struct packed
{
	logic [`MSB_POS__INST_8__4__DATA_INOUT:0] data;
} `INST_8__4(PortOut_InnerShiftForAlu);

typedef struct packed
{
	logic [`MSB_POS__INST_8__3__DATA_INOUT:0] to_shift, amount;
} `INST_8__3(PortIn_InnerShiftForAlu);
typedef struct packed
{
	logic [`MSB_POS__INST_8__3__DATA_INOUT:0] data;
} `INST_8__3(PortOut_InnerShiftForAlu);

typedef struct packed
{
	logic [`MSB_POS__INST_8__2__DATA_INOUT:0] to_shift, amount;
} `INST_8__2(PortIn_InnerShiftForAlu);
typedef struct packed
{
	logic [`MSB_POS__INST_8__2__DATA_INOUT:0] data;
} `INST_8__2(PortOut_InnerShiftForAlu);

typedef struct packed
{
	logic [`MSB_POS__INST_8__1__DATA_INOUT:0] to_shift, amount;
} `INST_8__1(PortIn_InnerShiftForAlu);
typedef struct packed
{
	logic [`MSB_POS__INST_8__1__DATA_INOUT:0] data;
} `INST_8__1(PortOut_InnerShiftForAlu);

typedef struct packed
{
	logic [`MSB_POS__INST_8__0__DATA_INOUT:0] to_shift, amount;
} `INST_8__0(PortIn_InnerShiftForAlu);
typedef struct packed
{
	logic [`MSB_POS__INST_8__0__DATA_INOUT:0] data;
} `INST_8__0(PortOut_InnerShiftForAlu);

localparam WIDTH__OF_64 = 64;
localparam MSB_POS__OF_64 = `WIDTH2MP(WIDTH__OF_64);
localparam WIDTH__OF_32 = 32;
localparam MSB_POS__OF_32 = `WIDTH2MP(WIDTH__OF_32);
localparam WIDTH__OF_16 = 16;
localparam MSB_POS__OF_16 = `WIDTH2MP(WIDTH__OF_16);
localparam WIDTH__OF_8 = 8;
localparam MSB_POS__OF_8 = `WIDTH2MP(WIDTH__OF_8);

localparam ARR_SIZE__SUB_ALU_PORTS = 8;
localparam LAST_INDEX__SUB_ALU_PORTS
	= `ARR_SIZE_TO_LAST_INDEX(ARR_SIZE__SUB_ALU_PORTS);



typedef struct packed
{
	logic [`MSB_POS__SNOW64_CPU_TYPE_SIZE:0] type_size;
	logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] to_slice;
} PortIn_SliceAndExtend;

typedef struct packed
{
	logic [`LAST_INDEX__SNOW64_ALU_SLICE_AND_EXTEND_OUT_DATA:0]
		[`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] sliced_data;
} PortOut_SliceAndExtend;

endpackage : PkgSnow64Alu
