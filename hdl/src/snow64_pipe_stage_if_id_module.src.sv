`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"
`include "src/snow64_pipe_stage_structs.header.sv"


module Snow64PipeStageIfId(input logic clk,
	input PortIn_Snow64PipeStageIfId_FromInstrCache in_from_instr_cache,
	input PortIn_Snow64PipeStageIfId_FromPipeStageEx in_from_pipe_stage_ex,
	input PortIn_Snow64PipeStageIfId_FromPipeStageWb in_from_pipe_stage_wb,
	output PortOut_Snow64PipeStageIfId_ToCtrlUnit out_to_ctrl_unit,
	output PortOut_Snow64PipeStageIfId_ToInstrCache out_to_instr_cache,
	output PortOut_Snow64PipeStageIfId_ToPipeStageEx out_to_pipe_stage_ex);


	localparam __NUM_BYTES__INSTR = `WIDTH__SNOW64_INSTR / 8;

	localparam __WIDTH__STATE = 3;
	localparam __MSB_POS__STATE = `WIDTH2MP(__WIDTH__STATE);

	enum logic [__MSB_POS__STATE:0]
	{
		StInit,
		StRegular,
		StChangePc,
		StWaitForLdStPart0,
		StWaitForLdStPart1
	} __state;

	PkgSnow64InstrDecoder::PortOut_InstrDecoder __out_inst_instr_decoder;
	Snow64InstrDecoder __inst_instr_decoder(.in(in_from_instr_cache.instr),
		.out(__out_inst_instr_decoder));

	logic [`MSB_POS__SNOW64_IENC_REG_INDEX:0]
		__curr_ra_index = 0,
		__curr_rb_index = 0,
		__curr_rc_index = 0,
		__captured_ra_index = 0,
		__captured_rb_index = 0,
		__captured_rc_index = 0;

	//assign out_to_ctrl_unit = {__out_inst_instr_decoder.ra_index,
	//	__out_inst_instr_decoder.rb_index,
	//	__out_inst_instr_decoder.rc_index};
	assign out_to_ctrl_unit = {__curr_ra_index, __curr_rb_index,
		__curr_rc_index};

	logic [`MSB_POS__SNOW64_CPU_ADDR:0] __spec_reg_pc;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __following_pc = __spec_reg_pc
		+ __NUM_BYTES__INSTR;

	//wire [`MSB_POS__SNOW64_INSTR:0] __bubble_instr = 0;

	wire __curr_decoded_instr_changes_pc
		= ((__out_inst_instr_decoder.group == 1)
		&& (!__out_inst_instr_decoder.nop));

	wire __from_pipe_stage_wb__stall = in_from_pipe_stage_wb.stall;

	task send_bubble;
		out_to_pipe_stage_ex.decoded_instr <= 0;
	endtask

	task send_curr_instr(input PkgSnow64Cpu::CpuAddr some_pc);
		//$display("send_curr_instr(%h), %h", some_pc,
		//	__out_inst_instr_decoder.group);
		out_to_pipe_stage_ex.decoded_instr <= __out_inst_instr_decoder;
		out_to_pipe_stage_ex.pc_val <= some_pc;
		//out_to_pipe_stage_ex.pc_val <= __spec_reg_pc;
		//out_to_pipe_stage_ex.pc_val <= __following_pc;
	endtask


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
				$display("%h:  add%s %s, %s, %s",
					__spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::Sub_ThreeRegs:
				$display("%h:  sub%s %s, %s, %s",
					__spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::Slt_ThreeRegs:
				$display("%h:  slt%s %s, %s, %s",
					__spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::Mul_ThreeRegs:
				$display("%h:  mul%s %s, %s, %s",
					__spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));

			PkgSnow64InstrDecoder::Div_ThreeRegs:
				$display("%h:  div%s %s, %s, %s",
					__spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::And_ThreeRegs:
				$display("%h:  and%s %s, %s, %s",
					__spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::Orr_ThreeRegs:
				$display("%h:  orr%s %s, %s, %s",
					__spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::Xor_ThreeRegs:
				$display("%h:  xor%s %s, %s, %s",
					__spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));

			PkgSnow64InstrDecoder::Shl_ThreeRegs:
				$display("%h:  shl%s %s, %s, %s",
					__spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::Shr_ThreeRegs:
				$display("%h:  shr%s %s, %s, %s",
					__spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index));
			PkgSnow64InstrDecoder::Inv_TwoRegs:
				$display("%h:  inv%s %s, %s",
					__spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index));
			PkgSnow64InstrDecoder::Not_TwoRegs:
				$display("%h:  not%s %s, %s",
					__spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index));

			PkgSnow64InstrDecoder::Addi_OneRegOnePcOneSimm12:
				$display("%h:  addi%s %s, pc, %h",
					__spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::Addi_TwoRegsOneSimm12:
				$display("%h:  addi%s %s, %s, %h",
					__spec_reg_pc,
					get_op_type_suffix_str
						(__out_inst_instr_decoder.op_type),
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::SimSyscall_ThreeRegsOneSimm12:
				$display("%h:  sim_syscall %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			default:
				$display("%h:  Unknown instruction (group 0):  %h",
					__spec_reg_pc, in_from_instr_cache.instr);
			endcase
		end

		1:
		begin
			case (__out_inst_instr_decoder.oper)
			PkgSnow64InstrDecoder::Btru_OneRegOneSimm20:
				$display("%h:  btru %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::Bfal_OneRegOneSimm20:
				$display("%h:  bfal %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::Jmp_OneReg:
				$display("%h:  jmp %s",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index));
			default:
				$display("%h:  Unknown instruction (group 1):  %h",
					__spec_reg_pc, in_from_instr_cache.instr);
			endcase
		end

		2:
		begin
			case (__out_inst_instr_decoder.oper)
			PkgSnow64InstrDecoder::LdU8_ThreeRegsOneSimm12:
				$display("%h:  ldu8 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::LdS8_ThreeRegsOneSimm12:
				$display("%h:  lds8 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::LdU16_ThreeRegsOneSimm12:
				$display("%h:  ldu16 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::LdS16_ThreeRegsOneSimm12:
				$display("%h:  lds16 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);

			PkgSnow64InstrDecoder::LdU32_ThreeRegsOneSimm12:
				$display("%h:  ldu32 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::LdS32_ThreeRegsOneSimm12:
				$display("%h:  lds32 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::LdU64_ThreeRegsOneSimm12:
				$display("%h:  ldu64 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::LdS64_ThreeRegsOneSimm12:
				$display("%h:  lds64 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);

			PkgSnow64InstrDecoder::LdF16_ThreeRegsOneSimm12:
				$display("%h:  ldf16 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			default:
				$display("%h:  Unknown instruction (group 2):  %h",
					__spec_reg_pc, in_from_instr_cache.instr);
			endcase
		end

		3:
		begin
			case (__out_inst_instr_decoder.oper)
			PkgSnow64InstrDecoder::StU8_ThreeRegsOneSimm12:
				$display("%h:  stu8 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::StS8_ThreeRegsOneSimm12:
				$display("%h:  sts8 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::StU16_ThreeRegsOneSimm12:
				$display("%h:  stu16 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::StS16_ThreeRegsOneSimm12:
				$display("%h:  sts16 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);

			PkgSnow64InstrDecoder::StU32_ThreeRegsOneSimm12:
				$display("%h:  stu32 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::StS32_ThreeRegsOneSimm12:
				$display("%h:  sts32 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::StU64_ThreeRegsOneSimm12:
				$display("%h:  stu64 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			PkgSnow64InstrDecoder::StS64_ThreeRegsOneSimm12:
				$display("%h:  sts64 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);

			PkgSnow64InstrDecoder::StF16_ThreeRegsOneSimm12:
				$display("%h:  stf16 %s, %s, %s, %h",
					__spec_reg_pc,
					get_reg_name_str(__out_inst_instr_decoder.ra_index),
					get_reg_name_str(__out_inst_instr_decoder.rb_index),
					get_reg_name_str(__out_inst_instr_decoder.rc_index),
					__out_inst_instr_decoder.signext_imm);
			default:
				$display("%h:  Unknown instruction (group 3):  %h",
					__spec_reg_pc, in_from_instr_cache.instr);
			endcase
		end

		default:
		begin
			$display("%h:  Unknown instruction (bad group):  %h",
				__spec_reg_pc, in_from_instr_cache.instr);
		end
		endcase
	endtask


	initial
	begin
		//__state = StRegular;
		//__spec_reg_pc = -__NUM_BYTES__INSTR;
		__state = StInit;
		__spec_reg_pc = 0;

		out_to_pipe_stage_ex = 0;
		out_to_instr_cache = 0;
	end



	always @(*)
	begin
		case (__state)
		StInit:
		begin
			//out_to_instr_cache = {1'b1, __following_pc};
			out_to_instr_cache = {1'b1, __spec_reg_pc};
			//out_to_instr_cache = (in_from_instr_cache.valid
			//	&& __curr_decoded_instr_changes_pc)
			//	? 0 : {1'b1, __following_pc};
		end
		StRegular:
		begin
			// Do not request an instruction from instr cache if the
			// current instruction is one that changes the program counter.
			out_to_instr_cache = (in_from_instr_cache.valid
				&& __curr_decoded_instr_changes_pc)
				? 0 : {1'b1, __following_pc};
		end
		StChangePc:
		begin
			out_to_instr_cache = {1'b1,
				in_from_pipe_stage_ex.computed_pc};
		end

		// StWaitForLdStPart0 or StWaitForLdStPart1:
		default:
		begin
			//out_to_instr_cache = {1'b1, __following_pc};
			out_to_instr_cache = {1'b1, __spec_reg_pc};
		end
		endcase
	end

	//always @(posedge clk)
	//begin
	//	$display("IF/ID stuff:  %h %h %h %h",
	//		in_from_instr_cache.valid, out_to_instr_cache.req,
	//		__state, __spec_reg_pc);
	//end

	always @(*)
	begin
		case (__state)
		StRegular:
		begin
			{__curr_ra_index, __curr_rb_index, __curr_rc_index}
				= {__out_inst_instr_decoder.ra_index,
				__out_inst_instr_decoder.rb_index,
				__out_inst_instr_decoder.rc_index};
		end

		default:
		begin
			//{__curr_ra_index, __curr_rb_index, __curr_rc_index}
			//	= {__captured_ra_index, __captured_rb_index,
			//	__captured_rc_index};
			{__curr_ra_index, __curr_rb_index, __curr_rc_index}
				= 0;
		end
		endcase
	end

	always @(posedge clk)
	begin
		//$display("IF/ID state:  %h", __state);

		show_decoded_instr();

		case (__state)
		StInit:
		begin
			//if (in_from_instr_cache.valid)
			//begin
			//	stuff_for_sending_instr();
			//end

			//else
			//begin
			//	send_bubble();
			//end
			//__state <= StRegular;
			
			//if (in_from_instr_cache.valid)
			//begin
			//	__spec_reg_pc <= __following_pc;
			//	stuff_for_sending_instr(__following_pc,
			//		__following_pc + 4);
			//end
			//else
			//begin
			//	send_bubble();
			//end

			if (in_from_instr_cache.valid)
			begin
				//__spec_reg_pc <= __following_pc;
				__state <= StRegular;
			end
			send_bubble();
		end

		StRegular:
		begin
			__captured_ra_index <= __out_inst_instr_decoder.ra_index;
			__captured_rb_index <= __out_inst_instr_decoder.rb_index;
			__captured_rc_index <= __out_inst_instr_decoder.rc_index;

			if ((!in_from_pipe_stage_ex.stall)
				&& in_from_instr_cache.valid)
			begin
				__spec_reg_pc <= __following_pc;

				case (__out_inst_instr_decoder.nop)
				1'b0:
				begin
					case (__out_inst_instr_decoder.group)
					// ALU/FPU instructions
					0:
					begin
						send_curr_instr(__spec_reg_pc);
						//$display("IF/ID StRegular next state:  %h",
						//	StRegular);
					end

					// Control-flow instructions
					1:
					begin
						//send_curr_instr();
						out_to_pipe_stage_ex.decoded_instr
							<= __out_inst_instr_decoder;
						out_to_pipe_stage_ex.pc_val <= __following_pc;
						//send_curr_instr(__following_pc);
						__state <= StChangePc;
						//$display("IF/ID StRegular next state:  %h",
						//	StChangePc);
					end

					// Load instructions
					2:
					begin
						send_curr_instr(__spec_reg_pc);
						__state <= StWaitForLdStPart0;
						//$display("IF/ID StRegular next state:  %h",
						//	StWaitForLdStPart0);
					end

					// Store instructions
					3:
					begin
						send_curr_instr(__spec_reg_pc);
						__state <= StWaitForLdStPart0;
						//$display("IF/ID StRegular next state:  %h",
						//	StWaitForLdStPart0);
					end
					endcase
				end

				1'b1:
				begin
					//$display("IF/ID StRegular next state:  %h", StRegular);
					send_bubble();
				end
				endcase
			end

			else if (!in_from_instr_cache.valid)
			begin
				//$display("IF/ID StRegular next state:  %h", StRegular);
				send_bubble();
			end
		end

		StChangePc:
		begin
			// EX stage:  combinational logic for updating the program
			// counter.
			__spec_reg_pc <= in_from_pipe_stage_ex.computed_pc;
			__state <= StRegular;
			send_bubble();
		end

		StWaitForLdStPart0:
		begin
			__state <= StWaitForLdStPart1;
			send_bubble();
		end

		StWaitForLdStPart1:
		begin
			if (!__from_pipe_stage_wb__stall)
			begin
				__state <= StRegular;
			end

			send_bubble();
		end
		endcase
	end


endmodule
