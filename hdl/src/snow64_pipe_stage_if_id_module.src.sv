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
		__curr_rc_index = 0;
		//__captured_ra_index = 0,
		//__captured_rb_index = 0,
		//__captured_rc_index = 0;

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
		//if (!in_from_instr_cache.valid)
		//begin
		//	$display("icache miss send_bubble(%h)", __spec_reg_pc);
		//end
		out_to_pipe_stage_ex.decoded_instr <= 0;
	endtask

	task send_curr_instr(input PkgSnow64Cpu::CpuAddr some_pc);
		$display("send_curr_instr(%h):  %h, %h; %h, %h", some_pc,
			__out_inst_instr_decoder.group, __out_inst_instr_decoder.oper,
			in_from_instr_cache.valid, in_from_instr_cache.instr);
		out_to_pipe_stage_ex.decoded_instr <= __out_inst_instr_decoder;
		out_to_pipe_stage_ex.pc_val <= some_pc;
		//out_to_pipe_stage_ex.pc_val <= __spec_reg_pc;
		//out_to_pipe_stage_ex.pc_val <= __following_pc;
	endtask


	`include "src/show_decoded_instr_task.header.sv"


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

	//always @(__following_pc)
	//begin
	//	$display("Updating __following_pc:  %h", __following_pc);
	//end


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
			//out_to_instr_cache = ((!in_from_pipe_stage_ex.stall)
			//	&& in_from_instr_cache.valid
			//	&& __curr_decoded_instr_changes_pc)
			//	? 0 : {1'b1, __following_pc};
			//out_to_instr_cache = ((!in_from_pipe_stage_ex.stall)
			//	&& in_from_instr_cache.valid
			//	&& __curr_decoded_instr_changes_pc)
			//	? 0 : {1'b1, __following_pc};
			//out_to_instr_cache = (in_from_instr_cache.valid
			//	&& __curr_decoded_instr_changes_pc)
			//	? 0 : {1'b1, __following_pc};
			case (in_from_pipe_stage_ex.stall)
			1'b0:
			begin
				//out_to_instr_cache = (in_from_instr_cache.valid
				//	&& __curr_decoded_instr_changes_pc)
				//	? 0 : {1'b1, __following_pc};
				case (in_from_instr_cache.valid)
				1'b0:
				begin
					out_to_instr_cache = {1'b1, __spec_reg_pc};
				end

				1'b1:
				begin
					out_to_instr_cache = __curr_decoded_instr_changes_pc
						? {1'b1, __spec_reg_pc} : {1'b1, __following_pc};
				end
				endcase
			end

			1'b1:
			begin
				out_to_instr_cache = {1'b1, __spec_reg_pc};
			end
			endcase
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




	always @(posedge clk)
	begin
		show_decoded_instr();

		//$display("IF/ID:  %h, %h; %h, %h, %h", __state, __spec_reg_pc,
		//	in_from_instr_cache.valid,
		//	in_from_pipe_stage_ex.stall,
		//	in_from_pipe_stage_wb.stall);

		//if (__state > StRegular)
		//begin
		//	$display("IF/ID stall:  %h", __state);
		//end

		case (__state)
		StInit:
		begin
			if (in_from_instr_cache.valid)
			begin
				//__spec_reg_pc <= __following_pc;
				__state <= StRegular;
			end
			send_bubble();
		end

		StRegular:
		begin
			//__captured_ra_index <= __out_inst_instr_decoder.ra_index;
			//__captured_rb_index <= __out_inst_instr_decoder.rb_index;
			//__captured_rc_index <= __out_inst_instr_decoder.rc_index;

			//if ((!in_from_pipe_stage_ex.stall)
			//	&& in_from_instr_cache.valid)
			if (!in_from_pipe_stage_ex.stall)
			begin
				if (in_from_instr_cache.valid)
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
						end

						// Control-flow instructions
						1:
						begin
							//send_curr_instr();
						$display("send_ctrl_flow_instr(%h):  %h, %h, %h",
								__spec_reg_pc,
								__out_inst_instr_decoder.group,
								__out_inst_instr_decoder.oper,
								in_from_instr_cache.instr);
							out_to_pipe_stage_ex.decoded_instr
								<= __out_inst_instr_decoder;
							out_to_pipe_stage_ex.pc_val <= __following_pc;
							//send_curr_instr(__following_pc);
							__state <= StChangePc;
						end

						// Load instructions
						2:
						begin
							send_curr_instr(__spec_reg_pc);
							__state <= StWaitForLdStPart0;
						end

						// Store instructions
						3:
						begin
							send_curr_instr(__spec_reg_pc);
							__state <= StWaitForLdStPart0;
						end
						endcase
					end

					1'b1:
					begin
						//$display("IF/ID StRegular next state:  %h",
						//	StRegular);

						$display("NOP send_bubble(%h)", __spec_reg_pc);
						send_bubble();
					end
					endcase
				end

				else // if (!in_from_instr_cache.valid)
				begin
					send_bubble();
				end
			end

			//else if (!in_from_pipe_stage_ex.stall)
			//begin
			//	//$display("IF/ID StRegular next state:  %h", StRegular);
			//	send_bubble();
			//end
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
