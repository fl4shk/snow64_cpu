#ifndef src__slash__encoding_stuff_class_hpp
#define src__slash__encoding_stuff_class_hpp

// src/encoding_stuff_class.hpp

#include "misc_includes.hpp"

class EncodingStuff
{
public:		// enums
	enum class ArgsType : u32
	{
		ThreeRegsScalar,
		TwoRegsScalar,
		OneRegOnePcOneSimm12Scalar,

		ThreeRegsVector,
		TwoRegsVector,
		OneRegOnePcOneSimm12Vector,

		RelBranch,
		Jump,

		OneRegOneIe,
		OneRegOneIreta,
		OneRegOneIdsta,
		OneIeOneReg,
		OneIretaOneReg,
		OneIdstaOneReg,
		NoArgs,

		LdThreeRegsOneSimm12,
		StThreeRegsOneSimm12,

		InputTwoRegsOneSimm16,
		OutputTwoRegsOneSimm16Scalar,
		OutputTwoRegsOneSimm16Vector,

		Unknown,
	};

public:		// typedefs
	typedef std::map<std::string*, u16> MapType;

private:		// variables
	MapType __reg_names_map;

	// Group 0 (ALU operations)
	// Scalar operations
	MapType __iog0_three_regs_scalar_map;
	MapType __iog0_two_regs_scalar_map;
	MapType __iog0_one_reg_one_pc_one_simm12_scalar_map;

	// Vector operations
	MapType __iog0_three_regs_vector_map;
	MapType __iog0_two_regs_vector_map;
	MapType __iog0_one_reg_one_pc_one_simm12_vector_map;

	// Group 1 (control flow and interrupts stuff)
	MapType __iog1_rel_branch_map;
	MapType __iog1_jump_map;

	MapType __iog1_no_args_map;

	MapType __iog1_one_reg_one_ie;
	MapType __iog1_one_reg_one_ireta;
	MapType __iog1_one_reg_one_idsta;

	MapType __iog1_one_ie_one_reg;
	MapType __iog1_one_ireta_one_reg;
	MapType __iog1_one_idsta_one_reg;


	// Group 2 (loads)
	MapType __iog2_ld_three_regs_one_simm12_map;

	// Group 3 (stores)
	MapType __iog3_st_three_regs_one_simm12_map;

	// Group 4 (input and output stuff)
	MapType __iog4_input_two_regs_one_simm16_map;
	MapType __iog4_output_two_regs_one_simm16_scalar_map;
	MapType __iog4_output_two_regs_one_simm16_vector_map;

private:		// functions
	inline void insert_map_entry(MapType& some_map, 
		const std::string& str, u16& some_val)
	{
		some_map[cstm_strdup(str)] = some_val++;
	}
	inline void insert_map_entry_keep_some_val(MapType& some_map,
		const std::string& str, u16 some_val)
	{
		some_map[cstm_strdup(str)] = some_val;
	}


public:		// functions
	EncodingStuff();

	gen_getter_by_con_ref(reg_names_map);

	// Group 0 (ALU operations)
	gen_getter_by_con_ref(iog0_three_regs_scalar_map);
	gen_getter_by_con_ref(iog0_two_regs_scalar_map);
	gen_getter_by_con_ref(iog0_one_reg_one_pc_one_simm12_scalar_map);

	gen_getter_by_con_ref(iog0_three_regs_vector_map);
	gen_getter_by_con_ref(iog0_two_regs_vector_map);
	gen_getter_by_con_ref(iog0_one_reg_one_pc_one_simm12_vector_map);

	// Group 1 (control flow and interrupts stuff)
	gen_getter_by_con_ref(iog1_rel_branch_map);
	gen_getter_by_con_ref(iog1_jump_map);

	gen_getter_by_con_ref(iog1_no_args_map);

	gen_getter_by_con_ref(iog1_one_reg_one_ie);
	gen_getter_by_con_ref(iog1_one_reg_one_ireta);
	gen_getter_by_con_ref(iog1_one_reg_one_idsta);

	gen_getter_by_con_ref(iog1_one_ie_one_reg);
	gen_getter_by_con_ref(iog1_one_ireta_one_reg);
	gen_getter_by_con_ref(iog1_one_idsta_one_reg);

	// Group 2 (loads)
	gen_getter_by_con_ref(iog2_ld_three_regs_one_simm12_map);

	// Group 3 (stores)
	gen_getter_by_con_ref(iog3_st_three_regs_one_simm12_map);

	// Group 4 (input and output stuff)
	gen_getter_by_con_ref(iog4_input_two_regs_one_simm16_map);
	gen_getter_by_con_ref(iog4_output_two_regs_one_simm16_scalar_map);
	gen_getter_by_con_ref(iog4_output_two_regs_one_simm16_vector_map);


	std::string* decode_reg_name(u32 reg_index) const;
	void decode_iog0_instr_name_and_args_type(u32 sv_bit, u32 opcode, 
		std::string*& instr_name, ArgsType& args_type) const;
	void decode_iog1_instr_name_and_args_type(u32 sv_bit, u32 opcode,
		std::string*& instr_name, ArgsType& args_type) const;
	void decode_iog2_instr_name_and_args_type(u32 sv_bit, u32 opcode,
		std::string*& instr_name, ArgsType& args_type) const;
	void decode_iog3_instr_name_and_args_type(u32 sv_bit, u32 opcode,
		std::string*& instr_name, ArgsType& args_type) const;
	void decode_iog4_instr_name_and_args_type(u32 sv_bit, u32 opcode,
		std::string*& instr_name, ArgsType& args_type) const;
};


#endif		// src__slash__encoding_stuff_class_hpp
