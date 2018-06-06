#include "assembler_class.hpp"
#include "allocation_stuff.hpp"

#include <sstream>



#define ANY_JUST_ACCEPT_BASIC(arg) \
	arg->accept(this)

#define ANY_ACCEPT_IF_BASIC(arg) \
	if (arg) \
	{ \
		ANY_JUST_ACCEPT_BASIC(arg); \
	}

#define ANY_PUSH_TOK_IF(arg) \
	if (arg) \
	{ \
		push_str(cstm_strdup(arg->toString())); \
	}

Assembler::Assembler(AssemblerGrammarParser& parser, bool s_show_words)
	: __show_words(s_show_words)
{
	__program_ctx = parser.program();


}

int Assembler::run()
{
	push_scope_child_num(0);
	// Two passes
	for (__pass=0; __pass<2; ++__pass)
	{
		//__pc = 0;
		//__pc.prev = __pc.curr = 0;
		__pc.curr = 0;
		__pc.back_up();

		__curr_scope_node = sym_tbl().tree().children.front();

		visitProgram(__program_ctx);
	}

	return 0;
}

template<typename CtxType>
auto Assembler::get_reg_encodings(CtxType *ctx) const
{
	std::vector<u16> ret;

	auto&& regs = ctx->TokReg();

	// If only I could check here whether or not CtxType can be iterated
	// through!
	// Perhaps there actually is a way in the C++ standard library....
	for (auto reg : regs)
	{
		ret.push_back(__encoding_stuff.reg_names_map()
			.at(cstm_strdup(reg->toString())));
	}

	return ret;
}

inline auto Assembler::get_one_reg_encoding(const std::string& reg_name) 
	const
{
	return __encoding_stuff.reg_names_map().at(cstm_strdup(reg_name));
}

void Assembler::gen_words(u16 data)
{
	if (__pass)
	{
		// Output big endian
		printout(std::hex);

		if (__pc.has_changed())
		{
			printout("@", __pc.curr, "\n");
		}

		//printout(get_bits_with_range(data, 15, 8), "");
		//printout(get_bits_with_range(data, 7, 0), "\n");
		const u32 a = get_bits_with_range(data, 15, 8);
		const u32 b = get_bits_with_range(data, 7, 0);

		if (a < 0x10)
		{
			printout(0);
		}
		printout(a);

		if (b < 0x10)
		{
			printout(0);
		}
		printout(b);

		printout(std::dec);
	}
	//__pc += sizeof(data);
	__pc.curr += sizeof(data);
	__pc.back_up();
}
void Assembler::gen_8(u8 data)
{
	if (__pass)
	{
		printout(std::hex);

		if (__pc.has_changed())
		{
			printout("@", __pc.curr, "\n");
		}

		const u32 a = data;

		if (a < 0x10)
		{
			printout(0);
		}
		printout(a);
		printout(std::dec);
	}

	//__pc += sizeof(data);
	__pc.curr += sizeof(data);
	__pc.back_up();

	//print_words_if_allowed("\n");

	if (__pass)
	{
		printout("\n");
	}
}
void Assembler::gen_16(u16 data)
{
	//gen_no_words(data);
	//print_words_if_allowed("\n");
	//gen_8(get_bits_with_range(data, 15, 8));
	//gen_8(get_bits_with_range(data, 7, 0));

	//if (__pass)
	{
		if (__show_words)
		{
			gen_words(data);

			if (__pass)
			{
				printout("\n");
			}
		}
		else
		{
			// Big endian
			gen_8(get_bits_with_range(data, 15, 8));
			gen_8(get_bits_with_range(data, 7, 0));
		}
	}
}
void Assembler::gen_32(u32 data)
{
	//gen_no_words(get_bits_with_range(data, 31, 16));
	//print_words_if_allowed(" ");
	//gen_no_words(get_bits_with_range(data, 15, 0));
	//print_words_if_allowed("\n");

	//if (__pass)
	{
		if (__show_words)
		{
			gen_words(get_bits_with_range(data, 31, 16));

			if (__pass)
			{
				printout(" ");
			}
			gen_words(get_bits_with_range(data, 15, 0));

			if (__pass)
			{
				printout("\n");
			}
		}
		else
		{
			// Big endian
			gen_8(get_bits_with_range(data, 31, 24));
			gen_8(get_bits_with_range(data, 23, 16));
			gen_8(get_bits_with_range(data, 15, 8));
			gen_8(get_bits_with_range(data, 7, 0));
		}
	}

}

