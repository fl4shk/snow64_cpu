`include "src/snow64_alu_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"

// 8-bit ALU with carry in, carry out, the size of the operands of the
// overall operation, and an index indicating which sub ALU we are (used to
// determine whether or not to use 'in.carry")
module __Snow64SubAlu(input PkgSnow64Alu::PortIn_SubAlu in,
	output PkgSnow64Alu::PortOut_SubAlu out);

	localparam __MSB_POS__DATA_INOUT
		= `MSB_POS__SNOW64_SUB_ALU_DATA_INOUT;

	//struct packed
	//{
	//	logic in_actual_carry;
	//} __locals;

	logic __in_actual_carry;
	logic __out_lts;
	logic __performing_subtract;

	SetLessThanSigned __inst_slts
		(.in_a_msb_pos(in.a[__MSB_POS__DATA_INOUT]),
		.in_b_msb_pos(in.b[__MSB_POS__DATA_INOUT]),
		.in_sub_result_msb_pos(out.data[__MSB_POS__DATA_INOUT]),
		.out_data(__out_lts));

	// Performing a subtract means that we need __in_actual_carry to
	// be set to 1'b1 **if we're ignoring in.carry**.
	assign __performing_subtract = ((in.oper == PkgSnow64Alu::OpSub)
		|| (in.oper == PkgSnow64Alu::OpSlt));


	// Determine if we need to use "in.carry"
	always @(*)
	begin
		case (in.type_size)

		// 8-bit operations don't care about "in.carry".
		PkgSnow64Cpu::TypSz8:
		begin
			__in_actual_carry = __performing_subtract;
		end

		// For 16-bit operations, a sub ALU with an odd-numbered index will
		// need to use "in.carry"
		PkgSnow64Cpu::TypSz16:
		begin
			case (in.index[0])
			0:
			begin
				__in_actual_carry = __performing_subtract;
			end

			//1:
			default:
			begin
				__in_actual_carry = in.carry;
			end
			endcase
		end

		// For 32-bit operations, we care about carry for only two cases:
		// (in.index == 0) or (in.index == 4).
		PkgSnow64Cpu::TypSz32:
		begin
			case (in.index[1:0])
			0:
			begin
				//__in_actual_carry = 1'b0;
				__in_actual_carry = __performing_subtract;
			end

			default:
			begin
				__in_actual_carry = in.carry;
			end
			endcase
		end

		// 64-bit operations do indeed care about carry, but only if the
		// index is zero.
		PkgSnow64Cpu::TypSz64:
		begin
			case (in.index[2:0])
			0:
			begin
				//__in_actual_carry = 1'b0;
				__in_actual_carry = __performing_subtract;
			end

			default:
			begin
				__in_actual_carry = in.carry;
			end
			endcase
		end
		endcase
	end

	always @(*)
	begin
		case (in.oper)
		PkgSnow64Alu::OpAdd:
		begin
			{out.carry, out.data} = in.a + in.b
				+ {{`WIDTH__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
				__in_actual_carry};
		end

		PkgSnow64Alu::OpSub:
		begin
			{out.carry, out.data} = {1'b0, in.a} + {1'b0, (~in.b)}
				+ {{`WIDTH__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
				__in_actual_carry};
		end

		// Just repeat the "OpSub" stuff here.
		PkgSnow64Alu::OpSlt:
		begin
			{out.carry, out.data} = {1'b0, in.a} + {1'b0, (~in.b)}
				+ {{`WIDTH__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
				__in_actual_carry};
		end
		PkgSnow64Alu::OpAnd:
		begin
			{out.carry, out.data} = in.a & in.b;
		end
		PkgSnow64Alu::OpOrr:
		begin
			{out.carry, out.data} = in.a | in.b;
		end
		PkgSnow64Alu::OpXor:
		begin
			{out.carry, out.data} = in.a ^ in.b;
		end
		PkgSnow64Alu::OpInv:
		begin
			{out.carry, out.data} = ~in.a;
		end
		//PkgSnow64Alu::OpNot:
		//begin
		//	// This is only used for 8-bit stuff
		//	{out.carry, out.data} = !in.a;
		//end

		// Just repeat the "OpAdd" stuff here.
		PkgSnow64Alu::OpAddAgain:
		begin
			{out.carry, out.data} = in.a + in.b
				+ {{`MSB_POS__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
				__in_actual_carry};
		end

		default:
		begin
			{out.carry, out.data} = 0;
		end
		endcase
	end

	always @(*)
	begin
		out.lts = __out_lts;
	end

endmodule

//`define SET_ASR_INPUTS_SIGNEXT(some_full_width, some_asr_num, 
//	in_data_sliced_num, data_num) \
//	__in_asr``some_full_width``_``some_asr_num.to_shift \
//		= `SIGN_EXTEND(some_full_width, in_data_sliced_num, \
//		__in_a_sliced_``in_data_sliced_num.data_``data_num); \
//	__in_asr``some_full_width``_``some_asr_num.amount \
//		= `ZERO_EXTEND(some_full_width, in_data_sliced_num, \
//		__in_b_sliced_``in_data_sliced_num.data_``data_num);
//`define SET_ASR_INPUTS(some_full_width, some_asr_num, in_data_sliced_num,
//	data_num) \
//	__in_asr``some_full_width``_``some_asr_num.to_shift \
//		= __in_a_sliced_``in_data_sliced_num.data_``data_num; \
//	__in_asr``some_full_width``_``some_asr_num.amount \
//		= __in_b_sliced_``in_data_sliced_num.data_``data_num;
//

`define MAKE_INNER_SHIFT_FOR_ALU_PORTS(in_prefix, out_prefix) \
PkgSnow64Alu::`INST_8__7(PortIn_InnerShiftForAlu) \
	`INST_8__7(in_prefix); \
PkgSnow64Alu::`INST_8__7(PortOut_InnerShiftForAlu) \
	`INST_8__7(out_prefix); \
PkgSnow64Alu::`INST_8__6(PortIn_InnerShiftForAlu) \
	`INST_8__6(in_prefix); \
PkgSnow64Alu::`INST_8__6(PortOut_InnerShiftForAlu) \
	`INST_8__6(out_prefix); \
PkgSnow64Alu::`INST_8__5(PortIn_InnerShiftForAlu) \
	`INST_8__5(in_prefix); \
PkgSnow64Alu::`INST_8__5(PortOut_InnerShiftForAlu) \
	`INST_8__5(out_prefix); \
PkgSnow64Alu::`INST_8__4(PortIn_InnerShiftForAlu) \
	`INST_8__4(in_prefix); \
PkgSnow64Alu::`INST_8__4(PortOut_InnerShiftForAlu) \
	`INST_8__4(out_prefix); \
PkgSnow64Alu::`INST_8__3(PortIn_InnerShiftForAlu) \
	`INST_8__3(in_prefix); \
PkgSnow64Alu::`INST_8__3(PortOut_InnerShiftForAlu) \
	`INST_8__3(out_prefix); \
PkgSnow64Alu::`INST_8__2(PortIn_InnerShiftForAlu) \
	`INST_8__2(in_prefix); \
PkgSnow64Alu::`INST_8__2(PortOut_InnerShiftForAlu) \
	`INST_8__2(out_prefix); \
PkgSnow64Alu::`INST_8__1(PortIn_InnerShiftForAlu) \
	`INST_8__1(in_prefix); \
PkgSnow64Alu::`INST_8__1(PortOut_InnerShiftForAlu) \
	`INST_8__1(out_prefix); \
PkgSnow64Alu::`INST_8__0(PortIn_InnerShiftForAlu) \
	`INST_8__0(in_prefix); \
PkgSnow64Alu::`INST_8__0(PortOut_InnerShiftForAlu) \
	`INST_8__0(out_prefix);

`define MAKE_ONE_BIT_SHIFTER(some_module_prefix, some_width, 
	some_inst_ident, in_ports, out_ports) \
some_module_prefix``some_width \
	some_inst_ident(.in_to_shift(in_ports.to_shift), \
	.in_amount(in_ports.amount), .out_data(out_ports.data))


module __Snow64SliceAndSignExtend 
	(input PkgSnow64Alu::PortIn_SliceAndExtend in,
	output PkgSnow64Alu::PortOut_SliceAndExtend out);

	localparam __WIDTH__DATA_INOUT = 64;
	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(__WIDTH__DATA_INOUT);

	localparam __ARR_SIZE__OUT_SLICED_DATA = 8;
	localparam __LAST_INDEX__OUT_SLICED_DATA
		= `ARR_SIZE_TO_LAST_INDEX(__ARR_SIZE__OUT_SLICED_DATA);

	localparam __ARR_SIZE__LOCAL_DATA_8 = 8;
	localparam __LAST_INDEX__LOCAL_DATA_8
		= `ARR_SIZE_TO_LAST_INDEX(__ARR_SIZE__LOCAL_DATA_8);
	localparam __ARR_SIZE__LOCAL_DATA_16 = 4;
	localparam __LAST_INDEX__LOCAL_DATA_16
		= `ARR_SIZE_TO_LAST_INDEX(__ARR_SIZE__LOCAL_DATA_16);
	localparam __ARR_SIZE__LOCAL_DATA_32 = 2;
	localparam __LAST_INDEX__LOCAL_DATA_32
		= `ARR_SIZE_TO_LAST_INDEX(__ARR_SIZE__LOCAL_DATA_32);

	PkgSnow64Alu::SlicedAlu8DataInout __in_to_slice_8;
	PkgSnow64Alu::SlicedAlu16DataInout __in_to_slice_16;
	PkgSnow64Alu::SlicedAlu32DataInout __in_to_slice_32;



	logic [__LAST_INDEX__LOCAL_DATA_8:0][__MSB_POS__DATA_INOUT:0]
		__sign_extended_data_8;

	logic [__LAST_INDEX__LOCAL_DATA_16:0][__MSB_POS__DATA_INOUT:0]
		__sign_extended_data_16;
	logic [__LAST_INDEX__LOCAL_DATA_32:0][__MSB_POS__DATA_INOUT:0]
		__sign_extended_data_32;
	logic [__MSB_POS__DATA_INOUT:0] __sign_extended_data_64;

	assign __in_to_slice_8 = in.to_slice;
	assign __in_to_slice_16 = in.to_slice;
	assign __in_to_slice_32 = in.to_slice;

	assign __sign_extended_data_8[7] 
		= `SIGN_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_7);
	assign __sign_extended_data_8[6] 
		= `SIGN_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_6);
	assign __sign_extended_data_8[5] 
		= `SIGN_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_5);
	assign __sign_extended_data_8[4] 
		= `SIGN_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_4);
	assign __sign_extended_data_8[3]
		= `SIGN_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_3);
	assign __sign_extended_data_8[2]
		= `SIGN_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_2);
	assign __sign_extended_data_8[1]
		= `SIGN_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_1);
	assign __sign_extended_data_8[0]
		= `SIGN_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_0);

	assign __sign_extended_data_16[3]
		= `SIGN_EXTEND(__WIDTH__DATA_INOUT, 16, __in_to_slice_16.data_3);
	assign __sign_extended_data_16[2]
		= `SIGN_EXTEND(__WIDTH__DATA_INOUT, 16, __in_to_slice_16.data_2);
	assign __sign_extended_data_16[1]
		= `SIGN_EXTEND(__WIDTH__DATA_INOUT, 16, __in_to_slice_16.data_1);
	assign __sign_extended_data_16[0]
		= `SIGN_EXTEND(__WIDTH__DATA_INOUT, 16, __in_to_slice_16.data_0);

	assign __sign_extended_data_32[1]
		= `SIGN_EXTEND(__WIDTH__DATA_INOUT, 32, __in_to_slice_32.data_1);
	assign __sign_extended_data_32[0]
		= `SIGN_EXTEND(__WIDTH__DATA_INOUT, 32, __in_to_slice_32.data_0);

	assign __sign_extended_data_64 = in.to_slice;

	always @(*)
	begin
		case (in.type_size)
		PkgSnow64Cpu::TypSz8:
		begin
			out.sliced_data = __sign_extended_data_8;
		end

		PkgSnow64Cpu::TypSz16:
		begin
			out.sliced_data = {__sign_extended_data_16, 
				{(512 - (512 >> 1)){1'b0}}};
		end

		PkgSnow64Cpu::TypSz32:
		begin
			out.sliced_data = {__sign_extended_data_32,
				{(512 - (512 >> 2)){1'b0}}};
		end

		PkgSnow64Cpu::TypSz64:
		begin
			out.sliced_data = {__sign_extended_data_64,
				{(512 - (512 >> 3)){1'b0}}};
		end
		endcase
	end


endmodule

module __Snow64SliceAndZeroExtend 
	(input PkgSnow64Alu::PortIn_SliceAndExtend in,
	output PkgSnow64Alu::PortOut_SliceAndExtend out);

	localparam __WIDTH__DATA_INOUT = 64;
	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(__WIDTH__DATA_INOUT);

	localparam __ARR_SIZE__OUT_SLICED_DATA = 8;
	localparam __LAST_INDEX__OUT_SLICED_DATA
		= `ARR_SIZE_TO_LAST_INDEX(__ARR_SIZE__OUT_SLICED_DATA);

	localparam __ARR_SIZE__LOCAL_DATA_8 = 8;
	localparam __LAST_INDEX__LOCAL_DATA_8
		= `ARR_SIZE_TO_LAST_INDEX(__ARR_SIZE__LOCAL_DATA_8);
	localparam __ARR_SIZE__LOCAL_DATA_16 = 4;
	localparam __LAST_INDEX__LOCAL_DATA_16
		= `ARR_SIZE_TO_LAST_INDEX(__ARR_SIZE__LOCAL_DATA_16);
	localparam __ARR_SIZE__LOCAL_DATA_32 = 2;
	localparam __LAST_INDEX__LOCAL_DATA_32
		= `ARR_SIZE_TO_LAST_INDEX(__ARR_SIZE__LOCAL_DATA_32);

	PkgSnow64Alu::SlicedAlu8DataInout __in_to_slice_8;
	PkgSnow64Alu::SlicedAlu16DataInout __in_to_slice_16;
	PkgSnow64Alu::SlicedAlu32DataInout __in_to_slice_32;



	logic [__LAST_INDEX__LOCAL_DATA_8:0][__MSB_POS__DATA_INOUT:0]
		__zero_extended_data_8;

	logic [__LAST_INDEX__LOCAL_DATA_16:0][__MSB_POS__DATA_INOUT:0]
		__zero_extended_data_16;
	logic [__LAST_INDEX__LOCAL_DATA_32:0][__MSB_POS__DATA_INOUT:0]
		__zero_extended_data_32;
	logic [__MSB_POS__DATA_INOUT:0] __zero_extended_data_64;

	assign __in_to_slice_8 = in.to_slice;
	assign __in_to_slice_16 = in.to_slice;
	assign __in_to_slice_32 = in.to_slice;

	assign __zero_extended_data_8[7] 
		= `ZERO_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_7);
	assign __zero_extended_data_8[6] 
		= `ZERO_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_6);
	assign __zero_extended_data_8[5] 
		= `ZERO_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_5);
	assign __zero_extended_data_8[4] 
		= `ZERO_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_4);
	assign __zero_extended_data_8[3]
		= `ZERO_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_3);
	assign __zero_extended_data_8[2]
		= `ZERO_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_2);
	assign __zero_extended_data_8[1]
		= `ZERO_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_1);
	assign __zero_extended_data_8[0]
		= `ZERO_EXTEND(__WIDTH__DATA_INOUT, 8, __in_to_slice_8.data_0);

	assign __zero_extended_data_16[3]
		= `ZERO_EXTEND(__WIDTH__DATA_INOUT, 16, __in_to_slice_16.data_3);
	assign __zero_extended_data_16[2]
		= `ZERO_EXTEND(__WIDTH__DATA_INOUT, 16, __in_to_slice_16.data_2);
	assign __zero_extended_data_16[1]
		= `ZERO_EXTEND(__WIDTH__DATA_INOUT, 16, __in_to_slice_16.data_1);
	assign __zero_extended_data_16[0]
		= `ZERO_EXTEND(__WIDTH__DATA_INOUT, 16, __in_to_slice_16.data_0);

	assign __zero_extended_data_32[1]
		= `ZERO_EXTEND(__WIDTH__DATA_INOUT, 32, __in_to_slice_32.data_1);
	assign __zero_extended_data_32[0]
		= `ZERO_EXTEND(__WIDTH__DATA_INOUT, 32, __in_to_slice_32.data_0);

	assign __zero_extended_data_64 = in.to_slice;

	always @(*)
	begin
		case (in.type_size)
		PkgSnow64Cpu::TypSz8:
		begin
			out.sliced_data = __zero_extended_data_8;
		end

		PkgSnow64Cpu::TypSz16:
		begin
			out.sliced_data = {__zero_extended_data_16, 
				{(512 - (512 >> 1)){1'b0}}};
		end

		PkgSnow64Cpu::TypSz32:
		begin
			out.sliced_data = {__zero_extended_data_32,
				{(512 - (512 >> 2)){1'b0}}};
		end

		PkgSnow64Cpu::TypSz64:
		begin
			out.sliced_data = {__zero_extended_data_64,
				{(512 - (512 >> 3)){1'b0}}};
		end
		endcase
	end


endmodule


`define MAKE_INNER_BIT_SHIFTERS_FOR_ALU(some_module_prefix,
	some_inst_ident_prefix, in_ports_prefix, out_ports_prefix) \
`MAKE_ONE_BIT_SHIFTER(some_module_prefix, \
	`WIDTH__DATA_INOUT_INST_8__7, `INST_8__7(some_inst_ident_prefix), \
	`INST_8__7(in_ports_prefix), `INST_8__7(out_ports_prefix)); \
`MAKE_ONE_BIT_SHIFTER(some_module_prefix, \
	`WIDTH__DATA_INOUT_INST_8__6, `INST_8__6(some_inst_ident_prefix), \
	`INST_8__6(in_ports_prefix), `INST_8__6(out_ports_prefix)); \
`MAKE_ONE_BIT_SHIFTER(some_module_prefix, \
	`WIDTH__DATA_INOUT_INST_8__5, `INST_8__5(some_inst_ident_prefix), \
	`INST_8__5(in_ports_prefix), `INST_8__5(out_ports_prefix)); \
`MAKE_ONE_BIT_SHIFTER(some_module_prefix, \
	`WIDTH__DATA_INOUT_INST_8__4, `INST_8__4(some_inst_ident_prefix), \
	`INST_8__4(in_ports_prefix), `INST_8__4(out_ports_prefix)); \
`MAKE_ONE_BIT_SHIFTER(some_module_prefix, \
	`WIDTH__DATA_INOUT_INST_8__3, `INST_8__3(some_inst_ident_prefix), \
	`INST_8__3(in_ports_prefix), `INST_8__3(out_ports_prefix)); \
`MAKE_ONE_BIT_SHIFTER(some_module_prefix, \
	`WIDTH__DATA_INOUT_INST_8__2, `INST_8__2(some_inst_ident_prefix), \
	`INST_8__2(in_ports_prefix), `INST_8__2(out_ports_prefix)); \
`MAKE_ONE_BIT_SHIFTER(some_module_prefix, \
	`WIDTH__DATA_INOUT_INST_8__1, `INST_8__1(some_inst_ident_prefix), \
	`INST_8__1(in_ports_prefix), `INST_8__1(out_ports_prefix)); \
`MAKE_ONE_BIT_SHIFTER(some_module_prefix, \
	`WIDTH__DATA_INOUT_INST_8__0, `INST_8__0(some_inst_ident_prefix), \
	`INST_8__0(in_ports_prefix), `INST_8__0(out_ports_prefix));


//// Module that performs arithmetic right shifts for the Snow64Alu's
//module __Snow64AsrForAlu(input PkgSnow64Alu::PortIn_ShiftForAlu in,
//	output PkgSnow64Alu::PortOut_ShiftForAlu out);
//
//	`MAKE_INNER_SHIFT_FOR_ALU_PORTS(__in_asr, __out_asr)
//	`MAKE_INNER_BIT_SHIFTERS_FOR_ALU(ArithmeticShiftRight,
//		__inst_asr, __in_asr, __out_asr)
//
//
//	// __inst_asr64_0.to_shift 
//	always @(*)
//	begin
//		case (in.type_size)
//		PkgSnow64Cpu::TypSz8:
//		begin
//			`INST_8__7(__in_asr).to_shift
//				= `SIGN_EXTEND(64, 8, in.a`SLICE64_8__7);
//		end
//
//		PkgSnow64Cpu::TypSz16:
//		begin
//			`INST_16__3(__in_asr).to_shift
//				= `SIGN_EXTEND(64, 16, in.a`SLICE64_16__3);
//		end
//
//		PkgSnow64Cpu::TypSz32:
//		begin
//			`INST_32__1(__in_asr).to_shift
//				= `SIGN_EXTEND(64, 32, in.a`SLICE64_32__1);
//		end
//
//		PkgSnow64Cpu::TypSz64:
//		begin
//			`INST_64__0(__in_asr).to_shift = in.a;
//		end
//		endcase
//	end
//
//
//endmodule

`undef MAKE_ONE_BIT_SHIFTER
`undef MAKE_INNER_BIT_SHIFTERS_FOR_ALU
`undef MAKE_INNER_SHIFT_FOR_ALU_PORTS

// Get the results from the __Snow64SubAlu's and pack them into nice 64-bit
// results (which we'll use directly) based upon the size of the
// operation's data type
// 
// I have chosen **not** to make my usual "PortIn_ModuleName" and
// "PortOut_ModuleName" packed structs for this module primarily because
// the (many) inputs to this module are all coming from existing sources.
module __Snow64GetSubAluResults
	(input logic [`MSB_POS__SNOW64_CPU_TYPE_SIZE:0] in_type_size,
	input logic [`MSB_POS__SNOW64_ALU_8_DATA_INOUT:0]
		in_sub_alu_0_out_data, in_sub_alu_1_out_data,
		in_sub_alu_2_out_data, in_sub_alu_3_out_data,
		in_sub_alu_4_out_data, in_sub_alu_5_out_data,
		in_sub_alu_6_out_data, in_sub_alu_7_out_data,

	input logic in_sub_alu_0_out_carry, in_sub_alu_1_out_carry,
		in_sub_alu_2_out_carry, in_sub_alu_3_out_carry,
		in_sub_alu_4_out_carry, in_sub_alu_5_out_carry,
		in_sub_alu_6_out_carry, in_sub_alu_7_out_carry,

	input logic in_sub_alu_0_out_lts, in_sub_alu_1_out_lts,
		in_sub_alu_2_out_lts, in_sub_alu_3_out_lts,
		in_sub_alu_4_out_lts, in_sub_alu_5_out_lts,
		in_sub_alu_6_out_lts, in_sub_alu_7_out_lts,
	
	output logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] 
		out_data, out_ltu, out_lts);




	assign out_data = {in_sub_alu_7_out_data, in_sub_alu_6_out_data,
		in_sub_alu_5_out_data, in_sub_alu_4_out_data,
		in_sub_alu_3_out_data, in_sub_alu_2_out_data,
		in_sub_alu_1_out_data, in_sub_alu_0_out_data};

	// packed ltu results
	always @(*)
	begin
		case (in_type_size)
		PkgSnow64Cpu::TypSz8:
		begin
			out_ltu = {`ZERO_EXTEND(8, 1, !in_sub_alu_7_out_carry),
				`ZERO_EXTEND(8, 1, !in_sub_alu_6_out_carry),
				`ZERO_EXTEND(8, 1, !in_sub_alu_5_out_carry),
				`ZERO_EXTEND(8, 1, !in_sub_alu_4_out_carry),
				`ZERO_EXTEND(8, 1, !in_sub_alu_3_out_carry),
				`ZERO_EXTEND(8, 1, !in_sub_alu_2_out_carry),
				`ZERO_EXTEND(8, 1, !in_sub_alu_1_out_carry),
				`ZERO_EXTEND(8, 1, !in_sub_alu_0_out_carry)};
		end

		PkgSnow64Cpu::TypSz16:
		begin
			out_ltu = {`ZERO_EXTEND(16, 1, !in_sub_alu_7_out_carry),
				`ZERO_EXTEND(16, 1, !in_sub_alu_5_out_carry),
				`ZERO_EXTEND(16, 1, !in_sub_alu_3_out_carry),
				`ZERO_EXTEND(16, 1, !in_sub_alu_1_out_carry)};
		end

		PkgSnow64Cpu::TypSz32:
		begin
			out_ltu = {`ZERO_EXTEND(32, 1, !in_sub_alu_7_out_carry),
				`ZERO_EXTEND(32, 1, !in_sub_alu_3_out_carry)};
		end

		PkgSnow64Cpu::TypSz64:
		begin
			out_ltu = `ZERO_EXTEND(64, 1, !in_sub_alu_7_out_carry);
		end
		endcase
	end

	// packed lts results
	always @(*)
	begin
		case (in_type_size)
		PkgSnow64Cpu::TypSz8:
		begin
			out_lts = {`ZERO_EXTEND(8, 1, in_sub_alu_7_out_lts),
				`ZERO_EXTEND(8, 1, in_sub_alu_6_out_lts),
				`ZERO_EXTEND(8, 1, in_sub_alu_5_out_lts),
				`ZERO_EXTEND(8, 1, in_sub_alu_4_out_lts),
				`ZERO_EXTEND(8, 1, in_sub_alu_3_out_lts),
				`ZERO_EXTEND(8, 1, in_sub_alu_2_out_lts),
				`ZERO_EXTEND(8, 1, in_sub_alu_1_out_lts),
				`ZERO_EXTEND(8, 1, in_sub_alu_0_out_lts)};
		end

		PkgSnow64Cpu::TypSz16:
		begin
			out_lts = {`ZERO_EXTEND(16, 1, in_sub_alu_7_out_lts),
				`ZERO_EXTEND(16, 1, in_sub_alu_5_out_lts),
				`ZERO_EXTEND(16, 1, in_sub_alu_3_out_lts),
				`ZERO_EXTEND(16, 1, in_sub_alu_1_out_lts)};
		end

		PkgSnow64Cpu::TypSz32:
		begin
			out_lts = {`ZERO_EXTEND(32, 1, in_sub_alu_7_out_lts),
				`ZERO_EXTEND(32, 1, in_sub_alu_3_out_lts)};
		end

		PkgSnow64Cpu::TypSz64:
		begin
			out_lts = `ZERO_EXTEND(64, 1, in_sub_alu_7_out_lts);
		end
		endcase
	end

endmodule

// This module would really benefit from the "generate" construct if I were
// allowing myself to use it.  The reason I chose not to use it is a simple
// one:  I cannot use Icarus Verilog's "-tvlog95" option if I use the
// "generate" construct.
//
// I do have a use case in mind for "-tvlog95" option... that's for later,
// though.
module Snow64Alu(input PkgSnow64Alu::PortIn_Alu in,
	output PkgSnow64Alu::PortOut_Alu out);


	logic __sub_alu_in_carry_0, __sub_alu_in_carry_1, 
		__sub_alu_in_carry_2, __sub_alu_in_carry_3,
		__sub_alu_in_carry_4, __sub_alu_in_carry_5,
		__sub_alu_in_carry_6, __sub_alu_in_carry_7;
	logic [`MSB_POS__SNOW64_SUB_ALU_INDEX:0] 
		__sub_alu_in_index_0, __sub_alu_in_index_1, 
		__sub_alu_in_index_2, __sub_alu_in_index_3,
		__sub_alu_in_index_4, __sub_alu_in_index_5,
		__sub_alu_in_index_6, __sub_alu_in_index_7;

	`define MAKE_BIT_SHIFTER_PORTS(some_msb_pos,
		some_in_shift_prefix, some_out_lsl_data_prefix, 
		some_out_lsr_data_prefix, some_out_asr_data_prefix) \
	logic [some_msb_pos:0] \
		some_in_shift_prefix``_to_shift_logical, \
		some_in_shift_prefix``_to_shift_arithmetic, \
		some_in_shift_prefix``_amount, \
		some_out_lsl_data_prefix``_data, \
		some_out_lsr_data_prefix``_data, \
		some_out_asr_data_prefix``_data;


	`define MAKE_BIT_SHIFTER_INSTANCES(some_width, some_inst_prefix,
		some_in_shift_prefix, some_out_lsl_data_prefix, 
		some_out_lsr_data_prefix, some_out_asr_data_prefix) \
		`MAKE_BIT_SHIFTER_PORTS(`WIDTH2MP(some_width), \
			some_in_shift_prefix, some_out_lsl_data_prefix, \
			some_out_lsr_data_prefix, some_out_asr_data_prefix) \
		LogicalShiftLeft``some_width some_inst_prefix``_lsl \
			(.in_to_shift(some_in_shift_prefix``_to_shift_logical), \
			.in_amount(some_in_shift_prefix``_amount), \
			.out_data(some_out_lsl_data_prefix``_data)); \
		LogicalShiftRight``some_width some_inst_prefix``_lsr \
			(.in_to_shift(some_in_shift_prefix``_to_shift_logical), \
			.in_amount(some_in_shift_prefix``_amount), \
			.out_data(some_out_lsr_data_prefix``_data)); \
		ArithmeticShiftRight``some_width some_inst_prefix``_asr \
			(.in_to_shift(some_in_shift_prefix``_to_shift_arithmetic), \
			.in_amount(some_in_shift_prefix``_amount), \
			.out_data(some_out_asr_data_prefix``_data)); \

	`MAKE_BIT_SHIFTER_INSTANCES(`WIDTH__INST_8__7__DATA_INOUT,
		`INST_8__7(__inst), `INST_8__7(__in_shift), `INST_8__7(__out_lsl),
		`INST_8__7(__out_lsr), `INST_8__7(__out_asr))
	`MAKE_BIT_SHIFTER_INSTANCES(`WIDTH__INST_8__6__DATA_INOUT,
		`INST_8__6(__inst), `INST_8__6(__in_shift), `INST_8__6(__out_lsl),
		`INST_8__6(__out_lsr), `INST_8__6(__out_asr))
	`MAKE_BIT_SHIFTER_INSTANCES(`WIDTH__INST_8__5__DATA_INOUT,
		`INST_8__5(__inst), `INST_8__5(__in_shift), `INST_8__5(__out_lsl),
		`INST_8__5(__out_lsr), `INST_8__5(__out_asr))
	`MAKE_BIT_SHIFTER_INSTANCES(`WIDTH__INST_8__4__DATA_INOUT,
		`INST_8__4(__inst), `INST_8__4(__in_shift), `INST_8__4(__out_lsl),
		`INST_8__4(__out_lsr), `INST_8__4(__out_asr))
	`MAKE_BIT_SHIFTER_INSTANCES(`WIDTH__INST_8__3__DATA_INOUT,
		`INST_8__3(__inst), `INST_8__3(__in_shift), `INST_8__3(__out_lsl),
		`INST_8__3(__out_lsr), `INST_8__3(__out_asr))
	`MAKE_BIT_SHIFTER_INSTANCES(`WIDTH__INST_8__2__DATA_INOUT,
		`INST_8__2(__inst), `INST_8__2(__in_shift), `INST_8__2(__out_lsl),
		`INST_8__2(__out_lsr), `INST_8__2(__out_asr))
	`MAKE_BIT_SHIFTER_INSTANCES(`WIDTH__INST_8__1__DATA_INOUT,
		`INST_8__1(__inst), `INST_8__1(__in_shift), `INST_8__1(__out_lsl),
		`INST_8__1(__out_lsr), `INST_8__1(__out_asr))
	`MAKE_BIT_SHIFTER_INSTANCES(`WIDTH__INST_8__0__DATA_INOUT,
		`INST_8__0(__inst), `INST_8__0(__in_shift), `INST_8__0(__out_lsl),
		`INST_8__0(__out_lsr), `INST_8__0(__out_asr))

	`undef MAKE_BIT_SHIFTER_PORTS
	`undef MAKE_BIT_SHIFTER_INSTANCES

	logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] 
		__out_get_sub_alu_results_data, 
		__out_get_sub_alu_results_ltu, __out_get_sub_alu_results_lts;

	PkgSnow64Alu::SlicedAlu8DataInout __in_a_sliced_8, __in_b_sliced_8;

	PkgSnow64Alu::SlicedAlu16DataInout __in_a_sliced_16;
	PkgSnow64Alu::SlicedAlu32DataInout __in_a_sliced_32;


	// Figure out the inputs to the barrel shifters.
	// These should *not* be used for anything outside the ALU, though the
	// "SliceAndXExtend" modules themselves certainly are fine to use
	// outside the ALU.
	PkgSnow64Alu::PortIn_SliceAndExtend 
		__in_slice_and_sign_extend, 
		__in_slice_and_zero_extend_a, __in_slice_and_zero_extend_b;
	PkgSnow64Alu::PortOut_SliceAndExtend 
		__out_slice_and_sign_extend,
		__out_slice_and_zero_extend_a, __out_slice_and_zero_extend_b;

	__Snow64SliceAndSignExtend __inst_slice_and_sign_extend
		(.in(__in_slice_and_sign_extend),
		.out(__out_slice_and_sign_extend));
	__Snow64SliceAndZeroExtend __inst_slice_and_zero_extend_a
		(.in(__in_slice_and_zero_extend_a),
		.out(__out_slice_and_zero_extend_a));
	__Snow64SliceAndZeroExtend __inst_slice_and_zero_extend_b
		(.in(__in_slice_and_zero_extend_b),
		.out(__out_slice_and_zero_extend_b));


	PkgSnow64Alu::PortIn_SubAlu 
		__in_sub_alu_0, __in_sub_alu_1, __in_sub_alu_2, __in_sub_alu_3,
		__in_sub_alu_4, __in_sub_alu_5, __in_sub_alu_6, __in_sub_alu_7;
	PkgSnow64Alu::PortOut_SubAlu 
		__out_sub_alu_0, __out_sub_alu_1, __out_sub_alu_2, __out_sub_alu_3,
		__out_sub_alu_4, __out_sub_alu_5, __out_sub_alu_6, __out_sub_alu_7;

	`define MAKE_INST_SUB_ALU(some_num) \
	__Snow64SubAlu __inst_sub_alu_``some_num \
		(.in(__in_sub_alu_``some_num), .out(__out_sub_alu_``some_num))

	`MAKE_INST_SUB_ALU(0);
	`MAKE_INST_SUB_ALU(1);
	`MAKE_INST_SUB_ALU(2);
	`MAKE_INST_SUB_ALU(3);
	`MAKE_INST_SUB_ALU(4);
	`MAKE_INST_SUB_ALU(5);
	`MAKE_INST_SUB_ALU(6);
	`MAKE_INST_SUB_ALU(7);
	`undef MAKE_INST_SUB_ALU

	__Snow64GetSubAluResults __inst_get_sub_alu_results
		(.in_type_size(in.type_size),
		.in_sub_alu_0_out_data(__out_sub_alu_0.data),
		.in_sub_alu_1_out_data(__out_sub_alu_1.data),
		.in_sub_alu_2_out_data(__out_sub_alu_2.data),
		.in_sub_alu_3_out_data(__out_sub_alu_3.data),
		.in_sub_alu_4_out_data(__out_sub_alu_4.data),
		.in_sub_alu_5_out_data(__out_sub_alu_5.data),
		.in_sub_alu_6_out_data(__out_sub_alu_6.data),
		.in_sub_alu_7_out_data(__out_sub_alu_7.data),

		.in_sub_alu_0_out_carry(__out_sub_alu_0.carry),
		.in_sub_alu_1_out_carry(__out_sub_alu_1.carry),
		.in_sub_alu_2_out_carry(__out_sub_alu_2.carry),
		.in_sub_alu_3_out_carry(__out_sub_alu_3.carry),
		.in_sub_alu_4_out_carry(__out_sub_alu_4.carry),
		.in_sub_alu_5_out_carry(__out_sub_alu_5.carry),
		.in_sub_alu_6_out_carry(__out_sub_alu_6.carry),
		.in_sub_alu_7_out_carry(__out_sub_alu_7.carry),

		.in_sub_alu_0_out_lts(__out_sub_alu_0.lts),
		.in_sub_alu_1_out_lts(__out_sub_alu_1.lts),
		.in_sub_alu_2_out_lts(__out_sub_alu_2.lts),
		.in_sub_alu_3_out_lts(__out_sub_alu_3.lts),
		.in_sub_alu_4_out_lts(__out_sub_alu_4.lts),
		.in_sub_alu_5_out_lts(__out_sub_alu_5.lts),
		.in_sub_alu_6_out_lts(__out_sub_alu_6.lts),
		.in_sub_alu_7_out_lts(__out_sub_alu_7.lts),

		.out_data(__out_get_sub_alu_results_data),
		.out_ltu(__out_get_sub_alu_results_ltu),
		.out_lts(__out_get_sub_alu_results_lts));


	// Assignments
	assign __in_a_sliced_8 = in.a;
	assign __in_b_sliced_8 = in.b;
	assign __in_a_sliced_16 = in.a;
	assign __in_a_sliced_32 = in.a;

	always @(*) __in_slice_and_sign_extend.type_size = in.type_size;
	always @(*) __in_slice_and_sign_extend.to_slice = in.a;

	always @(*) __in_slice_and_zero_extend_a.type_size = in.type_size;
	always @(*) __in_slice_and_zero_extend_a.to_slice = in.a;
	always @(*) __in_slice_and_zero_extend_b.type_size = in.type_size;
	always @(*) __in_slice_and_zero_extend_b.to_slice = in.b;

	`define ASSIGN_TO_IN_SUB_ALU(some_num) \
		always @(*) __in_sub_alu_``some_num.a \
			= __in_a_sliced_8.data_``some_num; \
		always @(*) __in_sub_alu_``some_num.b \
			= __in_b_sliced_8.data_``some_num; \
		always @(*) __in_sub_alu_``some_num.carry \
			= __sub_alu_in_carry_``some_num; \
		always @(*) __in_sub_alu_``some_num.oper = in.oper; \
		always @(*) __in_sub_alu_``some_num.type_size = in.type_size; \
		always @(*) __in_sub_alu_``some_num.index \
			= __sub_alu_in_index_``some_num;

	`ASSIGN_TO_IN_SUB_ALU(0)
	`ASSIGN_TO_IN_SUB_ALU(1)
	`ASSIGN_TO_IN_SUB_ALU(2)
	`ASSIGN_TO_IN_SUB_ALU(3)
	`ASSIGN_TO_IN_SUB_ALU(4)
	`ASSIGN_TO_IN_SUB_ALU(5)
	`ASSIGN_TO_IN_SUB_ALU(6)
	`ASSIGN_TO_IN_SUB_ALU(7)
	`undef ASSIGN_TO_IN_SUB_ALU

	assign `INST_8__7_B(__in_shift, _to_shift_logical)
		= __out_slice_and_zero_extend_a.sliced_data[7];
	assign `INST_8__6_B(__in_shift, _to_shift_logical)
		= __out_slice_and_zero_extend_a.sliced_data[6];
	assign `INST_8__5_B(__in_shift, _to_shift_logical)
		= __out_slice_and_zero_extend_a.sliced_data[5];
	assign `INST_8__4_B(__in_shift, _to_shift_logical)
		= __out_slice_and_zero_extend_a.sliced_data[4];
	assign `INST_8__3_B(__in_shift, _to_shift_logical)
		= __out_slice_and_zero_extend_a.sliced_data[3];
	assign `INST_8__2_B(__in_shift, _to_shift_logical)
		= __out_slice_and_zero_extend_a.sliced_data[2];
	assign `INST_8__1_B(__in_shift, _to_shift_logical)
		= __out_slice_and_zero_extend_a.sliced_data[1];
	assign `INST_8__0_B(__in_shift, _to_shift_logical)
		= __out_slice_and_zero_extend_a.sliced_data[0];

	assign `INST_8__7_B(__in_shift, _to_shift_arithmetic)
		= __out_slice_and_sign_extend.sliced_data[7];
	assign `INST_8__6_B(__in_shift, _to_shift_arithmetic)
		= __out_slice_and_sign_extend.sliced_data[6];
	assign `INST_8__5_B(__in_shift, _to_shift_arithmetic)
		= __out_slice_and_sign_extend.sliced_data[5];
	assign `INST_8__4_B(__in_shift, _to_shift_arithmetic)
		= __out_slice_and_sign_extend.sliced_data[4];
	assign `INST_8__3_B(__in_shift, _to_shift_arithmetic)
		= __out_slice_and_sign_extend.sliced_data[3];
	assign `INST_8__2_B(__in_shift, _to_shift_arithmetic)
		= __out_slice_and_sign_extend.sliced_data[2];
	assign `INST_8__1_B(__in_shift, _to_shift_arithmetic)
		= __out_slice_and_sign_extend.sliced_data[1];
	assign `INST_8__0_B(__in_shift, _to_shift_arithmetic)
		= __out_slice_and_sign_extend.sliced_data[0];

	assign `INST_8__7_B(__in_shift, _amount)
		= __out_slice_and_zero_extend_b.sliced_data[7];
	assign `INST_8__6_B(__in_shift, _amount)
		= __out_slice_and_zero_extend_b.sliced_data[6];
	assign `INST_8__5_B(__in_shift, _amount)
		= __out_slice_and_zero_extend_b.sliced_data[5];
	assign `INST_8__4_B(__in_shift, _amount)
		= __out_slice_and_zero_extend_b.sliced_data[4];
	assign `INST_8__3_B(__in_shift, _amount)
		= __out_slice_and_zero_extend_b.sliced_data[3];
	assign `INST_8__2_B(__in_shift, _amount)
		= __out_slice_and_zero_extend_b.sliced_data[2];
	assign `INST_8__1_B(__in_shift, _amount)
		= __out_slice_and_zero_extend_b.sliced_data[1];
	assign `INST_8__0_B(__in_shift, _amount)
		= __out_slice_and_zero_extend_b.sliced_data[0];



	//assign __sub_alu_in_carry_0 
	//	= ((in.oper == PkgSnow64Alu::OpSub)
	//	|| (in.oper == PkgSnow64Alu::OpSlt));
	assign __sub_alu_in_carry_0 = 0;
	assign __sub_alu_in_carry_1 = __out_sub_alu_0.carry;
	assign __sub_alu_in_carry_2 = __out_sub_alu_1.carry;
	assign __sub_alu_in_carry_3 = __out_sub_alu_2.carry;
	assign __sub_alu_in_carry_4 = __out_sub_alu_3.carry;
	assign __sub_alu_in_carry_5 = __out_sub_alu_4.carry;
	assign __sub_alu_in_carry_6 = __out_sub_alu_5.carry;
	assign __sub_alu_in_carry_7 = __out_sub_alu_6.carry;

	assign __sub_alu_in_index_0 = 0;
	assign __sub_alu_in_index_1 = 1;
	assign __sub_alu_in_index_2 = 2;
	assign __sub_alu_in_index_3 = 3;
	assign __sub_alu_in_index_4 = 4;
	assign __sub_alu_in_index_5 = 5;
	assign __sub_alu_in_index_6 = 6;
	assign __sub_alu_in_index_7 = 7;

	always @(*)
	begin
		case (in.oper)
			PkgSnow64Alu::OpAdd:
			begin
				out.data = __out_get_sub_alu_results_data;
			end
			PkgSnow64Alu::OpSub:
			begin
				out.data = __out_get_sub_alu_results_data;
			end
			PkgSnow64Alu::OpSlt:
			begin
				case (in.signedness)
				0:
				begin
					out.data = __out_get_sub_alu_results_ltu;
				end

				1:
				begin
					out.data = __out_get_sub_alu_results_lts;
				end
				endcase
			end
			//PkgSnow64Alu::OpDummy0:
			//begin
			//end

			//PkgSnow64Alu::OpDummy1:
			//begin
			//end
			PkgSnow64Alu::OpAnd:
			begin
				out.data = __out_get_sub_alu_results_data;
			end
			PkgSnow64Alu::OpOrr:
			begin
				out.data = __out_get_sub_alu_results_data;
			end
			PkgSnow64Alu::OpXor:
			begin
				out.data = __out_get_sub_alu_results_data;
			end

			PkgSnow64Alu::OpShl:
			begin
				case (in.type_size)
				PkgSnow64Cpu::TypSz8:
				begin
					out.data = {`INST_8__7_B(__out_lsl, _data)[7:0],
						`INST_8__6_B(__out_lsl, _data)[7:0],
						`INST_8__5_B(__out_lsl, _data)[7:0],
						`INST_8__4_B(__out_lsl, _data)[7:0],
						`INST_8__3_B(__out_lsl, _data)[7:0],
						`INST_8__2_B(__out_lsl, _data)[7:0],
						`INST_8__1_B(__out_lsl, _data)[7:0],
						`INST_8__0_B(__out_lsl, _data)[7:0]};
				end

				PkgSnow64Cpu::TypSz16:
				begin
					out.data = {`INST_16__3_B(__out_lsl, _data)[15:0],
						`INST_16__2_B(__out_lsl, _data)[15:0],
						`INST_16__1_B(__out_lsl, _data)[15:0],
						`INST_16__0_B(__out_lsl, _data)[15:0]};
				end

				PkgSnow64Cpu::TypSz32:
				begin
					out.data = {`INST_32__1_B(__out_lsl, _data)[31:0],
						`INST_32__0_B(__out_lsl, _data)[31:0]};
				end

				PkgSnow64Cpu::TypSz64:
				begin
					out.data = `INST_64__0_B(__out_lsl, _data);
				end
				endcase
			end
			PkgSnow64Alu::OpShr:
			begin
				case (in.signedness)
				0:
				begin
					case (in.type_size)
					PkgSnow64Cpu::TypSz8:
					begin
						out.data = {`INST_8__7_B(__out_lsr, _data)[7:0],
							`INST_8__6_B(__out_lsr, _data)[7:0],
							`INST_8__5_B(__out_lsr, _data)[7:0],
							`INST_8__4_B(__out_lsr, _data)[7:0],
							`INST_8__3_B(__out_lsr, _data)[7:0],
							`INST_8__2_B(__out_lsr, _data)[7:0],
							`INST_8__1_B(__out_lsr, _data)[7:0],
							`INST_8__0_B(__out_lsr, _data)[7:0]};
					end

					PkgSnow64Cpu::TypSz16:
					begin
						out.data = {`INST_16__3_B(__out_lsr, _data)[15:0],
							`INST_16__2_B(__out_lsr, _data)[15:0],
							`INST_16__1_B(__out_lsr, _data)[15:0],
							`INST_16__0_B(__out_lsr, _data)[15:0]};
					end

					PkgSnow64Cpu::TypSz32:
					begin
						out.data = {`INST_32__1_B(__out_lsr, _data)[31:0],
							`INST_32__0_B(__out_lsr, _data)[31:0]};
					end

					PkgSnow64Cpu::TypSz64:
					begin
						out.data = `INST_64__0_B(__out_lsr, _data);
					end
					endcase
				end

				1:
				begin
					case (in.type_size)
					PkgSnow64Cpu::TypSz8:
					begin
						out.data = {`INST_8__7_B(__out_asr, _data)[7:0],
							`INST_8__6_B(__out_asr, _data)[7:0],
							`INST_8__5_B(__out_asr, _data)[7:0],
							`INST_8__4_B(__out_asr, _data)[7:0],
							`INST_8__3_B(__out_asr, _data)[7:0],
							`INST_8__2_B(__out_asr, _data)[7:0],
							`INST_8__1_B(__out_asr, _data)[7:0],
							`INST_8__0_B(__out_asr, _data)[7:0]};
					end

					PkgSnow64Cpu::TypSz16:
					begin
						out.data = {`INST_16__3_B(__out_asr, _data)[15:0],
							`INST_16__2_B(__out_asr, _data)[15:0],
							`INST_16__1_B(__out_asr, _data)[15:0],
							`INST_16__0_B(__out_asr, _data)[15:0]};
					end

					PkgSnow64Cpu::TypSz32:
					begin
						out.data = {`INST_32__1_B(__out_asr, _data)[31:0],
							`INST_32__0_B(__out_asr, _data)[31:0]};
					end

					PkgSnow64Cpu::TypSz64:
					begin
						out.data = `INST_64__0_B(__out_asr, _data);
					end
					endcase
				end
				endcase
			end
			PkgSnow64Alu::OpInv:
			begin
				out.data = __out_get_sub_alu_results_data;
			end
			PkgSnow64Alu::OpNot:
			begin
				case (in.type_size)
				PkgSnow64Cpu::TypSz8:
				begin
					//out.data = __out_get_sub_alu_results_data;
					out.data 
						= {`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_7),
						`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_6),
						`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_5),
						`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_4),
						`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_3),
						`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_2),
						`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_1),
						`ZERO_EXTEND(8, 1, !__in_a_sliced_8.data_0)};
					//out.data[63:56] = !__in_a_sliced_8.data_7;
					//out.data[55:48] = !__in_a_sliced_8.data_6;
					//out.data[47:40] = !__in_a_sliced_8.data_5;
					//out.data[39:32] = !__in_a_sliced_8.data_4;
					//out.data[31:24] = !__in_a_sliced_8.data_3;
					//out.data[23:16] = !__in_a_sliced_8.data_2;
					//out.data[15:8] = !__in_a_sliced_8.data_1;
					//out.data[7:0] = !__in_a_sliced_8.data_0;
				end

				PkgSnow64Cpu::TypSz16:
				begin
					out.data 
						= {`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_3),
						`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_2),
						`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_1),
						`ZERO_EXTEND(16, 1, !__in_a_sliced_16.data_0)};
					//out.data[63:48] = !__in_a_sliced_16.data_3;
					//out.data[47:32] = !__in_a_sliced_16.data_2;
					//out.data[31:16] = !__in_a_sliced_16.data_1;
					//out.data[15:0] = !__in_a_sliced_16.data_0;
				end

				PkgSnow64Cpu::TypSz32:
				begin
					out.data
						= {`ZERO_EXTEND(32, 1, !__in_a_sliced_32.data_1),
						`ZERO_EXTEND(32, 1, !__in_a_sliced_32.data_0)};
					//out.data[63:32] = !__in_a_sliced_32.data_1;
					//out.data[31:0] = !__in_a_sliced_32.data_0;

				end

				PkgSnow64Cpu::TypSz64:
				begin
					out.data = !in.a;
				end
				endcase
			end

			PkgSnow64Alu::OpAddAgain:
			begin
				out.data = __out_get_sub_alu_results_data;
			end
			//PkgSnow64Alu::OpDummy2:
			//begin
			//end
			//PkgSnow64Alu::OpDummy3:
			//begin
			//end
			//PkgSnow64Alu::OpDummy:
			//begin
			//end
			default:
			begin
				out.data = 0;
			end
		endcase
	end


endmodule


module DebugSnow64Alu
	(input logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] in_a, in_b,
	input logic [`MSB_POS__SNOW64_ALU_OPER:0] in_oper,
	input logic [`MSB_POS__SNOW64_CPU_TYPE_SIZE:0] in_type_size,
	input logic in_signedness,

	output logic [`MSB_POS__SNOW64_ALU_64_DATA_INOUT:0] out_data);

	PkgSnow64Alu::PortIn_Alu __in_alu;
	PkgSnow64Alu::PortOut_Alu __out_alu;

	Snow64Alu __inst_alu(.in(__in_alu), .out(__out_alu));

	always @(*) __in_alu.a = in_a;
	always @(*) __in_alu.b = in_b;
	always @(*) __in_alu.oper = in_oper;
	always @(*) __in_alu.type_size = in_type_size;
	always @(*) __in_alu.signedness = in_signedness;

	always @(*) out_data = __out_alu.data;
endmodule
