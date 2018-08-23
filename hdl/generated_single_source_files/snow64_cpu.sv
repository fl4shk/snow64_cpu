


// src/snow64_instr_decoder_defines.header.sv




// src/misc_defines.header.sv

//`default_nettype none





// MSB position of some struct... used for approximating the ability to put
// a packed struct into another packed struct with Icarus Verilog.
// Ideally, Icarus Verilog would support that directly.


// A struct's dimensions (mostly used to work around limitations in Icarus
// Verilog's support of packed structs).










//`define SIGN_EXTEND_SLICED(some_full_width, some_width_of_arg, 
//	some_non_sliced_arg, some_other_arg) \
//	{{(some_full_width - some_width_of_arg) \
//	{some_non_sliced_arg[`WIDTH2MP(some_width_of_arg)]}},some_other_arg}



//`define BPRANGE_TO_SHIFTED_MASK(bit_pos_hi, bit_pos_lo) \
//	(((1 << (bit_pos_hi - bit_pos_lo + 1)) - 1) << bit_pos_lo)
//`define GET_BITS(to_get_from, mask, shift) \
//	((to_get_from & mask) >> shift)
//`define GET_BITS_WITH_RANGE(to_get_from, bit_pos_range_hi,
//	bit_pos_range_lo) \
//	`GET_BITS(to_get_from, \
//		`BPRANGE_TO_SHIFTED_MASK(bit_pos_range_hi, bit_pos_range_lo), \
//		bit_pos_range_lo)

















































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




// A maximum of 8 basic instruction groups.  If necessary, "extended"
// instruction groups may be added.






























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


	//// If we should stall the pipeline because of this instruction
	//logic stall;


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



// src/snow64_lar_file_defines.header.sv

//`include "src/misc_defines.header.sv"
































		// src__slash__snow64_cpu_defines_header_sv













// 8-bit










// 16-bit










// 32-bit










// 64-bit










// Metadata stuff





// A "tag" in this case is which refers to the index of the shared data
// that this LAR cares about.





// Shared data stuff











// It is technically possible for all the non-dzero LARs' metadata to point
// to the same shared data, though this is uncommon in practice.






















		// src__slash__snow64_lar_file_defines_header_sv

package PkgSnow64Cpu;

typedef logic [((64) - 1):0] CpuAddr;
typedef logic [
	((256) - 1):0] LarData;

typedef enum logic [
	((2) - 1):0]
{
	// Put "DataTypUnsgnInt" and "DataTypSgnInt" in this order so that we
	// can just do "some_data_type[0]" to get the value for the
	// "type_signedness" input that some modules have.
	DataTypUnsgnInt,
	DataTypSgnInt,

	// Snow64 only has BFloat16's for its floating point numbers.
	DataTypBFloat16,

	// We don't really have another format here.  A future data LARs
	// machine may support, for example, fixed-point numbers in the
	// hardware.  (I have some ideas for that myself, but I'm not going
	// into that here).
	// 
	// Another alternative might be to change "DataTypBFloat16" to
	// "DataTypFloat32" and also to change "DataTypReserved" to
	// "DataTypFloat64" if both binary32 and binary64 floats are supported,
	// but no other floating point types are supported.
	DataTypReserved
} DataType;

// Integers are the only types that rely on this "enum"... though perhaps
// that will change.
typedef enum logic [
	((2) - 1):0]
{
	IntTypSz8,
	IntTypSz16,
	IntTypSz32,
	IntTypSz64
} IntTypeSize;





typedef struct packed
{
	// Request an interrrupt.
	logic req;
} PartialPortIn_Cpu_Interrupt;



typedef enum logic
{
	ExtDataAccTypRead,
	ExtDataAccTypWrite
} ExtDataAccessType;


// Used for both memory access and port-mapped IO.
// Just as an aside, "Ext" stands for "external".
typedef struct packed
{
	logic busy;
	LarData data;
} PartialPortIn_Cpu_ExtDataAccess;

typedef struct packed
{
	logic req;
	ExtDataAccessType access_type;

	// Both memory and port-mapped IO are assumed to use 64-bit addresses,
	// at least from the CPU's perspective.
	// 
	// It's still technically possible to use smaller memory.
	CpuAddr addr;

	// Output data.
	LarData data;
} PartialPortOut_Cpu_ExtDataAccess;



typedef struct packed
{
	logic [(($bits(PartialPortIn_Cpu_Interrupt)) - 1):0] interrupt;
	logic [(($bits(PartialPortIn_Cpu_ExtDataAccess)) - 1):0]
		ext_dat_acc_mem, ext_dat_acc_port_mapped_io;
} PortIn_Cpu;


typedef struct packed
{
	logic [(($bits(PartialPortOut_Cpu_ExtDataAccess)) - 1):0]
		ext_dat_acc_mem, ext_dat_acc_port_mapped_io;
} PortOut_Cpu;

endpackage : PkgSnow64Cpu



// src/snow64_instr_cache_defines.header.sv



















































































































































































































































		// src__slash__misc_defines_header_sv

















































































































		// src__slash__snow64_lar_file_defines_header_sv










































		// src__slash__snow64_instr_decoder_defines_header_sv



// A single icache line is as long as a single LAR.
// This is done for simplicity purposes.





//`define WIDTH__SNOW64_ICACHE_LINE_PACKED_INNER_DIM 64
//`define WIDTH__SNOW64_ICACHE_LINE_PACKED_INNER_DIM 16










// log2 of the max possible number of addresses whose data is stored.

//`define WIDTH__SNOW64_ICACHE_EFFECTIVE_ADDR__BYTE_BASE_ADDR 12

//`define WIDTH__SNOW64_ICACHE_EFFECTIVE_ADDR__BYTE_BASE_ADDR 10

// To guarantee that the formal verification will complete in a reasonable
// amount of time, we use a smaller instruction cache.

//`define WIDTH__SNOW64_ICACHE_EFFECTIVE_ADDR__BYTE_BASE_ADDR 8
//`define WIDTH__SNOW64_ICACHE_EFFECTIVE_ADDR__BYTE_BASE_ADDR 7


		// FORMAL






// An index into the line of data (select an instruction from the line of
// data)











// Forcefully align addresses to width of instructions
// if outer index width is 8, WIDTH...DONT_CARE == 0
// if outer index width is 16, WIDTH...DONT_CARE == 1
// if outer index width is 32, WIDTH...DONT_CARE == 2





// 32 kiB instruction cache




















		// src__slash__snow64_instr_cache_defines_header_sv


package PkgSnow64InstrCache;

localparam WIDTH__LINE_DATA = 256;
localparam MSB_POS__LINE_DATA = ((WIDTH__LINE_DATA) - 1);

localparam WIDTH__LINE_PACKED_OUTER_DIM
	= 
	(256
	/ 32);
localparam MSB_POS__LINE_PACKED_OUTER_DIM
	= ((WIDTH__LINE_PACKED_OUTER_DIM) - 1);

localparam WIDTH__LINE_PACKED_INNER_DIM
	= 32;
localparam MSB_POS__LINE_PACKED_INNER_DIM
	= ((WIDTH__LINE_PACKED_INNER_DIM) - 1);

//localparam WIDTH__EFFECTIVE_ADDR__LOW_BASE_ADDR
//	= `WIDTH__SNOW64_ICACHE_EFFECTIVE_ADDR__LOW_BASE_ADDR;
//localparam MSB_POS__EFFECTIVE_ADDR__LOW_BASE_ADDR
//	= `WIDTH2MP(WIDTH__EFFECTIVE_ADDR__LOW_BASE_ADDR);


localparam ARR_SIZE__NUM_LINES = 
	((1 << 9)
	/ (256 / 8));
localparam LAST_INDEX__NUM_LINES
	= ((ARR_SIZE__NUM_LINES) - 1);


typedef logic [
	((
	(64
	- 
	$clog2(
	((1 << 9)
	/ (256 / 8)))
	- 
	($clog2(
	(256
	/ 32)))
	- 
	$clog2(32 / 8))) - 1):0] Tag;
typedef logic [
	((
	$clog2(
	((1 << 9)
	/ (256 / 8)))) - 1):0]
	ArrIndex;
typedef logic [
	((
	($clog2(
	(256
	/ 32)))) - 1):0]
	LineIndex;

typedef logic [((64) - 1):0] CpuAddr;
typedef logic [
	((256) - 1):0] LineData;
typedef logic [((32) - 1):0] Instr;

typedef enum logic
{
	StIdle,
	StWaitForMem
} State;

typedef struct packed
{
	Tag tag;
	ArrIndex arr_index;
	LineIndex line_index;

	logic [
	((
	$clog2(32 / 8)) - 1):0] dont_care;
} EffectiveAddr;


typedef struct packed
{
	logic valid;
	LineData data;
} PartialPortIn_InstrCache_MemAccess;

typedef struct packed
{
	logic req;
	CpuAddr addr;
} PartialPortIn_InstrCache_ReqRead;

typedef struct packed
{
	logic valid;
	Instr instr;
} PartialPortOut_InstrCache_ReqRead;

typedef struct packed
{
	logic req;
	CpuAddr addr;
} PartialPortOut_InstrCache_MemAccess;

typedef struct packed
{
	logic [(($bits(PartialPortIn_InstrCache_ReqRead)) - 1):0] req_read;
	logic [(($bits(PartialPortIn_InstrCache_MemAccess)) - 1):0] mem_access;
} PortIn_InstrCache;

typedef struct packed
{
	logic [(($bits(PartialPortOut_InstrCache_ReqRead)) - 1):0] req_read;
	logic [(($bits(PartialPortOut_InstrCache_MemAccess)) - 1):0] mem_access;
} PortOut_InstrCache;


endpackage : PkgSnow64InstrCache



// src/snow64_memory_access_fifo_defines.header.sv

//`include "src/misc_defines.header.sv"

















































































































		// src__slash__snow64_lar_file_defines_header_sv






		// src__slash__snow64_memory_access_fifo_defines_header_sv

// Single-element FIFOs.
package PkgSnow64MemoryAccessFifo;


typedef logic [((64) - 1):0] CpuAddr;
typedef logic [
	((256) - 1):0] LarData;


// Snow64MemoryAccessReadFifo

typedef enum logic
{
	RdFifoStIdle,
	RdFifoStWaitForMem
} ReadFifoState;

typedef struct packed
{
	logic req;

	// This address is generally aligned to the size of LarData.
	CpuAddr addr;
} PartialPortIn_ReadFifo_ReqRead;

typedef struct packed
{
	logic valid, cmd_accepted;
	LarData data;
} PartialPortIn_ReadFifo_FromMemoryBusGuard;

typedef struct packed
{
	logic valid, busy;
	LarData data;
} PartialPortOut_ReadFifo_ReqRead;

typedef PartialPortIn_ReadFifo_ReqRead
	PartialPortOut_ReadFifo_ToMemoryBusGuard;


typedef struct packed
{
	logic [(($bits(PartialPortIn_ReadFifo_ReqRead)) - 1):0] req_read;
	logic [(($bits(PartialPortIn_ReadFifo_FromMemoryBusGuard)) - 1):0]
		from_memory_bus_guard;
} PortIn_MemoryAccessReadFifo;

typedef struct packed
{
	logic [(($bits(PartialPortOut_ReadFifo_ReqRead)) - 1):0] req_read;
	logic [(($bits(PartialPortOut_ReadFifo_ToMemoryBusGuard)) - 1):0]
		to_memory_bus_guard;
} PortOut_MemoryAccessReadFifo;


// Snow64MemoryAccessWriteFifo

typedef enum logic
{
	WrFifoStIdle,
	WrFifoStWaitForMem
} WriteFifoState;

typedef struct packed
{
	logic req;

	// This address is generally aligned to the size of LarData.
	CpuAddr addr;
	LarData data;
} PartialPortIn_WriteFifo_ReqWrite;

typedef struct packed
{
	logic valid, cmd_accepted;
} PartialPortIn_WriteFifo_FromMemoryBusGuard;

typedef struct packed
{
	logic valid, busy;
} PartialPortOut_WriteFifo_ReqWrite;

typedef PartialPortIn_WriteFifo_ReqWrite
	PartialPortOut_WriteFifo_ToMemoryBusGuard;


typedef struct packed
{
	logic [(($bits(PartialPortIn_WriteFifo_ReqWrite)) - 1):0] req_write;
	logic [(($bits(PartialPortIn_WriteFifo_FromMemoryBusGuard)) - 1):0]
		from_memory_bus_guard;
} PortIn_MemoryAccessWriteFifo;

typedef struct packed
{
	logic [(($bits(PartialPortOut_WriteFifo_ReqWrite)) - 1):0] req_write;
	logic [(($bits(PartialPortOut_WriteFifo_ToMemoryBusGuard)) - 1):0]
		to_memory_bus_guard;
} PortOut_MemoryAccessWriteFifo;

endpackage : PkgSnow64MemoryAccessFifo



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
localparam __DEBUG_PORT_MSB_POS__INT_TYPE_SIZE
	= 
	((2) - 1);


typedef struct packed
{
	logic [
	((64) - 1):0] a, b;
	logic [((4) - 1):0] oper;
	logic [
	((2) - 1):0] int_type_size;
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
localparam MSB_POS__OF_64 = ((WIDTH__OF_64) - 1);
localparam WIDTH__OF_32 = 32;
localparam MSB_POS__OF_32 = ((WIDTH__OF_32) - 1);
localparam WIDTH__OF_16 = 16;
localparam MSB_POS__OF_16 = ((WIDTH__OF_16) - 1);
localparam WIDTH__OF_8 = 8;
localparam MSB_POS__OF_8 = ((WIDTH__OF_8) - 1);




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



// src/snow64_memory_bus_guard_defines.header.sv



















































































































































































































































		// src__slash__misc_defines_header_sv
//`include "src/snow64_cpu_defines.header.sv"







		// src__slash__snow64_memory_bus_guard_defines_header_sv
































		// src__slash__snow64_cpu_defines_header_sv

















































































































		// src__slash__snow64_lar_file_defines_header_sv


package PkgSnow64MemoryBusGuard;

typedef logic [((64) - 1):0] CpuAddr;
typedef logic [
	((256) - 1):0] LarData;

//typedef enum logic [`MSB_POS__SNOW64_MEMORY_BUS_GUARD__STATE:0]
//{
//	StIdle,
//	StOneReqWaitForMem,
//	StTwoReqsWaitForMem0,
//	StTwoReqsWaitForMem1
//} State;

typedef enum logic [
	((2) - 1):0]
{
	ReqTypNone,
	ReqTypReadInstr,
	ReqTypReadData,
	ReqTypWriteData
} RequestType;

typedef struct packed
{
	logic req;
	CpuAddr addr;
} PartialPortIn_MemoryBusGuard_ReqRead;

typedef struct packed
{
	logic req;
	CpuAddr addr;
	LarData data;
} PartialPortIn_MemoryBusGuard_ReqWrite;

typedef struct packed
{
	// valid:  indicate command complete
	// cmd_accepted:  indicate command accepted (used for clearing the
	// FIFO)
	logic valid, cmd_accepted;
	LarData data;
} PartialPortOut_MemoryBusGuard_ReqRead;

typedef struct packed
{
	// valid:  indicate command complete
	// cmd_accepted:  indicate command accepted (used for clearing the
	// FIFO)
	logic valid, cmd_accepted;
} PartialPortOut_MemoryBusGuard_ReqWrite;


// The memory input interface
typedef struct packed
{
	logic valid;
	LarData data;
} PartialPortIn_MemoryBusGuard_MemAccess;

// Whether we want to read from or write to memory.
typedef enum logic
{
	MemAccTypRead,
	MemAccTypWrite
} MemAccessType;

// The memory output interface
typedef struct packed
{
	logic req;
	CpuAddr addr;
	LarData data;
	logic mem_acc_type;
} PartialPortOut_MemoryBusGuard_MemAccess;

typedef struct packed
{
	logic [(($bits(PartialPortIn_MemoryBusGuard_ReqRead)) - 1):0]
		req_read_instr, req_read_data;

	logic [(($bits(PartialPortIn_MemoryBusGuard_ReqWrite)) - 1):0]
		req_write_data;

	logic [(($bits(PartialPortIn_MemoryBusGuard_MemAccess)) - 1):0] mem_access;
} PortIn_MemoryBusGuard;

typedef struct packed
{
	logic [(($bits(PartialPortOut_MemoryBusGuard_ReqRead)) - 1):0]
		req_read_instr, req_read_data;

	logic [(($bits(PartialPortOut_MemoryBusGuard_ReqWrite)) - 1):0]
		req_write_data;

	//logic `STRUCTDIM(PartialPortOut_MemoryBusGuard_Status) status;

	logic [(($bits(PartialPortOut_MemoryBusGuard_MemAccess)) - 1):0]
		mem_access;
} PortOut_MemoryBusGuard;


endpackage : PkgSnow64MemoryBusGuard
































		// src__slash__snow64_cpu_defines_header_sv

package PkgSnow64SlicedData;


typedef struct packed
{
	logic [
	((8) - 1):0] 
		data_7, data_6, data_5, data_4, data_3, data_2, data_1, data_0;
} SlicedData8;

typedef struct packed
{
	logic [
	((16) - 1):0] 
		data_3, data_2, data_1, data_0;
} SlicedData16;

typedef struct packed
{
	logic [
	((32) - 1):0] data_1, data_0;
} SlicedData32;

typedef struct packed
{
	logic [
	((64) - 1):0] data_0;
} SlicedData64;


endpackage : PkgSnow64SlicedData

















































































































		// src__slash__snow64_lar_file_defines_header_sv


package PkgSnow64LarFile;

typedef logic [
	((4) - 1):0] LarIndex;
typedef logic [
	((
	(64 - 5)) - 1):0]
	LarAddrBasePtr8;
typedef logic [
	((5) - 1):0] LarAddrOffset8;
typedef logic [
	((
	(64 - 4)) - 1):0]
	LarAddrBasePtr16;
typedef logic [
	((4) - 1):0] LarAddrOffset16;
typedef logic [
	((
	(64 - 3)) - 1):0]
	LarAddrBasePtr32;
typedef logic [
	((3) - 1):0] LarAddrOffset32;
typedef logic [
	((
	(64 - 2)) - 1):0]
	LarAddrBasePtr64;
typedef logic [
	((2) - 1):0] LarAddrOffset64;
typedef logic [
	((4) - 1):0] LarTag;

typedef logic [
	((256) - 1):0] LarData;
typedef logic [
	((
	
	(64 - 5)) - 1):0]
	LarBaseAddr;
typedef logic [
	((
	4) - 1):0]
	LarRefCount;
typedef logic [
	((1) - 1):0] LarDirty;

typedef enum logic [
	((2) - 1):0]
{
	// Mostly ALU/FPU operations.
	WriteTypOnlyData,

	// Used for port-mapped input instructions
	WriteTypDataAndType,

	WriteTypLd,

	WriteTypSt
} LarFileWriteType;

typedef enum logic [
	((3) - 1):0]
{
	WrStIdle,
	WrStStartLdSt,
	WrStWaitForJustMemRead,
	WrStWaitForJustMemWrite,

	WrStWaitForMemReadAndMemWrite,
	WrStBad0,
	WrStBad1,
	WrStBad2
} WriteState;

typedef struct packed
{
	//logic mem_bus_guard_instr_load_busy;
	logic mem_bus_guard_busy;
} PartialPortIn_LarFile_Ctrl;

typedef struct packed
{
	LarIndex index;
} PartialPortIn_LarFile_Read;


typedef struct packed
{
	// Are we requesting a write at all?
	logic req;

	// The type of writing into the LAR file that we're doing.
	logic [
	((2) - 1):0] write_type;

	// Which LAR are we writing to?
	LarIndex index;

	// Data to write into the LAR file (not relevant for WriteTypLd or
	// WriteTypSt)
	LarData data;

	// Address to write into the LAR file (relevant for WriteTypLd and
	// WriteTypSt)
	PkgSnow64Cpu::CpuAddr addr;

	// New type of the LAR (relevant for all LarFileWriteType's except
	// WriteTypOnlyData)
	logic [
	((2) - 1):0] data_type;
	logic [
	((2) - 1):0] int_type_size;
} PartialPortIn_LarFile_Write;

typedef struct packed
{
	logic valid, busy;
	LarData data;
} PartialPortIn_LarFile_MemRead;

typedef struct packed
{
	logic valid, busy;
} PartialPortIn_LarFile_MemWrite;

typedef struct packed
{
	LarData data;
	PkgSnow64Cpu::CpuAddr addr;

	// Outside the LAR file itself, this "tag" is used for operand
	// forwarding by the control unit or whatever you want to call it.
	// This is very much akin to how I implemented operand forwarding in my
	// first pipelined CPU, but in that case, I had used the register
	// indices directly.  Of course, with a DLARs machine, that's not
	// really a valid option because two registers may actually point to
	// the same data.
	LarTag tag;

	logic [
	((2) - 1):0] data_type;

	// Same int_type_size goodness as in other modules.
	logic [
	((2) - 1):0] int_type_size;

	// It turns out that nobody besides the LAR file needs to know which
	// LARs are dirty!
} PartialPortOut_LarFile_Read;

// Tell the outside world when we want to read from memory.
typedef struct packed
{
	logic req;
	LarBaseAddr base_addr;
} PartialPortOut_LarFile_MemRead;

// Tell the outside world when we want to write to memory.
typedef struct packed
{
	logic req;
	LarData data;
	LarBaseAddr base_addr;
} PartialPortOut_LarFile_MemWrite;

// Wait for me!
// This indicates that we can't accept any commands.
typedef struct packed
{
	logic busy;
} PartialPortOut_LarFile_WaitForMe;

typedef struct packed
{
	logic [(($bits(PartialPortIn_LarFile_Ctrl)) - 1):0] ctrl;

	logic [(($bits(PartialPortIn_LarFile_Read)) - 1):0] rd_a;
	logic [(($bits(PartialPortIn_LarFile_Read)) - 1):0] rd_b;
	logic [(($bits(PartialPortIn_LarFile_Read)) - 1):0] rd_c;
	logic [(($bits(PartialPortIn_LarFile_Write)) - 1):0] wr;
	logic [(($bits(PartialPortIn_LarFile_MemRead)) - 1):0] mem_read;
	logic [(($bits(PartialPortIn_LarFile_MemWrite)) - 1):0] mem_write;
} PortIn_LarFile;

typedef struct packed
{
	logic [(($bits(PartialPortOut_LarFile_Read)) - 1):0] rd_a;
	logic [(($bits(PartialPortOut_LarFile_Read)) - 1):0] rd_b;
	logic [(($bits(PartialPortOut_LarFile_Read)) - 1):0] rd_c;
	logic [(($bits(PartialPortOut_LarFile_MemRead)) - 1):0] mem_read;
	logic [(($bits(PartialPortOut_LarFile_MemWrite)) - 1):0] mem_write;
	logic [(($bits(PartialPortOut_LarFile_WaitForMe)) - 1):0] wait_for_me;
} PortOut_LarFile;


typedef struct packed
{
	LarAddrBasePtr8 base_ptr;
	LarAddrOffset8 offset;
} LarAddr8;


typedef struct packed
{
	LarAddrBasePtr16 base_ptr;
	LarAddrOffset16 offset;
} LarAddr16;


typedef struct packed
{
	LarAddrBasePtr32 base_ptr;
	LarAddrOffset32 offset;
} LarAddr32;


typedef struct packed
{
	LarAddrBasePtr64 base_ptr;
	LarAddrOffset64 offset;
} LarAddr64;

// Used to grab the base_addr from an incoming address
typedef struct packed
{
	LarBaseAddr base_addr;
	logic [
	((
	5) - 1):0] fill;
} LarIncomingBaseAddr;



//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_8:0]
//	LarAddr8BasePtr;
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_8:0]
//	LarAddr8DataOffset;
//
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_16:0]
//	LarAddr16BasePtr;
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_16:0]
//	LarAddr16DataOffset;
//
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_32:0]
//	LarAddr32BasePtr;
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_32:0]
//	LarAddr32DataOffset;
//
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_BASE_PTR_64:0]
//	LarAddr64BasePtr;
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_64:0]
//	LarAddr64DataOffset;



// LAR Metadata stuff


//typedef logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET:0]
//	LarMetaDaDataOffset;

//// The LAR's tag... specifies which shared data is used by this LAR.
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0] LarMetaDaTag;

//// See PkgSnow64Cpu::DataType.
//typedef logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] LarMetaDaDataType;