antlrcpp::Any Assembler::visitProgram
	(AssemblerGrammarParser::ProgramContext *ctx)
{
	auto&& lines = ctx->line();

	for (auto line : lines)
	{
		line->accept(this);
	}

	return nullptr;
}

antlrcpp::Any Assembler::visitLine
	(AssemblerGrammarParser::LineContext *ctx)
{
	ANY_ACCEPT_IF_BASIC(ctx->scopedLines())
	else ANY_ACCEPT_IF_BASIC(ctx->label())
	else ANY_ACCEPT_IF_BASIC(ctx->instruction())
	else ANY_ACCEPT_IF_BASIC(ctx->pseudoInstruction())
	else ANY_ACCEPT_IF_BASIC(ctx->directive())
	else
	{
		// Blank line or a line comment
	}

	return nullptr;
}

// line:
antlrcpp::Any Assembler::visitScopedLines
	(AssemblerGrammarParser::ScopedLinesContext *ctx)
{
	if (!__pass)
	{
		sym_tbl().mkscope(__curr_scope_node);
	}
	else // if (__pass)
	{
		__curr_scope_node = __curr_scope_node->children
			.at(get_top_scope_child_num());
		push_scope_child_num(0);
	}
	auto&& lines = ctx->line();

	for (auto line : lines)
	{
		line->accept(this);
	}

	if (!__pass)
	{
		sym_tbl().rmscope(__curr_scope_node);
	}
	else // if (__pass)
	{
		pop_scope_child_num();

		if (__scope_child_num_stack.size() >= 1)
		{
			auto temp = pop_scope_child_num();
			++temp;
			push_scope_child_num(temp);
		}
		__curr_scope_node = __curr_scope_node->parent;
	}

	return nullptr;
}

antlrcpp::Any Assembler::visitLabel
	(AssemblerGrammarParser::LabelContext *ctx)
{
	ANY_JUST_ACCEPT_BASIC(ctx->identName());

	auto name = pop_str();

	// What's up with "sym->found_as_label()", you may ask?
	// This disallows duplicate labels in the same scope.
	// Note that this check only needs to be performed in the first pass
	// (pass zero).
	{
	auto sym = sym_tbl().find_in_this_blklev(__curr_scope_node, name);
	if ((sym != nullptr) && !__pass && sym->found_as_label())
	{
		err(ctx, sconcat("Error:  Cannot have two identical identifers!  ",
			"The offending identifier is \"", *name, "\"\n"));
	}
	}
	auto sym = sym_tbl().find_or_insert(__curr_scope_node, name);

	sym->set_found_as_label(true);
	sym->set_addr(pc().curr);

	//printout("visitLabel():  ", pc().curr, "\n");

	return nullptr;
}
antlrcpp::Any Assembler::visitInstruction
	(AssemblerGrammarParser::InstructionContext *ctx)
{
	ANY_ACCEPT_IF_BASIC(ctx->instrOpGrp0ThreeRegsScalar())
	else ANY_ACCEPT_IF_BASIC(ctx->instrOpGrp0TwoRegsScalar())
	else ANY_ACCEPT_IF_BASIC(ctx->instrOpGrp0OneRegOnePcOneSimm12Scalar())

	else ANY_ACCEPT_IF_BASIC(ctx->instrOpGrp0ThreeRegsVector())
	else ANY_ACCEPT_IF_BASIC(ctx->instrOpGrp0TwoRegsVector())
	else ANY_ACCEPT_IF_BASIC(ctx->instrOpGrp0OneRegOnePcOneSimm12Vector())

	else ANY_ACCEPT_IF_BASIC(ctx->instrOpGrp1RelBranch())
	else ANY_ACCEPT_IF_BASIC(ctx->instrOpGrp1Jump())

	else ANY_ACCEPT_IF_BASIC(ctx->instrOpGrp1OneRegOneInterruptsReg())
	else ANY_ACCEPT_IF_BASIC(ctx->instrOpGrp1OneInterruptsRegOneReg())
	else ANY_ACCEPT_IF_BASIC(ctx->instrOpGrp1NoArgs())

	else ANY_ACCEPT_IF_BASIC(ctx->instrOpGrp2LdThreeRegsOneSimm12())
	else ANY_ACCEPT_IF_BASIC(ctx->instrOpGrp3StThreeRegsOneSimm12())

	else ANY_ACCEPT_IF_BASIC(ctx->instrOpGrp4IoTwoRegsOneSimm16())

	else
	{
		err(ctx, "visitInstruction():  Eek!");
	}
	return nullptr;
}
antlrcpp::Any Assembler::visitDirective
	(AssemblerGrammarParser::DirectiveContext *ctx)
{
	ANY_ACCEPT_IF_BASIC(ctx->dotOrgDirective())
	else ANY_ACCEPT_IF_BASIC(ctx->dotSpaceDirective())
	else ANY_ACCEPT_IF_BASIC(ctx->dotDb64Directive())
	else ANY_ACCEPT_IF_BASIC(ctx->dotDb32Directive())
	else ANY_ACCEPT_IF_BASIC(ctx->dotDb16Directive())
	else ANY_ACCEPT_IF_BASIC(ctx->dotDb8Directive())
	else
	{
		err(ctx, "visitDirective():  Eek!");
	}
	return nullptr;
}

