#include "encoding_stuff_class.hpp"
#include "allocation_stuff.hpp"

#define DECODE_ITERATION(some_map, some_args_type) \
	for (auto& iter : some_map()) \
	{ \
		if (iter.second == opcode) \
		{ \
			instr_name = iter.first; \
			args_type = some_args_type; \
			return; \
		} \
	}

EncodingStuff::EncodingStuff()
{
	// Encoding stuff (opcode field, register fields)

	// Registers
	u16 temp = 0;
	insert_map_entry(__reg_names_map, "dzero", temp);
	insert_map_entry(__reg_names_map, "du0", temp);
	insert_map_entry(__reg_names_map, "du1", temp);
	insert_map_entry(__reg_names_map, "du2", temp);
	insert_map_entry(__reg_names_map, "du3", temp);
	insert_map_entry(__reg_names_map, "du4", temp);
	insert_map_entry(__reg_names_map, "du5", temp);
	insert_map_entry(__reg_names_map, "du6", temp);
	insert_map_entry(__reg_names_map, "du7", temp);
	insert_map_entry(__reg_names_map, "du8", temp);
	insert_map_entry(__reg_names_map, "du9", temp);
	insert_map_entry(__reg_names_map, "du10", temp);
	insert_map_entry(__reg_names_map, "du11", temp);
	insert_map_entry(__reg_names_map, "dlr", temp);
	insert_map_entry(__reg_names_map, "dfp", temp);
	insert_map_entry(__reg_names_map, "dsp", temp);

	// Group 0 (scalar operations)
	temp = 0;
	insert_map_entry(__iog0_three_regs_scalar_map, "adds", temp);
	insert_map_entry(__iog0_three_regs_scalar_map, "subs", temp);
	insert_map_entry(__iog0_three_regs_scalar_map, "slts", temp);
	insert_map_entry(__iog0_three_regs_scalar_map, "muls", temp);

	insert_map_entry(__iog0_three_regs_scalar_map, "divs", temp);
	insert_map_entry(__iog0_three_regs_scalar_map, "ands", temp);
	insert_map_entry(__iog0_three_regs_scalar_map, "orrs", temp);
	insert_map_entry(__iog0_three_regs_scalar_map, "xors", temp);

	insert_map_entry(__iog0_three_regs_scalar_map, "shls", temp);
	insert_map_entry(__iog0_three_regs_scalar_map, "shrs", temp);

	insert_map_entry(__iog0_two_regs_scalar_map, "invs", temp);
	insert_map_entry(__iog0_two_regs_scalar_map, "nots", temp);

	insert_map_entry(__iog0_one_reg_one_pc_one_simm12_scalar_map, "addis",
		temp);
	insert_map_entry(__iog0_two_regs_one_simm12_scalar_map, "addis",
		temp);

	// Group 0 (vector operations)
	temp = 0;
	insert_map_entry(__iog0_three_regs_vector_map, "addv", temp);
	insert_map_entry(__iog0_three_regs_vector_map, "subv", temp);
	insert_map_entry(__iog0_three_regs_vector_map, "sltv", temp);
	insert_map_entry(__iog0_three_regs_vector_map, "mulv", temp);

	insert_map_entry(__iog0_three_regs_vector_map, "divv", temp);
	insert_map_entry(__iog0_three_regs_vector_map, "andv", temp);
	insert_map_entry(__iog0_three_regs_vector_map, "orrv", temp);
	insert_map_entry(__iog0_three_regs_vector_map, "xorv", temp);

	insert_map_entry(__iog0_three_regs_vector_map, "shlv", temp);
	insert_map_entry(__iog0_three_regs_vector_map, "shrv", temp);

	insert_map_entry(__iog0_two_regs_vector_map, "invv", temp);
	insert_map_entry(__iog0_two_regs_vector_map, "notv", temp);

	insert_map_entry(__iog0_one_reg_one_pc_one_simm12_vector_map, "addiv",
		temp);
	insert_map_entry(__iog0_two_regs_one_simm12_vector_map, "addiv",
		temp);

	// Group 0 (sim_syscall)
	//temp = 0;
	insert_map_entry(__iog0_three_regs_one_simm12_map, "sim_syscall",
		temp);

	// Group 1 (control flow and interrupts stuff)
	temp = 0;
	insert_map_entry(__iog1_rel_branch_map, "bnz", temp);
	insert_map_entry(__iog1_rel_branch_map, "bzo", temp);

	insert_map_entry(__iog1_jump_map, "jmp", temp);

	// Group 2 (loads)
	temp = 0;
	insert_map_entry(__iog2_ld_three_regs_one_simm12_map, "ldu8", temp);
	insert_map_entry(__iog2_ld_three_regs_one_simm12_map, "lds8", temp);
	insert_map_entry(__iog2_ld_three_regs_one_simm12_map, "ldu16", temp);
	insert_map_entry(__iog2_ld_three_regs_one_simm12_map, "lds16", temp);
	insert_map_entry(__iog2_ld_three_regs_one_simm12_map, "ldu32", temp);
	insert_map_entry(__iog2_ld_three_regs_one_simm12_map, "lds32", temp);
	insert_map_entry(__iog2_ld_three_regs_one_simm12_map, "ldu64", temp);
	insert_map_entry(__iog2_ld_three_regs_one_simm12_map, "lds64", temp);
	insert_map_entry(__iog2_ld_three_regs_one_simm12_map, "ldf16", temp);

	// Group 3 (stores)
	temp = 0;
	insert_map_entry(__iog3_st_three_regs_one_simm12_map, "stu8", temp);
	insert_map_entry(__iog3_st_three_regs_one_simm12_map, "sts8", temp);
	insert_map_entry(__iog3_st_three_regs_one_simm12_map, "stu16", temp);
	insert_map_entry(__iog3_st_three_regs_one_simm12_map, "sts16", temp);
	insert_map_entry(__iog3_st_three_regs_one_simm12_map, "stu32", temp);
	insert_map_entry(__iog3_st_three_regs_one_simm12_map, "sts32", temp);
	insert_map_entry(__iog3_st_three_regs_one_simm12_map, "stu64", temp);
	insert_map_entry(__iog3_st_three_regs_one_simm12_map, "sts64", temp);
	insert_map_entry(__iog3_st_three_regs_one_simm12_map, "stf16", temp);
}


