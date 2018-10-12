`ifndef src__slash__show_decoded_instr_task_header_sv
`define src__slash__show_decoded_instr_task_header_sv

// src/show_decoded_instr_task.header.sv

`include "src/misc_defines.header.sv"


	function string get_op_type_suffix_str(input logic some_op_type);

		case (some_op_type)
		PkgSnow64InstrDecoder::OpTypeScalar: return "s";
		PkgSnow64InstrDecoder::OpTypeVector: return "s";
		endcase
	endfunction

	function string get_reg_name_str
		(input logic [`MSB_POS__SNOW64_IENC_REG_INDEX:0] some_reg_index);

		case (some_reg_index)
		0: return "dzero";
		1: return "du0";
		2: return "du1";
		3: return "du2";
		4: return "du3";
		5: return "du4";
		6: return "du5";
		7: return "du6";
		8: return "du7";
		9: return "du8";
		10: return "du9";
		11: return "du10";
		12: return "du12";
		13: return "dlr";
		14: return "dfp";
		15: return "dsp";
		endcase
	endfunction


	task show_decoded_instr;
		case (__out_inst_instr_decoder.group)
		0:
		begin
			case (__out_inst_instr_decoder.oper)
			PkgSnow64InstrDecoder::Add_ThreeRegs:
				$display("%h, %h:  add%s %s, %s, %s",
					__state, __spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::Sub_ThreeRegs:
				$display("%h, %h:  sub%s %s, %s, %s",
					__state, __spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::Slt_ThreeRegs:
				$display("%h, %h:  slt%s %s, %s, %s",
					__state, __spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::Mul_ThreeRegs:
				$display("%h, %h:  mul%s %s, %s, %s",
					__state, __spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));

			PkgSnow64InstrDecoder::Div_ThreeRegs:
				$display("%h, %h:  div%s %s, %s, %s",
					__state, __spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::And_ThreeRegs:
				$display("%h, %h:  and%s %s, %s, %s",
					__state, __spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::Orr_ThreeRegs:
				$display("%h, %h:  orr%s %s, %s, %s",
					__state, __spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::Xor_ThreeRegs:
				$display("%h, %h:  xor%s %s, %s, %s",
					__state, __spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));

			PkgSnow64InstrDecoder::Shl_ThreeRegs:
				$display("%h, %h:  shl%s %s, %s, %s",
					__state, __spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::Shr_ThreeRegs:
				$display("%h, %h:  shr%s %s, %s, %s",
					__state, __spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::Inv_TwoRegs:
				$display("%h, %h:  inv%s %s, %s",
					__state, __spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index));
			PkgSnow64InstrDecoder::Not_TwoRegs:
				$display("%h, %h:  not%s %s, %s",
					__state, __spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index));

			PkgSnow64InstrDecoder::Addi_OneRegOnePcOneSimm12:
				$display("%h, %h:  addi%s %s, pc, %h",
					__state, __spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::Addi_TwoRegsOneSimm12:
				$display("%h, %h:  addi%s %s, %s, %h",
					__state, __spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::SimSyscall_ThreeRegsOneSimm12:
				$display("%h, %h:  sim_syscall %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			default:
				$display("%h, %h:  Unknown instruction (group 0):  %h",
					__state, __spec_reg_pc, in_from_instr_cache.instr);
			endcase
		end

		1:
		begin
			case (__out_inst_instr_decoder.oper)
			PkgSnow64InstrDecoder::Btru_OneRegOneSimm20:
				$display("%h, %h:  btru %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::Bfal_OneRegOneSimm20:
				$display("%h, %h:  bfal %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::Jmp_OneReg:
				$display("%h, %h:  jmp %s",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index));
			default:
				$display("%h, %h:  Unknown instruction (group 1):  %h",
					__state, __spec_reg_pc, in_from_instr_cache.instr);
			endcase
		end

		2:
		begin
			case (__out_inst_instr_decoder.oper)
			PkgSnow64InstrDecoder::LdU8_ThreeRegsOneSimm12:
				$display("%h, %h:  ldu8 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::LdS8_ThreeRegsOneSimm12:
				$display("%h, %h:  lds8 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::LdU16_ThreeRegsOneSimm12:
				$display("%h, %h:  ldu16 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::LdS16_ThreeRegsOneSimm12:
				$display("%h, %h:  lds16 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);

			PkgSnow64InstrDecoder::LdU32_ThreeRegsOneSimm12:
				$display("%h, %h:  ldu32 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::LdS32_ThreeRegsOneSimm12:
				$display("%h, %h:  lds32 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::LdU64_ThreeRegsOneSimm12:
				$display("%h, %h:  ldu64 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::LdS64_ThreeRegsOneSimm12:
				$display("%h, %h:  lds64 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);

			PkgSnow64InstrDecoder::LdF16_ThreeRegsOneSimm12:
				$display("%h, %h:  ldf16 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			default:
				$display("%h, %h:  Unknown instruction (group 2):  %h",
					__state, __spec_reg_pc, in_from_instr_cache.instr);
			endcase
		end

		3:
		begin
			case (__out_inst_instr_decoder.oper)
			PkgSnow64InstrDecoder::StU8_ThreeRegsOneSimm12:
				$display("%h, %h:  stu8 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::StS8_ThreeRegsOneSimm12:
				$display("%h, %h:  sts8 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::StU16_ThreeRegsOneSimm12:
				$display("%h, %h:  stu16 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::StS16_ThreeRegsOneSimm12:
				$display("%h, %h:  sts16 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);

			PkgSnow64InstrDecoder::StU32_ThreeRegsOneSimm12:
				$display("%h, %h:  stu32 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::StS32_ThreeRegsOneSimm12:
				$display("%h, %h:  sts32 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::StU64_ThreeRegsOneSimm12:
				$display("%h, %h:  stu64 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::StS64_ThreeRegsOneSimm12:
				$display("%h, %h:  sts64 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);

			PkgSnow64InstrDecoder::StF16_ThreeRegsOneSimm12:
				$display("%h, %h:  stf16 %s, %s, %s, %h",
					__state, __spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			default:
				$display("%h, %h:  Unknown instruction (group 3):  %h",
					__state, __spec_reg_pc, in_from_instr_cache.instr);
			endcase
		end

		default:
		begin
			$display("%h, %h:  Unknown instruction (bad group):  %h",
				__state, __spec_reg_pc, in_from_instr_cache.instr);
		end
		endcase
	endtask

`endif		// src__slash__show_decoded_instr_task_header_sv
