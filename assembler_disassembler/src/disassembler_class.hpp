#ifndef src_disassembler_class_hpp
#define src_disassembler_class_hpp

// src/disassembler_class.hpp

#include "misc_includes.hpp"
#include "ANTLRErrorListener.h"
#include "gen_src/DisassemblerGrammarLexer.h"
#include "gen_src/DisassemblerGrammarParser.h"
#include "gen_src/DisassemblerGrammarVisitor.h"

#include "symbol_table_classes.hpp"

#include "encoding_stuff_class.hpp"
#include "asm_disasm_visitor_base_class.hpp"

class Disassembler : public DisassemblerGrammarVisitor,
	public AsmDisasmVisitorBase
{
private:		// variables
	EncodingStuff __encoding_stuff;
	DisassemblerGrammarParser::ProgramContext* __program_ctx;

public:		// functions
	Disassembler(DisassemblerGrammarParser& parser);

	int run();

private:		// functions
	//inline void err(antlr4::ParserRuleContext* ctx, 
	//	const std::string& msg)
	//{
	//	if (ctx == nullptr)
	//	{
	//		printerr("Error:  ", msg, "\n");
	//	}
	//	else
	//	{
	//		auto tok = ctx->getStart();
	//		const size_t line = tok->getLine();
	//		const size_t pos_in_line = tok->getCharPositionInLine();
	//		//printerr("Error in file \"", *__file_name, "\", on line ",
	//		//	line, ", position ", pos_in_line, ":  ", msg, "\n");
	//		printerr("Error on line ", line, ", position ", pos_in_line, 
	//			":  ", msg, "\n");
	//	}
	//	exit(1);
	//}
	//inline void err(const std::string& msg)
	//{
	//	//printerr("Error in file \"", *__file_name, "\":  ", msg, "\n");
	//	printerr("Error:  ", msg, "\n");
	//	exit(1);
	//}

private:		// visitor functions
	antlrcpp::Any visitProgram
		(DisassemblerGrammarParser::ProgramContext *ctx);
	antlrcpp::Any visitLine
		(DisassemblerGrammarParser::LineContext *ctx);


private:		// functions
	//u32 convert_hex_string(antlr4::ParserRuleContext* ctx, 
	//	const std::string& str, u32& num_good_chars) const;

	inline void display_dot_db32(u32 data) const
	{
		printout(".db32 ", std::hex, "0x", (u32)data, std::dec);
	}
	inline void display_dot_db16(u32 data) const
	{
		printout(".db16 ", std::hex, "0x", (u16)data, std::dec);
	}
	inline void display_dot_db8(u32 data) const
	{
		printout(".db8 ", std::hex, "0x", (u64)((u8)data), std::dec);
	}

	inline u32 decode_iog(u32 instruction) const
	{
		//return get_bits_with_range(instruction, 31, 28);
		return get_bits_with_range(instruction, 31, 29);
	}
	inline void decode_group_0_instr(u32 instruction, u32& sv_bit, 
		u32& reg_a_index, u32& reg_b_index, u32& reg_c_index, 
		u32& opcode, s32& simm12) const
	{
		struct
		{
			u32 fill : 4;
			s16 simm12 : 12;
		} temp;

		sv_bit = instruction & (1 << 28);
		reg_a_index = get_bits_with_range(instruction, 27, 24);
		reg_b_index = get_bits_with_range(instruction, 23, 20);
		reg_c_index = get_bits_with_range(instruction, 19, 16);

		opcode = get_bits_with_range(instruction, 15, 12);
		temp.simm12 = get_bits_with_range(static_cast<s32>(instruction),
			11, 0);
		simm12 = temp.simm12;
	}
	inline void decode_group_1_instr(u32 instruction, u32& reg_a_index,
		u32& opcode, s32& simm20) const
	{
		struct
		{
			u32 fill : 12;
			s32 simm20 : 20;
		} temp;

		reg_a_index = get_bits_with_range(instruction, 27, 24);
		opcode = get_bits_with_range(instruction, 23, 20);

		temp.simm20 = get_bits_with_range(static_cast<s32>(instruction),
			19, 0);
		simm20 = temp.simm20;
	}

	inline void decode_group_2_instr(u32 instruction, u32& reg_a_index,
		u32& reg_b_index, u32& reg_c_index, u32& opcode, s32& simm12) const
	{
		struct
		{
			u32 fill : 4;
			s16 simm12 : 12;
		} temp;

		reg_a_index = get_bits_with_range(instruction, 27, 24);
		reg_b_index = get_bits_with_range(instruction, 23, 20);
		reg_c_index = get_bits_with_range(instruction, 19, 16);

		opcode = get_bits_with_range(instruction, 15, 12);
		temp.simm12 = get_bits_with_range(static_cast<s32>(instruction),
			11, 0);
		simm12 = temp.simm12;
	}

	inline void decode_group_3_instr(u32 instruction, u32& reg_a_index,
		u32& reg_b_index, u32& reg_c_index, u32& opcode, s32& simm12) const
	{
		struct
		{
			u32 fill : 4;
			s16 simm12 : 12;
		} temp;

		reg_a_index = get_bits_with_range(instruction, 27, 24);
		reg_b_index = get_bits_with_range(instruction, 23, 20);
		reg_c_index = get_bits_with_range(instruction, 19, 16);

		opcode = get_bits_with_range(instruction, 15, 12);
		temp.simm12 = get_bits_with_range(static_cast<s32>(instruction),
			11, 0);
		simm12 = temp.simm12;
	}

	inline void decode_group_4_instr(u32 instruction, u32& sv_bit,
		u32& reg_a_index, u32& reg_b_index, u32& opcode, s32& simm16)
	{
		sv_bit = instruction & (1 << 28);
		reg_a_index = get_bits_with_range(instruction, 27, 24);
		reg_b_index = get_bits_with_range(instruction, 23, 20);
		opcode = get_bits_with_range(instruction, 19, 16);
		simm16 = get_bits_with_range(static_cast<s32>(instruction), 15, 0);
	}



	//inline void decode_instr_opcode_group_0(u32 instruction, 
	//	u32& reg_a_index, u32& reg_b_index, u32& reg_c_index, u32& opcode)
	//	const
	//{
	//	reg_a_index = get_bits_with_range(instruction, 27, 24);
	//	reg_b_index = get_bits_with_range(instruction, 23, 20);
	//	reg_c_index = get_bits_with_range(instruction, 19, 16);
	//	opcode = get_bits_with_range(instruction, 3, 0);
	//}

	//inline void decode_instr_opcode_group_1(u32 instruction, 
	//	u32& reg_a_index, u32& reg_b_index, u32& opcode, u32& immediate)
	//	const
	//{
	//	reg_a_index = get_bits_with_range(instruction, 27, 24);
	//	reg_b_index = get_bits_with_range(instruction, 23, 20);
	//	opcode = get_bits_with_range(instruction, 19, 16);
	//	immediate = get_bits_with_range(instruction, 15, 0);
	//}
	//inline void decode_instr_opcode_group_2(u32 instruction, 
	//	u32& reg_a_index, u32& reg_b_index, u32& opcode, u32& immediate)
	//	const
	//{
	//	reg_a_index = get_bits_with_range(instruction, 27, 24);
	//	reg_b_index = get_bits_with_range(instruction, 23, 20);
	//	opcode = get_bits_with_range(instruction, 19, 16);
	//	immediate = get_bits_with_range(instruction, 15, 0);
	//}
	//inline void decode_instr_opcode_group_3(u32 instruction, 
	//	u32& reg_a_index, u32& reg_b_index, u32& reg_c_index, u32& opcode)
	//	const
	//{
	//	reg_a_index = get_bits_with_range(instruction, 27, 24);
	//	reg_b_index = get_bits_with_range(instruction, 23, 20);
	//	reg_c_index = get_bits_with_range(instruction, 19, 16);
	//	opcode = get_bits_with_range(instruction, 3, 0);
	//}

	//inline void decode_instr_opcode_group_4(u32 instruction, 
	//	u32& reg_a_index, u32& reg_b_index, u32& reg_c_index, u32& opcode)
	//	const
	//{
	//	reg_a_index = get_bits_with_range(instruction, 27, 24);
	//	reg_b_index = get_bits_with_range(instruction, 23, 20);
	//	reg_c_index = get_bits_with_range(instruction, 19, 16);
	//	opcode = get_bits_with_range(instruction, 3, 0);
	//}

	//inline void decode_instr_opcode_group_5(u32 instruction, 
	//	u32& reg_a_index, u32& reg_b_index, u32& reg_c_index, s32& simm12, 
	//	u32& opcode) const
	//{
	//	struct
	//	{
	//		u32 fill : 4;
	//		s16 simm12 : 12;
	//	} temp;

	//	reg_a_index = get_bits_with_range(instruction, 27, 24);
	//	reg_b_index = get_bits_with_range(instruction, 23, 20);
	//	reg_c_index = get_bits_with_range(instruction, 19, 16);
	//	temp.simm12 =  get_bits_with_range(static_cast<s32>(instruction), 
	//		15, 4);
	//	simm12 = temp.simm12;
	//	opcode = get_bits_with_range(instruction, 3, 0);
	//}

	//inline void decode_instr_opcode_group_6(u32 instruction,
	//	u32& reg_a_index, u32& reg_b_index, u32& reg_c_index, u32& opcode)
	//{
	//	reg_a_index = get_bits_with_range(instruction, 27, 24);
	//	reg_b_index = get_bits_with_range(instruction, 23, 20);
	//	reg_c_index = get_bits_with_range(instruction, 19, 16);
	//	opcode = get_bits_with_range(instruction, 3, 0);
	//}
};



#endif		// src_disassembler_class_hpp