//// See PkgSnow64Cpu::IntTypeSize.
//typedef logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] LarMetaDaIntTypeSize;


// LAR Shared Data stuff

//// The base address, used for associativity between LARs.
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0]
//	LarShDaBaseAddr;

//// The data itself.
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_DATA:0] LarShDaData;

//// The reference count.
//typedef logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_REF_COUNT:0]
//	LarShDaRefCount;

//// The "dirty" flag.  Used to determine if we should write back to memory.
//typedef logic LarShDaDirty;

endpackage : PkgSnow64LarFile



// src/snow64_bfloat16_defines.header.sv

































		// src__slash__snow64_cpu_defines_header_sv





















// That's right, here we have a state machine for the BFloat16 adder... we
// don't get to have single cycle execution for bfloat16s.













//`define SNOW64_BFLOAT16_MODDED_BIAS (`SNOW64_BFLOAT16_BIAS + 8'd7)





























		// src__slash__snow64_bfloat16_defines_header_sv

package PkgSnow64BFloat16;

typedef enum logic [
	((4) - 1):0]
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
	logic [
	((4) - 1):0] oper;
	logic [
	((16) - 1):0] a, b;
} PortIn_Fpu;

typedef struct packed
{
	logic data_valid, can_accept_cmd;
	logic [
	((16) - 1):0] data;
} PortOut_Fpu;

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
} PortOut_BinOp;


// For casting an integer to a BFloat16
typedef struct packed
{
	logic start;
	logic [
	((64) - 1):0] to_cast;
	logic [
	((2) - 1):0] int_type_size;
	logic type_signedness;
} PortIn_CastFromInt;

typedef struct packed
{
	logic data_valid, can_accept_cmd;
	logic [
	((16) - 1):0] data;
} PortOut_CastFromInt;


// For casting a BFloat16 to an integer 
typedef struct packed
{
	logic start;
	logic [
	((16) - 1):0] to_cast;
	logic [
	((2) - 1):0] int_type_size;
	logic type_signedness;
} PortIn_CastToInt;

typedef struct packed
{
	logic data_valid, can_accept_cmd;
	logic [
	((64) - 1):0] data;
} PortOut_CastToInt;




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





























































































		// src__slash__snow64_instr_cache_defines_header_sv



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
//	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] __in_alu_type_size;
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
//	assign __in_alu_type_size = PkgSnow64Cpu::IntTypSz8;
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
//	PkgSnow64BFloat16::PortOut_BinOp __out_bfloat16_div;
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

//module TestBFloat16CastFromInt;
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
//	PkgSnow64BFloat16::PortIn_CastFromInt __in_bfloat16_cast_from_int;
//	PkgSnow64BFloat16::PortOut_CastFromInt __out_bfloat16_cast_from_int;
//
//	Snow64BFloat16CastFromInt(.clk(clk), .in(__in_bfloat16_cast_from_int),
//		.out(__out_bfloat16_cast_from_int));
//
//
//	initial
//	begin
//		__in_bfloat16_cast_from_int = 0;
//	end
//
//endmodule

//module TestBFloat16Fpu;
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
//	PkgSnow64BFloat16::PortIn_Fpu __in_bfloat16_fpu;
//	PkgSnow64BFloat16::PortOut_Fpu __out_bfloat16_fpu;
//
//	Snow64BFloat16Fpu __inst_bfloat16_fpu(.clk(clk),
//		.in(__in_bfloat16_fpu), .out(__out_bfloat16_fpu));
//
//endmodule

//module TestLarFile;
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
//	PkgSnow64LarFile::PortIn_LarFile_Ctrl __in_lar_file_ctrl;
//	PkgSnow64LarFile::PortIn_LarFile_Read __in_lar_file_rd_a,
//		__in_lar_file_rd_b, __in_lar_file_rd_c;
//	PkgSnow64LarFile::PortIn_LarFile_Write __in_lar_file_wr;
//
//	PkgSnow64LarFile::PortOut_LarFile_Read __out_lar_file_rd_a,
//		__out_lar_file_rd_b, __out_lar_file_rd_c;
//	PkgSnow64LarFile::PortOut_LarFile_MemWrite __out_lar_file_mem_write;
//
//	Snow64LarFile __inst_lar_file(.clk(__clk),
//		.in_ctrl(__in_lar_file_ctrl), .in_rd_a(__in_lar_file_rd_a),
//		.in_rd_b(__in_lar_file_rd_b), .in_rd_c(__in_lar_file_rd_c),
//		.in_wr(__in_lar_file_wr), .out_rd_a(__out_lar_file_rd_a),
//		.out_rd_b(__out_lar_file_rd_b), .out_rd_c(__out_lar_file_rd_c),
//		.out_mem_write(__out_lar_file_mem_write));
//
//	task inc_indices;
//		{__in_lar_file_rd_a.index, __in_lar_file_rd_b.index,
//			__in_lar_file_rd_c.index} 
//			= {__in_lar_file_rd_a.index, __in_lar_file_rd_b.index,
//			__in_lar_file_rd_c.index} + 1;
//	endtask : inc_indices
//
//	initial
//	begin
//		//__in_lar_file_ctrl.pause = 0;
//
//		//{__in_lar_file_rd_a.index, __in_lar_file_rd_b.index,
//		//	__in_lar_file_rd_c.index} = 0;
//	end
//
//endmodule

//module FakeInstrCacheTestBench;
//	import PkgSnow64InstrCache::MSB_POS__LINE;
//	import PkgSnow64InstrCache::MSB_POS__LINE_PACKED_OUTER_DIM;
//	import PkgSnow64InstrCache::MSB_POS__LINE_PACKED_INNER_DIM;
//	import PkgSnow64InstrCache::LAST_INDEX__NUM_LINES;
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
//	PkgSnow64InstrCache::IncomingAddr test_incoming_addr;
//
//
//	logic [MSB_POS__LINE_PACKED_OUTER_DIM:0]
//		[MSB_POS__LINE_PACKED_INNER_DIM:0]
//		lines_arr[0 : LAST_INDEX__NUM_LINES];
//
//	always_ff @(posedge __clk)
//	begin
//		test_incoming_addr.base_addr <= 0;
//		test_incoming_addr.tag <= 0;
//		test_incoming_addr.line_index <= 0;
//		test_incoming_addr.dont_care <= 0;
//	end
//
//
//endmodule

//`ifdef SVFORMAL
//module TestMemAccess(input logic clk,
//	input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] in_data,
//
//	output logic out_req_wr,
//	output logic [`MSB_POS__SNOW64_CPU_ADDR:0] out_addr,
//	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] out_data);
//
//endmodule
//`endif		// SVFORMAL































		// src__slash__snow64_alu_defines_header_sv
































		// src__slash__snow64_cpu_defines_header_sv

//module DebugSnow64Alu
//	(input logic [`MSB_POS__SNOW64_SIZE_64:0] in_a, in_b,
//	input logic [`MSB_POS__SNOW64_ALU_OPER:0] in_oper,
//	input logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] in_type_size,
//	input logic in_signedness,
//
//	output logic [`MSB_POS__SNOW64_SIZE_64:0] out_data);
//
//	PkgSnow64Alu::PortIn_Alu __in_alu;
//	PkgSnow64Alu::PortOut_Alu __out_alu;
//
//	Snow64Alu __inst_alu(.in(__in_alu), .out(__out_alu));
//
//	always @(*) __in_alu.a = in_a;
//	always @(*) __in_alu.b = in_b;
//	always @(*) __in_alu.oper = in_oper;
//	always @(*) __in_alu.int_type_size = in_type_size;
//	always @(*) __in_alu.type_signedness = in_signedness;
//
//	always @(*) out_data = __out_alu.data;
//endmodule


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
//		case (in.int_type_size)
//		PkgSnow64Cpu::IntTypSz8:
//		begin
//			__in_actual_carry = __performing_subtract;
//		end
//
//		//PkgSnow64Cpu::IntTypSz16:
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
//	PkgSnow64SlicedData::SlicedData8 __in_a_sliced_8, __in_b_sliced_8,
//		__temp_data_sliced_8;
//	PkgSnow64SlicedData::SlicedData16 __in_a_sliced_16, __in_b_sliced_16,
//		__temp_data_sliced_16;
//	PkgSnow64SlicedData::SlicedData32 __in_a_sliced_32, __in_b_sliced_32,
//		__temp_data_sliced_32;
//
//	// ...slicing a 64-bit thing into 64-bit components means you're not
//	// really doing anything.
//	PkgSnow64SlicedData::SlicedData64 __in_a_sliced_64, __in_b_sliced_64,
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
//	always @(*) __in_sub_alu_``some_num``.int_type_size = in.int_type_size; \
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
//		case (in.int_type_size)
//		PkgSnow64Cpu::IntTypSz8:
//		begin
//			out.data = __temp_data_sliced_8;
//		end
//
//		PkgSnow64Cpu::IntTypSz16:
//		begin
//			out.data = __temp_data_sliced_16;
//		end
//
//		PkgSnow64Cpu::IntTypSz32:
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
//		PkgSnow64Cpu::IntTypSz64:
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

	PkgSnow64SlicedData::SlicedData8 
		__in_a_sliced_8, __in_b_sliced_8, __out_data_sliced_8;
	PkgSnow64SlicedData::SlicedData16 
		__in_a_sliced_16, __in_b_sliced_16, __out_data_sliced_16;
	PkgSnow64SlicedData::SlicedData32 
		__in_a_sliced_32, __in_b_sliced_32, __out_data_sliced_32;
	PkgSnow64SlicedData::SlicedData64 
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
	//	case (in.int_type_size)
	//	PkgSnow64Cpu::IntTypSz8:
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

	//	PkgSnow64Cpu::IntTypSz16:
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

	//	PkgSnow64Cpu::IntTypSz32:
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

	//	PkgSnow64Cpu::IntTypSz64:
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
	//	case (in.int_type_size)
	//	PkgSnow64Cpu::IntTypSz8:
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

	//	PkgSnow64Cpu::IntTypSz16:
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

	//	//PkgSnow64Cpu::IntTypSz32:
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
	//	case (in.int_type_size)
	//	PkgSnow64Cpu::IntTypSz8:
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

	//	//PkgSnow64Cpu::IntTypSz16:
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
	//	case (in.int_type_size)
	//	PkgSnow64Cpu::IntTypSz8:
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

	//	//PkgSnow64Cpu::IntTypSz16:
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
	// just 64-bit bit vectors, and so every "in.int_type_size" value will
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
		case (in.int_type_size)
		PkgSnow64Cpu::IntTypSz8:
		begin
			out.data = __out_data_sliced_8;
		end

		PkgSnow64Cpu::IntTypSz16:
		begin
			out.data = __out_data_sliced_16;
		end

		PkgSnow64Cpu::IntTypSz32:
		begin
			out.data = __out_data_sliced_32;
		end

		PkgSnow64Cpu::IntTypSz64:
		begin
			out.data = __out_data_sliced_64;
		end
		endcase
	end


endmodule
































		// src__slash__snow64_cpu_defines_header_sv

















































































































		// src__slash__snow64_lar_file_defines_header_sv


module Snow64Cpu(input logic clk,
	input PkgSnow64Cpu::PortIn_Cpu in,
	output PkgSnow64Cpu::PortOut_Cpu out);

	//PkgSnow64Cpu::Test __out_test;

	//assign out.test = __out_test;


endmodule








































































		// src__slash__snow64_bfloat16_defines_header_sv


// The "slt" instruction should *definitely* actually always be
// single-cycle.
// To keep from changing the test bench, this module TEMPORARILY has an
// interface that the test bench knows about.  That will change later!
module Snow64BFloat16Slt(input logic clk,
	input PkgSnow64BFloat16::PortIn_BinOp in,
	output PkgSnow64BFloat16::PortOut_BinOp out);

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

	initial
	begin
		out.data_valid = 0;
		out.can_accept_cmd = 1;
		out.data = 0;
	end

	//// Combinational logic
	//always @(*)
	always_ff @(posedge clk)
	begin
		if (in.start)
		begin
			case ({__in_a.sign, __in_b.sign})
			2'b00:
			begin
				// Equal signs, both non-negative
				out.data <= (__in_a_no_sign < __in_b_no_sign);
			end

			2'b01:
			begin
				out.data <= 0;
			end

			2'b10:
			begin
				// The only time opposite signs allows "<" to return false
				// is when ((__in_a == 0.0f) && (__in_b == -0.0f))
				out.data <= (!((__in_a_frac == 0) && (__in_b_frac == 0)));
			end

			2'b11:
			begin
				// Equal signs, both non-positive
				out.data <= (__in_b_no_sign < __in_a_no_sign);
			end
			endcase

			out.data_valid <= 1;
		end
	end

endmodule








































































		// src__slash__snow64_bfloat16_defines_header_sv

module Snow64BFloat16Add(input logic clk,
	input PkgSnow64BFloat16::PortIn_BinOp in,
	output PkgSnow64BFloat16::PortOut_BinOp out);



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

//module Snow64BFloat16Add(input logic clk,
//	input PkgSnow64BFloat16::PortIn_BinOp in,
//	output PkgSnow64BFloat16::PortOut_BinOp out);
//
//	__RealSnow64BFloat16Add __inst_real_bfloat16_add(.clk(clk), .in(in),
//		.out(out));
//endmodule
//
//module Snow64BFloat16Sub(input logic clk,
//	input PkgSnow64BFloat16::PortIn_BinOp in,
//	output PkgSnow64BFloat16::PortOut_BinOp out);
//
//	PkgSnow64BFloat16::PortIn_BinOp __in_bfloat16_add;
//	PkgSnow64BFloat16::BFloat16 __in_b, __in_bfloat16_add_b;
//
//	__RealSnow64BFloat16Add __inst_real_bfloat16_add(.clk(clk),
//		.in(__in_bfloat16_add), .out(out));
//
//	always @(*) __in_b = in.b;
//	always @(*) __in_bfloat16_add_b.sign = !__in_b.sign;
//	always @(*) __in_bfloat16_add_b.enc_exp = __in_b.enc_exp;
//	always @(*) __in_bfloat16_add_b.enc_mantissa = __in_b.enc_mantissa;
//
//	always @(*) __in_bfloat16_add.start = in.start;
//	always @(*) __in_bfloat16_add.a = in.a;
//	always @(*) __in_bfloat16_add.b = __in_bfloat16_add_b;
//
//endmodule








































































		// src__slash__snow64_bfloat16_defines_header_sv

module Snow64BFloat16Div(input logic clk,
	input PkgSnow64BFloat16::PortIn_BinOp in,
	output PkgSnow64BFloat16::PortOut_BinOp out);

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
			//$display("StDivAfterLongDiv");
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

//module DebugSnow64BFloat16Div(input logic clk,
//	input PkgSnow64BFloat16::PortIn_BinOp in,
//	output PkgSnow64BFloat16::PortOut_BinOp out);
//
//	Snow64BFloat16Div __inst_bfloat16_div(.clk(clk), .in(in), .out(out));
//endmodule























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

//module DebugSnow64BFloat16Fpu(input logic clk,
//	input logic in_start,
//	input logic [`MSB_POS__SNOW64_BFLOAT16_FPU_OPER:0] in_oper,
//	input logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] in_a, in_b,
//	output logic out_data_valid, out_can_accept_cmd,
//	output logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] out_data);
//
//
//	PkgSnow64BFloat16::PortIn_Fpu __in_bfloat16_fpu;
//	PkgSnow64BFloat16::PortOut_Fpu __out_bfloat16_fpu;
//
//	always @(*) __in_bfloat16_fpu.start = in_start;
//	always @(*) __in_bfloat16_fpu.oper = in_oper;
//	always @(*) __in_bfloat16_fpu.a = in_a;
//	always @(*) __in_bfloat16_fpu.b = in_b;
//
//	assign out_data_valid = __out_bfloat16_fpu.data_valid;
//	assign out_can_accept_cmd = __out_bfloat16_fpu.can_accept_cmd;
//	assign out_data = __out_bfloat16_fpu.data;
//
//	Snow64BFloat16Fpu __inst_bfloat16_fpu(.clk(clk),
//		.in(__in_bfloat16_fpu), .out(__out_bfloat16_fpu));
//endmodule


module Snow64BFloat16Fpu(input logic clk,
	input PkgSnow64BFloat16::PortIn_Fpu in,
	output PkgSnow64BFloat16::PortOut_Fpu out);

	PkgSnow64BFloat16::BFloat16 __in_b, __in_b_negated;
	assign __in_b = in.b;
	always @(*) __in_b_negated.sign = !__in_b.sign;
	always @(*) __in_b_negated.enc_exp = __in_b.enc_exp;
	always @(*) __in_b_negated.enc_mantissa = __in_b.enc_mantissa;

	logic [
	((4) - 1):0] __captured_in_oper;



	PkgSnow64BFloat16::PortIn_BinOp
		__in_submodule_add, __in_submodule_slt,
		__in_submodule_mul, __in_submodule_div;


	PkgSnow64BFloat16::PortOut_BinOp
		__out_submodule_add, __out_submodule_slt,
		__out_submodule_mul, __out_submodule_div;

	always @(*) __in_submodule_add.start = __temp_out_can_accept_cmd
		&& in.start && ((in.oper == PkgSnow64BFloat16::OpAdd)
		|| (in.oper == PkgSnow64BFloat16::OpSub)
		|| (in.oper == PkgSnow64BFloat16::OpAddAgain));

	always @(*) __in_submodule_slt.start = __temp_out_can_accept_cmd
		&& in.start && (in.oper == PkgSnow64BFloat16::OpSlt);

	always @(*) __in_submodule_mul.start = __temp_out_can_accept_cmd
		&& in.start && (in.oper == PkgSnow64BFloat16::OpMul);

	always @(*) __in_submodule_div.start = __temp_out_can_accept_cmd
		&& in.start && (in.oper == PkgSnow64BFloat16::OpDiv);

	always @(*) __in_submodule_add.a = in.a;
	always @(*) __in_submodule_slt.a = in.a;
	always @(*) __in_submodule_mul.a = in.a;
	always @(*) __in_submodule_div.a = in.a;

	always @(*)
	begin
		if (in.oper == PkgSnow64BFloat16::OpSub)
		begin
			__in_submodule_add.b = __in_b_negated;
		end

		else // if (in.oper != PkgSnow64BFloat16::OpSub)
		begin
			__in_submodule_add.b = in.b;
		end
	end
	always @(*) __in_submodule_slt.b = in.b;
	always @(*) __in_submodule_mul.b = in.b;
	always @(*) __in_submodule_div.b = in.b;

	Snow64BFloat16Add __inst_submodule_add(.clk(clk),
		.in(__in_submodule_add), .out(__out_submodule_add));
	Snow64BFloat16Slt __inst_submodule_slt(.clk(clk),
		.in(__in_submodule_slt), .out(__out_submodule_slt));
	Snow64BFloat16Mul __inst_submodule_mul(.clk(clk),
		.in(__in_submodule_mul), .out(__out_submodule_mul));
	Snow64BFloat16Div __inst_submodule_div(.clk(clk),
		.in(__in_submodule_div), .out(__out_submodule_div));

	logic __temp_out_data_valid, __temp_out_can_accept_cmd;

	initial
	begin
		__captured_in_oper = 0;
		//__temp_out_data_valid = 0;
		//__temp_out_can_accept_cmd = 1;
		out.data = 0;
	end

	//always @(*)
	always @(*) out.data_valid = __temp_out_data_valid;
	always @(*) out.can_accept_cmd = __temp_out_can_accept_cmd;
	
	assign __temp_out_data_valid
		= ((!(in.start && __temp_out_can_accept_cmd))
		&& ((__out_submodule_add.data_valid
		&& ((__captured_in_oper == PkgSnow64BFloat16::OpAdd)
		|| (__captured_in_oper == PkgSnow64BFloat16::OpSub)
		|| (__captured_in_oper == PkgSnow64BFloat16::OpAddAgain)))

		|| (__out_submodule_slt.data_valid
		&& (__captured_in_oper == PkgSnow64BFloat16::OpSlt))

		|| (__out_submodule_mul.data_valid
		&& (__captured_in_oper == PkgSnow64BFloat16::OpMul))

		|| (__out_submodule_div.data_valid
		&& (__captured_in_oper == PkgSnow64BFloat16::OpDiv))));

	assign __temp_out_can_accept_cmd
		= (__out_submodule_add.can_accept_cmd
		&& __out_submodule_slt.can_accept_cmd
		&& __out_submodule_mul.can_accept_cmd
		&& __out_submodule_div.can_accept_cmd);

	//task switch_to_wait_for_submodule;
	//	__captured_in_oper <= in.oper;
	//	__state <= StWaitForSubmodule;
	//	out.data_valid <= 0;
	//	out.can_accept_cmd <= 0;
	//endtask

	//task switch_to_idle
	//	(input logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] n_out_data);
	//	__state <= StIdle;
	//	out.data_valid <= 1;
	//	out.can_accept_cmd <= 1;
	//	out.data <= n_out_data;
	//endtask

	always @(*)
	begin
		//if (out.can_accept_cmd)
		if (__temp_out_can_accept_cmd)
		begin
			case (__captured_in_oper)
			PkgSnow64BFloat16::OpAdd:
			begin
				out.data = __out_submodule_add.data;
			end

			PkgSnow64BFloat16::OpSub:
			begin
				out.data = __out_submodule_add.data;
			end

			PkgSnow64BFloat16::OpSlt:
			begin
				out.data = __out_submodule_slt.data;
			end

			PkgSnow64BFloat16::OpMul:
			begin
				out.data = __out_submodule_mul.data;
			end

			PkgSnow64BFloat16::OpDiv:
			begin
				out.data = __out_submodule_div.data;
			end

			PkgSnow64BFloat16::OpAddAgain:
			begin
				out.data = __out_submodule_add.data;
			end

			default:
			begin
				out.data = 0;
			end
			endcase
		end

		else // if (!__temp_out_can_accept_cmd)
		begin
			out.data = 0;
		end
	end

	always_ff @(posedge clk)
	begin
		if (in.start && out.can_accept_cmd)
		begin
			__captured_in_oper <= in.oper;
		end
	end
endmodule





























































































		// src__slash__snow64_instr_cache_defines_header_sv


