


// src/snow64_instr_decoder_defines.header.sv




// src/misc_defines.header.sv

`default_nettype none







//`define SIGN_EXTEND_SLICED(some_full_width, some_width_of_arg, 
//	some_non_sliced_arg, some_other_arg) \
//	{{(some_full_width - some_width_of_arg) \
//	{some_non_sliced_arg[`WIDTH2MP(some_width_of_arg)]}},some_other_arg}





























































//`define ID_INST_8__7 _64_0
//`define ID_INST_8__6 _32_0
//`define ID_INST_8__5 _16_1
//`define ID_INST_8__4 _16_0
//`define ID_INST_8__3 _8_3
//`define ID_INST_8__2 _8_2
//`define ID_INST_8__1 _8_1
//`define ID_INST_8__0 _8_0
//
//`define ID_INST_16__3 `ID_INST_8__7
//`define ID_INST_16__2 `ID_INST_8__6
//`define ID_INST_16__1 `ID_INST_8__5
//`define ID_INST_16__0 `ID_INST_8__4
//
//`define ID_INST_32__1 `ID_INST_8__7
//`define ID_INST_32__0 `ID_INST_8__6
//
//`define ID_INST_64__0 `ID_INST_8__7







































































































// 5 because the number itself may be zero (meaning we have 16 leading
// zeros)













		// src__slash__misc_defines_header_sv































		// src__slash__snow64_instr_decoder_defines_header_sv



// src/snow64_cpu_defines.header.sv























































































































































































































		// src__slash__misc_defines_header_sv








		// src__slash__snow64_cpu_defines_header_sv

package PkgSnow64InstrDecoder;

// Group 0 instructions:  ALU/FPU stuffs
typedef enum logic [((4) - 1):0]
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
typedef enum logic [((4) - 1):0]
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
typedef enum logic [((4) - 1):0]
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
typedef enum logic [((4) - 1):0]
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
typedef enum logic [((4) - 1):0]
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

typedef enum logic
{
	OpTypeScalar,
	OpTypeVector
} OperationType;

localparam WIDTH__INSTR = 32;
localparam MSB_POS__INSTR = ((WIDTH__INSTR) - 1);
localparam WIDTH__ADDR = 64;
localparam MSB_POS__ADDR = ((WIDTH__ADDR) - 1);

localparam WIDTH__IOG0_SIMM12 = 12;
localparam WIDTH__IOG1_SIMM20 = 20;
localparam WIDTH__IOG2_SIMM12 = 12;
localparam WIDTH__IOG3_SIMM12 = 12;
localparam WIDTH__IOG4_SIMM16 = 16;


typedef struct packed
{
	logic [((3) - 1):0] group;
	logic op_type;
	logic [
	((4) - 1):0] 
		ra_index, rb_index, rc_index;
	logic [((4) - 1):0] oper;

	// Simply sign extend the immediate value encoded into each
	// instruction.
	// The size of that sign-extended immediate varies by instruction
	// group.
	logic [((64) - 1):0] signext_imm;
	//logic [`MSB_POS__SNOW64_CPU_ADDR:0] zeroext_imm;

	// If we should stall the pipeline because of this instruction
	logic stall;

	// If this instruction should be treated as a nop.
	logic nop;
} PortOut_InstrDecoder;


// Simple instruction decoding mechanism:  "cast" the input to the
// instruction decoder to these structs, and use the fields from the struct
// that has the same group as that struct would.
typedef struct packed
{
	// "group" should be 3'b000
	logic [((3) - 1):0] group;
	logic op_type;
	logic [
	((4) - 1):0]
		ra_index, rb_index, rc_index;
	logic [((4) - 1):0] oper;
	logic [
	((12) - 1):0] simm12;
} Iog0Instr;

typedef struct packed
{
	logic [((3) - 1):0] group;
	logic fill;
	logic [
	((4) - 1):0] ra_index;
	logic [((4) - 1):0] oper;
	logic [
	((20) - 1):0] simm20;
} Iog1Instr;

typedef struct packed
{
	logic [((3) - 1):0] group;
	logic fill;
	logic [
	((4) - 1):0]
		ra_index, rb_index, rc_index;
	logic [((4) - 1):0] oper;
	logic [
	((12) - 1):0] simm12;
} Iog2Instr;

typedef struct packed
{
	logic [((3) - 1):0] group;
	logic fill;
	logic [
	((4) - 1):0]
		ra_index, rb_index, rc_index;
	logic [((4) - 1):0] oper;
	logic [
	((12) - 1):0] simm12;
} Iog3Instr;

typedef struct packed
{
	logic [((3) - 1):0] group;
	logic op_type;
	logic [
	((4) - 1):0] ra_index, rb_index;
	logic [((4) - 1):0] oper;
	logic [
	((16) - 1):0] simm16;
} Iog4Instr;



endpackage : PkgSnow64InstrDecoder














		// src__slash__snow64_cpu_defines_header_sv

package PkgSnow64Cpu;


typedef enum logic [
	((2) - 1):0]
{
	TypSz8,
	TypSz16,
	TypSz32,
	TypSz64
} TypeSize;

localparam __DEBUG_ENUM__TYP_SZ_8 = TypSz8;
localparam __DEBUG_ENUM__TYP_SZ_16 = TypSz16;
localparam __DEBUG_ENUM__TYP_SZ_32 = TypSz32;
localparam __DEBUG_ENUM__TYP_SZ_64 = TypSz64;

endpackage : PkgSnow64Cpu



// src/snow64_alu_defines.header.sv























































































































































































































		// src__slash__misc_defines_header_sv

























//`define WIDTH__SNOW64_SUB_ALU_DATA_INOUT 16
//`define MSB_POS__SNOW64_SUB_ALU_DATA_INOUT \
//	`WIDTH2MP(`WIDTH__SNOW64_SUB_ALU_DATA_INOUT)
//
//`define WIDTH__SNOW64_SUB_ALU_INDEX $clog2(64 / 16)
//`define MSB_POS__SNOW64_SUB_ALU_INDEX \
//	`WIDTH2MP(`WIDTH__SNOW64_SUB_ALU_INDEX)





		// src__slash__snow64_alu_defines_header_sv














		// src__slash__snow64_cpu_defines_header_sv

package PkgSnow64Alu;

typedef enum logic [((4) - 1):0]
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
	= 
	((64) - 1);
localparam __DEBUG_PORT_MSB_POS__OPER = ((4) - 1);
localparam __DEBUG_PORT_MSB_POS__TYPE_SIZE
	= 
	((2) - 1);


typedef struct packed
{
	logic [
	((64) - 1):0] a, b;
	logic [((4) - 1):0] oper;
	logic [
	((2) - 1):0] type_size;
	logic type_signedness;
} PortIn_Alu;
typedef struct packed
{
	logic [
	((64) - 1):0] data;
} PortOut_Alu;



//typedef struct packed
//{
//	logic [`MSB_POS__SNOW64_SUB_ALU_DATA_INOUT:0] a, b;
//	logic carry;
//	logic [`MSB_POS__SNOW64_ALU_OPER:0] oper;
//	logic [`MSB_POS__SNOW64_CPU_TYPE_SIZE:0] type_size;
//	//logic type_size;
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


typedef struct packed
{
	logic [
	((8) - 1):0] 
		data_7, data_6, data_5, data_4, data_3, data_2, data_1, data_0;
} SlicedAlu8DataInout;

typedef struct packed
{
	logic [
	((16) - 1):0] 
		data_3, data_2, data_1, data_0;
} SlicedAlu16DataInout;

typedef struct packed
{
	logic [
	((32) - 1):0] data_1, data_0;
} SlicedAlu32DataInout;

typedef struct packed
{
	logic [
	((64) - 1):0] data_0;
} SlicedAlu64DataInout;


localparam WIDTH__OF_64 = 64;
localparam MSB_POS__OF_64 = ((WIDTH__OF_64) - 1);
localparam WIDTH__OF_32 = 32;
localparam MSB_POS__OF_32 = ((WIDTH__OF_32) - 1);
localparam WIDTH__OF_16 = 16;
localparam MSB_POS__OF_16 = ((WIDTH__OF_16) - 1);
localparam WIDTH__OF_8 = 8;
localparam MSB_POS__OF_8 = ((WIDTH__OF_8) - 1);

localparam ARR_SIZE__SUB_ALU_PORTS = 8;
localparam LAST_INDEX__SUB_ALU_PORTS
	= ((ARR_SIZE__SUB_ALU_PORTS) - 1);



//typedef struct packed
//{
//	logic [`MSB_POS__SNOW64_CPU_TYPE_SIZE:0] type_size;
//	logic [`MSB_POS__SNOW64_SIZE_64:0] to_slice;
//} PortIn_SliceAndExtend;
//
//typedef struct packed
//{
//	logic [`LAST_INDEX__SNOW64_ALU_SLICE_AND_EXTEND_OUT_DATA:0]
//		[`MSB_POS__SNOW64_SIZE_64:0] sliced_data;
//} PortOut_SliceAndExtend;

endpackage : PkgSnow64Alu



// src/snow64_long_div_u16_by_u8_defines.header.sv























































































































































































































		// src__slash__misc_defines_header_sv

















		// src__slash__snow64_long_div_u16_by_u8_defines_header_sv

package PkgSnow64LongDiv;

//typedef enum logic [`MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_OUT_DATA:0]
//{
//	StIdle,
//	StWorking,
//	StEnding
//} State;

typedef struct packed
{
	logic start;
	logic [
	((16) - 1):0] a;
	logic [
	((8) - 1):0] b;
} PortIn_LongDivU16ByU8;

typedef struct packed
{
	logic data_valid, can_accept_cmd;
	logic [
	((16) - 1):0] data;
} PortOut_LongDivU16ByU8;

endpackage : PkgSnow64LongDiv



// src/snow64_bfloat16_defines.header.sv















		// src__slash__snow64_cpu_defines_header_sv

















// That's right, here we have a state machine for the BFloat16 adder... we
// don't get to have single cycle execution for bfloat16s.








































		// src__slash__snow64_bfloat16_defines_header_sv

package PkgSnow64BFloat16;


typedef enum logic [
	((2) - 1):0]
{
	StAddIdle,

	StAddStarting,

	StAddEffAdd,

	StAddEffSub
} StateAdd;

typedef enum logic [
	((1) - 1):0]
{
	StMulIdle,

	StMulFinishing
} StateMul;

typedef enum logic [
	((2) - 1):0]
{
	StDivIdle,

	StDivStartingLongDiv,

	StDivAfterLongDiv,

	StDivFinishing
} StateDiv;

// Helper class
typedef struct packed
{
	logic [
	((1) - 1):0] sign;
	logic [
	((8) - 1):0] enc_exp;
	logic [
	((7) - 1):0] enc_mantissa;
} BFloat16;


// All BFloat16 operations can use the same style of inputs and outputs
typedef struct packed
{
	logic start;
	logic [
	((16) - 1):0] a, b;
} PortIn_BinOp;

typedef struct packed
{
	logic data_valid, can_accept_cmd;
	logic [
	((16) - 1):0] data;
} PortOut_Oper;


//// For casting an integer to a BFloat16
//typedef struct packed
//{
//	logic start;
//	logic [`MSB_POS__SNOW64_SIZE_64:0] to_cast;
//	logic [`MSB_POS__SNOW64_CPU_TYPE_SIZE:0] type_size;
//	logic type_signedness;
//} PortIn_CastFromInt;
//
//typedef struct packed
//{
//	logic data_valid, can_accept_cmd;
//	logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] data;
//} PortOut_CastFromInt;
//
//
//// For casting a BFloat16 to an integer 
//typedef struct packed
//{
//	logic start;
//	logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] to_cast;
//	logic [`MSB_POS__SNOW64_CPU_TYPE_SIZE:0] type_size;
//	logic type_signedness;
//} PortIn_CastToInt;
//
//typedef struct packed
//{
//	logic data_valid, can_accept_cmd;
//	logic [`MSB_POS__SNOW64_SIZE_64:0] data;
//} PortOut_CastToInt;




endpackage : PkgSnow64BFloat16











































		// src__slash__snow64_alu_defines_header_sv

//module SetLessThanUnsigned #(parameter WIDTH__DATA_INOUT=64)
//	(input logic [__MSB_POS__DATA_INOUT:0] in_a, in_b, 
//	output logic out_data);
//
//	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(WIDTH__DATA_INOUT);
//	logic [__MSB_POS__DATA_INOUT:0] __temp;
//
//	// 6502-style subtract
//	assign {out_data, __temp} = in_a + (~in_b) 
//		+ {{__MSB_POS__DATA_INOUT{1'b0}}, 1'b1};
//endmodule

//module SetLessThanSigned #(parameter WIDTH__DATA_INOUT=64)
//	(input logic [__MSB_POS__DATA_INOUT:0] in_a, in_b, 
//	output logic out_data);
//
//	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(WIDTH__DATA_INOUT);
//	logic [__MSB_POS__DATA_INOUT:0] __temp;
//
//	// 6502-style subtract
//	assign __temp = in_a + (~in_b) + {{__MSB_POS__DATA_INOUT{1'b0}}, 1'b1};
//
//	// 6502-style "N" and "V" flags.
//	assign out_data = (__temp[__MSB_POS__DATA_INOUT]
//		^ ((in_a[__MSB_POS__DATA_INOUT] ^ in_b[__MSB_POS__DATA_INOUT])
//		& (in_a[__MSB_POS__DATA_INOUT] ^ __temp[__MSB_POS__DATA_INOUT])));
//endmodule

//module SetLessThanUnsigned(input logic in_a_msb_pos, in_b_msb_pos,
//	output logic out_data);
//
//endmodule

module __RawSetLessThanSigned
	(input logic in_a_msb_pos, in_b_msb_pos, in_sub_result_msb_pos,
	output logic out_data);

	// 6502-style "N" and "V" flags.
	assign out_data = (in_sub_result_msb_pos
		^ ((in_a_msb_pos ^ in_b_msb_pos)
		& (in_a_msb_pos ^ in_sub_result_msb_pos)));
endmodule

module SetLessThanSigned #(parameter WIDTH__DATA_INOUT=64)
	(input logic [__MSB_POS__DATA_INOUT:0] in_a, in_b,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	localparam __MSB_POS__DATA_INOUT = ((WIDTH__DATA_INOUT) - 1);

	logic [__MSB_POS__DATA_INOUT:0] __sub_result;
	assign __sub_result = in_a - in_b;

	logic __out_raw_slts_data;

	__RawSetLessThanSigned __inst_raw_slts
		(.in_a_msb_pos(in_a[__MSB_POS__DATA_INOUT]),
		.in_b_msb_pos(in_b[__MSB_POS__DATA_INOUT]),
		.in_sub_result_msb_pos(__sub_result[__MSB_POS__DATA_INOUT]),
		.out_data(__out_raw_slts_data));

	assign out_data = 

	{{(WIDTH__DATA_INOUT - 1){1'b0}}, __out_raw_slts_data};

endmodule

// Barrel shifters to compute arithmetic shift right.
// This is used instead of the ">>>" Verilog operator to prevent the need
// for "$signed" and ">>>", which allow me to use Icarus Verilog's
// "-tvlog95" option).














































module LogicalShiftLeft64
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	
	localparam __WIDTH__DATA_INOUT = 64;
	localparam __MSB_POS__DATA_INOUT = ((__WIDTH__DATA_INOUT) - 1);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= ((__ARR_SIZE__TEMP) - 1);

	localparam __INDEX__OUT_DATA = __LAST_INDEX__TEMP;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];


	always @(*)
	begin
		if (
	in_amount[__MSB_POS__DATA_INOUT:__LOG2__WIDTH__DATA_INOUT])
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			
	__temp[1] = in_amount[1 - 1]
		? {__temp[1 - 1][__MSB_POS__DATA_INOUT - (1 << (1 - 1)) : 0],
		{(1 << (1 - 1)){1'b0}}}
		: __temp[1 - 1];
			
	__temp[2] = in_amount[2 - 1]
		? {__temp[2 - 1][__MSB_POS__DATA_INOUT - (1 << (2 - 1)) : 0],
		{(1 << (2 - 1)){1'b0}}}
		: __temp[2 - 1];
			
	__temp[3] = in_amount[3 - 1]
		? {__temp[3 - 1][__MSB_POS__DATA_INOUT - (1 << (3 - 1)) : 0],
		{(1 << (3 - 1)){1'b0}}}
		: __temp[3 - 1];
			
	__temp[4] = in_amount[4 - 1]
		? {__temp[4 - 1][__MSB_POS__DATA_INOUT - (1 << (4 - 1)) : 0],
		{(1 << (4 - 1)){1'b0}}}
		: __temp[4 - 1];
			
	__temp[5] = in_amount[5 - 1]
		? {__temp[5 - 1][__MSB_POS__DATA_INOUT - (1 << (5 - 1)) : 0],
		{(1 << (5 - 1)){1'b0}}}
		: __temp[5 - 1];
			
	__temp[6] = in_amount[6 - 1]
		? {__temp[6 - 1][__MSB_POS__DATA_INOUT - (1 << (6 - 1)) : 0],
		{(1 << (6 - 1)){1'b0}}}
		: __temp[6 - 1];
		end
	end
endmodule
module LogicalShiftLeft32
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	
	localparam __WIDTH__DATA_INOUT = 32;
	localparam __MSB_POS__DATA_INOUT = ((__WIDTH__DATA_INOUT) - 1);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= ((__ARR_SIZE__TEMP) - 1);

	localparam __INDEX__OUT_DATA = __LAST_INDEX__TEMP;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];


	always @(*)
	begin
		if (
	in_amount[__MSB_POS__DATA_INOUT:__LOG2__WIDTH__DATA_INOUT])
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			
	__temp[1] = in_amount[1 - 1]
		? {__temp[1 - 1][__MSB_POS__DATA_INOUT - (1 << (1 - 1)) : 0],
		{(1 << (1 - 1)){1'b0}}}
		: __temp[1 - 1];
			
	__temp[2] = in_amount[2 - 1]
		? {__temp[2 - 1][__MSB_POS__DATA_INOUT - (1 << (2 - 1)) : 0],
		{(1 << (2 - 1)){1'b0}}}
		: __temp[2 - 1];
			
	__temp[3] = in_amount[3 - 1]
		? {__temp[3 - 1][__MSB_POS__DATA_INOUT - (1 << (3 - 1)) : 0],
		{(1 << (3 - 1)){1'b0}}}
		: __temp[3 - 1];
			
	__temp[4] = in_amount[4 - 1]
		? {__temp[4 - 1][__MSB_POS__DATA_INOUT - (1 << (4 - 1)) : 0],
		{(1 << (4 - 1)){1'b0}}}
		: __temp[4 - 1];
			
	__temp[5] = in_amount[5 - 1]
		? {__temp[5 - 1][__MSB_POS__DATA_INOUT - (1 << (5 - 1)) : 0],
		{(1 << (5 - 1)){1'b0}}}
		: __temp[5 - 1];
		end
	end
endmodule
module LogicalShiftLeft16
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	
	localparam __WIDTH__DATA_INOUT = 16;
	localparam __MSB_POS__DATA_INOUT = ((__WIDTH__DATA_INOUT) - 1);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= ((__ARR_SIZE__TEMP) - 1);

	localparam __INDEX__OUT_DATA = __LAST_INDEX__TEMP;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];


	always @(*)
	begin
		if (
	in_amount[__MSB_POS__DATA_INOUT:__LOG2__WIDTH__DATA_INOUT])
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			
	__temp[1] = in_amount[1 - 1]
		? {__temp[1 - 1][__MSB_POS__DATA_INOUT - (1 << (1 - 1)) : 0],
		{(1 << (1 - 1)){1'b0}}}
		: __temp[1 - 1];
			
	__temp[2] = in_amount[2 - 1]
		? {__temp[2 - 1][__MSB_POS__DATA_INOUT - (1 << (2 - 1)) : 0],
		{(1 << (2 - 1)){1'b0}}}
		: __temp[2 - 1];
			
	__temp[3] = in_amount[3 - 1]
		? {__temp[3 - 1][__MSB_POS__DATA_INOUT - (1 << (3 - 1)) : 0],
		{(1 << (3 - 1)){1'b0}}}
		: __temp[3 - 1];
			
	__temp[4] = in_amount[4 - 1]
		? {__temp[4 - 1][__MSB_POS__DATA_INOUT - (1 << (4 - 1)) : 0],
		{(1 << (4 - 1)){1'b0}}}
		: __temp[4 - 1];
		end
	end
endmodule
module LogicalShiftLeft8
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	
	localparam __WIDTH__DATA_INOUT = 8;
	localparam __MSB_POS__DATA_INOUT = ((__WIDTH__DATA_INOUT) - 1);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= ((__ARR_SIZE__TEMP) - 1);

	localparam __INDEX__OUT_DATA = __LAST_INDEX__TEMP;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];


	always @(*)
	begin
		if (
	in_amount[__MSB_POS__DATA_INOUT:__LOG2__WIDTH__DATA_INOUT])
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			
	__temp[1] = in_amount[1 - 1]
		? {__temp[1 - 1][__MSB_POS__DATA_INOUT - (1 << (1 - 1)) : 0],
		{(1 << (1 - 1)){1'b0}}}
		: __temp[1 - 1];
			
	__temp[2] = in_amount[2 - 1]
		? {__temp[2 - 1][__MSB_POS__DATA_INOUT - (1 << (2 - 1)) : 0],
		{(1 << (2 - 1)){1'b0}}}
		: __temp[2 - 1];
			
	__temp[3] = in_amount[3 - 1]
		? {__temp[3 - 1][__MSB_POS__DATA_INOUT - (1 << (3 - 1)) : 0],
		{(1 << (3 - 1)){1'b0}}}
		: __temp[3 - 1];
		end
	end
endmodule


module LogicalShiftRight64
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	
	localparam __WIDTH__DATA_INOUT = 64;
	localparam __MSB_POS__DATA_INOUT = ((__WIDTH__DATA_INOUT) - 1);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= ((__ARR_SIZE__TEMP) - 1);

	localparam __INDEX__OUT_DATA = __LAST_INDEX__TEMP;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];


	always @(*)
	begin
		if (
	in_amount[__MSB_POS__DATA_INOUT:__LOG2__WIDTH__DATA_INOUT])
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			
	__temp[1] = in_amount[1 - 1]
		? {{(1 << (1 - 1)){1'b0}},
		__temp[1 - 1][__MSB_POS__DATA_INOUT : (1 << (1 - 1))]}
		: __temp[1 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[2] = in_amount[2 - 1]
		? {{(1 << (2 - 1)){1'b0}},
		__temp[2 - 1][__MSB_POS__DATA_INOUT : (1 << (2 - 1))]}
		: __temp[2 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[3] = in_amount[3 - 1]
		? {{(1 << (3 - 1)){1'b0}},
		__temp[3 - 1][__MSB_POS__DATA_INOUT : (1 << (3 - 1))]}
		: __temp[3 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[4] = in_amount[4 - 1]
		? {{(1 << (4 - 1)){1'b0}},
		__temp[4 - 1][__MSB_POS__DATA_INOUT : (1 << (4 - 1))]}
		: __temp[4 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[5] = in_amount[5 - 1]
		? {{(1 << (5 - 1)){1'b0}},
		__temp[5 - 1][__MSB_POS__DATA_INOUT : (1 << (5 - 1))]}
		: __temp[5 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[6] = in_amount[6 - 1]
		? {{(1 << (6 - 1)){1'b0}},
		__temp[6 - 1][__MSB_POS__DATA_INOUT : (1 << (6 - 1))]}
		: __temp[6 - 1][__MSB_POS__DATA_INOUT : 0];
		end
	end
endmodule
module LogicalShiftRight32
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	
	localparam __WIDTH__DATA_INOUT = 32;
	localparam __MSB_POS__DATA_INOUT = ((__WIDTH__DATA_INOUT) - 1);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= ((__ARR_SIZE__TEMP) - 1);

	localparam __INDEX__OUT_DATA = __LAST_INDEX__TEMP;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];


	always @(*)
	begin
		if (
	in_amount[__MSB_POS__DATA_INOUT:__LOG2__WIDTH__DATA_INOUT])
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			
	__temp[1] = in_amount[1 - 1]
		? {{(1 << (1 - 1)){1'b0}},
		__temp[1 - 1][__MSB_POS__DATA_INOUT : (1 << (1 - 1))]}
		: __temp[1 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[2] = in_amount[2 - 1]
		? {{(1 << (2 - 1)){1'b0}},
		__temp[2 - 1][__MSB_POS__DATA_INOUT : (1 << (2 - 1))]}
		: __temp[2 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[3] = in_amount[3 - 1]
		? {{(1 << (3 - 1)){1'b0}},
		__temp[3 - 1][__MSB_POS__DATA_INOUT : (1 << (3 - 1))]}
		: __temp[3 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[4] = in_amount[4 - 1]
		? {{(1 << (4 - 1)){1'b0}},
		__temp[4 - 1][__MSB_POS__DATA_INOUT : (1 << (4 - 1))]}
		: __temp[4 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[5] = in_amount[5 - 1]
		? {{(1 << (5 - 1)){1'b0}},
		__temp[5 - 1][__MSB_POS__DATA_INOUT : (1 << (5 - 1))]}
		: __temp[5 - 1][__MSB_POS__DATA_INOUT : 0];
		end
	end
endmodule
module LogicalShiftRight16
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	
	localparam __WIDTH__DATA_INOUT = 16;
	localparam __MSB_POS__DATA_INOUT = ((__WIDTH__DATA_INOUT) - 1);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= ((__ARR_SIZE__TEMP) - 1);

	localparam __INDEX__OUT_DATA = __LAST_INDEX__TEMP;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];


	always @(*)
	begin
		if (
	in_amount[__MSB_POS__DATA_INOUT:__LOG2__WIDTH__DATA_INOUT])
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			
	__temp[1] = in_amount[1 - 1]
		? {{(1 << (1 - 1)){1'b0}},
		__temp[1 - 1][__MSB_POS__DATA_INOUT : (1 << (1 - 1))]}
		: __temp[1 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[2] = in_amount[2 - 1]
		? {{(1 << (2 - 1)){1'b0}},
		__temp[2 - 1][__MSB_POS__DATA_INOUT : (1 << (2 - 1))]}
		: __temp[2 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[3] = in_amount[3 - 1]
		? {{(1 << (3 - 1)){1'b0}},
		__temp[3 - 1][__MSB_POS__DATA_INOUT : (1 << (3 - 1))]}
		: __temp[3 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[4] = in_amount[4 - 1]
		? {{(1 << (4 - 1)){1'b0}},
		__temp[4 - 1][__MSB_POS__DATA_INOUT : (1 << (4 - 1))]}
		: __temp[4 - 1][__MSB_POS__DATA_INOUT : 0];
		end
	end
endmodule
module LogicalShiftRight8
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	
	localparam __WIDTH__DATA_INOUT = 8;
	localparam __MSB_POS__DATA_INOUT = ((__WIDTH__DATA_INOUT) - 1);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= ((__ARR_SIZE__TEMP) - 1);

	localparam __INDEX__OUT_DATA = __LAST_INDEX__TEMP;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];


	always @(*)
	begin
		if (
	in_amount[__MSB_POS__DATA_INOUT:__LOG2__WIDTH__DATA_INOUT])
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			
	__temp[1] = in_amount[1 - 1]
		? {{(1 << (1 - 1)){1'b0}},
		__temp[1 - 1][__MSB_POS__DATA_INOUT : (1 << (1 - 1))]}
		: __temp[1 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[2] = in_amount[2 - 1]
		? {{(1 << (2 - 1)){1'b0}},
		__temp[2 - 1][__MSB_POS__DATA_INOUT : (1 << (2 - 1))]}
		: __temp[2 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[3] = in_amount[3 - 1]
		? {{(1 << (3 - 1)){1'b0}},
		__temp[3 - 1][__MSB_POS__DATA_INOUT : (1 << (3 - 1))]}
		: __temp[3 - 1][__MSB_POS__DATA_INOUT : 0];
		end
	end
endmodule

module ArithmeticShiftRight64
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	
	localparam __WIDTH__DATA_INOUT = 64;
	localparam __MSB_POS__DATA_INOUT = ((__WIDTH__DATA_INOUT) - 1);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= ((__ARR_SIZE__TEMP) - 1);

	localparam __INDEX__OUT_DATA = __LAST_INDEX__TEMP;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];


	always @(*)
	begin
		if (
	in_amount[__MSB_POS__DATA_INOUT:__LOG2__WIDTH__DATA_INOUT])
		begin
			__temp[__INDEX__OUT_DATA]
				= {__WIDTH__DATA_INOUT
				{in_to_shift[__MSB_POS__DATA_INOUT]}};
		end

		else
		begin
			
	__temp[1] = in_amount[1 - 1]
		? {{(1 << (1 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[1 - 1][__MSB_POS__DATA_INOUT : (1 << (1 - 1))]}
		: __temp[1 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[2] = in_amount[2 - 1]
		? {{(1 << (2 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[2 - 1][__MSB_POS__DATA_INOUT : (1 << (2 - 1))]}
		: __temp[2 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[3] = in_amount[3 - 1]
		? {{(1 << (3 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[3 - 1][__MSB_POS__DATA_INOUT : (1 << (3 - 1))]}
		: __temp[3 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[4] = in_amount[4 - 1]
		? {{(1 << (4 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[4 - 1][__MSB_POS__DATA_INOUT : (1 << (4 - 1))]}
		: __temp[4 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[5] = in_amount[5 - 1]
		? {{(1 << (5 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[5 - 1][__MSB_POS__DATA_INOUT : (1 << (5 - 1))]}
		: __temp[5 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[6] = in_amount[6 - 1]
		? {{(1 << (6 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[6 - 1][__MSB_POS__DATA_INOUT : (1 << (6 - 1))]}
		: __temp[6 - 1][__MSB_POS__DATA_INOUT : 0];
		end
	end
endmodule

module ArithmeticShiftRight32
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	
	localparam __WIDTH__DATA_INOUT = 32;
	localparam __MSB_POS__DATA_INOUT = ((__WIDTH__DATA_INOUT) - 1);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= ((__ARR_SIZE__TEMP) - 1);

	localparam __INDEX__OUT_DATA = __LAST_INDEX__TEMP;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];


	always @(*)
	begin
		if (
	in_amount[__MSB_POS__DATA_INOUT:__LOG2__WIDTH__DATA_INOUT])
		begin
			__temp[__INDEX__OUT_DATA]
				= {__WIDTH__DATA_INOUT
				{in_to_shift[__MSB_POS__DATA_INOUT]}};
		end

		else
		begin
			
	__temp[1] = in_amount[1 - 1]
		? {{(1 << (1 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[1 - 1][__MSB_POS__DATA_INOUT : (1 << (1 - 1))]}
		: __temp[1 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[2] = in_amount[2 - 1]
		? {{(1 << (2 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[2 - 1][__MSB_POS__DATA_INOUT : (1 << (2 - 1))]}
		: __temp[2 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[3] = in_amount[3 - 1]
		? {{(1 << (3 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[3 - 1][__MSB_POS__DATA_INOUT : (1 << (3 - 1))]}
		: __temp[3 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[4] = in_amount[4 - 1]
		? {{(1 << (4 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[4 - 1][__MSB_POS__DATA_INOUT : (1 << (4 - 1))]}
		: __temp[4 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[5] = in_amount[5 - 1]
		? {{(1 << (5 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[5 - 1][__MSB_POS__DATA_INOUT : (1 << (5 - 1))]}
		: __temp[5 - 1][__MSB_POS__DATA_INOUT : 0];
		end
	end
endmodule

module ArithmeticShiftRight16
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	
	localparam __WIDTH__DATA_INOUT = 16;
	localparam __MSB_POS__DATA_INOUT = ((__WIDTH__DATA_INOUT) - 1);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= ((__ARR_SIZE__TEMP) - 1);

	localparam __INDEX__OUT_DATA = __LAST_INDEX__TEMP;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];


	always @(*)
	begin
		if (
	in_amount[__MSB_POS__DATA_INOUT:__LOG2__WIDTH__DATA_INOUT])
		begin
			__temp[__INDEX__OUT_DATA]
				= {__WIDTH__DATA_INOUT
				{in_to_shift[__MSB_POS__DATA_INOUT]}};
		end

		else
		begin
			
	__temp[1] = in_amount[1 - 1]
		? {{(1 << (1 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[1 - 1][__MSB_POS__DATA_INOUT : (1 << (1 - 1))]}
		: __temp[1 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[2] = in_amount[2 - 1]
		? {{(1 << (2 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[2 - 1][__MSB_POS__DATA_INOUT : (1 << (2 - 1))]}
		: __temp[2 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[3] = in_amount[3 - 1]
		? {{(1 << (3 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[3 - 1][__MSB_POS__DATA_INOUT : (1 << (3 - 1))]}
		: __temp[3 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[4] = in_amount[4 - 1]
		? {{(1 << (4 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[4 - 1][__MSB_POS__DATA_INOUT : (1 << (4 - 1))]}
		: __temp[4 - 1][__MSB_POS__DATA_INOUT : 0];
		end
	end

endmodule

module ArithmeticShiftRight8
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	
	localparam __WIDTH__DATA_INOUT = 8;
	localparam __MSB_POS__DATA_INOUT = ((__WIDTH__DATA_INOUT) - 1);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= ((__ARR_SIZE__TEMP) - 1);

	localparam __INDEX__OUT_DATA = __LAST_INDEX__TEMP;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];


	always @(*)
	begin
		if (
	in_amount[__MSB_POS__DATA_INOUT:__LOG2__WIDTH__DATA_INOUT])
		begin
			__temp[__INDEX__OUT_DATA]
				= {__WIDTH__DATA_INOUT
				{in_to_shift[__MSB_POS__DATA_INOUT]}};
		end

		else
		begin
			
	__temp[1] = in_amount[1 - 1]
		? {{(1 << (1 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[1 - 1][__MSB_POS__DATA_INOUT : (1 << (1 - 1))]}
		: __temp[1 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[2] = in_amount[2 - 1]
		? {{(1 << (2 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[2 - 1][__MSB_POS__DATA_INOUT : (1 << (2 - 1))]}
		: __temp[2 - 1][__MSB_POS__DATA_INOUT : 0];
			
	__temp[3] = in_amount[3 - 1]
		? {{(1 << (3 - 1)){in_to_shift[__MSB_POS__DATA_INOUT]}},
		__temp[3 - 1][__MSB_POS__DATA_INOUT : (1 << (3 - 1))]}
		: __temp[3 - 1][__MSB_POS__DATA_INOUT : 0];
		end
	end
endmodule

//`define MAKE_ASR_AND_PORTS(some_width) \
//	struct packed \
//	{ \
//		logic [PkgSnow64Alu::MSB_POS__OF_``some_width:0] \
//			to_shift, amount; \
//	} __in_asr``some_width; \
//	struct packed \
//	{ \
//		logic [PkgSnow64Alu::MSB_POS__OF_``some_width:0] data; \
//	} __out_asr``some_width; \
//	assign __in_asr``some_width.to_shift = in_to_shift; \
//	assign __in_asr``some_width.amount = in_amount; \
//	ArithmeticShiftRight``some_width \
//		__inst_asr``some_width \
//		(.in_to_shift(__in_asr``some_width.to_shift), \
//		.in_amount(__in_asr``some_width.amount), \
//		.out_data(__out_asr``some_width.data));
//
//
//
//module DebugArithmeticShiftRight #(parameter WIDTH__DATA_INOUT=64)
//	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
//	output logic [__MSB_POS__DATA_INOUT:0] out_data);
//
//	//import PkgSnow64Alu::*;
//
//	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(WIDTH__DATA_INOUT);
//
//	`MAKE_ASR_AND_PORTS(64)
//
//	`MAKE_ASR_AND_PORTS(32)
//
//	`MAKE_ASR_AND_PORTS(16)
//
//	`MAKE_ASR_AND_PORTS(8)
//
//	always @(*)
//	begin
//		case (WIDTH__DATA_INOUT)
//			64:
//			begin
//				out_data = __out_asr64.data;
//			end
//
//			32:
//			begin
//				out_data = __out_asr32.data;
//			end
//
//			16:
//			begin
//				out_data = __out_asr16.data;
//			end
//
//			8:
//			begin
//				out_data = __out_asr8.data;
//			end
//
//			default:
//			begin
//				out_data = 0;
//			end
//		endcase
//	end
//
//endmodule





































		// src__slash__snow64_instr_decoder_defines_header_sv














		// src__slash__snow64_cpu_defines_header_sv











































		// src__slash__snow64_alu_defines_header_sv



//module TestBenchAsr;
//
//	localparam __WIDTH__DATA_INOUT = 8;
//	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(__WIDTH__DATA_INOUT);
//
//	struct packed
//	{
//		logic [__MSB_POS__DATA_INOUT:0] to_shift, amount;
//	} __in_asr;
//
//	struct packed
//	{
//		logic [__MSB_POS__DATA_INOUT:0] data;
//	} __out_asr;
//
//	DebugArithmeticShiftRight #(.WIDTH__DATA_INOUT(__WIDTH__DATA_INOUT))
//		__inst_asr(.in_to_shift(__in_asr.to_shift),
//		.in_amount(__in_asr.amount), .out_data(__out_asr.data));
//
//	logic [__WIDTH__DATA_INOUT:0] __i, __j;
//
//	logic [__MSB_POS__DATA_INOUT:0] __oracle_asr_out_data;
//
//	initial
//	begin
//		for (__i=0; !__i[__WIDTH__DATA_INOUT]; __i=__i+1)
//		begin
//			for (__j=0; !__j[__WIDTH__DATA_INOUT]; __j=__j+1)
//			//for (__j=0; !__j[$clog2(__WIDTH__DATA_INOUT)]; __j=__j+1)
//			begin
//				__in_asr.to_shift = __i;
//				__in_asr.amount = __j;
//				#1
//
//				__oracle_asr_out_data 
//					= $signed(__in_asr.to_shift) >>> __in_asr.amount;
//
//				#1
//				if (__oracle_asr_out_data != __out_asr.data)
//				begin
//					$display("asr wrong output data:  %h >>> %h, %h, %h",
//						__in_asr.to_shift, __in_asr.amount,
//						__out_asr.data, __oracle_asr_out_data);
//				end
//			end
//		end
//	end
//
//
//endmodule




//module TestBenchSltu;
//
//
//	localparam __WIDTH__DATA_INOUT = 8;
//	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(__WIDTH__DATA_INOUT);
//
//	struct packed
//	{
//		logic [__MSB_POS__DATA_INOUT:0] a, b;
//	} __in_sltu;
//
//	struct packed
//	{
//		logic data;
//	} __out_sltu;
//
//	SetLessThanUnsigned #(.WIDTH__DATA_INOUT(__WIDTH__DATA_INOUT))
//		__inst_sltu(.in_a(__in_sltu.a), .in_b(__in_sltu.b),
//		.out_data(__out_sltu.data));
//
//	logic [__WIDTH__DATA_INOUT:0] __i, __j;
//
//	logic __oracle_sltu_out_data;
//
//	initial
//	begin
//		for (__i=0; !__i[__WIDTH__DATA_INOUT]; __i=__i+1)
//		begin
//			for (__j=0; !__j[__WIDTH__DATA_INOUT]; __j=__j+1)
//			begin
//				__in_sltu.a = __i;
//				__in_sltu.b = __j;
//				#1
//
//				__oracle_sltu_out_data = __in_sltu.a < __in_sltu.b;
//
//				#1
//				if (__oracle_sltu_out_data != __out_sltu.data)
//				begin
//					$display("sltu wrong output data:  %h < %h, %h, %h",
//						__in_sltu.a, __in_sltu.b,
//						__out_sltu.data, __oracle_sltu_out_data);
//				end
//			end
//		end
//	end
//
//endmodule

//module TestBenchSlts;
//
//
//	localparam __WIDTH__DATA_INOUT = 8;
//	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(__WIDTH__DATA_INOUT);
//
//	struct packed
//	{
//		logic [__MSB_POS__DATA_INOUT:0] a, b;
//	} __in_slts;
//
//	struct packed
//	{
//		logic data;
//	} __out_slts;
//
//	SetLessThanSigned #(.WIDTH__DATA_INOUT(__WIDTH__DATA_INOUT))
//		__inst_slts(.in_a(__in_slts.a), .in_b(__in_slts.b),
//		.out_data(__out_slts.data));
//
//	logic [__WIDTH__DATA_INOUT:0] __i, __j;
//
//	logic __oracle_slts_out_data;
//
//	initial
//	begin
//		for (__i=0; !__i[__WIDTH__DATA_INOUT]; __i=__i+1)
//		begin
//			for (__j=0; !__j[__WIDTH__DATA_INOUT]; __j=__j+1)
//			begin
//				__in_slts.a = __i;
//				__in_slts.b = __j;
//				#1
//
//				__oracle_slts_out_data 
//					= $signed(__in_slts.a) < $signed(__in_slts.b);
//
//				#1
//				if (__oracle_slts_out_data != __out_slts.data)
//				begin
//					$display("slts wrong output data:  %h < %h, %h, %h",
//						__in_slts.a, __in_slts.b,
//						__out_slts.data, __oracle_slts_out_data);
//				end
//			end
//		end
//	end
//
//endmodule

//module TestBenchAlu;
//
//	logic [`MSB_POS__SNOW64_SIZE_64:0] __in_alu_a, __in_alu_b;
//	logic [`MSB_POS__SNOW64_ALU_OPER:0] __in_alu_oper;
//	logic [`MSB_POS__SNOW64_CPU_TYPE_SIZE:0] __in_alu_type_size;
//	logic __in_alu_signedness;
//
//	logic [`MSB_POS__SNOW64_SIZE_64:0] __out_alu_data;
//
//
//	DebugSnow64Alu __inst_debug_alu(.in_a(__in_alu_a), .in_b(__in_alu_b),
//		.in_oper(__in_alu_oper), .in_type_size(__in_alu_type_size),
//		.in_signedness(__in_alu_signedness), .out_data(__out_alu_data));
//
//	assign __in_alu_oper = PkgSnow64Alu::OpShr;
//	assign __in_alu_type_size = PkgSnow64Cpu::TypSz8;
//	assign __in_alu_signedness = 1;
//
//	logic [`MSB_POS__SNOW64_SIZE_64:0] __oracle_alu_out_data;
//
//	initial
//	begin
//		for (longint i=0; i<(1 << 8); i=i+1)
//		begin
//			for (longint j=0; j<(1 << 8); j=j+1)
//			begin
//				__in_alu_a = i;
//				__in_alu_b = j;
//
//				#1
//				__oracle_alu_out_data[7:0] 
//					= $signed(__in_alu_a[7:0]) >>> __in_alu_b[7:0];
//
//				#1
//				if (__out_alu_data[7:0] != __oracle_alu_out_data[7:0])
//				begin
//				$display("TestBenchAlu:  Wrong data!:  %h >>> %h, %h, %h",
//					__in_alu_a, __in_alu_b, __out_alu_data,
//					__oracle_alu_out_data);
//				end
//
//				$display("TestBenchAlu stuffs:  %h, %h,   %h, %h",
//					__in_alu_a, __in_alu_b, 
//					__out_alu_data, __oracle_alu_out_data);
//			end
//		end
//	end
//
//
//endmodule

//module TestBenchCountLeadingZeros16;
//
//	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_IN:0] __in_clz16;
//	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_OUT:0] __out_clz16;
//	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_OUT:0] __oracle;
//
//	logic __did_find_zero;
//
//	Snow64CountLeadingZeros16 __inst_clz16(.in(__in_clz16),
//		.out(__out_clz16));
//
//
//	initial
//	begin
//		for (longint i=0; 
//			i<(1 << `WIDTH__SNOW64_COUNT_LEADING_ZEROS_16_IN);
//			i=i+1)
//		begin
//			__in_clz16 = i;
//			__oracle = 0;
//			__did_find_zero = 0;
//
//			#1
//			for (longint j=15; j>=0; --j)
//			begin
//				//#1
//				//$display("j:  ", j);
//				if (!__in_clz16[j])
//				begin
//					if (!__did_find_zero)
//					begin
//						__oracle = __oracle + 1;
//					end
//				end
//				else
//				begin
//					__did_find_zero = 1;
//				end
//			end
//
//			if (__in_clz16 == 0)
//			begin
//				__oracle = 16;
//			end
//
//			#1
//			if (__out_clz16 != __oracle)
//			begin
//				$display("Eek!  %h:  %d, %d", __in_clz16, __out_clz16,
//					__oracle);
//			end
//		end
//
//		$finish;
//	end
//
//endmodule

//module ShowBFloat16Div;
//
//	logic __clk;
//
//	initial
//	begin
//		__clk = 0;
//	end
//
//	always
//	begin
//		#1
//		__clk = !__clk;
//	end
//
//	logic __dummy;
//	logic __in_bfloat16_div_start;
//	PkgSnow64BFloat16::BFloat16 __in_bfloat16_div_a, __in_bfloat16_div_b;
//
//	PkgSnow64BFloat16::PortIn_Oper __in_bfloat16_div;
//	PkgSnow64BFloat16::PortOut_Oper __out_bfloat16_div;
//
//	assign __in_bfloat16_div.start = __in_bfloat16_div_start;
//	assign __in_bfloat16_div.a = __in_bfloat16_div_a;
//	assign __in_bfloat16_div.b = __in_bfloat16_div_b;
//
//	Snow64BFloat16Div __inst_bfloat16_div(.clk(__clk),
//		.in(__in_bfloat16_div), .out(__out_bfloat16_div));
//
//
//	initial
//	begin
//		for (longint i=0; i<20; i=i+1)
//		begin
//		__dummy = 0;
//		__in_bfloat16_div_start = 0;
//		//__in_bfloat16_div_a = 'h81;
//		//__in_bfloat16_div_b = 'hb0b5;
//		//__in_bfloat16_div_a = 'h4080;
//		//__in_bfloat16_div_b = 'h80;
//		__in_bfloat16_div_a = 'h80;
//		__in_bfloat16_div_b = 'h80 + i;
//
//
//		#2
//		__in_bfloat16_div_start = 1;
//
//		#2
//		__in_bfloat16_div_start = 0;
//
//		while (!__out_bfloat16_div.data_valid)
//		begin
//			#2
//			__dummy = !__dummy;
//		end
//		//#2
//		//#2
//		//#2
//		//#2
//		//#2
//		//#2
//
//		#2
//		$display("__out_bfloat16_div.data:  %h",
//			__out_bfloat16_div.data);
//		#2
//		$display("__out_bfloat16_div.data:  %h",
//			__out_bfloat16_div.data);
//
//		//#2
//		//$display("__out_bfloat16_div.data:  %h",
//		//	__out_bfloat16_div.data);
//
//		//for (longint i=0; i<(1 << `WIDTH__SNOW64_BFLOAT16_ITSELF); i=i+1)
//		//begin
//		//	__in_bfloat16_div_a = i;
//
//		//	for (longint j=0;
//		//		j<(1 << `WIDTH__SNOW64_BFLOAT16_ITSELF);
//		//		j=j+1)
//		//	begin
//		//		__in_bfloat16_div_start = 1;
//		//		__in_bfloat16_div_b = j;
//
//		//		#2
//		//		__in_bfloat16_div_start = 0;
//
//		//		#2
//		//		#2
//		//		$display("%d",
//		//			__out_bfloat16_div.data);
//		//	end
//		//end
//		end
//
//		$finish;
//	end
//
//
//endmodule











































		// src__slash__snow64_alu_defines_header_sv














		// src__slash__snow64_cpu_defines_header_sv

module DebugSnow64Alu
	(input logic [
	((64) - 1):0] in_a, in_b,
	input logic [((4) - 1):0] in_oper,
	input logic [
	((2) - 1):0] in_type_size,
	input logic in_signedness,

	output logic [
	((64) - 1):0] out_data);

	PkgSnow64Alu::PortIn_Alu __in_alu;
	PkgSnow64Alu::PortOut_Alu __out_alu;

	Snow64Alu __inst_alu(.in(__in_alu), .out(__out_alu));

	always @(*) __in_alu.a = in_a;
	always @(*) __in_alu.b = in_b;
	always @(*) __in_alu.oper = in_oper;
	always @(*) __in_alu.type_size = in_type_size;
	always @(*) __in_alu.type_signedness = in_signedness;

	always @(*) out_data = __out_alu.data;
endmodule


//module __Snow64SubAlu(input PkgSnow64Alu::PortIn_SubAlu in,
//	output PkgSnow64Alu::PortOut_SubAlu out);
//
//	localparam __MSB_POS__DATA_INOUT
//		= `MSB_POS__SNOW64_SUB_ALU_DATA_INOUT;
//
//	logic __in_actual_carry;
//	logic __out_lts;
//	logic __performing_subtract;
//
//	SetLessThanSigned __inst_slts
//		(.in_a_msb_pos(in.a[__MSB_POS__DATA_INOUT]),
//		.in_b_msb_pos(in.b[__MSB_POS__DATA_INOUT]),
//		.in_sub_result_msb_pos(out.data[__MSB_POS__DATA_INOUT]),
//		.out_data(__out_lts));
//
//	// Performing a subtract means that we need __in_actual_carry to
//	// be set to 1'b1 **if we're ignoring in.carry**.
//	assign __performing_subtract = ((in.oper == PkgSnow64Alu::OpSub)
//		|| (in.oper == PkgSnow64Alu::OpSlt));
//
//	always @(*)
//	begin
//		out.lts = __out_lts;
//	end
//
//	always @(*)
//	begin
//		case (in.type_size)
//		PkgSnow64Cpu::TypSz8:
//		begin
//			__in_actual_carry = __performing_subtract;
//		end
//
//		//PkgSnow64Cpu::TypSz16:
//		default:
//		begin
//			case (in.index[0])
//			0:
//			begin
//				__in_actual_carry = __performing_subtract;
//			end
//
//			//1:
//			default:
//			begin
//				__in_actual_carry = in.carry;
//			end
//			endcase
//		end
//		endcase
//
//	end
//
//	always @(*)
//	begin
//		case (in.oper)
//		PkgSnow64Alu::OpAdd:
//		begin
//			{out.carry, out.data} = in.a + in.b
//				+ {{`WIDTH__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
//				__in_actual_carry};
//		end
//
//		PkgSnow64Alu::OpSub:
//		begin
//			{out.carry, out.data} = {1'b0, in.a} + {1'b0, (~in.b)}
//				+ {{`WIDTH__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
//				__in_actual_carry};
//		end
//
//		// Just repeat the "OpSub" stuff here.
//		PkgSnow64Alu::OpSlt:
//		begin
//			{out.carry, out.data} = {1'b0, in.a} + {1'b0, (~in.b)}
//				+ {{`WIDTH__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
//				__in_actual_carry};
//		end
//		PkgSnow64Alu::OpAnd:
//		begin
//			{out.carry, out.data} = in.a & in.b;
//		end
//		PkgSnow64Alu::OpOrr:
//		begin
//			{out.carry, out.data} = in.a | in.b;
//		end
//		PkgSnow64Alu::OpXor:
//		begin
//			{out.carry, out.data} = in.a ^ in.b;
//		end
//		PkgSnow64Alu::OpInv:
//		begin
//			{out.carry, out.data} = ~in.a;
//		end
//		//PkgSnow64Alu::OpNot:
//		//begin
//		//	// This is only used for 8-bit stuff
//		//	{out.carry, out.data} = !in.a;
//		//end
//
//		// Just repeat the "OpAdd" stuff here.
//		PkgSnow64Alu::OpAddAgain:
//		begin
//			{out.carry, out.data} = in.a + in.b
//				+ {{`MSB_POS__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
//				__in_actual_carry};
//		end
//
//		default:
//		begin
//			{out.carry, out.data} = 0;
//		end
//		endcase
//	end
//
//
//endmodule
//
//module Snow64Alu(input PkgSnow64Alu::PortIn_Alu in,
//	output PkgSnow64Alu::PortOut_Alu out);
//
//	// Local variables, module instantiations, and assignments
//	PkgSnow64Alu::SlicedAlu8DataInout __in_a_sliced_8, __in_b_sliced_8,
//		__temp_data_sliced_8;
//	PkgSnow64Alu::SlicedAlu16DataInout __in_a_sliced_16, __in_b_sliced_16,
//		__temp_data_sliced_16;
//	PkgSnow64Alu::SlicedAlu32DataInout __in_a_sliced_32, __in_b_sliced_32,
//		__temp_data_sliced_32;
//
//	// ...slicing a 64-bit thing into 64-bit components means you're not
//	// really doing anything.
//	PkgSnow64Alu::SlicedAlu64DataInout __in_a_sliced_64, __in_b_sliced_64,
//		__temp_data_sliced_64;
//
//	logic [PkgSnow64Alu::MSB_POS__OF_8:0]
//		__out_lsl_data_sliced_8_7, __out_lsl_data_sliced_8_6,
//		__out_lsl_data_sliced_8_5, __out_lsl_data_sliced_8_4,
//		__out_lsl_data_sliced_8_3, __out_lsl_data_sliced_8_2,
//		__out_lsl_data_sliced_8_1, __out_lsl_data_sliced_8_0,
//
//		__out_lsr_data_sliced_8_7, __out_lsr_data_sliced_8_6,
//		__out_lsr_data_sliced_8_5, __out_lsr_data_sliced_8_4,
//		__out_lsr_data_sliced_8_3, __out_lsr_data_sliced_8_2,
//		__out_lsr_data_sliced_8_1, __out_lsr_data_sliced_8_0,
//
//		__out_asr_data_sliced_8_7, __out_asr_data_sliced_8_6,
//		__out_asr_data_sliced_8_5, __out_asr_data_sliced_8_4,
//		__out_asr_data_sliced_8_3, __out_asr_data_sliced_8_2,
//		__out_asr_data_sliced_8_1, __out_asr_data_sliced_8_0;
//
//	logic [PkgSnow64Alu::MSB_POS__OF_16:0]
//		__out_lsl_data_sliced_16_3, __out_lsl_data_sliced_16_2,
//		__out_lsl_data_sliced_16_1, __out_lsl_data_sliced_16_0,
//
//		__out_lsr_data_sliced_16_3, __out_lsr_data_sliced_16_2,
//		__out_lsr_data_sliced_16_1, __out_lsr_data_sliced_16_0,
//
//		__out_asr_data_sliced_16_3, __out_asr_data_sliced_16_2,
//		__out_asr_data_sliced_16_1, __out_asr_data_sliced_16_0;
//
//	logic [PkgSnow64Alu::MSB_POS__OF_32:0]
//
//		__out_lsl_data_sliced_32_1, __out_lsl_data_sliced_32_0,
//		__out_lsr_data_sliced_32_1, __out_lsr_data_sliced_32_0,
//		__out_asr_data_sliced_32_1, __out_asr_data_sliced_32_0;
//
//	logic __out_slts_data_sliced_32_1, __out_slts_data_sliced_32_0;
//
//	logic [PkgSnow64Alu::MSB_POS__OF_64:0]
//		__out_lsl_data_sliced_64_0,
//		__out_lsr_data_sliced_64_0,
//		__out_asr_data_sliced_64_0;
//
//	logic __out_slts_data_sliced_64_0;
//
//	assign __in_a_sliced_8 = in.a;
//	assign __in_b_sliced_8 = in.b;
//
//	assign __in_a_sliced_16 = in.a;
//	assign __in_b_sliced_16 = in.b;
//
//	assign __in_a_sliced_32 = in.a;
//	assign __in_b_sliced_32 = in.b;
//
//	assign __in_a_sliced_64 = in.a;
//	assign __in_b_sliced_64 = in.b;
//
//	`define MAKE_BIT_SHIFTERS(some_width, some_num) \
//	LogicalShiftLeft``some_width __inst_lsl_``some_width``__``some_num \
//		(.in_to_shift(__in_a_sliced_``some_width``.data_``some_num), \
//		.in_amount(__in_b_sliced_``some_width``.data_``some_num), \
//		.out_data(__out_lsl_data_sliced_``some_width``_``some_num)); \
//	LogicalShiftRight``some_width __inst_lsr_``some_width``__``some_num \
//		(.in_to_shift(__in_a_sliced_``some_width``.data_``some_num), \
//		.in_amount(__in_b_sliced_``some_width``.data_``some_num), \
//		.out_data(__out_lsr_data_sliced_``some_width``_``some_num)); \
//	ArithmeticShiftRight``some_width \
//		__inst_asr_``some_width``__``some_num \
//		(.in_to_shift(__in_a_sliced_``some_width``.data_``some_num), \
//		.in_amount(__in_b_sliced_``some_width``.data_``some_num), \
//		.out_data(__out_asr_data_sliced_``some_width``_``some_num));
//
//	`MAKE_BIT_SHIFTERS(8, 7)
//	`MAKE_BIT_SHIFTERS(8, 6)
//	`MAKE_BIT_SHIFTERS(8, 5)
//	`MAKE_BIT_SHIFTERS(8, 4)
//	`MAKE_BIT_SHIFTERS(8, 3)
//	`MAKE_BIT_SHIFTERS(8, 2)
//	`MAKE_BIT_SHIFTERS(8, 1)
//	`MAKE_BIT_SHIFTERS(8, 0)
//
//	`MAKE_BIT_SHIFTERS(16, 3)
//	`MAKE_BIT_SHIFTERS(16, 2)
//	`MAKE_BIT_SHIFTERS(16, 1)
//	`MAKE_BIT_SHIFTERS(16, 0)
//
//	`MAKE_BIT_SHIFTERS(32, 1)
//	`MAKE_BIT_SHIFTERS(32, 0)
//
//	`MAKE_BIT_SHIFTERS(64, 0)
//
//	`undef MAKE_BIT_SHIFTERS
//
//	logic
//		__sub_alu_0_in_carry, __sub_alu_1_in_carry,
//		__sub_alu_2_in_carry, __sub_alu_3_in_carry,
//		__sub_alu_4_in_carry, __sub_alu_5_in_carry,
//		__sub_alu_6_in_carry, __sub_alu_7_in_carry;
//
//	logic [`MSB_POS__SNOW64_SUB_ALU_INDEX:0]
//		__sub_alu_0_in_index, __sub_alu_1_in_index,
//		__sub_alu_2_in_index, __sub_alu_3_in_index,
//		__sub_alu_4_in_index, __sub_alu_5_in_index,
//		__sub_alu_6_in_index, __sub_alu_7_in_index;
//
//	assign __sub_alu_0_in_carry = 0;
//	assign __sub_alu_1_in_carry = __out_sub_alu_0.carry;
//	assign __sub_alu_2_in_carry = __out_sub_alu_1.carry;
//	assign __sub_alu_3_in_carry = __out_sub_alu_2.carry;
//	assign __sub_alu_4_in_carry = __out_sub_alu_3.carry;
//	assign __sub_alu_5_in_carry = __out_sub_alu_4.carry;
//	assign __sub_alu_6_in_carry = __out_sub_alu_5.carry;
//	assign __sub_alu_7_in_carry = __out_sub_alu_6.carry;
//
//	assign __sub_alu_0_in_index = 0;
//	assign __sub_alu_1_in_index = 1;
//	assign __sub_alu_2_in_index = 2;
//	assign __sub_alu_3_in_index = 3;
//	assign __sub_alu_4_in_index = 4;
//	assign __sub_alu_5_in_index = 5;
//	assign __sub_alu_6_in_index = 6;
//	assign __sub_alu_7_in_index = 7;
//
//
//
//	PkgSnow64Alu::PortIn_SubAlu 
//		__in_sub_alu_0, __in_sub_alu_1, __in_sub_alu_2, __in_sub_alu_3,
//		__in_sub_alu_4, __in_sub_alu_5, __in_sub_alu_6, __in_sub_alu_7;
//	PkgSnow64Alu::PortOut_SubAlu 
//		__out_sub_alu_0, __out_sub_alu_1, __out_sub_alu_2, __out_sub_alu_3,
//		__out_sub_alu_4, __out_sub_alu_5, __out_sub_alu_6, __out_sub_alu_7;
//
//	`define ASSIGN_TO_SUB_ALU_INPUTS(some_num) \
//	always @(*) __in_sub_alu_``some_num.a \
//		= __in_a_sliced_8.data_``some_num; \
//	always @(*) __in_sub_alu_``some_num.b \
//		= __in_b_sliced_8.data_``some_num; \
//	always @(*) __in_sub_alu_``some_num.carry \
//		= __sub_alu_``some_num``_in_carry; \
//	always @(*) __in_sub_alu_``some_num``.index \
//		= __sub_alu_``some_num``_in_index; \
//	always @(*) __in_sub_alu_``some_num``.type_size = in.type_size; \
//	always @(*) __in_sub_alu_``some_num``.oper = in.oper;
//
//	`ASSIGN_TO_SUB_ALU_INPUTS(0)
//	`ASSIGN_TO_SUB_ALU_INPUTS(1)
//	`ASSIGN_TO_SUB_ALU_INPUTS(2)
//	`ASSIGN_TO_SUB_ALU_INPUTS(3)
//	`ASSIGN_TO_SUB_ALU_INPUTS(4)
//	`ASSIGN_TO_SUB_ALU_INPUTS(5)
//	`ASSIGN_TO_SUB_ALU_INPUTS(6)
//	`ASSIGN_TO_SUB_ALU_INPUTS(7)
//
//	`undef ASSIGN_TO_SUB_ALU_INPUTS
//
//	__Snow64SubAlu __inst_sub_alu_0(.in(__in_sub_alu_0),
//		.out(__out_sub_alu_0));
//	__Snow64SubAlu __inst_sub_alu_1(.in(__in_sub_alu_1),
//		.out(__out_sub_alu_1));
//	__Snow64SubAlu __inst_sub_alu_2(.in(__in_sub_alu_2),
//		.out(__out_sub_alu_2));
//	__Snow64SubAlu __inst_sub_alu_3(.in(__in_sub_alu_3),
//		.out(__out_sub_alu_3));
//	__Snow64SubAlu __inst_sub_alu_4(.in(__in_sub_alu_4),
//		.out(__out_sub_alu_4));
//	__Snow64SubAlu __inst_sub_alu_5(.in(__in_sub_alu_5),
//		.out(__out_sub_alu_5));
//	__Snow64SubAlu __inst_sub_alu_6(.in(__in_sub_alu_6),
//		.out(__out_sub_alu_6));
//	__Snow64SubAlu __inst_sub_alu_7(.in(__in_sub_alu_7),
//		.out(__out_sub_alu_7));
//
//	SetLessThanSigned __inst_slts_32_1
//		(.in_a_msb_pos(__in_a_sliced_32.data_1
//		[`MSB_POS__SNOW64_SIZE_32]),
//		.in_b_msb_pos(__in_b_sliced_32.data_1
//		[`MSB_POS__SNOW64_SIZE_32]),
//		.in_sub_result_msb_pos(__temp_data_sliced_32.data_1
//		[`MSB_POS__SNOW64_SIZE_32]),
//		.out_data(__out_slts_data_sliced_32_1));
//	SetLessThanSigned __inst_slts_32_0
//		(.in_a_msb_pos(__in_a_sliced_32.data_0
//		[`MSB_POS__SNOW64_SIZE_32]),
//		.in_b_msb_pos(__in_b_sliced_32.data_0
//		[`MSB_POS__SNOW64_SIZE_32]),
//		.in_sub_result_msb_pos(__temp_data_sliced_32.data_0
//		[`MSB_POS__SNOW64_SIZE_32]),
//		.out_data(__out_slts_data_sliced_32_0));
//	SetLessThanSigned __inst_slts_64_0
//		(.in_a_msb_pos(__in_a_sliced_64.data_0
//		[`MSB_POS__SNOW64_SIZE_64]),
//		.in_b_msb_pos(__in_b_sliced_64.data_0
//		[`MSB_POS__SNOW64_SIZE_64]),
//		.in_sub_result_msb_pos(__temp_data_sliced_64.data_0
//		[`MSB_POS__SNOW64_SIZE_64]),
//		.out_data(__out_slts_data_sliced_64_0));
//
//
//	always @(*)
//	begin
//		case (in.type_size)
//		PkgSnow64Cpu::TypSz8:
//		begin
//			out.data = __temp_data_sliced_8;
//		end
//
//		PkgSnow64Cpu::TypSz16:
//		begin
//			out.data = __temp_data_sliced_16;
//		end
//
//		PkgSnow64Cpu::TypSz32:
//		begin
//			if ((in.oper == PkgSnow64Alu::OpSlt) && in.type_signedness)
//			begin
//				out.data 
//					= {`ZERO_EXTEND(32, 1, __out_slts_data_sliced_32_1),
//					`ZERO_EXTEND(32, 1, __out_slts_data_sliced_32_0)};
//			end
//
//			else
//			begin
//				out.data = __temp_data_sliced_32;
//			end
//		end
//
//		PkgSnow64Cpu::TypSz64:
//		begin
//			if ((in.oper == PkgSnow64Alu::OpSlt) && in.type_signedness)
//			begin
//				out.data = __out_slts_data_sliced_64_0;
//			end
//
//			else
//			begin
//				out.data = __temp_data_sliced_64;
//			end
//		end
//		endcase
//	end
//
//	// 8-bit stuff
//	always @(*)
//	begin
//		case (in.oper)
//		PkgSnow64Alu::OpSlt:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_8
//					= {`ZERO_EXTEND(8, 1, !__out_sub_alu_7.carry),
//					`ZERO_EXTEND(8, 1, !__out_sub_alu_6.carry),
//					`ZERO_EXTEND(8, 1, !__out_sub_alu_5.carry),
//					`ZERO_EXTEND(8, 1, !__out_sub_alu_4.carry),
//					`ZERO_EXTEND(8, 1, !__out_sub_alu_3.carry),
//					`ZERO_EXTEND(8, 1, !__out_sub_alu_2.carry),
//					`ZERO_EXTEND(8, 1, !__out_sub_alu_1.carry),
//					`ZERO_EXTEND(8, 1, !__out_sub_alu_0.carry)};
//			end
//
//			1:
//			begin
//				__temp_data_sliced_8
//					= {`ZERO_EXTEND(8, 1, __out_sub_alu_7.lts),
//					`ZERO_EXTEND(8, 1, __out_sub_alu_6.lts),
//					`ZERO_EXTEND(8, 1, __out_sub_alu_5.lts),
//					`ZERO_EXTEND(8, 1, __out_sub_alu_4.lts),
//					`ZERO_EXTEND(8, 1, __out_sub_alu_3.lts),
//					`ZERO_EXTEND(8, 1, __out_sub_alu_2.lts),
//					`ZERO_EXTEND(8, 1, __out_sub_alu_1.lts),
//					`ZERO_EXTEND(8, 1, __out_sub_alu_0.lts)};
//			end
//			endcase
//		end
//
//		PkgSnow64Alu::OpShl:
//		begin
//			__temp_data_sliced_8
//				= {__out_lsl_data_sliced_8_7,
//				__out_lsl_data_sliced_8_6,
//				__out_lsl_data_sliced_8_5,
//				__out_lsl_data_sliced_8_4,
//				__out_lsl_data_sliced_8_3,
//				__out_lsl_data_sliced_8_2,
//				__out_lsl_data_sliced_8_1,
//				__out_lsl_data_sliced_8_0};
//		end
//
//		PkgSnow64Alu::OpShr:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_8
//					= {__out_lsr_data_sliced_8_7,
//					__out_lsr_data_sliced_8_6,
//					__out_lsr_data_sliced_8_5,
//					__out_lsr_data_sliced_8_4,
//					__out_lsr_data_sliced_8_3,
//					__out_lsr_data_sliced_8_2,
//					__out_lsr_data_sliced_8_1,
//					__out_lsr_data_sliced_8_0};
//			end
//
//			1:
//			begin
//				__temp_data_sliced_8
//					= {__out_asr_data_sliced_8_7,
//					__out_asr_data_sliced_8_6,
//					__out_asr_data_sliced_8_5,
//					__out_asr_data_sliced_8_4,
//					__out_asr_data_sliced_8_3,
//					__out_asr_data_sliced_8_2,
//					__out_asr_data_sliced_8_1,
//					__out_asr_data_sliced_8_0};
//			end
//			endcase
//		end
//
//		PkgSnow64Alu::OpNot:
//		begin
//			__temp_data_sliced_8
//				= {`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_7),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_6),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_5),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_4),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_3),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_2),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_1),
//				`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_0)};
//		end
//
//		default:
//		begin
//			__temp_data_sliced_8
//				= {__out_sub_alu_7.data, __out_sub_alu_6.data,
//				__out_sub_alu_5.data, __out_sub_alu_4.data,
//				__out_sub_alu_3.data, __out_sub_alu_2.data,
//				__out_sub_alu_1.data, __out_sub_alu_0.data};
//		end
//		endcase
//	end
//
//	// 16-bit stuff
//	always @(*)
//	begin
//		case (in.oper)
//		PkgSnow64Alu::OpSlt:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_16
//					= {`ZERO_EXTEND(16, 1, !__out_sub_alu_7.carry),
//					`ZERO_EXTEND(16, 1, !__out_sub_alu_5.carry),
//					`ZERO_EXTEND(16, 1, !__out_sub_alu_3.carry),
//					`ZERO_EXTEND(16, 1, !__out_sub_alu_1.carry)};
//			end
//
//			1:
//			begin
//				__temp_data_sliced_16
//					= {`ZERO_EXTEND(16, 1, __out_sub_alu_7.lts),
//					`ZERO_EXTEND(16, 1, __out_sub_alu_5.lts),
//					`ZERO_EXTEND(16, 1, __out_sub_alu_3.lts),
//					`ZERO_EXTEND(16, 1, __out_sub_alu_1.lts)};
//			end
//			endcase
//		end
//
//		PkgSnow64Alu::OpShl:
//		begin
//			__temp_data_sliced_16
//				= {__out_lsl_data_sliced_16_3,
//				__out_lsl_data_sliced_16_2,
//				__out_lsl_data_sliced_16_1,
//				__out_lsl_data_sliced_16_0};
//		end
//
//		PkgSnow64Alu::OpShr:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_16
//					= {__out_lsr_data_sliced_16_3,
//					__out_lsr_data_sliced_16_2,
//					__out_lsr_data_sliced_16_1,
//					__out_lsr_data_sliced_16_0};
//			end
//
//			1:
//			begin
//				__temp_data_sliced_16
//					= {__out_asr_data_sliced_16_3,
//					__out_asr_data_sliced_16_2,
//					__out_asr_data_sliced_16_1,
//					__out_asr_data_sliced_16_0};
//			end
//			endcase
//		end
//
//		PkgSnow64Alu::OpNot:
//		begin
//			__temp_data_sliced_16
//				= {`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_3),
//				`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_2),
//				`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_1),
//				`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_0)};
//		end
//
//		default:
//		begin
//			__temp_data_sliced_16
//				= {__out_sub_alu_7.data, __out_sub_alu_6.data,
//				__out_sub_alu_5.data, __out_sub_alu_4.data,
//				__out_sub_alu_3.data, __out_sub_alu_2.data,
//				__out_sub_alu_1.data, __out_sub_alu_0.data};
//		end
//		endcase
//	end
//
//	// 32-bit stuff
//	always @(*)
//	begin
//		case (in.oper)
//		PkgSnow64Alu::OpAdd:
//		begin
//			__temp_data_sliced_32
//				= {(__in_a_sliced_32.data_1 + __in_b_sliced_32.data_1),
//				(__in_a_sliced_32.data_0 + __in_b_sliced_32.data_0)};
//		end
//
//		PkgSnow64Alu::OpSub:
//		begin
//			__temp_data_sliced_32
//				= {(__in_a_sliced_32.data_1 - __in_b_sliced_32.data_1),
//				(__in_a_sliced_32.data_0 - __in_b_sliced_32.data_0)};
//		end
//
//		PkgSnow64Alu::OpSlt:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_32
//					= {`ZERO_EXTEND(32, 1, 
//					(__in_a_sliced_32.data_1 < __in_b_sliced_32.data_1)),
//					`ZERO_EXTEND(32, 1, 
//					(__in_a_sliced_32.data_0 < __in_b_sliced_32.data_0))};
//			end
//
//			1:
//			begin
//				__temp_data_sliced_32
//					= {(__in_a_sliced_32.data_1 - __in_b_sliced_32.data_1),
//					(__in_a_sliced_32.data_0 - __in_b_sliced_32.data_0)};
//			end
//			endcase
//		end
//
//		PkgSnow64Alu::OpShl:
//		begin
//			__temp_data_sliced_32
//				= {__out_lsl_data_sliced_32_1, __out_lsl_data_sliced_32_0};
//		end
//		PkgSnow64Alu::OpShr:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_32
//					= {__out_lsr_data_sliced_32_1, 
//					__out_lsr_data_sliced_32_0};
//			end
//
//			1:
//			begin
//				__temp_data_sliced_32
//					= {__out_asr_data_sliced_32_1, 
//					__out_asr_data_sliced_32_0};
//			end
//			endcase
//		end
//		PkgSnow64Alu::OpNot:
//		begin
//			__temp_data_sliced_32
//				= {`ZERO_EXTEND(32, 1, !__in_a_sliced_32.data_1),
//				`ZERO_EXTEND(32, 1, !__in_a_sliced_32.data_0)};
//		end
//
//		PkgSnow64Alu::OpAddAgain:
//		begin
//			__temp_data_sliced_32
//				= {(__in_a_sliced_32.data_1 + __in_b_sliced_32.data_1),
//				(__in_a_sliced_32.data_0 + __in_b_sliced_32.data_0)};
//		end
//
//		// Operations that don't have any relation to the carry flag can
//		// just use the outputs from the 8-bit ALUs
//		default:
//		begin
//			__temp_data_sliced_32
//				= {__out_sub_alu_7.data, __out_sub_alu_6.data,
//				__out_sub_alu_5.data, __out_sub_alu_4.data,
//				__out_sub_alu_3.data, __out_sub_alu_2.data,
//				__out_sub_alu_1.data, __out_sub_alu_0.data};
//		end
//		endcase
//	end
//
//	// 64-bit stuff
//	always @(*)
//	begin
//		case (in.oper)
//		PkgSnow64Alu::OpAdd:
//		begin
//			__temp_data_sliced_64.data_0
//				= __in_a_sliced_64.data_0 + __in_b_sliced_64.data_0;
//		end
//
//		PkgSnow64Alu::OpSub:
//		begin
//			__temp_data_sliced_64.data_0
//				= __in_a_sliced_64.data_0 - __in_b_sliced_64.data_0;
//		end
//
//		PkgSnow64Alu::OpSlt:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_64.data_0
//					= __in_a_sliced_64.data_0 < __in_b_sliced_64.data_0;
//			end
//
//			1:
//			begin
//				__temp_data_sliced_64.data_0
//					= __in_a_sliced_64.data_0 - __in_b_sliced_64.data_0;
//			end
//			endcase
//		end
//
//		PkgSnow64Alu::OpShl:
//		begin
//			__temp_data_sliced_64.data_0 = __out_lsl_data_sliced_64_0;
//		end
//
//		PkgSnow64Alu::OpShr:
//		begin
//			case (in.type_signedness)
//			0:
//			begin
//				__temp_data_sliced_64.data_0 = __out_lsr_data_sliced_64_0;
//			end
//
//			1:
//			begin
//				__temp_data_sliced_64.data_0 = __out_asr_data_sliced_64_0;
//			end
//			endcase
//		end
//
//		PkgSnow64Alu::OpNot:
//		begin
//			__temp_data_sliced_64.data_0 = !__in_a_sliced_64.data_0;
//		end
//
//		PkgSnow64Alu::OpAddAgain:
//		begin
//			__temp_data_sliced_64.data_0
//				= __in_a_sliced_64.data_0 + __in_b_sliced_64.data_0;
//		end
//
//		// Operations that don't have any relation to the carry flag can
//		// just use the outputs from the 8-bit ALUs
//		default:
//		begin
//			__temp_data_sliced_64
//				= {__out_sub_alu_7.data, __out_sub_alu_6.data,
//				__out_sub_alu_5.data, __out_sub_alu_4.data,
//				__out_sub_alu_3.data, __out_sub_alu_2.data,
//				__out_sub_alu_1.data, __out_sub_alu_0.data};
//		end
//		endcase
//	end
//
//
//endmodule


module Snow64Alu(input PkgSnow64Alu::PortIn_Alu in,
	output PkgSnow64Alu::PortOut_Alu out);

	// Local variables, module instantiations, and assignments

	PkgSnow64Alu::SlicedAlu8DataInout 
		__in_a_sliced_8, __in_b_sliced_8, __out_data_sliced_8;
	PkgSnow64Alu::SlicedAlu16DataInout 
		__in_a_sliced_16, __in_b_sliced_16, __out_data_sliced_16;
	PkgSnow64Alu::SlicedAlu32DataInout 
		__in_a_sliced_32, __in_b_sliced_32, __out_data_sliced_32;
	PkgSnow64Alu::SlicedAlu64DataInout 
		__in_a_sliced_64, __in_b_sliced_64, __out_data_sliced_64;


	assign __in_a_sliced_8 = in.a;
	assign __in_b_sliced_8 = in.b;

	assign __in_a_sliced_16 = in.a;
	assign __in_b_sliced_16 = in.b;

	assign __in_a_sliced_32 = in.a;
	assign __in_b_sliced_32 = in.b;

	assign __in_a_sliced_64 = in.a;
	assign __in_b_sliced_64 = in.b;


	////`define MAKE_BIT_SHIFTERS(some_width, some_id_inst) \
	////	LogicalShiftLeft``some_width __inst_lsl``some_id_inst \
	////		(.in_amount(__zero_ext``some_id_inst``_in_a), \
	////		.in_to_shift(__zero_ext``some_id_inst``_in_b), \
	////		.out_data(__out_lsl``some_id_inst``_data)); \
	////	LogicalShiftRight``some_width __inst_lsr``some_id_inst \
	////		(.in_amount(__zero_ext``some_id_inst``_in_a), \
	////		.in_to_shift(__zero_ext``some_id_inst``_in_b), \
	////		.out_data(__out_lsr``some_id_inst``_data)); \
	////	ArithmeticShiftRight``some_width __inst_asr``some_id_inst \
	////		(.in_amount(__sign_ext``some_id_inst``_in_a), \
	////		.in_to_shift(__zero_ext``some_id_inst``_in_b), \
	////		.out_data(__out_asr``some_id_inst``_data));
	//`define MAKE_INST_LSL(some_width, some_inst_lsl_name, 
	//	some_in_to_shift, some_in_amount, some_out_lsl_data) \
	//	LogicalShiftLeft``some_width some_inst_lsl_name \
	//		(.in_to_shift(some_in_to_shift), \
	//		.in_amount(some_in_amount), \
	//		.out_data(some_out_lsl_data)); \

	//`define MAKE_INST_LSR(some_width, some_inst_lsr_name,
	//	some_in_to_shift, some_in_amount, some_out_lsr_data) \
	//	LogicalShiftRight``some_width some_inst_lsr_name \
	//		(.in_to_shift(some_in_to_shift), \
	//		.in_amount(some_in_amount), \
	//		.out_data(some_out_lsr_data)); \

	//`define MAKE_INST_ASR(some_width, some_inst_asr_name,
	//	some_in_to_shift, some_in_amount, some_out_asr_data) \
	//	ArithmeticShiftRight``some_width some_inst_asr_name \
	//		(.in_to_shift(some_in_to_shift), \
	//		.in_amount(some_in_amount), \
	//		.out_data(some_out_asr_data)); \

	logic [
	((64) - 1):0]
		__zero_ext_64_0_in_a, __zero_ext_64_0_in_b,
		__sign_ext_64_0_in_a, __sign_ext_64_0_in_b,
		__out_lsl_64_0_data,
		__out_lsr_64_0_data,
		__out_asr_64_0_data,
		__out_slts_64_0_data;
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__7__DATA_INOUT))
	//	`INST_8__7(__inst_slts) (.in_a(`INST_8__7_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__7_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__7_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__7__DATA_INOUT, `INST_8__7(__inst_lsl), 
	//	`INST_8__7_S(__zero_ext, _in_a), `INST_8__7_S(__zero_ext, _in_b),
	//	`INST_8__7_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__7__DATA_INOUT, `INST_8__7(__inst_lsr), 
	//	`INST_8__7_S(__zero_ext, _in_a), `INST_8__7_S(__zero_ext, _in_b),
	//	`INST_8__7_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__7__DATA_INOUT, `INST_8__7(__inst_asr), 
	//	`INST_8__7_S(__sign_ext, _in_a), `INST_8__7_S(__zero_ext, _in_b),
	//	`INST_8__7_S(__out_asr, _data))

	logic [
	((32) - 1):0]
		__zero_ext_32_0_in_a, __zero_ext_32_0_in_b,
		__sign_ext_32_0_in_a, __sign_ext_32_0_in_b,
		__out_lsl_32_0_data,
		__out_lsr_32_0_data,
		__out_asr_32_0_data,
		__out_slts_32_0_data;
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__6__DATA_INOUT))
	//	`INST_8__6(__inst_slts) (.in_a(`INST_8__6_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__6_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__6_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__6__DATA_INOUT, `INST_8__6(__inst_lsl), 
	//	`INST_8__6_S(__zero_ext, _in_a), `INST_8__6_S(__zero_ext, _in_b),
	//	`INST_8__6_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__6__DATA_INOUT, `INST_8__6(__inst_lsr), 
	//	`INST_8__6_S(__zero_ext, _in_a), `INST_8__6_S(__zero_ext, _in_b),
	//	`INST_8__6_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__6__DATA_INOUT, `INST_8__6(__inst_asr), 
	//	`INST_8__6_S(__sign_ext, _in_a), `INST_8__6_S(__zero_ext, _in_b),
	//	`INST_8__6_S(__out_asr, _data))

	logic [
	((16) - 1):0]
		__zero_ext_16_1_in_a, __zero_ext_16_1_in_b,
		__sign_ext_16_1_in_a, __sign_ext_16_1_in_b,
		__out_lsl_16_1_data,
		__out_lsr_16_1_data,
		__out_asr_16_1_data,
		__out_slts_16_1_data;
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__5__DATA_INOUT))
	//	`INST_8__5(__inst_slts) (.in_a(`INST_8__5_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__5_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__5_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__5__DATA_INOUT, `INST_8__5(__inst_lsl), 
	//	`INST_8__5_S(__zero_ext, _in_a), `INST_8__5_S(__zero_ext, _in_b),
	//	`INST_8__5_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__5__DATA_INOUT, `INST_8__5(__inst_lsr), 
	//	`INST_8__5_S(__zero_ext, _in_a), `INST_8__5_S(__zero_ext, _in_b),
	//	`INST_8__5_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__5__DATA_INOUT, `INST_8__5(__inst_asr), 
	//	`INST_8__5_S(__sign_ext, _in_a), `INST_8__5_S(__zero_ext, _in_b),
	//	`INST_8__5_S(__out_asr, _data))

	logic [
	((16) - 1):0]
		__zero_ext_16_0_in_a, __zero_ext_16_0_in_b,
		__sign_ext_16_0_in_a, __sign_ext_16_0_in_b,
		__out_lsl_16_0_data,
		__out_lsr_16_0_data,
		__out_asr_16_0_data,
		__out_slts_16_0_data;
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__4__DATA_INOUT))
	//	`INST_8__4(__inst_slts) (.in_a(`INST_8__4_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__4_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__4_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__4__DATA_INOUT, `INST_8__4(__inst_lsl), 
	//	`INST_8__4_S(__zero_ext, _in_a), `INST_8__4_S(__zero_ext, _in_b),
	//	`INST_8__4_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__4__DATA_INOUT, `INST_8__4(__inst_lsr), 
	//	`INST_8__4_S(__zero_ext, _in_a), `INST_8__4_S(__zero_ext, _in_b),
	//	`INST_8__4_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__4__DATA_INOUT, `INST_8__4(__inst_asr), 
	//	`INST_8__4_S(__sign_ext, _in_a), `INST_8__4_S(__zero_ext, _in_b),
	//	`INST_8__4_S(__out_asr, _data))

	logic [
	((8) - 1):0]
		__zero_ext_8_3_in_a, __zero_ext_8_3_in_b,
		__sign_ext_8_3_in_a, __sign_ext_8_3_in_b,
		__out_lsl_8_3_data,
		__out_lsr_8_3_data,
		__out_asr_8_3_data,
		__out_slts_8_3_data;
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__3__DATA_INOUT))
	//	`INST_8__3(__inst_slts) (.in_a(`INST_8__3_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__3_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__3_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__3__DATA_INOUT, `INST_8__3(__inst_lsl), 
	//	`INST_8__3_S(__zero_ext, _in_a), `INST_8__3_S(__zero_ext, _in_b),
	//	`INST_8__3_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__3__DATA_INOUT, `INST_8__3(__inst_lsr), 
	//	`INST_8__3_S(__zero_ext, _in_a), `INST_8__3_S(__zero_ext, _in_b),
	//	`INST_8__3_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__3__DATA_INOUT, `INST_8__3(__inst_asr), 
	//	`INST_8__3_S(__sign_ext, _in_a), `INST_8__3_S(__zero_ext, _in_b),
	//	`INST_8__3_S(__out_asr, _data))

	logic [
	((8) - 1):0]
		__zero_ext_8_2_in_a, __zero_ext_8_2_in_b,
		__sign_ext_8_2_in_a, __sign_ext_8_2_in_b,
		__out_lsl_8_2_data,
		__out_lsr_8_2_data,
		__out_asr_8_2_data,
		__out_slts_8_2_data;
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__2__DATA_INOUT))
	//	`INST_8__2(__inst_slts) (.in_a(`INST_8__2_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__2_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__2_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__2__DATA_INOUT, `INST_8__2(__inst_lsl), 
	//	`INST_8__2_S(__zero_ext, _in_a), `INST_8__2_S(__zero_ext, _in_b),
	//	`INST_8__2_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__2__DATA_INOUT, `INST_8__2(__inst_lsr), 
	//	`INST_8__2_S(__zero_ext, _in_a), `INST_8__2_S(__zero_ext, _in_b),
	//	`INST_8__2_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__2__DATA_INOUT, `INST_8__2(__inst_asr), 
	//	`INST_8__2_S(__sign_ext, _in_a), `INST_8__2_S(__zero_ext, _in_b),
	//	`INST_8__2_S(__out_asr, _data))

	logic [
	((8) - 1):0]
		__zero_ext_8_1_in_a, __zero_ext_8_1_in_b,
		__sign_ext_8_1_in_a, __sign_ext_8_1_in_b,
		__out_lsl_8_1_data,
		__out_lsr_8_1_data,
		__out_asr_8_1_data,
		__out_slts_8_1_data;
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__1__DATA_INOUT))
	//	`INST_8__1(__inst_slts) (.in_a(`INST_8__1_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__1_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__1_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__1__DATA_INOUT, `INST_8__1(__inst_lsl), 
	//	`INST_8__1_S(__zero_ext, _in_a), `INST_8__1_S(__zero_ext, _in_b),
	//	`INST_8__1_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__1__DATA_INOUT, `INST_8__1(__inst_lsr), 
	//	`INST_8__1_S(__zero_ext, _in_a), `INST_8__1_S(__zero_ext, _in_b),
	//	`INST_8__1_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__1__DATA_INOUT, `INST_8__1(__inst_asr), 
	//	`INST_8__1_S(__sign_ext, _in_a), `INST_8__1_S(__zero_ext, _in_b),
	//	`INST_8__1_S(__out_asr, _data))

	logic [
	((8) - 1):0]
		__zero_ext_8_0_in_a, __zero_ext_8_0_in_b,
		__sign_ext_8_0_in_a, __sign_ext_8_0_in_b,
		__out_lsl_8_0_data,
		__out_lsr_8_0_data,
		__out_asr_8_0_data,
		__out_slts_8_0_data;
	//SetLessThanSigned #(.WIDTH__DATA_INOUT(`WIDTH__INST_8__0__DATA_INOUT))
	//	`INST_8__0(__inst_slts) (.in_a(`INST_8__0_S(__sign_ext, _in_a)),
	//	.in_b(`INST_8__0_S(__sign_ext, _in_b)),
	//	.out_data(`INST_8__0_S(__out_slts, _data)));
	//`MAKE_INST_LSL(`WIDTH__INST_8__0__DATA_INOUT, `INST_8__0(__inst_lsl), 
	//	`INST_8__0_S(__zero_ext, _in_a), `INST_8__0_S(__zero_ext, _in_b),
	//	`INST_8__0_S(__out_lsl, _data))
	//`MAKE_INST_LSR(`WIDTH__INST_8__0__DATA_INOUT, `INST_8__0(__inst_lsr), 
	//	`INST_8__0_S(__zero_ext, _in_a), `INST_8__0_S(__zero_ext, _in_b),
	//	`INST_8__0_S(__out_lsr, _data))
	//`MAKE_INST_ASR(`WIDTH__INST_8__0__DATA_INOUT, `INST_8__0(__inst_asr), 
	//	`INST_8__0_S(__sign_ext, _in_a), `INST_8__0_S(__zero_ext, _in_b),
	//	`INST_8__0_S(__out_asr, _data))

	












	logic [PkgSnow64Alu::MSB_POS__OF_8:0]
		__out_slts_data_sliced_8_7,
		__out_slts_data_sliced_8_6,
		__out_slts_data_sliced_8_5,
		__out_slts_data_sliced_8_4,
		__out_slts_data_sliced_8_3,
		__out_slts_data_sliced_8_2,
		__out_slts_data_sliced_8_1,
		__out_slts_data_sliced_8_0,

		__out_asr_data_sliced_8_7,
		__out_asr_data_sliced_8_6,
		__out_asr_data_sliced_8_5,
		__out_asr_data_sliced_8_4,
		__out_asr_data_sliced_8_3,
		__out_asr_data_sliced_8_2,
		__out_asr_data_sliced_8_1,
		__out_asr_data_sliced_8_0;

	logic [PkgSnow64Alu::MSB_POS__OF_16:0]
		__out_slts_data_sliced_16_3,
		__out_slts_data_sliced_16_2,
		__out_slts_data_sliced_16_1,
		__out_slts_data_sliced_16_0,

		__out_asr_data_sliced_16_3,
		__out_asr_data_sliced_16_2,
		__out_asr_data_sliced_16_1,
		__out_asr_data_sliced_16_0;

	logic [PkgSnow64Alu::MSB_POS__OF_32:0]
		__out_slts_data_sliced_32_1,
		__out_slts_data_sliced_32_0,

		__out_asr_data_sliced_32_1,
		__out_asr_data_sliced_32_0;

	logic [PkgSnow64Alu::MSB_POS__OF_64:0]
		__out_slts_data_sliced_64_0,

		__out_asr_data_sliced_64_0;

	
	ArithmeticShiftRight8
		__inst_asr_8__7
		(.in_to_shift(__in_a_sliced_8.data_7),
		.in_amount(__in_b_sliced_8.data_7),
		.out_data(__out_asr_data_sliced_8_7));
	SetLessThanSigned #(.WIDTH__DATA_INOUT(8))
		__inst_slts_8__7
		(.in_a(__in_a_sliced_8.data_7),
		.in_b(__in_b_sliced_8.data_7),
		.out_data(__out_slts_data_sliced_8_7));
	
	ArithmeticShiftRight8
		__inst_asr_8__6
		(.in_to_shift(__in_a_sliced_8.data_6),
		.in_amount(__in_b_sliced_8.data_6),
		.out_data(__out_asr_data_sliced_8_6));
	SetLessThanSigned #(.WIDTH__DATA_INOUT(8))
		__inst_slts_8__6
		(.in_a(__in_a_sliced_8.data_6),
		.in_b(__in_b_sliced_8.data_6),
		.out_data(__out_slts_data_sliced_8_6));
	
	ArithmeticShiftRight8
		__inst_asr_8__5
		(.in_to_shift(__in_a_sliced_8.data_5),
		.in_amount(__in_b_sliced_8.data_5),
		.out_data(__out_asr_data_sliced_8_5));
	SetLessThanSigned #(.WIDTH__DATA_INOUT(8))
		__inst_slts_8__5
		(.in_a(__in_a_sliced_8.data_5),
		.in_b(__in_b_sliced_8.data_5),
		.out_data(__out_slts_data_sliced_8_5));
	
	ArithmeticShiftRight8
		__inst_asr_8__4
		(.in_to_shift(__in_a_sliced_8.data_4),
		.in_amount(__in_b_sliced_8.data_4),
		.out_data(__out_asr_data_sliced_8_4));
	SetLessThanSigned #(.WIDTH__DATA_INOUT(8))
		__inst_slts_8__4
		(.in_a(__in_a_sliced_8.data_4),
		.in_b(__in_b_sliced_8.data_4),
		.out_data(__out_slts_data_sliced_8_4));
	
	ArithmeticShiftRight8
		__inst_asr_8__3
		(.in_to_shift(__in_a_sliced_8.data_3),
		.in_amount(__in_b_sliced_8.data_3),
		.out_data(__out_asr_data_sliced_8_3));
	SetLessThanSigned #(.WIDTH__DATA_INOUT(8))
		__inst_slts_8__3
		(.in_a(__in_a_sliced_8.data_3),
		.in_b(__in_b_sliced_8.data_3),
		.out_data(__out_slts_data_sliced_8_3));
	
	ArithmeticShiftRight8
		__inst_asr_8__2
		(.in_to_shift(__in_a_sliced_8.data_2),
		.in_amount(__in_b_sliced_8.data_2),
		.out_data(__out_asr_data_sliced_8_2));
	SetLessThanSigned #(.WIDTH__DATA_INOUT(8))
		__inst_slts_8__2
		(.in_a(__in_a_sliced_8.data_2),
		.in_b(__in_b_sliced_8.data_2),
		.out_data(__out_slts_data_sliced_8_2));
	
	ArithmeticShiftRight8
		__inst_asr_8__1
		(.in_to_shift(__in_a_sliced_8.data_1),
		.in_amount(__in_b_sliced_8.data_1),
		.out_data(__out_asr_data_sliced_8_1));
	SetLessThanSigned #(.WIDTH__DATA_INOUT(8))
		__inst_slts_8__1
		(.in_a(__in_a_sliced_8.data_1),
		.in_b(__in_b_sliced_8.data_1),
		.out_data(__out_slts_data_sliced_8_1));
	
	ArithmeticShiftRight8
		__inst_asr_8__0
		(.in_to_shift(__in_a_sliced_8.data_0),
		.in_amount(__in_b_sliced_8.data_0),
		.out_data(__out_asr_data_sliced_8_0));
	SetLessThanSigned #(.WIDTH__DATA_INOUT(8))
		__inst_slts_8__0
		(.in_a(__in_a_sliced_8.data_0),
		.in_b(__in_b_sliced_8.data_0),
		.out_data(__out_slts_data_sliced_8_0));

	
	ArithmeticShiftRight16
		__inst_asr_16__3
		(.in_to_shift(__in_a_sliced_16.data_3),
		.in_amount(__in_b_sliced_16.data_3),
		.out_data(__out_asr_data_sliced_16_3));
	SetLessThanSigned #(.WIDTH__DATA_INOUT(16))
		__inst_slts_16__3
		(.in_a(__in_a_sliced_16.data_3),
		.in_b(__in_b_sliced_16.data_3),
		.out_data(__out_slts_data_sliced_16_3));
	
	ArithmeticShiftRight16
		__inst_asr_16__2
		(.in_to_shift(__in_a_sliced_16.data_2),
		.in_amount(__in_b_sliced_16.data_2),
		.out_data(__out_asr_data_sliced_16_2));
	SetLessThanSigned #(.WIDTH__DATA_INOUT(16))
		__inst_slts_16__2
		(.in_a(__in_a_sliced_16.data_2),
		.in_b(__in_b_sliced_16.data_2),
		.out_data(__out_slts_data_sliced_16_2));
	
	ArithmeticShiftRight16
		__inst_asr_16__1
		(.in_to_shift(__in_a_sliced_16.data_1),
		.in_amount(__in_b_sliced_16.data_1),
		.out_data(__out_asr_data_sliced_16_1));
	SetLessThanSigned #(.WIDTH__DATA_INOUT(16))
		__inst_slts_16__1
		(.in_a(__in_a_sliced_16.data_1),
		.in_b(__in_b_sliced_16.data_1),
		.out_data(__out_slts_data_sliced_16_1));
	
	ArithmeticShiftRight16
		__inst_asr_16__0
		(.in_to_shift(__in_a_sliced_16.data_0),
		.in_amount(__in_b_sliced_16.data_0),
		.out_data(__out_asr_data_sliced_16_0));
	SetLessThanSigned #(.WIDTH__DATA_INOUT(16))
		__inst_slts_16__0
		(.in_a(__in_a_sliced_16.data_0),
		.in_b(__in_b_sliced_16.data_0),
		.out_data(__out_slts_data_sliced_16_0));

	
	ArithmeticShiftRight32
		__inst_asr_32__1
		(.in_to_shift(__in_a_sliced_32.data_1),
		.in_amount(__in_b_sliced_32.data_1),
		.out_data(__out_asr_data_sliced_32_1));
	SetLessThanSigned #(.WIDTH__DATA_INOUT(32))
		__inst_slts_32__1
		(.in_a(__in_a_sliced_32.data_1),
		.in_b(__in_b_sliced_32.data_1),
		.out_data(__out_slts_data_sliced_32_1));
	
	ArithmeticShiftRight32
		__inst_asr_32__0
		(.in_to_shift(__in_a_sliced_32.data_0),
		.in_amount(__in_b_sliced_32.data_0),
		.out_data(__out_asr_data_sliced_32_0));
	SetLessThanSigned #(.WIDTH__DATA_INOUT(32))
		__inst_slts_32__0
		(.in_a(__in_a_sliced_32.data_0),
		.in_b(__in_b_sliced_32.data_0),
		.out_data(__out_slts_data_sliced_32_0));

	
	ArithmeticShiftRight64
		__inst_asr_64__0
		(.in_to_shift(__in_a_sliced_64.data_0),
		.in_amount(__in_b_sliced_64.data_0),
		.out_data(__out_asr_data_sliced_64_0));
	SetLessThanSigned #(.WIDTH__DATA_INOUT(64))
		__inst_slts_64__0
		(.in_a(__in_a_sliced_64.data_0),
		.in_b(__in_b_sliced_64.data_0),
		.out_data(__out_slts_data_sliced_64_0));

	


	//// Zero extend and sign extend the inputs
	//always @(*)
	//begin
	//	case (in.type_size)
	//	PkgSnow64Cpu::TypSz8:
	//	begin
	//		{`INST_8__7_S(__zero_ext, _in_a),
	//			`INST_8__7_S(__zero_ext, _in_b),
	//			`INST_8__7_S(__sign_ext, _in_a),
	//			`INST_8__7_S(__sign_ext, _in_b)}
	//			= {`ZERO_EXTEND(`WIDTH__INST_8__7__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_7),
	//			`ZERO_EXTEND(`WIDTH__INST_8__7__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_7),
	//			`SIGN_EXTEND(`WIDTH__INST_8__7__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_7),
	//			`SIGN_EXTEND(`WIDTH__INST_8__7__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_7)};
	//	end

	//	PkgSnow64Cpu::TypSz16:
	//	begin
	//		{`INST_16__3_S(__zero_ext, _in_a),
	//			`INST_16__3_S(__zero_ext, _in_b),
	//			`INST_16__3_S(__sign_ext, _in_a),
	//			`INST_16__3_S(__sign_ext, _in_b)}
	//			= {`ZERO_EXTEND(`WIDTH__INST_16__3__DATA_INOUT, 16,
	//			__in_a_sliced_16.data_3),
	//			`ZERO_EXTEND(`WIDTH__INST_16__3__DATA_INOUT, 16,
	//			__in_b_sliced_16.data_3),
	//			`SIGN_EXTEND(`WIDTH__INST_16__3__DATA_INOUT, 16,
	//			__in_a_sliced_16.data_3),
	//			`SIGN_EXTEND(`WIDTH__INST_16__3__DATA_INOUT, 16,
	//			__in_b_sliced_16.data_3)};
	//	end

	//	PkgSnow64Cpu::TypSz32:
	//	begin
	//		{`INST_32__1_S(__zero_ext, _in_a),
	//			`INST_32__1_S(__zero_ext, _in_b),
	//			`INST_32__1_S(__sign_ext, _in_a),
	//			`INST_32__1_S(__sign_ext, _in_b)}
	//			= {`ZERO_EXTEND(`WIDTH__INST_32__1__DATA_INOUT, 32,
	//			__in_a_sliced_32.data_1),
	//			`ZERO_EXTEND(`WIDTH__INST_32__1__DATA_INOUT, 32,
	//			__in_b_sliced_32.data_1),
	//			`SIGN_EXTEND(`WIDTH__INST_32__1__DATA_INOUT, 32,
	//			__in_a_sliced_32.data_1),
	//			`SIGN_EXTEND(`WIDTH__INST_32__1__DATA_INOUT, 32,
	//			__in_b_sliced_32.data_1)};
	//	end

	//	PkgSnow64Cpu::TypSz64:
	//	begin
	//		{`INST_64__0_S(__zero_ext, _in_a),
	//			`INST_64__0_S(__zero_ext, _in_b),
	//			`INST_64__0_S(__sign_ext, _in_a),
	//			`INST_64__0_S(__sign_ext, _in_b)}
	//			= {__in_a_sliced_64.data_0,
	//			__in_b_sliced_64.data_0,
	//			__in_a_sliced_64.data_0,
	//			__in_b_sliced_64.data_0};
	//	end
	//	endcase
	//end

	//always @(*)
	//begin
	//	case (in.type_size)
	//	PkgSnow64Cpu::TypSz8:
	//	begin
	//		{`INST_8__6_S(__zero_ext, _in_a),
	//			`INST_8__6_S(__zero_ext, _in_b),
	//			`INST_8__6_S(__sign_ext, _in_a),
	//			`INST_8__6_S(__sign_ext, _in_b)}
	//			= {`ZERO_EXTEND(`WIDTH__INST_8__6__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_6),
	//			`ZERO_EXTEND(`WIDTH__INST_8__6__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_6),
	//			`SIGN_EXTEND(`WIDTH__INST_8__6__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_6),
	//			`SIGN_EXTEND(`WIDTH__INST_8__6__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_6)};
	//	end

	//	PkgSnow64Cpu::TypSz16:
	//	begin
	//		{`INST_16__2_S(__zero_ext, _in_a),
	//			`INST_16__2_S(__zero_ext, _in_b),
	//			`INST_16__2_S(__sign_ext, _in_a),
	//			`INST_16__2_S(__sign_ext, _in_b)}
	//			= {`ZERO_EXTEND(`WIDTH__INST_16__2__DATA_INOUT, 16,
	//			__in_a_sliced_16.data_2),
	//			`ZERO_EXTEND(`WIDTH__INST_16__2__DATA_INOUT, 16,
	//			__in_b_sliced_16.data_2),
	//			`SIGN_EXTEND(`WIDTH__INST_16__2__DATA_INOUT, 16,
	//			__in_a_sliced_16.data_2),
	//			`SIGN_EXTEND(`WIDTH__INST_16__2__DATA_INOUT, 16,
	//			__in_b_sliced_16.data_2)};
	//	end

	//	//PkgSnow64Cpu::TypSz32:
	//	default:
	//	begin
	//		{`INST_32__0_S(__zero_ext, _in_a),
	//			`INST_32__0_S(__zero_ext, _in_b),
	//			`INST_32__0_S(__sign_ext, _in_a),
	//			`INST_32__0_S(__sign_ext, _in_b)}
	//			= { __in_a_sliced_32.data_0,
	//			__in_b_sliced_32.data_0,
	//			__in_a_sliced_32.data_0,
	//			__in_b_sliced_32.data_0};
	//	end
	//	endcase
	//end

	//always @(*)
	//begin
	//	case (in.type_size)
	//	PkgSnow64Cpu::TypSz8:
	//	begin
	//		{`INST_8__5_S(__zero_ext, _in_a),
	//			`INST_8__5_S(__zero_ext, _in_b),
	//			`INST_8__5_S(__sign_ext, _in_a),
	//			`INST_8__5_S(__sign_ext, _in_b)}
	//			= {`ZERO_EXTEND(`WIDTH__INST_8__5__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_5),
	//			`ZERO_EXTEND(`WIDTH__INST_8__5__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_5),
	//			`SIGN_EXTEND(`WIDTH__INST_8__5__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_5),
	//			`SIGN_EXTEND(`WIDTH__INST_8__5__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_5)};
	//	end

	//	//PkgSnow64Cpu::TypSz16:
	//	default:
	//	begin
	//		{`INST_16__1_S(__zero_ext, _in_a),
	//			`INST_16__1_S(__zero_ext, _in_b),
	//			`INST_16__1_S(__sign_ext, _in_a),
	//			`INST_16__1_S(__sign_ext, _in_b)}
	//			= {__in_a_sliced_16.data_1, 
	//			__in_b_sliced_16.data_1, 
	//			__in_a_sliced_16.data_1, 
	//			__in_b_sliced_16.data_1};
	//	end
	//	endcase
	//end

	//always @(*)
	//begin
	//	case (in.type_size)
	//	PkgSnow64Cpu::TypSz8:
	//	begin
	//		{`INST_8__4_S(__zero_ext, _in_a),
	//			`INST_8__4_S(__zero_ext, _in_b),
	//			`INST_8__4_S(__sign_ext, _in_a),
	//			`INST_8__4_S(__sign_ext, _in_b)}
	//			= {`ZERO_EXTEND(`WIDTH__INST_8__4__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_4),
	//			`ZERO_EXTEND(`WIDTH__INST_8__4__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_4),
	//			`SIGN_EXTEND(`WIDTH__INST_8__4__DATA_INOUT, 8,
	//			__in_a_sliced_8.data_4),
	//			`SIGN_EXTEND(`WIDTH__INST_8__4__DATA_INOUT, 8,
	//			__in_b_sliced_8.data_4)};
	//	end

	//	//PkgSnow64Cpu::TypSz16:
	//	default:
	//	begin
	//		{`INST_16__0_S(__zero_ext, _in_a),
	//			`INST_16__0_S(__zero_ext, _in_b),
	//			`INST_16__0_S(__sign_ext, _in_a),
	//			`INST_16__0_S(__sign_ext, _in_b)}
	//			= {__in_a_sliced_16.data_0,
	//			__in_b_sliced_16.data_0,
	//			__in_a_sliced_16.data_0,
	//			__in_b_sliced_16.data_0};
	//	end
	//	endcase
	//end

	//always @(*)
	//begin
	//	{`INST_8__3_S(__zero_ext, _in_a),
	//		`INST_8__3_S(__zero_ext, _in_b),
	//		`INST_8__3_S(__sign_ext, _in_a),
	//		`INST_8__3_S(__sign_ext, _in_b)}
	//		= {__in_a_sliced_8.data_3,
	//		__in_b_sliced_8.data_3,
	//		__in_a_sliced_8.data_3,
	//		__in_b_sliced_8.data_3};
	//end
	//always @(*)
	//begin
	//	{`INST_8__2_S(__zero_ext, _in_a),
	//		`INST_8__2_S(__zero_ext, _in_b),
	//		`INST_8__2_S(__sign_ext, _in_a),
	//		`INST_8__2_S(__sign_ext, _in_b)}
	//		= {__in_a_sliced_8.data_2,
	//		__in_b_sliced_8.data_2,
	//		__in_a_sliced_8.data_2,
	//		__in_b_sliced_8.data_2};
	//end
	//always @(*)
	//begin
	//	{`INST_8__1_S(__zero_ext, _in_a),
	//		`INST_8__1_S(__zero_ext, _in_b),
	//		`INST_8__1_S(__sign_ext, _in_a),
	//		`INST_8__1_S(__sign_ext, _in_b)}
	//		= {__in_a_sliced_8.data_1,
	//		__in_b_sliced_8.data_1,
	//		__in_a_sliced_8.data_1,
	//		__in_b_sliced_8.data_1};
	//end
	//always @(*)
	//begin
	//	{`INST_8__0_S(__zero_ext, _in_a),
	//		`INST_8__0_S(__zero_ext, _in_b),
	//		`INST_8__0_S(__sign_ext, _in_a),
	//		`INST_8__0_S(__sign_ext, _in_b)}
	//		= {__in_a_sliced_8.data_0,
	//		__in_b_sliced_8.data_0,
	//		__in_a_sliced_8.data_0,
	//		__in_b_sliced_8.data_0};
	//end

	// Non-shift bitwise operations treat "in.a" and "in.b" as if they're
	// just 64-bit bit vectors, and so every "in.type_size" value will
	// cause the same result to occur.  This allows me to slightly shrink
	// the ALU.
	logic [PkgSnow64Alu::MSB_POS__OF_64:0] __out_non_shift_bitwise_data;

	always @(*)
	begin
		case (in.oper)
		PkgSnow64Alu::OpAnd:
		begin
			__out_non_shift_bitwise_data = in.a & in.b;
		end

		PkgSnow64Alu::OpOrr:
		begin
			__out_non_shift_bitwise_data = in.a | in.b;
		end

		PkgSnow64Alu::OpXor:
		begin
			__out_non_shift_bitwise_data = in.a ^ in.b;
		end

		PkgSnow64Alu::OpInv:
		begin
			__out_non_shift_bitwise_data = ~in.a;
		end

		default:
		begin
			__out_non_shift_bitwise_data = 0;
		end
		endcase
	end

	always @(*)
	begin
		case (in.oper)
		PkgSnow64Alu::OpAdd:
		begin
			__out_data_sliced_8
				= {(__in_a_sliced_8.data_7 + __in_b_sliced_8.data_7),
				(__in_a_sliced_8.data_6 + __in_b_sliced_8.data_6),
				(__in_a_sliced_8.data_5 + __in_b_sliced_8.data_5),
				(__in_a_sliced_8.data_4 + __in_b_sliced_8.data_4),
				(__in_a_sliced_8.data_3 + __in_b_sliced_8.data_3),
				(__in_a_sliced_8.data_2 + __in_b_sliced_8.data_2),
				(__in_a_sliced_8.data_1 + __in_b_sliced_8.data_1),
				(__in_a_sliced_8.data_0 + __in_b_sliced_8.data_0)};
		end

		PkgSnow64Alu::OpSub:
		begin
			__out_data_sliced_8
				= {(__in_a_sliced_8.data_7 - __in_b_sliced_8.data_7),
				(__in_a_sliced_8.data_6 - __in_b_sliced_8.data_6),
				(__in_a_sliced_8.data_5 - __in_b_sliced_8.data_5),
				(__in_a_sliced_8.data_4 - __in_b_sliced_8.data_4),
				(__in_a_sliced_8.data_3 - __in_b_sliced_8.data_3),
				(__in_a_sliced_8.data_2 - __in_b_sliced_8.data_2),
				(__in_a_sliced_8.data_1 - __in_b_sliced_8.data_1),
				(__in_a_sliced_8.data_0 - __in_b_sliced_8.data_0)};
		end

		PkgSnow64Alu::OpSlt:
		begin
			case (in.type_signedness)
			0:
			begin
				__out_data_sliced_8
					= {

	{{(8 - 1){1'b0}}, __in_a_sliced_8.data_7 < __in_b_sliced_8.data_7},
					

	{{(8 - 1){1'b0}}, __in_a_sliced_8.data_6 < __in_b_sliced_8.data_6},
					

	{{(8 - 1){1'b0}}, __in_a_sliced_8.data_5 < __in_b_sliced_8.data_5},
					

	{{(8 - 1){1'b0}}, __in_a_sliced_8.data_4 < __in_b_sliced_8.data_4},
					

	{{(8 - 1){1'b0}}, __in_a_sliced_8.data_3 < __in_b_sliced_8.data_3},
					

	{{(8 - 1){1'b0}}, __in_a_sliced_8.data_2 < __in_b_sliced_8.data_2},
					

	{{(8 - 1){1'b0}}, __in_a_sliced_8.data_1 < __in_b_sliced_8.data_1},
					

	{{(8 - 1){1'b0}}, __in_a_sliced_8.data_0 < __in_b_sliced_8.data_0}};
			end

			1:
			begin
				//__out_data_sliced_8
				//	= {`INST_8__7_S(__out_slts, _data)[7:0],
				//	`INST_8__6_S(__out_slts, _data)[7:0],
				//	`INST_8__5_S(__out_slts, _data)[7:0],
				//	`INST_8__4_S(__out_slts, _data)[7:0],
				//	`INST_8__3_S(__out_slts, _data)[7:0],
				//	`INST_8__2_S(__out_slts, _data)[7:0],
				//	`INST_8__1_S(__out_slts, _data)[7:0],
				//	`INST_8__0_S(__out_slts, _data)[7:0]};
				__out_data_sliced_8
					= {__out_slts_data_sliced_8_7,
					__out_slts_data_sliced_8_6,
					__out_slts_data_sliced_8_5,
					__out_slts_data_sliced_8_4,
					__out_slts_data_sliced_8_3,
					__out_slts_data_sliced_8_2,
					__out_slts_data_sliced_8_1,
					__out_slts_data_sliced_8_0};
			end
			endcase
		end

		PkgSnow64Alu::OpAnd:
		begin
			__out_data_sliced_8 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpOrr:
		begin
			__out_data_sliced_8 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpXor:
		begin
			__out_data_sliced_8 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpShl:
		begin
			//__out_data_sliced_8
			//	= {`INST_8__7_S(__out_lsl, _data)[7:0],
			//	`INST_8__6_S(__out_lsl, _data)[7:0],
			//	`INST_8__5_S(__out_lsl, _data)[7:0],
			//	`INST_8__4_S(__out_lsl, _data)[7:0],
			//	`INST_8__3_S(__out_lsl, _data)[7:0],
			//	`INST_8__2_S(__out_lsl, _data)[7:0],
			//	`INST_8__1_S(__out_lsl, _data)[7:0],
			//	`INST_8__0_S(__out_lsl, _data)[7:0]};
			__out_data_sliced_8
				= {(__in_a_sliced_8.data_7 << __in_b_sliced_8.data_7),
				(__in_a_sliced_8.data_6 << __in_b_sliced_8.data_6),
				(__in_a_sliced_8.data_5 << __in_b_sliced_8.data_5),
				(__in_a_sliced_8.data_4 << __in_b_sliced_8.data_4),
				(__in_a_sliced_8.data_3 << __in_b_sliced_8.data_3),
				(__in_a_sliced_8.data_2 << __in_b_sliced_8.data_2),
				(__in_a_sliced_8.data_1 << __in_b_sliced_8.data_1),
				(__in_a_sliced_8.data_0 << __in_b_sliced_8.data_0)};
		end

		PkgSnow64Alu::OpShr:
		begin
			case (in.type_signedness)
			0:
			begin
				//__out_data_sliced_8
				//	= {`INST_8__7_S(__out_lsr, _data)[7:0],
				//	`INST_8__6_S(__out_lsr, _data)[7:0],
				//	`INST_8__5_S(__out_lsr, _data)[7:0],
				//	`INST_8__4_S(__out_lsr, _data)[7:0],
				//	`INST_8__3_S(__out_lsr, _data)[7:0],
				//	`INST_8__2_S(__out_lsr, _data)[7:0],
				//	`INST_8__1_S(__out_lsr, _data)[7:0],
				//	`INST_8__0_S(__out_lsr, _data)[7:0]};
				__out_data_sliced_8
					= {(__in_a_sliced_8.data_7 >> __in_b_sliced_8.data_7),
					(__in_a_sliced_8.data_6 >> __in_b_sliced_8.data_6),
					(__in_a_sliced_8.data_5 >> __in_b_sliced_8.data_5),
					(__in_a_sliced_8.data_4 >> __in_b_sliced_8.data_4),
					(__in_a_sliced_8.data_3 >> __in_b_sliced_8.data_3),
					(__in_a_sliced_8.data_2 >> __in_b_sliced_8.data_2),
					(__in_a_sliced_8.data_1 >> __in_b_sliced_8.data_1),
					(__in_a_sliced_8.data_0 >> __in_b_sliced_8.data_0)};
			end

			1:
			begin
				//__out_data_sliced_8
				//	= {`INST_8__7_S(__out_asr, _data)[7:0],
				//	`INST_8__6_S(__out_asr, _data)[7:0],
				//	`INST_8__5_S(__out_asr, _data)[7:0],
				//	`INST_8__4_S(__out_asr, _data)[7:0],
				//	`INST_8__3_S(__out_asr, _data)[7:0],
				//	`INST_8__2_S(__out_asr, _data)[7:0],
				//	`INST_8__1_S(__out_asr, _data)[7:0],
				//	`INST_8__0_S(__out_asr, _data)[7:0]};
				__out_data_sliced_8
					= {__out_asr_data_sliced_8_7,
					__out_asr_data_sliced_8_6,
					__out_asr_data_sliced_8_5,
					__out_asr_data_sliced_8_4,
					__out_asr_data_sliced_8_3,
					__out_asr_data_sliced_8_2,
					__out_asr_data_sliced_8_1,
					__out_asr_data_sliced_8_0};
			end
			endcase
		end

		PkgSnow64Alu::OpInv:
		begin
			__out_data_sliced_8 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpNot:
		begin
			__out_data_sliced_8
				= {
	{{(8 - 1){1'b0}},!__in_a_sliced_8.data_7},
				
	{{(8 - 1){1'b0}},!__in_a_sliced_8.data_6},
				
	{{(8 - 1){1'b0}},!__in_a_sliced_8.data_5},
				
	{{(8 - 1){1'b0}},!__in_a_sliced_8.data_4},
				
	{{(8 - 1){1'b0}},!__in_a_sliced_8.data_3},
				
	{{(8 - 1){1'b0}},!__in_a_sliced_8.data_2},
				
	{{(8 - 1){1'b0}},!__in_a_sliced_8.data_1},
				
	{{(8 - 1){1'b0}},!__in_a_sliced_8.data_0}};
		end

		PkgSnow64Alu::OpAddAgain:
		begin
			__out_data_sliced_8
				= {(__in_a_sliced_8.data_7 + __in_b_sliced_8.data_7),
				(__in_a_sliced_8.data_6 + __in_b_sliced_8.data_6),
				(__in_a_sliced_8.data_5 + __in_b_sliced_8.data_5),
				(__in_a_sliced_8.data_4 + __in_b_sliced_8.data_4),
				(__in_a_sliced_8.data_3 + __in_b_sliced_8.data_3),
				(__in_a_sliced_8.data_2 + __in_b_sliced_8.data_2),
				(__in_a_sliced_8.data_1 + __in_b_sliced_8.data_1),
				(__in_a_sliced_8.data_0 + __in_b_sliced_8.data_0)};
		end

		default:
		begin
			__out_data_sliced_8 = 0;
		end

		endcase
	end

	always @(*)
	begin
		case (in.oper)
		PkgSnow64Alu::OpAdd:
		begin
			__out_data_sliced_16
				= {(__in_a_sliced_16.data_3 + __in_b_sliced_16.data_3),
				(__in_a_sliced_16.data_2 + __in_b_sliced_16.data_2),
				(__in_a_sliced_16.data_1 + __in_b_sliced_16.data_1),
				(__in_a_sliced_16.data_0 + __in_b_sliced_16.data_0)};
		end

		PkgSnow64Alu::OpSub:
		begin
			__out_data_sliced_16
				= {(__in_a_sliced_16.data_3 - __in_b_sliced_16.data_3),
				(__in_a_sliced_16.data_2 - __in_b_sliced_16.data_2),
				(__in_a_sliced_16.data_1 - __in_b_sliced_16.data_1),
				(__in_a_sliced_16.data_0 - __in_b_sliced_16.data_0)};
		end

		PkgSnow64Alu::OpSlt:
		begin
			case (in.type_signedness)
			0:
			begin
				__out_data_sliced_16
					= {

	{{(16 - 1){1'b0}}, __in_a_sliced_16.data_3 < __in_b_sliced_16.data_3},
					

	{{(16 - 1){1'b0}}, __in_a_sliced_16.data_2 < __in_b_sliced_16.data_2},
					

	{{(16 - 1){1'b0}}, __in_a_sliced_16.data_1 < __in_b_sliced_16.data_1},
					

	{{(16 - 1){1'b0}}, __in_a_sliced_16.data_0 < __in_b_sliced_16.data_0}};
			end

			1:
			begin
				//__out_data_sliced_16
				//	= {`INST_16__3_S(__out_slts, _data)[15:0],
				//	`INST_16__2_S(__out_slts, _data)[15:0],
				//	`INST_16__1_S(__out_slts, _data)[15:0],
				//	`INST_16__0_S(__out_slts, _data)[15:0]};
				__out_data_sliced_16
					= {__out_slts_data_sliced_16_3,
					__out_slts_data_sliced_16_2,
					__out_slts_data_sliced_16_1,
					__out_slts_data_sliced_16_0};
			end
			endcase
		end

		PkgSnow64Alu::OpAnd:
		begin
			__out_data_sliced_16 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpOrr:
		begin
			__out_data_sliced_16 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpXor:
		begin
			__out_data_sliced_16 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpShl:
		begin
			//__out_data_sliced_16
			//	= {`INST_16__3_S(__out_lsl, _data)[15:0],
			//	`INST_16__2_S(__out_lsl, _data)[15:0],
			//	`INST_16__1_S(__out_lsl, _data)[15:0],
			//	`INST_16__0_S(__out_lsl, _data)[15:0]};
			__out_data_sliced_16
				= {(__in_a_sliced_16.data_3 << __in_b_sliced_16.data_3),
				(__in_a_sliced_16.data_2 << __in_b_sliced_16.data_2),
				(__in_a_sliced_16.data_1 << __in_b_sliced_16.data_1),
				(__in_a_sliced_16.data_0 << __in_b_sliced_16.data_0)};
		end

		PkgSnow64Alu::OpShr:
		begin
			case (in.type_signedness)
			0:
			begin
				//__out_data_sliced_16
				//	= {`INST_16__3_S(__out_lsr, _data)[15:0],
				//	`INST_16__2_S(__out_lsr, _data)[15:0],
				//	`INST_16__1_S(__out_lsr, _data)[15:0],
				//	`INST_16__0_S(__out_lsr, _data)[15:0]};
				__out_data_sliced_16
					= {(__in_a_sliced_16.data_3
					>> __in_b_sliced_16.data_3),
					(__in_a_sliced_16.data_2
					>> __in_b_sliced_16.data_2),
					(__in_a_sliced_16.data_1
					>> __in_b_sliced_16.data_1),
					(__in_a_sliced_16.data_0
					>> __in_b_sliced_16.data_0)};
			end

			1:
			begin
				//__out_data_sliced_16
				//	= {`INST_16__3_S(__out_asr, _data)[15:0],
				//	`INST_16__2_S(__out_asr, _data)[15:0],
				//	`INST_16__1_S(__out_asr, _data)[15:0],
				//	`INST_16__0_S(__out_asr, _data)[15:0]};
				//__out_data_sliced_16
				//	= {($signed(__in_a_sliced_16.data_3)
				//	>>> __in_b_sliced_16.data_3),
				//	($signed(__in_a_sliced_16.data_2)
				//	>>> __in_b_sliced_16.data_2),
				//	($signed(__in_a_sliced_16.data_1)
				//	>>> __in_b_sliced_16.data_1),
				//	($signed(__in_a_sliced_16.data_0)
				//	>>> __in_b_sliced_16.data_0)};
				__out_data_sliced_16
					= {__out_asr_data_sliced_16_3,
					__out_asr_data_sliced_16_2,
					__out_asr_data_sliced_16_1,
					__out_asr_data_sliced_16_0};
			end
			endcase
		end

		PkgSnow64Alu::OpInv:
		begin
			__out_data_sliced_16 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpNot:
		begin
			__out_data_sliced_16
				= {
	{{(16 - 1){1'b0}},!__in_a_sliced_16.data_3},
				
	{{(16 - 1){1'b0}},!__in_a_sliced_16.data_2},
				
	{{(16 - 1){1'b0}},!__in_a_sliced_16.data_1},
				
	{{(16 - 1){1'b0}},!__in_a_sliced_16.data_0}};
		end

		PkgSnow64Alu::OpAddAgain:
		begin
			__out_data_sliced_16
				= {(__in_a_sliced_16.data_3 + __in_b_sliced_16.data_3),
				(__in_a_sliced_16.data_2 + __in_b_sliced_16.data_2),
				(__in_a_sliced_16.data_1 + __in_b_sliced_16.data_1),
				(__in_a_sliced_16.data_0 + __in_b_sliced_16.data_0)};
		end

		default:
		begin
			__out_data_sliced_16 = 0;
		end

		endcase
	end

	always @(*)
	begin
		case (in.oper)
		PkgSnow64Alu::OpAdd:
		begin
			__out_data_sliced_32
				= {(__in_a_sliced_32.data_1 + __in_b_sliced_32.data_1),
				(__in_a_sliced_32.data_0 + __in_b_sliced_32.data_0)};
		end

		PkgSnow64Alu::OpSub:
		begin
			__out_data_sliced_32
				= {(__in_a_sliced_32.data_1 - __in_b_sliced_32.data_1),
				(__in_a_sliced_32.data_0 - __in_b_sliced_32.data_0)};
		end

		PkgSnow64Alu::OpSlt:
		begin
			case (in.type_signedness)
			0:
			begin
				__out_data_sliced_32
					= {

	{{(32 - 1){1'b0}}, __in_a_sliced_32.data_1 < __in_b_sliced_32.data_1},
					

	{{(32 - 1){1'b0}}, __in_a_sliced_32.data_0 < __in_b_sliced_32.data_0}};
			end

			1:
			begin
				//__out_data_sliced_32
				//	= {`INST_32__1_S(__out_slts, _data)[31:0],
				//	`INST_32__0_S(__out_slts, _data)[31:0]};
				__out_data_sliced_32
					= {__out_slts_data_sliced_32_1,
					__out_slts_data_sliced_32_0};
			end
			endcase
		end

		PkgSnow64Alu::OpAnd:
		begin
			__out_data_sliced_32 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpOrr:
		begin
			__out_data_sliced_32 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpXor:
		begin
			__out_data_sliced_32 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpShl:
		begin
			//__out_data_sliced_32
			//	= {`INST_32__1_S(__out_lsl, _data)[31:0],
			//	`INST_32__0_S(__out_lsl, _data)[31:0]};
			__out_data_sliced_32
				= {(__in_a_sliced_32.data_1 << __in_b_sliced_32.data_1),
				(__in_a_sliced_32.data_0 << __in_b_sliced_32.data_0)};
		end

		PkgSnow64Alu::OpShr:
		begin
			case (in.type_signedness)
			0:
			begin
				//__out_data_sliced_32
				//	= {`INST_32__1_S(__out_lsr, _data)[31:0],
				//	`INST_32__0_S(__out_lsr, _data)[31:0]};
				__out_data_sliced_32
					= {(__in_a_sliced_32.data_1
					>> __in_b_sliced_32.data_1),
					(__in_a_sliced_32.data_0
					>> __in_b_sliced_32.data_0)};
			end

			1:
			begin
				//__out_data_sliced_32
				//	= {`INST_32__1_S(__out_asr, _data)[31:0],
				//	`INST_32__0_S(__out_asr, _data)[31:0]};
				//__out_data_sliced_32
				//	= {($signed(__in_a_sliced_32.data_1)
				//	>>> __in_b_sliced_32.data_1),
				//	($signed(__in_a_sliced_32.data_0)
				//	>> __in_b_sliced_32.data_0)};
				__out_data_sliced_32
					= {__out_asr_data_sliced_32_1,
					__out_asr_data_sliced_32_0};
			end
			endcase
		end

		PkgSnow64Alu::OpInv:
		begin
			__out_data_sliced_32 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpNot:
		begin
			__out_data_sliced_32
				= {
	{{(32 - 1){1'b0}},!__in_a_sliced_32.data_1},
				
	{{(32 - 1){1'b0}},!__in_a_sliced_32.data_0}};
		end

		PkgSnow64Alu::OpAddAgain:
		begin
			__out_data_sliced_32
				= {(__in_a_sliced_32.data_1 + __in_b_sliced_32.data_1),
				(__in_a_sliced_32.data_0 + __in_b_sliced_32.data_0)};
		end

		default:
		begin
			__out_data_sliced_32 = 0;
		end

		endcase
	end

	always @(*)
	begin
		case (in.oper)
		PkgSnow64Alu::OpAdd:
		begin
			__out_data_sliced_64
				= {(__in_a_sliced_64.data_0 + __in_b_sliced_64.data_0)};
		end

		PkgSnow64Alu::OpSub:
		begin
			__out_data_sliced_64
				= {(__in_a_sliced_64.data_0 - __in_b_sliced_64.data_0)};
		end

		PkgSnow64Alu::OpSlt:
		begin
			case (in.type_signedness)
			0:
			begin
				__out_data_sliced_64
					= {

	{{(64 - 1){1'b0}}, __in_a_sliced_64.data_0 < __in_b_sliced_64.data_0}};
			end

			1:
			begin
				//__out_data_sliced_64
				//	= {`INST_64__0_S(__out_slts, _data)[63:0]};
				__out_data_sliced_64
					= {__out_slts_data_sliced_64_0};
			end
			endcase
		end

		PkgSnow64Alu::OpAnd:
		begin
			__out_data_sliced_64 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpOrr:
		begin
			__out_data_sliced_64 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpXor:
		begin
			__out_data_sliced_64 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpShl:
		begin
			//__out_data_sliced_64
			//	= {`INST_64__0_S(__out_lsl, _data)[63:0]};
			__out_data_sliced_64.data_0
				= __in_a_sliced_64.data_0 << __in_b_sliced_64.data_0;
		end

		PkgSnow64Alu::OpShr:
		begin
			case (in.type_signedness)
			0:
			begin
				//__out_data_sliced_64
				//	= {`INST_64__0_S(__out_lsr, _data)[63:0]};
				__out_data_sliced_64.data_0
					= __in_a_sliced_64.data_0 >> __in_b_sliced_64.data_0;
			end

			1:
			begin
				//__out_data_sliced_64
				//	= {`INST_64__0_S(__out_asr, _data)[63:0]};
				//__out_data_sliced_64.data_0
				//	= $signed($signed(__in_a_sliced_64.data_0) 
				//	>>> __in_b_sliced_64.data_0);
				__out_data_sliced_64
					= {__out_asr_data_sliced_64_0};
			end
			endcase
		end

		PkgSnow64Alu::OpInv:
		begin
			__out_data_sliced_64 = __out_non_shift_bitwise_data;
		end

		PkgSnow64Alu::OpNot:
		begin
			__out_data_sliced_64
				= {
	{{(64 - 1){1'b0}},!__in_a_sliced_64.data_0}};
		end

		PkgSnow64Alu::OpAddAgain:
		begin
			__out_data_sliced_64
				= {(__in_a_sliced_64.data_0 + __in_b_sliced_64.data_0)};
		end

		default:
		begin
			__out_data_sliced_64 = 0;
		end

		endcase
	end

	always @(*)
	begin
		case (in.type_size)
		PkgSnow64Cpu::TypSz8:
		begin
			out.data = __out_data_sliced_8;
		end

		PkgSnow64Cpu::TypSz16:
		begin
			out.data = __out_data_sliced_16;
		end

		PkgSnow64Cpu::TypSz32:
		begin
			out.data = __out_data_sliced_32;
		end

		PkgSnow64Cpu::TypSz64:
		begin
			out.data = __out_data_sliced_64;
		end
		endcase
	end


endmodule

































































		// src__slash__snow64_bfloat16_defines_header_sv


// The "slt" instruction should *definitely* actually always be
// single-cycle.
// To keep from changing the test bench, this module TEMPORARILY has an
// interface that the test bench knows about.  That will change later!
module Snow64BFloat16Slt(input PkgSnow64BFloat16::PortIn_BinOp in,
	output logic out);

	localparam __WIDTH__DATA_NO_SIGN = 16 - 1;
	localparam __MSB_POS__DATA_NO_SIGN = ((__WIDTH__DATA_NO_SIGN) - 1);

	PkgSnow64BFloat16::BFloat16 __in_a, __in_b;
	assign __in_a = in.a;
	assign __in_b = in.b;


	logic [__MSB_POS__DATA_NO_SIGN:0] __in_a_no_sign, __in_b_no_sign;
	assign __in_a_no_sign = {__in_a.enc_exp, __in_a.enc_mantissa};
	assign __in_b_no_sign = {__in_b.enc_exp, __in_b.enc_mantissa};


	logic [
	((
	(7 + 1)) - 1):0] __in_a_frac, __in_b_frac;
	assign __in_a_frac = 
	(
	((__in_a.enc_exp != 8'd0)
	&& (__in_a.enc_exp != 8'd255))
	? {1'b1, __in_a.enc_mantissa}
	: {{
	(7 + 1){1'b0}}});
	assign __in_b_frac = 
	(
	((__in_b.enc_exp != 8'd0)
	&& (__in_b.enc_exp != 8'd255))
	? {1'b1, __in_b.enc_mantissa}
	: {{
	(7 + 1){1'b0}}});

	//initial
	//begin
	//	out.data_valid = 1;
	//	out.can_accept_cmd = 1;
	//	out.data = 0;
	//end

	initial
	begin
		out = 0;
	end

	// Combinational logic
	always @(*)
	begin
		case ({__in_a.sign, __in_b.sign})
		2'b00:
		begin
			// Equal signs, both non-negative
			out = (__in_a_no_sign < __in_b_no_sign);
		end

		2'b01:
		begin
			out = 0;
		end

		2'b10:
		begin
			// The only time opposite signs allows "<" to return false
			// is when ((__in_a == 0.0f) && (__in_b == -0.0f))
			out = (!((__in_a_frac == 0) && (__in_b_frac == 0)));
		end

		2'b11:
		begin
			// Equal signs, both non-positive
			out = (__in_b_no_sign < __in_a_no_sign);
		end
		endcase
	end

endmodule

































































		// src__slash__snow64_bfloat16_defines_header_sv

module __RealSnow64BFloat16Add(input logic clk,
	input PkgSnow64BFloat16::PortIn_BinOp in,
	output PkgSnow64BFloat16::PortOut_Oper out);



	localparam __WIDTH__BUFFER_BITS = 3;
	localparam __MSB_POS__BUFFER_BITS = ((__WIDTH__BUFFER_BITS) - 1);

	//localparam __WIDTH__TEMP_SIGNIFICAND = 16 + __WIDTH__BUFFER_BITS;
	//localparam __WIDTH__TEMP_SIGNIFICAND = 24;
	//localparam __WIDTH__TEMP_SIGNIFICAND = PkgSnow64BFloat16::WIDTH__FRAC
	//	+ __WIDTH__BUFFER_BITS;
	localparam __WIDTH__TEMP_SIGNIFICAND = 16;
	localparam __MSB_POS__TEMP_SIGNIFICAND
		= ((__WIDTH__TEMP_SIGNIFICAND) - 1);


	PkgSnow64BFloat16::StateAdd __state;
	PkgSnow64BFloat16::BFloat16 __captured_in_a, __captured_in_b,
		__curr_in_a, __curr_in_b, __temp_out_data;

	logic [__MSB_POS__TEMP_SIGNIFICAND:0]
		__captured_in_a_shifted_frac, __captured_in_b_shifted_frac;
	logic [8:0] __d;
	//logic __sticky;

	logic [__MSB_POS__TEMP_SIGNIFICAND:0]
		//__a_significand, __b_significand, 
		//__ret_significand,
		__temp_a_significand, __temp_b_significand, __temp_ret_significand,
		__real_num_leading_zeros, __temp_ret_enc_exp;

	//logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_IN:0] __in_clz16;
	logic [
	((5) - 1):0] __out_clz16;


	Snow64CountLeadingZeros16 __inst_clz16(.in(__temp_ret_significand),
		.out(__out_clz16));

	assign {__curr_in_a, __curr_in_b} = {in.a, in.b};


	// Use "always @(*)" here to keep Icarus Verilog happy
	//always @(*) out.data = __temp_out_data;


	task set_some_significand;
		input[__MSB_POS__TEMP_SIGNIFICAND:0]
			some_captured_shifted_frac_0, some_captured_shifted_frac_1;

		output [__MSB_POS__TEMP_SIGNIFICAND:0]
			some_significand_to_mod, some_significand_to_copy;

		//$display("set_some_significand():  %h %h, %h %h",
		//	some_captured_shifted_frac_0, some_captured_shifted_frac_1,
		//	some_significand_to_mod, some_significand_to_copy);

		if (__d >= __WIDTH__TEMP_SIGNIFICAND)
		begin
			// Set the sticky bit
			some_significand_to_mod
				= (some_captured_shifted_frac_0 != 0);
		end
		else if (__d > 0)
		begin
			






			//	__sticky = ((`GET_BITS_WITH_RANGE(in, \
			//		some_d - 1 + __MSB_POS__BUFFER_BITS, \
			//		__MSB_POS__BUFFER_BITS)) != 0); \
			//	out = in >> some_d; \
			//	out[0] = __sticky;

			//`inner_shift_some_significand(some_captured_shifted_frac_0,
			//	__d, some_significand_to_mod)

			case (__d)
			1:
			begin
				


				some_significand_to_mod = ((some_captured_shifted_frac_0 >> 1)
					& {{__WIDTH__TEMP_SIGNIFICAND - 1{1'b1}},
					1'b0})
					| (some_captured_shifted_frac_0[(1 - 1 + __MSB_POS__BUFFER_BITS)
					:__MSB_POS__BUFFER_BITS] != 0);
;
			end

			2:
			begin
				


				some_significand_to_mod = ((some_captured_shifted_frac_0 >> 2)
					& {{__WIDTH__TEMP_SIGNIFICAND - 1{1'b1}},
					1'b0})
					| (some_captured_shifted_frac_0[(2 - 1 + __MSB_POS__BUFFER_BITS)
					:__MSB_POS__BUFFER_BITS] != 0);
;
			end

			3:
			begin
				


				some_significand_to_mod = ((some_captured_shifted_frac_0 >> 3)
					& {{__WIDTH__TEMP_SIGNIFICAND - 1{1'b1}},
					1'b0})
					| (some_captured_shifted_frac_0[(3 - 1 + __MSB_POS__BUFFER_BITS)
					:__MSB_POS__BUFFER_BITS] != 0);
;
			end

			4:
			begin
				


				some_significand_to_mod = ((some_captured_shifted_frac_0 >> 4)
					& {{__WIDTH__TEMP_SIGNIFICAND - 1{1'b1}},
					1'b0})
					| (some_captured_shifted_frac_0[(4 - 1 + __MSB_POS__BUFFER_BITS)
					:__MSB_POS__BUFFER_BITS] != 0);
;
			end

			5:
			begin
				


				some_significand_to_mod = ((some_captured_shifted_frac_0 >> 5)
					& {{__WIDTH__TEMP_SIGNIFICAND - 1{1'b1}},
					1'b0})
					| (some_captured_shifted_frac_0[(5 - 1 + __MSB_POS__BUFFER_BITS)
					:__MSB_POS__BUFFER_BITS] != 0);
;
			end

			6:
			begin
				


				some_significand_to_mod = ((some_captured_shifted_frac_0 >> 6)
					& {{__WIDTH__TEMP_SIGNIFICAND - 1{1'b1}},
					1'b0})
					| (some_captured_shifted_frac_0[(6 - 1 + __MSB_POS__BUFFER_BITS)
					:__MSB_POS__BUFFER_BITS] != 0);
;
			end

			7:
			begin
				


				some_significand_to_mod = ((some_captured_shifted_frac_0 >> 7)
					& {{__WIDTH__TEMP_SIGNIFICAND - 1{1'b1}},
					1'b0})
					| (some_captured_shifted_frac_0[(7 - 1 + __MSB_POS__BUFFER_BITS)
					:__MSB_POS__BUFFER_BITS] != 0);
;
			end

			8:
			begin
				


				some_significand_to_mod = ((some_captured_shifted_frac_0 >> 8)
					& {{__WIDTH__TEMP_SIGNIFICAND - 1{1'b1}},
					1'b0})
					| (some_captured_shifted_frac_0[(8 - 1 + __MSB_POS__BUFFER_BITS)
					:__MSB_POS__BUFFER_BITS] != 0);
;
			end

			9:
			begin
				


				some_significand_to_mod = ((some_captured_shifted_frac_0 >> 9)
					& {{__WIDTH__TEMP_SIGNIFICAND - 1{1'b1}},
					1'b0})
					| (some_captured_shifted_frac_0[(9 - 1 + __MSB_POS__BUFFER_BITS)
					:__MSB_POS__BUFFER_BITS] != 0);
;
			end

			//10:
			default:
			begin
				


				some_significand_to_mod = ((some_captured_shifted_frac_0 >> 10)
					& {{__WIDTH__TEMP_SIGNIFICAND - 1{1'b1}},
					1'b0})
					| (some_captured_shifted_frac_0[(10 - 1 + __MSB_POS__BUFFER_BITS)
					:__MSB_POS__BUFFER_BITS] != 0);
;
			end
			endcase

			
		end

		else
		begin
			some_significand_to_mod = some_captured_shifted_frac_0;
		end

		some_significand_to_copy = some_captured_shifted_frac_1;

		//$display("set_some_significand():  %h %h, %h %h",
		//	some_captured_shifted_frac_0, some_captured_shifted_frac_1,
		//	some_significand_to_mod, some_significand_to_copy);
	endtask // set_some_significand


	//always @(in.a or in.b)
	//always @(__state)

	initial
	begin
		__state = PkgSnow64BFloat16::StAddIdle;
		out.data_valid = 0;
		out.can_accept_cmd = 1;
		out.data = 0;
	end

	// Pseudo combinational logic
	always @(posedge clk)
	begin
		case (__state)
		PkgSnow64BFloat16::StAddIdle:
		begin
			if (in.start)
			begin
				out = 0;
				if (__curr_in_a.enc_exp < __curr_in_b.enc_exp)
				begin
					__d = __curr_in_b.enc_exp - __curr_in_a.enc_exp;
					__temp_out_data.enc_exp = __curr_in_b.enc_exp;
				end

				else // if (__curr_in_a.enc_exp >= __curr_in_b.enc_exp)
				begin
					__d = __curr_in_a.enc_exp - __curr_in_b.enc_exp;
					__temp_out_data.enc_exp = __curr_in_a.enc_exp;
				end
				__captured_in_a_shifted_frac
					= 
	(
	((__curr_in_a.enc_exp != 8'd0)
	&& (__curr_in_a.enc_exp != 8'd255))
	? {1'b1, __curr_in_a.enc_mantissa}
	: {{
	(7 + 1){1'b0}}})
					<< __WIDTH__BUFFER_BITS;
				__captured_in_b_shifted_frac
					= 
	(
	((__curr_in_b.enc_exp != 8'd0)
	&& (__curr_in_b.enc_exp != 8'd255))
	? {1'b1, __curr_in_b.enc_mantissa}
	: {{
	(7 + 1){1'b0}}})
					<< __WIDTH__BUFFER_BITS;

				if (__curr_in_a.enc_exp < __curr_in_b.enc_exp)
				begin
					set_some_significand(__captured_in_a_shifted_frac,
						__captured_in_b_shifted_frac,
						__temp_a_significand, __temp_b_significand);
				end
				else // if (__curr_in_a.enc_exp >= __curr_in_b.enc_exp)
				begin
					set_some_significand(__captured_in_b_shifted_frac,
						__captured_in_a_shifted_frac,
						__temp_b_significand, __temp_a_significand);
				end
			end
		end
		PkgSnow64BFloat16::StAddStarting:
		begin
			//if (__curr_in_a.enc_exp < __curr_in_b.enc_exp)
			//begin
			//	set_some_significand(__captured_in_a_shifted_frac,
			//		__captured_in_b_shifted_frac,
			//		__temp_a_significand, __temp_b_significand);
			//end
			//else // if (__curr_in_a.enc_exp >= __curr_in_b.enc_exp)
			//begin
			//	set_some_significand(__captured_in_b_shifted_frac,
			//		__captured_in_a_shifted_frac,
			//		__temp_b_significand, __temp_a_significand);
			//end

			if (__captured_in_a.sign == __captured_in_b.sign)
			begin
				__temp_ret_significand = __temp_a_significand
					+ __temp_b_significand;
				__temp_out_data.sign = __captured_in_a.sign;
			end
			else // if (__captured_in_a.sign != __captured_in_b.sign)
			begin
				__temp_ret_significand = __captured_in_a.sign
					? (__temp_b_significand - __temp_a_significand)
					: (__temp_a_significand - __temp_b_significand);

				// Convert to sign and magnitude
				if (__temp_ret_significand
					[__MSB_POS__TEMP_SIGNIFICAND])
				begin
					__temp_out_data.sign = 1;
					__temp_ret_significand = -__temp_ret_significand;
				end

				else
				begin
					__temp_out_data.sign = 0;
				end
			end
		end

		PkgSnow64BFloat16::StAddEffAdd:
		begin
			// Check for an overflow (for an add:  only ever by one bit,
			// and thus we only need to be able to right shift by one bit)
			if (__temp_ret_significand[
	(7 + 1)
				+ __WIDTH__BUFFER_BITS])
			begin
				__temp_ret_significand = __temp_ret_significand >> 1;
				__temp_out_data.enc_exp = __temp_out_data.enc_exp + 1;
			end

			// If necessary, saturate to the highest valid mantissa and
			// exponent
			if (__temp_out_data.enc_exp == 8'hff)
			begin
				{__temp_ret_significand, __temp_out_data.enc_exp}
					= {{__WIDTH__TEMP_SIGNIFICAND{1'b1}},
					
	8'hfe};
			end

			{__temp_out_data.enc_mantissa, __temp_out_data.sign}
				= {__temp_ret_significand[
	((
	(7 + 1)) - 1)
				+ __WIDTH__BUFFER_BITS :__WIDTH__BUFFER_BITS],
				__captured_in_a.sign};

			//$display("StAddEffAdd:  %h, %h, %h:  %h",
			//	__temp_out_data.sign, __temp_out_data.enc_exp,
			//	__temp_out_data.enc_mantissa, __temp_out_data);
			{out.data_valid, out.can_accept_cmd, out.data}
				= {1'b1, 1'b1, __temp_out_data};
		end

		PkgSnow64BFloat16::StAddEffSub:
		begin
			// If the result is not zero
			if (__temp_ret_significand)
			begin
				__real_num_leading_zeros
					= __out_clz16
					- (__WIDTH__TEMP_SIGNIFICAND
					- (
	(7 + 1)
					+ __WIDTH__BUFFER_BITS));

				if ((

	{{(32 - 8){1'b0}},__temp_out_data.enc_exp}
					- 

	{{(32 - __WIDTH__TEMP_SIGNIFICAND){1'b0}},__real_num_leading_zeros}) & (1 << 31))
				begin
					__temp_out_data.enc_exp = 0;
				end

				else
				begin
					__temp_out_data.enc_exp = __temp_out_data.enc_exp
						- __real_num_leading_zeros;
					__temp_ret_significand <<= __real_num_leading_zeros;
				end
			end

			else // if (!__temp_ret_significand)
			begin
				__temp_out_data.enc_exp = 0;
			end

			if (__temp_out_data.enc_exp == 0)
			begin
				__temp_out_data.enc_mantissa = 0;
			end

			else // if (__temp_out_data.enc_exp != 0)
			begin
				__temp_out_data.enc_mantissa = __temp_ret_significand
					[__MSB_POS__TEMP_SIGNIFICAND:__WIDTH__BUFFER_BITS];
			end

			//$display("StAddEffSub:  %h, %h",
			//	__temp_ret_significand, __temp_out_data);

			//$display("StAddEffSub:  %h, %h, %h:  %h",
			//	__temp_out_data.sign, __temp_out_data.enc_exp,
			//	__temp_out_data.enc_mantissa, __temp_out_data);

			{out.data_valid, out.can_accept_cmd, out.data}
				= {1'b1, 1'b1, __temp_out_data};
		end

		//default:
		//begin
		//	{__temp_a_significand, __temp_b_significand,
		//		__temp_ret_significand, __temp_out_data,
		//		__real_num_leading_zeros} = 0;
		//end

		endcase
	end



	always_ff @(posedge clk)
	begin
		case (__state)
		PkgSnow64BFloat16::StAddIdle:
		begin
			if (in.start)
			begin
				//out.data_valid <= 0;
				//out.can_accept_cmd <= 0;

				__captured_in_a <= in.a;
				__captured_in_b <= in.b;


				__state <= PkgSnow64BFloat16::StAddStarting;

				//__captured_in_a_shifted_frac
				//	<= `SNOW64_BFLOAT16_FRAC(__curr_in_a) << __WIDTH__BUFFER_BITS;
				//__captured_in_b_shifted_frac
				//	<= `SNOW64_BFLOAT16_FRAC(__curr_in_b) << __WIDTH__BUFFER_BITS;

				//if (__curr_in_a.enc_exp < __curr_in_b.enc_exp)
				//begin
				//	__d <= __curr_in_b.enc_exp - __curr_in_a.enc_exp;
				//	//__temp_out_data.enc_exp <= __curr_in_b.enc_exp;
				//end

				//else // if (__curr_in_a.enc_exp >= __curr_in_b.enc_exp)
				//begin
				//	__d <= __curr_in_a.enc_exp - __curr_in_b.enc_exp;
				//	//__temp_out_data.enc_exp <= __curr_in_a.enc_exp;
				//end

				//__temp_out_data.sign <= 0;
			end
		end

		PkgSnow64BFloat16::StAddStarting:
		begin
			if (__captured_in_a.sign == __captured_in_b.sign)
			begin
				__state <= PkgSnow64BFloat16::StAddEffAdd;

				//__ret_significand <= __temp_a_significand
				//	+ __temp_b_significand;
			end

			else // if (__captured_in_a.sign != __captured_in_b.sign)
			begin
				__state <= PkgSnow64BFloat16::StAddEffSub;

				//// Convert to sign and magnitude
				//if (__temp_ret_significand
				//	[__MSB_POS__TEMP_SIGNIFICAND])
				//begin
				//	__temp_out_data.sign <= 1;
				//	__ret_significand <= -__temp_ret_significand;
				//end

				//else
				//begin
				//	__ret_significand <= __temp_ret_significand;
				//end
			end
		end


		//PkgSnow64BFloat16::StAddEffAdd:
		//PkgSnow64BFloat16::StAddEffSub:
		default:
		begin
			__state <= PkgSnow64BFloat16::StAddIdle;
			//out.data_valid <= 1;
			//out.can_accept_cmd <= 1;

			//__ret_significand <= __temp_ret_significand;
			//__temp_out_data <= __temp_out_data;
		end
		endcase
	end
endmodule

module Snow64BFloat16Add(input logic clk,
	input PkgSnow64BFloat16::PortIn_BinOp in,
	output PkgSnow64BFloat16::PortOut_Oper out);

	__RealSnow64BFloat16Add __inst_real_bfloat16_add(.clk(clk), .in(in),
		.out(out));
endmodule

module Snow64BFloat16Sub(input logic clk,
	input PkgSnow64BFloat16::PortIn_BinOp in,
	output PkgSnow64BFloat16::PortOut_Oper out);

	PkgSnow64BFloat16::PortIn_BinOp __in_bfloat16_add;
	PkgSnow64BFloat16::BFloat16 __in_b, __in_bfloat16_add_b;

	__RealSnow64BFloat16Add __inst_real_bfloat16_add(.clk(clk),
		.in(__in_bfloat16_add), .out(out));

	always @(*) __in_b = in.b;
	always @(*) __in_bfloat16_add_b.sign = !__in_b.sign;
	always @(*) __in_bfloat16_add_b.enc_exp = __in_b.enc_exp;
	always @(*) __in_bfloat16_add_b.enc_mantissa = __in_b.enc_mantissa;

	always @(*) __in_bfloat16_add.start = in.start;
	always @(*) __in_bfloat16_add.a = in.a;
	always @(*) __in_bfloat16_add.b = __in_bfloat16_add_b;

endmodule

































































		// src__slash__snow64_bfloat16_defines_header_sv

module Snow64BFloat16Div(input logic clk,
	input PkgSnow64BFloat16::PortIn_BinOp in,
	output PkgSnow64BFloat16::PortOut_Oper out);

	localparam __WIDTH__TEMP = 16;
	localparam __MSB_POS__TEMP = ((__WIDTH__TEMP) - 1);

	localparam __WIDTH__BUFFER_BITS = 8;
	localparam __MSB_POS__BUFFER_BITS = ((__WIDTH__BUFFER_BITS) - 1);

	PkgSnow64BFloat16::StateDiv __state;
	//PkgSnow64BFloat16::StateDiv __state, __prev_state;

	PkgSnow64BFloat16::BFloat16 __captured_in_a, __captured_in_b,
		__curr_in_a, __curr_in_b, __temp_out_data;

	logic [__MSB_POS__TEMP:0] __temp_a_significand;
	logic [__MSB_POS__BUFFER_BITS:0] __temp_b_significand;
	logic [__MSB_POS__TEMP:0] __temp_ret_significand, __temp_ret_enc_exp;

	logic __temp_out_data_valid, __temp_out_can_accept_cmd;


	PkgSnow64LongDiv::PortIn_LongDivU16ByU8 __in_long_div;
	PkgSnow64LongDiv::PortOut_LongDivU16ByU8 __out_long_div;

	Snow64LongDivU16ByU8Radix16 __inst_long_div(.clk(clk),
		.in(__in_long_div), .out(__out_long_div));

	assign {__curr_in_a, __curr_in_b} = {in.a, in.b};

	logic __in_long_div_start;
	logic [
	((16) - 1):0] __in_long_div_a;
	logic [
	((8) - 1):0] __in_long_div_b;


	//assign __in_long_div_start = in.start;
	assign __in_long_div_start = in.start && out.can_accept_cmd;

	assign __in_long_div_a = {
	(
	((__curr_in_a.enc_exp != 8'd0)
	&& (__curr_in_a.enc_exp != 8'd255))
	? {1'b1, __curr_in_a.enc_mantissa}
	: {{
	(7 + 1){1'b0}}}),
		{__WIDTH__BUFFER_BITS{1'b0}}};
	assign __in_long_div_b = 
	(
	((__curr_in_b.enc_exp != 8'd0)
	&& (__curr_in_b.enc_exp != 8'd255))
	? {1'b1, __curr_in_b.enc_mantissa}
	: {{
	(7 + 1){1'b0}}});


	assign __in_long_div = {__in_long_div_start, __in_long_div_a,
		__in_long_div_b};

	assign out.data_valid = __temp_out_data_valid;
	assign out.can_accept_cmd = __temp_out_can_accept_cmd;
	assign out.data = __temp_out_data;

	initial
	begin
		__state = PkgSnow64BFloat16::StDivIdle;
		//__prev_state = PkgSnow64BFloat16::StDivIdle;
		__temp_out_data_valid = 0;
		__temp_out_can_accept_cmd = 1;
		__temp_out_data = 0;

		//{__captured_in_a, __captured_in_b, __curr_in_a, __curr_in_b,
		//	__temp_out_data, __temp_a_significand, __temp_b_significand,
		//	__temp_ret_significand, __temp_ret_enc_exp} = 0;
	end



	always_ff @(posedge clk)
	begin
		//__prev_state <= __state;

		case (__state)
		PkgSnow64BFloat16::StDivIdle:
		begin
			if (in.start)
			begin
				__state <= PkgSnow64BFloat16::StDivStartingLongDiv;
				__captured_in_a <= __curr_in_a;
				__captured_in_b <= __curr_in_b;

				//__temp_a_significand <= __in_long_div_a;
				//__temp_b_significand <= __in_long_div_b;
				__temp_a_significand <= {
	(
	((__curr_in_a.enc_exp != 8'd0)
	&& (__curr_in_a.enc_exp != 8'd255))
	? {1'b1, __curr_in_a.enc_mantissa}
	: {{
	(7 + 1){1'b0}}}),
					{__WIDTH__BUFFER_BITS{1'b0}}};
				__temp_b_significand <= 
	(
	((__curr_in_b.enc_exp != 8'd0)
	&& (__curr_in_b.enc_exp != 8'd255))
	? {1'b1, __curr_in_b.enc_mantissa}
	: {{
	(7 + 1){1'b0}}});

				__temp_out_data_valid <= 0;
				__temp_out_can_accept_cmd <= 0;
				__temp_out_data.sign <= (__curr_in_a.sign
					^ __curr_in_b.sign);
				__temp_out_data.enc_exp <= 0;
				__temp_out_data.enc_mantissa <= 0;
			end
		end

		PkgSnow64BFloat16::StDivStartingLongDiv:
		begin
			//$display("StDivStartingLongDiv:  %h, %h",
			//	__temp_a_significand, __temp_b_significand);

			//if (__out_long_div.data_valid && __out_long_div.can_accept_cmd)
			// This should not trigger other than when we've finished doing
			// a long division, but....
			//if ((__prev_state == PkgSnow64BFloat16::StDivStartingLongDiv)
			//	&& __out_long_div.data_valid)
			if (__out_long_div.data_valid)
			begin
				__state <= PkgSnow64BFloat16::StDivAfterLongDiv;

				// Special case of division by zero:  just set the whole
				// thing to zero
				if (__temp_b_significand == 0)
				begin
					__temp_ret_significand <= 0;
				end
				else
				begin
					__temp_ret_significand <= __out_long_div.data;
					//$display("__out_long_div.data:  %h", __out_long_div.data);
					//__temp_ret_significand <= __temp_a_significand
					//	/ __temp_b_significand;

					//if (__out_long_div.data 
					//	!= (__temp_a_significand / __temp_b_significand))
					//begin
					//	$display("Eek!  %h != %h",
					//		__out_long_div.data,
					//		(__temp_a_significand / __temp_b_significand));
					//end
				end

				__temp_ret_enc_exp
					<= 


	{{(__WIDTH__TEMP -  8){1'b0}},__captured_in_a.enc_exp}
					- 


	{{(__WIDTH__TEMP -  8){1'b0}},__captured_in_b.enc_exp}
					+ 


	{{(__WIDTH__TEMP -  8){1'b0}},8'd127};
			end
		end

		PkgSnow64BFloat16::StDivAfterLongDiv:
		begin
			__state <= PkgSnow64BFloat16::StDivFinishing;
			//$display("__temp_ret_significand:  %h",
			//	__temp_ret_significand);

			if (__temp_ret_significand == 0)
			begin
				__temp_ret_enc_exp <= 0;
			end
			else // if (__ret_significand != 0)
			begin
				// Normalization done here
				if (__temp_ret_significand[
	(7 + 1)])
				begin
					__temp_ret_significand <= __temp_ret_significand >> 1;
				end
				else
				begin
					__temp_ret_enc_exp <= __temp_ret_enc_exp - 1;
				end
			end
		end

		PkgSnow64BFloat16::StDivFinishing:
		begin
			__state <= PkgSnow64BFloat16::StDivIdle;
			__temp_out_data_valid <= 1;
			__temp_out_can_accept_cmd <= 1;


			// If necessary, set everything to zero
			if (__temp_ret_enc_exp[__MSB_POS__TEMP])
			begin
				//$display("set everything to zero");
				__temp_out_data.enc_mantissa <= 0;
				__temp_out_data.enc_exp <= 0;
			end
			else if (__temp_ret_enc_exp >= 8'hff)
			begin
				//$display("saturate");
				__temp_out_data.enc_mantissa 
					<= 
	16'h7f7f;
				__temp_out_data.enc_exp
					<= 
	8'hfe;
			end

			else
			begin
				//$display("\"regular\"");
				//$display("outputs:  %h, %h",
				//	__temp_ret_significand, __temp_ret_enc_exp);
				__temp_out_data.enc_mantissa <= __temp_ret_significand;
				__temp_out_data.enc_exp <= __temp_ret_enc_exp;
			end
		end
		endcase
	end

endmodule























		// src__slash__snow64_long_div_u16_by_u8_defines_header_sv

module Snow64LongDivU16ByU8Radix8(input logic clk, 
	input PkgSnow64LongDiv::PortIn_LongDivU16ByU8 in,
	output PkgSnow64LongDiv::PortOut_LongDivU16ByU8 out);

	localparam __WIDTH__IN_A = 16;
	localparam __MSB_POS__IN_A = 
	((16) - 1);

	localparam __WIDTH__IN_B = 8;
	localparam __MSB_POS__IN_B = 
	((8) - 1);

	localparam __WIDTH__OUT_DATA
		= 16;
	localparam __MSB_POS__OUT_DATA
		= 
	((16) - 1);

	localparam __WIDTH__MULT_ARR = 11;
	localparam __MSB_POS__MULT_ARR = ((__WIDTH__MULT_ARR) - 1);


	localparam __RADIX = 8;
	localparam __NUM_BITS_PER_ITERATION = 3;
	localparam __STARTING_I_VALUE = 5;


	localparam __WIDTH__TEMP = 18;
	localparam __MSB_POS__TEMP = ((__WIDTH__TEMP) - 1);


	localparam __WIDTH__ARR_INDEX = 3;
	localparam __MSB_POS__ARR_INDEX = ((__WIDTH__ARR_INDEX) - 1);


	localparam __WIDTH__CAPTURED_A = 18;
	localparam __MSB_POS__CAPTURED_A = ((__WIDTH__CAPTURED_A) - 1);
	localparam __WIDTH__CAPTURED_B = __WIDTH__IN_B;
	localparam __MSB_POS__CAPTURED_B = ((__WIDTH__CAPTURED_B) - 1);

	localparam __WIDTH__ALMOST_OUT_DATA = __WIDTH__CAPTURED_A;
	localparam __MSB_POS__ALMOST_OUT_DATA
		= ((__WIDTH__ALMOST_OUT_DATA) - 1);


	enum logic
	{
		StIdle,
		StWorking
	} __state;



	logic [__MSB_POS__MULT_ARR:0] __mult_arr
		[0 : ((__RADIX) - 1)];
	//logic [__MSB_POS__TEMP:0] __mult_arr[0 : __RADIX];

	logic [__MSB_POS__CAPTURED_A:0] __captured_a;
	//logic [__MSB_POS__CAPTURED_B:0] __captured_b;
	logic [__MSB_POS__ALMOST_OUT_DATA:0] __almost_out_data;
	logic __temp_out_data_valid, __temp_out_can_accept_cmd;

	logic [__MSB_POS__TEMP:0] __current;

	logic [__MSB_POS__ARR_INDEX:0] __i;
	//logic [1:0] __i;
	logic [__MSB_POS__TEMP:0] __j;

	//logic [__MSB_POS__ARR_INDEX:0] __search_result;
	logic [__MSB_POS__ARR_INDEX:0] 
		__search_result_0_1_2_3, __search_result_4_5_6_7;

	assign out.data = __almost_out_data;
	assign out.data_valid = __temp_out_data_valid;
	assign out.can_accept_cmd = __temp_out_can_accept_cmd;
	//always @(*) out.data = __almost_out_data;

	task iteration_end;
		input [__MSB_POS__ARR_INDEX:0] some_index;

		case (__i)
			3'd5:
			begin
				__almost_out_data[17:15] = some_index;
			end

			3'd4:
			begin
				__almost_out_data[14:12] = some_index;
			end

			3'd3:
			begin
				__almost_out_data[11:9] = some_index;
			end

			3'd2:
			begin
				__almost_out_data[8:6] = some_index;
			end

			3'd1:
			begin
				__almost_out_data[5:3] = some_index;
			end

			3'd0:
			begin
				__almost_out_data[2:0] = some_index;
			end
		endcase

		__current = __current - __mult_arr[some_index];
	endtask

	//assign out_ready = (__state == StIdle);

	initial
	begin
		__state = StIdle;
		__temp_out_data_valid = 0;
		__temp_out_can_accept_cmd = 1;
	end

	always @(posedge clk)
	begin
		case (__state)
			StIdle:
			begin
				__current = 0;
				__almost_out_data = 0;

			end

			StWorking:
			begin
				case (__i)
					3'd5:
					begin
						__current = {__current[15:0], __captured_a[17:15]};
					end

					3'd4:
					begin
						__current = {__current[15:0], __captured_a[14:12]};
					end

					3'd3:
					begin
						__current = {__current[15:0], __captured_a[11:9]};
					end

					3'd2:
					begin
						__current = {__current[15:0], __captured_a[8:6]};
					end

					3'd1:
					begin
						__current = {__current[15:0], __captured_a[5:3]};
					end

					3'd0:
					begin
						__current = {__current[15:0], __captured_a[2:0]};
					end
				endcase

				// Binary search
				if (__mult_arr[4] > __current)
				begin
					if (__mult_arr[2] > __current)
					begin
						// 0 or 1
						if (__mult_arr[1] > __current)
						begin
							__search_result_0_1_2_3 = 0;
							//iteration_end(0);
						end
						else // if (__mult_arr[1] <= __current)
						begin
							__search_result_0_1_2_3 = 1;
							//iteration_end(1);
						end
					end
					else // if (__mult_arr[2] <= __current)
					begin
						// 2 or 3
						if (__mult_arr[3] > __current)
						begin
							__search_result_0_1_2_3 = 2;
							//iteration_end(2);
						end
						else // if (__mult_arr[3] <= __current)
						begin
							__search_result_0_1_2_3 = 3;
							//iteration_end(3);
						end
					end
					iteration_end(__search_result_0_1_2_3);
				end
				else // if (__mult_arr[4] <= __current)
				begin
					if (__mult_arr[6] > __current)
					begin
						// 4 or 5
						if (__mult_arr[5] > __current)
						begin
							__search_result_4_5_6_7 = 4;
							//iteration_end(4);
						end
						else // if (__mult_arr[5] <= __current)
						begin
							__search_result_4_5_6_7 = 5;
							//iteration_end(5);
						end
					end
					else // if (__mult_arr[6] <= __current)
					begin
						// 6 or 7
						if (__mult_arr[7] > __current)
						begin
							__search_result_4_5_6_7 = 6;
							//iteration_end(6);
						end
						else // if (__mult_arr[7] <= __current)
						begin
							__search_result_4_5_6_7 = 7;
							//iteration_end(7);
						end
					end
					iteration_end(__search_result_4_5_6_7);
				end

				//iteration_end(__search_result);

				//if (__i == 0)
				//begin
				//	out_data_valid = 1;
				//	out_can_accept_cmd = 1;
				//end
			end

		endcase
	end

	always_ff @(posedge clk)
	begin
		//$display("Snow64LongDivU16ByU8Radix8 in.start:  %h", in.start);
		case (__state)
			StIdle:
			begin
				if (in.start)
				begin
					__state <= StWorking;

					__mult_arr[0] <= 0;

					if (in.b != 0)
					begin
						__captured_a <= in.a;
						//__captured_b <= in.b;

						//__mult_arr[0] <= in.b * 0;
						__mult_arr[1] <= in.b * 1;
						__mult_arr[2] <= in.b * 2;
						__mult_arr[3] <= in.b * 3;

						__mult_arr[4] <= in.b * 4;
						__mult_arr[5] <= in.b * 5;
						__mult_arr[6] <= in.b * 6;
						__mult_arr[7] <= in.b * 7;
					end

					else // if (in.b == 0)
					begin
						// Ensure "correct" results (return a zero when
						// in.b is zero)
						__captured_a <= 0;
						//__captured_b <= 1;

						//__mult_arr[0] <= 0;
						__mult_arr[1] <= 1;
						__mult_arr[2] <= 2;
						__mult_arr[3] <= 3;

						__mult_arr[4] <= 4;
						__mult_arr[5] <= 5;
						__mult_arr[6] <= 6;
						__mult_arr[7] <= 7;
					end

					__i <= __STARTING_I_VALUE;

					__temp_out_data_valid <= 0;
					__temp_out_can_accept_cmd <= 0;
				end
			end


			StWorking:
			begin
				//__i <= __i - __NUM_BITS_PER_ITERATION;
				__i <= __i - 1;

				// Last iteration means we should update __state
				//if (__i == __NUM_BITS_PER_ITERATION - 1)
				if (__i == 0)
				begin
					__state <= StIdle;
					__temp_out_data_valid <= 1;
					__temp_out_can_accept_cmd <= 1;
					//$display("Snow64LongDivU16ByU8Radix8:  stuff");
				end
			end
		endcase
	end


endmodule

































































		// src__slash__snow64_bfloat16_defines_header_sv

module Snow64BFloat16Mul(input logic clk,
	input PkgSnow64BFloat16::PortIn_BinOp in,
	output PkgSnow64BFloat16::PortOut_Oper out);

	localparam __WIDTH__TEMP = 16;
	localparam __MSB_POS__TEMP = ((__WIDTH__TEMP) - 1);

	PkgSnow64BFloat16::StateMul __state;
	//PkgSnow64BFloat16::BFloat16 __captured_in_a, __captured_in_b,
	//	__curr_in_a, __curr_in_b, __temp_out_data;
	PkgSnow64BFloat16::BFloat16 __curr_in_a, __curr_in_b, __temp_out_data;

	logic [__MSB_POS__TEMP:0]
		__temp_a_significand, __temp_b_significand, __temp_ret_significand,
		__temp_ret_enc_exp;

	assign {__curr_in_a, __curr_in_b} = {in.a, in.b};


	initial
	begin
		__state = PkgSnow64BFloat16::StMulIdle;
		out.data_valid = 0;
		out.can_accept_cmd = 1;
		out.data = 0;
	end

	// Pseudo combinational logic
	always @(posedge clk)
	begin
		case (__state)
		PkgSnow64BFloat16::StMulIdle:
		begin
			if (in.start)
			begin
				out = 0;

				__temp_out_data.sign = __curr_in_a.sign ^ __curr_in_b.sign;

				{__temp_a_significand, __temp_b_significand}
					= {


	{{(__WIDTH__TEMP - 
	(7 + 1)){1'b0}},
	(
	((__curr_in_a.enc_exp != 8'd0)
	&& (__curr_in_a.enc_exp != 8'd255))
	? {1'b1, __curr_in_a.enc_mantissa}
	: {{
	(7 + 1){1'b0}}})},
					


	{{(__WIDTH__TEMP - 
	(7 + 1)){1'b0}},
	(
	((__curr_in_b.enc_exp != 8'd0)
	&& (__curr_in_b.enc_exp != 8'd255))
	? {1'b1, __curr_in_b.enc_mantissa}
	: {{
	(7 + 1){1'b0}}})}};
				//__temp_a_significand = `SNOW64_BFLOAT16_FRAC(__curr_in_a);
				//__temp_b_significand = `SNOW64_BFLOAT16_FRAC(__curr_in_b);

				//$display("temp a, temp b:  %h, %h", __temp_a_significand,
				//	__temp_b_significand);

				if (__temp_a_significand && __temp_b_significand)
				begin
					__temp_ret_significand
						= __temp_a_significand * __temp_b_significand;
					__temp_ret_enc_exp
						= (


	{{(__WIDTH__TEMP - 8){1'b0}},__curr_in_a.enc_exp})
						+ (


	{{(__WIDTH__TEMP - 8){1'b0}},__curr_in_b.enc_exp})
						- (


	{{(__WIDTH__TEMP - 8){1'b0}},8'd127});
				end

				// Special case 0:  we need to set the encoded exponent
				// to zero in this case
				else
				begin
					{__temp_ret_significand, __temp_ret_enc_exp} = 0;
				end

				// Normalize if needed
				if (__temp_ret_significand[__MSB_POS__TEMP])
				begin
					__temp_ret_significand = __temp_ret_significand >> 1;
					__temp_ret_enc_exp = __temp_ret_enc_exp + 1;
				end

				__temp_ret_significand = __temp_ret_significand
					>> 7;

				//$display("stuffs 0:  %h, %h",
				//	__temp_ret_significand, __temp_ret_enc_exp);
			end
		end

		PkgSnow64BFloat16::StMulFinishing:
		begin
			// If necessary, set everything to zero.
			if ((__temp_ret_enc_exp == 0)
				|| (__temp_ret_enc_exp[__MSB_POS__TEMP]))
			begin
				{__temp_out_data.enc_mantissa, __temp_out_data.enc_exp}
					= 0;
			end

			// If necessary, saturate to highest valid mantissa and
			// exponent
			else if (__temp_ret_enc_exp >= 


	{{(__WIDTH__TEMP - 8){1'b0}},8'hff})
			begin
				{__temp_out_data.enc_mantissa, __temp_out_data.enc_exp}
					= {
	16'h7f7f,
					
	8'hfe};
			end

			else
			begin
				{__temp_out_data.enc_mantissa, __temp_out_data.enc_exp}
				= {__temp_ret_significand
					[
	((7) - 1):0],
					__temp_ret_enc_exp
					[
	((8) - 1):0]};
			end

			{out.data_valid, out.can_accept_cmd, out.data}
				= {1'b1, 1'b1, __temp_out_data};
		end

		endcase
	end

	always_ff @(posedge clk)
	begin
		case (__state)
		PkgSnow64BFloat16::StMulIdle:
		begin
			if (in.start)
			begin
				//__captured_in_a <= in.a;
				//__captured_in_b <= in.b;

				__state <= PkgSnow64BFloat16::StMulFinishing;
			end
		end

		PkgSnow64BFloat16::StMulFinishing:
		begin
			__state <= PkgSnow64BFloat16::StMulIdle;
		end
		endcase
	end


endmodule

































































		// src__slash__snow64_bfloat16_defines_header_sv

//module Snow64BFloat16CastFromInt(input logic clk,
//	input PkgSnow64BFloat16::PortIn_CastFromInt in,
//	output PkgSnow64BFloat16::PortOut_CastFromInt out);
//
//
//	enum logic
//	{
//		StIdle,
//		StFinishing
//	} __state;
//
//	logic __temp_out_data_valid, __temp_out_can_accept_cmd;
//	PkgSnow64BFloat16::BFloat16 __temp_out_data;
//	logic [`MSB_POS__SNOW64_SIZE_64:0] __temp_ret_enc_exp;
//
//	assign out.data_valid = __temp_out_data_valid;
//	assign out.can_accept_cmd = __temp_out_can_accept_cmd;
//	assign out.data = __temp_out_data;
//
//	logic [`MSB_POS__SNOW64_SIZE_64:0] __width;
//
//	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_64_IN:0] __temp_abs_data;
//	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_64_OUT:0] __out_clz64;
//
//	Snow64CountLeadingZeros64 __inst_clz64(.in(__temp_abs_data),
//		.out(__out_clz64));
//
//	initial
//	begin
//		__state = StIdle;
//		__temp_out_data_valid = 0;
//		__temp_out_can_accept_cmd = 1;
//		__temp_out_data = 0;
//	end
//
//	// Pseudo combinational logic
//	always @(posedge clk)
//	begin
//		case (__state)
//		StIdle:
//		begin
//			if (in.start)
//			begin
//				case (in.type_signedness)
//				0:
//				begin
//					case (in.type_size)
//					PkgSnow64Cpu::TypSz8:
//					begin
//						__temp_abs_data = {56'h0, in.to_cast[7:0]};
//						__width = 8;
//					end
//
//					PkgSnow64Cpu::TypSz16:
//					begin
//						__temp_abs_data = {48'h0, in.to_cast[15:0]};
//						__width = 16;
//					end
//
//					PkgSnow64Cpu::TypSz32:
//					begin
//						__temp_abs_data = {32'h0, in.to_cast[31:0]};
//						__width = 32;
//					end
//
//					PkgSnow64Cpu::TypSz64:
//					begin
//						__temp_abs_data = in.to_cast;
//						__width = 64;
//					end
//					endcase
//
//					__temp_out_data.sign = 0;
//				end
//
//				1:
//				begin
//					case (in.type_size)
//					PkgSnow64Cpu::TypSz8:
//					begin
//						__temp_abs_data = in.to_cast[7]
//							? (-in.to_cast[7:0]) : in.to_cast[7:0];
//						__width = 8;
//						__temp_out_data.sign = in.to_cast[7];
//					end
//
//					PkgSnow64Cpu::TypSz16:
//					begin
//						__temp_abs_data = in.to_cast[15]
//							? (-in.to_cast[15:0]) : in.to_cast[15:0];
//						__width = 16;
//						__temp_out_data.sign = in.to_cast[15];
//					end
//
//					PkgSnow64Cpu::TypSz32:
//					begin
//						__temp_abs_data = in.to_cast[31]
//							? (-in.to_cast[31:0]) : in.to_cast[31:0];
//						__width = 32;
//						__temp_out_data.sign = in.to_cast[31];
//					end
//
//					PkgSnow64Cpu::TypSz64:
//					begin
//						__temp_abs_data = in.to_cast;
//						__width = 64;
//						__temp_out_data.sign = in.to_cast[63];
//					end
//					endcase
//				end
//				endcase
//			end
//		end
//
//		StFinishing:
//		begin
//			__temp_ret_enc_exp = `ZERO_EXTEND(`WIDTH__SNOW64_SIZE_64,
//				`WIDTH__SNOW64_SIZE_8, `SNOW64_BFLOAT16_BIAS)
//				+ (__width - `WIDTH__SNOW64_SIZE_64'h1) - __out_clz64;
//
//			__temp_abs_data = __temp_abs_data << __out_clz64;
//			__temp_abs_data = __temp_abs_data[63:56];
//
//			if (__temp_abs_data == 0)
//			begin
//				{__temp_out_data.enc_exp, __temp_out_data.enc_mantissa}
//					= 0;
//			end
//			else // if (__temp_abs_data != 0)
//			begin
//				{__temp_out_data.enc_exp, __temp_out_data.enc_mantissa}
//					= {__temp_ret_enc_exp
//					[`MSB_POS__SNOW64_BFLOAT16_ENC_EXP:0],
//					__temp_abs_data
//					[`MSB_POS__SNOW64_BFLOAT16_ENC_MANTISSA:0]};
//			end
//
//		end
//		endcase
//	end
//
//	always_ff @(posedge clk)
//	begin
//		case (__state)
//		StIdle:
//		begin
//			if (in.start)
//			begin
//				__state <= StFinishing;
//				__temp_out_data_valid <= 0;
//				__temp_out_can_accept_cmd <= 0;
//			end
//		end
//
//		StFinishing:
//		begin
//			__state <= StIdle;
//			__temp_out_data_valid <= 1;
//			__temp_out_can_accept_cmd <= 1;
//		end
//		endcase
//	end
//
//endmodule

//module Snow64BFloat16CastToInt(input logic clk,
//	input PkgSnow64BFloat16::PortIn_CastToInt in,
//	output PkgSnow64BFloat16::PortOut_CastToInt out);
//
//endmodule





































		// src__slash__snow64_instr_decoder_defines_header_sv


module Snow64InstrDecoder
	(input logic [PkgSnow64InstrDecoder::MSB_POS__INSTR:0] in,
	output PkgSnow64InstrDecoder::PortOut_InstrDecoder out);

	//import PkgSnow64InstrDecoder::*;

	PkgSnow64InstrDecoder::Iog0Instr __iog0_instr;
	PkgSnow64InstrDecoder::Iog1Instr __iog1_instr;
	PkgSnow64InstrDecoder::Iog2Instr __iog2_instr;
	PkgSnow64InstrDecoder::Iog3Instr __iog3_instr;
	PkgSnow64InstrDecoder::Iog4Instr __iog4_instr;

	assign __iog0_instr = in;
	assign __iog1_instr = in;
	assign __iog2_instr = in;
	assign __iog3_instr = in;
	assign __iog4_instr = in;

	always @(*)
	begin
		out.group = __iog0_instr.group;
	end

	always @(*)
	begin
		out.op_type = __iog0_instr.op_type;
	end
	always @(*)
	begin
		out.ra_index = __iog0_instr.ra_index;
	end
	always @(*)
	begin
		out.rb_index = __iog0_instr.rb_index;
	end
	always @(*)
	begin
		out.rc_index = __iog0_instr.rc_index;
	end


	always @(*)
	begin
		case (__iog0_instr.group)
		0:
		begin
			out.oper = __iog0_instr.oper;
			out.stall = ((__iog0_instr.oper 
				== PkgSnow64InstrDecoder::Mul_ThreeRegs)
				|| (__iog0_instr.oper
				== PkgSnow64InstrDecoder::Div_ThreeRegs));
			out.nop = ((__iog0_instr.oper
				== PkgSnow64InstrDecoder::Bad0_Iog0)
				|| (__iog0_instr.oper
				== PkgSnow64InstrDecoder::Bad1_Iog0)
				|| (__iog0_instr.oper
				== PkgSnow64InstrDecoder::Bad2_Iog0));

			out.signext_imm 
				= 


	{{(PkgSnow64InstrDecoder::WIDTH__ADDR - PkgSnow64InstrDecoder::WIDTH__IOG0_SIMM12)
	{__iog0_instr.simm12[((PkgSnow64InstrDecoder::WIDTH__IOG0_SIMM12) - 1)]}},__iog0_instr.simm12};
			//out.zeroext_imm 
			//	= `ZERO_EXTEND(PkgSnow64InstrDecoder::WIDTH__ADDR,
			//	PkgSnow64InstrDecoder::WIDTH__IOG0_SIMM12,
			//	__iog0_instr.simm12);
		end

		1:
		begin
			out.oper = __iog1_instr.oper;
			out.stall = 0;

			// out.nop 
			// = (__iog1_instr.oper 
			// 	<= PkgSnow64InstrDecoder::Bad0_Iog1);
			out.nop = (__iog1_instr.oper[3] && __iog1_instr.oper[2]);

			out.signext_imm 
				= 


	{{(PkgSnow64InstrDecoder::WIDTH__ADDR - PkgSnow64InstrDecoder::WIDTH__IOG1_SIMM20)
	{__iog1_instr.simm20[((PkgSnow64InstrDecoder::WIDTH__IOG1_SIMM20) - 1)]}},__iog1_instr.simm20};
			//out.zeroext_imm 
			//	= `ZERO_EXTEND(PkgSnow64InstrDecoder::WIDTH__ADDR,
			//	PkgSnow64InstrDecoder::WIDTH__IOG1_SIMM20,
			//	__iog1_instr.simm20);
		end

		2:
		begin
			out.oper = __iog2_instr.oper;
			out.stall = __iog2_instr.oper;

			// out.nop = (__iog2_instr.oper
			// 	>= PkgSnow64InstrDecoder::Bad0_Iog2);
			out.nop = ((__iog2_instr.oper 
				!= PkgSnow64InstrDecoder::LdF16_ThreeRegsOneSimm12)
				&& (__iog2_instr.oper[3]));

			out.signext_imm 
				= 


	{{(PkgSnow64InstrDecoder::WIDTH__ADDR - PkgSnow64InstrDecoder::WIDTH__IOG2_SIMM12)
	{__iog2_instr.simm12[((PkgSnow64InstrDecoder::WIDTH__IOG2_SIMM12) - 1)]}},__iog2_instr.simm12};
			//out.zeroext_imm 
			//	= `ZERO_EXTEND(PkgSnow64InstrDecoder::WIDTH__ADDR,
			//	PkgSnow64InstrDecoder::WIDTH__IOG2_SIMM12,
			//	__iog2_instr.simm12);
		end

		3:
		begin
			out.oper = __iog3_instr.oper;
			out.stall = __iog3_instr.oper;

			// out.nop = (__iog3_instr.oper
			// 	>= PkgSnow64InstrDecoder::Bad0_Iog3);
			out.nop = ((__iog3_instr.oper 
				!= PkgSnow64InstrDecoder::StF16_ThreeRegsOneSimm12)
				&& (__iog3_instr.oper[3]));

			out.signext_imm 
				= 


	{{(PkgSnow64InstrDecoder::WIDTH__ADDR - PkgSnow64InstrDecoder::WIDTH__IOG3_SIMM12)
	{__iog3_instr.simm12[((PkgSnow64InstrDecoder::WIDTH__IOG3_SIMM12) - 1)]}},__iog3_instr.simm12};
			//out.zeroext_imm 
			//	= `ZERO_EXTEND(PkgSnow64InstrDecoder::WIDTH__ADDR,
			//	PkgSnow64InstrDecoder::WIDTH__IOG3_SIMM12,
			//	__iog3_instr.simm12);
		end

		4:
		begin
			out.oper = __iog4_instr.oper;
			out.stall = __iog4_instr.oper;

			// out.nop = (__iog4_instr.oper
			// 	>= PkgSnow64InstrDecoder::Bad0_Iog4);
			out.nop = ((__iog4_instr.oper 
				!= PkgSnow64InstrDecoder::Out_TwoRegsOneSimm16)
				&& (__iog4_instr.oper[3]));

			out.signext_imm 
				= 


	{{(PkgSnow64InstrDecoder::WIDTH__ADDR - PkgSnow64InstrDecoder::WIDTH__IOG4_SIMM16)
	{__iog4_instr.simm16[((PkgSnow64InstrDecoder::WIDTH__IOG4_SIMM16) - 1)]}},__iog4_instr.simm16};
			//out.zeroext_imm 
			//	= `ZERO_EXTEND(PkgSnow64InstrDecoder::WIDTH__ADDR,
			//	PkgSnow64InstrDecoder::WIDTH__IOG4_SIMM16,
			//	__iog4_instr.simm16);
		end

		// Eek!
		default:
		begin
			out.oper = 0;
			out.stall = 0;
			out.nop = 1;
			out.signext_imm = 0;
		end

		endcase
	end

endmodule






















































































































































































































		// src__slash__misc_defines_header_sv



//case 2:
//	s = get_bits_with_range(s, 15, 8)
//		? get_bits_with_range(s, 15, 8)
//		: ((1 << 8) | get_bits_with_range(s, 7, 0));
//	set_bits_with_range(ret, get_bits_with_range(s, 8, 8), 3,
//		3);

//case 1:
//	s = get_bits_with_range(s, 7, 4)
//		? get_bits_with_range(s, 7, 4)
//		: ((1 << 4) | get_bits_with_range(s, 3, 0));
//	set_bits_with_range(ret, get_bits_with_range(s, 4, 4), 2,
//		2);

//	s = get_bits_with_range(s, 3, 2)
//		? get_bits_with_range(s, 3, 2)
//		: ((1 << 2) | get_bits_with_range(s, 1, 0));
//	set_bits_with_range(ret, get_bits_with_range(s, 2, 2), 1,
//		1);

//	set_bits_with_range(ret, !get_bits_with_range(s, 1, 1), 0,
//		0);
//	break;

module Snow64CountLeadingZeros16
	(input logic [
	((16) - 1):0] in,
	output logic [
	((5) - 1):0] out);

	logic [
	((16) - 1):0] __temp;

	//always_comb
	always @(*)
	begin
		if (in == 0)
		begin
			// This is why "out" has a width of 5 bits.
			out = 16;
		end

		else
		begin
			__temp = in;
			out[4] = 0;

			__temp = __temp[15:8] ? __temp[15:8] : {1'b1, __temp[7:0]};
			out[3] = __temp[8];

			__temp = __temp[7:4] ? __temp[7:4] : {1'b1, __temp[3:0]};
			out[2] = __temp[4];

			__temp = __temp[3:2] ? __temp[3:2] : {1'b1, __temp[1:0]};
			out[1] = __temp[2];

			out[0] = !__temp[1];
		end
	end

endmodule

module Snow64CountLeadingZeros32
	(input logic [
	((32) - 1):0] in,
	output logic [
	((6) - 1):0] out);

	logic [
	((32) - 1):0] __temp;

	//always_comb
	always @(*)
	begin
		if (in == 0)
		begin
			out = 32;
		end

		else
		begin
			__temp = in;
			out[5] = 0;

			__temp = __temp[31:16] ? __temp[31:16] : {1'b1, __temp[15:0]};
			out[4] = __temp[16];

			__temp = __temp[15:8] ? __temp[15:8] : {1'b1, __temp[7:0]};
			out[3] = __temp[8];

			__temp = __temp[7:4] ? __temp[7:4] : {1'b1, __temp[3:0]};
			out[2] = __temp[4];

			__temp = __temp[3:2] ? __temp[3:2] : {1'b1, __temp[1:0]};
			out[1] = __temp[2];

			out[0] = !__temp[1];
		end
	end

endmodule

module Snow64CountLeadingZeros64
	(input logic [
	((64) - 1):0] in,
	output logic [
	((7) - 1):0] out);

	logic [
	((64) - 1):0] __temp;

	//always_comb
	always @(*)
	begin
		if (in == 0)
		begin
			out = 64;
		end

		else
		begin
			__temp = in;
			out[6] = 0;

			__temp = __temp[63:32] ? __temp[63:32] : {1'b1, __temp[31:0]};
			out[5] = __temp[32];

			__temp = __temp[31:16] ? __temp[31:16] : {1'b1, __temp[15:0]};
			out[4] = __temp[16];

			__temp = __temp[15:8] ? __temp[15:8] : {1'b1, __temp[7:0]};
			out[3] = __temp[8];

			__temp = __temp[7:4] ? __temp[7:4] : {1'b1, __temp[3:0]};
			out[2] = __temp[4];

			__temp = __temp[3:2] ? __temp[3:2] : {1'b1, __temp[1:0]};
			out[1] = __temp[2];

			out[0] = !__temp[1];
		end
	end

endmodule























		// src__slash__snow64_long_div_u16_by_u8_defines_header_sv

// Long division, u16 by u8 -> u16.  Computes 4 bits per cycle.
module Snow64LongDivU16ByU8Radix16(input logic clk, 
	input PkgSnow64LongDiv::PortIn_LongDivU16ByU8 in,
	output PkgSnow64LongDiv::PortOut_LongDivU16ByU8 out);

	localparam __WIDTH__IN_A = 16;
	localparam __MSB_POS__IN_A = 
	((16) - 1);

	localparam __WIDTH__IN_B = 8;
	localparam __MSB_POS__IN_B = 
	((8) - 1);

	localparam __WIDTH__OUT_DATA
		= 16;
	localparam __MSB_POS__OUT_DATA
		= 
	((16) - 1);

	localparam __WIDTH__MULT_ARR = 12;
	localparam __MSB_POS__MULT_ARR = ((__WIDTH__MULT_ARR) - 1);

	localparam __WIDTH__ALMOST_OUT_DATA = __WIDTH__IN_A;
	localparam __MSB_POS__ALMOST_OUT_DATA
		= ((__WIDTH__ALMOST_OUT_DATA) - 1);

	localparam __RADIX = 16;
	localparam __NUM_BITS_PER_ITERATION = 4;
	//localparam __STARTING_I_VALUE = `WIDTH2MP(__RADIX);
	localparam __STARTING_I_VALUE = ((__NUM_BITS_PER_ITERATION) - 1);
	//localparam __STARTING_I_VALUE = 3;

	localparam __WIDTH__TEMP = 16;
	localparam __MSB_POS__TEMP = ((__WIDTH__TEMP) - 1);

	localparam __WIDTH__ARR_INDEX = 4;
	localparam __MSB_POS__ARR_INDEX = ((__WIDTH__ARR_INDEX) - 1);

	//enum logic [1:0]
	//{
	//	StIdle,
	//	StStarting,
	//	StWorking
	//} __state;
	enum logic
	{
		StIdle,
		StWorking
	} __state;



	logic [__MSB_POS__MULT_ARR:0] __mult_arr
		[0 : ((__RADIX) - 1)];
	//logic [__MSB_POS__TEMP:0] __mult_arr[0 : __RADIX];

	logic [__MSB_POS__IN_A:0] __captured_a;
	//logic [__MSB_POS__IN_B:0] __captured_b;

	logic [__MSB_POS__TEMP:0] __current;

	//logic [__MSB_POS__ARR_INDEX:0] __i;
	logic [1:0] __i;
	logic [__MSB_POS__TEMP:0] __j;

	logic [__MSB_POS__ALMOST_OUT_DATA:0] __almost_out_data;
	logic __temp_out_data_valid, __temp_out_can_accept_cmd;

	//logic [__MSB_POS__ARR_INDEX:0] __search_result;
	//logic [__MSB_POS__ARR_INDEX:0]
	//	__search_result_0_1_2_3, __search_result_4_5_6_7,
	//	__search_result_8_9_10_11, __search_result_12_13_14_15;
	logic [__MSB_POS__ARR_INDEX:0]
		__search_result_0_to_7, __search_result_8_to_15;

	assign out.data = __almost_out_data;
	assign out.data_valid = __temp_out_data_valid;
	assign out.can_accept_cmd = __temp_out_can_accept_cmd;

	task iteration_end;
		input [__MSB_POS__ARR_INDEX:0] some_index;
		//case (__i[3:2])
		case (__i)
			2'd3:
			begin
				__almost_out_data[15:12] = some_index;
			end

			2'd2:
			begin
				__almost_out_data[11:8] = some_index;
			end

			2'd1:
			begin
				__almost_out_data[7:4] = some_index;
			end

			2'd0:
			begin
				__almost_out_data[3:0] = some_index;
			end
		endcase

		__current = __current - __mult_arr[some_index];
	endtask

	//assign out_ready = (__state == StIdle);

	initial
	begin
		__state = StIdle;
		//out.data_valid = 0;
		//out.can_accept_cmd = 1;
		__temp_out_data_valid = 0;
		__temp_out_can_accept_cmd = 1;
	end


	always @(posedge clk)
	begin
		case (__state)
			StIdle:
			begin
				__current = 0;

				//if (in.start)
				//begin
				//	out.data_valid = 1;
				//	out.can_accept_cmd = 1;
				//end
				__almost_out_data = 0;
			end

			StWorking:
			begin
				//case (__i[3:2])
				case (__i)
					2'd3:
					begin
						__current = {__current[11:0], __captured_a[15:12]};
					end

					2'd2:
					begin
						__current = {__current[11:0], __captured_a[11:8]};
					end

					2'd1:
					begin
						__current = {__current[11:0], __captured_a[7:4]};
					end

					2'd0:
					begin
						__current = {__current[11:0], __captured_a[3:0]};
					end
				endcase

				// Binary search
				if (__mult_arr[8] > __current)
				begin
					if (__mult_arr[4] > __current)
					begin
						if (__mult_arr[2] > __current)
						begin
							// 0 or 1
							if (__mult_arr[1] > __current)
							begin
								__search_result_0_to_7 = 0;
								//iteration_end(0);
							end
							else // if (__mult_arr[1] <= __current)
							begin
								__search_result_0_to_7 = 1;
								//iteration_end(1);
							end
						end
						else // if (__mult_arr[2] <= __current)
						begin
							// 2 or 3
							if (__mult_arr[3] > __current)
							begin
								__search_result_0_to_7 = 2;
								//iteration_end(2);
							end
							else // if (__mult_arr[3] <= __current)
							begin
								__search_result_0_to_7 = 3;
								//iteration_end(3);
							end
						end

						//iteration_end(__search_result_0_1_2_3);
						//iteration_end(__search_result);
					end
					else // if (__mult_arr[4] <= __current)
					begin
						if (__mult_arr[6] > __current)
						begin
							// 4 or 5
							if (__mult_arr[5] > __current)
							begin
								__search_result_0_to_7 = 4;
								//iteration_end(4);
							end
							else // if (__mult_arr[5] <= __current)
							begin
								__search_result_0_to_7 = 5;
								//iteration_end(5);
							end
						end
						else // if (__mult_arr[6] <= __current)
						begin
							// 6 or 7
							if (__mult_arr[7] > __current)
							begin
								__search_result_0_to_7 = 6;
								//iteration_end(6);
							end
							else // if (__mult_arr[7] <= __current)
							begin
								__search_result_0_to_7 = 7;
								//iteration_end(7);
							end
						end

						//iteration_end(__search_result_4_5_6_7);
						//iteration_end(__search_result);
					end
					iteration_end(__search_result_0_to_7);
				end
				else // if (__mult_arr[8] <= __current)
				begin
					if (__mult_arr[12] > __current)
					begin
						if (__mult_arr[10] > __current)
						begin
							// 8 or 9
							if (__mult_arr[9] > __current)
							begin
								__search_result_8_to_15 = 8;
								//iteration_end(8);
							end
							else // if (__mult_arr[9] <= __current)
							begin
								__search_result_8_to_15 = 9;
								//iteration_end(9);
							end
						end
						else // if (__mult_arr[10] <= __current)
						begin
							// 10 or 11
							if (__mult_arr[11] > __current)
							begin
								__search_result_8_to_15 = 10;
								//iteration_end(10);
							end
							else // if (__mult_arr[11] <= __current)
							begin
								__search_result_8_to_15 = 11;
								//iteration_end(11);
							end
						end

						//iteration_end(__search_result_8_9_10_11);
						//iteration_end(__search_result);
					end
					else // if (__mult_arr[12] <= __current)
					begin
						if (__mult_arr[14] > __current)
						begin
							// 12 or 13
							if (__mult_arr[13] > __current)
							begin
								__search_result_8_to_15 = 12;
								//iteration_end(12);
							end
							else // if (__mult_arr[13] <= __current)
							begin
								__search_result_8_to_15 = 13;
								//iteration_end(13);
							end
						end
						else // if (__mult_arr[14] <= __current)
						begin
							// 14 or 15
							if (__mult_arr[15] > __current)
							begin
								__search_result_8_to_15 = 14;
								//iteration_end(14);
								//__search_result_12_13_14_15 = 14;
							end
							else
							begin
								__search_result_8_to_15 = 15;
								//iteration_end(15);
							end
						end

						//iteration_end(__search_result_12_13_14_15);
						//iteration_end(__search_result);
					end
					iteration_end(__search_result_8_to_15);
				end
				//iteration_end(__search_result);

				//if (__i == 0)
				//begin
				//	out.data_valid = 1;
				//	out.can_accept_cmd = 1;
				//end
			end

		endcase
	end

	always_ff @(posedge clk)
	begin
		case (__state)
			StIdle:
			begin
				if (in.start)
				begin
					__state <= StWorking;

					__mult_arr[0] <= 0;

					if (in.b != 0)
					begin
						__captured_a <= in.a;
						//__captured_b <= in.b;

						//__mult_arr[0] <= in.b * 0;
						__mult_arr[1] <= in.b * 1;
						__mult_arr[2] <= in.b * 2;
						__mult_arr[3] <= in.b * 3;

						__mult_arr[4] <= in.b * 4;
						__mult_arr[5] <= in.b * 5;
						__mult_arr[6] <= in.b * 6;
						__mult_arr[7] <= in.b * 7;

						__mult_arr[8] <= in.b * 8;
						__mult_arr[9] <= in.b * 9;
						__mult_arr[10] <= in.b * 10;
						__mult_arr[11] <= in.b * 11;

						__mult_arr[12] <= in.b * 12;
						__mult_arr[13] <= in.b * 13;
						__mult_arr[14] <= in.b * 14;
						__mult_arr[15] <= in.b * 15;

					end

					else // if (in.b == 0)
					begin
						// Ensure "correct" results (return a zero when
						// in.b is zero)
						__captured_a <= 0;
						//__captured_b <= 1;

						//__mult_arr[0] <= 0;
						__mult_arr[1] <= 1;
						__mult_arr[2] <= 2;
						__mult_arr[3] <= 3;

						__mult_arr[4] <= 4;
						__mult_arr[5] <= 5;
						__mult_arr[6] <= 6;
						__mult_arr[7] <= 7;

						__mult_arr[8] <= 8;
						__mult_arr[9] <= 9;
						__mult_arr[10] <= 10;
						__mult_arr[11] <= 11;

						__mult_arr[12] <= 12;
						__mult_arr[13] <= 13;
						__mult_arr[14] <= 14;
						__mult_arr[15] <= 15;
					end

					__i <= __STARTING_I_VALUE;
					__temp_out_data_valid <= 0;
					__temp_out_can_accept_cmd <= 0;
				end
			end


			StWorking:
			begin
				//__i <= __i - __NUM_BITS_PER_ITERATION;
				__i <= __i - 1;

				// Last iteration means we should update __state
				//if (__i == __NUM_BITS_PER_ITERATION - 1)
				if (__i == 0)
				begin
					__state <= StIdle;
					__temp_out_data_valid <= 1;
					__temp_out_can_accept_cmd <= 1;
				end
			end
		endcase
	end

endmodule
