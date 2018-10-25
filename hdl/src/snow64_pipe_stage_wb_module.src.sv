`include "src/snow64_pipe_stage_structs.header.sv"

module Snow64PipeStageWb(input logic clk,
	input PortIn_Snow64PipeStageWb_FromCtrlUnit in_from_ctrl_unit,
	input PortIn_Snow64PipeStageWb_FromPipeStageEx in_from_pipe_stage_ex,
	output PortOut_Snow64PipeStageWb_ToPipeStageIfId
		out_to_pipe_stage_if_id,
	output PortOut_Snow64PipeStageWb_ToCtrlUnit out_to_ctrl_unit);

	localparam __WIDTH__STATE = 2;
	localparam __MSB_POS__STATE = `WIDTH2MP(__WIDTH__STATE);

	typedef enum logic [__MSB_POS__STATE:0]
	{
		StRegular,
		StPrepLdSt,
		StWaitForLarFileValid,
		StBad
	} State;
	
	logic [__MSB_POS__STATE:0] __state = StRegular,
		__next_state = StRegular;

	wire __from_out_lar_file__wr__valid
		= in_from_ctrl_unit.out_inst_lar_file__wr__valid;


	PkgSnow64InstrDecoder::PortOut_InstrDecoder __curr_decoded_instr,
		__captured_decoded_instr = 0;
	assign __curr_decoded_instr = (__state == StRegular)
		? in_from_pipe_stage_ex.decoded_instr : __captured_decoded_instr;
	logic [`MSB_POS__SNOW64_CPU_ADDR:0] __captured_ldst_addr = 0;

	assign out_to_pipe_stage_if_id.stall
		= (__next_state != StRegular);

	task prep_ldst(input logic [`MSB_POS__SNOW64_LAR_FILE_WRITE_TYPE:0]
		some_write_type);
		//$display("WB:  prep_ldst():  %h %h; %h",
		//	__curr_decoded_instr.ra_index,
		//	in_from_pipe_stage_ex.ldst_addr,
		//	some_write_type);
		//$display("WB:  prep_ldst():  %h %h; %h",
		//	__curr_decoded_instr.ra_index,
		//	__captured_ldst_addr,
		//	some_write_type);
		out_to_ctrl_unit.in_inst_lar_file__wr__req <= 1;
		out_to_ctrl_unit.in_inst_lar_file__wr__write_type
			<= some_write_type;
		out_to_ctrl_unit.in_inst_lar_file__wr__index
			<= __curr_decoded_instr.ra_index;
		//out_to_ctrl_unit.in_inst_lar_file__wr__ldst_addr
		//	<= in_from_pipe_stage_ex.ldst_addr;
		out_to_ctrl_unit.in_inst_lar_file__wr__ldst_addr
			<= __captured_ldst_addr;

		// Make use of the symmetry in the encoding of loads and stores
		case (__curr_decoded_instr.oper)
		PkgSnow64InstrDecoder::LdU8_ThreeRegsOneSimm12:
		begin
			out_to_ctrl_unit.in_inst_lar_file__wr__data_type
				<= PkgSnow64Cpu::DataTypUnsgnInt;
			out_to_ctrl_unit.in_inst_lar_file__wr__int_type_size
				<= PkgSnow64Cpu::IntTypSz8;
		end
		PkgSnow64InstrDecoder::LdS8_ThreeRegsOneSimm12:
		begin
			out_to_ctrl_unit.in_inst_lar_file__wr__data_type
				<= PkgSnow64Cpu::DataTypSgnInt;
			out_to_ctrl_unit.in_inst_lar_file__wr__int_type_size
				<= PkgSnow64Cpu::IntTypSz8;
		end

		PkgSnow64InstrDecoder::LdU16_ThreeRegsOneSimm12:
		begin
			out_to_ctrl_unit.in_inst_lar_file__wr__data_type
				<= PkgSnow64Cpu::DataTypUnsgnInt;
			out_to_ctrl_unit.in_inst_lar_file__wr__int_type_size
				<= PkgSnow64Cpu::IntTypSz16;
		end
		PkgSnow64InstrDecoder::LdS16_ThreeRegsOneSimm12:
		begin
			out_to_ctrl_unit.in_inst_lar_file__wr__data_type
				<= PkgSnow64Cpu::DataTypSgnInt;
			out_to_ctrl_unit.in_inst_lar_file__wr__int_type_size
				<= PkgSnow64Cpu::IntTypSz16;
		end

		PkgSnow64InstrDecoder::LdU32_ThreeRegsOneSimm12:
		begin
			out_to_ctrl_unit.in_inst_lar_file__wr__data_type
				<= PkgSnow64Cpu::DataTypUnsgnInt;
			out_to_ctrl_unit.in_inst_lar_file__wr__int_type_size
				<= PkgSnow64Cpu::IntTypSz32;
		end
		PkgSnow64InstrDecoder::LdS32_ThreeRegsOneSimm12:
		begin
			out_to_ctrl_unit.in_inst_lar_file__wr__data_type
				<= PkgSnow64Cpu::DataTypSgnInt;
			out_to_ctrl_unit.in_inst_lar_file__wr__int_type_size
				<= PkgSnow64Cpu::IntTypSz32;
		end

		PkgSnow64InstrDecoder::LdU64_ThreeRegsOneSimm12:
		begin
			out_to_ctrl_unit.in_inst_lar_file__wr__data_type
				<= PkgSnow64Cpu::DataTypUnsgnInt;
			out_to_ctrl_unit.in_inst_lar_file__wr__int_type_size
				<= PkgSnow64Cpu::IntTypSz64;
		end
		PkgSnow64InstrDecoder::LdS64_ThreeRegsOneSimm12:
		begin
			out_to_ctrl_unit.in_inst_lar_file__wr__data_type
				<= PkgSnow64Cpu::DataTypSgnInt;
			out_to_ctrl_unit.in_inst_lar_file__wr__int_type_size
				<= PkgSnow64Cpu::IntTypSz64;
		end

		PkgSnow64InstrDecoder::LdF16_ThreeRegsOneSimm12:
		begin
			out_to_ctrl_unit.in_inst_lar_file__wr__data_type
				<= PkgSnow64Cpu::DataTypBFloat16;

			// This is just for good measure (it doesn't actually affect
			// anything... or at least it shouldn't!)
			out_to_ctrl_unit.in_inst_lar_file__wr__int_type_size
				<= PkgSnow64Cpu::IntTypSz16;
		end

		endcase
	endtask

	//always @(posedge clk)
	//begin
	//	$display("WB:  %h:  %h, %h:  %h %h",
	//		out_to_pipe_stage_if_id.stall,
	//		__state,
	//		__next_state,
	//		out_to_ctrl_unit.in_inst_lar_file__wr__req,
	//		__from_out_lar_file__wr__valid);
	//end

	initial
	begin
		//out_to_pipe_stage_if_id = 0;
		out_to_ctrl_unit = 0;
	end

	// Compute __next_state
	always @(*)
	begin
		case (__state)
		StRegular:
		begin
			//__next_state = ((__curr_decoded_instr.group == 2)
			//	|| (__curr_decoded_instr.group == 3))
			//	? StWaitForLarFileValid
			//	: StRegular;
			__next_state = ((__curr_decoded_instr.group == 2)
				|| (__curr_decoded_instr.group == 3))
				? StPrepLdSt
				: StRegular;
		end

		StPrepLdSt:
		begin
			__next_state = StWaitForLarFileValid;
		end

		StWaitForLarFileValid:
		begin
			__next_state = __from_out_lar_file__wr__valid
				? StRegular
				: StWaitForLarFileValid;
		end

		StBad:
		begin
			__next_state = StBad;
		end
		endcase
	end

	//always @(posedge clk)
	//begin
	//	$display("WB state stuff:  %h %h", __state, __next_state);

	//	if (__state == StWaitForLarFileValid)
	//	begin
	//		$display("WB StWaitForLarFileValid:  %h %h",
	//			__from_out_lar_file__wr__valid,
	//			out_to_ctrl_unit.in_inst_lar_file__wr__req);
	//	end
	//end
	always @(posedge clk)
	begin
		//$display("WB stuff:  %h %h;  %h, %h;  %h", __state, __next_state,
		//	__curr_decoded_instr.group, __curr_decoded_instr.oper,
		//	__from_out_lar_file__wr__valid);
		//$display("WB stuff:  %h %h:  %h %h",
		//	__state, __next_state,
		//	__from_out_lar_file__wr__valid,
		//	out_to_pipe_stage_if_id.stall);
		__state <= __next_state;

		case (__state)
		StRegular:
		begin
			case (__curr_decoded_instr.group)
			// ALU/FPU/Mul/Div/SimSyscall
			0:
			begin
				case (__curr_decoded_instr.oper) 
				PkgSnow64InstrDecoder::SimSyscall_ThreeRegsOneSimm12:
				begin
					out_to_ctrl_unit.in_inst_lar_file__wr__req <= 0;
				end

				default:
				begin
					//if (__curr_decoded_instr.ra_index != 0)
					//if (__curr_decoded_instr.ra_index == 'hb)
					//begin
					//$display("WB group 0 instr (non-dzero dDest):  %h, %h",
					//		__curr_decoded_instr.ra_index,
					//		in_from_pipe_stage_ex.computed_data);
					//end
					out_to_ctrl_unit.in_inst_lar_file__wr__req <= 1;
					out_to_ctrl_unit.in_inst_lar_file__wr__write_type
						<= PkgSnow64LarFile::WriteTypOnlyData;
					out_to_ctrl_unit.in_inst_lar_file__wr__index
						<= __curr_decoded_instr.ra_index;
					out_to_ctrl_unit.in_inst_lar_file__wr__non_ldst_data
						<= in_from_pipe_stage_ex.computed_data;
				end
				endcase
			end

			// Loads
			2:
			begin
				//prep_ldst(PkgSnow64LarFile::WriteTypLd);
				__captured_decoded_instr <= __curr_decoded_instr;
				__captured_ldst_addr <= in_from_pipe_stage_ex.ldst_addr;
			end

			// Stores
			3:
			begin
				//prep_ldst(PkgSnow64LarFile::WriteTypSt);
				__captured_decoded_instr <= __curr_decoded_instr;
				__captured_ldst_addr <= in_from_pipe_stage_ex.ldst_addr;
			end

			default:
			begin
				out_to_ctrl_unit.in_inst_lar_file__wr__req <= 0;
			end
			endcase
		end

		StPrepLdSt:
		begin
			case (__curr_decoded_instr.group)
			2:
			begin
				prep_ldst(PkgSnow64LarFile::WriteTypLd);
			end

			3:
			begin
				prep_ldst(PkgSnow64LarFile::WriteTypSt);
			end
			endcase
		end

		StWaitForLarFileValid:
		begin
			out_to_ctrl_unit.in_inst_lar_file__wr__req <= 0;
		end
		endcase
	end

endmodule