std::string* EncodingStuff::decode_reg_name(u32 reg_index) const
{
	//printout("EncodingStuff::decode_reg_name():  ", reg_index, "\n");
	for (auto& iter : reg_names_map())
	{
		if (iter.second == reg_index)
		{
			return iter.first;
		}
	}

	printerr("EncodingStuff::decode_reg_name():  Eek!");
	exit(1);
	return nullptr;
}
void EncodingStuff::decode_iog0_instr_name_and_args_type(u32 sv_bit, 
	u32 opcode, std::string*& instr_name, ArgsType& args_type) const
{
	//DECODE_ITERATION(iog0_three_regs_map, ArgsType::ThreeRegs);
	////DECODE_ITERATION(iog0_two_regs_map, ArgsType::TwoRegs);

	if (!sv_bit)
	{
		DECODE_ITERATION(iog0_three_regs_scalar_map,
			ArgsType::ThreeRegsScalar);
		DECODE_ITERATION(iog0_two_regs_scalar_map,
			ArgsType::TwoRegsScalar);
		DECODE_ITERATION(iog0_one_reg_one_pc_one_simm12_scalar_map,
			ArgsType::OneRegOnePcOneSimm12Scalar);
		DECODE_ITERATION(iog0_two_regs_one_simm12_scalar_map,
			ArgsType::TwoRegsOneSimm12Scalar);
	}
	else // if (sv_bit)
	{
		DECODE_ITERATION(iog0_three_regs_vector_map,
			ArgsType::ThreeRegsVector);
		DECODE_ITERATION(iog0_two_regs_vector_map,
			ArgsType::TwoRegsVector);
		DECODE_ITERATION(iog0_one_reg_one_pc_one_simm12_vector_map,
			ArgsType::OneRegOnePcOneSimm12Vector);
		DECODE_ITERATION(iog0_two_regs_one_simm12_vector_map,
			ArgsType::TwoRegsOneSimm12Vector);
	}

	DECODE_ITERATION(iog0_three_regs_one_simm12_map,
		ArgsType::ThreeRegsOneSimm12);

	instr_name = cstm_strdup("unknown_instruction");
	args_type = ArgsType::Unknown;
}

void EncodingStuff::decode_iog1_instr_name_and_args_type(u32 sv_bit, 
	u32 opcode, std::string*& instr_name, ArgsType& args_type) const
{
	DECODE_ITERATION(iog1_rel_branch_map, ArgsType::RelBranch);
	DECODE_ITERATION(iog1_jump_map, ArgsType::Jump);

	instr_name = cstm_strdup("unknown_instruction");
	args_type = ArgsType::Unknown;
}
void EncodingStuff::decode_iog2_instr_name_and_args_type(u32 sv_bit, 
	u32 opcode, std::string*& instr_name, ArgsType& args_type) const
{
	DECODE_ITERATION(iog2_ld_three_regs_one_simm12_map,
		ArgsType::LdThreeRegsOneSimm12);

	instr_name = cstm_strdup("unknown_instruction");
	args_type = ArgsType::Unknown;
}
void EncodingStuff::decode_iog3_instr_name_and_args_type(u32 sv_bit, 
	u32 opcode, std::string*& instr_name, ArgsType& args_type) const
{
	DECODE_ITERATION(iog3_st_three_regs_one_simm12_map,
		ArgsType::StThreeRegsOneSimm12);

	instr_name = cstm_strdup("unknown_instruction");
	args_type = ArgsType::Unknown;
}
