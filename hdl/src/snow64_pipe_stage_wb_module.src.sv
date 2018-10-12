`include "src/snow64_pipe_stage_structs.header.sv"

module Snow64PipeStageWb(input logic clk,
	input PortIn_Snow64PipeStageWb_FromCtrlUnit in_from_ctrl_unit,
	input PortIn_Snow64PipeStageWb_FromPipeStageEx in_from_pipe_stage_ex,
	output PortOut_Snow64PipeStageWb_ToPipeStageIfId
		out_to_pipe_stage_if_id,
	output PortOut_Snow64PipeStageWb_ToCtrlUnit out_to_ctrl_unit);

	typedef enum logic
	{
		StRegular,
		StWaitForLarFileValid
	} State;
	
	logic __state = StRegular, __next_state = StRegular;

	wire __from_out_lar_file__wr__valid
		= in_from_ctrl_unit.out_inst_lar_file__wr__valid;


	PkgSnow64InstrDecoder::PortOut_InstrDecoder __curr_decoded_instr;
	assign __curr_decoded_instr = in_from_pipe_stage_ex.decoded_instr;

	assign out_to_pipe_stage_if_id.stall
		= (__next_state != StRegular);

	task prep_ldst(input logic [`MSB_POS__SNOW64_LAR_FILE_WRITE_TYPE:0]
		some_write_type);
		$display("WB:  prep_ldst():  %h", in_from_pipe_stage_ex.ldst_addr);
		out_to_ctrl_unit.in_inst_lar_file__wr__req <= 1;
		out_to_ctrl_unit.in_inst_lar_file__wr__write_type
			<= some_write_type;
		out_to_ctrl_unit.in_inst_lar_file__wr__index
			<= __curr_decoded_instr.ra_index;
		out_to_ctrl_unit.in_inst_lar_file__wr__ldst_addr
			<= in_from_pipe_stage_ex.ldst_addr;

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
			__next_state = ((__curr_decoded_instr.group == 2)
				|| (__curr_decoded_instr.group == 3))
				? StWaitForLarFileValid
				: StRegular;
		end

		StWaitForLarFileValid:
		begin
			__next_state = __from_out_lar_file__wr__valid
				? StRegular
				: StWaitForLarFileValid;
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
		__state <= __next_state;

		case (__state)
		StRegular:
		begin
			case (__curr_decoded_instr.group)
			// ALU/FPU/Mul/Div
			0:
			begin
				out_to_ctrl_unit.in_inst_lar_file__wr__req <= 1;
				out_to_ctrl_unit.in_inst_lar_file__wr__write_type
					<= PkgSnow64LarFile::WriteTypOnlyData;
				out_to_ctrl_unit.in_inst_lar_file__wr__index
					<= __curr_decoded_instr.ra_index;
				out_to_ctrl_unit.in_inst_lar_file__wr__non_ldst_data
					<= in_from_pipe_stage_ex.computed_data;
			end

			// Loads
			2:
			begin
				prep_ldst(PkgSnow64LarFile::WriteTypLd);
			end

			// Stores
			3:
			begin
				prep_ldst(PkgSnow64LarFile::WriteTypSt);
			end

			default:
			begin
				out_to_ctrl_unit.in_inst_lar_file__wr__req <= 0;
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