// instruction:
//antlrcpp::Any Assembler::visitInstrOpGrp0ThreeRegs
//	(AssemblerGrammarParser::InstrOpGrp0ThreeRegsContext *ctx)
//{
//	ANY_PUSH_TOK_IF(ctx->TokInstrNameAdd())
//	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSub())
//	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSltu())
//	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSlts())
//	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSgtu())
//	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSgts())
//	else ANY_PUSH_TOK_IF(ctx->TokInstrNameMul())
//	else ANY_PUSH_TOK_IF(ctx->TokInstrNameAnd())
//	else ANY_PUSH_TOK_IF(ctx->TokInstrNameOrr())
//	else ANY_PUSH_TOK_IF(ctx->TokInstrNameXor())
//	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLsl ())
//	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLsr())
//	else ANY_PUSH_TOK_IF(ctx->TokInstrNameAsr())
//	else ANY_PUSH_TOK_IF(ctx->TokInstrNameUdiv())
//	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSdiv())
//	else
//	{
//		err(ctx, "visitInstrOpGrp0ThreeRegs():  Eek!");
//	}
//
//	const auto opcode = __encoding_stuff.iog0_three_regs_map()
//		.at(pop_str());
//
//	auto&& reg_encodings = get_reg_encodings(ctx);
//
//	encode_instr_opcode_group_0(reg_encodings.at(0), reg_encodings.at(1),
//		reg_encodings.at(2), opcode);
//
//
//	return nullptr;
//}


// directive:
antlrcpp::Any Assembler::visitDotOrgDirective
	(AssemblerGrammarParser::DotOrgDirectiveContext *ctx)
{
	ANY_JUST_ACCEPT_BASIC(ctx->expr());
	__pc.curr = pop_num();

	return nullptr;
}
antlrcpp::Any Assembler::visitDotSpaceDirective
	(AssemblerGrammarParser::DotSpaceDirectiveContext *ctx)
{
	ANY_JUST_ACCEPT_BASIC(ctx->expr());
	__pc.curr += pop_num();

	return nullptr;
}

antlrcpp::Any Assembler::visitDotDb64Directive
	(AssemblerGrammarParser::DotDb64DirectiveContext *ctx)
{
	auto&& expressions = ctx->expr();

	for (auto expr : expressions)
	{
		expr->accept(this);
		const auto temp = pop_num();
		// Big endian
		gen_32(get_bits_with_range(temp, 63, 32));
		gen_32(get_bits_with_range(temp, 31, 0));
	}

	return nullptr;
}

antlrcpp::Any Assembler::visitDotDb32Directive
	(AssemblerGrammarParser::DotDb32DirectiveContext *ctx)
{
	auto&& expressions = ctx->expr();

	for (auto expr : expressions)
	{
		expr->accept(this);
		gen_32(pop_num());
	}

	return nullptr;
}
antlrcpp::Any Assembler::visitDotDb16Directive
	(AssemblerGrammarParser::DotDb16DirectiveContext *ctx)
{
	auto&& expressions = ctx->expr();

	for (auto expr : expressions)
	{
		expr->accept(this);
		gen_16(pop_num());
	}

	return nullptr;
}
antlrcpp::Any Assembler::visitDotDb8Directive
	(AssemblerGrammarParser::DotDb8DirectiveContext *ctx)
{
	auto&& expressions = ctx->expr();

	for (auto expr : expressions)
	{
		expr->accept(this);
		gen_8(pop_num());
	}

	return nullptr;
}

