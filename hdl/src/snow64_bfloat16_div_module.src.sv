`include "src/snow64_bfloat16_defines.header.sv"

module Snow64BFloat16Div(input logic clk,
	input PkgSnow64BFloat16::PortIn_BinOp in,
	output PkgSnow64BFloat16::PortOut_BinOp out);

	localparam __WIDTH__TEMP = 16;
	localparam __MSB_POS__TEMP = `WIDTH2MP(__WIDTH__TEMP);

	localparam __WIDTH__BUFFER_BITS = 8;
	localparam __MSB_POS__BUFFER_BITS = `WIDTH2MP(__WIDTH__BUFFER_BITS);

	PkgSnow64BFloat16::StateDiv __state;
	//PkgSnow64BFloat16::StateDiv __state, __prev_state;

	PkgSnow64BFloat16::BFloat16 __captured_in_a, __captured_in_b,
		__curr_in_a, __curr_in_b, __temp_out_data;

	logic [__MSB_POS__TEMP:0] __temp_a_significand;
	logic [__MSB_POS__BUFFER_BITS:0] __temp_b_significand;
	logic [__MSB_POS__TEMP:0] __temp_ret_significand, __temp_ret_enc_exp;

	logic __temp_out_data_valid, __temp_out_can_accept_cmd;


	PkgSnow64LongDiv::PortIn_LongDivU16ByU8 __in_long_div;
	PkgSnow64LongDiv::PortOut_LongDivU16ByU8 __out_long_div;

	Snow64LongDivU16ByU8Radix16 __inst_long_div(.clk(clk),
		.in(__in_long_div), .out(__out_long_div));

	assign {__curr_in_a, __curr_in_b} = {in.a, in.b};

	logic __in_long_div_start;
	logic [`MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_IN_A:0] __in_long_div_a;
	logic [`MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_IN_B:0] __in_long_div_b;


	//assign __in_long_div_start = in.start;
	assign __in_long_div_start = in.start && out.can_accept_cmd;

	assign __in_long_div_a = {`SNOW64_BFLOAT16_FRAC(__curr_in_a),
		{__WIDTH__BUFFER_BITS{1'b0}}};
	assign __in_long_div_b = `SNOW64_BFLOAT16_FRAC(__curr_in_b);


	assign __in_long_div = {__in_long_div_start, __in_long_div_a,
		__in_long_div_b};

	assign out.data_valid = __temp_out_data_valid;
	assign out.can_accept_cmd = __temp_out_can_accept_cmd;
	assign out.data = __temp_out_data;

	initial
	begin
		__state = PkgSnow64BFloat16::StDivIdle;
		//__prev_state = PkgSnow64BFloat16::StDivIdle;
		__temp_out_data_valid = 0;
		__temp_out_can_accept_cmd = 1;
		__temp_out_data = 0;

		//{__captured_in_a, __captured_in_b, __curr_in_a, __curr_in_b,
		//	__temp_out_data, __temp_a_significand, __temp_b_significand,
		//	__temp_ret_significand, __temp_ret_enc_exp} = 0;
	end



	always_ff @(posedge clk)
	begin
		//__prev_state <= __state;

		case (__state)
		PkgSnow64BFloat16::StDivIdle:
		begin
			if (in.start)
			begin
				__state <= PkgSnow64BFloat16::StDivStartingLongDiv;
				__captured_in_a <= __curr_in_a;
				__captured_in_b <= __curr_in_b;

				//__temp_a_significand <= __in_long_div_a;
				//__temp_b_significand <= __in_long_div_b;
				__temp_a_significand <= {`SNOW64_BFLOAT16_FRAC(__curr_in_a),
					{__WIDTH__BUFFER_BITS{1'b0}}};
				__temp_b_significand <= `SNOW64_BFLOAT16_FRAC(__curr_in_b);

				__temp_out_data_valid <= 0;
				__temp_out_can_accept_cmd <= 0;
				__temp_out_data.sign <= (__curr_in_a.sign
					^ __curr_in_b.sign);
				__temp_out_data.enc_exp <= 0;
				__temp_out_data.enc_mantissa <= 0;
			end
		end

		PkgSnow64BFloat16::StDivStartingLongDiv:
		begin
			//$display("StDivStartingLongDiv:  %h, %h",
			//	__temp_a_significand, __temp_b_significand);

			//if (__out_long_div.data_valid && __out_long_div.can_accept_cmd)
			// This should not trigger other than when we've finished doing
			// a long division, but....
			//if ((__prev_state == PkgSnow64BFloat16::StDivStartingLongDiv)
			//	&& __out_long_div.data_valid)
			if (__out_long_div.data_valid)
			begin
				__state <= PkgSnow64BFloat16::StDivAfterLongDiv;

				// Special case of division by zero:  just set the whole
				// thing to zero
				if (__temp_b_significand == 0)
				begin
					__temp_ret_significand <= 0;
				end
				else
				begin
					__temp_ret_significand <= __out_long_div.data;
					//$display("__out_long_div.data:  %h", __out_long_div.data);
					//__temp_ret_significand <= __temp_a_significand
					//	/ __temp_b_significand;

					//if (__out_long_div.data 
					//	!= (__temp_a_significand / __temp_b_significand))
					//begin
					//	$display("Eek!  %h != %h",
					//		__out_long_div.data,
					//		(__temp_a_significand / __temp_b_significand));
					//end
				end

				__temp_ret_enc_exp
					<= `ZERO_EXTEND(__WIDTH__TEMP, 
					`WIDTH__SNOW64_BFLOAT16_ENC_EXP,
					__captured_in_a.enc_exp)
					- `ZERO_EXTEND(__WIDTH__TEMP, 
					`WIDTH__SNOW64_BFLOAT16_ENC_EXP,
					__captured_in_b.enc_exp)
					+ `ZERO_EXTEND(__WIDTH__TEMP, 
					`WIDTH__SNOW64_BFLOAT16_ENC_EXP,
					`SNOW64_BFLOAT16_BIAS);
			end
		end

		PkgSnow64BFloat16::StDivAfterLongDiv:
		begin
			//$display("StDivAfterLongDiv");
			__state <= PkgSnow64BFloat16::StDivFinishing;
			//$display("__temp_ret_significand:  %h",
			//	__temp_ret_significand);

			if (__temp_ret_significand == 0)
			begin
				__temp_ret_enc_exp <= 0;
			end
			else // if (__ret_significand != 0)
			begin
				// Normalization done here
				if (__temp_ret_significand[`WIDTH__SNOW64_BFLOAT16_FRAC])
				begin
					__temp_ret_significand <= __temp_ret_significand >> 1;
				end
				else
				begin
					__temp_ret_enc_exp <= __temp_ret_enc_exp - 1;
				end
			end
		end

		PkgSnow64BFloat16::StDivFinishing:
		begin
			__state <= PkgSnow64BFloat16::StDivIdle;
			__temp_out_data_valid <= 1;
			__temp_out_can_accept_cmd <= 1;


			// If necessary, set everything to zero
			if (__temp_ret_enc_exp[__MSB_POS__TEMP])
			begin
				//$display("set everything to zero");
				__temp_out_data.enc_mantissa <= 0;
				__temp_out_data.enc_exp <= 0;
			end
			else if (__temp_ret_enc_exp >= `SNOW64_BFLOAT16_MAX_ENC_EXP)
			begin
				//$display("saturate");
				__temp_out_data.enc_mantissa 
					<= `SNOW64_BFLOAT16_MAX_SATURATED_DATA_ABS;
				__temp_out_data.enc_exp
					<= `SNOW64_BFLOAT16_MAX_SATURATED_ENC_EXP;
			end

			else
			begin
				//$display("\"regular\"");
				//$display("outputs:  %h, %h",
				//	__temp_ret_significand, __temp_ret_enc_exp);
				__temp_out_data.enc_mantissa <= __temp_ret_significand;
				__temp_out_data.enc_exp <= __temp_ret_enc_exp;
			end
		end
		endcase
	end

endmodule

//module DebugSnow64BFloat16Div(input logic clk,
//	input PkgSnow64BFloat16::PortIn_BinOp in,
//	output PkgSnow64BFloat16::PortOut_BinOp out);
//
//	Snow64BFloat16Div __inst_bfloat16_div(.clk(clk), .in(in), .out(out));
//endmodule
