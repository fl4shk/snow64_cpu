#ifndef src__slash__assembler_class_hpp
#define src__slash__assembler_class_hpp

// src/assembler_class.hpp

#include "misc_includes.hpp"
#include "ANTLRErrorListener.h"
#include "gen_src/AssemblerGrammarLexer.h"
#include "gen_src/AssemblerGrammarParser.h"
#include "gen_src/AssemblerGrammarVisitor.h"

#include "symbol_table_classes.hpp"

#include "encoding_stuff_class.hpp"




class Assembler : public AssemblerGrammarVisitor
{
public:		// typedefs
	typedef antlr4::ParserRuleContext ParserRuleContext;

private:		// variables
	SymbolTable __sym_tbl;

	//u64 __pc;

	liborangepower::containers::PrevCurrPair<u64> __pc;

	std::stack<s64> __num_stack;
	//std::stack<bool> __enable_signed_expr_stack;
	std::stack<s64> __scope_child_num_stack;
	std::stack<std::string*> __str_stack;

	EncodingStuff __encoding_stuff;

	AssemblerGrammarParser::ProgramContext* __program_ctx;
	int __pass;

	bool __show_words;

	ScopedTableNode<Symbol>* __curr_scope_node = nullptr;

public:		// functions
	Assembler(AssemblerGrammarParser& parser, bool s_show_words=false);

	int run();

private:		// functions
	inline void err(ParserRuleContext* ctx, const std::string& msg)
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
	inline void warn(ParserRuleContext* ctx, const std::string& msg)
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
			printerr("Warning on line ", line, ", position ", pos_in_line, 
				":  ", msg, "\n");
		}
	}
	inline void warn(const std::string& msg)
	{
		printerr("Warning:  ", msg, "\n");
	}
	//inline void print_words_if_allowed(const std::string some_words)
	//{
	//	if (__pass && __show_words)
	//	{
	//		printout(some_words);
	//	}
	//}

	template<typename CtxType>
	std::vector<u16> get_reg_encodings(CtxType *ctx);

	template<typename CtxType>
	inline auto get_one_reg_encoding(CtxType *ctx);
	inline auto get_one_reg_encoding(const std::string& reg_name);

	//inline void encode_instr_opcode_group_0(u32 reg_a_index, 
	//	u32 reg_b_index, u32 reg_c_index, u32 opcode)
	//{
	//	u64 to_gen = 0;

	//	// clear_and_set_bits(to_gen, 0b0000, 31, 28);
	//	clear_and_set_bits(to_gen, reg_a_index, 27, 24);
	//	clear_and_set_bits(to_gen, reg_b_index, 23, 20);
	//	clear_and_set_bits(to_gen, reg_c_index, 19, 16);
	//	clear_and_set_bits(to_gen, opcode, 3, 0);

	//	gen_32(to_gen);
	//}

	inline void encode_group_0_instr(u32 sv_bit, u32 reg_a_index,
		u32 reg_b_index, u32 reg_c_index, u32 opcode, s32 simm12)
	{
		u64 to_gen = 0;

		// Instruction group (0b000)
		clear_and_set_bits(to_gen, 0b000, 31, 29);
		clear_and_set_bits(to_gen, sv_bit, 28, 28);
		clear_and_set_bits(to_gen, reg_a_index, 27, 24);
		clear_and_set_bits(to_gen, reg_b_index, 23, 20);
		clear_and_set_bits(to_gen, reg_c_index, 19, 16);
		clear_and_set_bits(to_gen, opcode, 15, 12);
		clear_and_set_bits(to_gen, simm12, 11, 0);

		gen_32(to_gen);
	}

	inline void encode_group_1_instr(u32 reg_a_index, u32 opcode,
		s32 simm20)
	{
		u64 to_gen = 0;

		// Instrucgion group (0b001)
		clear_and_set_bits(to_gen, 0b001, 31, 29);
		clear_and_set_bits(to_gen, reg_a_index, 27, 24);
		clear_and_set_bits(to_gen, opcode, 23, 20);
		clear_and_set_bits(to_gen, simm20, 19, 0);


		gen_32(to_gen);
	}

	inline void encode_group_2_instr(u32 reg_a_index, u32 reg_b_index,
		u32 reg_c_index, u32 opcode, s32 simm12)
	{
		u64 to_gen = 0;

		// Instruction group (0b010)
		clear_and_set_bits(to_gen, 0b010, 31, 29);
		clear_and_set_bits(to_gen, reg_a_index, 27, 24);
		clear_and_set_bits(to_gen, reg_b_index, 23, 20);
		clear_and_set_bits(to_gen, reg_c_index, 19, 16);
		clear_and_set_bits(to_gen, opcode, 15, 12);
		clear_and_set_bits(to_gen, simm12, 11, 0);

		gen_32(to_gen);
	}

	inline void encode_group_3_instr(u32 reg_a_index, u32 reg_b_index,
		u32 reg_c_index, u32 opcode, s32 simm12)
	{
		u64 to_gen = 0;

		// Instruction group (0b011)
		clear_and_set_bits(to_gen, 0b011, 31, 29);
		clear_and_set_bits(to_gen, reg_a_index, 27, 24);
		clear_and_set_bits(to_gen, reg_b_index, 23, 20);
		clear_and_set_bits(to_gen, reg_c_index, 19, 16);
		clear_and_set_bits(to_gen, opcode, 15, 12);
		clear_and_set_bits(to_gen, simm12, 11, 0);

		gen_32(to_gen);
	}


	// Generate data
	void gen_words(u16 data);
	void gen_8(u8 data);
	void gen_16(u16 data);
	void gen_32(u32 data);


