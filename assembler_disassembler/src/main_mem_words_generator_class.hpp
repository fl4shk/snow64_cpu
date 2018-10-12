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

class MainMemWordsGenerator : public DisassemblerGrammarVisitor
{
private:		// variables
	DisassemblerGrammarParser::ProgramContext* __program_ctx;
	u64 __curr_instr_addr;

public:		// functions
	MainMemWordsGenerator(DisassemblerGrammarParser& parser);

	int run();

private:		// functions
	inline void err(antlr4::ParserRuleContext* ctx, 
		const std::string& msg)
	{
		if (ctx == nullptr)
		{
			printerr("Error:  ", msg, "\n");
		}
		else
		{
			auto tok = ctx->getStart();
			const size_t line = tok->getLine();
			const size_t pos_in_line = tok->getCharPositionInLine();
			//printerr("Error in file \"", *__file_name, "\", on line ",
			//	line, ", position ", pos_in_line, ":  ", msg, "\n");
			printerr("Error on line ", line, ", position ", pos_in_line, 
				":  ", msg, "\n");
		}
		exit(1);
	}
	inline void err(const std::string& msg)
	{
		//printerr("Error in file \"", *__file_name, "\":  ", msg, "\n");
		printerr("Error:  ", msg, "\n");
		exit(1);
	}

private:		// visitor functions
	antlrcpp::Any visitProgram
		(DisassemblerGrammarParser::ProgramContext *ctx);
	antlrcpp::Any visitLine
		(DisassemblerGrammarParser::LineContext *ctx);


private:		// functions
	u32 convert_hex_string(antlr4::ParserRuleContext* ctx, 
		const std::string& str, u32& num_good_chars) const;

	void gen(u32 instruction);

};


#endif		// src__slash__main_mem_words_generator_class_hpp
