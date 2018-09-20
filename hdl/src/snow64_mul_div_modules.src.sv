`include "src/snow64_mul_div_defines.header.sv"

`define OUT_DATA {out.data_1, out.data_0}


module __Snow64SubMul(input logic clk,
	input PkgSnow64ArithLog::PortIn_SubMul in,
	output PkgSnow64ArithLog::PortOut_Mul out);


	localparam __WIDTH__STATE = 3;
	localparam __MSB_POS__STATE = `WIDTH2MP(__WIDTH__STATE);

	enum logic [__MSB_POS__STATE:0]
	{
		StIdle,
		StMulMediumAdds,

		StMulLargeAdds_0,

		StMulLargeAdds_1,

		StMulLargeAdds_2,
		StMulLargeAdds_3,
		StBad0,
		StBad1
	} __state;

	localparam __WIDTH__MUL_MEDIUM_LEFT_SHIFT
		= `WIDTH__SNOW64_SUB_MUL_SMALL_DATA;
	localparam __WIDTH__MUL_LARGE_LEFT_SHIFT_0
		= `WIDTH__SNOW64_SUB_MUL_SMALL_DATA * 1;
	localparam __WIDTH__MUL_LARGE_LEFT_SHIFT_1
		= `WIDTH__SNOW64_SUB_MUL_SMALL_DATA * 2;
	localparam __WIDTH__MUL_LARGE_LEFT_SHIFT_2
		= `WIDTH__SNOW64_SUB_MUL_SMALL_DATA * 3;

	`ifdef FORMAL_TINY_MUL
	PkgSnow64SlicedData::FormalSlicedData2
	`else // if !defined(FORMAL_TINY_MUL)
	PkgSnow64SlicedData::SlicedData8
	`endif		// FORMAL_TINY_MUL
		__in_a_sliced_small, __in_b_sliced_small;

	assign {__in_a_sliced_small, __in_b_sliced_small} = {in.a, in.b};

	`define MAKE_CURR_PROD(slice_num_a, slice_num_b) \
	wire [`MSB_POS__SNOW64_SUB_MUL_MEDIUM_DATA:0] \
		__curr_prod_``slice_num_a``_``slice_num_b \
			= (`ZERO_EXTEND(`WIDTH__SNOW64_SUB_MUL_MEDIUM_DATA, \
			`WIDTH__SNOW64_SUB_MUL_SMALL_DATA, \
			__in_a_sliced_small.data_``slice_num_a) \
			* `ZERO_EXTEND(`WIDTH__SNOW64_SUB_MUL_MEDIUM_DATA, \
			`WIDTH__SNOW64_SUB_MUL_SMALL_DATA, \
			__in_b_sliced_small.data_``slice_num_b));

	`MAKE_CURR_PROD(0, 0)
	`MAKE_CURR_PROD(1, 0)
	`MAKE_CURR_PROD(2, 0)
	`MAKE_CURR_PROD(3, 0)
	`MAKE_CURR_PROD(0, 1)
	`MAKE_CURR_PROD(1, 1)
	`MAKE_CURR_PROD(2, 1)
	`MAKE_CURR_PROD(0, 2)
	`MAKE_CURR_PROD(1, 2)
	`MAKE_CURR_PROD(0, 3)

	// Set of 16x16to32 multiplies for second 32x32to32 multiply
	`MAKE_CURR_PROD(3, 2)
	`MAKE_CURR_PROD(2, 3)
	`MAKE_CURR_PROD(2, 2)

	`undef MAKE_CURR_PROD


	logic [`MSB_POS__SNOW64_SUB_MUL_MEDIUM_DATA:0]
		__captured_prod_0_0,
		__captured_prod_1_0,
		__captured_prod_2_0,
		__captured_prod_3_0,
		__captured_prod_0_1,
		__captured_prod_1_1,
		__captured_prod_2_1,
		__captured_prod_0_2,
		__captured_prod_1_2,
		__captured_prod_0_3,

		__captured_prod_3_2,
		__captured_prod_2_3,
		__captured_prod_2_2;

	logic [`MSB_POS__SNOW64_SUB_MUL_LARGE_DATA:0]
		__temp_large_add_result_0, __temp_large_add_result_1,
		__temp_large_add_result_2;

	`ifdef FORMAL
	localparam __ENUM__STATE__IDLE = StIdle;
	localparam __ENUM__STATE__MUL_MEDIUM_ADDS = StMulMediumAdds;

	localparam __ENUM__STATE__MUL_LARGE_ADDS_0 = StMulLargeAdds_0;
	localparam __ENUM__STATE__MUL_LARGE_ADDS_1 = StMulLargeAdds_1;
	localparam __ENUM__STATE__MUL_LARGE_ADDS_2 = StMulLargeAdds_2;
	localparam __ENUM__STATE__MUL_LARGE_ADDS_3 = StMulLargeAdds_3;
	localparam __ENUM__STATE__BAD_0 = StBad0;
	localparam __ENUM__STATE__BAD_1 = StBad1;

	wire __formal__in_enable = in.enable;
	wire __formal__in_do_large = in.do_large;
	wire [`MSB_POS__SNOW64_SUB_MUL_LARGE_DATA:0]
		__formal__in_a = in.a, __formal__in_b = in.b;
	wire __formal__out_can_accept_cmd = out.can_accept_cmd,
		__formal__out_valid = out.valid;
	wire [`MSB_POS__SNOW64_SUB_MUL_MEDIUM_DATA:0]
		__formal__out_data_1 = out.data_1,
		__formal__out_data_0 = out.data_0;
	wire [`MSB_POS__SNOW64_SUB_MUL_LARGE_DATA:0]
		__formal__out_whole_data = `OUT_DATA;

	wire [`MSB_POS__SNOW64_SUB_MUL_SMALL_DATA:0]
		__formal__in_a_sliced_small__data_0 = __in_a_sliced_small.data_0,
		__formal__in_a_sliced_small__data_1 = __in_a_sliced_small.data_1,
		__formal__in_a_sliced_small__data_2 = __in_a_sliced_small.data_2,
		__formal__in_a_sliced_small__data_3 = __in_a_sliced_small.data_3,
		__formal__in_b_sliced_small__data_0 = __in_b_sliced_small.data_0,
		__formal__in_b_sliced_small__data_1 = __in_b_sliced_small.data_1,
		__formal__in_b_sliced_small__data_2 = __in_b_sliced_small.data_2,
		__formal__in_b_sliced_small__data_3 = __in_b_sliced_small.data_3;
	`endif		// FORMAL

	initial
	begin
		__state = StIdle;
		out.valid = 0;
		`OUT_DATA = 0;

		{__captured_prod_0_0,
			__captured_prod_1_0,
			__captured_prod_2_0,
			__captured_prod_3_0,
			__captured_prod_0_1,
			__captured_prod_1_1,
			__captured_prod_2_1,
			__captured_prod_0_2,
			__captured_prod_1_2,
			__captured_prod_0_3,

			__captured_prod_3_2,
			__captured_prod_2_3,
			__captured_prod_2_2} = 0;
	end


	always @(*)
	begin
		out.can_accept_cmd = (__state == StIdle);
	end


	always_ff @(posedge clk)
	begin
		case (__state)
		StIdle:
		begin
			if (in.enable)
			begin
				out.valid <= 0;

				case (in.do_large)
				0:
				begin
					__state <= StMulMediumAdds;

					__captured_prod_1_0 <= __curr_prod_1_0;
					__captured_prod_0_1 <= __curr_prod_0_1;
					__captured_prod_0_0 <= __curr_prod_0_0;

					__captured_prod_3_2 <= __curr_prod_3_2;
					__captured_prod_2_3 <= __curr_prod_2_3;
					__captured_prod_2_2 <= __curr_prod_2_2;

					out.data_0 <= __curr_prod_0_0;
					out.data_1 <= __curr_prod_2_2;
				end

				1:
				begin
					__state <= StMulLargeAdds_0;

					__captured_prod_0_0 <= __curr_prod_0_0;
					__captured_prod_1_0 <= __curr_prod_1_0;
					__captured_prod_2_0 <= __curr_prod_2_0;
					__captured_prod_3_0 <= __curr_prod_3_0;
					__captured_prod_0_1 <= __curr_prod_0_1;
					__captured_prod_1_1 <= __curr_prod_1_1;
					__captured_prod_2_1 <= __curr_prod_2_1;
					__captured_prod_0_2 <= __curr_prod_0_2;
					__captured_prod_1_2 <= __curr_prod_1_2;
					__captured_prod_0_3 <= __curr_prod_0_3;

					`OUT_DATA <= __curr_prod_0_0;
				end
				endcase
			end

			else // if (!in.enable)
			begin
				out.valid <= 0;
			end
		end

		StMulMediumAdds:
		begin
			__state <= StIdle;
			out.valid <= 1;

			out.data_0 <= out.data_0
				+ {(__captured_prod_1_0 + __captured_prod_0_1),
				{__WIDTH__MUL_MEDIUM_LEFT_SHIFT{1'b0}}};
			out.data_1 <= out.data_1
				+ {(__captured_prod_3_2 + __captured_prod_2_3),
				{__WIDTH__MUL_MEDIUM_LEFT_SHIFT{1'b0}}};
		end


		StMulLargeAdds_0:
		begin
			__state <= StMulLargeAdds_1;


			__temp_large_add_result_0
				<= ((__captured_prod_1_0 + __captured_prod_0_1)
				<< __WIDTH__MUL_LARGE_LEFT_SHIFT_0);
			//__temp_large_add_result_1
			//	<= ((__captured_prod_2_0 + __captured_prod_1_1
			//	+ __captured_prod_0_2)
			//	<< __WIDTH__MUL_LARGE_LEFT_SHIFT_1);
			//__temp_large_add_result_2
			//	<= ((__captured_prod_3_0 + __captured_prod_2_1
			//	+ __captured_prod_1_2 + __captured_prod_0_3)
			//	<< __WIDTH__MUL_LARGE_LEFT_SHIFT_2);

			__temp_large_add_result_1
				<= ((__captured_prod_2_0 + __captured_prod_1_1)
				<< __WIDTH__MUL_LARGE_LEFT_SHIFT_1);
			__temp_large_add_result_2
				<= ((__captured_prod_3_0 + __captured_prod_2_1)
				<< __WIDTH__MUL_LARGE_LEFT_SHIFT_2);
		end

		StMulLargeAdds_1:
		begin
			__state <= StMulLargeAdds_2;

			__temp_large_add_result_1 <= __temp_large_add_result_1
				+ (__captured_prod_0_2
				<< __WIDTH__MUL_LARGE_LEFT_SHIFT_1);
			__temp_large_add_result_2 <= __temp_large_add_result_2
				+ (__captured_prod_1_2
				<< __WIDTH__MUL_LARGE_LEFT_SHIFT_2);


			`OUT_DATA <= `OUT_DATA + __temp_large_add_result_0;
		end

		StMulLargeAdds_2:
		begin
			__state <= StMulLargeAdds_3;
			__temp_large_add_result_2 <= __temp_large_add_result_2
				+ (__captured_prod_0_3
				<< __WIDTH__MUL_LARGE_LEFT_SHIFT_2);
			`OUT_DATA <= `OUT_DATA + __temp_large_add_result_1;
		end

		StMulLargeAdds_3:
		begin
			out.valid <= 1;
			__state <= StIdle;
			`OUT_DATA <= `OUT_DATA + __temp_large_add_result_2;
		end

		endcase
	end

endmodule

module Snow64Mul(input logic clk,
	input PkgSnow64ArithLog::PortIn_Mul in,
	output PkgSnow64ArithLog::PortOut_Mul out);

	enum logic
	{
		StIdle,
		StWaitForSubMul
	} __state;

	localparam __WIDTH__MUL_TINY_DATA
		= `WIDTH__SNOW64_SUB_MUL_SMALL_DATA >> 1;
	localparam __MSB_POS__MUL_TINY_DATA
		= `WIDTH2MP(__WIDTH__MUL_TINY_DATA);

	PkgSnow64ArithLog::PortIn_SubMul __in_sub_mul;
	PkgSnow64ArithLog::PortOut_Mul __out_sub_mul;
	__Snow64SubMul __inst_sub_mul(.clk(clk), .in(__in_sub_mul),
		.out(__out_sub_mul));

	`ifdef FORMAL_TINY_MUL
	PkgSnow64SlicedData::FormalSlicedData1
	`else		// if !defined(FORMAL_TINY_MUL)
	PkgSnow64SlicedData::SlicedData8
	`endif		// FORMAL_TINY_MUL
		__in_a_sliced_mini, __in_b_sliced_mini, __out_mul_mini;

	assign {__in_a_sliced_mini, __in_b_sliced_mini} = {in.a, in.b};
	assign __out_mul_mini.data_7
		= __in_a_sliced_mini.data_7 * __in_b_sliced_mini.data_7;
	assign __out_mul_mini.data_6
		= __in_a_sliced_mini.data_6 * __in_b_sliced_mini.data_6;
	assign __out_mul_mini.data_5
		= __in_a_sliced_mini.data_5 * __in_b_sliced_mini.data_5;
	assign __out_mul_mini.data_4
		= __in_a_sliced_mini.data_4 * __in_b_sliced_mini.data_4;
	assign __out_mul_mini.data_3
		= __in_a_sliced_mini.data_3 * __in_b_sliced_mini.data_3;
	assign __out_mul_mini.data_2
		= __in_a_sliced_mini.data_2 * __in_b_sliced_mini.data_2;
	assign __out_mul_mini.data_1
		= __in_a_sliced_mini.data_1 * __in_b_sliced_mini.data_1;
	assign __out_mul_mini.data_0
		= __in_a_sliced_mini.data_0 * __in_b_sliced_mini.data_0;

	`ifdef FORMAL_TINY_MUL
	PkgSnow64SlicedData::FormalSlicedData2
	`else		// if !defined(FORMAL_TINY_MUL)
	PkgSnow64SlicedData::SlicedData16
	`endif		// FORMAL_TINY_MUL
		__in_a_sliced_small, __in_b_sliced_small, __out_mul_small;

	assign {__in_a_sliced_small, __in_b_sliced_small} = {in.a, in.b};


	assign __out_mul_small.data_3
		= __in_a_sliced_small.data_3 * __in_b_sliced_small.data_3;
	assign __out_mul_small.data_2
		= __in_a_sliced_small.data_2 * __in_b_sliced_small.data_2;
	assign __out_mul_small.data_1
		= __in_a_sliced_small.data_1 * __in_b_sliced_small.data_1;
	assign __out_mul_small.data_0
		= __in_a_sliced_small.data_0 * __in_b_sliced_small.data_0;



	`ifdef FORMAL
	localparam __ENUM__STATE__IDLE = StIdle;
	localparam __ENUM__STATE__WAIT_FOR_SUB_MUL = StWaitForSubMul;

	localparam __ENUM__INT_TYPE_SIZE__TINY = PkgSnow64Cpu::IntTypSz8;
	localparam __ENUM__INT_TYPE_SIZE__SMALL = PkgSnow64Cpu::IntTypSz16;
	localparam __ENUM__INT_TYPE_SIZE__MEDIUM = PkgSnow64Cpu::IntTypSz32;
	localparam __ENUM__INT_TYPE_SIZE__LARGE = PkgSnow64Cpu::IntTypSz64;
	localparam __WIDTH__INT_TYPE_SIZE = `WIDTH__SNOW64_CPU_INT_TYPE_SIZE;
	localparam __MSB_POS__INT_TYPE_SIZE
		= `WIDTH2MP(__WIDTH__INT_TYPE_SIZE);

	wire __formal__in_enable = in.enable;
	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__formal__in_int_type_size = in.int_type_size;
	wire [`MSB_POS__SNOW64_MUL_DATA_IN:0]
		__formal__in_a = in.a, __formal__in_b = in.b;

	wire __formal__in_sub_mul__enable = __in_sub_mul.enable;
	wire __formal__in_sub_mul__do_large = __in_sub_mul.do_large;
	wire [`MSB_POS__SNOW64_MUL_DATA_IN:0]
		__formal__in_sub_mul__a = __in_sub_mul.a,
		__formal__in_sub_mul__b = __in_sub_mul.b;


	wire __formal__out_can_accept_cmd = out.can_accept_cmd,
		__formal__out_valid = out.valid;
	wire [`MSB_POS__SNOW64_SUB_MUL_MEDIUM_DATA:0]
		__formal__out_data_1 = out.data_1,
		__formal__out_data_0 = out.data_0;
	wire [`MSB_POS__SNOW64_SUB_MUL_LARGE_DATA:0]
		__formal__out_whole_data = `OUT_DATA;

	wire __formal__out_sub_mul__can_accept_cmd
		= __out_sub_mul.can_accept_cmd,
		__formal__out_sub_mul__valid = __out_sub_mul.valid;
	wire [`MSB_POS__SNOW64_MUL_DATA_OUT:0]
		__formal__out_sub_mul__data_1 = __out_sub_mul.data_1,
		__formal__out_sub_mul__data_0 = __out_sub_mul.data_0;
	`endif		// FORMAL

	initial
	begin
		__state = StIdle;
	end



	always @(*) __in_sub_mul.enable = ((in.enable) && (__state == StIdle)
			&& (in.int_type_size >= PkgSnow64Cpu::IntTypSz32));
	always @(*) __in_sub_mul.do_large = (in.int_type_size
		== PkgSnow64Cpu::IntTypSz64);
	always @(*) __in_sub_mul.a = in.a;
	always @(*) __in_sub_mul.b = in.b;

	always @(*) out.can_accept_cmd = (__state == StIdle);

	always_ff @(posedge clk)
	begin
		case (__state)
		StIdle:
		begin
			if (in.enable)
			begin
				case (in.int_type_size)
				PkgSnow64Cpu::IntTypSz8:
				begin
					`OUT_DATA <= __out_mul_mini;
					out.valid <= 1;
				end

				PkgSnow64Cpu::IntTypSz16:
				begin
					`OUT_DATA <= __out_mul_small;
					out.valid <= 1;
				end

				default:
				begin
					__state <= StWaitForSubMul;
					out.valid <= 0;
				end
				endcase
			end
			else // if (!in.enable)
			begin
				out.valid <= 0;
			end
		end

		StWaitForSubMul:
		begin
			if (__out_sub_mul.valid)
			begin
				__state <= StIdle;
				out.valid <= 1;
				out.data_1 <= __out_sub_mul.data_1;
				out.data_0 <= __out_sub_mul.data_0;
			end
		end
		endcase
	end


endmodule

`undef OUT_DATA

