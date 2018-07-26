`include "src/snow64_bfloat16_defines.header.sv"

module Snow64BFloat16Fpu(input logic clk,
	input PkgSnow64BFloat16::PortIn_Fpu in,
	output PkgSnow64BFloat16::PortOut_Fpu out);

	enum logic
	{
		StIdle,
		StWaitForSubmodule
	} __state;

	logic [`MSB_POS__SNOW64_BFLOAT16_FPU_OPER:0] __captured_in_oper;

	PkgSnow64BFloat16::PortIn_BinOp
		__in_submodule_add, __in_submodule_sub,
		__in_submodule_slt,
		__in_submodule_mul, __in_submodule_div;


	PkgSnow64BFloat16::PortOut_BinOp
		__out_submodule_add, __out_submodule_sub,
		__out_submodule_mul, __out_submodule_div;

	logic __out_submodule_slt; // slt is on an island by itself


	always @(*) __in_submodule_add.start = (__state == StIdle) && in.start
		&& ((in.oper == PkgSnow64BFloat16::OpAdd)
		|| (in.oper == PkgSnow64BFloat16::OpAddAgain));

	always @(*) __in_submodule_sub.start = (__state == StIdle) && in.start
		&& (in.oper == PkgSnow64BFloat16::OpSub);

	always @(*) __in_submodule_mul.start = (__state == StIdle) && in.start
		&& (in.oper == PkgSnow64BFloat16::OpMul);

	always @(*) __in_submodule_div.start = (__state == StIdle) && in.start
		&& (in.oper == PkgSnow64BFloat16::OpDiv);

	always @(*) __in_submodule_add.a = in.a;
	always @(*) __in_submodule_sub.a = in.a;
	always @(*) __in_submodule_slt.a = in.a;
	always @(*) __in_submodule_mul.a = in.a;
	always @(*) __in_submodule_div.a = in.a;

	always @(*) __in_submodule_add.b = in.b;
	always @(*) __in_submodule_sub.b = in.b;
	always @(*) __in_submodule_slt.b = in.b;
	always @(*) __in_submodule_mul.b = in.b;
	always @(*) __in_submodule_div.b = in.b;

	Snow64BFloat16Add __inst_submodule_add(.clk(clk),
		.in(__in_submodule_add), .out(__out_submodule_add));
	Snow64BFloat16Sub __inst_submodule_sub(.clk(clk),
		.in(__in_submodule_sub), .out(__out_submodule_sub));
	Snow64BFloat16Slt __inst_submodule_slt(.in(__in_submodule_slt),
		.out(__out_submodule_slt));
	Snow64BFloat16Mul __inst_submodule_mul(.clk(clk),
		.in(__in_submodule_mul), .out(__out_submodule_mul));
	Snow64BFloat16Div __inst_submodule_div(.clk(clk),
		.in(__in_submodule_div), .out(__out_submodule_div));

	initial
	begin
		__state = StIdle;
		out.data_valid = 0;
		out.can_accept_cmd = 1;
		out.data = 0;
	end

	task switch_to_wait_for_submodule;
		__captured_in_oper <= in.oper;
		__state <= StWaitForSubmodule;
		out.data_valid <= 0;
		out.can_accept_cmd <= 0;
	endtask

	task tell_outside_world_data_ready
		(input logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] n_out_data);
		__state <= StIdle;
		out.data_valid <= 1;
		out.can_accept_cmd <= 1;
		out.data <= n_out_data;
	endtask

	always_ff @(posedge clk)
	begin
		case (__state)
		StIdle:
		begin
			if (in.start)
			begin
				case (in.oper)
				PkgSnow64BFloat16::OpAdd:
				begin
					switch_to_wait_for_submodule();
				end

				PkgSnow64BFloat16::OpSub:
				begin
					switch_to_wait_for_submodule();
				end

				PkgSnow64BFloat16::OpSlt:
				begin
					switch_to_wait_for_submodule();
				end

				PkgSnow64BFloat16::OpMul:
				begin
					switch_to_wait_for_submodule();
				end

				PkgSnow64BFloat16::OpDiv:
				begin
					switch_to_wait_for_submodule();
				end

				PkgSnow64BFloat16::OpAddAgain:
				begin
					switch_to_wait_for_submodule();
				end
				endcase
			end
		end

		// One extra cycle of delay... boo
		StWaitForSubmodule:
		begin
			case (__captured_in_oper)
			PkgSnow64BFloat16::OpAdd:
			begin
				if (__out_submodule_add.data_valid)
				begin
					tell_outside_world_data_ready(__out_submodule_add.data);
				end
			end

			PkgSnow64BFloat16::OpSub:
			begin
				if (__out_submodule_sub.data_valid)
				begin
					tell_outside_world_data_ready(__out_submodule_sub.data);
				end
			end

			PkgSnow64BFloat16::OpSlt:
			begin
				tell_outside_world_data_ready
					(`ZERO_EXTEND(`WIDTH__SNOW64_BFLOAT16_ITSELF, 1,
					__out_submodule_slt));
			end

			PkgSnow64BFloat16::OpMul:
			begin
				if (__out_submodule_mul.data_valid)
				begin
					tell_outside_world_data_ready(__out_submodule_mul.data);
				end
			end

			PkgSnow64BFloat16::OpDiv:
			begin
				if (__out_submodule_div.data_valid)
				begin
					tell_outside_world_data_ready(__out_submodule_div.data);
				end
			end

			PkgSnow64BFloat16::OpAddAgain:
			begin
				if (__out_submodule_add.data_valid)
				begin
					tell_outside_world_data_ready(__out_submodule_add.data);
				end
			end
			endcase
		end
		endcase
	end


endmodule