// Expression parsing
antlrcpp::Any Assembler::visitExpr
	(AssemblerGrammarParser::ExprContext *ctx)
{
	if (ctx->expr())
	{
		//ctx->expr()->accept(this);
		ANY_JUST_ACCEPT_BASIC(ctx->expr());
		const auto left = pop_num();

		//ctx->exprLogical()->accept(this);
		ANY_JUST_ACCEPT_BASIC(ctx->exprLogical());
		const auto right = pop_num();

		auto&& op = ctx->TokOpLogical()->toString();

		if (op == "&&")
		{
			push_num(left && right);
		}
		else if (op == "||")
		{
			push_num(left || right);
		}
		else
		{
			//printerr("visitExpr():  Eek!\n");
			//exit(1);
			err(ctx, "visitExpr():  Eek!");
		}
	}
	else
	{
		//ctx->exprLogical()->accept(this);
		ANY_JUST_ACCEPT_BASIC(ctx->exprLogical());
	}
	return nullptr;
}
antlrcpp::Any Assembler::visitExprLogical
	(AssemblerGrammarParser::ExprLogicalContext *ctx)
{
	if (ctx->exprLogical())
	{
		//ctx->exprLogical()->accept(this);
		ANY_JUST_ACCEPT_BASIC(ctx->exprLogical());
		const auto left = pop_num();

		//ctx->exprCompare()->accept(this);
		ANY_JUST_ACCEPT_BASIC(ctx->exprCompare());
		const auto right = pop_num();

		auto&& op = ctx->TokOpCompare()->toString();

		if (op == "==")
		{
			push_num(left == right);
		}
		else if (op == "!=")
		{
			push_num(left != right);
		}
		else if (op == "<")
		{
			push_num(left < right);
		}
		else if (op == ">")
		{
			push_num(left > right);
		}
		else if (op == "<=")
		{
			push_num(left <= right);
		}
		else if (op == ">=")
		{
			push_num(left >= right);
		}
		else
		{
			//printerr("visitExprLogical():  Eek!\n");
			//exit(1);
			err(ctx, "visitExprLogical():  Eek!");
		}
	}
	else
	{
		//ctx->exprCompare()->accept(this);
		ANY_JUST_ACCEPT_BASIC(ctx->exprCompare());
	}
	return nullptr;
}
antlrcpp::Any Assembler::visitExprCompare
	(AssemblerGrammarParser::ExprCompareContext *ctx)
{
	ANY_ACCEPT_IF_BASIC(ctx->exprAddSub())
	else ANY_ACCEPT_IF_BASIC(ctx->exprJustAdd())
	else ANY_ACCEPT_IF_BASIC(ctx->exprJustSub())
	else
	{
		//printerr("visitExprCompare():  Eek!\n");
		//exit(1);
		err(ctx, "visitExprCompare():  Eek!");
	}
	return nullptr;
}
antlrcpp::Any Assembler::visitExprJustAdd
	(AssemblerGrammarParser::ExprJustAddContext *ctx)
{
	//ctx->exprAddSub()->accept(this);
	ANY_JUST_ACCEPT_BASIC(ctx->exprAddSub());
	const auto left = pop_num();

	//ctx->exprCompare()->accept(this);
	ANY_JUST_ACCEPT_BASIC(ctx->exprCompare());
	const auto right = pop_num();

	push_num(left + right);

	return nullptr;
}
antlrcpp::Any Assembler::visitExprJustSub
	(AssemblerGrammarParser::ExprJustSubContext *ctx)
{
	//ctx->exprAddSub()->accept(this);
	ANY_JUST_ACCEPT_BASIC(ctx->exprAddSub());
	const auto left = pop_num();

	//ctx->exprCompare()->accept(this);
	ANY_JUST_ACCEPT_BASIC(ctx->exprCompare());
	const auto right = pop_num();

	push_num(left - right);

	return nullptr;
}
antlrcpp::Any Assembler::visitExprAddSub
	(AssemblerGrammarParser::ExprAddSubContext *ctx)
{
	if (ctx->exprAddSub())
	{
		//ctx->exprAddSub()->accept(this);
		ANY_JUST_ACCEPT_BASIC(ctx->exprAddSub());
		const auto left = pop_num();

		//ctx->exprMulDivModEtc()->accept(this);
		ANY_JUST_ACCEPT_BASIC(ctx->exprMulDivModEtc());
		const auto right = pop_num();

		//auto&& op = ctx->TokOpAddSub()->toString();
		std::string op;

		if (ctx->TokOpMulDivMod())
		{
			op = ctx->TokOpMulDivMod()->toString();
		}
		else if (ctx->TokOpBitwise())
		{
			op = ctx->TokOpBitwise()->toString();
		}
		else
		{
			//printerr("visitExprAddSub():  no op thing eek!\n");
			//exit(1);
			err(ctx, "visitExprAddSub():  no op thing eek!");
		}

		if (op == "*")
		{
			push_num(left * right);
		}
		else if (op == "/")
		{
			if (right != 0)
			{
				push_num(left / right);
			}
			else
			{
				if (__pass)
				{
					//printerr("Error:  Cannot divide by zero!\n");
					//exit(1);
					err(ctx, "Error:  Cannot divide by zero!");
				}
				else
				{
					push_num(0);
				}
			}
		}
		else if (op == "%")
		{
			push_num(left % right);
		}
		else if (op == "&")
		{
			push_num(left & right);
		}
		else if (op == "|")
		{
			push_num(left | right);
		}
		else if (op == "^")
		{
			push_num(left ^ right);
		}
		else if (op == "<<")
		{
			push_num(left << right);
		}
		else if (op == ">>")
		{
			// Logical shift right is special
			const u64 left_u = left;
			const u64 right_u = right;
			const u64 to_push = left_u >> right_u;
			push_num(to_push);
		}
		else if (op == ">>>")
		{
			// This relies upon C++ compilers **usually** performing
			// arithmetic right shifting one signed integer by another
			// 
			// Those C++ compilers that don't support this are not
			// supported for building this assembler!
			push_num(left >> right);
		}
		else
		{
			//printerr("visitExprAddSub():  Eek!\n");
			//exit(1);
			err(ctx, "visitExprAddSub():  Eek!");
		}
	}
	else
	{
		//ctx->exprMulDivModEtc()->accept(this);
		ANY_JUST_ACCEPT_BASIC(ctx->exprMulDivModEtc());
	}
	return nullptr;
}
antlrcpp::Any Assembler::visitExprMulDivModEtc
	(AssemblerGrammarParser::ExprMulDivModEtcContext *ctx)
{
	ANY_ACCEPT_IF_BASIC(ctx->exprUnary())
	else ANY_ACCEPT_IF_BASIC(ctx->numExpr())
	else if (ctx->identName())
	{
		//ctx->identName()->accept(this);
		ANY_JUST_ACCEPT_BASIC(ctx->identName());

		if (!__pass)
		{
			pop_str();
			push_num(0);
		}
		else // if (__pass)
		{
			auto name = pop_str();
			auto sym = sym_tbl().find_or_insert(__curr_scope_node, name);

			// Only allow known symbols to be used.
			if (!sym->found_as_label())
			{
				err(ctx, sconcat("Error:  Unknown symbol called \"",
					*name, "\"."));
			}
			push_num(sym->addr());
		}
	}
	else ANY_ACCEPT_IF_BASIC(ctx->currPc())
	else
	{
		//ctx->expr()->accept(this);
		ANY_JUST_ACCEPT_BASIC(ctx->expr());
	}

	return nullptr;
}
antlrcpp::Any Assembler::visitExprUnary
	(AssemblerGrammarParser::ExprUnaryContext *ctx)
{
	ANY_ACCEPT_IF_BASIC(ctx->exprBitInvert())
	else ANY_ACCEPT_IF_BASIC(ctx->exprNegate())
	else ANY_ACCEPT_IF_BASIC(ctx->exprLogNot())
	else
	{
		printerr("visitExprUnary():  Eek!\n");
		exit(1);
	}
	return nullptr;
}

