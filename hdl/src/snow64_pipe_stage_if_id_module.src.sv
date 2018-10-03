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

	localparam __WIDTH__STATE = 2;
	localparam __MSB_POS__STATE = `WIDTH2MP(__WIDTH__STATE);

	enum logic [__MSB_POS__STATE:0]
	{
		StRegular,
		StChangePc,
		StWaitForLdStPart0,
		StWaitForLdStPart1
	} __state;

	PkgSnow64InstrDecoder::PortOut_InstrDecoder __out_inst_instr_decoder;
	Snow64InstrDecoder __inst_instr_decoder(.in(in_from_instr_cache.instr),
		.out(__out_inst_instr_decoder));

	assign out_to_ctrl_unit = {__out_inst_instr_decoder.ra_index,
		__out_inst_instr_decoder.rb_index,
		__out_inst_instr_decoder.rc_index};

	logic [`MSB_POS__SNOW64_CPU_ADDR:0] __spec_reg_pc;

	//task send_bubble;
	//	out_to_pipe_stage_ex.decoded_instr <= 0;
	//endtask

	//task send_decoded_instr;
	//	out_to_pipe_stage_ex.decoded_instr <= __out_inst_instr_decoder;
	//endtask

	//task send_pc;
	//	out_to_pipe_stage_ex.pc_val <= __spec_reg_pc;
	//endtask

	//task regular_pc_update;
	//	__spec_reg_pc <= __spec_reg_pc + __NUM_BYTES__INSTR;
	//endtask



	initial
	begin
		__state = StRegular;
		__spec_reg_pc = -__NUM_BYTES__INSTR;
		out_to_instr_cache = 0;
		out_to_pipe_stage_ex = 0;
	end


	//assign out_to_instr_cache = {1'b1,
	//	(__spec_reg_pc + __NUM_BYTES__INSTR)};

	always @(*)
	begin
		case (__state)
		StChangePc:
		begin
			out_to_instr_cache
				= {1'b1, in_from_pipe_stage_ex.computed_pc};
		end

		default:
		begin
			out_to_instr_cache
				= {1'b1, (__spec_reg_pc + __NUM_BYTES__INSTR)};
		end
		endcase
	end



	always @(posedge clk)
	begin
		case (__state)
		StRegular:
		begin
			if ((!in_from_pipe_stage_ex.stall)
				&& in_from_instr_cache.valid)
			begin
				case (__out_inst_instr_decoder.group)
				0:
				begin
					case (__out_inst_instr_decoder.nop)
					1'b0:
					begin
						//send_decoded_instr();
						//send_pc();

						out_to_pipe_stage_ex.decoded_instr
							<= __out_inst_instr_decoder;
						out_to_pipe_stage_ex.pc_val <= __spec_reg_pc;
					end

					1'b1:
					begin
						//send_bubble();
						out_to_pipe_stage_ex.decoded_instr <= 0;
					end
					endcase
					//regular_pc_update();
					__spec_reg_pc <= __spec_reg_pc + __NUM_BYTES__INSTR;
				end

				1:
				begin
					case (__out_inst_instr_decoder.nop)
					1'b0:
					begin
						//send_decoded_instr();
						//send_pc();
						out_to_pipe_stage_ex.decoded_instr
							<= __out_inst_instr_decoder;
						out_to_pipe_stage_ex.pc_val <= __spec_reg_pc;
						__state <= StChangePc;
					end

					1'b1:
					begin
						//send_bubble();
						//regular_pc_update();
						out_to_pipe_stage_ex.decoded_instr <= 0;
						__spec_reg_pc <= __spec_reg_pc
							+ __NUM_BYTES__INSTR;
					end
					endcase
				end

				2:
				begin
					case (__out_inst_instr_decoder.nop)
					1'b0:
					begin
						//send_decoded_instr();
						//send_pc();
						out_to_pipe_stage_ex.decoded_instr
							<= __out_inst_instr_decoder;
						out_to_pipe_stage_ex.pc_val <= __spec_reg_pc;
						__state <= StWaitForLdStPart0;
					end

					1'b1:
					begin
						//send_bubble();
						out_to_pipe_stage_ex.decoded_instr <= 0;
					end
					endcase
					//regular_pc_update();
					__spec_reg_pc <= __spec_reg_pc + __NUM_BYTES__INSTR;
				end

				3:
				begin
					case (__out_inst_instr_decoder.nop)
					1'b0:
					begin
						//send_decoded_instr();
						//send_pc();
						out_to_pipe_stage_ex.decoded_instr
							<= __out_inst_instr_decoder;
						out_to_pipe_stage_ex.pc_val <= __spec_reg_pc;
						__state <= StWaitForLdStPart0;
					end

					1'b1:
					begin
						//send_bubble();
						out_to_pipe_stage_ex.decoded_instr <= 0;
					end
					endcase
					//regular_pc_update();
					__spec_reg_pc <= __spec_reg_pc + __NUM_BYTES__INSTR;
				end

				default:
				begin
					// The instruction was a NOP
					//send_bubble();
					//regular_pc_update();
					out_to_pipe_stage_ex.decoded_instr <= 0;
					__spec_reg_pc <= __spec_reg_pc + __NUM_BYTES__INSTR;
				end
				endcase
			end
		end

		StChangePc:
		begin
			// EX stage:  combinational logic for updating the program
			// counter.
			__spec_reg_pc <= in_from_pipe_stage_ex.computed_pc;
			__state <= StRegular;
			//send_bubble();
			out_to_pipe_stage_ex.decoded_instr <= 0;
		end

		StWaitForLdStPart0:
		begin
			__state <= StWaitForLdStPart1;
			//send_bubble();
			out_to_pipe_stage_ex.decoded_instr <= 0;
		end

		StWaitForLdStPart1:
		begin
			if (!in_from_pipe_stage_wb.stall)
			begin
				__state <= StRegular;
			end

			//send_bubble();
			out_to_pipe_stage_ex.decoded_instr <= 0;
		end
		endcase
	end


endmodule
