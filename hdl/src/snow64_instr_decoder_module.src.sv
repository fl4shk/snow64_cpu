`include "src/snow64_instr_decoder_defines.header.sv"


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
	//PkgSnow64InstrDecoder::Iog4Instr __iog4_instr;

	assign __iog0_instr = in;
	assign __iog1_instr = in;
	assign __iog2_instr = in;
	assign __iog3_instr = in;
	//assign __iog4_instr = in;

	always @(*) out.group = __iog0_instr.group;
	always @(*) out.op_type = __iog0_instr.op_type;
	always @(*) out.ra_index = __iog0_instr.ra_index;
	always @(*) out.rb_index = __iog0_instr.rb_index;
	always @(*) out.rc_index = __iog0_instr.rc_index;

	always @(*) out.forced_64_bit_integers
		= ((__iog0_instr.group == 0)
		&& ((__iog0_instr.oper == PkgSnow64InstrDecoder::Div_ThreeRegs)
		|| (__iog0_instr.oper == PkgSnow64InstrDecoder::Shl_ThreeRegs)
		|| (__iog0_instr.oper == PkgSnow64InstrDecoder::Shr_ThreeRegs)
		|| (__iog0_instr.oper == PkgSnow64InstrDecoder::Not_TwoRegs)));


	always @(*)
	begin
		case (__iog0_instr.group)
		0:
		begin
			out.oper = __iog0_instr.oper;
			out.nop = (__iog0_instr.oper
				== PkgSnow64InstrDecoder::Bad_Iog0);

			out.signext_imm 
				= `SIGN_EXTEND(PkgSnow64InstrDecoder::WIDTH__ADDR,
				PkgSnow64InstrDecoder::WIDTH__IOG0_SIMM12,
				__iog0_instr.simm12);
			out.decoded_stall_type = PkgSnow64InstrDecoder::DecStalTypNone;
		end

		1:
		begin
			out.oper = __iog1_instr.oper;

			out.nop = !((__iog1_instr.oper
				== PkgSnow64InstrDecoder::Bnz_OneRegOneSimm20)
				|| (__iog1_instr.oper
				== PkgSnow64InstrDecoder::Bzo_OneRegOneSimm20)
				|| (__iog1_instr.oper
				== PkgSnow64InstrDecoder::Jmp_OneReg));

			out.signext_imm 
				= `SIGN_EXTEND(PkgSnow64InstrDecoder::WIDTH__ADDR,
				PkgSnow64InstrDecoder::WIDTH__IOG1_SIMM20,
				__iog1_instr.simm20);
			out.decoded_stall_type
				= PkgSnow64InstrDecoder::DecStalTypEndsInEx;
		end

		2:
		begin
			out.oper = __iog2_instr.oper;

			// out.nop = (__iog2_instr.oper
			// 	>= PkgSnow64InstrDecoder::Bad0_Iog2);
			out.nop = ((__iog2_instr.oper 
				!= PkgSnow64InstrDecoder::LdF16_ThreeRegsOneSimm12)
				&& (__iog2_instr.oper[3]));

			out.signext_imm 
				= `SIGN_EXTEND(PkgSnow64InstrDecoder::WIDTH__ADDR,
				PkgSnow64InstrDecoder::WIDTH__IOG2_SIMM12,
				__iog2_instr.simm12);
			out.decoded_stall_type
				= PkgSnow64InstrDecoder::DecStalTypEndsInWb;
		end

		3:
		begin
			out.oper = __iog3_instr.oper;

			// out.nop = (__iog3_instr.oper
			// 	>= PkgSnow64InstrDecoder::Bad0_Iog3);
			out.nop = ((__iog3_instr.oper 
				!= PkgSnow64InstrDecoder::StF16_ThreeRegsOneSimm12)
				&& (__iog3_instr.oper[3]));

			out.signext_imm 
				= `SIGN_EXTEND(PkgSnow64InstrDecoder::WIDTH__ADDR,
				PkgSnow64InstrDecoder::WIDTH__IOG3_SIMM12,
				__iog3_instr.simm12);
			out.decoded_stall_type
				= PkgSnow64InstrDecoder::DecStalTypEndsInWb;
		end

		//4:
		//begin
		//	out.oper = __iog4_instr.oper;

		//	// out.nop = (__iog4_instr.oper
		//	// 	>= PkgSnow64InstrDecoder::Bad0_Iog4);
		//	out.nop = ((__iog4_instr.oper 
		//		!= PkgSnow64InstrDecoder::Out_TwoRegsOneSimm16)
		//		&& (__iog4_instr.oper[3]));

		//	out.signext_imm 
		//		= `SIGN_EXTEND(PkgSnow64InstrDecoder::WIDTH__ADDR,
		//		PkgSnow64InstrDecoder::WIDTH__IOG4_SIMM16,
		//		__iog4_instr.simm16);
		//end

		// Eek!
		default:
		begin
			out.oper = 0;
			out.nop = 1;
			out.signext_imm = 0;
			out.decoded_stall_type = PkgSnow64InstrDecoder::DecStalTypNone;
		end

		endcase
	end

endmodule