antlrcpp::Any Assembler::visitExprBitInvert
	(AssemblerGrammarParser::ExprBitInvertContext *ctx)
{
	//ctx->expr()->accept(this);
	ANY_JUST_ACCEPT_BASIC(ctx->expr());
	push_num(~pop_num());
	return nullptr;
}
antlrcpp::Any Assembler::visitExprNegate
	(AssemblerGrammarParser::ExprNegateContext *ctx)
{
	//ctx->expr()->accept(this);
	ANY_JUST_ACCEPT_BASIC(ctx->expr());
	push_num(-pop_num());
	return nullptr;
}
antlrcpp::Any Assembler::visitExprLogNot
	(AssemblerGrammarParser::ExprLogNotContext *ctx)
{
	//ctx->expr()->accept(this);
	ANY_JUST_ACCEPT_BASIC(ctx->expr());
	push_num(!pop_num());
	return nullptr;
}


// Last set of token stuff
antlrcpp::Any Assembler::visitIdentName
	(AssemblerGrammarParser::IdentNameContext *ctx)
{
	ANY_PUSH_TOK_IF(ctx->TokIdent())
	else ANY_ACCEPT_IF_BASIC(ctx->instrName())
	else ANY_ACCEPT_IF_BASIC(ctx->pseudoInstrName())
	else ANY_PUSH_TOK_IF(ctx->TokReg())
	else ANY_PUSH_TOK_IF(ctx->TokPcReg())
	else ANY_PUSH_TOK_IF(ctx->TokIretaReg())
	else ANY_PUSH_TOK_IF(ctx->TokIdstaReg())
	else
	{
		err(ctx, "visitIdentName():  Eek!");
	}

	return nullptr;
}
antlrcpp::Any Assembler::visitInstrName
	(AssemblerGrammarParser::InstrNameContext *ctx)
{
	ANY_PUSH_TOK_IF(ctx->TokInstrNameAdd())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSub())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSltu())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSlts())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSgtu())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSgts())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameMul())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameAnd())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameOrr())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameXor())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameNor())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLsl())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLsr())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameAsr())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameUdiv())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSdiv())

	else ANY_PUSH_TOK_IF(ctx->TokInstrNameAddi())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSubi())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSltui())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSltsi())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSgtui())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSgtsi())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameMuli())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameAndi())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameOrri())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameXori())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameNori())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLsli())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLsri())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameAsri())

	else ANY_PUSH_TOK_IF(ctx->TokInstrNameAddsi())

	else ANY_PUSH_TOK_IF(ctx->TokInstrNameCpyhi())

	else ANY_PUSH_TOK_IF(ctx->TokInstrNameBne())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameBeq())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameBltu())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameBgeu())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameBleu())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameBgtu())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameBlts())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameBges())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameBles())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameBgts())

	else ANY_PUSH_TOK_IF(ctx->TokInstrNameJne())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameJeq())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameJltu())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameJgeu())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameJleu())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameJgtu())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameJlts())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameJges())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameJles())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameJgts())

	else ANY_PUSH_TOK_IF(ctx->TokInstrNameCne())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameCeq())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameCltu())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameCgeu())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameCleu())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameCgtu())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameClts())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameCges())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameCles())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameCgts())

	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLdr())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLdh())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLdsh())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLdb())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLdsb())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameStr())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSth())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameStb())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLdri())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLdhi())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLdshi())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLdbi())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameLdsbi())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameStri())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameSthi())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameStbi())

	else ANY_PUSH_TOK_IF(ctx->TokInstrNameEi())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameDi())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameCpy())
	else ANY_PUSH_TOK_IF(ctx->TokInstrNameReti())
	else
	{
		err(ctx, "visitInstrName():  Eek!");
	}

	return nullptr;
}
antlrcpp::Any Assembler::visitPseudoInstrName
	(AssemblerGrammarParser::PseudoInstrNameContext *ctx)
{
	ANY_PUSH_TOK_IF(ctx->TokPseudoInstrNameInv())
	else ANY_PUSH_TOK_IF(ctx->TokPseudoInstrNameInvi())
	else ANY_PUSH_TOK_IF(ctx->TokPseudoInstrNameCpyi())
	else ANY_PUSH_TOK_IF(ctx->TokPseudoInstrNameCpya())
	else ANY_PUSH_TOK_IF(ctx->TokPseudoInstrNameBra())
	else ANY_PUSH_TOK_IF(ctx->TokPseudoInstrNameJmp())
	else ANY_PUSH_TOK_IF(ctx->TokPseudoInstrNameCall())
	else ANY_PUSH_TOK_IF(ctx->TokPseudoInstrNameJmpa())
	else ANY_PUSH_TOK_IF(ctx->TokPseudoInstrNameCalla())
	else ANY_PUSH_TOK_IF(ctx->TokPseudoInstrNameJmpane())
	else ANY_PUSH_TOK_IF(ctx->TokPseudoInstrNameJmpaeq())
	else ANY_PUSH_TOK_IF(ctx->TokPseudoInstrNameCallane())
	else ANY_PUSH_TOK_IF(ctx->TokPseudoInstrNameCallaeq())
	else ANY_PUSH_TOK_IF(ctx->TokPseudoInstrNameInc())
	else ANY_PUSH_TOK_IF(ctx->TokPseudoInstrNameDec())
	else
	{
		err(ctx, "visitPseudoInstrName():  Eek!");
	}

	return nullptr;
}
antlrcpp::Any Assembler::visitNumExpr
	(AssemblerGrammarParser::NumExprContext *ctx)
{
	s64 to_push;

	std::stringstream sstm;
	if (ctx->TokDecNum())
	{
		sstm << ctx->TokDecNum()->toString();
		sstm >> to_push;
	}
	else if (ctx->TokHexNum())
	{
		u64 temp = 0;
		auto&& str = ctx->TokHexNum()->toString();

		for (size_t i=2; i<str.size(); ++i)
		{
			if ((str.at(i) >= '0') && (str.at(i) <= '9'))
			{
				temp |= (str.at(i) - '0');
			}
			else if ((str.at(i) >= 'a') && (str.at(i) <= 'f'))
			{
				temp |= (str.at(i) - 'a' + 0xa);
			}
			else if ((str.at(i) >= 'A') && (str.at(i) <= 'F'))
			{
				temp |= (str.at(i) - 'A' + 0xa);
			}
			else
			{
				err(ctx, "visitNumExpr():  Eek!");
			}

			if ((i + 1) < str.size())
			{
				temp <<= 4;
			}
		}

		to_push = temp;
		//sstm << ctx->TokHexNum()->toString();
		//sstm >> to_push;
	}
	//else if (ctx->TokChar())
	//{
	//	std::string temp;
	//	sstm << ctx->TokChar()->toString();
	//	sstm >> temp;

	//	to_push = temp.at(1);
	//}
	else if (ctx->TokBinNum())
	{
		err(ctx, "Sorry, binary literal numbers are not supported yet.");
	}
	else
	{
		err(ctx, "visitNumExpr():  Eek!");
	}

	push_num(to_push);
	return nullptr;
}
antlrcpp::Any Assembler::visitCurrPc
	(AssemblerGrammarParser::CurrPcContext *ctx)
{
	push_num(__pc.curr);
	return nullptr;
}

