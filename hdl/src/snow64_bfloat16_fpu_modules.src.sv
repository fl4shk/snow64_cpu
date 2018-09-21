`include "src/snow64_bfloat16_defines.header.sv"

//module DebugSnow64BFloat16Fpu(input logic clk,
//	input logic in_start,
//	input logic [`MSB_POS__SNOW64_BFLOAT16_FPU_OPER:0] in_oper,
//	input logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] in_a, in_b,
//	output logic out_valid, out_can_accept_cmd,
//	output logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] out_data);
//
//
//	PkgSnow64BFloat16::PortIn_Fpu __in_bfloat16_fpu;
//	PkgSnow64BFloat16::PortOut_Fpu __out_bfloat16_fpu;
//
//	always @(*) __in_bfloat16_fpu.start = in_start;
//	always @(*) __in_bfloat16_fpu.oper = in_oper;
//	always @(*) __in_bfloat16_fpu.a = in_a;
//	always @(*) __in_bfloat16_fpu.b = in_b;
//
//	assign out_valid = __out_bfloat16_fpu.valid;
//	assign out_can_accept_cmd = __out_bfloat16_fpu.can_accept_cmd;
//	assign out_data = __out_bfloat16_fpu.data;
//
//	Snow64BFloat16Fpu __inst_bfloat16_fpu(.clk(clk),
//		.in(__in_bfloat16_fpu), .out(__out_bfloat16_fpu));
//endmodule


