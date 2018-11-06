#include "asm_disasm_visitor_base_class.hpp"

u32 AsmDisasmVisitorBase::convert_hex_string
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
			//printerr("Error in file \"", *___file_name, "\", on line ",
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