// Compute one quotient bit per cycle.
module Snow64NonRestoringDivider #(parameter WIDTH__ARGS=64)
	(input logic clk, in_enable, in_signedness,
	// Numerator, Denominator
	input logic [`WIDTH2MP(WIDTH__ARGS):0] in_num, in_denom,

	// Quotient, Remainder
	output logic [`WIDTH2MP(WIDTH__ARGS):0] out_quot, out_rem,

	output logic out_can_accept_cmd, out_data_ready);

	localparam __MSB_POS__ARGS = `WIDTH2MP(WIDTH__ARGS);


	localparam __WIDTH__TEMP = (WIDTH__ARGS << 1) + 1;

	localparam __MSB_POS__TEMP = `WIDTH2MP(__WIDTH__TEMP);


	// This assumes you aren't trying to do division of numbers larger than
	// 128-logic.
	localparam __MSB_POS__COUNTER = 7;




	logic [__MSB_POS__COUNTER:0] __counter, __state_counter;

	logic [__MSB_POS__ARGS:0] __num_buf, __denom_buf;
	logic [__MSB_POS__ARGS:0] __quot_buf, __rem_buf;
	logic [__MSB_POS__ARGS:0] __quot_buf_2, __rem_buf_2;

	`ifdef FORMAL
	logic __captured_in_signedness, __debug_captured_in_signedness;
	logic [__MSB_POS__ARGS:0] __captured_in_num, __captured_in_denom,
		__debug_captured_in_num, __debug_captured_in_denom;
	`endif		// FORMAL


	wire __busy = !out_can_accept_cmd;
	//wire __num_is_negative, __denom_is_negative;
	logic __num_was_negative, __denom_was_negative;
	logic __signedness_buf;

	logic __start_state, __end_state;



	// Temporaries
	logic [__MSB_POS__TEMP:0] __P;
	logic [__MSB_POS__TEMP:0] __D;



	// Tasks
	task iterate;
		input [__MSB_POS__COUNTER:0] i;

		// if (__P >= 0)
		if (!__P[__MSB_POS__TEMP] || (__P == 0))
		begin
			//__quot_buf[__counter] = 1;
			__quot_buf[i] = 1;
			__P = (__P << 1) - __D;
		end

		else
		begin
			////__quot_buf[__counter] = 0;
			//__quot_buf[i] = 0;
			__P = (__P << 1) + __D;
		end

		//__counter = __counter - 1;
	endtask





	initial
	begin
		__counter = 0;
		__state_counter = 0;
		__P = 0;
		__D = 0;

		__state_counter = 0;

		__start_state = 1;
		__end_state = 1;

		out_quot = 0;
		out_rem = 0;

		out_can_accept_cmd = 1;
		out_data_ready = 0;
	end


	`ifdef FORMAL
	always @(posedge clk)
	begin
		__debug_captured_in_signedness <= __captured_in_signedness;
		__debug_captured_in_num <= __captured_in_num;
		__debug_captured_in_denom <= __captured_in_denom;
	end
	`endif		// FORMAL

	always @(posedge clk)
	begin
		if (__state_counter[__MSB_POS__COUNTER])
		begin
			__quot_buf = 0;
			__rem_buf = 0;

			__counter = __MSB_POS__ARGS;


			__P = __num_buf;
			__D = __denom_buf << WIDTH__ARGS;
		end

		else if (__busy)
		begin
			iterate(__counter);
			__counter = __counter - 1;
		end

	end


	always @(posedge clk)
	begin
		if (in_enable && out_can_accept_cmd)
		begin
			out_can_accept_cmd <= 0;
			out_data_ready <= 0;
			__state_counter <= -1;

			__num_buf <= in_num;
			__denom_buf <= in_denom;

			`ifdef FORMAL
			__captured_in_signedness <= in_signedness;
			__captured_in_num <= in_num;
			__captured_in_denom <= in_denom;
			`endif		// FORMAL


			//__num_buf <= (in_signedness && __num_is_negative)
			//	? (-in_num) : in_num;
			//__denom_buf <= (in_signedness && __denom_is_negative)
			//	? (-in_denom) : in_denom;

			__signedness_buf <= in_signedness;

			//__num_was_negative <= __num_is_negative;
			//__denom_was_negative <= __denom_is_negative;
			__num_was_negative <= in_num[__MSB_POS__ARGS];
			__denom_was_negative <= in_denom[__MSB_POS__ARGS];

			__start_state <= 0;
			__end_state <= 0;
		end

		else if (__start_state == 0)
		begin
			__start_state <= 1;

			__num_buf <= (__signedness_buf && __num_was_negative)
				? (-__num_buf) : __num_buf;
			__denom_buf <= (__signedness_buf && __denom_was_negative)
				? (-__denom_buf) : __denom_buf;
		end

		else if (__busy)
		begin
			if (!__counter[__MSB_POS__COUNTER])
			begin
				__state_counter <= __state_counter + 1;
				__end_state <= 0;
			end

			else if (__end_state == 0)
			begin
				__end_state <= 1;

				if (__P[__MSB_POS__TEMP])
				begin
					__quot_buf_2 <= (__signedness_buf 
						&& (__num_was_negative  ^ __denom_was_negative))
						?  (-((__quot_buf - (~__quot_buf)) - 1))
						: ((__quot_buf - (~__quot_buf)) - 1);
					__rem_buf_2
						<= (__signedness_buf && __num_was_negative)
						? (-((__P + __D) >> WIDTH__ARGS))
						: ((__P + __D) >> WIDTH__ARGS);
				end

				else
				begin
					__quot_buf_2 <= (__signedness_buf
						&& (__num_was_negative ^ __denom_was_negative))
						? (-((__quot_buf - (~__quot_buf))))
						: ((__quot_buf - (~__quot_buf)));
					__rem_buf_2 
						<= (__signedness_buf && __num_was_negative)
						? (-((__P) >> WIDTH__ARGS))
						: ((__P) >> WIDTH__ARGS);
				end
				
			end

			else // if (__end_state == 1)
			begin
				out_can_accept_cmd <= 1;
				__state_counter <= -1;
				out_data_ready <= 1;

				////$display("end:  %d, %d %d, %d",
				////	__signedness_buf, 
				////	__num_was_negative, __denom_was_negative,
				////	(__num_was_negative ^ __denom_was_negative));
				//if (__P[__MSB_POS__TEMP])
				//begin
				//	out_quot <= (__signedness_buf 
				//		&& (__num_was_negative  ^ __denom_was_negative))
				//		?  (-((__quot_buf - (~__quot_buf)) - 1))
				//		: ((__quot_buf - (~__quot_buf)) - 1);
				//	out_rem <= (__signedness_buf && __num_was_negative)
				//		? (-((__P + __D) >> WIDTH__ARGS))
				//		: ((__P + __D) >> WIDTH__ARGS);
				//end

				//else
				//begin
				//	out_quot <= (__signedness_buf
				//		&& (__num_was_negative ^ __denom_was_negative))
				//		? (-((__quot_buf - (~__quot_buf))))
				//		: ((__quot_buf - (~__quot_buf)));
				//	out_rem <= (__signedness_buf && __num_was_negative)
				//		? (-((__P) >> WIDTH__ARGS))
				//		: ((__P) >> WIDTH__ARGS);
				//end
				out_quot <= __quot_buf_2;
				out_rem <= __rem_buf_2;
			end
		end

		//else
		//begin
		//	$display("out_quot, out_rem:  %h, %h", out_quot, out_rem);
		//end
	end


