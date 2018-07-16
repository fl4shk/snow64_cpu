`include "src/snow64_bfloat16_defines.header.sv"

module Snow64BFloat16Mul(input logic clk,
	input PkgSnow64BFloat16::PortIn_Oper in,
	output PkgSnow64BFloat16::PortOut_Oper out);

	localparam __WIDTH__TEMP = 16;
	localparam __MSB_POS__TEMP = `WIDTH2MP(__WIDTH__TEMP);

	PkgSnow64BFloat16::StateMul __state;
	//PkgSnow64BFloat16::BFloat16 __captured_in_a, __captured_in_b,
	//	__curr_in_a, __curr_in_b, __temp_out_data;
	PkgSnow64BFloat16::BFloat16 __curr_in_a, __curr_in_b, __temp_out_data;

	logic [__MSB_POS__TEMP:0]
		__temp_a_significand, __temp_b_significand, __temp_ret_significand,
		__temp_ret_enc_exp;

	assign {__curr_in_a, __curr_in_b} = {in.a, in.b};


	initial
	begin
		__state = PkgSnow64BFloat16::StMulIdle;
		out.data_valid = 0;
		out.can_accept_cmd = 1;
		out.data = 0;
	end

	// Pseudo combinational logic
	always @(posedge clk)
	begin
		case (__state)
		PkgSnow64BFloat16::StMulIdle:
		begin
			if (in.start)
			begin
				out = 0;

				__temp_out_data.sign = __curr_in_a.sign ^ __curr_in_b.sign;

				{__temp_a_significand, __temp_b_significand}
					= {`ZERO_EXTEND(__WIDTH__TEMP,
					`WIDTH__SNOW64_BFLOAT16_FRAC,
					`BFLOAT16_FRAC(__curr_in_a)),
					`ZERO_EXTEND(__WIDTH__TEMP,
					`WIDTH__SNOW64_BFLOAT16_FRAC,
					`BFLOAT16_FRAC(__curr_in_b))};
				//__temp_a_significand = `BFLOAT16_FRAC(__curr_in_a);
				//__temp_b_significand = `BFLOAT16_FRAC(__curr_in_b);

				//$display("temp a, temp b:  %h, %h", __temp_a_significand,
				//	__temp_b_significand);

				if (__temp_a_significand && __temp_b_significand)
				begin
					__temp_ret_significand
						= __temp_a_significand * __temp_b_significand;
					__temp_ret_enc_exp
						= (`ZERO_EXTEND(__WIDTH__TEMP,
						`WIDTH__SNOW64_BFLOAT16_ENC_EXP,
						__curr_in_a.enc_exp))
						+ (`ZERO_EXTEND(__WIDTH__TEMP,
						`WIDTH__SNOW64_BFLOAT16_ENC_EXP,
						__curr_in_b.enc_exp))
						- (`ZERO_EXTEND(__WIDTH__TEMP,
						  `WIDTH__SNOW64_BFLOAT16_ENC_EXP,
						`SNOW64_BFLOAT16_BIAS));
				end

				// Special case 0:  we need to set the encoded exponent
				// to zero in this case
				else
				begin
					{__temp_ret_significand, __temp_ret_enc_exp} = 0;
				end

				// Normalize if needed
				if (__temp_ret_significand[__MSB_POS__TEMP])
				begin
					__temp_ret_significand = __temp_ret_significand >> 1;
					__temp_ret_enc_exp = __temp_ret_enc_exp + 1;
				end

				__temp_ret_significand = __temp_ret_significand
					>> `SNOW64_BFLOAT16_MUL_SIGNIFICAND_NUM_BUFFER_BITS;

				//$display("stuffs 0:  %h, %h",
				//	__temp_ret_significand, __temp_ret_enc_exp);
			end
		end

		PkgSnow64BFloat16::StMulFinishing:
		begin
			// If necessary, set everything to zero.
			if ((__temp_ret_enc_exp == 0)
				|| (__temp_ret_enc_exp[__MSB_POS__TEMP]))
			begin
				{__temp_out_data.enc_mantissa, __temp_out_data.enc_exp}
					= 0;
			end

			// If necessary, saturate to highest valid mantissa and
			// exponent
			else if (__temp_ret_enc_exp >= `ZERO_EXTEND(__WIDTH__TEMP,
				`WIDTH__SNOW64_BFLOAT16_ENC_EXP,
				`SNOW64_BFLOAT16_MAX_ENC_EXP))
			begin
				{__temp_out_data.enc_mantissa, __temp_out_data.enc_exp}
					= {`SNOW64_BFLOAT16_MAX_SATURATED_DATA_ABS,
					`SNOW64_BFLOAT16_MAX_SATURATED_ENC_EXP};
			end

			else
			begin
				{__temp_out_data.enc_mantissa, __temp_out_data.enc_exp}
				= {__temp_ret_significand
				[`MSB_POS__SNOW64_BFLOAT16_ENC_MANTISSA:0],
				__temp_ret_enc_exp[`MSB_POS__SNOW64_BFLOAT16_ENC_EXP:0]};
			end

			{out.data_valid, out.can_accept_cmd, out.data}
				= {1'b1, 1'b1, __temp_out_data};
		end

		endcase
	end

	always_ff @(posedge clk)
	begin
		case (__state)
		PkgSnow64BFloat16::StMulIdle:
		begin
			if (in.start)
			begin
				//__captured_in_a <= in.a;
				//__captured_in_b <= in.b;

				__state <= PkgSnow64BFloat16::StMulFinishing;
			end
		end

		PkgSnow64BFloat16::StMulFinishing:
		begin
			__state <= PkgSnow64BFloat16::StMulIdle;
		end
		endcase
	end


endmodule