module Snow64BFloat16Fpu(input logic clk,
	input PkgSnow64BFloat16::PortIn_Fpu in,
	output PkgSnow64BFloat16::PortOut_Fpu out);

	PkgSnow64BFloat16::BFloat16 __in_b, __in_b_negated;
	assign __in_b = in.b;
	always @(*) __in_b_negated.sign = !__in_b.sign;
	always @(*) __in_b_negated.enc_exp = __in_b.enc_exp;
	always @(*) __in_b_negated.enc_mantissa = __in_b.enc_mantissa;

	logic [`MSB_POS__SNOW64_BFLOAT16_FPU_OPER:0] __captured_in_oper;



	PkgSnow64BFloat16::PortIn_BinOp
		__in_submodule_add, __in_submodule_slt,
		__in_submodule_mul, __in_submodule_div;


	PkgSnow64BFloat16::PortOut_BinOp
		__out_submodule_add, __out_submodule_slt,
		__out_submodule_mul, __out_submodule_div;

	always @(*) __in_submodule_add.start = __temp_out_can_accept_cmd
		&& in.start && ((in.oper == PkgSnow64BFloat16::OpAdd)
		|| (in.oper == PkgSnow64BFloat16::OpSub)
		|| (in.oper == PkgSnow64BFloat16::OpAddAgain));

	always @(*) __in_submodule_slt.start = __temp_out_can_accept_cmd
		&& in.start && (in.oper == PkgSnow64BFloat16::OpSlt);

	always @(*) __in_submodule_mul.start = __temp_out_can_accept_cmd
		&& in.start && (in.oper == PkgSnow64BFloat16::OpMul);

	always @(*) __in_submodule_div.start = __temp_out_can_accept_cmd
		&& in.start && (in.oper == PkgSnow64BFloat16::OpDiv);

	always @(*) __in_submodule_add.a = in.a;
	always @(*) __in_submodule_slt.a = in.a;
	always @(*) __in_submodule_mul.a = in.a;
	always @(*) __in_submodule_div.a = in.a;

	always @(*)
	begin
		if (in.oper == PkgSnow64BFloat16::OpSub)
		begin
			__in_submodule_add.b = __in_b_negated;
		end

		else // if (in.oper != PkgSnow64BFloat16::OpSub)
		begin
			__in_submodule_add.b = in.b;
		end
	end
	always @(*) __in_submodule_slt.b = in.b;
	always @(*) __in_submodule_mul.b = in.b;
	always @(*) __in_submodule_div.b = in.b;

	Snow64BFloat16Add __inst_submodule_add(.clk(clk),
		.in(__in_submodule_add), .out(__out_submodule_add));
	Snow64BFloat16Slt __inst_submodule_slt(.clk(clk),
		.in(__in_submodule_slt), .out(__out_submodule_slt));
	Snow64BFloat16Mul __inst_submodule_mul(.clk(clk),
		.in(__in_submodule_mul), .out(__out_submodule_mul));
	Snow64BFloat16Div __inst_submodule_div(.clk(clk),
		.in(__in_submodule_div), .out(__out_submodule_div));

	logic __temp_out_valid, __temp_out_can_accept_cmd;

	initial
	begin
		__captured_in_oper = 0;
		//__temp_out_valid = 0;
		//__temp_out_can_accept_cmd = 1;
		out.data = 0;
	end

	//always @(*)
	always @(*) out.valid = __temp_out_valid;
	always @(*) out.can_accept_cmd = __temp_out_can_accept_cmd;
	
	assign __temp_out_valid
		= ((!(in.start && __temp_out_can_accept_cmd))
		&& ((__out_submodule_add.valid
		&& ((__captured_in_oper == PkgSnow64BFloat16::OpAdd)
		|| (__captured_in_oper == PkgSnow64BFloat16::OpSub)
		|| (__captured_in_oper == PkgSnow64BFloat16::OpAddAgain)))

		|| (__out_submodule_slt.valid
		&& (__captured_in_oper == PkgSnow64BFloat16::OpSlt))

		|| (__out_submodule_mul.valid
		&& (__captured_in_oper == PkgSnow64BFloat16::OpMul))

		|| (__out_submodule_div.valid
		&& (__captured_in_oper == PkgSnow64BFloat16::OpDiv))));

	assign __temp_out_can_accept_cmd
		= (__out_submodule_add.can_accept_cmd
		&& __out_submodule_slt.can_accept_cmd
		&& __out_submodule_mul.can_accept_cmd
		&& __out_submodule_div.can_accept_cmd);

	//task switch_to_wait_for_submodule;
	//	__captured_in_oper <= in.oper;
	//	__state <= StWaitForSubmodule;
	//	out.valid <= 0;
	//	out.can_accept_cmd <= 0;
	//endtask

	//task switch_to_idle
	//	(input logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] n_out_data);
	//	__state <= StIdle;
	//	out.valid <= 1;
	//	out.can_accept_cmd <= 1;
	//	out.data <= n_out_data;
	//endtask

	always @(*)
	begin
		//if (out.can_accept_cmd)
		if (__temp_out_can_accept_cmd)
		begin
			case (__captured_in_oper)
			PkgSnow64BFloat16::OpAdd:
			begin
				out.data = __out_submodule_add.data;
			end

			PkgSnow64BFloat16::OpSub:
			begin
				out.data = __out_submodule_add.data;
			end

			PkgSnow64BFloat16::OpSlt:
			begin
				out.data = __out_submodule_slt.data;
			end

			PkgSnow64BFloat16::OpMul:
			begin
				out.data = __out_submodule_mul.data;
			end

			PkgSnow64BFloat16::OpDiv:
			begin
				out.data = __out_submodule_div.data;
			end

			PkgSnow64BFloat16::OpAddAgain:
			begin
				out.data = __out_submodule_add.data;
			end

			default:
			begin
				out.data = 0;
			end
			endcase
		end

		else // if (!__temp_out_can_accept_cmd)
		begin
			out.data = 0;
		end
	end

	always_ff @(posedge clk)
	begin
		if (in.start && out.can_accept_cmd)
		begin
			__captured_in_oper <= in.oper;
		end
	end
endmodule


module Snow64BFloat16VectorFpu(input logic clk,
	input PkgSnow64BFloat16::PortIn_VectorFpu in,
	output PkgSnow64BFloat16::PortOut_VectorFpu out);

	`define OPERATE_ON_SUB_FPU \
		`X(0) `X(1) `X(2) `X(3) \
		`X(4) `X(5) `X(6) `X(7) \
		`X(8) `X(9) `X(10) `X(11) \
		`X(12) `X(13) `X(14) `X(15)


	`define IN_INST_SUB_FPU(inst_num) __in_inst_sub_fpu_``inst_num
	`define OUT_INST_SUB_FPU(inst_num) __out_inst_sub_fpu_``inst_num

	`define X(inst_num) \
		PkgSnow64BFloat16::PortIn_Fpu `IN_INST_SUB_FPU(inst_num); \
		PkgSnow64BFloat16::PortOut_Fpu `OUT_INST_SUB_FPU(inst_num); \
		Snow64BFloat16Fpu __inst_sub_fpu_``inst_num(.clk(clk), \
			.in(`IN_INST_SUB_FPU(inst_num)), \
			.out(`OUT_INST_SUB_FPU(inst_num))); \
		assign `IN_INST_SUB_FPU(inst_num) \
			= {in.start, in.oper, \
			in.a[inst_num * `WIDTH__SNOW64_BFLOAT16_ITSELF \
			+: `WIDTH__SNOW64_BFLOAT16_ITSELF], \
			in.b[inst_num * `WIDTH__SNOW64_BFLOAT16_ITSELF \
			+: `WIDTH__SNOW64_BFLOAT16_ITSELF]};
	`OPERATE_ON_SUB_FPU
	`undef X

	//assign out = {`OUT_INST_SUB_FPU(0).valid,
	//	{`OUT_INST_SUB_FPU(15).data, `OUT_INST_SUB_FPU(14).data,
	//	`OUT_INST_SUB_FPU(13).data, `OUT_INST_SUB_FPU(12).data,
	//	`OUT_INST_SUB_FPU(11).data, `OUT_INST_SUB_FPU(10).data,
	//	`OUT_INST_SUB_FPU(9).data, `OUT_INST_SUB_FPU(8).data,
	//	`OUT_INST_SUB_FPU(7).data, `OUT_INST_SUB_FPU(6).data,
	//	`OUT_INST_SUB_FPU(5).data, `OUT_INST_SUB_FPU(4).data,
	//	`OUT_INST_SUB_FPU(3).data, `OUT_INST_SUB_FPU(2).data,
	//	`OUT_INST_SUB_FPU(1).data, `OUT_INST_SUB_FPU(0).data}};

	assign out.valid = `OUT_INST_SUB_FPU(0).valid;
	`define X(inst_num) \
		assign out[inst_num * 16 +: 16] = `OUT_INST_SUB_FPU(inst_num).data;
	`OPERATE_ON_SUB_FPU
	`undef X


	`undef IN_INST_SUB_FPU
	`undef OUT_INST_SUB_FPU
	`undef OPERATE_ON_SUB_FPU
endmodule
