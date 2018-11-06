#ifndef src_asm_disasm_visitor_base_class_hpp
#define src_asm_disasm_visitor_base_class_hpp

// src/asm_disasm_visitor_base_class.hpp

#include "misc_includes.hpp"
#include "ANTLRErrorListener.h"
#include "gen_src/DisassemblerGrammarLexer.h"
#include "gen_src/DisassemblerGrammarParser.h"
#include "gen_src/DisassemblerGrammarVisitor.h"


class AsmDisasmVisitorBase
{
public:		// functions
	//virtual int run() = 0;

protected:		// functions
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
	u32 convert_hex_string(antlr4::ParserRuleContext* ctx, 
		const std::string& str, u32& num_good_chars) const;
};

#endif		// src_asm_disasm_visitor_base_class_hpp
