#ifndef src_encoding_stuff_class_hpp
#define src_encoding_stuff_class_hpp

// src/encoding_stuff_class.hpp

#include "misc_includes.hpp"

extern std::string* cstm_strdup(const std::string& to_dup);

class EncodingStuff
{
public:		// enums
	enum class ArgsType : u32
	{
		ThreeRegsScalar,
		TwoRegsScalar,
		OneRegOnePcOneSimm12Scalar,
		TwoRegsOneSimm12Scalar,

		ThreeRegsVector,
		TwoRegsVector,
		OneRegOnePcOneSimm12Vector,
		TwoRegsOneSimm12Vector,

		ThreeRegsOneSimm12,

		RelBranch,
		Jump,

		//OneRegOneIe,
		//OneRegOneIreta,
		//OneRegOneIdsta,
		//OneIeOneReg,
		//OneIretaOneReg,
		//OneIdstaOneReg,
		//NoArgs,

		LdThreeRegsOneSimm12,
		StThreeRegsOneSimm12,

		//InputTwoRegsOneSimm16,
		//OutputTwoRegsOneSimm16Scalar,
		//OutputTwoRegsOneSimm16Vector,

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
	MapType __iog0_two_regs_one_simm12_scalar_map;

	// Vector operations
	MapType __iog0_three_regs_vector_map;
	MapType __iog0_two_regs_vector_map;
	MapType __iog0_one_reg_one_pc_one_simm12_vector_map;
	MapType __iog0_two_regs_one_simm12_vector_map;

	// sim_syscall
	MapType __iog0_three_regs_one_simm12_map;

	// Group 1 (control flow stuff)
	MapType __iog1_rel_branch_map;
	MapType __iog1_jump_map;


	// Group 2 (loads)
	MapType __iog2_ld_three_regs_one_simm12_map;

	// Group 3 (stores)
	MapType __iog3_st_three_regs_one_simm12_map;


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

	// Group 0 (ALU/FPU/etc. operations)
	gen_getter_by_con_ref(iog0_three_regs_scalar_map);
	gen_getter_by_con_ref(iog0_two_regs_scalar_map);
	gen_getter_by_con_ref(iog0_one_reg_one_pc_one_simm12_scalar_map);
	gen_getter_by_con_ref(iog0_two_regs_one_simm12_scalar_map);

	gen_getter_by_con_ref(iog0_three_regs_vector_map);
	gen_getter_by_con_ref(iog0_two_regs_vector_map);
	gen_getter_by_con_ref(iog0_one_reg_one_pc_one_simm12_vector_map);
	gen_getter_by_con_ref(iog0_two_regs_one_simm12_vector_map);
	gen_getter_by_con_ref(iog0_three_regs_one_simm12_map);

	// Group 1 (control flow stuff)
	gen_getter_by_con_ref(iog1_rel_branch_map);
	gen_getter_by_con_ref(iog1_jump_map);

	// Group 2 (loads)
	gen_getter_by_con_ref(iog2_ld_three_regs_one_simm12_map);

	// Group 3 (stores)
	gen_getter_by_con_ref(iog3_st_three_regs_one_simm12_map);



	std::string* decode_reg_name(u32 reg_index) const;
	void decode_iog0_instr_name_and_args_type(u32 sv_bit, u32 opcode, 
		std::string*& instr_name, ArgsType& args_type) const;
	void decode_iog1_instr_name_and_args_type(u32 sv_bit, u32 opcode,
		std::string*& instr_name, ArgsType& args_type) const;
	void decode_iog2_instr_name_and_args_type(u32 sv_bit, u32 opcode,
		std::string*& instr_name, ArgsType& args_type) const;
	void decode_iog3_instr_name_and_args_type(u32 sv_bit, u32 opcode,
		std::string*& instr_name, ArgsType& args_type) const;
};


#endif		// src_encoding_stuff_class_hpp