void Assembler::__encode_alu_op_three_regs
	(Assembler::ParserRuleContext* ctx,
	const std::string& instr_name,
	u32 reg_a_index, u32 reg_b_index, u32 reg_c_index)
{
	const auto opcode = __encoding_stuff.iog0_three_regs_map()
		.at(cstm_strdup(instr_name));

	encode_instr_opcode_group_0(reg_a_index, reg_b_index, reg_c_index,
		opcode);
}
void Assembler::__encode_alu_op_two_regs_one_imm
	(Assembler::ParserRuleContext* ctx,
	const std::string& instr_name, u32 reg_a_index, u32 reg_b_index, 
	s64 immediate)
{
	if ((instr_name != "sltsi") && (instr_name != "sgtsi"))
	{
		const auto opcode = __encoding_stuff.iog1_two_regs_one_imm_map()
			.at(cstm_strdup(instr_name));

		__warn_if_imm16_out_of_range(ctx, immediate);

		encode_instr_opcode_group_1(reg_a_index, reg_b_index, opcode,
			immediate);
	}
	else
	{
		const auto opcode = __encoding_stuff.iog1_two_regs_one_simm_map()
			.at(cstm_strdup(instr_name));

		__warn_if_simm16_out_of_range(ctx, immediate);

		encode_instr_opcode_group_1(reg_a_index, reg_b_index, opcode,
			immediate);
	}
}
void Assembler::__encode_inv(Assembler::ParserRuleContext* ctx, 
	u32 reg_a_index, u32 reg_b_index)
{
	// inv rA, rB
	// Encoded as "nor rA, rB, zero"

	//const auto opcode = __encoding_stuff.iog0_three_regs_map()
	//	.at(cstm_strdup("nor"));

	////auto&& reg_encodings = get_reg_encodings(ctx);

	////encode_instr_opcode_group_0(reg_encodings.at(0),
	////	reg_encodings.at(1), 0x0, opcode);
	//encode_instr_opcode_group_0(reg_a_index, reg_b_index, 0x0, opcode);

	__encode_alu_op_three_regs(ctx, "nor", reg_a_index, reg_b_index, 0x0);
}
void Assembler::__encode_invi(Assembler::ParserRuleContext* ctx, 
	u32 reg_a_index, s64 immediate)
{
	// invi rA, imm16
	// Encoded as "nori rA, zero, imm16"
	//const auto opcode = __encoding_stuff
	//	.iog1_two_regs_one_imm_map().at(cstm_strdup("nori"));
	//encode_instr_opcode_group_1(reg_a_index, 0x0, opcode, immediate);

	__encode_alu_op_two_regs_one_imm(ctx, "nori", reg_a_index, 0x0, 
		immediate);
}
void Assembler::__encode_cpy_ra_rb(Assembler::ParserRuleContext* ctx, 
	u32 reg_a_index, u32 reg_b_index)
{
	const auto opcode = __encoding_stuff.iog0_three_regs_map()
		.at(cstm_strdup("add"));

	//encode_instr_opcode_group_0(reg_encodings.at(0),
	//	reg_encodings.at(1), 0x0, opcode);
	encode_instr_opcode_group_0(reg_a_index, reg_b_index, 0x0, opcode);
}
void Assembler::__encode_cpy_ra_pc(Assembler::ParserRuleContext* ctx, 
	u32 reg_a_index)
{
	const auto opcode = __encoding_stuff
		.iog1_one_reg_one_pc_one_simm_map().at(cstm_strdup("addsi"));

	encode_instr_opcode_group_1(reg_a_index, 0x0, opcode, 0x0000);
}
void Assembler::__encode_cpyi(Assembler::ParserRuleContext* ctx, 
	u32 reg_a_index, s64 immediate)
{
	//// addi rA, zero, (immediate & 0xffff)
	//const auto first_opcode = __encoding_stuff
	//	.iog1_two_regs_one_imm_map().at(cstm_strdup("addi"));

	////__warn_if_imm16_out_of_range
	//encode_instr_opcode_group_1(reg_a_index, 0x0, first_opcode,
	//	immediate);
	__encode_alu_op_two_regs_one_imm(ctx, "addi", reg_a_index, 0x0,
		immediate);
}
void Assembler::__encode_cpya(Assembler::ParserRuleContext* ctx, 
	u32 reg_a_index, s64 immediate)
{
	// addi rA, zero, (imm32 & 0xffff)
	//__encode_cpyi(ctx, reg_a_index, immediate);

	const auto first_opcode = __encoding_stuff
		.iog1_two_regs_one_imm_map().at(cstm_strdup("addi"));

	encode_instr_opcode_group_1(reg_a_index, 0x0, first_opcode,
		immediate);

	// cpyhi rA, (imm32 >> 16)
	const auto second_opcode = __encoding_stuff
		.iog1_one_reg_one_imm_map().at(cstm_strdup("cpyhi"));
	encode_instr_opcode_group_1(reg_a_index, 0x0, second_opcode,
		(immediate >> 16));
}
void Assembler::__encode_relative_branch
	(Assembler::ParserRuleContext* ctx, const std::string& instr_name, 
	u32 reg_a_index, u32 reg_b_index, s64 raw_immediate)
{
	const auto opcode = __encoding_stuff.iog2_branch_map()
		.at(cstm_strdup(instr_name));

	const auto immediate = raw_immediate - __pc.curr - sizeof(s32);

	__warn_if_simm16_out_of_range(ctx, immediate, true);

	encode_instr_opcode_group_2(reg_a_index, reg_b_index, opcode, 
		immediate);
}
void Assembler::__encode_jump(Assembler::ParserRuleContext* ctx,
	const std::string& instr_name, 
	u32 reg_a_index, u32 reg_b_index, u32 reg_c_index)
{
	const auto opcode = __encoding_stuff.iog3_jump_map()
		.at(cstm_strdup(instr_name));

	encode_instr_opcode_group_3(reg_a_index, reg_b_index, reg_c_index,
		opcode);
}
void Assembler::__encode_call(Assembler::ParserRuleContext* ctx,
	const std::string& instr_name, 
	u32 reg_a_index, u32 reg_b_index, u32 reg_c_index)
{
	const auto opcode = __encoding_stuff.iog4_call_map()
		.at(cstm_strdup(instr_name));

	encode_instr_opcode_group_4(reg_a_index, reg_b_index, reg_c_index,
		opcode);
}

void Assembler::__encode_ldst_three_regs(Assembler::ParserRuleContext* ctx,
	const std::string& instr_name,
	u32 reg_a_index, u32 reg_b_index, u32 reg_c_index)
{
	const auto opcode = __encoding_stuff.iog5_three_regs_ldst_map()
		.at(cstm_strdup(instr_name));

	encode_instr_opcode_group_5_no_simm(reg_a_index, reg_b_index,
		reg_c_index, opcode);
}
void Assembler::__encode_ldst_two_regs_one_simm
	(Assembler::ParserRuleContext* ctx,
	const std::string& instr_name, u32 reg_a_index, u32 reg_b_index, 
	s64 immediate)
{
	const auto opcode = __encoding_stuff.iog5_two_regs_one_simm_ldst_map()
		.at(cstm_strdup(instr_name));

	__warn_if_simm12_out_of_range(ctx, immediate);

	encode_instr_opcode_group_5_with_simm(reg_a_index, reg_b_index, opcode,
		immediate);
}

u32 Assembler::__get_reg_temp_index() const
{
	return __encoding_stuff.reg_names_map().at(cstm_strdup("temp"));
}
