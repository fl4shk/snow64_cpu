#include "disassembler_class.hpp"

Disassembler::Disassembler(DisassemblerGrammarParser& parser)
{
	__program_ctx = parser.program();
}

int Disassembler::run()
{
	visitProgram(__program_ctx);
	return 0;
}

antlrcpp::Any Disassembler::visitProgram
	(DisassemblerGrammarParser::ProgramContext *ctx)
{
	auto&& lines = ctx->line();

	for (auto line : lines)
	{
		line->accept(this);
	}

	return nullptr;
}
antlrcpp::Any Disassembler::visitLine
	(DisassemblerGrammarParser::LineContext *ctx)
{
	u32 num_good_chars;
	if (ctx->TokOrg())
	{
		const u32 addr = convert_hex_string(ctx, ctx->TokOrg()->toString(),
			num_good_chars);

		// This isn't perfect, as it does plain ".org" always, but never
		// ".space"
		// 
		// It should still work, though
		printout(".org ", std::hex, "0x", addr, std::dec, "\n");
	}
	else if (ctx->TokHexNum())
	{
		const u32 instruction = convert_hex_string(ctx, 
			ctx->TokHexNum()->toString(), num_good_chars);

		auto show_unknown_instruction_as_dot_db = [&]() -> void
		{
			if (num_good_chars == 2)
			{
				display_dot_db8(instruction);
			}
			else if (num_good_chars == 4)
			{
				display_dot_db16(instruction);
			}
			else if (num_good_chars == 8)
			{
				display_dot_db32(instruction);
			}
			else
			{
				err(ctx, "Disassembler::visitLine():  Eek 1!");
			}
		};

		if ((num_good_chars != 2) && (num_good_chars != 4)
			&& (num_good_chars != 8))
		{
			err(ctx, "Allowed data sizes:   8-bit, 16-bit, 32-bit");
		}

		if (num_good_chars == 8)
		{
			const u32 iog = decode_iog(instruction);
			u32 sv_bit = 0;
			u32 reg_a_index = 0, reg_b_index = 0, reg_c_index = 0, 
				opcode= 0;
			s32 simm12 = 0, simm20 = 0, simm16 = 0;
			std::string * reg_a_name = nullptr, * reg_b_name = nullptr, 
				* reg_c_name = nullptr;
			std::string* instr_name = nullptr;
			EncodingStuff::ArgsType args_type 
				= EncodingStuff::ArgsType::Unknown;

			switch (iog)
			{
				case 0x0:
					decode_group_0_instr(instruction, sv_bit, reg_a_index,
						reg_b_index, reg_c_index, opcode, simm12);
					//__encoding_stuff.get_iog0_instr_from_opcode(opcode,
					//	instr_name, args_type);
					__encoding_stuff.decode_iog0_instr_name_and_args_type
						(sv_bit, opcode, instr_name, args_type);
					break;
				case 0x1:
					decode_group_1_instr(instruction, reg_a_index, opcode,
						simm20);
					__encoding_stuff.decode_iog1_instr_name_and_args_type
						(sv_bit, opcode, instr_name, args_type);
					break;
				case 0x2:
					decode_group_2_instr(instruction, reg_a_index,
						reg_b_index, reg_c_index, opcode, simm12);
					__encoding_stuff.decode_iog2_instr_name_and_args_type
						(sv_bit, opcode, instr_name, args_type);
					break;
				case 0x3:
					decode_group_3_instr(instruction, reg_a_index,
						reg_b_index, reg_c_index, opcode, simm12);
					__encoding_stuff.decode_iog3_instr_name_and_args_type
						(sv_bit, opcode, instr_name, args_type);
					break;
				default:
					show_unknown_instruction_as_dot_db();
					printout("\n");
					return nullptr;
			}

			reg_a_name = __encoding_stuff.decode_reg_name(reg_a_index);
			reg_b_name = __encoding_stuff.decode_reg_name(reg_b_index);
			reg_c_name = __encoding_stuff.decode_reg_name(reg_c_index);

			switch (args_type)
			{
				//case EncodingStuff::ArgsType::ThreeRegs:
				//	printout(*instr_name, " ", strappcom2(*reg_a_name, 
				//		*reg_b_name, *reg_c_name));
				//	break;
				case EncodingStuff::ArgsType::ThreeRegsScalar:
					printout(*instr_name, " ", strappcom2(*reg_a_name,
						*reg_b_name, *reg_c_name));
					break;
				case EncodingStuff::ArgsType::TwoRegsScalar:
					printout(*instr_name, " ", strappcom2(*reg_a_name,
						*reg_b_name));
					break;
				case EncodingStuff::ArgsType::OneRegOnePcOneSimm12Scalar:
					printout(*instr_name, " ", strappcom2(*reg_a_name,
						"pc", simm12));
					break;
				case EncodingStuff::ArgsType::TwoRegsOneSimm12Scalar:
					printout(*instr_name, " ", strappcom2(*reg_a_name,
						*reg_b_name, simm12));
					break;

				case EncodingStuff::ArgsType::ThreeRegsVector:
					printout(*instr_name, " ", strappcom2(*reg_a_name,
						*reg_b_name, *reg_c_name));
					break;
				case EncodingStuff::ArgsType::TwoRegsVector:
					printout(*instr_name, " ", strappcom2(*reg_a_name,
						*reg_b_name));
					break;
				case EncodingStuff::ArgsType::OneRegOnePcOneSimm12Vector:
					printout(*instr_name, " ", strappcom2(*reg_a_name,
						"pc", simm12));
					break;
				case EncodingStuff::ArgsType::TwoRegsOneSimm12Vector:
					printout(*instr_name, " ", strappcom2(*reg_a_name,
						*reg_b_name, simm12));
					break;

				case EncodingStuff::ArgsType::ThreeRegsOneSimm12:
					printout(*instr_name, " ", strappcom2(*reg_a_name,
						*reg_b_name, *reg_c_name, simm12));
					break;


				case EncodingStuff::ArgsType::RelBranch:
					printout(*instr_name, " ", strappcom2(*reg_a_name,
						simm20));
					break;
				case EncodingStuff::ArgsType::Jump:
					printout(*instr_name, " ", *reg_a_name);
					break;


				case EncodingStuff::ArgsType::LdThreeRegsOneSimm12:
					printout(*instr_name, " ", strappcom2(*reg_a_name,
						*reg_b_name, *reg_c_name, simm12));
					break;
				case EncodingStuff::ArgsType::StThreeRegsOneSimm12:
					printout(*instr_name, " ", strappcom2(*reg_a_name,
						*reg_b_name, *reg_c_name, simm12));
					break;

				case EncodingStuff::ArgsType::Unknown:
					show_unknown_instruction_as_dot_db();
					printout("\n");
					return nullptr;
					break;
				default:
					err(ctx, "Disassembler::visitLine():  Eek 2!");
					break;
			}

		}
		else
		{
			show_unknown_instruction_as_dot_db();
			printout("\n");
			return nullptr;
		}


		printout("\n");
	}
	else if (ctx->TokNewline())
	{
		// Just a blank line (or one with only a comment), so do nothing.
	}
	else
	{
		err(ctx, "visitLine():  Eek 3!");
	}

	return nullptr;
}
//u32 Disassembler::convert_hex_string(antlr4::ParserRuleContext* ctx,
//	const std::string& str, u32& num_good_chars) const
//{
//	std::string temp_str;
//
//	for (size_t i=0; i<str.size(); ++i)
//	{
//		if ((str.at(i) != '@') && (str.at(i) != ' '))
//		{
//			temp_str += str.at(i);
//		}
//	}
//	//printout("str, temp_str:  ", strappcom2(str, temp_str), "\n");
//	num_good_chars = temp_str.size();
//
//	u32 temp = 0;
//	for (size_t i=0; i<temp_str.size(); ++i)
//	{
//		if ((temp_str.at(i) >= '0') && (temp_str.at(i) <= '9'))
//		{
//			temp |= (temp_str.at(i) - '0');
//		}
//		else if ((temp_str.at(i) >= 'a') && (temp_str.at(i) <= 'f'))
//		{
//			temp |= (temp_str.at(i) - 'a' + 0xa);
//		}
//		else if ((temp_str.at(i) >= 'A') && (temp_str.at(i) <= 'F'))
//		{
//			temp |= (temp_str.at(i) - 'A' + 0xa);
//		}
//		else
//		{
//			const std::string msg("convert_hex_string():  Eek!");
//
//			auto tok = ctx->getStart();
//			const size_t line = tok->getLine();
//			const size_t pos_in_line = tok->getCharPositionInLine();
//			//printerr("Error in file \"", *__file_name, "\", on line ",
//			//	line, ", position ", pos_in_line, ":  ", msg, "\n");
//			printerr("Error on line ", line, ", position ", pos_in_line, 
//				":  ", msg, "\n");
//			exit(1);
//		}
//
//		if ((i + 1) < temp_str.size())
//		{
//			temp <<= 4;
//		}
//	}
//	//printout(std::hex, "0x", temp, std::dec);
//
//	return temp;
//}
