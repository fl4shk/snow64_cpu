`include "src/snow64_bfloat16_defines.header.sv"

module Snow64BFloat16Add(input logic clk,
	input PkgSnow64BFloat16::PortIn_BinOp in,
	output PkgSnow64BFloat16::PortOut_BinOp out);



	localparam __WIDTH__BUFFER_BITS = 3;
	localparam __MSB_POS__BUFFER_BITS = `WIDTH2MP(__WIDTH__BUFFER_BITS);

	//localparam __WIDTH__TEMP_SIGNIFICAND = 16 + __WIDTH__BUFFER_BITS;
	//localparam __WIDTH__TEMP_SIGNIFICAND = 24;
	//localparam __WIDTH__TEMP_SIGNIFICAND = PkgSnow64BFloat16::WIDTH__FRAC
	//	+ __WIDTH__BUFFER_BITS;
	localparam __WIDTH__TEMP_SIGNIFICAND = 16;
	localparam __MSB_POS__TEMP_SIGNIFICAND
		= `WIDTH2MP(__WIDTH__TEMP_SIGNIFICAND);


	PkgSnow64BFloat16::StateAdd __state;
	PkgSnow64BFloat16::BFloat16 __captured_in_a, __captured_in_b,
		__curr_in_a, __curr_in_b, __temp_out_data;

	logic [__MSB_POS__TEMP_SIGNIFICAND:0]
		__captured_in_a_shifted_frac, __captured_in_b_shifted_frac;
	logic [`WIDTH__SNOW64_BFLOAT16_ENC_EXP:0] __d;
	//logic __sticky;

	logic [__MSB_POS__TEMP_SIGNIFICAND:0]
		//__a_significand, __b_significand, 
		//__ret_significand,
		__temp_a_significand, __temp_b_significand, __temp_ret_significand,
		__real_num_leading_zeros, __temp_ret_enc_exp;

	//logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_IN:0] __in_clz16;
	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_OUT:0] __out_clz16;


	Snow64CountLeadingZeros16 __inst_clz16(.in(__temp_ret_significand),
		.out(__out_clz16));

	assign {__curr_in_a, __curr_in_b} = {in.a, in.b};


	// Use "always @(*)" here to keep Icarus Verilog happy
	//always @(*) out.data = __temp_out_data;


	task set_some_significand;
		input[__MSB_POS__TEMP_SIGNIFICAND:0]
			some_captured_shifted_frac_0, some_captured_shifted_frac_1;

		output [__MSB_POS__TEMP_SIGNIFICAND:0]
			some_significand_to_mod, some_significand_to_copy;

		//$display("set_some_significand():  %h %h, %h %h",
		//	some_captured_shifted_frac_0, some_captured_shifted_frac_1,
		//	some_significand_to_mod, some_significand_to_copy);

		if (__d >= __WIDTH__TEMP_SIGNIFICAND)
		begin
			// Set the sticky bit
			some_significand_to_mod
				= (some_captured_shifted_frac_0 != 0);
		end
		else if (__d > 0)
		begin
			`define inner_shift_some_significand(in, some_d, out) \
				out = ((in >> some_d) \
					& {{__WIDTH__TEMP_SIGNIFICAND - 1{1'b1}}, \
					1'b0}) \
					| (in[(some_d - 1 + __MSB_POS__BUFFER_BITS) \
					:__MSB_POS__BUFFER_BITS] != 0); \
			//`define inner_shift_some_significand(in, some_d, out) \
			//	__sticky = ((`GET_BITS_WITH_RANGE(in, \
			//		some_d - 1 + __MSB_POS__BUFFER_BITS, \
			//		__MSB_POS__BUFFER_BITS)) != 0); \
			//	out = in >> some_d; \
			//	out[0] = __sticky;

			//`inner_shift_some_significand(some_captured_shifted_frac_0,
			//	__d, some_significand_to_mod)

			case (__d)
			1:
			begin
				`inner_shift_some_significand
					(some_captured_shifted_frac_0, 1,
					some_significand_to_mod);
			end

			2:
			begin
				`inner_shift_some_significand
					(some_captured_shifted_frac_0, 2,
					some_significand_to_mod);
			end

			3:
			begin
				`inner_shift_some_significand
					(some_captured_shifted_frac_0, 3,
					some_significand_to_mod);
			end

			4:
			begin
				`inner_shift_some_significand
					(some_captured_shifted_frac_0, 4,
					some_significand_to_mod);
			end

			5:
			begin
				`inner_shift_some_significand
					(some_captured_shifted_frac_0, 5,
					some_significand_to_mod);
			end

			6:
			begin
				`inner_shift_some_significand
					(some_captured_shifted_frac_0, 6,
					some_significand_to_mod);
			end

			7:
			begin
				`inner_shift_some_significand
					(some_captured_shifted_frac_0, 7,
					some_significand_to_mod);
			end

			8:
			begin
				`inner_shift_some_significand
					(some_captured_shifted_frac_0, 8,
					some_significand_to_mod);
			end

			9:
			begin
				`inner_shift_some_significand
					(some_captured_shifted_frac_0, 9,
					some_significand_to_mod);
			end

			//10:
			default:
			begin
				`inner_shift_some_significand
					(some_captured_shifted_frac_0, 10,
					some_significand_to_mod);
			end
			endcase

			`undef inner_shift_some_significand
		end

		else
		begin
			some_significand_to_mod = some_captured_shifted_frac_0;
		end

		some_significand_to_copy = some_captured_shifted_frac_1;

		//$display("set_some_significand():  %h %h, %h %h",
		//	some_captured_shifted_frac_0, some_captured_shifted_frac_1,
		//	some_significand_to_mod, some_significand_to_copy);
	endtask // set_some_significand


	//always @(in.a or in.b)
	//always @(__state)

	initial
	begin
		__state = PkgSnow64BFloat16::StAddIdle;
		out.data_valid = 0;
		out.can_accept_cmd = 1;
		out.data = 0;
	end

	// Pseudo combinational logic
	always @(posedge clk)
	begin
		case (__state)
		PkgSnow64BFloat16::StAddIdle:
		begin
			if (in.start)
			begin
				out = 0;
				if (__curr_in_a.enc_exp < __curr_in_b.enc_exp)
				begin
					__d = __curr_in_b.enc_exp - __curr_in_a.enc_exp;
					__temp_out_data.enc_exp = __curr_in_b.enc_exp;
				end

				else // if (__curr_in_a.enc_exp >= __curr_in_b.enc_exp)
				begin
					__d = __curr_in_a.enc_exp - __curr_in_b.enc_exp;
					__temp_out_data.enc_exp = __curr_in_a.enc_exp;
				end
				__captured_in_a_shifted_frac
					= `SNOW64_BFLOAT16_FRAC(__curr_in_a)
					<< __WIDTH__BUFFER_BITS;
				__captured_in_b_shifted_frac
					= `SNOW64_BFLOAT16_FRAC(__curr_in_b)
					<< __WIDTH__BUFFER_BITS;

				if (__curr_in_a.enc_exp < __curr_in_b.enc_exp)
				begin
					set_some_significand(__captured_in_a_shifted_frac,
						__captured_in_b_shifted_frac,
						__temp_a_significand, __temp_b_significand);
				end
				else // if (__curr_in_a.enc_exp >= __curr_in_b.enc_exp)
				begin
					set_some_significand(__captured_in_b_shifted_frac,
						__captured_in_a_shifted_frac,
						__temp_b_significand, __temp_a_significand);
				end
			end
		end
		PkgSnow64BFloat16::StAddStarting:
		begin
			//if (__curr_in_a.enc_exp < __curr_in_b.enc_exp)
			//begin
			//	set_some_significand(__captured_in_a_shifted_frac,
			//		__captured_in_b_shifted_frac,
			//		__temp_a_significand, __temp_b_significand);
			//end
			//else // if (__curr_in_a.enc_exp >= __curr_in_b.enc_exp)
			//begin
			//	set_some_significand(__captured_in_b_shifted_frac,
			//		__captured_in_a_shifted_frac,
			//		__temp_b_significand, __temp_a_significand);
			//end

			if (__captured_in_a.sign == __captured_in_b.sign)
			begin
				__temp_ret_significand = __temp_a_significand
					+ __temp_b_significand;
				__temp_out_data.sign = __captured_in_a.sign;
			end
			else // if (__captured_in_a.sign != __captured_in_b.sign)
			begin
				__temp_ret_significand = __captured_in_a.sign
					? (__temp_b_significand - __temp_a_significand)
					: (__temp_a_significand - __temp_b_significand);

				// Convert to sign and magnitude
				if (__temp_ret_significand
					[__MSB_POS__TEMP_SIGNIFICAND])
				begin
					__temp_out_data.sign = 1;
					__temp_ret_significand = -__temp_ret_significand;
				end

				else
				begin
					__temp_out_data.sign = 0;
				end
			end
		end

		PkgSnow64BFloat16::StAddEffAdd:
		begin
			// Check for an overflow (for an add:  only ever by one bit,
			// and thus we only need to be able to right shift by one bit)
			if (__temp_ret_significand[`WIDTH__SNOW64_BFLOAT16_FRAC
				+ __WIDTH__BUFFER_BITS])
			begin
				__temp_ret_significand = __temp_ret_significand >> 1;
				__temp_out_data.enc_exp = __temp_out_data.enc_exp + 1;
			end

			// If necessary, saturate to the highest valid mantissa and
			// exponent
			if (__temp_out_data.enc_exp == `SNOW64_BFLOAT16_MAX_ENC_EXP)
			begin
				{__temp_ret_significand, __temp_out_data.enc_exp}
					= {{__WIDTH__TEMP_SIGNIFICAND{1'b1}},
					`SNOW64_BFLOAT16_MAX_SATURATED_ENC_EXP};
			end

			{__temp_out_data.enc_mantissa, __temp_out_data.sign}
				= {__temp_ret_significand[`MSB_POS__SNOW64_BFLOAT16_FRAC
				+ __WIDTH__BUFFER_BITS :__WIDTH__BUFFER_BITS],
				__captured_in_a.sign};

			//$display("StAddEffAdd:  %h, %h, %h:  %h",
			//	__temp_out_data.sign, __temp_out_data.enc_exp,
			//	__temp_out_data.enc_mantissa, __temp_out_data);
			{out.data_valid, out.can_accept_cmd, out.data}
				= {1'b1, 1'b1, __temp_out_data};
		end

		PkgSnow64BFloat16::StAddEffSub:
		begin
			// If the result is not zero
			if (__temp_ret_significand)
			begin
				__real_num_leading_zeros
					= __out_clz16
					- (__WIDTH__TEMP_SIGNIFICAND
					- (`WIDTH__SNOW64_BFLOAT16_FRAC
					+ __WIDTH__BUFFER_BITS));

				if ((`ZERO_EXTEND(32, `WIDTH__SNOW64_BFLOAT16_ENC_EXP,
					__temp_out_data.enc_exp)
					- `ZERO_EXTEND(32, __WIDTH__TEMP_SIGNIFICAND,
					__real_num_leading_zeros)) & (1 << 31))
				begin
					__temp_out_data.enc_exp = 0;
				end

				else
				begin
					__temp_out_data.enc_exp = __temp_out_data.enc_exp
						- __real_num_leading_zeros;
					__temp_ret_significand <<= __real_num_leading_zeros;
				end
			end

			else // if (!__temp_ret_significand)
			begin
				__temp_out_data.enc_exp = 0;
			end

			if (__temp_out_data.enc_exp == 0)
			begin
				__temp_out_data.enc_mantissa = 0;
			end

			else // if (__temp_out_data.enc_exp != 0)
			begin
				__temp_out_data.enc_mantissa = __temp_ret_significand
					[__MSB_POS__TEMP_SIGNIFICAND:__WIDTH__BUFFER_BITS];
			end

			//$display("StAddEffSub:  %h, %h",
			//	__temp_ret_significand, __temp_out_data);

			//$display("StAddEffSub:  %h, %h, %h:  %h",
			//	__temp_out_data.sign, __temp_out_data.enc_exp,
			//	__temp_out_data.enc_mantissa, __temp_out_data);

			{out.data_valid, out.can_accept_cmd, out.data}
				= {1'b1, 1'b1, __temp_out_data};
		end

		//default:
		//begin
		//	{__temp_a_significand, __temp_b_significand,
		//		__temp_ret_significand, __temp_out_data,
		//		__real_num_leading_zeros} = 0;
		//end

		endcase
	end



	always_ff @(posedge clk)
	begin
		case (__state)
		PkgSnow64BFloat16::StAddIdle:
		begin
			if (in.start)
			begin
				//out.data_valid <= 0;
				//out.can_accept_cmd <= 0;

				__captured_in_a <= in.a;
				__captured_in_b <= in.b;


				__state <= PkgSnow64BFloat16::StAddStarting;

				//__captured_in_a_shifted_frac
				//	<= `SNOW64_BFLOAT16_FRAC(__curr_in_a) << __WIDTH__BUFFER_BITS;
				//__captured_in_b_shifted_frac
				//	<= `SNOW64_BFLOAT16_FRAC(__curr_in_b) << __WIDTH__BUFFER_BITS;

				//if (__curr_in_a.enc_exp < __curr_in_b.enc_exp)
				//begin
				//	__d <= __curr_in_b.enc_exp - __curr_in_a.enc_exp;
				//	//__temp_out_data.enc_exp <= __curr_in_b.enc_exp;
				//end

				//else // if (__curr_in_a.enc_exp >= __curr_in_b.enc_exp)
				//begin
				//	__d <= __curr_in_a.enc_exp - __curr_in_b.enc_exp;
				//	//__temp_out_data.enc_exp <= __curr_in_a.enc_exp;
				//end

				//__temp_out_data.sign <= 0;
			end
		end

		PkgSnow64BFloat16::StAddStarting:
		begin
			if (__captured_in_a.sign == __captured_in_b.sign)
			begin
				__state <= PkgSnow64BFloat16::StAddEffAdd;

				//__ret_significand <= __temp_a_significand
				//	+ __temp_b_significand;
			end

			else // if (__captured_in_a.sign != __captured_in_b.sign)
			begin
				__state <= PkgSnow64BFloat16::StAddEffSub;

				//// Convert to sign and magnitude
				//if (__temp_ret_significand
				//	[__MSB_POS__TEMP_SIGNIFICAND])
				//begin
				//	__temp_out_data.sign <= 1;
				//	__ret_significand <= -__temp_ret_significand;
				//end

				//else
				//begin
				//	__ret_significand <= __temp_ret_significand;
				//end
			end
		end


		//PkgSnow64BFloat16::StAddEffAdd:
		//PkgSnow64BFloat16::StAddEffSub:
		default:
		begin
			__state <= PkgSnow64BFloat16::StAddIdle;
			//out.data_valid <= 1;
			//out.can_accept_cmd <= 1;

			//__ret_significand <= __temp_ret_significand;
			//__temp_out_data <= __temp_out_data;
		end
		endcase
	end
endmodule

//module Snow64BFloat16Add(input logic clk,
//	input PkgSnow64BFloat16::PortIn_BinOp in,
//	output PkgSnow64BFloat16::PortOut_BinOp out);
//
//	__RealSnow64BFloat16Add __inst_real_bfloat16_add(.clk(clk), .in(in),
//		.out(out));
//endmodule
//
//module Snow64BFloat16Sub(input logic clk,
//	input PkgSnow64BFloat16::PortIn_BinOp in,
//	output PkgSnow64BFloat16::PortOut_BinOp out);
//
//	PkgSnow64BFloat16::PortIn_BinOp __in_bfloat16_add;
//	PkgSnow64BFloat16::BFloat16 __in_b, __in_bfloat16_add_b;
//
//	__RealSnow64BFloat16Add __inst_real_bfloat16_add(.clk(clk),
//		.in(__in_bfloat16_add), .out(out));
//
//	always @(*) __in_b = in.b;
//	always @(*) __in_bfloat16_add_b.sign = !__in_b.sign;
//	always @(*) __in_bfloat16_add_b.enc_exp = __in_b.enc_exp;
//	always @(*) __in_bfloat16_add_b.enc_mantissa = __in_b.enc_mantissa;
//
//	always @(*) __in_bfloat16_add.start = in.start;
//	always @(*) __in_bfloat16_add.a = in.a;
//	always @(*) __in_bfloat16_add.b = __in_bfloat16_add_b;
//
//endmodule