module Snow64InstrCache(input logic clk,
	input PkgSnow64InstrCache::PortIn_InstrCache in,
	output PkgSnow64InstrCache::PortOut_InstrCache out);

	localparam __MSB_POS__LINE_DATA
		= PkgSnow64InstrCache::MSB_POS__LINE_DATA;
	localparam __MSB_POS__LINE_PACKED_OUTER_DIM
		= PkgSnow64InstrCache::MSB_POS__LINE_PACKED_OUTER_DIM;
	localparam __MSB_POS__LINE_PACKED_INNER_DIM
		= PkgSnow64InstrCache::MSB_POS__LINE_PACKED_INNER_DIM;
	localparam __ARR_SIZE__NUM_LINES
		= PkgSnow64InstrCache::ARR_SIZE__NUM_LINES;
	localparam __LAST_INDEX__NUM_LINES
		= PkgSnow64InstrCache::LAST_INDEX__NUM_LINES;

	localparam __MSB_POS__EFFECTIVE_ADDR__ARR_INDEX
		= 
	((
	$clog2(
	((1 << 9)
	/ (256 / 8)))) - 1);
	localparam __MSB_POS__EFFECTIVE_ADDR__TAG
		= 
	((
	(64
	- 
	$clog2(
	((1 << 9)
	/ (256 / 8)))
	- 
	($clog2(
	(256
	/ 32)))
	- 
	$clog2(32 / 8))) - 1);

	localparam __WIDTH__EFFECTIVE_ADDR__LINE_INDEX
		= 
	($clog2(
	(256
	/ 32)));
	localparam __MSB_POS__EFFECTIVE_ADDR__LINE_INDEX
		= 
	((
	($clog2(
	(256
	/ 32)))) - 1);

	//localparam __MSB_POS__LINE_BYTE_INDEX
	//	= `MSB_POS__SNOW64_ICACHE_LINE_BYTE_INDEX;
	localparam __MSB_POS__EFFECTIVE_ADDR__DONT_CARE
		= 
	((
	$clog2(32 / 8)) - 1);

	PkgSnow64InstrCache::PartialPortIn_InstrCache_ReqRead
		real_in_req_read;
	assign real_in_req_read = in.req_read;


	PkgSnow64InstrCache::PartialPortIn_InstrCache_MemAccess
		real_in_mem_access;
	assign real_in_mem_access = in.mem_access;


	PkgSnow64InstrCache::PartialPortOut_InstrCache_ReqRead
		real_out_req_read;
	assign out.req_read = real_out_req_read;

	PkgSnow64InstrCache::PartialPortOut_InstrCache_MemAccess
		real_out_mem_access;
	assign out.mem_access = real_out_mem_access;


	PkgSnow64InstrCache::EffectiveAddr
		__in_req_read__effective_addr, __addr_for_miss;
	assign __in_req_read__effective_addr = real_in_req_read.addr;

	assign __addr_for_miss.tag = __in_req_read__effective_addr.tag;
	assign __addr_for_miss.arr_index
		= __in_req_read__effective_addr.arr_index;
	assign __addr_for_miss.line_index = 0;
	assign __addr_for_miss.dont_care = 0;


	// Locals (not ports)
	logic [__MSB_POS__LINE_PACKED_OUTER_DIM:0]
		[__MSB_POS__LINE_PACKED_INNER_DIM:0]
		__lines_arr[__ARR_SIZE__NUM_LINES];
	wire [__MSB_POS__LINE_PACKED_OUTER_DIM:0]
		[__MSB_POS__LINE_PACKED_INNER_DIM:0] __in_mem_access__data
		= real_in_mem_access.data;

	PkgSnow64InstrCache::Tag __tags_arr[__ARR_SIZE__NUM_LINES];
	logic __valid_flags_arr[__ARR_SIZE__NUM_LINES];

	logic __state;


	logic [__MSB_POS__EFFECTIVE_ADDR__TAG:0]
		__captured_in_req_read__effective_addr__tag;
	logic [__MSB_POS__EFFECTIVE_ADDR__ARR_INDEX:0]
		__captured_in_req_read__effective_addr__arr_index;
	logic [__MSB_POS__EFFECTIVE_ADDR__LINE_INDEX:0]
		__captured_in_req_read__effective_addr__line_index;


	
	localparam __ENUM__STATE__IDLE = PkgSnow64InstrCache::StIdle;
	localparam __ENUM__STATE__WAIT_FOR_MEM
		= PkgSnow64InstrCache::StWaitForMem;

	logic [__MSB_POS__LINE_PACKED_OUTER_DIM:0]
		[__MSB_POS__LINE_PACKED_INNER_DIM:0]
		__debug_lines_arr[__ARR_SIZE__NUM_LINES];

	PkgSnow64InstrCache::Tag __debug_tags_arr[__ARR_SIZE__NUM_LINES];
	logic __debug_valid_flags_arr[__ARR_SIZE__NUM_LINES];

	always @(posedge clk)
	begin
		integer i;
		for (i=0; i<__ARR_SIZE__NUM_LINES; i=i+1)
		begin
			__debug_lines_arr[i] <= __lines_arr[i];
			__debug_tags_arr[i] <= __tags_arr[i];
			__debug_valid_flags_arr[i] <= __valid_flags_arr[i];
		end
	end


	wire __formal__in_req_read__req = real_in_req_read.req;
	wire [((64) - 1):0] __formal__in_req_read__addr 
		= real_in_req_read.addr;

	wire __formal__in_mem_access__valid = real_in_mem_access.valid;
	wire [__MSB_POS__LINE_DATA:0] __formal__in_mem_access__data
		= real_in_mem_access.data;

	wire [__MSB_POS__EFFECTIVE_ADDR__TAG:0]
		__formal__in_req_read__effective_addr__tag
		= __in_req_read__effective_addr.tag;
	wire [__MSB_POS__EFFECTIVE_ADDR__ARR_INDEX:0]
		__formal__in_req_read__effective_addr__arr_index
		= __in_req_read__effective_addr.arr_index;
	wire [__MSB_POS__EFFECTIVE_ADDR__LINE_INDEX:0]
		__formal__in_req_read__effective_addr__line_index
		= __in_req_read__effective_addr.line_index;

	wire __formal__out_req_read__valid = real_out_req_read.valid;
	wire [((32) - 1):0] __formal__out_req_read__instr
		= real_out_req_read.instr;

	wire __formal__out_mem_access__req = real_out_mem_access.req;
	wire [((64) - 1):0] __formal__out_mem_access__addr
		= real_out_mem_access.addr;
			// FORMAL

	initial
	begin
		integer __i;

		// We start with NO valid information.
		for (__i=0; __i<__ARR_SIZE__NUM_LINES; __i=__i+1)
		begin
			__lines_arr[__i] = 0;
			__tags_arr[__i] = 0;
			__valid_flags_arr[__i] = 0;
		end

		__state = PkgSnow64InstrCache::StIdle;
		real_out_req_read = 0;
		real_out_mem_access = 0;
		__captured_in_req_read__effective_addr__tag = 0;
		__captured_in_req_read__effective_addr__arr_index = 0;
		__captured_in_req_read__effective_addr__line_index = 0;
	end

	

	

	


	

	

	


	always_ff @(posedge clk)
	begin
		case (__state)
		PkgSnow64InstrCache::StIdle:
		begin
			if (real_in_req_read.req)
			begin
				// InstrCache hit
				if ((
		__tags_arr[__in_req_read__effective_addr.arr_index]
					== __in_req_read__effective_addr.tag)
					&& 
		__valid_flags_arr[__in_req_read__effective_addr.arr_index])
				begin
					real_out_req_read.valid <= 1;

					//real_out_req_read.instr
					//	<= `CURR_CONTAINED_LINE
					//	[__in_req_read__effective_addr.line_index];
					case (__in_req_read__effective_addr.line_index)
					0:
					begin
						real_out_req_read.instr
							<= 
		__lines_arr[__in_req_read__effective_addr.arr_index][0];
					end
					1:
					begin
						real_out_req_read.instr
							<= 
		__lines_arr[__in_req_read__effective_addr.arr_index][1];
					end
					2:
					begin
						real_out_req_read.instr
							<= 
		__lines_arr[__in_req_read__effective_addr.arr_index][2];
					end
					3:
					begin
						real_out_req_read.instr
							<= 
		__lines_arr[__in_req_read__effective_addr.arr_index][3];
					end
					4:
					begin
						real_out_req_read.instr
							<= 
		__lines_arr[__in_req_read__effective_addr.arr_index][4];
					end
					5:
					begin
						real_out_req_read.instr
							<= 
		__lines_arr[__in_req_read__effective_addr.arr_index][5];
					end
					6:
					begin
						real_out_req_read.instr
							<= 
		__lines_arr[__in_req_read__effective_addr.arr_index][6];
					end
					7:
					begin
						real_out_req_read.instr
							<= 
		__lines_arr[__in_req_read__effective_addr.arr_index][7];
					end
					endcase

					real_out_mem_access.req <= 0;
				end

				// InstrCache miss
				else
				begin
					__state <= PkgSnow64InstrCache::StWaitForMem;
					real_out_req_read.valid <= 0;

					real_out_mem_access.req <= 1;
					real_out_mem_access.addr <= __addr_for_miss;

					__captured_in_req_read__effective_addr__tag
						<= __in_req_read__effective_addr.tag;
					__captured_in_req_read__effective_addr__arr_index
						<= __in_req_read__effective_addr.arr_index;
					__captured_in_req_read__effective_addr__line_index
						<= __in_req_read__effective_addr.line_index;
				end
			end

			else
			begin
				real_out_req_read.valid <= 0;
			end
		end

		PkgSnow64InstrCache::StWaitForMem:
		begin
			real_out_mem_access.req <= 0;

			if (real_in_mem_access.valid)
			begin
				__state <= PkgSnow64InstrCache::StIdle;

				
		__tags_arr[__captured_in_req_read__effective_addr__arr_index]
					<= __captured_in_req_read__effective_addr__tag;
				
		__valid_flags_arr[__captured_in_req_read__effective_addr__arr_index] <= 1;

				real_out_req_read.valid <= 1;

				//real_out_req_read.instr <= __in_mem_access__data
				//	[__captured_in_req_read__effective_addr__line_index];
				case (__captured_in_req_read__effective_addr__line_index)
				0:
				begin
					real_out_req_read.instr <= __in_mem_access__data[0];
				end
				1:
				begin
					real_out_req_read.instr <= __in_mem_access__data[1];
				end
				2:
				begin
					real_out_req_read.instr <= __in_mem_access__data[2];
				end
				3:
				begin
					real_out_req_read.instr <= __in_mem_access__data[3];
				end
				4:
				begin
					real_out_req_read.instr <= __in_mem_access__data[4];
				end
				5:
				begin
					real_out_req_read.instr <= __in_mem_access__data[5];
				end
				6:
				begin
					real_out_req_read.instr <= __in_mem_access__data[6];
				end
				7:
				begin
					real_out_req_read.instr <= __in_mem_access__data[7];
				end
				endcase
				
		__lines_arr[__captured_in_req_read__effective_addr__arr_index] <= real_in_mem_access.data;
			end
		end
		endcase
	end

	
	
	

	
	
	

endmodule








































































		// src__slash__snow64_bfloat16_defines_header_sv

module Snow64BFloat16Mul(input logic clk,
	input PkgSnow64BFloat16::PortIn_BinOp in,
	output PkgSnow64BFloat16::PortOut_BinOp out);

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

