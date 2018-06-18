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
		.in_b_msb_pos(in.a[__MSB_POS__DATA_INOUT]),
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

module Snow64Alu(input PkgSnow64Alu::PortIn_Alu in,
	output PkgSnow64Alu::PortOut_Alu out);


	PkgSnow64Alu::SlicedAlu8DataInout __in_a_sliced_8, __in_b_sliced_8;
	PkgSnow64Alu::SlicedAlu16DataInout __in_a_sliced_16, __in_b_sliced_16;
	PkgSnow64Alu::SlicedAlu32DataInout __in_a_sliced_32, __in_b_sliced_32;

	// Assignments
	assign __in_a_sliced_8 = in.a;
	assign __in_b_sliced_8 = in.b;
	assign __in_a_sliced_16 = in.a;
	assign __in_b_sliced_16 = in.b;
	assign __in_a_sliced_32 = in.a;
	assign __in_b_sliced_32 = in.b;

endmodule