endmodule

module Snow64VectorMul(input logic clk,
	input PkgSnow64ArithLog::PortIn_VectorMul in,
	output PkgSnow64ArithLog::PortOut_VectorMul out);

	enum logic
	{
		StIdle,
		StWaitForSubmodule
	} __state;

	logic __real_out_valid;
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __real_out_data;

	PkgSnow64ArithLog::PortIn_Mul __in_inst_mul_0, __in_inst_mul_1,
		__in_inst_mul_2, __in_inst_mul_3;
	PkgSnow64ArithLog::PortOut_Mul __out_inst_mul_0, __out_inst_mul_1,
		__out_inst_mul_2, __out_inst_mul_3;

	Snow64Mul __inst_mul_0(.clk(clk), .in(__in_inst_mul_0),
		.out(__out_inst_mul_0));
	Snow64Mul __inst_mul_1(.clk(clk), .in(__in_inst_mul_1),
		.out(__out_inst_mul_1));
	Snow64Mul __inst_mul_2(.clk(clk), .in(__in_inst_mul_2),
		.out(__out_inst_mul_2));
	Snow64Mul __inst_mul_3(.clk(clk), .in(__in_inst_mul_3),
		.out(__out_inst_mul_3));


	assign out.valid = __real_out_valid;
	assign out.data = __real_out_data;

	initial
	begin
		__state = StIdle;
		__real_out_valid = 0;
		__real_out_data = 0;

		__in_inst_mul_0 = 0;
		__in_inst_mul_1 = 0;
		__in_inst_mul_2 = 0;
		__in_inst_mul_3 = 0;
	end

	always_ff @(posedge clk)
	begin
		case (__state)
		StIdle:
		begin
			__real_out_valid <= 0;

			if (in.enable)
			begin
				__state <= StWaitForSubmodule;

				__in_inst_mul_0.enable <= 1;
				__in_inst_mul_1.enable <= 1;
				__in_inst_mul_2.enable <= 1;
				__in_inst_mul_3.enable <= 1;

				__in_inst_mul_0.int_type_size <= in.int_type_size;
				__in_inst_mul_1.int_type_size <= in.int_type_size;
				__in_inst_mul_2.int_type_size <= in.int_type_size;
				__in_inst_mul_3.int_type_size <= in.int_type_size;

				__in_inst_mul_0.a <= in.a[0 * 64 +: 64];
				__in_inst_mul_1.a <= in.a[1 * 64 +: 64];
				__in_inst_mul_2.a <= in.a[2 * 64 +: 64];
				__in_inst_mul_3.a <= in.a[3 * 64 +: 64];

				__in_inst_mul_0.b <= in.b[0 * 64 +: 64];
				__in_inst_mul_1.b <= in.b[1 * 64 +: 64];
				__in_inst_mul_2.b <= in.b[2 * 64 +: 64];
				__in_inst_mul_3.b <= in.b[3 * 64 +: 64];
			end
		end

		StWaitForSubmodule:
		begin
			__in_inst_mul_0.enable <= 0;
			__in_inst_mul_1.enable <= 0;
			__in_inst_mul_2.enable <= 0;
			__in_inst_mul_3.enable <= 0;

			if (__out_inst_mul_0.valid)
			begin
				__state <= StIdle;

				__real_out_valid <= 1;

				__real_out_data[0 * 64 +: 64]
					<= {__out_inst_mul_0.data_1, __out_inst_mul_0.data_0};
				__real_out_data[1 * 64 +: 64]
					<= {__out_inst_mul_1.data_1, __out_inst_mul_1.data_0};
				__real_out_data[2 * 64 +: 64]
					<= {__out_inst_mul_2.data_1, __out_inst_mul_2.data_0};
				__real_out_data[3 * 64 +: 64]
					<= {__out_inst_mul_3.data_1, __out_inst_mul_3.data_0};
			end
		end
		endcase
	end

