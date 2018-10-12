#include "main_mem_words_generator_class.hpp"

MainMemWordsGenerator::MainMemWordsGenerator
	(DisassemblerGrammarParser& parser)
{
	__program_ctx = parser.program();
	__curr_instr_addr = 0;
}

int MainMemWordsGenerator::run()
{
	visitProgram(__program_ctx);
	return 0;
}

antlrcpp::Any MainMemWordsGenerator::visitProgram
	(DisassemblerGrammarParser::ProgramContext *ctx)
{
	auto&& lines = ctx->line();

	for (auto line : lines)
	{
		line->accept(this);
	}

	return nullptr;
}
antlrcpp::Any MainMemWordsGenerator::visitLine
	(DisassemblerGrammarParser::LineContext *ctx)
{
	u32 num_good_chars;
	if (ctx->TokOrg())
	{
		const u64 addr = convert_hex_string(ctx, ctx->TokOrg()->toString(),
			num_good_chars);

		//// This isn't perfect, as it does plain ".org" always, but never
		//// ".space"
		//// 
		//// It should still work, though
		//printout(".org ", std::hex, "0x", addr, std::dec, "\n");

		if ((addr & (~static_cast<u64>(0b11))) != addr)
		{
			err(ctx, sconcat("MainMemWordsGenerator can ONLY handle ",
				"addresses aligned to 32-bits."));
		}

		printout("@", std::hex, addr, "\n");
		__curr_instr_addr = addr;
	}
	else if (ctx->TokHexNum())
	{
		const u32 instruction = convert_hex_string(ctx, 
			ctx->TokHexNum()->toString(), num_good_chars);

		// Require that everything be 32-bit or 64-bit
		if (num_good_chars == 4)
		{
			gen(instruction);
		}

		else
		{
			err(ctx, sconcat("MainMemWordsGenerator can ONLY convert ",
				"32-bit and 64-bit data."));
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
u32 MainMemWordsGenerator::convert_hex_string
	(antlr4::ParserRuleContext* ctx, const std::string& str,
	u32& num_good_chars) const
{
	std::string temp_str;

	for (size_t i=0; i<str.size(); ++i)
	{
		if ((str.at(i) != '@') && (str.at(i) != ' '))
		{
			temp_str += str.at(i);
		}
	}
	//printout("str, temp_str:  ", strappcom2(str, temp_str), "\n");
	num_good_chars = temp_str.size();

	u32 temp = 0;
	for (size_t i=0; i<temp_str.size(); ++i)
	{
		if ((temp_str.at(i) >= '0') && (temp_str.at(i) <= '9'))
		{
			temp |= (temp_str.at(i) - '0');
		}
		else if ((temp_str.at(i) >= 'a') && (temp_str.at(i) <= 'f'))
		{
			temp |= (temp_str.at(i) - 'a' + 0xa);
		}
		else if ((temp_str.at(i) >= 'A') && (temp_str.at(i) <= 'F'))
		{
			temp |= (temp_str.at(i) - 'A' + 0xa);
		}
		else
		{
			const std::string msg("convert_hex_string():  Eek!");

			auto tok = ctx->getStart();
			const size_t line = tok->getLine();
			const size_t pos_in_line = tok->getCharPositionInLine();
			//printerr("Error in file \"", *__file_name, "\", on line ",
			//	line, ", position ", pos_in_line, ":  ", msg, "\n");
			printerr("Error on line ", line, ", position ", pos_in_line, 
				":  ", msg, "\n");
			exit(1);
		}

		if ((i + 1) < temp_str.size())
		{
			temp <<= 4;
		}
	}
	//printout(std::hex, "0x", temp, std::dec);

	return temp;
}

void MainMemWordsGenerator::gen(u32 instruction)
{
	static constexpr size_t num_bytes_per_instr = sizeof(u32);

	const size_t mem_word_addr = get_bits_with_range(__curr_instr_addr,
		(sizeof(u64) - 1), 5);

	// (get_bits_with_range(__curr_instr_addr, 5, 2))
	//{
	//}

	__curr_instr_addr += num_bytes_per_instr;
}