module Snow64BFloat16CastFromInt(input logic clk,
	input PkgSnow64BFloat16::PortIn_CastFromInt in,
	output PkgSnow64BFloat16::PortOut_CastFromInt out);


	enum logic
	{
		StIdle,
		StFinishing
	} __state;

	logic __temp_out_data_valid, __temp_out_can_accept_cmd;
	PkgSnow64BFloat16::BFloat16 __temp_out_data;
	logic [
	((64) - 1):0] __temp_ret_enc_exp;

	assign out.data_valid = __temp_out_data_valid;
	assign out.can_accept_cmd = __temp_out_can_accept_cmd;
	assign out.data = __temp_out_data;

	logic [
	((64) - 1):0] __width;
	logic [
	((2) - 1):0] __captured_in_type_size;

	logic [
	((64) - 1):0] __temp_abs_data;
	logic [
	((7) - 1):0] __out_clz64;

	Snow64CountLeadingZeros64 __inst_clz64(.in(__temp_abs_data),
		.out(__out_clz64));

	initial
	begin
		__state = StIdle;
		__temp_out_data_valid = 0;
		__temp_out_can_accept_cmd = 1;
		__temp_out_data = 0;
	end

	// Pseudo combinational logic
	always @(posedge clk)
	begin
		case (__state)
		StIdle:
		begin
			if (in.start)
			begin
				case (in.type_signedness)
				0:
				begin
					case (in.int_type_size)
					PkgSnow64Cpu::IntTypSz8:
					begin
						__temp_abs_data = {56'h0, in.to_cast[7:0]};
						__width = 8;
					end

					PkgSnow64Cpu::IntTypSz16:
					begin
						__temp_abs_data = {48'h0, in.to_cast[15:0]};
						__width = 16;
					end

					PkgSnow64Cpu::IntTypSz32:
					begin
						__temp_abs_data = {32'h0, in.to_cast[31:0]};
						__width = 32;
					end

					PkgSnow64Cpu::IntTypSz64:
					begin
						__temp_abs_data = in.to_cast;
						__width = 64;
					end
					endcase

					__temp_out_data.sign = 0;
				end

				1:
				begin
					case (in.int_type_size)
					PkgSnow64Cpu::IntTypSz8:
					begin
						__temp_abs_data = in.to_cast[7]
							? (-in.to_cast[7:0]) : in.to_cast[7:0];
						__width = 8;
						__temp_out_data.sign = in.to_cast[7];
					end

					PkgSnow64Cpu::IntTypSz16:
					begin
						__temp_abs_data = in.to_cast[15]
							? (-in.to_cast[15:0]) : in.to_cast[15:0];
						__width = 16;
						__temp_out_data.sign = in.to_cast[15];
					end

					PkgSnow64Cpu::IntTypSz32:
					begin
						__temp_abs_data = in.to_cast[31]
							? (-in.to_cast[31:0]) : in.to_cast[31:0];
						__width = 32;
						__temp_out_data.sign = in.to_cast[31];
					end

					PkgSnow64Cpu::IntTypSz64:
					begin
						//__temp_abs_data = in.to_cast;
						//__temp_abs_data = in.to_cast;
						__temp_abs_data = in.to_cast[63]
							? (-in.to_cast[63:0]) : in.to_cast[63:0];
						__width = 64;
						__temp_out_data.sign = in.to_cast[63];
					end
					endcase
				end
				endcase
			end
		end

		StFinishing:
		begin
			case (__captured_in_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				__temp_ret_enc_exp = 8'd127
					+ (__width - 64'h1) 
					- (__out_clz64 - (64 - 8));
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				__temp_ret_enc_exp = 8'd127
					+ (__width - 64'h1) 
					- (__out_clz64 - (64 - 16));
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				__temp_ret_enc_exp = 8'd127
					+ (__width - 64'h1) 
					- (__out_clz64 - (64 - 32));
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				__temp_ret_enc_exp = 8'd127
					+ (__width - 64'h1) 
					- __out_clz64;
			end
			endcase

			__temp_abs_data = __temp_abs_data << __out_clz64;
			__temp_abs_data = __temp_abs_data[63:56];

			if (__temp_abs_data == 0)
			begin
				{__temp_out_data.enc_exp, __temp_out_data.enc_mantissa}
					= 0;
			end
			else // if (__temp_abs_data != 0)
			begin
				//{__temp_out_data.enc_exp, __temp_out_data.enc_mantissa}
				//	= {__temp_ret_enc_exp
				//	[`MSB_POS__SNOW64_BFLOAT16_ENC_EXP:0],
				//	__temp_abs_data
				//	[`MSB_POS__SNOW64_BFLOAT16_ENC_MANTISSA:0]};
				__temp_out_data.enc_exp = __temp_ret_enc_exp;
				__temp_out_data.enc_mantissa = __temp_abs_data;
			end

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
				__state <= StFinishing;
				__temp_out_data_valid <= 0;
				__temp_out_can_accept_cmd <= 0;
				__captured_in_type_size <= in.int_type_size;
			end
		end

		StFinishing:
		begin
			__state <= StIdle;
			__temp_out_data_valid <= 1;
			__temp_out_can_accept_cmd <= 1;
		end
		endcase
	end

endmodule

module Snow64BFloat16CastToInt(input logic clk,
	input PkgSnow64BFloat16::PortIn_CastToInt in,
	output PkgSnow64BFloat16::PortOut_CastToInt out);

	localparam __WIDTH__STATE = 2;
	localparam __MSB_POS__STATE = ((__WIDTH__STATE) - 1);

	enum logic [__MSB_POS__STATE:0]
	{
		StIdle,
		StInner,
		StFinishing
	} __state;

	logic __temp_out_data_valid, __temp_out_can_accept_cmd;
	logic [
	((64) - 1):0] __temp_out_data, __temp_for_sticky;

	assign out.data_valid = __temp_out_data_valid;
	assign out.can_accept_cmd = __temp_out_can_accept_cmd;
	assign out.data = __temp_out_data;


	//logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] __captured_in_to_cast;
	PkgSnow64BFloat16::BFloat16 __curr_in_to_cast, __captured_in_to_cast;
	assign __curr_in_to_cast = in.to_cast;

	logic [
	((2) - 1):0] __captured_in_type_size;
	logic __captured_in_type_signedness;

	//logic [`MSB_POS__SNOW64_BFLOAT16_ENC_EXP:0]
	logic [
	((16) - 1):0]
		__curr_exp, __abs_curr_exp, __max_shift_amount;

	logic [
	((64) - 1):0] __width;
	logic [
	((64) - 1):0] __temp_ret_enc_exp;
	logic __sticky;

	// I treat SystemVerilog tasks a lot like I would local variable lambda
	// functions in C++.
	// In fact, "set_to_max_signed()" was a C++ local variable lambda
	// function in my BFloat16 software implementation.
	task set_to_max_signed;
		case (__captured_in_type_size)
		PkgSnow64Cpu::IntTypSz8:
		begin
			__temp_out_data = {{(64
				- 8){1'b1}}, 1'b1, 7'h0};
		end

		PkgSnow64Cpu::IntTypSz16:
		begin
			__temp_out_data = {{(64
				- 16){1'b1}}, 1'b1, 15'h0};
		end

		PkgSnow64Cpu::IntTypSz32:
		begin
			__temp_out_data = {{(64
				- 32){1'b1}}, 1'b1, 31'h0};
		end

		PkgSnow64Cpu::IntTypSz64:
		begin
			__temp_out_data = {1'b1, 63'h0};
		end
		endcase
	endtask

	task set_sticky;
		case (__captured_in_type_size)
			PkgSnow64Cpu::IntTypSz32:
			begin
				__temp_for_sticky = (~((32'h1
					<< (((__width) - 1) - {16'h0, __abs_curr_exp}))
					- 32'h1));
				__sticky = (__temp_out_data[31:0] 
					& __temp_for_sticky[31:0]) != 0;
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				__temp_for_sticky = (~((64'h1
					<< (((__width) - 1) - {48'h0, __abs_curr_exp}))
					- 64'h1));
				__sticky = (__temp_out_data[63:0] 
					& __temp_for_sticky[63:0]) != 0;
			end
		endcase
	endtask

	initial
	begin
		__state = StIdle;
		__temp_out_data_valid = 0;
		__temp_out_can_accept_cmd = 1;
		__temp_out_data = 0;
	end

	// Pseudo combinational logic
	always @(posedge clk)
	begin
		case (__state)
		StIdle:
		begin
			if (in.start)
			begin
				__temp_out_data = 
	(
	((__curr_in_to_cast.enc_exp != 8'd0)
	&& (__curr_in_to_cast.enc_exp != 8'd255))
	? {1'b1, __curr_in_to_cast.enc_mantissa}
	: {{
	(7 + 1){1'b0}}});

				//__curr_exp = `SIGN_EXTEND(`WIDTH__SNOW64_SIZE_64,
				//	`WIDTH__SNOW64_BFLOAT16_ENC_EXP,
				//	__curr_in_to_cast.enc_exp)
				//	- `SIGN_EXTEND(`WIDTH__SNOW64_SIZE_64,
				//	`WIDTH__SNOW64_BFLOAT16_ENC_EXP,
				//	`SNOW64_BFLOAT16_MODDED_BIAS);
				//__curr_exp = `SIGN_EXTEND(`WIDTH__SNOW64_SIZE_64,
				//	`WIDTH__SNOW64_BFLOAT16_ENC_EXP,
				//	__curr_in_to_cast.enc_exp)
				//	- `SNOW64_BFLOAT16_MODDED_BIAS;
				__curr_exp = __curr_in_to_cast.enc_exp
					- (8'd134);

				if (__curr_exp[
	((16) - 1)])
				begin
					__abs_curr_exp = -__curr_exp;
				end
				else
				begin
					__abs_curr_exp = __curr_exp;
				end

				case (in.int_type_size)
				PkgSnow64Cpu::IntTypSz8:
				begin
					__max_shift_amount = 
	((8) - 1);
					__width = 8;
				end

				PkgSnow64Cpu::IntTypSz16:
				begin
					__max_shift_amount = 
	((16) - 1);
					__width = 16;
				end

				PkgSnow64Cpu::IntTypSz32:
				begin
					__max_shift_amount = 
	((32) - 1);
					__width = 32;
				end

				PkgSnow64Cpu::IntTypSz64:
				begin
					__max_shift_amount = 
	((64) - 1);
					__width = 64;
				end
				endcase
			end
		end

		StInner:
		begin
			//$display("StInner stuffs:  %h\t\t%h, %h, %h",
			//	__temp_out_data, __curr_exp, __abs_curr_exp,
			//	__max_shift_amount);
			if (__curr_exp != __abs_curr_exp)
			begin
				//$display("StInner:  __curr_exp < 0");
				if (__abs_curr_exp <= __max_shift_amount)
				begin
					//$display("StInner:  %s",
					//	"__abs_curr_exp <= __max_shift_amount");
					__temp_out_data = __temp_out_data >> __abs_curr_exp;


					if ((!__captured_in_type_signedness)
						&& __captured_in_to_cast.sign)
					begin
						__temp_out_data = -__temp_out_data;
					end
				end
				else
				begin
					//$display("StInner:  %s",
					//	"__abs_curr_exp > __max_shift_amount");
					__temp_out_data = 0;
				end
			end
			else // if (__curr_exp == __abs_curr_exp)
			begin
				//$display("StInner:  __curr_exp >= 0");
				if (__abs_curr_exp <= __max_shift_amount)
				begin
					//$display("StInner:  %s",
					//	"__abs_curr_exp <= __max_shift_amount");
					//if (__abs_curr_exp == 0)
					//begin
					//	__sticky = `GET_BITS_WITH_RANGE(__temp_out_data,
					//		`WIDTH2MP(__width), 0) != 0;
					//end
					//else // if (__abs_curr_exp != 0)
					//begin
					//	__sticky = `GET_BITS_WITH_RANGE(__temp_out_data,
					//		`WIDTH2MP(__width),
					//		(`WIDTH2MP(__width) - __abs_curr_exp))
					//		!= 0;
					//end
					set_sticky();

					__temp_out_data = __temp_out_data << __abs_curr_exp;

					if ((!__captured_in_type_signedness)
						&& __captured_in_to_cast.sign)
					begin
						__temp_out_data = -__temp_out_data;
					end

					//$display("StInner last __temp_out_data:  %h",
					//	__temp_out_data);
				end

				else // if (__abs_curr_exp > __max_shift_amount)
				begin
					//$display("StInner:  %s",
					//	"__abs_curr_exp > __max_shift_amount");

					//$display("stuffs:  %h\t\t%h, %h, %h\t\t%h, %h, %h",
					//	__captured_in_type_signedness,
					//	__captured_in_type_size,
					//	__curr_exp, __width,
					//	__captured_in_to_cast.enc_exp,
					//	`SNOW64_BFLOAT16_MAX_ENC_EXP,
					//	(__captured_in_to_cast.enc_exp
					//	!= `SNOW64_BFLOAT16_MAX_ENC_EXP));

					__temp_out_data = 0;

					//if ((__captured_in_type_size >= PkgSnow64Cpu::IntTypSz32)
					//	&& (__curr_exp >= __width)
					//	&& (__captured_in_to_cast.enc_exp
					//	!= `SNOW64_BFLOAT16_MAX_ENC_EXP))
					if ((__captured_in_type_size >= PkgSnow64Cpu::IntTypSz32)
						&& ({8'h00, __curr_exp} >= __width[15:0])
						&& (__captured_in_to_cast.enc_exp
						!= 8'hff))
					begin
						if (!__captured_in_type_signedness)
						begin
							if (__captured_in_to_cast.sign
								&& (__captured_in_type_size
								== PkgSnow64Cpu::IntTypSz64))
							begin
								set_to_max_signed();
							end
						end
						else // if (__captured_in_type_signedness)
						begin
							//$display("set_to_max_signed()");
							set_to_max_signed();
						end
					end
				end
			end
		end

		StFinishing:
		begin
			// I have no idea what's up with this strange behavior,
			// but this is what I had to do to get it to properly
			// match what IEEE floats do on my x86-64 laptop.

			//$display("StFinishing:  %h", __sticky);

			if ((__curr_exp == __abs_curr_exp)
				&& (__abs_curr_exp <= __max_shift_amount)
				&& (__captured_in_type_size >= PkgSnow64Cpu::IntTypSz32)
				&& __sticky)
			begin
				if (!__captured_in_type_signedness)
				begin
					if (__captured_in_type_size == PkgSnow64Cpu::IntTypSz64)
					begin
						if (__captured_in_to_cast.sign)
						begin
							__temp_out_data = 0;

							if (__curr_exp >= 56)
							begin
								set_to_max_signed();
							end
						end

						else if (__curr_exp >= 57)
						begin
							__temp_out_data = 0;
						end
					end
				end
				else // if (__captured_in_type_signedness)
				begin
					set_to_max_signed();
				end
			end

			if (__captured_in_type_signedness
				&& __captured_in_to_cast.sign)
			begin
				__temp_out_data = -__temp_out_data;
			end

			//$display("StFinishing");

			case (__captured_in_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				//$display("Shrinking things:  %h", __temp_out_data);
				__temp_out_data = __temp_out_data[7:0];
				//$display("Shrinking things:  %h", __temp_out_data);
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				__temp_out_data = __temp_out_data[15:0];
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				__temp_out_data = __temp_out_data[31:0];
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				
			end
			endcase
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
				__state <= StInner;
				__temp_out_data_valid <= 0;
				__temp_out_can_accept_cmd <= 0;

				__captured_in_to_cast <= in.to_cast;
				__captured_in_type_size <= in.int_type_size;
				__captured_in_type_signedness <= in.type_signedness;
			end
		end

		StInner:
		begin
			__state <= StFinishing;
		end

		StFinishing:
		begin
			__state <= StIdle;
			__temp_out_data_valid <= 1;
			__temp_out_can_accept_cmd <= 1;
		end
		endcase
	end

endmodule


//module DebugSnow64BFloat16CastFromInt(input logic clk,
//	input logic in_start,
//	input logic [`MSB_POS__SNOW64_SIZE_64:0] in_to_cast,
//	input logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] in_type_size,
//	input logic in_type_signedness,
//	output logic out_data_valid, out_can_accept_cmd,
//	output logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] out_data);
//
//	PkgSnow64BFloat16::PortIn_CastFromInt __in_cast_from_int;
//	PkgSnow64BFloat16::PortOut_CastFromInt __out_cast_from_int;
//
//	Snow64BFloat16CastFromInt __inst_cast_from_int(.clk(clk),
//		.in(__in_cast_from_int), .out(__out_cast_from_int));
//
//
//	always @(*) __in_cast_from_int.start = in_start;
//	always @(*) __in_cast_from_int.to_cast = in_to_cast;
//	always @(*) __in_cast_from_int.int_type_size = in_type_size;
//	always @(*) __in_cast_from_int.type_signedness = in_type_signedness;
//
//	assign out_data_valid = __out_cast_from_int.data_valid;
//	assign out_can_accept_cmd = __out_cast_from_int.can_accept_cmd;
//	assign out_data = __out_cast_from_int.data;
//
//endmodule
//
//
//module DebugSnow64BFloat16CastToInt(input logic clk,
//	input logic in_start,
//	input logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] in_to_cast,
//	input logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] in_type_size,
//	input logic in_type_signedness,
//	output logic out_data_valid, out_can_accept_cmd,
//	output logic [`MSB_POS__SNOW64_SIZE_64:0] out_data);
//
//	PkgSnow64BFloat16::PortIn_CastToInt __in_cast_to_int;
//	PkgSnow64BFloat16::PortOut_CastToInt __out_cast_to_int;
//
//	Snow64BFloat16CastToInt __inst_cast_to_int(.clk(clk),
//		.in(__in_cast_to_int), .out(__out_cast_to_int));
//
//
//	always @(*) __in_cast_to_int.start = in_start;
//	always @(*) __in_cast_to_int.to_cast = in_to_cast;
//	always @(*) __in_cast_to_int.int_type_size = in_type_size;
//	always @(*) __in_cast_to_int.type_signedness = in_type_signedness;
//
//	assign out_data_valid = __out_cast_to_int.data_valid;
//	assign out_can_accept_cmd = __out_cast_to_int.can_accept_cmd;
//	assign out_data = __out_cast_to_int.data;
//
//endmodule














		// src__slash__snow64_memory_bus_guard_defines_header_sv
































		// src__slash__snow64_cpu_defines_header_sv

















































































































		// src__slash__snow64_lar_file_defines_header_sv


module Snow64MemoryBusGuard(input logic clk,
	input PkgSnow64MemoryBusGuard::PortIn_MemoryBusGuard in,
	output PkgSnow64MemoryBusGuard::PortOut_MemoryBusGuard out);

	import PkgSnow64MemoryBusGuard::CpuAddr;
	import PkgSnow64MemoryBusGuard::LarData;

	typedef logic [
	((2) - 1):0]
		RequestType;

	logic [
	((2) - 1):0]
		__stage_0_to_1__req_type, __stage_1_to_2__req_type;


	
	localparam __ENUM__REQUEST_TYPE__NONE
		= PkgSnow64MemoryBusGuard::ReqTypNone;
	localparam __ENUM__REQUEST_TYPE__READ_INSTR
		= PkgSnow64MemoryBusGuard::ReqTypReadInstr;
	localparam __ENUM__REQUEST_TYPE__READ_DATA
		= PkgSnow64MemoryBusGuard::ReqTypReadData;
	localparam __ENUM__REQUEST_TYPE__WRITE_DATA
		= PkgSnow64MemoryBusGuard::ReqTypWriteData;

	localparam __ENUM__MEM_ACCESS_TYPE__READ
		= PkgSnow64MemoryBusGuard::MemAccTypRead;
	localparam __ENUM__MEM_ACCESS_TYPE__WRITE
		= PkgSnow64MemoryBusGuard::MemAccTypWrite;
	

	PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_ReqRead
		real_in_req_read_instr, real_in_req_read_data;
	assign real_in_req_read_instr = in.req_read_instr;
	assign real_in_req_read_data = in.req_read_data;


	PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_ReqWrite
		real_in_req_write_data;
	assign real_in_req_write_data = in.req_write_data;


	PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_MemAccess
		real_in_mem_access;
	assign real_in_mem_access = in.mem_access;



	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_ReqRead
		real_out_req_read_instr, real_out_req_read_data;
	assign out.req_read_instr = real_out_req_read_instr;
	assign out.req_read_data = real_out_req_read_data;




	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_ReqWrite
		real_out_req_write_data;
	assign out.req_write_data = real_out_req_write_data;




	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_MemAccess
		real_out_mem_access;
	assign out.mem_access = real_out_mem_access;





	
	wire __formal__in_req_read_instr__req
		= real_in_req_read_instr.req;
	wire [((64) - 1):0] __formal__in_req_read_instr__addr
		= real_in_req_read_instr.addr;

	wire __formal__in_req_read_data__req
		= real_in_req_read_data.req;
	wire [((64) - 1):0] __formal__in_req_read_data__addr
		= real_in_req_read_data.addr;


	wire __formal__in_req_write_data__req = real_in_req_write_data.req;
	wire [((64) - 1):0] __formal__in_req_write_data__addr
		= real_in_req_write_data.addr;
	wire [
	((256) - 1):0]
		__formal__in_req_write_data__data
		= real_in_req_write_data.data;


	wire __formal__in_mem_access__valid = real_in_mem_access.valid;

	wire [
	((256) - 1):0]
		__formal__in_mem_access__data
		= real_in_mem_access.data;


	wire __formal__out_req_read_instr__valid
		= real_out_req_read_instr.valid;
	wire __formal__out_req_read_instr__cmd_accepted
		= real_out_req_read_instr.cmd_accepted;
	wire [
	((256) - 1):0]
		__formal__out_req_read_instr__data = real_out_req_read_instr.data;

	wire __formal__out_req_read_data__valid = real_out_req_read_data.valid;
	wire __formal__out_req_read_data__cmd_accepted
		= real_out_req_read_data.cmd_accepted;
	wire [
	((256) - 1):0]
		__formal__out_req_read_data__data = real_out_req_read_data.data;


	wire __formal__out_req_write_data__valid
		= real_out_req_write_data.valid;
	wire __formal__out_req_write_data__cmd_accepted
		= real_out_req_write_data.cmd_accepted;


	wire __formal__out_mem_access__req = real_out_mem_access.req;
	wire [((64) - 1):0] __formal__out_mem_access__addr
		= real_out_mem_access.addr;
	wire [
	((256) - 1):0] __formal__out_mem_access__data
		= real_out_mem_access.data;
	wire __formal__out_mem_access__mem_acc_type
		= real_out_mem_access.mem_acc_type;
			// FORMAL

	// Basically the "global valid signal" method of stalling.
	// This is used for simplicity, and because this pipeline will never
	// stall when we are interfacing with purely synchronous block RAM that
	// has the same clock rate as us.
	wire __stall = ((__stage_1_to_2__req_type
		!= PkgSnow64MemoryBusGuard::ReqTypNone)
		&& (!real_in_mem_access.valid));

	initial
	begin
		{__stage_0_to_1__req_type, __stage_1_to_2__req_type} = 0;

		{real_out_req_read_instr.valid, real_out_req_read_data.valid} = 0;
		{real_out_req_read_instr.cmd_accepted,
			real_out_req_read_data.cmd_accepted} = 0;
		{real_out_req_read_instr.data, real_out_req_read_data.data} = 0;
		real_out_req_write_data.valid = 0;
		real_out_req_write_data.cmd_accepted = 0;
		{real_out_mem_access.req, real_out_mem_access.addr,
			real_out_mem_access.data} = 0;

		real_out_mem_access.mem_acc_type
			= PkgSnow64MemoryBusGuard::MemAccTypRead;
	end


	task stop_mem_access;
		real_out_mem_access.req <= 0;
	endtask : stop_mem_access

	task prep_mem_read(input CpuAddr addr);
		real_out_mem_access.req <= 1;
		real_out_mem_access.addr <= addr;
		real_out_mem_access.mem_acc_type
			<= PkgSnow64MemoryBusGuard::MemAccTypRead;
	endtask : prep_mem_read

	task prep_mem_write;
		real_out_mem_access.req <= 1;
		real_out_mem_access.addr <= real_in_req_write_data.addr;
		real_out_mem_access.mem_acc_type
			<= PkgSnow64MemoryBusGuard::MemAccTypWrite;
		real_out_mem_access.data <= real_in_req_write_data.data;
	endtask : prep_mem_write


	// Stage 0:  Accept a request, drive memory bus.
	always @(posedge clk)
	begin
		// If we're stalling, that means we can't drive the memory bus, and
		// therefore we have nothing to send down the pipe to later stages.
		if (!__stall)
		begin
			// Instruction reader thing requested a block of instructions.
			if (real_in_req_read_instr.req)
			begin
				__stage_0_to_1__req_type
					<= PkgSnow64MemoryBusGuard::ReqTypReadInstr;
				prep_mem_read(real_in_req_read_instr.addr);

				real_out_req_read_instr.cmd_accepted <= 1;
				real_out_req_read_data.cmd_accepted <= 0;
				real_out_req_write_data.cmd_accepted <= 0;
			end

			// LAR file wants to read data.
			else if (real_in_req_read_data.req)
			begin
				__stage_0_to_1__req_type
					<= PkgSnow64MemoryBusGuard::ReqTypReadData;
				prep_mem_read(real_in_req_read_data.addr);

				real_out_req_read_instr.cmd_accepted <= 0;
				real_out_req_read_data.cmd_accepted <= 1;
				real_out_req_write_data.cmd_accepted <= 0;
			end

			// LAR file wants to write data.
			else if (real_in_req_write_data.req)
			begin
				__stage_0_to_1__req_type
					<= PkgSnow64MemoryBusGuard::ReqTypWriteData;
				prep_mem_write();

				real_out_req_read_instr.cmd_accepted <= 0;
				real_out_req_read_data.cmd_accepted <= 0;
				real_out_req_write_data.cmd_accepted <= 1;
			end

			else
			begin
				__stage_0_to_1__req_type
					<= PkgSnow64MemoryBusGuard::ReqTypNone;
				stop_mem_access();

				real_out_req_read_instr.cmd_accepted <= 0;
				real_out_req_read_data.cmd_accepted <= 0;
				real_out_req_write_data.cmd_accepted <= 0;
			end
		end

		else // if (__stall)
		begin
			stop_mem_access();

			real_out_req_read_instr.cmd_accepted <= 0;
			real_out_req_read_data.cmd_accepted <= 0;
			real_out_req_write_data.cmd_accepted <= 0;
		end
	end

	// Stage 1:  Idle while the memory (or memory controller, as the case
	// may be) sees our request and synchronously drives its own outputs.
	always_ff @(posedge clk)
	begin
		if (!__stall)
		begin
			__stage_1_to_2__req_type <= __stage_0_to_1__req_type;
		end
	end

	// Stage 2:  Let requester know that stuff is done.
	// Here, it's possible
	always_ff @(posedge clk)
	begin
		if (!__stall)
		begin
			case (__stage_1_to_2__req_type)
			PkgSnow64MemoryBusGuard::ReqTypReadInstr:
			begin
				real_out_req_read_instr.valid <= 1;
				real_out_req_read_data.valid <= 0;
				real_out_req_write_data.valid <= 0;

				real_out_req_read_instr.data <= real_in_mem_access.data;
			end

			PkgSnow64MemoryBusGuard::ReqTypReadData:
			begin
				real_out_req_read_instr.valid <= 0;
				real_out_req_read_data.valid <= 1;
				real_out_req_write_data.valid <= 0;

				real_out_req_read_data.data <= real_in_mem_access.data;
			end

			PkgSnow64MemoryBusGuard::ReqTypWriteData:
			begin
				real_out_req_read_instr.valid <= 0;
				real_out_req_read_data.valid <= 0;
				real_out_req_write_data.valid <= 1;
			end

			default:
			begin
				real_out_req_read_instr.valid <= 0;
				real_out_req_read_data.valid <= 0;
				real_out_req_write_data.valid <= 0;
			end
			endcase
		end

		else // if (__stall)
		begin
			real_out_req_read_instr.valid <= 0;
			real_out_req_read_data.valid <= 0;
			real_out_req_write_data.valid <= 0;
		end
	end

endmodule

















































































































		// src__slash__snow64_lar_file_defines_header_sv

//// For when we're done formally verifying the LAR file itself.
//// As of this writing, formal verification is totally done.
//`ifdef FORMAL
//`undef FORMAL
//`endif		// FORMAL





module Snow64LarFile(input logic clk,
	input PkgSnow64LarFile::PortIn_LarFile in,
	output PkgSnow64LarFile::PortOut_LarFile out);


	PkgSnow64LarFile::PartialPortIn_LarFile_Ctrl real_in_ctrl;
	PkgSnow64LarFile::PartialPortIn_LarFile_Read 
		real_in_rd_a, real_in_rd_b, real_in_rd_c;
	PkgSnow64LarFile::PartialPortIn_LarFile_Write real_in_wr;
	PkgSnow64LarFile::PartialPortIn_LarFile_MemRead real_in_mem_read;
	PkgSnow64LarFile::PartialPortIn_LarFile_MemWrite real_in_mem_write;

	PkgSnow64LarFile::PartialPortOut_LarFile_Read
		real_out_rd_a, real_out_rd_b, real_out_rd_c;
	PkgSnow64LarFile::PartialPortOut_LarFile_MemRead real_out_mem_read;
	PkgSnow64LarFile::PartialPortOut_LarFile_MemWrite
		real_out_mem_write;
	PkgSnow64LarFile::PartialPortOut_LarFile_WaitForMe
		real_out_wait_for_me;

	assign real_in_ctrl = in.ctrl;
	assign real_in_rd_a = in.rd_a;
	assign real_in_rd_b = in.rd_b;
	assign real_in_rd_c = in.rd_c;
	assign real_in_wr = in.wr;
	assign real_in_mem_read = in.mem_read;
	assign real_in_mem_write = in.mem_write;


	assign out.rd_a = real_out_rd_a;
	assign out.rd_b = real_out_rd_b;
	assign out.rd_c = real_out_rd_c;
	assign out.mem_read = real_out_mem_read;
	assign out.mem_write = real_out_mem_write;
	assign out.wait_for_me = real_out_wait_for_me;



	import PkgSnow64Cpu::CpuAddr;
	import PkgSnow64LarFile::LarIndex;
	import PkgSnow64LarFile::LarAddrBasePtr8;
	import PkgSnow64LarFile::LarAddrOffset8;
	import PkgSnow64LarFile::LarAddrBasePtr16;
	import PkgSnow64LarFile::LarAddrOffset16;
	import PkgSnow64LarFile::LarAddrBasePtr32;
	import PkgSnow64LarFile::LarAddrOffset32;
	import PkgSnow64LarFile::LarAddrBasePtr64;
	import PkgSnow64LarFile::LarAddrOffset64;
	import PkgSnow64LarFile::LarTag;
	import PkgSnow64LarFile::LarData;
	import PkgSnow64LarFile::LarBaseAddr;
	import PkgSnow64LarFile::LarRefCount;
	import PkgSnow64LarFile::LarDirty;

	



 // if defined(FORMAL)
		
		// Verify the LAR file when there are only Four LARs 
		localparam __ARR_SIZE__NUM_LARS = 4;
		


		// SMALL_LAR_FILE
		localparam __LAST_INDEX__NUM_LARS
			= ((__ARR_SIZE__NUM_LARS) - 1);
	 // FORMAL


	
	// Mostly ALU/FPU operations.
	localparam __ENUM__WRITE_TYPE__ONLY_DATA 
		= PkgSnow64LarFile::WriteTypOnlyData;

	// Used for port-mapped input instructions
	localparam __ENUM__WRITE_TYPE__DATA_AND_TYPE
		= PkgSnow64LarFile::WriteTypDataAndType;

	// Used for load and store instructions.
	localparam __ENUM__WRITE_TYPE__LD = PkgSnow64LarFile::WriteTypLd;
	localparam __ENUM__WRITE_TYPE__ST = PkgSnow64LarFile::WriteTypSt;

	localparam __ENUM__WRITE_STATE__IDLE
		= PkgSnow64LarFile::WrStIdle;
	localparam __ENUM__WRITE_STATE__START_LD_ST
		= PkgSnow64LarFile::WrStStartLdSt;
	localparam __ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_READ
		= PkgSnow64LarFile::WrStWaitForJustMemRead;
	localparam __ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_WRITE
		= PkgSnow64LarFile::WrStWaitForJustMemWrite;

	localparam __ENUM__WRITE_STATE__WAIT_FOR_MEM_READ_AND_MEM_WRITE
		= PkgSnow64LarFile::WrStWaitForMemReadAndMemWrite;
	localparam __ENUM__WRITE_STATE__BAD_0
		= PkgSnow64LarFile::WrStBad0;
	localparam __ENUM__WRITE_STATE__BAD_1
		= PkgSnow64LarFile::WrStBad1;
	localparam __ENUM__WRITE_STATE__BAD_2
		= PkgSnow64LarFile::WrStBad2;

	localparam __ENUM__DATA_TYPE__UNSGN_INT
		= PkgSnow64Cpu::DataTypUnsgnInt;
	localparam __ENUM__DATA_TYPE__SGN_INT
		= PkgSnow64Cpu::DataTypSgnInt;
	localparam __ENUM__DATA_TYPE__BFLOAT16
		= PkgSnow64Cpu::DataTypBFloat16;
	localparam __ENUM__DATA_TYPE__RESERVED
		= PkgSnow64Cpu::DataTypReserved;

	localparam __ENUM__INT_TYPE_SIZE__8 = PkgSnow64Cpu::IntTypSz8;
	localparam __ENUM__INT_TYPE_SIZE__16 = PkgSnow64Cpu::IntTypSz16;
	localparam __ENUM__INT_TYPE_SIZE__32 = PkgSnow64Cpu::IntTypSz32;
	localparam __ENUM__INT_TYPE_SIZE__64 = PkgSnow64Cpu::IntTypSz64;
			// FORMAL

	localparam __UNALLOCATED_TAG = 0;

	logic [
	((3) - 1):0] __wr_state;



	// These are used mainly because Icarus Verilog does not, at the time
	// of this writing, support creating an array of packed structs.
	//
	// The other reason for these is that they will make it easier for me
	// to formally verify this module, as I have to convert this module to
	// Verilog first before I can formally verify it.

	// Metadata fields
	localparam __METADATA__DATA_INDEX__INDEX_LO = 0;
	localparam __METADATA__DATA_INDEX__INDEX_HI
		= 

	((__METADATA__DATA_INDEX__INDEX_LO) + (((5) - 1)));

	localparam __METADATA__TAG__INDEX_LO
		= 
	((__METADATA__DATA_INDEX__INDEX_HI) + 1);
	localparam __METADATA__TAG__INDEX_HI
		= 

	((__METADATA__TAG__INDEX_LO) + (((4) - 1)));

	localparam __METADATA__DATA_TYPE__INDEX_LO
		= 
	((__METADATA__TAG__INDEX_HI) + 1);
	localparam __METADATA__DATA_TYPE__INDEX_HI
		= 

	((__METADATA__DATA_TYPE__INDEX_LO) + (((2) - 1)));

	localparam __METADATA__INT_TYPE_SIZE__INDEX_LO
		= 
	((__METADATA__DATA_TYPE__INDEX_HI) + 1);
	localparam __METADATA__INT_TYPE_SIZE__INDEX_HI
		= 

	((__METADATA__INT_TYPE_SIZE__INDEX_LO) + (((2) - 1)));




	// Shared data fields
	localparam __SHAREDDATA__BASE_ADDR__INDEX_LO = 0;
	localparam __SHAREDDATA__BASE_ADDR__INDEX_HI
		= 

	((__SHAREDDATA__BASE_ADDR__INDEX_LO) + (((
	
	(64 - 5)) - 1)));

	localparam __SHAREDDATA__DATA__INDEX_LO
		= 
	((__SHAREDDATA__BASE_ADDR__INDEX_HI) + 1);
	localparam __SHAREDDATA__DATA__INDEX_HI
		= 

	((__SHAREDDATA__DATA__INDEX_LO) + (((256) - 1)));

	localparam __SHAREDDATA__REF_COUNT__INDEX_LO
		= 
	((__SHAREDDATA__DATA__INDEX_HI) + 1);
	localparam __SHAREDDATA__REF_COUNT__INDEX_HI
		= 

	((__SHAREDDATA__REF_COUNT__INDEX_LO) + (((
	4) - 1)));

	localparam __SHAREDDATA__DIRTY__INDEX_LO
		= 
	((__SHAREDDATA__REF_COUNT__INDEX_HI) + 1);
	localparam __SHAREDDATA__DIRTY__INDEX_HI
		= 

	((__SHAREDDATA__DIRTY__INDEX_LO) + (((1) - 1)));



	localparam __MSB_POS__METADATA__DATA_INDEX
		= __METADATA__DATA_INDEX__INDEX_HI
		- __METADATA__DATA_INDEX__INDEX_LO;
	localparam __WIDTH__METADATA__DATA_INDEX
		= ((__MSB_POS__METADATA__DATA_INDEX) + 1);

	localparam __MSB_POS__METADATA__TAG
		= (($clog2(__ARR_SIZE__NUM_LARS)) - 1);
	localparam __WIDTH__METADATA__TAG
		= ((__MSB_POS__METADATA__TAG) + 1);

	localparam __MSB_POS__METADATA__DATA_TYPE
		= __METADATA__DATA_TYPE__INDEX_HI
		- __METADATA__DATA_TYPE__INDEX_LO;
	localparam __WIDTH__METADATA__DATA_TYPE
		= ((__MSB_POS__METADATA__DATA_TYPE) + 1);

	localparam __MSB_POS__METADATA__INT_TYPE_SIZE
		= __METADATA__INT_TYPE_SIZE__INDEX_HI
		- __METADATA__INT_TYPE_SIZE__INDEX_LO;
	localparam __WIDTH__METADATA__INT_TYPE_SIZE
		= ((__MSB_POS__METADATA__INT_TYPE_SIZE) + 1);

	localparam __MSB_POS__SHAREDDATA__BASE_ADDR
		= __SHAREDDATA__BASE_ADDR__INDEX_HI
		- __SHAREDDATA__BASE_ADDR__INDEX_LO;
	localparam __WIDTH__SHAREDDATA__BASE_ADDR
		= ((__MSB_POS__SHAREDDATA__BASE_ADDR) + 1);

	localparam __MSB_POS__SHAREDDATA__DATA
		= __SHAREDDATA__DATA__INDEX_HI
		- __SHAREDDATA__DATA__INDEX_LO;
	localparam __WIDTH__SHAREDDATA__DATA
		= ((__MSB_POS__SHAREDDATA__DATA) + 1);

	localparam __MSB_POS__SHAREDDATA__REF_COUNT
		= __MSB_POS__METADATA__TAG;
	localparam __WIDTH__SHAREDDATA__REF_COUNT
		= ((__MSB_POS__SHAREDDATA__REF_COUNT) + 1);

	localparam __MSB_POS__SHAREDDATA__DIRTY
		= __SHAREDDATA__DIRTY__INDEX_HI
		- __SHAREDDATA__DIRTY__INDEX_LO;
	localparam __WIDTH__SHAREDDATA__DIRTY
		= ((__MSB_POS__SHAREDDATA__DIRTY) + 1);


	logic [
	((2) - 1):0]
		__captured_in_wr__write_type;
	// The index of the LAR we want to read data into.
	logic [__MSB_POS__METADATA__TAG:0] __captured_in_wr__index;
	// Incoming base_addr to be written to a LAR
	PkgSnow64LarFile::LarIncomingBaseAddr
		__captured_in_wr__base_addr,
		__in_wr__incoming_base_addr;
	assign __in_wr__incoming_base_addr = real_in_wr.addr;

	logic [
	((2) - 1):0] __captured_in_wr__data_type;
	logic [
	((2) - 1):0]
		__captured_in_wr__int_type_size;

	// For when we're both reading from and writing to memory
	logic __captured_in_mem_read__valid, __captured_in_mem_write__valid;


	wire [__MSB_POS__METADATA__TAG:0] __in_wr__index
		= real_in_wr.index[__MSB_POS__METADATA__TAG:0];

	
	//wire __formal__in_ctrl__mem_bus_guard_instr_load_busy
	//	= real_in_ctrl.mem_bus_guard_instr_load_busy;
	wire __formal__in_ctrl__mem_bus_guard_busy 
		= real_in_ctrl.mem_bus_guard_busy;

	wire [__MSB_POS__METADATA__TAG:0] 
		__formal__in_rd_a__index
		= real_in_rd_a.index[__MSB_POS__METADATA__TAG:0],
		__formal__in_rd_b__index
		= real_in_rd_b.index[__MSB_POS__METADATA__TAG:0],
		__formal__in_rd_c__index
		= real_in_rd_c.index[__MSB_POS__METADATA__TAG:0];

	wire __formal__in_wr__req = real_in_wr.req;
	wire [
	((2) - 1):0]
		__formal__in_wr__write_type = real_in_wr.write_type;

	wire [__MSB_POS__METADATA__TAG:0] __formal__in_wr__index
		= __in_wr__index;

	wire [
	((256) - 1):0]
		__formal__in_wr__data = real_in_wr.data;
	wire [((64) - 1):0]
		__formal__in_wr__addr = real_in_wr.addr;
	wire [
	((2) - 1):0]
		__formal__in_wr__data_type = real_in_wr.data_type;
	wire [
	((2) - 1):0]
		__formal__in_wr__int_type_size = real_in_wr.int_type_size;


	wire __formal__in_mem_read__valid = real_in_mem_read.valid;
	wire __formal__in_mem_read__busy = real_in_mem_read.busy;
	wire [
	((256) - 1):0]
		__formal__in_mem_read__data = real_in_mem_read.data;

	wire __formal__in_mem_write__valid = real_in_mem_write.valid;
	wire __formal__in_mem_write__busy = real_in_mem_write.busy;



	wire [
	((256) - 1):0] 
		__formal__out_rd_a__data = real_out_rd_a.data;
	wire [
	((256) - 1):0] 
		__formal__out_rd_b__data = real_out_rd_b.data;
	wire [
	((256) - 1):0] 
		__formal__out_rd_c__data = real_out_rd_c.data;

	wire [((64) - 1):0]
		__formal__out_rd_a__addr = real_out_rd_a.addr;
	wire [((64) - 1):0]
		__formal__out_rd_b__addr = real_out_rd_b.addr;
	wire [((64) - 1):0]
		__formal__out_rd_c__addr = real_out_rd_c.addr;

	wire [
	((4) - 1):0]
		__formal__out_rd_a__tag = real_out_rd_a.tag;
	wire [
	((4) - 1):0]
		__formal__out_rd_b__tag = real_out_rd_b.tag;
	wire [
	((4) - 1):0]
		__formal__out_rd_c__tag = real_out_rd_c.tag;

	wire [
	((2) - 1):0]
		__formal__out_rd_a__data_type = real_out_rd_a.data_type;
	wire [
	((2) - 1):0]
		__formal__out_rd_b__data_type = real_out_rd_b.data_type;
	wire [
	((2) - 1):0]
		__formal__out_rd_c__data_type = real_out_rd_c.data_type;

	wire [
	((2) - 1):0]
		__formal__out_rd_a__int_type_size = real_out_rd_a.int_type_size;
	wire [
	((2) - 1):0]
		__formal__out_rd_b__int_type_size = real_out_rd_b.int_type_size;
	wire [
	((2) - 1):0]
		__formal__out_rd_c__int_type_size = real_out_rd_c.int_type_size;

	wire __formal__out_mem_read__req = real_out_mem_read.req;

	wire [
	((
	
	(64 - 5)) - 1):0]
		__formal__out_mem_read__base_addr = real_out_mem_read.base_addr;

	wire __formal__out_mem_write__req = real_out_mem_write.req;

	wire [
	((256) - 1):0] __formal__out_mem_write__data
		= real_out_mem_write.data;

	wire [
	((
	
	(64 - 5)) - 1):0]
		__formal__out_mem_write__base_addr
		= real_out_mem_write.base_addr;

	wire __formal__out_wait_for_me__busy = real_out_wait_for_me.busy;
			// FORMAL

	assign real_out_wait_for_me.busy
		= (__wr_state != PkgSnow64LarFile::WrStIdle);


	// The arrays of LAR metadata and shared data.
	logic [__MSB_POS__METADATA__DATA_INDEX : 0]
		__lar_metadata__data_index[__ARR_SIZE__NUM_LARS];
	
	logic [__MSB_POS__METADATA__DATA_INDEX : 0]
		__debug_lar_metadata__data_index[__ARR_SIZE__NUM_LARS];
			// FORMAL

	logic [__MSB_POS__METADATA__TAG : 0]
		__lar_metadata__tag[__ARR_SIZE__NUM_LARS];
	
	logic [__MSB_POS__METADATA__TAG : 0]
		__debug_lar_metadata__tag[__ARR_SIZE__NUM_LARS];
			// FORMAL

	logic [__MSB_POS__METADATA__DATA_TYPE : 0]
		__lar_metadata__data_type[__ARR_SIZE__NUM_LARS];
	
	logic [__MSB_POS__METADATA__DATA_TYPE : 0]
		__debug_lar_metadata__data_type[__ARR_SIZE__NUM_LARS];
			// FORMAL

	logic [__MSB_POS__METADATA__INT_TYPE_SIZE : 0]
		__lar_metadata__int_type_size[__ARR_SIZE__NUM_LARS];
	
	logic [__MSB_POS__METADATA__INT_TYPE_SIZE : 0]
		__debug_lar_metadata__int_type_size[__ARR_SIZE__NUM_LARS];
			// FORMAL


	//logic [__MSB_POS__SHAREDDATA:0] __lar_shareddata
	//	[__ARR_SIZE__NUM_LARS];
	logic [__MSB_POS__SHAREDDATA__BASE_ADDR : 0]
		__lar_shareddata__base_addr[__ARR_SIZE__NUM_LARS];
	
	logic [__MSB_POS__SHAREDDATA__BASE_ADDR : 0]
		__debug_lar_shareddata__base_addr[__ARR_SIZE__NUM_LARS];
			// FORMAL

	logic [__MSB_POS__SHAREDDATA__DATA : 0]
		__lar_shareddata__data[__ARR_SIZE__NUM_LARS];
	
	logic [__MSB_POS__SHAREDDATA__DATA : 0]
		__debug_lar_shareddata__data[__ARR_SIZE__NUM_LARS];
			// FORMAL

	logic [__MSB_POS__SHAREDDATA__REF_COUNT : 0]
		__lar_shareddata__ref_count[__ARR_SIZE__NUM_LARS];
	
	logic [__MSB_POS__SHAREDDATA__REF_COUNT : 0]
		__debug_lar_shareddata__ref_count[__ARR_SIZE__NUM_LARS];
			// FORMAL

	logic [__MSB_POS__SHAREDDATA__DIRTY : 0]
		__lar_shareddata__dirty[__ARR_SIZE__NUM_LARS];
	
	logic [__MSB_POS__SHAREDDATA__DIRTY : 0]
		__debug_lar_shareddata__dirty[__ARR_SIZE__NUM_LARS];
			// FORMAL

	
	always_ff @(posedge clk)
	begin
		integer i;

		for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
		begin
			__debug_lar_metadata__data_index[i]
				<= __lar_metadata__data_index[i];
			__debug_lar_metadata__tag[i]
				<= __lar_metadata__tag[i];
			__debug_lar_metadata__data_type[i]
				<= __lar_metadata__data_type[i];
			__debug_lar_metadata__int_type_size[i]
				<= __lar_metadata__int_type_size[i];

			__debug_lar_shareddata__base_addr[i]
				<= __lar_shareddata__base_addr[i];
			__debug_lar_shareddata__data[i]
				<= __lar_shareddata__data[i];
			__debug_lar_shareddata__ref_count[i]
				<= __lar_shareddata__ref_count[i];
			__debug_lar_shareddata__dirty[i]
				<= __lar_shareddata__dirty[i];
		end
	end
			// FORMAL


	// Used for allocating/deallocating shared data.
	//logic [__METADATA__TAG__INDEX_HI - __METADATA__TAG__INDEX_LO : 0]
	//	__lar_tag_stack[__ARR_SIZE__NUM_LARS];
	//logic [__METADATA__TAG__INDEX_HI - __METADATA__TAG__INDEX_LO : 0]
	//	__curr_tag_stack_index;
	logic [__MSB_POS__METADATA__TAG : 0]
		__lar_tag_stack[__ARR_SIZE__NUM_LARS];
	logic [__MSB_POS__METADATA__TAG : 0]
		__curr_tag_stack_index;

	logic [__MSB_POS__METADATA__TAG : 0]
		__tag_search_0, __tag_search_1, __tag_search_2, __tag_search_3,
		__tag_search_final, __captured_tag_search_final;

	
	logic __found_tag;
	//logic __eek;
	logic [__MSB_POS__METADATA__TAG : 0] __debug_tag_search_final;

	initial
	begin
		__debug_tag_search_final = 0;
		__found_tag = 0;
	end
			// FORMAL


	//`define TAG(index) __lar_metadata[index] `METADATA__TAG

	






	// The LAR's tag... specifies which shared data is used by this LAR.
	


	// See PkgSnow64Cpu::DataType.
	


	// See PkgSnow64Cpu::IntTypeSize.
	



	// LAR Shared Data stuff
	// Used for extracting the base_addr from a 64-bit address

	// The base address, used for associativity between LARs.
	

	



	// The data itself.
	

	


	// The reference count of this shared data.
	

	


	// The "dirty" flag.  Used to determine if we should write back to
	// memory.
	

	


	initial
	begin
		integer __i;

		__wr_state = PkgSnow64LarFile::WrStIdle;

		for (__i=0; __i<__ARR_SIZE__NUM_LARS; __i=__i+1)
		begin
			__lar_metadata__data_index[__i] = 0;

			__lar_metadata__tag[__i] = __UNALLOCATED_TAG;
			//__lar_metadata__tag[__i] = __LAST_INDEX__NUM_LARS;
			__lar_metadata__data_type[__i] = 0;
			__lar_metadata__int_type_size[__i] = 0;

			__lar_shareddata__base_addr[__i] = 0;
			__lar_shareddata__data[__i] = 0;
			__lar_shareddata__ref_count[__i] = 0;
			__lar_shareddata__dirty[__i] = 0;

			// Fill up the stack of tags.
			__lar_tag_stack[__i] = __i;
		end

		__captured_in_wr__index = 0;
		__captured_in_wr__base_addr = 0;
		__captured_in_wr__write_type = 0;
		__captured_in_wr__data_type = 0;
		__captured_in_wr__int_type_size = 0;
		__captured_in_mem_read__valid = 0;
		__captured_in_mem_write__valid = 0;
		__captured_tag_search_final = 0;
		__curr_tag_stack_index = __LAST_INDEX__NUM_LARS;
		{real_out_rd_a.data, real_out_rd_b.data,
			real_out_rd_c.data} = 0;
		{real_out_rd_a.addr, real_out_rd_b.addr,
			real_out_rd_c.addr} = 0;
		{real_out_rd_a.tag, real_out_rd_b.tag,
			real_out_rd_c.tag} = 0;
		{real_out_rd_a.data_type, real_out_rd_b.data_type,
			real_out_rd_c.data_type} = 0;
		{real_out_rd_a.int_type_size,
			real_out_rd_b.int_type_size,
			real_out_rd_c.int_type_size} = 0;

		real_out_mem_read.req = 0;
		real_out_mem_read.base_addr = 0;

		real_out_mem_write.req = 0;
		real_out_mem_write.data = 0;
		real_out_mem_write.base_addr = 0;
	end



	

	













































































	
	always @(posedge clk)
	begin
		real_out_rd_a.data
			<= 
		
		__lar_shareddata__data[
		__lar_metadata__tag[real_in_rd_a.index]
];
		case (
		__lar_metadata__data_type[real_in_rd_a.index])
		PkgSnow64Cpu::DataTypBFloat16:
		begin
			real_out_rd_a.addr
				<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_a.index]
],
					



	{
		__lar_metadata__data_index[real_in_rd_a.index][__METADATA__DATA_INDEX__INDEX_HI:1], 1'b0}};
		end


		PkgSnow64Cpu::DataTypReserved:
		begin
			real_out_rd_a.addr
				<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_a.index]
],
				{((__METADATA__DATA_INDEX__INDEX_HI) + 1){1'b0}}};
		end


		default:
		begin
			case (
		__lar_metadata__int_type_size[real_in_rd_a.index])
			PkgSnow64Cpu::IntTypSz8:
			begin
				real_out_rd_a.addr
					<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_a.index]
],
						



	{
		__lar_metadata__data_index[real_in_rd_a.index][__METADATA__DATA_INDEX__INDEX_HI:0]}};
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				real_out_rd_a.addr
					<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_a.index]
],
						



	{
		__lar_metadata__data_index[real_in_rd_a.index][__METADATA__DATA_INDEX__INDEX_HI:1], 1'b0}};
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				real_out_rd_a.addr
					<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_a.index]
],
						



	{
		__lar_metadata__data_index[real_in_rd_a.index][__METADATA__DATA_INDEX__INDEX_HI:2], 2'b0}};
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				real_out_rd_a.addr
					<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_a.index]
],
						



	{
		__lar_metadata__data_index[real_in_rd_a.index][__METADATA__DATA_INDEX__INDEX_HI:3], 3'b0}};
			end
			endcase
		end
		endcase
		real_out_rd_a.tag
			<= 
		__lar_metadata__tag[real_in_rd_a.index]
;
		real_out_rd_a.data_type
			<= 
		__lar_metadata__data_type[real_in_rd_a.index];
		real_out_rd_a.int_type_size
			<= 
		__lar_metadata__int_type_size[real_in_rd_a.index];
	end
	
	always @(posedge clk)
	begin
		real_out_rd_b.data
			<= 
		
		__lar_shareddata__data[
		__lar_metadata__tag[real_in_rd_b.index]
];
		case (
		__lar_metadata__data_type[real_in_rd_b.index])
		PkgSnow64Cpu::DataTypBFloat16:
		begin
			real_out_rd_b.addr
				<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_b.index]
],
					



	{
		__lar_metadata__data_index[real_in_rd_b.index][__METADATA__DATA_INDEX__INDEX_HI:1], 1'b0}};
		end


		PkgSnow64Cpu::DataTypReserved:
		begin
			real_out_rd_b.addr
				<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_b.index]
],
				{((__METADATA__DATA_INDEX__INDEX_HI) + 1){1'b0}}};
		end


		default:
		begin
			case (
		__lar_metadata__int_type_size[real_in_rd_b.index])
			PkgSnow64Cpu::IntTypSz8:
			begin
				real_out_rd_b.addr
					<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_b.index]
],
						



	{
		__lar_metadata__data_index[real_in_rd_b.index][__METADATA__DATA_INDEX__INDEX_HI:0]}};
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				real_out_rd_b.addr
					<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_b.index]
],
						



	{
		__lar_metadata__data_index[real_in_rd_b.index][__METADATA__DATA_INDEX__INDEX_HI:1], 1'b0}};
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				real_out_rd_b.addr
					<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_b.index]
],
						



	{
		__lar_metadata__data_index[real_in_rd_b.index][__METADATA__DATA_INDEX__INDEX_HI:2], 2'b0}};
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				real_out_rd_b.addr
					<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_b.index]
],
						



	{
		__lar_metadata__data_index[real_in_rd_b.index][__METADATA__DATA_INDEX__INDEX_HI:3], 3'b0}};
			end
			endcase
		end
		endcase
		real_out_rd_b.tag
			<= 
		__lar_metadata__tag[real_in_rd_b.index]
;
		real_out_rd_b.data_type
			<= 
		__lar_metadata__data_type[real_in_rd_b.index];
		real_out_rd_b.int_type_size
			<= 
		__lar_metadata__int_type_size[real_in_rd_b.index];
	end
	
	always @(posedge clk)
	begin
		real_out_rd_c.data
			<= 
		
		__lar_shareddata__data[
		__lar_metadata__tag[real_in_rd_c.index]
];
		case (
		__lar_metadata__data_type[real_in_rd_c.index])
		PkgSnow64Cpu::DataTypBFloat16:
		begin
			real_out_rd_c.addr
				<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_c.index]
],
					



	{
		__lar_metadata__data_index[real_in_rd_c.index][__METADATA__DATA_INDEX__INDEX_HI:1], 1'b0}};
		end


		PkgSnow64Cpu::DataTypReserved:
		begin
			real_out_rd_c.addr
				<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_c.index]
],
				{((__METADATA__DATA_INDEX__INDEX_HI) + 1){1'b0}}};
		end


		default:
		begin
			case (
		__lar_metadata__int_type_size[real_in_rd_c.index])
			PkgSnow64Cpu::IntTypSz8:
			begin
				real_out_rd_c.addr
					<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_c.index]
],
						



	{
		__lar_metadata__data_index[real_in_rd_c.index][__METADATA__DATA_INDEX__INDEX_HI:0]}};
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				real_out_rd_c.addr
					<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_c.index]
],
						



	{
		__lar_metadata__data_index[real_in_rd_c.index][__METADATA__DATA_INDEX__INDEX_HI:1], 1'b0}};
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				real_out_rd_c.addr
					<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_c.index]
],
						



	{
		__lar_metadata__data_index[real_in_rd_c.index][__METADATA__DATA_INDEX__INDEX_HI:2], 2'b0}};
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				real_out_rd_c.addr
					<= {
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[real_in_rd_c.index]
],
						



	{
		__lar_metadata__data_index[real_in_rd_c.index][__METADATA__DATA_INDEX__INDEX_HI:3], 3'b0}};
			end
			endcase
		end
		endcase
		real_out_rd_c.tag
			<= 
		__lar_metadata__tag[real_in_rd_c.index]
;
		real_out_rd_c.data_type
			<= 
		__lar_metadata__data_type[real_in_rd_c.index];
		real_out_rd_c.int_type_size
			<= 
		__lar_metadata__int_type_size[real_in_rd_c.index];
	end

	
	

	





	assign __tag_search_0 = 
		((
		__lar_shareddata__ref_count[1]
		&& (
		__lar_shareddata__base_addr[1]
		== __in_wr__incoming_base_addr.base_addr))
		? 1 : 0) | 
		((
		__lar_shareddata__ref_count[2]
		&& (
		__lar_shareddata__base_addr[2]
		== __in_wr__incoming_base_addr.base_addr))
		? 2 : 0)
		| 
		((
		__lar_shareddata__ref_count[3]
		&& (
		__lar_shareddata__base_addr[3]
		== __in_wr__incoming_base_addr.base_addr))
		? 3 : 0);

	









	assign __tag_search_1 = 0;
	assign __tag_search_2 = 0;
	assign __tag_search_3 = 0;
			// if !defined(SMALL_LAR_FILE)

	assign __tag_search_final = __tag_search_0 | __tag_search_1
		| __tag_search_2 | __tag_search_3;




	

	

	

	


	


	

	


	

	

	


	

	

	

	


	

	

	

	


	

	

	


	task stop_mem_read;
		real_out_mem_read.req <= 0;
	endtask : stop_mem_read

	//task prep_mem_read;
	//	real_out_mem_read.req <= 1;
	//	real_out_mem_read.base_addr
	//		<= `shareddata_tagged_base_addr(__captured_in_wr__index);
	//endtask

	// Reads from memory ALWAYS use the captured base addr
	task prep_mem_read;
		real_out_mem_read.req <= 1;
		real_out_mem_read.base_addr
			<= __captured_in_wr__base_addr.base_addr;
	endtask : prep_mem_read

	task stop_mem_write;
		real_out_mem_write.req <= 0;
	endtask : stop_mem_write

	task prep_mem_write;
		real_out_mem_write.req <= 1;
		real_out_mem_write.data
			<= 
		__lar_shareddata__data[
		
		__lar_metadata__tag[__captured_in_wr__index]
];
		real_out_mem_write.base_addr
			<= 
		__lar_shareddata__base_addr[
		
		__lar_metadata__tag[__captured_in_wr__index]
];
	endtask : prep_mem_write

	always @(posedge clk)
	begin
		case (__wr_state)
		PkgSnow64LarFile::WrStIdle:
		begin
			stop_mem_read();
			__captured_in_wr__index <= __in_wr__index;
			__captured_in_wr__write_type <= real_in_wr.write_type;
			__captured_in_wr__base_addr <= real_in_wr.addr;
			__captured_in_wr__data_type <= real_in_wr.data_type;
			__captured_in_wr__int_type_size <= real_in_wr.int_type_size;

			__captured_in_mem_read__valid <= 0;
			__captured_in_mem_write__valid <= 0;

			if (real_in_wr.req && (__in_wr__index != 0))
			begin
				// Mostly ALU/FPU operations.
				case (real_in_wr.write_type)
				PkgSnow64LarFile::WriteTypOnlyData:
				begin
					stop_mem_write();
					if (
		
		__lar_metadata__tag[__in_wr__index]
 != __UNALLOCATED_TAG)
					begin
						// Data identical to what we have means we might
						// not have to touch memory.
						if (
		
		
		__lar_shareddata__data[
		__lar_metadata__tag[__in_wr__index]
]
							!= real_in_wr.data)
						begin
							
		
		
		__lar_shareddata__dirty[
		__lar_metadata__tag[__in_wr__index]
] <= 1;
						end
						
		
		
		__lar_shareddata__data[
		__lar_metadata__tag[__in_wr__index]
]
							<= real_in_wr.data;
					end


					
					__debug_tag_search_final <= 0;
					__found_tag <= 0;
							// FORMAL
				end

				// Used for port-mapped input instructions
				PkgSnow64LarFile::WriteTypDataAndType:
				begin
					stop_mem_write();
					if (
		
		__lar_metadata__tag[__in_wr__index]
 != __UNALLOCATED_TAG)
					begin
						
		
		__lar_metadata__data_type[__in_wr__index]
							<= real_in_wr.data_type;
						
		
		__lar_metadata__int_type_size[__in_wr__index]
							<= real_in_wr.int_type_size;

						// Data identical to what we have means we might
						// not have to touch memory.
						if (
		
		
		__lar_shareddata__data[
		__lar_metadata__tag[__in_wr__index]
]
							!= real_in_wr.data)
						begin
							
		
		
		__lar_shareddata__dirty[
		__lar_metadata__tag[__in_wr__index]
] <= 1;
						end
						
		
		
		__lar_shareddata__data[
		__lar_metadata__tag[__in_wr__index]
]
							<= real_in_wr.data;


						// We basically have to convert the index from one
						// type to another here.
						case (real_in_wr.data_type)
						PkgSnow64Cpu::DataTypBFloat16:
						begin
							// BFloat16's here are actually 16-bit, or two
							// bytes.
							
		
		__lar_metadata__data_index[__in_wr__index]
								<= 


	{
		
		__lar_metadata__data_index[__in_wr__index][__METADATA__DATA_INDEX__INDEX_HI:1], 1'b0};
						end

						PkgSnow64Cpu::DataTypReserved:
						begin
							// As usual, we don't care about
							// DataTypReserved.
							
		
		__lar_metadata__data_index[__in_wr__index] <= 0;
						end

						// An integer of either signedness
						default:
						begin
							case (real_in_wr.int_type_size)
							PkgSnow64Cpu::IntTypSz8:
							begin
								
		
		__lar_metadata__data_index[__in_wr__index]
									<= 


	{
		
		__lar_metadata__data_index[__in_wr__index][__METADATA__DATA_INDEX__INDEX_HI:0]};
							end

							PkgSnow64Cpu::IntTypSz16:
							begin
								
		
		__lar_metadata__data_index[__in_wr__index]
									<= 


	{
		
		__lar_metadata__data_index[__in_wr__index][__METADATA__DATA_INDEX__INDEX_HI:1], 1'b0};
							end

							PkgSnow64Cpu::IntTypSz32:
							begin
								
		
		__lar_metadata__data_index[__in_wr__index]
									<= 


	{
		
		__lar_metadata__data_index[__in_wr__index][__METADATA__DATA_INDEX__INDEX_HI:2], 2'b0};
							end

							PkgSnow64Cpu::IntTypSz64:
							begin
								
		
		__lar_metadata__data_index[__in_wr__index]
									<= 


	{
		
		__lar_metadata__data_index[__in_wr__index][__METADATA__DATA_INDEX__INDEX_HI:3], 3'b0};
							end
							endcase
						end
						endcase
					end


					
					__debug_tag_search_final <= 0;
					__found_tag <= 0;
							// FORMAL
				end

				// PkgSnow64LarFile::WriteTypLd or
				// PkgSnow64LarFile::WriteTypSt
				default:
				begin
					__wr_state <= PkgSnow64LarFile::WrStStartLdSt;

					
		
		__lar_metadata__data_type[__in_wr__index]
						<= real_in_wr.data_type;
					
		
		__lar_metadata__int_type_size[__in_wr__index]
						<= real_in_wr.int_type_size;

					__captured_tag_search_final <= __tag_search_final;

					
					__debug_tag_search_final <= __tag_search_final;
					__found_tag <= __tag_search_final != 0;
							// FORMAL

					case (real_in_wr.data_type)
					PkgSnow64Cpu::DataTypBFloat16:
					begin
						// BFloat16's are 16-bit, or two bytes.
						
		
		__lar_metadata__data_index[__in_wr__index]
							<= 


	{real_in_wr.addr[__METADATA__DATA_INDEX__INDEX_HI:1], 1'b0};
					end

					// We don't care about DataTypReserved
					PkgSnow64Cpu::DataTypReserved:
					begin
						
		
		__lar_metadata__data_index[__in_wr__index] <= 0;
					end

					// An integer of either signedness
					default:
					begin
						case (real_in_wr.int_type_size)
						PkgSnow64Cpu::IntTypSz8:
						begin
							
		
		__lar_metadata__data_index[__in_wr__index]
								<= 


	{real_in_wr.addr[__METADATA__DATA_INDEX__INDEX_HI:0]};
						end

						PkgSnow64Cpu::IntTypSz16:
						begin
							
		
		__lar_metadata__data_index[__in_wr__index]
								<= 


	{real_in_wr.addr[__METADATA__DATA_INDEX__INDEX_HI:1], 1'b0};
						end

						PkgSnow64Cpu::IntTypSz32:
						begin
							
		
		__lar_metadata__data_index[__in_wr__index]
								<= 


	{real_in_wr.addr[__METADATA__DATA_INDEX__INDEX_HI:2], 2'b0};
						end

						PkgSnow64Cpu::IntTypSz64:
						begin
							
		
		__lar_metadata__data_index[__in_wr__index]
								<= 


	{real_in_wr.addr[__METADATA__DATA_INDEX__INDEX_HI:3], 3'b0};
						end
						endcase
					end
					endcase
				end
				endcase
			end
		end

		PkgSnow64LarFile::WrStStartLdSt:
		begin
			__captured_in_mem_read__valid <= 0;
			__captured_in_mem_write__valid <= 0;

			// The address's data is already in at least one LAR.
			// 
			// This is the best case scenario.  It's the analog of a cache
			// hit in a conventional cache.
			if (__captured_tag_search_final != 0)
			begin
				// We'll never need to read from memory if there was a
				// "hit".
				stop_mem_read();

				// A tag already exists.  We set our tag to the existing
				// one.
				
		
		__lar_metadata__tag[__captured_in_wr__index]
 <= __captured_tag_search_final;

				// Loads of data we already had don't affect the dirty
				// flag.

				// If our existing tag ISN'T the one we found.
				if (__captured_tag_search_final
					!= 
		
		__lar_metadata__tag[__captured_in_wr__index]
)
				begin
					
		
		__lar_shareddata__ref_count[__captured_tag_search_final]
						<= 
		
		__lar_shareddata__ref_count[__captured_tag_search_final] + 1;

					if (__captured_in_wr__write_type
						== PkgSnow64LarFile::WriteTypSt)
					begin
						// Make a copy of our data to the new address.
						// This also causes us to need to set the dirty
						// flag.
						
		
		__lar_shareddata__data[__captured_tag_search_final]
							<= 
		
		
		__lar_shareddata__data[
		__lar_metadata__tag[__captured_in_wr__index]
];
						
		
		__lar_shareddata__dirty[__captured_tag_search_final] <= 1;
					end

					case (
		
		
		__lar_shareddata__ref_count[
		__lar_metadata__tag[__captured_in_wr__index]
])
					// We haven't been allocated yet.
					// Since we haven't been allocated yet, we don't need
					// to do a write back to memory.
					0:
					begin
						stop_mem_write();
						__wr_state <= PkgSnow64LarFile::WrStIdle;
					end

					// There were no other references to us, so deallocate
					// the old tag (pushing it onto the stack), and (if we
					// were dirty) send our old data out to memory.
					1:
					begin
						// Deallocate our old tag.  Note that this is
						// actually the only case where we will ever do so.
						
		__lar_tag_stack[__curr_tag_stack_index + 1]
							<= 
		
		__lar_metadata__tag[__captured_in_wr__index]
;
						__curr_tag_stack_index <= __curr_tag_stack_index
							+ 1;

						// Since we're deallocating stuff, we need to write
						// our old data back to memory if it's not already
						// up to date.
						if (
		
		
		__lar_shareddata__dirty[
		__lar_metadata__tag[__captured_in_wr__index]
])
						begin
							__wr_state <= PkgSnow64LarFile
								::WrStWaitForJustMemWrite;
							prep_mem_write();
						end
						else // if (!`captured__wr_curr_shareddata_dirty)
						begin
							// We need to go back to our previous state.
							__wr_state <= PkgSnow64LarFile::WrStIdle;
							stop_mem_write();
						end

						// We were the only LAR that cared about our old
						// shared data, which means our old shared data
						// becomes free for other use.
						
		
		
		__lar_shareddata__ref_count[
		__lar_metadata__tag[__captured_in_wr__index]
] <= 0;


						
		
		
		__lar_shareddata__dirty[
		__lar_metadata__tag[__captured_in_wr__index]
] <= 0;

						// For good measure.
						
		
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[__captured_in_wr__index]
] <= 0;
						
		
		
		__lar_shareddata__data[
		__lar_metadata__tag[__captured_in_wr__index]
] <= 0;
					end

					// There was at least one other reference to us, so
					// don't deallocate anything, but do decrement the
					// reference count.
					// In this situation, all that happens is that our tag
					// changes and our shared data loses a reference, but
					// our new shared data gains a reference.
					default:
					begin
						__wr_state <= PkgSnow64LarFile::WrStIdle;
						
		
		
		__lar_shareddata__ref_count[
		__lar_metadata__tag[__captured_in_wr__index]
]
							<= 
		
		
		__lar_shareddata__ref_count[
		__lar_metadata__tag[__captured_in_wr__index]
]
							- 1;
						stop_mem_write();
					end
					endcase
				end

				// If our address is identical to the one being searched
				// for, we do nothing useful.
				else
				begin
					// In this case, we do nothing of interest.
					__wr_state <= PkgSnow64LarFile::WrStIdle;
					stop_mem_write();
				end
			end

			// Nobody had the address we were looking for.
			// 
			// This is an analog of a cache miss in a conventional
			// cache design.
			else // if (__captured_tag_search_final == 0)
			begin
				case (
		
		
		__lar_shareddata__ref_count[
		__lar_metadata__tag[__captured_in_wr__index]
])
				// This is from before we were allocated.
				0:
				begin
					stop_mem_write();

					// Allocate a new element of shared data.
					
		
		__lar_metadata__tag[__captured_in_wr__index]
 <= 
		__lar_tag_stack[__curr_tag_stack_index];
					__curr_tag_stack_index <= __curr_tag_stack_index
						- 1;
					
		
		__lar_shareddata__base_addr[
		__lar_tag_stack[__curr_tag_stack_index]]
						<= __captured_in_wr__base_addr.base_addr;

					// Within the run of the current program, we are
					// the first LAR to ever reference this element of
					// shared data.
					
		
		__lar_shareddata__ref_count[
		__lar_tag_stack[__curr_tag_stack_index]] <= 1;

					if (__captured_in_wr__write_type
						== PkgSnow64LarFile::WriteTypLd)
					begin
						// Because we haven't been allocated yet, we
						// only need to perform a data read.
						__wr_state <= PkgSnow64LarFile
							::WrStWaitForJustMemRead;
						prep_mem_read();

						// A load of fresh data marks us as clean.
						
		
		__lar_shareddata__dirty[
		__lar_tag_stack[__curr_tag_stack_index]] <= 0;
					end

					else // if (__captured_in_wr__write_type
						// == PkgSnow64LarFile::WriteTypSt)
					begin
						__wr_state <= PkgSnow64LarFile::WrStIdle;
						// Simple default behavior... if you do a store
						// before there was any data in a LAR, why not
						// make the result data zero?
						// 
						// ...In actuality, it the data will already be
						// zero anyway.
						
		
		__lar_shareddata__data[
		__lar_tag_stack[__curr_tag_stack_index]] <= 0;

						// Stores mark the data as dirty.
						
		
		__lar_shareddata__dirty[
		__lar_tag_stack[__curr_tag_stack_index]] <= 1;
					end
				end

				// We were the only reference, so don't perform any
				// allocation or deallocation, and don't change the
				// reference count.  Note however that this can still
				// cause accessing memory.
				1:
				begin
					
		
		
		__lar_shareddata__base_addr[
		__lar_metadata__tag[__captured_in_wr__index]
]
						<= __captured_in_wr__base_addr.base_addr;

					//if (`captured__wr_curr_shareddata_base_addr
					//	!= __captured_in_wr__base_addr.base_addr)
					begin
						if (
		
		
		__lar_shareddata__dirty[
		__lar_metadata__tag[__captured_in_wr__index]
])
						begin
							if (__captured_in_wr__write_type
								== PkgSnow64LarFile::WriteTypLd)
							begin
								// This is the ONLY case in which we end up
								// needing to do both a read from memory
								// and a write to memory.
								__wr_state <= PkgSnow64LarFile
									::WrStWaitForMemReadAndMemWrite;
								prep_mem_write();
								prep_mem_read();

								// Loads of fresh data mark us as clean.
								
		
		
		__lar_shareddata__dirty[
		__lar_metadata__tag[__captured_in_wr__index]
] <= 0;
							end
							else // if (__captured_in_wr__write_type
								// == PkgSnow64LarFile::WriteTypSt)
							begin
								__wr_state <= PkgSnow64LarFile
									::WrStWaitForJustMemWrite;
								prep_mem_write();
								stop_mem_read();

								// Stores to an address nobody had already
								// marks our data as dirty.
								// 
								// Actually, our allocated data was already
								// marked as dirty, so we don't have to set
								// it to dirty again.
								//`captured__wr_curr_shareddata_dirty <= 1;
							end
						end

						else // if (our data ISN'T dirty)
						begin
							if (__captured_in_wr__write_type
								== PkgSnow64LarFile::WriteTypLd)
							begin
								__wr_state <= PkgSnow64LarFile
									::WrStWaitForJustMemRead;

								// In this case, we don't have to write our
								// current data back to memory, as we're
								// already up to date with memory.
								stop_mem_write();
								prep_mem_read();

								// Loads of fresh data mark us as clean.
								// However, our allocated data slot is
								// already marked as clean!
								//`captured__wr_curr_shareddata_dirty <= 0;
							end
							else // if (__captured_in_wr__write_type
								// == PkgSnow64LarFile::WriteTypSt)
							begin
								// However, since our CURRENT data is
								// already matching with memory, we don't
								// have to write our CURRENT data back to
								// memory.

								// Actually, we don't have to touch memory
								// at all for this special case.
								__wr_state <= PkgSnow64LarFile::WrStIdle;
								stop_mem_write();
								stop_mem_read();

								// Stores to an address nobody has yet
								// marks our NEW data as dirty.
								
		
		
		__lar_shareddata__dirty[
		__lar_metadata__tag[__captured_in_wr__index]
] <= 1;
							end
						end
					end

					//// If we already had the data from the address, we
					//// can just do nothing here... though we're
					//// definitely wasting a cycle!
					//else
					//begin
					//	__wr_state <= PkgSnow64LarFile::WrStIdle;
					//	stop_mem_write();
					//	stop_mem_read();
					//end
				end

				// There are other LARs that have our old data, but
				// no LAR has the data from our new address.
				default:
				begin
					// We flat out don't need to store any LAR's data
					// back to memory in this case.
					stop_mem_write();

					// Decrement the old reference count.
					// The old reference count is guaranteed to be at
					// least 1 after decrementing it.
					
		
		
		__lar_shareddata__ref_count[
		__lar_metadata__tag[__captured_in_wr__index]
]
						<= 
		
		
		__lar_shareddata__ref_count[
		__lar_metadata__tag[__captured_in_wr__index]
] - 1;

					// Allocate a new element of shared data
					
		
		__lar_metadata__tag[__captured_in_wr__index]
 <= 
		__lar_tag_stack[__curr_tag_stack_index];
					__curr_tag_stack_index <= __curr_tag_stack_index
						- 1;

					// Set the base_addr and ref_count of our allocated
					// element of shared data.
					
		
		__lar_shareddata__base_addr[
		__lar_tag_stack[__curr_tag_stack_index]]
						<= __captured_in_wr__base_addr.base_addr;
					
		
		__lar_shareddata__ref_count[
		__lar_tag_stack[__curr_tag_stack_index]] <= 1;


					if (__captured_in_wr__write_type
						== PkgSnow64LarFile::WriteTypLd)
					begin
						// Because at laest one other LAR has our
						// previous data, we do not need to store it
						// back to memory yet, but since nobody has our
						// new address, we need to load that address's
						// data from memory.
						__wr_state <= PkgSnow64LarFile
							::WrStWaitForJustMemRead;
						prep_mem_read();

						// Loads of fresh data always provide clean
						// data
						
		
		__lar_shareddata__dirty[
		__lar_tag_stack[__curr_tag_stack_index]] <= 0;

					end
					else // if (real_in_wr.write_type
						// == PkgSnow64LarFile::WriteTypSt)
					begin
						__wr_state <= PkgSnow64LarFile::WrStIdle;
						stop_mem_read();

						// Make a copy of our old data over to the
						// freshly allocated element of shared data.
						
		
		__lar_shareddata__data[
		__lar_tag_stack[__curr_tag_stack_index]]
							<= 
		
		
		__lar_shareddata__data[
		__lar_metadata__tag[__captured_in_wr__index]
];

						// Also, since this is a store, mark the copy
						// of our old data as dirty.
						
		
		__lar_shareddata__dirty[
		__lar_tag_stack[__curr_tag_stack_index]] <= 1;
					end
				end
				endcase
			end
		end

		PkgSnow64LarFile::WrStWaitForJustMemRead:
		begin
			stop_mem_read();
			stop_mem_write();

			if (real_in_mem_read.valid)
			begin
				__wr_state <= PkgSnow64LarFile::WrStIdle;

				
		
		
		__lar_shareddata__data[
		__lar_metadata__tag[__captured_in_wr__index]
]
					<= real_in_mem_read.data;
			end
		end

		PkgSnow64LarFile::WrStWaitForJustMemWrite:
		begin
			stop_mem_read();
			stop_mem_write();

			if (real_in_mem_write.valid)
			begin
				__wr_state <= PkgSnow64LarFile::WrStIdle;
			end
		end

		PkgSnow64LarFile::WrStWaitForMemReadAndMemWrite:
		begin
			// It is assumed that the memory bus guard will notice our
			// request for both a read and a write on the same cycle.
			stop_mem_read();
			stop_mem_write();

			// Here, we don't care about the order in which our requests
			// are serviced.  The memory bus guard takes care of that for
			// us.
			if (real_in_mem_read.valid)
			begin
				__captured_in_mem_read__valid <= 1;

				
		
		
		__lar_shareddata__data[
		__lar_metadata__tag[__captured_in_wr__index]
]
					<= real_in_mem_read.data;

				if ((!real_in_mem_write.valid)
					&& __captured_in_mem_write__valid)
				begin
					// At this time, both our read and our write have
					// happened, and we can change our state.
					__wr_state <= PkgSnow64LarFile::WrStIdle;
				end
			end

			if (real_in_mem_write.valid)
			begin
				__captured_in_mem_write__valid <= 1;

				if ((!real_in_mem_read.valid)
					&& __captured_in_mem_read__valid)
				begin
					// At this time, both our read and our write have
					// happened, and we can change our state.
					__wr_state <= PkgSnow64LarFile::WrStIdle;
				end
			end
		end
		endcase
	end
	
	
	
	

	

	
	

	
	
	

	
	
	
	

	
	
	
	

	
	
	


	

	
	
	

	
	

	
	

	
	

	
	

	


	
	localparam __INCOMING_BASE_ADDR__INDEX_HI = 63;
	localparam __INCOMING_BASE_ADDR__INDEX_LO = 5;

	
	

	
	

	
	
	
	

	



	

	

	

	


	

	

	

	



	integer i, j;
	(* keep *) logic [__MSB_POS__METADATA__TAG:0]
		__total_num_references;
		
	(* keep *) logic [__MSB_POS__METADATA__TAG:0]
		__curr_num_references;

	(* keep *) logic [__MSB_POS__METADATA__TAG:0]
		__num_unique_tags;
	//(* keep *) logic __no_unique_tags;

	(* keep *) logic __found_unique_tag;
	(* keep *) logic __found_tag_in_stack;
	(* keep *) logic __found_tag_outside_stack;

	//(* keep *) logic [__MSB_POS__METADATA__TAG:0]
	//	__unique_tags[0 : __LAST_INDEX__NUM_LARS];
	(* keep *) logic __unique_tags[0 : __LAST_INDEX__NUM_LARS];

	(* keep *) logic [__MSB_POS__METADATA__TAG:0]
		__found_tags_per_ref[0 : __LAST_INDEX__NUM_LARS];

	(* keep *) logic __tags_that_should_be_in_stack
		[0 : __LAST_INDEX__NUM_LARS];

	//logic __tag_was_changed_to_nonzero[0 : __LAST_INDEX__NUM_LARS];
	//logic __curr_tag_stack_index_was_decremented;
	(* keep *) logic __did_init;

	//logic __did_find_mem_write;


	//logic [1:0] __debug_lar_metadata__data_type [0:15];
	//logic [1:0] __debug_lar_metadata__int_type_size [0:15];
	//logic [3:0] __debug_lar_metadata__tag [0:15];
	//logic [63:0] __debug_lar_metadata__whole_addr [0:15];
	//logic [58:0] __debug_lar_shareddata__base_addr [0:15];
	//logic [255:0] __debug_lar_shareddata__data [0:15];
	//logic __debug_lar_shareddata__dirty [0:15];
	//logic [3:0] __debug_lar_shareddata__ref_count [0:15];
	//logic [3:0] __debug_lar_tag_stack [0:15];

	task formal_shared_init;
		assume(real_in_ctrl == 0);
		assume(real_in_rd_a == 0);
		assume(real_in_rd_b == 0);
		assume(real_in_rd_c == 0);
		assume(real_in_wr == 0);
		assume(real_in_mem_read == 0);
		assume(real_in_mem_write == 0);

		//assert(__eek == 0);
		//assert(__found == 0);

		//assert(__curr_tag_stack_index_was_decremented == 0);
		assert(__curr_tag_stack_index == __LAST_INDEX__NUM_LARS);

		assert({__formal__out_rd_a__data, __formal__out_rd_b__data,
			__formal__out_rd_c__data} == 0);
		assert({__formal__out_rd_a__addr, __formal__out_rd_b__addr,
			__formal__out_rd_c__addr} == 0);
		assert({__formal__out_rd_a__tag, __formal__out_rd_b__tag,
			__formal__out_rd_c__tag} == 0);
		assert({__formal__out_rd_a__data_type,
			__formal__out_rd_b__data_type, __formal__out_rd_c__data_type}
			== 0);
		assert({__formal__out_rd_a__int_type_size,
			__formal__out_rd_b__int_type_size,
			__formal__out_rd_c__int_type_size} == 0);
		assert(__formal__out_mem_read__req == 0);
		assert(__formal__out_mem_read__base_addr == 0);
		assert(__formal__out_mem_write__req == 0);
		assert(__formal__out_mem_write__data == 0);
		assert(__formal__out_mem_write__base_addr == 0);
		assert(__formal__out_wait_for_me__busy == 0);

		assert(__found_tag == 0);
		assert(__debug_tag_search_final == 0);
		assert(__wr_state == 0);
		assert(__captured_in_wr__index == 0);
		assert(__captured_in_wr__data_type == 0);
		assert(__captured_in_wr__int_type_size == 0);
		assert(__captured_in_wr__base_addr == 0);
		assert(__captured_in_wr__write_type == 0);
		assert(__captured_in_mem_read__valid == 0);
		assert(__captured_in_mem_write__valid == 0);
		assert(__captured_tag_search_final == 0);
	endtask

	initial
	begin
		for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
		begin
			//__tag_was_changed_to_nonzero[i] = 0;
			//assert(__tag_was_changed_to_nonzero[i] == 0);
			assert(__lar_metadata__data_index[i] == 0);
			assert(__lar_metadata__tag[i] == 0);
			assert(__lar_metadata__data_type[i] == 0);
			assert(__lar_metadata__int_type_size[i] == 0);
			assert(__lar_shareddata__base_addr[i] == 0);
			assert(__lar_shareddata__data[i] == 0);
			assert(__lar_shareddata__ref_count[i] == 0);
			assert(__lar_shareddata__dirty[i] == 0);
			assert(__lar_tag_stack[i] == i);
			//assert(__found_indices[i] == 0);
		end

		__did_init = 0;
		assert(__did_init == 0);

		formal_shared_init();
	end

	//always @(*)
	always @(posedge clk)
	begin

	if (!__did_init)
	begin
		__did_init = 1;
		assert(__did_init == 1);

		formal_shared_init();
	end

	else // if (__did_init)
	begin
		for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
		begin
			if (__lar_shareddata__ref_count[i] == 0)
			begin
				assert(__lar_shareddata__base_addr[i] == 0);
			end

			else // if (__lar_shareddata__ref_count[i] != 0)
			begin
				for (j=0; j<__ARR_SIZE__NUM_LARS; j=j+1)
				begin
					if ((__lar_shareddata__ref_count[j] != 0)
						&& (i != j))
					begin
						assert(__lar_shareddata__base_addr[i]
							!= __lar_shareddata__base_addr[j]);
					end
				end
			end
		end

		// Check the memory access stuff.
		for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
		begin
			// We should REALLY be in a state where we're trying to write
			// our old data back to memory.

			// Here is the case where we found the tag we were looking for,
			// and we also deallocated our old one.
			if (($past(__lar_shareddata__ref_count[i]) != 0)
				&& (__lar_shareddata__ref_count[i] == 0))
			begin
				assert($past(__wr_state)
					== __ENUM__WRITE_STATE__START_LD_ST);

				// We had to have found a tag for this situation to occur.
				assert(__captured_tag_search_final != 0);

				assert(__curr_tag_stack_index
					== ($past(__curr_tag_stack_index) + 1));
				assert(__lar_tag_stack[__curr_tag_stack_index] == i);

				// If we deallocated a tag, that means there had to have
				// been only one reference.
				assert($past(__lar_shareddata__ref_count[i]) == 1);

				// Deallocation means that, if our data is dirty, it should
				// be sent back to main memory.
				if ($past(__lar_shareddata__dirty[i]))
				begin
					// We definitely need to be requesting a write.
					assert(__formal__out_mem_write__req);
					assert(__formal__out_mem_write__data
						== $past(__lar_shareddata__data[i]));
					assert(__formal__out_mem_write__base_addr
						== $past(__lar_shareddata__base_addr[i]));

					// If there was a "hit" that also caused us to
					// deallocate a piece of shared data, we won't need to
					// read from memory, just 
					assert(__wr_state
						== __ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_WRITE);
				end

				else // if (!$past(__lar_shareddata__dirty[i]))
				begin
					assert(__wr_state == __ENUM__WRITE_STATE__IDLE);
				end
			end

			// We changed our address, but our reference count didn't
			// change.  This is a very special situation, as it means we
			// were the only reference, but we also changed our address (as
			// well as our data to that of the new address).
			if (($past(__lar_shareddata__ref_count[i]) == 1)
				&& (__lar_shareddata__ref_count[i] == 1)
				&& !$stable(__lar_shareddata__base_addr[i]))
			begin
				// For this to have happened, we need to have NOT found a
				// tag, and the tag stack needs to have remained constant.
				assert(__captured_tag_search_final == 0);

				assert($stable(__curr_tag_stack_index));

				for (j=0; j<__ARR_SIZE__NUM_LARS; j=j+1)
				begin
					assert($stable(__lar_tag_stack[j]));
				end

				assert($past(__wr_state)
					== __ENUM__WRITE_STATE__START_LD_ST);

				if ($past(__lar_shareddata__dirty[i]))
				begin
					if (__captured_in_wr__write_type
						== __ENUM__WRITE_TYPE__LD)
					begin
						assert(__wr_state
							> __ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_READ);
						assert(__wr_state
							> __ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_WRITE);
					end

					else // if (__captured_in_wr__write_type
						// == __ENUM__WRITE_TYPE__ST)
					begin
						assert(__wr_state
							==
							__ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_WRITE);
					end
				end

				else // if (!$past(__lar_shareddata__dirty[i]))
				begin
					if (__captured_in_wr__write_type
						== __ENUM__WRITE_TYPE__LD)
					begin
						assert(__wr_state
							==
							__ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_READ);
					end

					else // if (__captured_in_wr__write_type
						// == __ENUM__WRITE_TYPE__ST)
					begin

						assert(__wr_state
							== __ENUM__WRITE_STATE__IDLE);
					end
				end
			end

		end

		case (__wr_state)
		__ENUM__WRITE_STATE__IDLE:
		begin
			if ($past(__wr_state) == __ENUM__WRITE_STATE__START_LD_ST)
			begin
				//assert(__captured_tag_search_final != 0);

				//begin
				//	for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
				//	begin
				//		if (i == $past(__lar_metadata__tag
				//			[__captured_in_wr__index]))
				//		begin
				//			assert(__lar_shareddata__dirty[i]);
				//		end

				//		else
				//		begin
				//			assert($stable(__lar_shareddata__dirty[i]));
				//		end
				//	end
				//end

				if (__captured_tag_search_final != 0)
				begin
					if (__captured_tag_search_final
						!= __debug_lar_metadata__tag
						[__captured_in_wr__index])
					begin
						if (__captured_in_wr__write_type
							== __ENUM__WRITE_TYPE__ST)
						begin
							assert(__lar_shareddata__dirty
								[__captured_tag_search_final]);
						end

						case(__debug_lar_shareddata__ref_count
							[__debug_lar_metadata__tag
							[__captured_in_wr__index]])
						0:
						begin
							for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
							begin
								if (i != __captured_tag_search_final)
								begin
									assert($stable(__lar_shareddata__dirty
										[i]));
								end
							end
						end

						1:
						begin
							assert(!__debug_lar_shareddata__dirty
								[__debug_lar_metadata__tag
								[__captured_in_wr__index]]);
							assert(!__lar_shareddata__dirty
								[__debug_lar_metadata__tag
								[__captured_in_wr__index]]);

							// We deallocated here.
							for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
							begin
								if (i == __debug_lar_metadata__tag
									[__captured_in_wr__index])
								begin
									assert(!__lar_shareddata__dirty[i]);
								end
								else if (i != __captured_tag_search_final)
								begin
									assert($stable(__lar_shareddata__dirty
										[i]));
								end
							end
						end

						default:
						begin
							for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
							begin
								if (i != __captured_tag_search_final)
								begin
									assert($stable(__lar_shareddata__dirty
										[i]));
								end
							end
						end
						endcase
					end

					else // if (__captured_tag_search_final
						// == __debug_lar_metadata__tag
						// [__captured_in_wr__index])
					begin
						for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
						begin
							assert($stable(__lar_shareddata__dirty[i]));
						end
					end
				end

				else // if (__captured_tag_search_final == 0)
				begin
					// There had to have been a store
					assert(__captured_in_wr__write_type
						== __ENUM__WRITE_TYPE__ST);

					case(__debug_lar_shareddata__ref_count
						[__debug_lar_metadata__tag
						[__captured_in_wr__index]])
					0:
					begin
						assert(__curr_tag_stack_index
							== ($past(__curr_tag_stack_index) - 1));
						assert(__lar_shareddata__ref_count[__lar_tag_stack
							[__curr_tag_stack_index + 1]] == 1);
						assert(__lar_shareddata__base_addr
							[__lar_tag_stack[__curr_tag_stack_index + 1]]
							== 
		__captured_in_wr__base_addr
		[__INCOMING_BASE_ADDR__INDEX_HI : __INCOMING_BASE_ADDR__INDEX_LO]);
						assert(__lar_metadata__tag[__captured_in_wr__index]
							== __lar_tag_stack
							[__curr_tag_stack_index + 1]);
						assert(__lar_shareddata__dirty
							[__lar_tag_stack[__curr_tag_stack_index + 1]]);
						assert(__lar_shareddata__data
							[__lar_tag_stack[__curr_tag_stack_index + 1]]
							== 0);
					end

					1:
					begin
						assert(__lar_shareddata__base_addr
							[__debug_lar_metadata__tag
							[__captured_in_wr__index]]
							== 
		__captured_in_wr__base_addr
		[__INCOMING_BASE_ADDR__INDEX_HI : __INCOMING_BASE_ADDR__INDEX_LO]);

						assert(__lar_shareddata__dirty
							[__debug_lar_metadata__tag
							[__captured_in_wr__index]]);

						assert(!__debug_lar_shareddata__dirty
							[__debug_lar_metadata__tag
							[__captured_in_wr__index]]);
						assert(__lar_shareddata__ref_count
							[__debug_lar_metadata__tag
							[__captured_in_wr__index]] == 1);

						assert($stable(__curr_tag_stack_index));
					end

					default:
					begin
						//assert(__lar_shareddata__dirty
						//	[__debug_lar_metadata__tag
						//	[__captured_in_wr__index]]);
						assert(__lar_shareddata__data[__lar_tag_stack
							[__curr_tag_stack_index + 1]]
							== __debug_lar_shareddata__data
							[__debug_lar_metadata__tag
							[__captured_in_wr__index]]);
						assert(__lar_shareddata__ref_count
							[__debug_lar_metadata__tag
							[__captured_in_wr__index]]
							== (__debug_lar_shareddata__ref_count
							[__debug_lar_metadata__tag
							[__captured_in_wr__index]] - 1));

						assert(__lar_shareddata__ref_count[__lar_tag_stack
							[__curr_tag_stack_index + 1]] == 1);
						assert(__lar_shareddata__base_addr
							[__lar_tag_stack[__curr_tag_stack_index + 1]]
							== 
		__captured_in_wr__base_addr
		[__INCOMING_BASE_ADDR__INDEX_HI : __INCOMING_BASE_ADDR__INDEX_LO]);

						assert(__curr_tag_stack_index
							== ($past(__curr_tag_stack_index) - 1));
					end
					endcase
				end
			end

			else if ($past(__wr_state) != __ENUM__WRITE_STATE__IDLE)
			begin
				for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
				begin
					assert($stable(__lar_shareddata__dirty[i]));
				end
			end

			else if (($past(__wr_state) == __ENUM__WRITE_STATE__IDLE)
				&& $past(__formal__in_wr__req)
				&& ($past(__formal__in_wr__index) != 0))
			begin
				for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
				begin
					if (i == __lar_metadata__tag[__captured_in_wr__index])
					begin
						if ((i != 0)
							&& ($past(__lar_shareddata__data[i])
							!= $past(__formal__in_wr__data)))
						begin
							assert(__lar_shareddata__dirty[i]);
							//assert(`CURR_SHAREDDATA_TAGGED_DATA(i)
							//	== $past(__formal__in_wr__data));
							assert(__lar_shareddata__data[i]
								== $past(__formal__in_wr__data));
						end

						else
						begin
							assert($stable(__lar_shareddata__dirty[i]));
							assert($stable(__lar_shareddata__data[i]));
						end
					end

					else
					begin
						assert($stable(__lar_shareddata__dirty[i]));
						assert($stable(__lar_shareddata__data[i]));
					end

					assert($stable(__lar_shareddata__base_addr[i]));
					assert($stable(__lar_shareddata__ref_count[i]));
				end
				for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
				begin
					assert($stable(__lar_metadata__tag[i]));
				end

				case (__captured_in_wr__write_type)
				__ENUM__WRITE_TYPE__ONLY_DATA:
				begin
					for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
					begin
						assert($stable(__lar_metadata__data_index[i]));
						assert($stable(__lar_metadata__int_type_size[i]));
						assert($stable(__lar_metadata__data_type[i]));
					end
				end

				default:
				begin
					assert(__captured_in_wr__write_type
						== __ENUM__WRITE_TYPE__DATA_AND_TYPE);

					for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
					begin
						assert(__lar_metadata__data_index[i]
							<= $past(__lar_metadata__data_index[i]));
					end
				end
				endcase
			end

			else
			begin
				for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
				begin
					assert($stable(__lar_metadata__tag[i]));
					assert($stable(__lar_metadata__data_index[i]));
					assert($stable(__lar_metadata__data_type[i]));
					assert($stable(__lar_metadata__int_type_size[i]));
					assert($stable(__lar_shareddata__dirty[i]));
					assert($stable(__lar_shareddata__data[i]));
					assert($stable(__lar_shareddata__base_addr[i]));
					assert($stable(__lar_shareddata__ref_count[i]));
				end
			end
		end

		__ENUM__WRITE_STATE__START_LD_ST:
		begin
			for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
			begin
				assert($stable(__lar_shareddata__dirty[i]));
			end
		end

		// Anything where we have to touch memory
		default:
		begin
			if ($past(__wr_state) == __ENUM__WRITE_STATE__START_LD_ST)
			begin
				// If we had to touch memory, the index CAN'T have been
				// index zero.
				assert(__captured_in_wr__index != 0);

				// We found a tag
				if (__captured_tag_search_final != 0)
				begin
					if (__captured_tag_search_final
						!= __debug_lar_metadata__tag
						[__captured_in_wr__index])
					begin
						if (__captured_in_wr__write_type
							== __ENUM__WRITE_TYPE__LD)
						begin
							case (__debug_lar_shareddata__ref_count
								[__debug_lar_metadata__tag
								[__captured_in_wr__index]])
							0:
							begin
								for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
								begin
									assert($stable
										(__lar_shareddata__dirty[i]));
								end
							end

							1:
							begin
								assert(!__lar_shareddata__dirty
									[__debug_lar_metadata__tag
									[__captured_in_wr__index]]);

								for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
								begin
									if (i != __debug_lar_metadata__tag
										[__captured_in_wr__index])
									begin
										assert($stable
											(__lar_shareddata__dirty[i]));
									end
								end
							end

							default:
							begin
								for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
								begin
									assert($stable
										(__lar_shareddata__dirty[i]));
								end
							end
							endcase
						end

						else // if (__captured_in_wr__write_type
							// == __ENUM__WRITE_TYPE__ST)
						begin
							assert(__lar_shareddata__dirty
								[__captured_tag_search_final]);

							case (__debug_lar_shareddata__ref_count
								[__debug_lar_metadata__tag
								[__captured_in_wr__index]])
							0:
							begin
								for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
								begin
									if (i != __captured_tag_search_final)
									begin
										assert($stable
											(__lar_shareddata__dirty[i]));
									end
								end
							end

							1:
							begin
								assert(!__lar_shareddata__dirty
									[__debug_lar_metadata__tag
									[__captured_in_wr__index]]);

								for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
								begin
									if ((i != __captured_tag_search_final)
										&& (i != __debug_lar_metadata__tag
										[__captured_in_wr__index]))
									begin
										assert($stable
											(__lar_shareddata__dirty[i]));
									end
								end
							end

							default:
							begin
								for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
								begin
									if (i != __captured_tag_search_final)
									begin
										assert($stable
											(__lar_shareddata__dirty[i]));
									end
								end
							end
							endcase
						end
					end

					else // if (__captured_tag_search_final
						// == __debug_lar_metadata__tag
						// [__captured_in_wr__index])
					begin
						for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
						begin
							assert($stable(__lar_shareddata__dirty[i]));
						end
					end
				end

				else // if (__captured_tag_search_final == 0)
				begin
					case (__debug_lar_shareddata__ref_count
						[__debug_lar_metadata__tag
						[__captured_in_wr__index]])
					0:
					begin
						assert(__curr_tag_stack_index
							== ($past(__curr_tag_stack_index) - 1));
						
						if (__captured_in_wr__write_type
							== __ENUM__WRITE_TYPE__LD)
						begin
							assert(!__lar_shareddata__dirty
								[$past(__lar_tag_stack
								[__curr_tag_stack_index])]);
						end

						else // if (__captured_in_wr__write_type
							// == __ENUM__WRITE_TYPE__ST)
						begin
							assert(__lar_shareddata__dirty
								[$past(__lar_tag_stack
								[__curr_tag_stack_index])]);
						end

						for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
						begin
							if (i != $past(__lar_tag_stack
								[__curr_tag_stack_index]))
							begin
								assert($stable(__lar_shareddata__dirty
									[i]));
							end
						end
					end

					1:
					begin
						assert($stable(__curr_tag_stack_index));

						if (__captured_in_wr__write_type
							== __ENUM__WRITE_TYPE__LD)
						begin
							assert(!__lar_shareddata__dirty
								[__lar_metadata__tag
								[__captured_in_wr__index]]);
						end

						else // if (__captured_in_wr__write_type
							// == __ENUM__WRITE_TYPE__ST)
						begin
							assert(__lar_shareddata__dirty
								[__lar_metadata__tag
								[__captured_in_wr__index]]);
						end

						for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
						begin
							if (i != __lar_metadata__tag
								[__captured_in_wr__index])
							begin
								assert($stable(__lar_shareddata__dirty
									[i]));
							end
						end
					end

					default:
					begin
						assert(__curr_tag_stack_index
							== ($past(__curr_tag_stack_index) - 1));
						
						if (__captured_in_wr__write_type
							== __ENUM__WRITE_TYPE__LD)
						begin
							assert(!__lar_shareddata__dirty
								[$past(__lar_tag_stack
								[__curr_tag_stack_index])]);
						end

						else // if (__captured_in_wr__write_type
							// == __ENUM__WRITE_TYPE__ST)
						begin
							assert(__lar_shareddata__dirty
								[$past(__lar_tag_stack
								[__curr_tag_stack_index])]);
						end

						for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
						begin
							if (i != $past(__lar_tag_stack
								[__curr_tag_stack_index]))
							begin
								assert($stable(__lar_shareddata__dirty
									[i]));
							end
						end
					end
					endcase
				end
			end

			else
			begin
				for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
				begin
					assert($stable(__lar_shareddata__dirty[i]));
				end
			end


			if (__captured_in_wr__write_type != __ENUM__WRITE_TYPE__LD)
			begin
				assert(__captured_in_wr__write_type
					== __ENUM__WRITE_TYPE__ST);
			end
		end
		endcase


		if (__wr_state != __ENUM__WRITE_STATE__IDLE)
		begin
			assert(__captured_in_wr__index != 0);

			if (__wr_state != __ENUM__WRITE_STATE__START_LD_ST)
			begin
				assert(__lar_metadata__tag[__captured_in_wr__index] != 0);
			end
		end

		//if (__formal__out_mem_write__req)
		//begin
		//	assert(!__formal__out_mem_read__req);
		//end

		//if (__formal__out_mem_read__req)
		//begin
		//	assert(!__formal__out_mem_write__req);
		//end


		if (__wr_state == __ENUM__WRITE_STATE__IDLE)
		begin
			assert(__formal__out_wait_for_me__busy == 0);
		end
		else
		begin
			assert(__formal__out_wait_for_me__busy == 1);
		end

		case (__wr_state)
		__ENUM__WRITE_STATE__IDLE:
		begin
			assert(__formal__out_mem_read__req == 0);
			assert(__formal__out_mem_write__req == 0);
		end

		__ENUM__WRITE_STATE__START_LD_ST:
		begin
			assert($past(__formal__in_wr__req)
				&& ($past(__formal__in_wr__index) != 0));
			assert(__captured_in_wr__index != 0);
			assert(__captured_in_mem_read__valid == 0);
			assert(__captured_in_mem_write__valid == 0);

			assert ($past(__wr_state) == __ENUM__WRITE_STATE__IDLE);
		end

		__ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_READ:
		begin
			assert(__captured_in_wr__write_type
				== __ENUM__WRITE_TYPE__LD);

			assert(($past(__wr_state) == __ENUM__WRITE_STATE__START_LD_ST)
				|| ($past(__wr_state)
				== __ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_READ));

			assert(!__formal__out_mem_write__req);
			assert(__formal__out_mem_read__base_addr
				== 
		__captured_in_wr__base_addr
		[__INCOMING_BASE_ADDR__INDEX_HI : __INCOMING_BASE_ADDR__INDEX_LO]);

			if ($past(__wr_state)
				== __ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_READ)
			begin
				assert(!__formal__out_mem_read__req);
				assert($stable(__formal__out_mem_read__base_addr));
			end
			else
			begin
				assert(__formal__out_mem_read__req);
				assert(__formal__out_mem_read__base_addr
					== 
		__captured_in_wr__base_addr
		[__INCOMING_BASE_ADDR__INDEX_HI : __INCOMING_BASE_ADDR__INDEX_LO]);
			end

			assert($stable(__captured_in_wr__write_type));
			assert($stable(__captured_in_wr__base_addr));
			assert($stable(__captured_in_wr__index));
			assert($stable(__captured_in_wr__data_type));
			assert($stable(__captured_in_wr__int_type_size));
		end
		__ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_WRITE:
		begin
			assert(__captured_in_wr__write_type
				>= __ENUM__WRITE_TYPE__LD);
			assert(($past(__wr_state) == __ENUM__WRITE_STATE__START_LD_ST)
				|| ($past(__wr_state)
				== __ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_WRITE));

			assert(!__formal__out_mem_read__req);

			if ($past(__wr_state)
				== __ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_WRITE)
			begin
				assert(!__formal__out_mem_write__req);
				assert($stable(__formal__out_mem_write__base_addr));
				assert($stable(__formal__out_mem_write__data));
			end
			else
			begin
				assert(__formal__out_mem_write__req);
				//assert(__formal__out_mem_write__base_addr
				//	== ($past(__lar_shareddata__base_addr
				//	[$past(__lar_metadata__tag
				//	[__captured_in_wr__index])])));
				//assert(__formal__out_mem_write__data
				//	== (__lar_shareddata__data
				//	[$past(__lar_metadata__tag
				//	[__captured_in_wr__index])]));
				//assert(__formal__out_mem_write__base_addr
				//	== $past(__lar_shareddata__base_addr
				//	[$past(__lar_metadata__tag
				//	[__captured_in_wr__index])]));
				assert(__formal__out_mem_write__base_addr
					== __debug_lar_shareddata__base_addr
					[__debug_lar_metadata__tag[__captured_in_wr__index]]);
				assert(__formal__out_mem_write__data
					== __debug_lar_shareddata__data
					[__debug_lar_metadata__tag[__captured_in_wr__index]]);
			end

			assert($stable(__captured_in_wr__write_type));
			assert($stable(__captured_in_wr__base_addr));
			assert($stable(__captured_in_wr__index));
			assert($stable(__captured_in_wr__data_type));
			assert($stable(__captured_in_wr__int_type_size));
		end

		__ENUM__WRITE_STATE__WAIT_FOR_MEM_READ_AND_MEM_WRITE:
		begin
			assert(__captured_in_wr__write_type
				== __ENUM__WRITE_TYPE__LD);

			assert(($past(__wr_state) == __ENUM__WRITE_STATE__START_LD_ST)
				|| ($past(__wr_state)
				== __ENUM__WRITE_STATE__WAIT_FOR_MEM_READ_AND_MEM_WRITE));

			assert(__formal__out_mem_read__base_addr
				== 
		__captured_in_wr__base_addr
		[__INCOMING_BASE_ADDR__INDEX_HI : __INCOMING_BASE_ADDR__INDEX_LO]);

			if ($past(__wr_state)
				== __ENUM__WRITE_STATE__WAIT_FOR_MEM_READ_AND_MEM_WRITE)
			begin
				assert(!__formal__out_mem_read__req);
				assert(!__formal__out_mem_write__req);

				assert($stable(__formal__out_mem_read__base_addr));
				assert($stable(__formal__out_mem_write__base_addr));
				assert($stable(__formal__out_mem_write__data));
			end

			else
			begin
				assert(__formal__out_mem_read__req);
				assert(__formal__out_mem_write__req);

				assert(__formal__out_mem_read__base_addr
					== 
		__captured_in_wr__base_addr
		[__INCOMING_BASE_ADDR__INDEX_HI : __INCOMING_BASE_ADDR__INDEX_LO]);
				//assert(__formal__out_mem_write__base_addr
				//	== ($past(__lar_shareddata__base_addr
				//	[$past(__lar_metadata__tag
				//	[__captured_in_wr__index])])));
				//assert(__formal__out_mem_write__data
				//	== (__lar_shareddata__data
				//	[$past(__lar_metadata__tag
				//	[__captured_in_wr__index])]));

				//assert(__formal__out_mem_write__base_addr
				//	== $past(__lar_shareddata__base_addr
				//	[$past(__lar_metadata__tag
				//	[__captured_in_wr__index])]));
				//assert(__formal__out_mem_write__base_addr
				//	== $past(__lar_shareddata__base_addr
				//	[$past(__lar_metadata__tag
				//	[__captured_in_wr__index])]));
				assert(__formal__out_mem_write__base_addr
					== __debug_lar_shareddata__base_addr
					[__debug_lar_metadata__tag[__captured_in_wr__index]]);
				assert(__formal__out_mem_write__data
					== __debug_lar_shareddata__data
					[__debug_lar_metadata__tag[__captured_in_wr__index]]);
			end

			//if ($past(__wr_state) == __ENUM__WRITE_STATE__START_LD_ST)
			//begin
			//	assert(__formal__out_mem_write__base_addr
			//		== $past(__lar_shareddata__base_addr
			//		[$past(__lar_metadata__tag
			//		[__captured_in_wr__index])]));
			//end

			assert($stable(__captured_in_wr__write_type));
			assert($stable(__captured_in_wr__base_addr));
			assert($stable(__captured_in_wr__index));
			assert($stable(__captured_in_wr__data_type));
			assert($stable(__captured_in_wr__int_type_size));
		end
		endcase

		assert(__wr_state < __ENUM__WRITE_STATE__BAD_0);

		//for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
		//begin
		//	assert(__found_indices[i] == 0);
		//end
		//assert(__eek == 0);


		__num_unique_tags = 0;
		assert(__num_unique_tags == 0);

		for (i=1; i<__ARR_SIZE__NUM_LARS; i=i+1)
		begin
			__unique_tags[i] = 0;
			assert(__unique_tags[i] == 0);
		end

		//for (i=1; i<__ARR_SIZE__NUM_LARS; i=i+1)
		//begin
		//	if (__lar_metadata__tag[i] != 0)
		//	begin
		//		__found_unique_tag = 0;
		//		assert(__found_unique_tag == 0);

		//		for (j=1; j<__ARR_SIZE__NUM_LARS; j=j+1)
		//		begin
		//			if ((__unique_tags[j] != 0) && (j < __num_unique_tags))
		//			begin
		//				if (__unique_tags[j] == __lar_metadata__tag[i])
		//				begin
		//					__found_unique_tag = 1;
		//				end
		//			end
		//		end

		//		if (!__found_unique_tag)
		//		begin
		//			__unique_tags[__num_unique_tags]
		//				= __lar_metadata__tag[i];
		//			__num_unique_tags = __num_unique_tags + 1;
		//		end
		//	end
		//end

		for (i=1; i<__ARR_SIZE__NUM_LARS; i=i+1)
		begin
			if (__lar_metadata__tag[i] != 0)
			begin
				__found_unique_tag = 0;
				assert(__found_unique_tag == 0);

				if (__unique_tags[__lar_metadata__tag[i]])
				begin
					__found_unique_tag = 1;
				end

				if (!__found_unique_tag)
				begin
					__unique_tags[__lar_metadata__tag[i]] = 1;
					__num_unique_tags = __num_unique_tags + 1;
				end
			end
		end



		for (i=1; i<__ARR_SIZE__NUM_LARS; i=i+1)
		begin
			__tags_that_should_be_in_stack[i] = 1;
			assert(__tags_that_should_be_in_stack[i] == 1);
		end

		//for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
		//begin
		//	if ((__unique_tags[i] != 0) && (i < __num_unique_tags))
		//	begin
		//		__tags_that_should_be_in_stack[i] = 0;
		//		assert(__tags_that_should_be_in_stack[i] == 0);
		//	end
		//end

		for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
		begin
			if (__lar_shareddata__ref_count[i])
			begin
				__tags_that_should_be_in_stack[i] = 0;
			end
		end

		for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
		begin
			__found_tag_in_stack = 0;
			__found_tag_outside_stack = 0;

			for (j=0; j<__ARR_SIZE__NUM_LARS; j=j+1)
			begin
				// in stack
				if (j <= __curr_tag_stack_index)
				begin
					if (__lar_tag_stack[j] == i)
					begin
						assert(!__found_tag_in_stack);
						__found_tag_in_stack = 1;
					end
				end

				// outside of stack
				else // if (j > __curr_tag_stack_index)
				begin
					if (__lar_tag_stack[j] == i)
					begin
						//assert(!__found_tag_outside_stack);
						__found_tag_outside_stack = 1;
					end
				end
			end

			if (__tags_that_should_be_in_stack[i])
			begin
				assert(__found_tag_in_stack);
				//assert(!__found_tag_outside_stack);
			end

			else // if (!__tags_that_should_be_in_stack[i])
			begin
				assert(!__found_tag_in_stack);
				//assert(__found_tag_outside_stack);
			end
		end

		for (i=1; i<__ARR_SIZE__NUM_LARS; i=i+1)
		begin
			__found_tags_per_ref[i] = 0;

			for (j=0; j<__ARR_SIZE__NUM_LARS; j=j+1)
			begin
				if (__lar_metadata__tag[j] == i)
				begin
					__found_tags_per_ref[i] = __found_tags_per_ref[i] + 1;
				end
			end

			assert(__found_tags_per_ref[i]
				== __lar_shareddata__ref_count[i]);
		end

		__total_num_references = 0;
		assert(__total_num_references == 0);

		for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
		begin
			__total_num_references = __total_num_references
				+ __lar_shareddata__ref_count[i];
		end

		// Less than __ARR_SIZE__NUM_LARS because there are only 15
		// allocatable LARs, not 16, due to dzero always being zero.
		assert(__total_num_references < __ARR_SIZE__NUM_LARS);

		if (__curr_tag_stack_index < __LAST_INDEX__NUM_LARS)
		begin
			assert(__total_num_references > 0);
		end


		//if (__total_num_references > 0)
		//begin
		//	assert((__LAST_INDEX__NUM_LARS - __curr_tag_stack_index)
		//		== __num_unique_tags);
		//end
		//else
		if (__total_num_references == 0)
		begin
			assert(__num_unique_tags == 0);
		end

		if (__wr_state > __ENUM__WRITE_STATE__START_LD_ST)
		begin
			if ($past(__curr_tag_stack_index) != __curr_tag_stack_index)
			begin
				assert((__curr_tag_stack_index
					== ($past(__curr_tag_stack_index) - 1))
					|| (__curr_tag_stack_index
					== ($past(__curr_tag_stack_index) + 1)));

				// It had to have been a write that changed the stack index.
				assert($past(__formal__in_wr__req, 2));
			end
		end

		//__did_find_mem_write = 0;

		//for (i=1; i<__ARR_SIZE__NUM_LARS; i=i+1)
		//begin
		//	if (($past(__lar_shareddata__ref_count[i]) == 1)
		//		&& (__lar_shareddata__ref_count[i] == 0))
		//	begin
		//		assert(__did_find_mem_write == 0);
		//		assert(__formal__out_mem_write__req == 1);
		//		assert(__formal__out_mem_write__data
		//			== __debug_lar_shareddata__data[i]);
		//		assert(__formal__out_mem_write__base_addr
		//			== __debug_lar_shareddata__base_addr[i]);
		//		__did_find_mem_write = 1;
		//	end
		//end

		//if (__did_find_mem_write == 0)
		//begin
		//	assert(__formal__out_mem_write__req == 0);
		//end


		if ($past(__curr_tag_stack_index) == 0)
		begin
			assert(__curr_tag_stack_index != __LAST_INDEX__NUM_LARS);
		end

		else if ($past(__curr_tag_stack_index) == __LAST_INDEX__NUM_LARS)
		begin
			assert(__curr_tag_stack_index != 0);
		end

		// dzero must remain zero!
		assert(__lar_metadata__tag[0] == 0);
		assert(__lar_metadata__data_index[0] == 0);
		assert(__lar_metadata__data_type[0] == 0);
		assert(__lar_metadata__int_type_size[0] == 0);
		assert(__lar_shareddata__data[0] == 0);
		assert(__lar_shareddata__base_addr[0] == 0);
		assert(__lar_shareddata__ref_count[0] == 0);
		assert(__lar_shareddata__dirty[0] == 0);
		assert(__lar_tag_stack[0] == 0);

		for (i=1; i<__ARR_SIZE__NUM_LARS; i=i+1)
		begin
			assert(__lar_tag_stack[i] != 0);
		end

		if (__found_tag)
		begin
			assert(__debug_tag_search_final != 0);
		end

		//if (__debug_lar_metadata__tag[`PAST_READ_INDEX(a)]
		//	== __debug_lar_metadata__tag[`PAST_READ_INDEX(b)])
		//begin
		//	assert(__debug_lar_metadata__whole_addr[`PAST_READ_INDEX(a)]
		//		[__INCOMING_BASE_ADDR__INDEX_HI
		//		: __INCOMING_BASE_ADDR__INDEX_LO]
		//		== __debug_lar_metadata__whole_addr[`PAST_READ_INDEX(b)]
		//		[__INCOMING_BASE_ADDR__INDEX_HI
		//		: __INCOMING_BASE_ADDR__INDEX_LO]);
		//end

		//for (i=1; i<__ARR_SIZE__NUM_LARS; i=i+1)
		//begin
		//	for (j=1; j<__ARR_SIZE__NUM_LARS; j=j+1)
		//	begin
		//		if (__lar_metadata__tag[i] == __lar_metadata__tag[j])
		//		begin
		//			assert(__lar_metadata__whole_addr[i]
		//				[__INCOMING_BASE_ADDR__INDEX_HI
		//				: __INCOMING_BASE_ADDR__INDEX_LO]
		//				== __lar_metadata__whole_addr[j]
		//				[__INCOMING_BASE_ADDR__INDEX_HI
		//				: __INCOMING_BASE_ADDR__INDEX_LO]);
		//		end
		//	end
		//end

		for (i=1; i<__ARR_SIZE__NUM_LARS; i=i+1)
		begin
			case (__lar_metadata__data_type[i])
			__ENUM__DATA_TYPE__RESERVED:
			begin
				assert(__lar_metadata__data_index[i] == 0);
			end

			__ENUM__DATA_TYPE__BFLOAT16:
			begin
				assert(__lar_metadata__data_index[i][0] == 0);
			end

			default:
			begin
				case (__lar_metadata__int_type_size[i])
				__ENUM__INT_TYPE_SIZE__8:
				begin
				end

				__ENUM__INT_TYPE_SIZE__16:
				begin
					assert(__lar_metadata__data_index[i][0] == 0);
				end

				__ENUM__INT_TYPE_SIZE__32:
				begin
					assert(__lar_metadata__data_index[i][1:0] == 0);
				end

				__ENUM__INT_TYPE_SIZE__64:
				begin
					assert(__lar_metadata__data_index[i][2:0] == 0);
				end
				endcase
			end
			endcase
		end

		for (i=1; i<__ARR_SIZE__NUM_LARS; i=i+1)
		begin
			assert(__debug_lar_metadata__tag[i]
				== $past(__lar_metadata__tag[i]));
			assert(__debug_lar_metadata__data_index[i]
				== $past(__lar_metadata__data_index[i]));
			assert(__debug_lar_metadata__data_type[i]
				== $past(__lar_metadata__data_type[i]));
			assert(__debug_lar_metadata__int_type_size[i]
				== $past(__lar_metadata__int_type_size[i]));

			assert(__debug_lar_shareddata__data[i]
				== $past(__lar_shareddata__data[i]));
			assert(__debug_lar_shareddata__base_addr[i]
				== $past(__lar_shareddata__base_addr[i]));
			assert(__debug_lar_shareddata__dirty[i]
				== $past(__lar_shareddata__dirty[i]));
			assert(__debug_lar_shareddata__ref_count[i]
				== $past(__lar_shareddata__ref_count[i]));
		end

		if ($past(__formal__in_rd_a__index) != 0)
		begin
			assert(__formal__out_rd_a__addr 
				== {__debug_lar_shareddata__base_addr
				[__debug_lar_metadata__tag[$past(__formal__in_rd_a__index)]],
				__debug_lar_metadata__data_index[$past(__formal__in_rd_a__index)]});
			assert(__formal__out_rd_a__data
				== __debug_lar_shareddata__data
				[__debug_lar_metadata__tag[$past(__formal__in_rd_a__index)]]);
			assert(__formal__out_rd_a__data_type
				== __debug_lar_metadata__data_type[$past(__formal__in_rd_a__index)]);
			assert(__formal__out_rd_a__int_type_size
				== __debug_lar_metadata__int_type_size
				[$past(__formal__in_rd_a__index)]);
			assert(__formal__out_rd_a__tag
				== __debug_lar_metadata__tag[$past(__formal__in_rd_a__index)]);
		end
		else // if (`PAST_READ_INDEX(a) == 0)
		begin
			assert(__formal__out_rd_a__addr == 0);
			assert(__formal__out_rd_a__data == 0);
			assert(__formal__out_rd_a__data_type == 0);
			assert(__formal__out_rd_a__int_type_size == 0);
			assert(__formal__out_rd_a__tag == 0);
		end

		if ($past(__formal__in_rd_b__index) != 0)
		begin
			assert(__formal__out_rd_b__addr 
				== {__debug_lar_shareddata__base_addr
				[__debug_lar_metadata__tag[$past(__formal__in_rd_b__index)]],
				__debug_lar_metadata__data_index[$past(__formal__in_rd_b__index)]});
			assert(__formal__out_rd_b__data
				== __debug_lar_shareddata__data
				[__debug_lar_metadata__tag[$past(__formal__in_rd_b__index)]]);
			assert(__formal__out_rd_b__data_type
				== __debug_lar_metadata__data_type[$past(__formal__in_rd_b__index)]);
			assert(__formal__out_rd_b__int_type_size
				== __debug_lar_metadata__int_type_size
				[$past(__formal__in_rd_b__index)]);
			assert(__formal__out_rd_b__tag
				== __debug_lar_metadata__tag[$past(__formal__in_rd_b__index)]);
		end
		else // if (`PAST_READ_INDEX(b) == 0)
		begin
			assert(__formal__out_rd_b__addr == 0);
			assert(__formal__out_rd_b__data == 0);
			assert(__formal__out_rd_b__data_type == 0);
			assert(__formal__out_rd_b__int_type_size == 0);
			assert(__formal__out_rd_b__tag == 0);
		end

		if ($past(__formal__in_rd_c__index) != 0)
		begin
			assert(__formal__out_rd_c__addr 
				== {__debug_lar_shareddata__base_addr
				[__debug_lar_metadata__tag[$past(__formal__in_rd_c__index)]],
				__debug_lar_metadata__data_index[$past(__formal__in_rd_c__index)]});
			assert(__formal__out_rd_c__data
				== __debug_lar_shareddata__data
				[__debug_lar_metadata__tag[$past(__formal__in_rd_c__index)]]);
			assert(__formal__out_rd_c__data_type
				== __debug_lar_metadata__data_type[$past(__formal__in_rd_c__index)]);
			assert(__formal__out_rd_c__int_type_size
				== __debug_lar_metadata__int_type_size
				[$past(__formal__in_rd_c__index)]);
			assert(__formal__out_rd_c__tag
				== __debug_lar_metadata__tag[$past(__formal__in_rd_c__index)]);
		end
		else // if (`PAST_READ_INDEX(c) == 0)
		begin
			assert(__formal__out_rd_c__addr == 0);
			assert(__formal__out_rd_c__data == 0);
			assert(__formal__out_rd_c__data_type == 0);
			assert(__formal__out_rd_c__int_type_size == 0);
			assert(__formal__out_rd_c__tag == 0);
		end


		
		
		
		
		
		

		
		

		


		
		
		
		

		
		
		
		


	end
	end
			// SVFORMAL


endmodule










































		// src__slash__snow64_instr_decoder_defines_header_sv


// I honestly don't think there's a need to formally verify the instruction
// decoder.
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
			//out.stall = ((__iog0_instr.oper 
			//	== PkgSnow64InstrDecoder::Mul_ThreeRegs)
			//	|| (__iog0_instr.oper
			//	== PkgSnow64InstrDecoder::Div_ThreeRegs));
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
		end

		1:
		begin
			out.oper = __iog1_instr.oper;
			//out.stall = 0;

			// out.nop 
			// = (__iog1_instr.oper 
			// 	<= PkgSnow64InstrDecoder::Bad0_Iog1);
			out.nop = (__iog1_instr.oper[3] && __iog1_instr.oper[2]);

			out.signext_imm 
				= 


	{{(PkgSnow64InstrDecoder::WIDTH__ADDR - PkgSnow64InstrDecoder::WIDTH__IOG1_SIMM20)
	{__iog1_instr.simm20[((PkgSnow64InstrDecoder::WIDTH__IOG1_SIMM20) - 1)]}},__iog1_instr.simm20};
		end

		2:
		begin
			out.oper = __iog2_instr.oper;
			//out.stall = __iog2_instr.oper;

			// out.nop = (__iog2_instr.oper
			// 	>= PkgSnow64InstrDecoder::Bad0_Iog2);
			out.nop = ((__iog2_instr.oper 
				!= PkgSnow64InstrDecoder::LdF16_ThreeRegsOneSimm12)
				&& (__iog2_instr.oper[3]));

			out.signext_imm 
				= 


	{{(PkgSnow64InstrDecoder::WIDTH__ADDR - PkgSnow64InstrDecoder::WIDTH__IOG2_SIMM12)
	{__iog2_instr.simm12[((PkgSnow64InstrDecoder::WIDTH__IOG2_SIMM12) - 1)]}},__iog2_instr.simm12};
		end

		3:
		begin
			out.oper = __iog3_instr.oper;
			//out.stall = __iog3_instr.oper;

			// out.nop = (__iog3_instr.oper
			// 	>= PkgSnow64InstrDecoder::Bad0_Iog3);
			out.nop = ((__iog3_instr.oper 
				!= PkgSnow64InstrDecoder::StF16_ThreeRegsOneSimm12)
				&& (__iog3_instr.oper[3]));

			out.signext_imm 
				= 


	{{(PkgSnow64InstrDecoder::WIDTH__ADDR - PkgSnow64InstrDecoder::WIDTH__IOG3_SIMM12)
	{__iog3_instr.simm12[((PkgSnow64InstrDecoder::WIDTH__IOG3_SIMM12) - 1)]}},__iog3_instr.simm12};
		end

		4:
		begin
			out.oper = __iog4_instr.oper;
			//out.stall = __iog4_instr.oper;

			// out.nop = (__iog4_instr.oper
			// 	>= PkgSnow64InstrDecoder::Bad0_Iog4);
			out.nop = ((__iog4_instr.oper 
				!= PkgSnow64InstrDecoder::Out_TwoRegsOneSimm16)
				&& (__iog4_instr.oper[3]));

			out.signext_imm 
				= 


	{{(PkgSnow64InstrDecoder::WIDTH__ADDR - PkgSnow64InstrDecoder::WIDTH__IOG4_SIMM16)
	{__iog4_instr.simm16[((PkgSnow64InstrDecoder::WIDTH__IOG4_SIMM16) - 1)]}},__iog4_instr.simm16};
		end

		// Eek!
		default:
		begin
			out.oper = 0;
			//out.stall = 0;
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













		// src__slash__snow64_memory_access_fifo_defines_header_sv

module Snow64MemoryAccessReadFifo(input logic clk,
	input PkgSnow64MemoryAccessFifo::PortIn_MemoryAccessReadFifo in,
	output PkgSnow64MemoryAccessFifo::PortOut_MemoryAccessReadFifo out);

	PkgSnow64MemoryAccessFifo::PartialPortIn_ReadFifo_ReqRead
		real_in_req_read;
	assign real_in_req_read = in.req_read;

	PkgSnow64MemoryAccessFifo::PartialPortIn_ReadFifo_FromMemoryBusGuard
		real_in_from_memory_bus_guard;
	assign real_in_from_memory_bus_guard = in.from_memory_bus_guard;

	PkgSnow64MemoryAccessFifo::PartialPortOut_ReadFifo_ReqRead
		real_out_req_read;
	assign out.req_read = real_out_req_read;


	PkgSnow64MemoryAccessFifo::PartialPortOut_ReadFifo_ToMemoryBusGuard
		real_out_to_memory_bus_guard;
	assign out.to_memory_bus_guard = real_out_to_memory_bus_guard;


	logic __state;
	logic __cmd_was_accepted;


	
	localparam __ENUM__STATE__IDLE
		= PkgSnow64MemoryAccessFifo::RdFifoStIdle;
	localparam __ENUM__STATE__WAIT_FOR_MEM
		= PkgSnow64MemoryAccessFifo::RdFifoStWaitForMem;

	wire __formal__in_req_read__req = real_in_req_read.req;
	wire [((64) - 1):0] __formal__in_req_read__addr
		= real_in_req_read.addr;

	wire __formal__in_from_memory_bus_guard__valid
		= real_in_from_memory_bus_guard.valid;
	wire __formal__in_from_memory_bus_guard__cmd_accepted
		= real_in_from_memory_bus_guard.cmd_accepted;
	wire [
	((256) - 1):0]
		__formal__in_from_memory_bus_guard__data
		= real_in_from_memory_bus_guard.data;

	wire __formal__out_req_read__valid = real_out_req_read.valid;
	wire __formal__out_req_read__busy = real_out_req_read.busy;
	wire [
	((256) - 1):0] __formal__out_req_read__data
		= real_out_req_read.data;

	wire __formal__out_to_memory_bus_guard__req
		= real_out_to_memory_bus_guard.req;
	wire [((64) - 1):0]
		__formal__out_to_memory_bus_guard__addr
		= real_out_to_memory_bus_guard.addr;
			// FORMAL

	initial
	begin
		__state = PkgSnow64MemoryAccessFifo::RdFifoStIdle;
		__cmd_was_accepted = 0;

		real_out_req_read = 0;
		real_out_to_memory_bus_guard = 0;
	end

	always_ff @(posedge clk)
	begin
		case (__state)
		PkgSnow64MemoryAccessFifo::RdFifoStIdle:
		begin
			real_out_req_read.valid <= 0;

			if (real_in_req_read.req)
			begin
				__state <= PkgSnow64MemoryAccessFifo::RdFifoStWaitForMem;

				real_out_to_memory_bus_guard.req <= 1;
				real_out_to_memory_bus_guard.addr <= real_in_req_read.addr;

				real_out_req_read.busy <= 1;

				__cmd_was_accepted <= 0;
			end

			else // if (!real_in_req_read.req)
			begin
				real_out_to_memory_bus_guard.req <= 0;
				real_out_req_read.busy <= 0;
			end
		end

		PkgSnow64MemoryAccessFifo::RdFifoStWaitForMem:
		begin
			if (real_in_from_memory_bus_guard.cmd_accepted)
			begin
				__cmd_was_accepted <= 1;
				real_out_to_memory_bus_guard.req <= 0;
			end

			// ...On the off chance that SOMEHOW the memory bus guard
			// already has our data, we can make this work.
			if ((real_in_from_memory_bus_guard.cmd_accepted
				|| __cmd_was_accepted)
				&& (real_in_from_memory_bus_guard.valid))
			begin
				// Grant the requested data.
				__state <= PkgSnow64MemoryAccessFifo::RdFifoStIdle;

				real_out_req_read.valid <= 1;
				real_out_req_read.busy <= 0;
				real_out_req_read.data
					<= real_in_from_memory_bus_guard.data;
			end
		end
		endcase
	end


endmodule

module Snow64MemoryAccessWriteFifo(input logic clk,
	input PkgSnow64MemoryAccessFifo::PortIn_MemoryAccessWriteFifo in,
	output PkgSnow64MemoryAccessFifo::PortOut_MemoryAccessWriteFifo out);

	PkgSnow64MemoryAccessFifo::PartialPortIn_WriteFifo_ReqWrite
		real_in_req_write;
	assign real_in_req_write = in.req_write;

	PkgSnow64MemoryAccessFifo::PartialPortIn_WriteFifo_FromMemoryBusGuard
		real_in_from_memory_bus_guard;
	assign real_in_from_memory_bus_guard = in.from_memory_bus_guard;

	PkgSnow64MemoryAccessFifo::PartialPortOut_WriteFifo_ReqWrite
		real_out_req_write;
	assign out.req_write = real_out_req_write;


	PkgSnow64MemoryAccessFifo::PartialPortOut_WriteFifo_ToMemoryBusGuard
		real_out_to_memory_bus_guard;
	assign out.to_memory_bus_guard = real_out_to_memory_bus_guard;


	logic __state;
	logic __cmd_was_accepted;


	
	localparam __ENUM__STATE__IDLE
		= PkgSnow64MemoryAccessFifo::WrFifoStIdle;
	localparam __ENUM__STATE__WAIT_FOR_MEM
		= PkgSnow64MemoryAccessFifo::WrFifoStWaitForMem;

	wire __formal__in_req_write__req = real_in_req_write.req;
	wire [((64) - 1):0] __formal__in_req_write__addr
		= real_in_req_write.addr;

	wire __formal__in_from_memory_bus_guard__valid
		= real_in_from_memory_bus_guard.valid;
	wire __formal__in_from_memory_bus_guard__cmd_accepted
		= real_in_from_memory_bus_guard.cmd_accepted;
	wire [
	((256) - 1):0] __formal__in_req_write__data
		= real_in_req_write.data;

	wire __formal__out_req_write__valid = real_out_req_write.valid;
	wire __formal__out_req_write__busy = real_out_req_write.busy;

	wire __formal__out_to_memory_bus_guard__req
		= real_out_to_memory_bus_guard.req;
	wire [((64) - 1):0]
		__formal__out_to_memory_bus_guard__addr
		= real_out_to_memory_bus_guard.addr;
	wire [
	((256) - 1):0]
		__formal__out_to_memory_bus_guard__data
		= real_out_to_memory_bus_guard.data;
			// FORMAL

	initial
	begin
		__state = PkgSnow64MemoryAccessFifo::WrFifoStIdle;
		__cmd_was_accepted = 0;

		real_out_req_write = 0;
		real_out_to_memory_bus_guard = 0;
	end

	always_ff @(posedge clk)
	begin
		case (__state)
		PkgSnow64MemoryAccessFifo::WrFifoStIdle:
		begin
			real_out_req_write.valid <= 0;

			if (real_in_req_write.req)
			begin
				__state <= PkgSnow64MemoryAccessFifo::WrFifoStWaitForMem;

				real_out_to_memory_bus_guard.req <= 1;
				real_out_to_memory_bus_guard.addr <= real_in_req_write.addr;
				real_out_to_memory_bus_guard.data
					<= real_in_req_write.data;


				real_out_req_write.busy <= 1;

				__cmd_was_accepted <= 0;
			end

			else // if (!real_in_req_write.req)
			begin
				real_out_to_memory_bus_guard.req <= 0;
				real_out_req_write.busy <= 0;
			end
		end

		PkgSnow64MemoryAccessFifo::WrFifoStWaitForMem:
		begin
			if (real_in_from_memory_bus_guard.cmd_accepted)
			begin
				__cmd_was_accepted <= 1;
				real_out_to_memory_bus_guard.req <= 0;
			end

			// ...On the off chance that SOMEHOW the memory bus guard
			// already has our data, we can make this work.
			if ((real_in_from_memory_bus_guard.cmd_accepted
				|| __cmd_was_accepted)
				&& (real_in_from_memory_bus_guard.valid))
			begin
				// Grant the requested data.
				__state <= PkgSnow64MemoryAccessFifo::WrFifoStIdle;

				real_out_req_write.valid <= 1;
				real_out_req_write.busy <= 0;
				//real_out_req_write.data
				//	<= real_in_from_memory_bus_guard.data;
			end
		end
		endcase
	end


endmodule