private:		// visitor functions
	antlrcpp::Any visitProgram
		(AssemblerGrammarParser::ProgramContext *ctx);
	// program:
	antlrcpp::Any visitLine
		(AssemblerGrammarParser::LineContext *ctx);

	// line:
	antlrcpp::Any visitScopedLines
		(AssemblerGrammarParser::ScopedLinesContext *ctx);
	antlrcpp::Any visitLabel
		(AssemblerGrammarParser::LabelContext *ctx);
	antlrcpp::Any visitInstruction
		(AssemblerGrammarParser::InstructionContext *ctx);
	antlrcpp::Any visitPseudoInstruction
		(AssemblerGrammarParser::PseudoInstructionContext *ctx);
	antlrcpp::Any visitDirective
		(AssemblerGrammarParser::DirectiveContext *ctx);

	// instruction:
	antlrcpp::Any visitInstrOpGrp0ThreeRegsScalar
		(AssemblerGrammarParser::InstrOpGrp0ThreeRegsScalarContext *ctx);
	antlrcpp::Any visitInstrOpGrp0TwoRegsScalar
		(AssemblerGrammarParser::InstrOpGrp0TwoRegsScalarContext *ctx);
	antlrcpp::Any visitInstrOpGrp0OneRegOnePcOneSimm12Scalar
		(AssemblerGrammarParser
		::InstrOpGrp0OneRegOnePcOneSimm12ScalarContext *ctx);
	antlrcpp::Any visitInstrOpGrp0TwoRegsOneSimm12Scalar
		(AssemblerGrammarParser
		::InstrOpGrp0TwoRegsOneSimm12ScalarContext *ctx);

	antlrcpp::Any visitInstrOpGrp0ThreeRegsVector
		(AssemblerGrammarParser::InstrOpGrp0ThreeRegsVectorContext *ctx);
	antlrcpp::Any visitInstrOpGrp0TwoRegsVector
		(AssemblerGrammarParser::InstrOpGrp0TwoRegsVectorContext *ctx);
	antlrcpp::Any visitInstrOpGrp0OneRegOnePcOneSimm12Vector
		(AssemblerGrammarParser
		::InstrOpGrp0OneRegOnePcOneSimm12VectorContext *ctx);
	antlrcpp::Any visitInstrOpGrp0TwoRegsOneSimm12Vector
		(AssemblerGrammarParser
		::InstrOpGrp0TwoRegsOneSimm12VectorContext *ctx);

	antlrcpp::Any visitInstrOpGrp1RelBranch
		(AssemblerGrammarParser::InstrOpGrp1RelBranchContext *ctx);
	antlrcpp::Any visitInstrOpGrp1Jump
		(AssemblerGrammarParser::InstrOpGrp1JumpContext *ctx);


	antlrcpp::Any visitInstrOpGrp2LdThreeRegsOneSimm12
		(AssemblerGrammarParser::InstrOpGrp2LdThreeRegsOneSimm12Context
		*ctx);
	antlrcpp::Any visitInstrOpGrp3StThreeRegsOneSimm12
		(AssemblerGrammarParser::InstrOpGrp3StThreeRegsOneSimm12Context
		*ctx);

	// pseudoInstruction:
	antlrcpp::Any visitPseudoInstrBraOneSimm20
		(AssemblerGrammarParser::PseudoInstrBraOneSimm20Context *ctx);
	antlrcpp::Any visitPseudoInstrPcrelOneRegOneSimm12Scalar
		(AssemblerGrammarParser
		::PseudoInstrPcrelOneRegOneSimm12ScalarContext *ctx);
	antlrcpp::Any visitPseudoInstrPcrelOneRegOneSimm12Vector
		(AssemblerGrammarParser
		::PseudoInstrPcrelOneRegOneSimm12VectorContext *ctx);



	// directive:
	antlrcpp::Any visitDotOrgDirective
		(AssemblerGrammarParser::DotOrgDirectiveContext *ctx);
	antlrcpp::Any visitDotSpaceDirective
		(AssemblerGrammarParser::DotSpaceDirectiveContext *ctx);
	antlrcpp::Any visitDotDb64Directive
		(AssemblerGrammarParser::DotDb64DirectiveContext *ctx);
	antlrcpp::Any visitDotDb32Directive
		(AssemblerGrammarParser::DotDb32DirectiveContext *ctx);
	antlrcpp::Any visitDotDb16Directive
		(AssemblerGrammarParser::DotDb16DirectiveContext *ctx);
	antlrcpp::Any visitDotDb8Directive
		(AssemblerGrammarParser::DotDb8DirectiveContext *ctx);
	antlrcpp::Any visitDotEquDirective
		(AssemblerGrammarParser::DotEquDirectiveContext *ctx);

	// Expression parsing
	antlrcpp::Any visitExpr
		(AssemblerGrammarParser::ExprContext *ctx);

	antlrcpp::Any visitExprLogical
		(AssemblerGrammarParser::ExprLogicalContext *ctx);
	antlrcpp::Any visitExprCompare
		(AssemblerGrammarParser::ExprCompareContext *ctx);
	antlrcpp::Any visitExprAddSub
		(AssemblerGrammarParser::ExprAddSubContext *ctx);
	//antlrcpp::Any visitExprJustAdd
	//	(AssemblerGrammarParser::ExprJustAddContext *ctx);
	//antlrcpp::Any visitExprJustSub
	//	(AssemblerGrammarParser::ExprJustSubContext *ctx);
	antlrcpp::Any visitExprMulDivModEtc
		(AssemblerGrammarParser::ExprMulDivModEtcContext *ctx);

	antlrcpp::Any visitExprUnary
		(AssemblerGrammarParser::ExprUnaryContext *ctx);
	antlrcpp::Any visitExprBitInvert
		(AssemblerGrammarParser::ExprBitInvertContext *ctx);
	antlrcpp::Any visitExprNegate
		(AssemblerGrammarParser::ExprNegateContext *ctx);
	antlrcpp::Any visitExprLogNot
		(AssemblerGrammarParser::ExprLogNotContext *ctx);

	// Last set of token stuff
	antlrcpp::Any visitRegOrIdentName
		(AssemblerGrammarParser::RegOrIdentNameContext *ctx);
	antlrcpp::Any visitIdentName
		(AssemblerGrammarParser::IdentNameContext *ctx);
	antlrcpp::Any visitInstrName
		(AssemblerGrammarParser::InstrNameContext *ctx);
	antlrcpp::Any visitPseudoInstrName
		(AssemblerGrammarParser::PseudoInstrNameContext *ctx);
	antlrcpp::Any visitNumExpr
		(AssemblerGrammarParser::NumExprContext *ctx);
	antlrcpp::Any visitCurrPc
		(AssemblerGrammarParser::CurrPcContext *ctx);

