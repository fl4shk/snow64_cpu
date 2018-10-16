#ifndef src__slash__main_mem_words_generator_class_hpp
#define src__slash__main_mem_words_generator_class_hpp

// src/main_mem_words_generator_class.hpp

#include "misc_includes.hpp"
#include "ANTLRErrorListener.h"
#include "gen_src/DisassemblerGrammarLexer.h"
#include "gen_src/DisassemblerGrammarParser.h"
#include "gen_src/DisassemblerGrammarVisitor.h"

#include "symbol_table_classes.hpp"

#include "encoding_stuff_class.hpp"
#include "asm_disasm_visitor_base_class.hpp"

class MainMemWordsGenerator : public DisassemblerGrammarVisitor,
	public AsmDisasmVisitorBase
{
public:		// classes
	class MemWord
	{
	public:		// constants
		static constexpr size_t num_instrs_per_word = 8;
	public:		// variables
		u32 data[num_instrs_per_word];

	public:		// functions
		inline MemWord()
		{
			for (size_t i=0; i<num_instrs_per_word; ++i)
			{
				data[i] = 0;
			}
		}

		inline MemWord(const MemWord& to_copy)
		{
			for (size_t i=0; i<num_instrs_per_word; ++i)
			{
				data[i] = to_copy.data[i];
			}
		}
		virtual ~MemWord()
		{
		}

		inline MemWord& operator = (const MemWord& to_copy)
		{
			for (size_t i=0; i<num_instrs_per_word; ++i)
			{
				data[i] = to_copy.data[i];
			}
			return *this;
		}
	};
private:		// variables
	DisassemblerGrammarParser::ProgramContext* __program_ctx;
	u64 __curr_instr_addr;
	//std::vector<u64> __word_addresses_vec;
	std::map<u64, MemWord> __mem_words_map;

public:		// functions
	MainMemWordsGenerator(DisassemblerGrammarParser& parser);

	int run();


private:		// visitor functions
	antlrcpp::Any visitProgram
		(DisassemblerGrammarParser::ProgramContext *ctx);
	antlrcpp::Any visitLine
		(DisassemblerGrammarParser::LineContext *ctx);


private:		// functions

	void gen(antlr4::ParserRuleContext* ctx, 
		u32 to_gen, u32 num_good_chars);

};


#endif		// src__slash__main_mem_words_generator_class_hpp
