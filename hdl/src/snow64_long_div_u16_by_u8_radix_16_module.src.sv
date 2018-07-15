`include "src/snow64_long_div_u16_by_u8_defines.header.sv"

module Snow64LongDivU16ByU8Radix16(input logic clk, in_start,
	input logic [`MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_IN_A:0] in_a,
	input logic [`MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_IN_B:0] in_b,
	output logic out_data_valid, out_can_accept_cmd,
	output logic [`MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_OUT_DATA:0]
		out_data);

	localparam __WIDTH__IN_A = `WIDTH__SNOW64_LONG_DIV_U16_BY_U8_IN_A;
	localparam __MSB_POS__IN_A = `MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_IN_A;

	localparam __WIDTH__IN_B = `WIDTH__SNOW64_LONG_DIV_U16_BY_U8_IN_B;
	localparam __MSB_POS__IN_B = `MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_IN_B;

	localparam __WIDTH__OUT_DATA
		= `WIDTH__SNOW64_LONG_DIV_U16_BY_U8_OUT_DATA;
	localparam __MSB_POS__OUT_DATA
		= `MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_OUT_DATA;

	localparam __WIDTH__MULT_ARR = 12;
	localparam __MSB_POS__MULT_ARR = `WIDTH2MP(__WIDTH__MULT_ARR);


	localparam __RADIX = 16;
	localparam __NUM_BITS_PER_ITERATION = 4;
	//localparam __STARTING_I_VALUE = `WIDTH2MP(__RADIX);
	localparam __STARTING_I_VALUE = `WIDTH2MP(__NUM_BITS_PER_ITERATION);
	//localparam __STARTING_I_VALUE = 3;

	localparam __WIDTH__TEMP = 16;
	localparam __MSB_POS__TEMP = `WIDTH2MP(__WIDTH__TEMP);

	localparam __WIDTH__ARR_INDEX = 4;
	localparam __MSB_POS__ARR_INDEX = `WIDTH2MP(__WIDTH__ARR_INDEX);

	//enum logic [1:0]
	//{
	//	StIdle,
	//	StStarting,
	//	StWorking
	//} __state;
	enum logic
	{
		StIdle,
		StWorking
	} __state;



	logic [__MSB_POS__MULT_ARR:0] __mult_arr
		[0 : `ARR_SIZE_TO_LAST_INDEX(__RADIX)];
	//logic [__MSB_POS__TEMP:0] __mult_arr[0 : __RADIX];

	logic [__MSB_POS__IN_A:0] __captured_a;
	//logic [__MSB_POS__IN_B:0] __captured_b;

	logic [__MSB_POS__TEMP:0] __current;

	//logic [__MSB_POS__ARR_INDEX:0] __i;
	logic [1:0] __i;
	logic [__MSB_POS__TEMP:0] __j;

	logic [__MSB_POS__ARR_INDEX:0] __search_result;
	//logic [__MSB_POS__ARR_INDEX:0]
	//	__search_result_0_1_2_3, __search_result_4_5_6_7,
	//	__search_result_8_9_10_11, __search_result_12_13_14_15;

	task iteration_end;
		input [__MSB_POS__ARR_INDEX:0] some_index;
		//case (__i[3:2])
		case (__i)
			2'd3:
			begin
				out_data[15:12] = some_index;
			end

			2'd2:
			begin
				out_data[11:8] = some_index;
			end

			2'd1:
			begin
				out_data[7:4] = some_index;
			end

			2'd0:
			begin
				out_data[3:0] = some_index;
			end
		endcase

		__current = __current - __mult_arr[some_index];
	endtask

	//assign out_ready = (__state == StIdle);

	initial
	begin
		__state = StIdle;
		out_data_valid = 0;
		out_can_accept_cmd = 1;
	end

	always_ff @(posedge clk)
	begin
		case (__state)
			StIdle:
			begin
				if (in_start)
				begin
					__state <= StWorking;

					__mult_arr[0] <= 0;

					if (in_b != 0)
					begin
						__captured_a <= in_a;
						//__captured_b <= in_b;

						//__mult_arr[0] <= in_b * 0;
						__mult_arr[1] <= in_b * 1;
						__mult_arr[2] <= in_b * 2;
						__mult_arr[3] <= in_b * 3;

						__mult_arr[4] <= in_b * 4;
						__mult_arr[5] <= in_b * 5;
						__mult_arr[6] <= in_b * 6;
						__mult_arr[7] <= in_b * 7;

						__mult_arr[8] <= in_b * 8;
						__mult_arr[9] <= in_b * 9;
						__mult_arr[10] <= in_b * 10;
						__mult_arr[11] <= in_b * 11;

						__mult_arr[12] <= in_b * 12;
						__mult_arr[13] <= in_b * 13;
						__mult_arr[14] <= in_b * 14;
						__mult_arr[15] <= in_b * 15;

					end

					else // if (in_b == 0)
					begin
						// Ensure "correct" results (return a zero when
						// in_b is zero)
						__captured_a <= 0;
						//__captured_b <= 1;

						//__mult_arr[0] <= 0;
						__mult_arr[1] <= 1;
						__mult_arr[2] <= 2;
						__mult_arr[3] <= 3;

						__mult_arr[4] <= 4;
						__mult_arr[5] <= 5;
						__mult_arr[6] <= 6;
						__mult_arr[7] <= 7;

						__mult_arr[8] <= 8;
						__mult_arr[9] <= 9;
						__mult_arr[10] <= 10;
						__mult_arr[11] <= 11;

						__mult_arr[12] <= 12;
						__mult_arr[13] <= 13;
						__mult_arr[14] <= 14;
						__mult_arr[15] <= 15;
					end

					__i <= __STARTING_I_VALUE;

					out_data_valid <= 0;
					out_can_accept_cmd <= 0;
				end
			end


			StWorking:
			begin
				//__i <= __i - __NUM_BITS_PER_ITERATION;
				__i <= __i - 1;

				// Last iteration means we should update __state
				//if (__i == __NUM_BITS_PER_ITERATION - 1)
				if (__i == 0)
				begin
					__state <= StIdle;
					out_data_valid <= 1;
					out_can_accept_cmd <= 1;
				end
			end
		endcase
	end

	always @(posedge clk)
	begin
		case (__state)
			StIdle:
			begin
				__current = 0;
				out_data = 0;
			end

			StWorking:
			begin
				//case (__i[3:2])
				case (__i)
					2'd3:
					begin
						__current = {__current[11:0], __captured_a[15:12]};
					end

					2'd2:
					begin
						__current = {__current[11:0], __captured_a[11:8]};
					end

					2'd1:
					begin
						__current = {__current[11:0], __captured_a[7:4]};
					end

					2'd0:
					begin
						__current = {__current[11:0], __captured_a[3:0]};
					end
				endcase

				// Binary search
				if (__mult_arr[8] > __current)
				begin
					if (__mult_arr[4] > __current)
					begin
						if (__mult_arr[2] > __current)
						begin
							// 0 or 1
							if (__mult_arr[1] > __current)
							begin
								__search_result = 0;
								//iteration_end(0);
								//__search_result_0_1_2_3 = 0;
							end
							else // if (__mult_arr[1] <= __current)
							begin
								__search_result = 1;
								//iteration_end(1);
								//__search_result_0_1_2_3 = 1;
							end
						end
						else // if (__mult_arr[2] <= __current)
						begin
							// 2 or 3
							if (__mult_arr[3] > __current)
							begin
								__search_result = 2;
								//iteration_end(2);
								//__search_result_0_1_2_3 = 2;
							end
							else // if (__mult_arr[3] <= __current)
							begin
								__search_result = 3;
								//iteration_end(3);
								//__search_result_0_1_2_3 = 3;
							end
						end

						//iteration_end(__search_result_0_1_2_3);
						iteration_end(__search_result);
					end
					else // if (__mult_arr[4] <= __current)
					begin
						if (__mult_arr[6] > __current)
						begin
							// 4 or 5
							if (__mult_arr[5] > __current)
							begin
								__search_result = 4;
								//iteration_end(4);
								//__search_result_4_5_6_7 = 4;
							end
							else // if (__mult_arr[5] <= __current)
							begin
								__search_result = 5;
								//iteration_end(5);
								//__search_result_4_5_6_7 = 5;
							end
						end
						else // if (__mult_arr[6] <= __current)
						begin
							// 6 or 7
							if (__mult_arr[7] > __current)
							begin
								__search_result = 6;
								//iteration_end(6);
								//__search_result_4_5_6_7 = 6;
							end
							else // if (__mult_arr[7] <= __current)
							begin
								__search_result = 7;
								//iteration_end(7);
								//__search_result_4_5_6_7 = 7;
							end
						end

						//iteration_end(__search_result_4_5_6_7);
						iteration_end(__search_result);
					end
				end
				else // if (__mult_arr[8] <= __current)
				begin
					if (__mult_arr[12] > __current)
					begin
						if (__mult_arr[10] > __current)
						begin
							// 8 or 9
							if (__mult_arr[9] > __current)
							begin
								__search_result = 8;
								//iteration_end(8);
								//__search_result_8_9_10_11 = 8;
							end
							else // if (__mult_arr[9] <= __current)
							begin
								__search_result = 9;
								//iteration_end(9);
								//__search_result_8_9_10_11 = 9;
							end
						end
						else // if (__mult_arr[10] <= __current)
						begin
							// 10 or 11
							if (__mult_arr[11] > __current)
							begin
								__search_result = 10;
								//iteration_end(10);
								//__search_result_8_9_10_11 = 10;
							end
							else // if (__mult_arr[11] <= __current)
							begin
								__search_result = 11;
								//iteration_end(11);
								//__search_result_8_9_10_11 = 11;
							end
						end

						//iteration_end(__search_result_8_9_10_11);
						iteration_end(__search_result);
					end
					else // if (__mult_arr[12] <= __current)
					begin
						if (__mult_arr[14] > __current)
						begin
							// 12 or 13
							if (__mult_arr[13] > __current)
							begin
								__search_result = 12;
								//iteration_end(12);
								//__search_result_12_13_14_15 = 12;
							end
							else // if (__mult_arr[13] <= __current)
							begin
								__search_result = 13;
								//iteration_end(13);
								//__search_result_12_13_14_15 = 13;
							end
						end
						else // if (__mult_arr[14] <= __current)
						begin
							// 14 or 15
							if (__mult_arr[15] > __current)
							begin
								__search_result = 14;
								//iteration_end(14);
								//__search_result_12_13_14_15 = 14;
							end
							else
							begin
								__search_result = 15;
								//iteration_end(15);
								//__search_result_12_13_14_15 = 15;
							end
						end

						//iteration_end(__search_result_12_13_14_15);
						iteration_end(__search_result);
					end
				end
				//iteration_end(__search_result);
			end

		endcase
	end

endmodule
