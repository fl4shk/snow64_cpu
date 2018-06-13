`include "src/snow64_alu_defines.header.sv"


module __Snow64Alu #(parameter WIDTH__DATA_INOUT=64)
	(input logic [__MSB_POS__DATA_INOUT:0] in_a, in_b,
	input logic [`MSB_POS__SNOW64_CPU_ALU_OPER:0] in_oper,
	input logic in_unsgn_or_sgn,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	import PkgSnow64Alu::*;
	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(WIDTH__DATA_INOUT);

	logic __out_slts;

	SetLessThanSigned #(.WIDTH__DATA_INOUT(WIDTH__DATA_INOUT))
		__inst_slts(.in_a(in_a), .in_b(in_b), .out_data(__out_slts));

	struct packed
	{
		logic [__MSB_POS__DATA_INOUT:0] to_shift, amount;
	} __in_asr;

	struct packed
	{
		logic [__MSB_POS__DATA_INOUT:0] data;
	} __out_asr;

	ArithmeticShiftRight #(.WIDTH__DATA_INOUT(WIDTH__DATA_INOUT))
		__inst_asr(.in_to_shift(__in_asr.to_shift),
		.in_amount(__in_asr.amount),
		.out_data(__out_asr.data));



	// Assignments
	always @(*)
	begin
		__in_asr.to_shift = in_a;
	end

	always @(*)
	begin
		__in_asr.amount = in_b;
	end

	always @(*)
	begin
		case (in_oper)

		PkgSnow64Alu::OpAdd:
		begin
			out_data = in_a + in_b;
		end
		PkgSnow64Alu::OpSub:
		begin
			out_data = in_a - in_b;
		end
		PkgSnow64Alu::OpSlt:
		begin
			case (in_unsgn_or_sgn)
			// Unsigned
			0:
			begin
				out_data = (in_a < in_b);
			end

			// Signed
			1:
			begin
				out_data = __out_slts;
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
			out_data = in_a & in_b;
		end
		PkgSnow64Alu::OpOrr:
		begin
			out_data = in_a | in_b;
		end
		PkgSnow64Alu::OpXor:
		begin
			out_data = in_a ^ in_b;
		end

		PkgSnow64Alu::OpShl:
		begin
			out_data = in_a << in_b;
		end
		PkgSnow64Alu::OpShr:
		begin
			case (in_unsgn_or_sgn)
			0:
			begin
				out_data = in_a >> in_b;
			end

			1:
			begin
				//out_data = $signed(in_a) >>> in_b;
				out_data = __out_asr.data;
			end
			endcase
		end
		PkgSnow64Alu::OpInv:
		begin
			out_data = ~in_a;
		end
		PkgSnow64Alu::OpNot:
		begin
			out_data = !in_a;
		end

		PkgSnow64Alu::OpAddAgain:
		begin
			out_data = in_a + in_b;
		end
		//PkgSnow64Alu::OpDummy2:
		//begin
		//end
		//PkgSnow64Alu::OpDummy3:
		//begin
		//end
		//PkgSnow64Alu::OpDummy4:
		//begin
		//end
		default:
		begin
			out_data = 0;
		end

		endcase
	end

endmodule

module Snow64Alu64(input PkgSnow64Alu::PortIn_Alu64 in,
	output PkgSnow64Alu::PortOut_Alu64 out);

	import PkgSnow64Alu::*;

	__Snow64Alu #(.WIDTH__DATA_INOUT(`WIDTH__SNOW64_CPU_ALU_64_DATA_INOUT))
		__inst_alu(.in_a(in.a), .in_b(in.b), .in_oper(in.oper),
		.in_unsgn_or_sgn(in.unsgn_or_sgn), .out_data(out.data));

endmodule
module Snow64Alu32(input PkgSnow64Alu::PortIn_Alu32 in,
	output PkgSnow64Alu::PortOut_Alu32 out);

	import PkgSnow64Alu::*;

	__Snow64Alu #(.WIDTH__DATA_INOUT(`WIDTH__SNOW64_CPU_ALU_32_DATA_INOUT))
		__inst_alu(.in_a(in.a), .in_b(in.b), .in_oper(in.oper),
		.in_unsgn_or_sgn(in.unsgn_or_sgn), .out_data(out.data));
endmodule
module Snow64Alu16(input PkgSnow64Alu::PortIn_Alu16 in,
	output PkgSnow64Alu::PortOut_Alu16 out);

	import PkgSnow64Alu::*;

	__Snow64Alu #(.WIDTH__DATA_INOUT(`WIDTH__SNOW64_CPU_ALU_16_DATA_INOUT))
		__inst_alu(.in_a(in.a), .in_b(in.b), .in_oper(in.oper),
		.in_unsgn_or_sgn(in.unsgn_or_sgn), .out_data(out.data));
endmodule
module Snow64Alu8(input PkgSnow64Alu::PortIn_Alu8 in,
	output PkgSnow64Alu::PortOut_Alu8 out);

	import PkgSnow64Alu::*;

	__Snow64Alu #(.WIDTH__DATA_INOUT(`WIDTH__SNOW64_CPU_ALU_8_DATA_INOUT))
		__inst_alu(.in_a(in.a), .in_b(in.b), .in_oper(in.oper),
		.in_unsgn_or_sgn(in.unsgn_or_sgn), .out_data(out.data));
endmodule
