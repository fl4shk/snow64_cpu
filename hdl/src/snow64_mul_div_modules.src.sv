`include "src/snow64_alu_defines.header.sv"

`define OUT_DATA {out.data_1, out.data_0}
module __Snow64SubMul(input logic clk,
	input PkgSnow64Alu::PortIn_SubMul in,
	output PkgSnow64Alu::PortOut_Mul out);


	localparam __WIDTH__STATE = 3;
	localparam __MSB_POS__STATE = `WIDTH2MP(__WIDTH__STATE);

	enum logic [__MSB_POS__STATE:0]
	{
		StIdle,
		StMul32Adds,

		StMul64Adds_0,

		StMul64Adds_1,
		StMul64Adds_2,
		StMul64Adds_3
	} __state;

	PkgSnow64SlicedData::SlicedData16 __in_a_sliced_16, __in_b_sliced_16;

	assign {__in_a_sliced_16, __in_b_sliced_16} = {in.a, in.b};

	`define MAKE_CURR_PROD(slice_num_a, slice_num_b) \
	wire [`MSB_POS__SNOW64_SIZE_32:0] \
		__curr_prod_``slice_num_a``_``slice_num_b \
			= (`ZERO_EXTEND(32, 16, __in_a_sliced_16.data_``slice_num_a) \
			* `ZERO_EXTEND(32, 16, __in_b_sliced_16.data_``slice_num_b));

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


	logic [`MSB_POS__SNOW64_SIZE_32:0]
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

	logic [`MSB_POS__SNOW64_SIZE_64:0]
		__temp_64_bit_add_result_0, __temp_64_bit_add_result_1,
		__temp_64_bit_add_result_2;

	`ifdef FORMAL
	localparam __ENUM__STATE__IDLE = StIdle;
	localparam __ENUM__STATE__MUL32_ADDS = StMul32Adds;

	localparam __ENUM__STATE__MUL64_ADDS_0 = StMul64Adds_0;
	localparam __ENUM__STATE__MUL64_ADDS_1 = StMul64Adds_1;
	localparam __ENUM__STATE__MUL64_ADDS_2 = StMul64Adds_2;
	localparam __ENUM__STATE__MUL64_ADDS_3 = StMul64Adds_3;

	wire __formal__in_enable = in.enable;
	wire __formal__in_do_64_bit = in.do_64_bit;
	wire [`MSB_POS__SNOW64_SIZE_64:0]
		__formal__in_a = in.a, __formal__in_b = in.b;
	wire __formal__out_can_accept_cmd = out.can_accept_cmd,
		__formal__out_valid = out.valid;
	wire [`MSB_POS__SNOW64_SIZE_32:0]
		__formal__out_data_1 = out.data_1,
		__formal__out_data_0 = out.data_0;

	`endif		// FORMAL

	initial
	begin
		__state = StIdle;
		out.valid = 0;
		`OUT_DATA = 0;

		__captured_prod_0_0 = 0;
		__captured_prod_1_0 = 0;
		__captured_prod_2_0 = 0;
		__captured_prod_3_0 = 0;
		__captured_prod_0_1 = 0;
		__captured_prod_1_1 = 0;
		__captured_prod_2_1 = 0;
		__captured_prod_0_2 = 0;
		__captured_prod_1_2 = 0;
		__captured_prod_0_3 = 0;

		__captured_prod_3_2 = 0;
		__captured_prod_2_3 = 0;
		__captured_prod_2_2 = 0;
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

				case (in.do_64_bit)
				0:
				begin
					__state <= StMul32Adds;

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
					__state <= StMul64Adds_0;

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

					__captured_prod_3_2 <= __curr_prod_3_2;
					__captured_prod_2_3 <= __curr_prod_2_3;
					__captured_prod_2_2 <= __curr_prod_2_2;

					`OUT_DATA <= __curr_prod_0_0;
				end
				endcase
			end

			else // if (!in.enable)
			begin
				out.valid <= 0;
			end
		end

		StMul32Adds:
		begin
			__state <= StIdle;
			out.valid <= 1;

			out.data_0 <= out.data_0
				+ {(__captured_prod_1_0 + __captured_prod_0_1), 16'h0};
			out.data_1 <= out.data_1
				+ {(__captured_prod_3_2 + __captured_prod_2_3), 16'h0};
		end


		StMul64Adds_0:
		begin
			__state <= StMul64Adds_1;

			__temp_64_bit_add_result_0
				<= {(__captured_prod_1_0 + __captured_prod_0_1), 16'h0};

			__temp_64_bit_add_result_1
				<= {(__captured_prod_2_0 + __captured_prod_1_1), 32'h0};

			__temp_64_bit_add_result_2
				<= {(__captured_prod_3_0 + __captured_prod_2_1), 48'h0};
		end

		StMul64Adds_1:
		begin
			__state <= StMul64Adds_2;

			__temp_64_bit_add_result_1 <= __temp_64_bit_add_result_1
				+ {__captured_prod_0_2, 32'h0};
			__temp_64_bit_add_result_2 <= __temp_64_bit_add_result_2
				+ {__captured_prod_1_2, 48'h0};

			`OUT_DATA <= `OUT_DATA + __temp_64_bit_add_result_0;
		end

		StMul64Adds_2:
		begin
			__temp_64_bit_add_result_2 <= __temp_64_bit_add_result_2
				+ {__captured_prod_0_3, 48'h0};
			`OUT_DATA <= `OUT_DATA + __temp_64_bit_add_result_1;
		end

		StMul64Adds_3:
		begin
			out.valid <= 1;
			__state <= StIdle;
			`OUT_DATA <= `OUT_DATA + __temp_64_bit_add_result_2;
		end

		endcase
	end

endmodule

module Snow64VectorMul(input logic clk,
	input PkgSnow64Alu::PortIn_VectorMul in,
	output PkgSnow64Alu::PortOut_Mul out);




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

		else
		begin
			$display("out_quot, out_rem:  %h, %h", out_quot, out_rem);
		end
	end


endmodule

`define MAKE_TEST_DIV_MODULE_CONTENTS(some_width) \
	(input logic clk, in_enable, in_signedness, \
	input logic [`WIDTH2MP(some_width):0] in_num, in_denom, \
\
	output logic [`WIDTH2MP(some_width):0] out_quot, out_rem, \
\
	output logic out_can_accept_cmd, out_data_ready); \
\
\
	parameter WIDTH__ARGS = some_width; \
	Snow64NonRestoringDivider #(.WIDTH__ARGS(WIDTH__ARGS)) \
		__inst_non_restoring_divider(.clk(clk), .in_enable(in_enable), \
			.in_signedness(in_signedness), \
			.in_num(in_num), .in_denom(in_denom), \
			.out_quot(out_quot), .out_rem(out_rem), \
			.out_can_accept_cmd(out_can_accept_cmd), \
			.out_data_ready(out_data_ready));

module TestDiv8
`MAKE_TEST_DIV_MODULE_CONTENTS(8)
endmodule

module TestDiv16
`MAKE_TEST_DIV_MODULE_CONTENTS(16)
endmodule

module TestDiv32
`MAKE_TEST_DIV_MODULE_CONTENTS(32)
endmodule

module TestDiv64
`MAKE_TEST_DIV_MODULE_CONTENTS(64)
endmodule

`undef MAKE_TEST_DIV_MODULE_CONTENTS