endmodule


module Snow64VectorDiv(input logic clk,
	input PkgSnow64ArithLog::PortIn_VectorDiv in,
	output PkgSnow64ArithLog::PortOut_VectorDiv out);

	enum logic
	{
		StIdle,
		StWaitForSubDiv
	} __state;

	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__captured_in_int_type_size;
	logic __real_out_valid;
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __real_out_data;

	`define IN_INST_SUB_DIV(width, inst_num) \
		__in_inst_sub_div_``width``_``inst_num
	`define OUT_INST_SUB_DIV__QUOT(width, inst_num) \
		__out_inst_sub_div_``width``_``inst_num``__quot
	`define OUT_INST_SUB_DIV__REM(width, inst_num) \
		__out_inst_sub_div_``width``_``inst_num``__rem
	`define OUT_INST_SUB_DIV__CAN_ACCEPT_CMD(width, inst_num) \
		__out_inst_sub_div_``width``_``inst_num``__can_accept_cmd
	`define OUT_INST_SUB_DIV__DATA_READY(width, inst_num) \
		__out_inst_sub_div_``width``_``inst_num``__data_ready
	`define MAKE_INST_SUB_DIV(width, inst_num) \
		Snow64NonRestoringDivider #(.WIDTH__ARGS(width)) \
			__inst_sub_div_``width``_``inst_num(.clk(clk), \
			.in_enable(`IN_INST_SUB_DIV(width, inst_num).enable), \
			.in_signedness(`IN_INST_SUB_DIV(width, inst_num) \
			.type_signedness), \
			.in_num(`IN_INST_SUB_DIV(width, inst_num).num), \
			.in_denom(`IN_INST_SUB_DIV(width, inst_num).denom), \
			.out_quot(`OUT_INST_SUB_DIV__QUOT(width, inst_num)), \
			.out_rem(`OUT_INST_SUB_DIV__REM(width, inst_num)), \
			.out_can_accept_cmd \
			(`OUT_INST_SUB_DIV__CAN_ACCEPT_CMD(width, inst_num)), \
			.out_data_ready(`OUT_INST_SUB_DIV__DATA_READY(width, \
			inst_num)));

	`define OPERATE_ON_SUB_DIV_64 \
		`X(0) `X(1) `X(2) `X(3)
	`define OPERATE_ON_SUB_DIV_32 \
		`X(0) `X(1) `X(2) `X(3) \
		`X(4) `X(5) `X(6) `X(7)
	`define OPERATE_ON_SUB_DIV_16 \
		`X(0) `X(1) `X(2) `X(3) \
		`X(4) `X(5) `X(6) `X(7) \
		`X(8) `X(9) `X(10) `X(11) \
		`X(12) `X(13) `X(14) `X(15)
	`define OPERATE_ON_SUB_DIV_8 \
		`X(0) `X(1) `X(2) `X(3) \
		`X(4) `X(5) `X(6) `X(7) \
		`X(8) `X(9) `X(10) `X(11) \
		`X(12) `X(13) `X(14) `X(15) \
		`X(16) `X(17) `X(18) `X(19) \
		`X(20) `X(21) `X(22) `X(23) \
		`X(24) `X(25) `X(26) `X(27) \
		`X(28) `X(29) `X(30) `X(31)

	struct packed
	{
		logic enable, type_signedness;
		logic [`MSB_POS__SNOW64_SIZE_64:0] num, denom;
	} __in_inst_sub_div_64_0, __in_inst_sub_div_64_1,
		__in_inst_sub_div_64_2, __in_inst_sub_div_64_3;

	`define X(inst_num) \
	logic [`MSB_POS__SNOW64_SIZE_64:0] \
		`OUT_INST_SUB_DIV__QUOT(64, inst_num), \
		`OUT_INST_SUB_DIV__REM(64, inst_num); \
	logic `OUT_INST_SUB_DIV__CAN_ACCEPT_CMD(64, inst_num), \
		`OUT_INST_SUB_DIV__DATA_READY(64, inst_num);
	`OPERATE_ON_SUB_DIV_64
	`undef X


	//Snow64NonRestoringDivider

	`define MAKE_SUB_DIV_PORTS(width, inst_num) \
	struct packed \
	{ \
		logic enable, type_signedness; \
		logic [`WIDTH2MP(width):0] num, denom; \
	} `IN_INST_SUB_DIV(width, inst_num); \
	\
	logic [`WIDTH2MP(width):0] \
		`OUT_INST_SUB_DIV__QUOT(width, inst_num), \
		`OUT_INST_SUB_DIV__REM(width, inst_num); \
	logic `OUT_INST_SUB_DIV__CAN_ACCEPT_CMD(width, inst_num), \
		`OUT_INST_SUB_DIV__DATA_READY(width, inst_num);

	`define X(inst_num) `MAKE_SUB_DIV_PORTS(32, inst_num)
	`OPERATE_ON_SUB_DIV_32
	`undef X
	`define X(inst_num) `MAKE_SUB_DIV_PORTS(16, inst_num)
	`OPERATE_ON_SUB_DIV_16
	`undef X
	`define X(inst_num) `MAKE_SUB_DIV_PORTS(8, inst_num)
	`OPERATE_ON_SUB_DIV_8
	`undef X

	`undef MAKE_SUB_DIV_PORTS


	`define X(inst_num) `MAKE_INST_SUB_DIV(64, inst_num)
	`OPERATE_ON_SUB_DIV_64
	`undef X

	`define X(inst_num) `MAKE_INST_SUB_DIV(32, inst_num)
	`OPERATE_ON_SUB_DIV_32
	`undef X

	`define X(inst_num) `MAKE_INST_SUB_DIV(16, inst_num)
	`OPERATE_ON_SUB_DIV_16
	`undef X

	`define X(inst_num) `MAKE_INST_SUB_DIV(8, inst_num)
	`OPERATE_ON_SUB_DIV_8
	`undef X


	`undef MAKE_INST_SUB_DIV

	initial
	begin
		__state = StIdle;
		__captured_in_int_type_size = 0;
		__real_out_valid = 0;
		__real_out_data = 0;

		`define X(inst_num) `IN_INST_SUB_DIV(64, inst_num) = 0;
		`OPERATE_ON_SUB_DIV_64
		`undef X

		`define X(inst_num) `IN_INST_SUB_DIV(32, inst_num) = 0;
		`OPERATE_ON_SUB_DIV_32
		`undef X

		`define X(inst_num) `IN_INST_SUB_DIV(16, inst_num) = 0;
		`OPERATE_ON_SUB_DIV_16
		`undef X

		`define X(inst_num) `IN_INST_SUB_DIV(8, inst_num) = 0;
		`OPERATE_ON_SUB_DIV_8
		`undef X
	end

	assign out.valid = __real_out_valid;
	assign out.data = __real_out_data;

	always_ff @(posedge clk)
	begin
		case (__state)
		StIdle:
		begin
			__captured_in_int_type_size <= in.int_type_size;
			__real_out_valid <= 0;


			if (in.enable)
			begin
				__state <= StWaitForSubDiv;

				`define START_SUB_DIV(width, inst_num) \
					`IN_INST_SUB_DIV(width, inst_num).enable <= 1; \
					`IN_INST_SUB_DIV(width, inst_num).type_signedness \
						<= in.type_signedness; \
					`IN_INST_SUB_DIV(width, inst_num).num \
						<= in.a[inst_num * width +: width]; \
					`IN_INST_SUB_DIV(width, inst_num).denom \
						<= in.b[inst_num * width +: width];
				case (in.int_type_size)
				PkgSnow64Cpu::IntTypSz8:
				begin
					`define X(inst_num) `START_SUB_DIV(8, inst_num)
					`OPERATE_ON_SUB_DIV_8
					`undef X
				end

				PkgSnow64Cpu::IntTypSz16:
				begin
					`define X(inst_num) `START_SUB_DIV(16, inst_num)
					`OPERATE_ON_SUB_DIV_16
					`undef X
				end

				PkgSnow64Cpu::IntTypSz32:
				begin
					`define X(inst_num) `START_SUB_DIV(32, inst_num)
					`OPERATE_ON_SUB_DIV_32
					`undef X
				end

				PkgSnow64Cpu::IntTypSz64:
				begin
					`define X(inst_num) `START_SUB_DIV(64, inst_num)
					`OPERATE_ON_SUB_DIV_64
					`undef X
				end
				endcase

				`undef START_SUB_DIV
			end
		end

		StWaitForSubDiv:
		begin
			`define DISABLE_SUB_DIV(which, inst_num) \
				`IN_INST_SUB_DIV(which, inst_num).enable <= 0;

			`define X(inst_num) `DISABLE_SUB_DIV(64, inst_num)
			`OPERATE_ON_SUB_DIV_64
			`undef X
			`define X(inst_num) `DISABLE_SUB_DIV(32, inst_num)
			`OPERATE_ON_SUB_DIV_32
			`undef X
			`define X(inst_num) `DISABLE_SUB_DIV(16, inst_num)
			`OPERATE_ON_SUB_DIV_16
			`undef X
			`define X(inst_num) `DISABLE_SUB_DIV(8, inst_num)
			`OPERATE_ON_SUB_DIV_8
			`undef X
			`undef DISABLE_SUB_DIV


			case (__captured_in_int_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				if (`OUT_INST_SUB_DIV__DATA_READY(8, 0))
				begin
					__state <= StIdle;
					__real_out_valid <= 1;
					`define X(inst_num) \
						__real_out_data[inst_num * 8 +: 8] \
							<= `OUT_INST_SUB_DIV__QUOT(8, inst_num);
					`OPERATE_ON_SUB_DIV_8
					`undef X
				end
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				if (`OUT_INST_SUB_DIV__DATA_READY(16, 0))
				begin
					__state <= StIdle;
					__real_out_valid <= 1;
					`define X(inst_num) \
						__real_out_data[inst_num * 16 +: 16] \
							<= `OUT_INST_SUB_DIV__QUOT(16, inst_num);
					`OPERATE_ON_SUB_DIV_16
					`undef X
				end
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				if (`OUT_INST_SUB_DIV__DATA_READY(32, 0))
				begin
					__state <= StIdle;
					__real_out_valid <= 1;
					`define X(inst_num) \
						__real_out_data[inst_num * 32 +: 32] \
							<= `OUT_INST_SUB_DIV__QUOT(32, inst_num);
					`OPERATE_ON_SUB_DIV_32
					`undef X
				end
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				if (`OUT_INST_SUB_DIV__DATA_READY(64, 0))
				begin
					__state <= StIdle;
					__real_out_valid <= 1;
					`define X(inst_num) \
						__real_out_data[inst_num * 64 +: 64] \
							<= `OUT_INST_SUB_DIV__QUOT(64, inst_num);
					`OPERATE_ON_SUB_DIV_64
					`undef X
				end
			end
			endcase
		end
		endcase
	end




	`undef IN_INST_SUB_DIV
	`undef OUT_INST_SUB_DIV__QUOT
	`undef OUT_INST_SUB_DIV__REM
	`undef OUT_INST_SUB_DIV__CAN_ACCEPT_CMD
	`undef OUT_INST_SUB_DIV__DATA_READY
	`undef OPERATE_ON_SUB_DIV_64
	`undef OPERATE_ON_SUB_DIV_32
	`undef OPERATE_ON_SUB_DIV_16
	`undef OPERATE_ON_SUB_DIV_8

endmodule

//`define MAKE_TEST_DIV_MODULE_CONTENTS(some_width) \
//	(input logic clk, in_enable, in_signedness, \
//	input logic [`WIDTH2MP(some_width):0] in_num, in_denom, \
//\
//	output logic [`WIDTH2MP(some_width):0] out_quot, out_rem, \
//\
//	output logic out_can_accept_cmd, out_data_ready); \
//\
//\
//	parameter WIDTH__ARGS = some_width; \
//	Snow64NonRestoringDivider #(.WIDTH__ARGS(WIDTH__ARGS)) \
//		__inst_non_restoring_divider(.clk(clk), .in_enable(in_enable), \
//			.in_signedness(in_signedness), \
//			.in_num(in_num), .in_denom(in_denom), \
//			.out_quot(out_quot), .out_rem(out_rem), \
//			.out_can_accept_cmd(out_can_accept_cmd), \
//			.out_data_ready(out_data_ready));
//
//module TestDiv8
//`MAKE_TEST_DIV_MODULE_CONTENTS(8)
//endmodule
//
//module TestDiv16
//`MAKE_TEST_DIV_MODULE_CONTENTS(16)
//endmodule
//
//module TestDiv32
//`MAKE_TEST_DIV_MODULE_CONTENTS(32)
//endmodule
//
//module TestDiv64
//`MAKE_TEST_DIV_MODULE_CONTENTS(64)
//endmodule
//
//`undef MAKE_TEST_DIV_MODULE_CONTENTS