private:		// functions
	inline void push_num(s64 to_push)
	{
		__num_stack.push(to_push);
	}
	inline auto get_top_num()
	{
		return __num_stack.top();
	}
	inline auto pop_num()
	{
		auto ret = __num_stack.top();
		__num_stack.pop();
		return ret;
	}
	inline void push_scope_child_num(s64 to_push)
	{
		__scope_child_num_stack.push(to_push);
	}
	inline auto get_top_scope_child_num()
	{
		return __scope_child_num_stack.top();
	}
	inline auto pop_scope_child_num()
	{
		auto ret = __scope_child_num_stack.top();
		__scope_child_num_stack.pop();
		return ret;
	}

	inline void push_str(std::string* to_push)
	{
		__str_stack.push(to_push);
	}
	inline auto get_top_str()
	{
		return __str_stack.top();
	}
	inline auto pop_str()
	{
		auto ret = __str_stack.top();
		__str_stack.pop();
		return ret;
	}

	gen_getter_and_setter_by_val(pc);
	gen_getter_by_ref(sym_tbl);

	void __encode_alu_op_three_regs(ParserRuleContext* ctx,
		const std::string& instr_name, u32 reg_a_index, u32 reg_b_index, 
		u32 reg_c_index);
	void __encode_alu_op_two_regs_one_imm(ParserRuleContext* ctx,
		const std::string& instr_name, u32 reg_a_index, u32 reg_b_index, 
		s64 immediate);
	void __encode_inv(ParserRuleContext* ctx, u32 reg_a_index, u32 
		reg_b_index);
	void __encode_invi(ParserRuleContext* ctx, u32 reg_a_index, 
		s64 immediate);
	void __encode_cpy_ra_rb(ParserRuleContext* ctx, u32 reg_a_index, 
		u32 reg_b_index);
	void __encode_cpy_ra_pc(ParserRuleContext* ctx, u32 reg_a_index);
	void __encode_cpyi(ParserRuleContext* ctx, u32 reg_a_index, 
		s64 immediate);
	void __encode_cpya(ParserRuleContext* ctx, u32 reg_a_index, 
		s64 immediate);


	void __encode_relative_branch(ParserRuleContext* ctx,
		const std::string& instr_name, 
		u32 reg_a_index, u32 reg_b_index, s64 raw_immediate);
	void __encode_jump(ParserRuleContext* ctx,
		const std::string& instr_name, u32 reg_a_index, 
		u32 reg_b_index, u32 reg_c_index);
	void __encode_call(ParserRuleContext* ctx,
		const std::string& instr_name, u32 reg_a_index, 
		u32 reg_b_index, u32 reg_c_index);
	void __encode_ldst_three_regs(ParserRuleContext* ctx,
		const std::string& instr_name,
		u32 reg_a_index, u32 reg_b_index, u32 reg_c_index);
	void __encode_ldst_two_regs_one_simm(ParserRuleContext* ctx,
		const std::string& instr_name,
		u32 reg_a_index, u32 reg_b_index, s64 immediate);

	//u32 __get_reg_temp_index() const;

	inline void __warn_if_simm20_out_of_range(ParserRuleContext* ctx,
		s64 immediate, bool is_for_pc_relative=false)
	{
		if (__pass)
		{
			struct
			{
				u32 fill : 12;
				s32 simm20 : 20;
			} temp;

			//const s16 simm16 = static_cast<s16>(immediate);
			temp.simm20 = static_cast<s32>(immediate);

			//const s64 simm64 = static_cast<s64>(temp.simm12);

			if (immediate != temp.simm20)
			{
				if (!is_for_pc_relative)
				{
					warn(ctx, sconcat("immediate value 0x", std::hex,
						immediate, std::dec, " out of range for ",
						"20-bit signed immediate."));
				}
				else // if (is_for_pc_relative)
				{
					warn(ctx, sconcat("pc-relative offset 0x", std::hex,
						immediate, std::dec, " out of range for ",
						"20-bit signed immediate."));
				}
			}
		}
	}

	//inline void __warn_if_imm16_out_of_range(ParserRuleContext* ctx, 
	//	s64 immediate)
	//{
	//	if (__pass)
	//	{
	//		const u16 imm16 = static_cast<u16>(immediate);
	//		const u64 imm64 = static_cast<u64>(immediate);

	//		//if (immediate != static_cast<s64>(imm64))
	//		if (imm64 != imm16)
	//		{
	//			warn(ctx, sconcat("immediate value 0x", std::hex,
	//				immediate, std::dec, 
	//				" out of range for for 16-bit unsigned "
	//				"immediate."));
	//		}
	//	}
	//}


	inline void __warn_if_simm16_out_of_range(ParserRuleContext* ctx, 
		s64 immediate, bool is_for_pc_relative=false)
	{
		if (__pass)
		{
			s16 simm16 = static_cast<s16>(immediate);
			//s16 simm16;
			//const s64 simm64 = static_cast<s64>(simm16);

			if (immediate != simm16)
			{
				if (!is_for_pc_relative)
				{
					warn(ctx, sconcat("immediate value 0x", std::hex, 
						immediate, std::dec, 
						" out of range for for 16-bit signed ",
						"immediate."));
				}
				else // if (is_for_pc_relative)
				{
					warn(ctx, sconcat("pc-relative offset 0x", std::hex,
						immediate, std::dec, " out of range ",
						"because it doesn't fit in a 16-bit signed ",
						"immediate."));
				}
			}
		}
	}

	inline void __warn_if_simm12_out_of_range(ParserRuleContext* ctx, 
		s64 immediate, bool is_for_pc_relative=false)
	{
		if (__pass)
		{
			struct
			{
				u8 fill : 4;
				s16 simm12 : 12;
			} temp;

			//const s16 simm16 = static_cast<s16>(immediate);
			temp.simm12 = static_cast<s16>(immediate);

			//const s64 simm64 = static_cast<s64>(temp.simm12);

			if (immediate != temp.simm12)
			{
				if (!is_for_pc_relative)
				{
					warn(ctx, sconcat("immediate value 0x", std::hex,
						immediate, std::dec, " out of range for ",
						"12-bit signed immediate."));
				}
				else // if (is_for_pc_relative)
				{
					warn(ctx, sconcat("pc-relative offset 0x", std::hex,
						immediate, std::dec, " out of range for ",
						"12-bit signed immediate."));
				}
			}
		}
	}

	inline s64 get_pc_relative_offset(s64 raw_immediate) const
	{
		// sizeof(s32) is used because an instruction is encoded as 32-bit
		return raw_immediate - __pc.curr - sizeof(s32);
	}


	inline auto get_instr_opcode_from_str
		(const EncodingStuff::MapType& some_opcode_map)
	{
		return some_opcode_map.at(pop_str());
	}

	template<typename CtxType>
	inline void get_sym_address(CtxType* ctx)
	{
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

};



#endif		// src__slash__assembler_class_hpp
