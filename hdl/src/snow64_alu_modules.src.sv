`include "src/snow64_alu_defines.header.sv"

// 8-bit ALU with carry in, carry out, the size of the operands of the
// overall operation, and an index indicating which sub ALU we are (used to
// determine whether or not to use 'in.carry")
module __Snow64SubAlu(input PkgSnow64Alu::PortIn_SubAlu in,
	output PkgSnow64Alu::PortOut_SubAlu out);

	localparam __MSB_POS__DATA_INOUT
		= `MSB_POS__SNOW64_SUB_ALU_DATA_INOUT;

	struct packed
	{
		logic in_actual_carry;
	} __locals;

	logic __out_slts;

	SetLessThanSigned __inst_slts
		(.in_a_msb_pos(in.a[__MSB_POS__DATA_INOUT]),
		.in_b_msb_pos(in.b[__MSB_POS__DATA_INOUT]),
		.in_sub_result_msb_pos(out.data[__MSB_POS__DATA_INOUT]),
		.out_data(__out_slts));


	// Determine if we need to use "in.carry"
	always @(*)
	begin
		case (in.type_size)

		// 8-bit operations don't care about "in.carry".
		PkgSnow64Alu::TypSz8:
		begin
			__locals.in_actual_carry = 1'b0;
		end

		// For 16-bit operations, a sub ALU with an odd-numbered index will
		// need to use "in.carry"
		PkgSnow64Alu::TypSz16:
		begin
			if (in.index[0])
			begin
				__locals.in_actual_carry = in.carry;
			end

			// For 16-bit operations, an even-numbered indexed sub ALU
			// doesn't care about "in.carry" because this architecture
			else
			begin
				__locals.in_actual_carry = 1'b0;
			end
		end

		// For 32-bit operations, we care about carry for only two cases:
		// (in.index == 0) or (in.index == 4).
		PkgSnow64Alu::TypSz32:
		begin
			if (in.index[1:0])
			begin
				__locals.in_actual_carry = in.carry;
			end

			else
			begin
				__locals.in_actual_carry = 1'b0;
			end
		end

		// 64-bit operations do indeed care about carry, but only if the
		// index is zero.
		PkgSnow64Alu::TypSz64:
		begin
			if (in.index[2:0])
			begin
				__locals.in_actual_carry = in.carry;
			end

			else
			begin
				__locals.in_actual_carry = 1'b0;
			end
		end
		endcase
	end

	always @(*)
	begin
		case (in.oper)
		PkgSnow64Alu::OpAdd:
		begin
			{out.carry, out.data} = in.a + in.b
				+ {{`MSB_POS__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
				__locals.in_actual_carry};
		end

		PkgSnow64Alu::OpSub:
		begin
			{out.carry, out.data} = in.a + (~in.b)
				+ {{`MSB_POS__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
				__locals.in_actual_carry};
		end

		// Just repeat the "OpSub" stuff here.
		PkgSnow64Alu::OpSlt:
		begin
			{out.carry, out.data} = in.a + (~in.b)
				+ {{`MSB_POS__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
				__locals.in_actual_carry};
		end
		PkgSnow64Alu::OpAnd:
		begin
			out.carry = 0;
			out.data = in.a & in.b;
		end
		PkgSnow64Alu::OpOrr:
		begin
			out.carry = 0;
			out.data = in.a | in.b;
		end
		PkgSnow64Alu::OpXor:
		begin
			out.carry = 0;
			out.data = in.a ^ in.b;
		end
		PkgSnow64Alu::OpInv:
		begin
			out.carry = 0;
			out.data = ~in.a;
		end
		PkgSnow64Alu::OpNot:
		begin
			out.carry = 0;
			out.data = !in.a;
		end

		// Just repeat the "OpAdd" stuff here.
		PkgSnow64Alu::OpAddAgain:
		begin
			{out.carry, out.data} = in.a + in.b
				+ {{`MSB_POS__SNOW64_SUB_ALU_DATA_INOUT{1'b0}},
				__locals.in_actual_carry};
		end

		default:
		begin
			out.carry = 0;
			out.data = 0;
		end
		endcase
	end

	always @(*)
	begin
		out.slts = __out_slts;
	end

endmodule

`define SET_ASR_INPUTS_SIGNEXT(some_full_width, some_asr_num, 
	in_data_sliced_num, data_num) \
	__in_asr``some_full_width``_``some_asr_num.to_shift \
		= `SIGN_EXTEND(some_full_width, in_data_sliced_num, \
		__in_a_sliced_``in_data_sliced_num.data_``data_num); \
	__in_asr``some_full_width``_``some_asr_num.amount \
		= `SIGN_EXTEND(some_full_width, in_data_sliced_num, \
		__in_b_sliced_``in_data_sliced_num.data_``data_num);
`define SET_ASR_INPUTS(some_full_width, some_asr_num, in_data_sliced_num,
	data_num) \
	__in_asr``some_full_width``_``some_asr_num.to_shift \
		= __in_a_sliced_``in_data_sliced_num.data_``data_num; \
	__in_asr``some_full_width``_``some_asr_num.amount \
		= __in_b_sliced_``in_data_sliced_num.data_``data_num;

module Snow64Alu(input PkgSnow64Alu::PortIn_Alu in,
	output PkgSnow64Alu::PortOut_Alu out);


	PkgSnow64Alu::SlicedAlu8DataInout __in_a_sliced_8, __in_b_sliced_8;
	PkgSnow64Alu::SlicedAlu16DataInout __in_a_sliced_16, __in_b_sliced_16;
	PkgSnow64Alu::SlicedAlu32DataInout __in_a_sliced_32, __in_b_sliced_32;

	//logic [PkgSnow64Alu::MSB_POS__OF_8:0]
	//	__out_asr8_7, __out_asr8_6, __out_asr8_5, __out_asr8_4,
	//	__out_asr8_3, __out_asr8_2, __out_asr8_1, __out_asr8_0;
	//logic [PkgSnow64Alu::MSB_POS__OF_16:0]
	//	__out_asr16_3, __out_asr16_2, __out_asr16_1, __out_asr16_0;
	//logic [PkgSnow64Alu::MSB_POS__OF_32:0] __out_asr32_1, __out_asr32_0;
	//logic [PkgSnow64Alu::MSB_POS__OF_64:0] __out_asr64;


	// One ArithmeticShiftRight64 module instantiation, which can be
	// re-used for smaller-sized data types
	PkgSnow64Alu::PortIn_Asr64 __in_asr64_0;
	PkgSnow64Alu::PortOut_Asr64 __out_asr64_0;
	ArithmeticShiftRight64 __inst_asr64_0
		(.in_to_shift(__in_asr64_0.to_shift),
		.in_amount(__in_asr64_0.amount),
		.out_data(__out_asr64_0.data));

	PkgSnow64Alu::PortIn_Asr32 __in_asr32_0;
	PkgSnow64Alu::PortOut_Asr32 __out_asr32_0;
	ArithmeticShiftRight32 __inst_asr32_0
		(.in_to_shift(__in_asr32_0.to_shift),
		.in_amount(__in_asr32_0.amount),
		.out_data(__out_asr32_0.data));

	PkgSnow64Alu::PortIn_Asr16 __in_asr16_0, __in_asr16_1;
	PkgSnow64Alu::PortOut_Asr16 __out_asr16_0, __out_asr16_1;
	ArithmeticShiftRight16 __inst_asr16_0
		(.in_to_shift(__in_asr16_0.to_shift),
		.in_amount(__in_asr16_0.amount),
		.out_data(__out_asr16_0.data));
	ArithmeticShiftRight16 __inst_asr16_1
		(.in_to_shift(__in_asr16_1.to_shift),
		.in_amount(__in_asr16_1.amount),
		.out_data(__out_asr16_1.data));

	PkgSnow64Alu::PortIn_Asr8
		__in_asr8_0, __in_asr8_1, __in_asr8_2, __in_asr8_3;
	PkgSnow64Alu::PortOut_Asr8
		__out_asr8_0, __out_asr8_1, __out_asr8_2, __out_asr8_3;
	ArithmeticShiftRight8 __inst_asr8_0
		(.in_to_shift(__in_asr8_0.to_shift),
		.in_amount(__in_asr8_0.amount),
		.out_data(__out_asr8_0.data));
	ArithmeticShiftRight8 __inst_asr8_1
		(.in_to_shift(__in_asr8_1.to_shift),
		.in_amount(__in_asr8_1.amount),
		.out_data(__out_asr8_1.data));
	ArithmeticShiftRight8 __inst_asr8_2
		(.in_to_shift(__in_asr8_2.to_shift),
		.in_amount(__in_asr8_2.amount),
		.out_data(__out_asr8_2.data));
	ArithmeticShiftRight8 __inst_asr8_3
		(.in_to_shift(__in_asr8_3.to_shift),
		.in_amount(__in_asr8_3.amount),
		.out_data(__out_asr8_3.data));

	// Assignments and whatnot
	always @(*)
	begin
		case (in.type_size)
		PkgSnow64Alu::TypSz8:
		begin
			// Compute __out_asr8_7
			`SET_ASR_INPUTS_SIGNEXT(64, 0, 8, 7)
		end

		PkgSnow64Alu::TypSz16:
		begin
			// Compute __out_asr16_3
			`SET_ASR_INPUTS_SIGNEXT(64, 0, 16, 3)
		end

		PkgSnow64Alu::TypSz32:
		begin
			// Compute __out_asr32_1
			`SET_ASR_INPUTS_SIGNEXT(64, 0, 32, 1)
		end

		PkgSnow64Alu::TypSz64:
		begin
			__in_asr64_0.to_shift = in.a;
			__in_asr64_0.amount = in.b;
		end
		endcase
	end

	always @(*)
	begin
		case (in.type_size)
		PkgSnow64Alu::TypSz8:
		begin
			// Compute __out_asr8_6
			`SET_ASR_INPUTS_SIGNEXT(32, 0, 8, 6)
		end

		PkgSnow64Alu::TypSz16:
		begin
			// Compute __out_asr16_2
			`SET_ASR_INPUTS_SIGNEXT(32, 0, 16, 2)
		end

		default:
		begin
			// Compute __out_asr32_0
			`SET_ASR_INPUTS(32, 0, 32, 0)
		end
		endcase
	end

	always @(*)
	begin
		case (in.type_size)
		PkgSnow64Alu::TypSz8:
		begin
			// Compute __out_asr8_5
			`SET_ASR_INPUTS_SIGNEXT(16, 0, 8, 5)
		end

		default:
		begin
			// Compute __out_asr16_1
			`SET_ASR_INPUTS(16, 0, 16, 1)
		end
		endcase
	end

	always @(*)
	begin
		case (in.type_size)
		PkgSnow64Alu::TypSz8:
		begin
			// Compute __out_asr8_4
			`SET_ASR_INPUTS_SIGNEXT(16, 1, 8, 4)
		end

		default:
		begin
			// Compute __out_asr16_0
			`SET_ASR_INPUTS(16, 1, 16, 0)
		end
		endcase
	end

	assign __in_asr8_0.to_shift = __in_a_sliced_8.data_3;
	assign __in_asr8_0.amount = __in_b_sliced_8.data_3;

	assign __in_asr8_1.to_shift = __in_a_sliced_8.data_2;
	assign __in_asr8_1.amount = __in_b_sliced_8.data_2;

	assign __in_asr8_2.to_shift = __in_a_sliced_8.data_1;
	assign __in_asr8_2.amount = __in_b_sliced_8.data_1;

	assign __in_asr8_3.to_shift = __in_a_sliced_8.data_0;
	assign __in_asr8_3.amount = __in_b_sliced_8.data_0;


	assign __in_a_sliced_8 = in.a;
	assign __in_b_sliced_8 = in.b;
	assign __in_a_sliced_16 = in.a;
	assign __in_b_sliced_16 = in.b;
	assign __in_a_sliced_32 = in.a;
	assign __in_b_sliced_32 = in.b;

endmodule
