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
	//printout("`define INSTR_0(word_addr) ",
	//	"__mem[word_addr][0 * 32 +: 32]\n");
	//printout("`define INSTR_1(word_addr) ",
	//	"__mem[word_addr][1 * 32 +: 32]\n");
	//printout("`define INSTR_2(word_addr) ",
	//	"__mem[word_addr][2 * 32 +: 32]\n");
	//printout("`define INSTR_3(word_addr) ",
	//	"__mem[word_addr][3 * 32 +: 32]\n");
	//printout("`define INSTR_4(word_addr) ",
	//	"__mem[word_addr][4 * 32 +: 32]\n");
	//printout("`define INSTR_5(word_addr) ",
	//	"__mem[word_addr][5 * 32 +: 32]\n");
	//printout("`define INSTR_6(word_addr) ",
	//	"__mem[word_addr][6 * 32 +: 32]\n");
	//printout("`define INSTR_7(word_addr) ",
	//	"__mem[word_addr][7 * 32 +: 32]\n");

	auto&& lines = ctx->line();

	for (auto line : lines)
	{
		line->accept(this);
	}

	u64 mem_word_addr = 0;
	//printout("__mem_words_map stuff:  \n");
	for (const auto& iter : __mem_words_map)
	{
		if ((mem_word_addr + 1) != iter.first)
		{
			printout("@", std::hex, iter.first, std::dec, "\n");
		}
		mem_word_addr = iter.first;

		printout(std::hex);
		//for (size_t i=0; i<MemWord::num_instrs_per_word; ++i)
		for (s64 i=MemWord::num_instrs_per_word - 1; i>=0; --i)
		{
			const u32 data_i_3 = get_bits_with_range(iter.second.data[i],
				31, 24);
			const u32 data_i_2 = get_bits_with_range(iter.second.data[i],
				23, 16);
			const u32 data_i_1 = get_bits_with_range(iter.second.data[i],
				15, 8);
			const u32 data_i_0 = get_bits_with_range(iter.second.data[i],
				7, 0);

			if (data_i_3 < 0x10)
			{
				printout(0);
			}
			printout(data_i_3);
			if (data_i_2 < 0x10)
			{
				printout(0);
			}
			printout(data_i_2);
			if (data_i_1 < 0x10)
			{
				printout(0);
			}
			printout(data_i_1);
			if (data_i_0 < 0x10)
			{
				printout(0);
			}
			printout(data_i_0);
			//printout("\n");
		}
		printout(std::dec);
		printout("\n");
		//const auto& mem_word = iter.second;
		//printout(std::hex, iter.first, std::dec, "\n");
	}

	//printout("`undef INSTR_0\n");
	//printout("`undef INSTR_1\n");
	//printout("`undef INSTR_2\n");
	//printout("`undef INSTR_3\n");
	//printout("`undef INSTR_4\n");
	//printout("`undef INSTR_5\n");
	//printout("`undef INSTR_6\n");
	//printout("`undef INSTR_7\n");

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

		//printout("@", std::hex, addr, "\n");
		__curr_instr_addr = addr;
	}
	else if (ctx->TokHexNum())
	{
		const u32 instruction = convert_hex_string(ctx, 
			ctx->TokHexNum()->toString(), num_good_chars);

		// Require that everything be 32-bit or 64-bit
		if (num_good_chars == 8)
		{
			gen(instruction);
		}

		else
		{
			err(ctx, sconcat("MainMemWordsGenerator can ONLY convert ",
				"32-bit and 64-bit data."));
		}

		//printout("\n");
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
		((sizeof(u64) * 8) - 1), 5);
	const size_t index_into_mem_word
		= get_bits_with_range(__curr_instr_addr, 4, 2);

	//const std::string __sysver_defines_arr[]
	//	= {"`INSTR_0", "`INSTR_1", "`INSTR_2", "`INSTR_3",
	//	"`INSTR_4", "`INSTR_5", "`INSTR_6", "`INSTR_7"};


	//printout(__sysver_defines_arr[get_bits_with_range(__curr_instr_addr,
	//	4, 2)]);
	//printout("('h", std::hex, mem_word_addr, std::dec, ") = 'h",
	//	std::hex, instruction, std::dec, ";\n");

	if (__mem_words_map.find(mem_word_addr) == __mem_words_map.end())
	{
		__mem_words_map[mem_word_addr] = MemWord();
	}

	auto& some_mem_word = __mem_words_map.at(mem_word_addr);

	some_mem_word.data[index_into_mem_word] = instruction;

	__curr_instr_addr += num_bytes_per_instr;
}
