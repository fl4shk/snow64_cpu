`include "src/snow64_long_div_u16_by_u8_defines.header.sv"

module LongDivU16ByU8(input logic clk, in_start,
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
	localparam __STARTING_I_VALUE = `WIDTH2MP(__RADIX);

	localparam __WIDTH__TEMP = 16;
	localparam __MSB_POS__TEMP = `WIDTH2MP(__WIDTH__TEMP);

	localparam __WIDTH__INDEX = 2;
	localparam __MSB_POS__INDEX = `WIDTH2MP(__WIDTH__IN_A);

	enum logic [1:0]
	{
		StIdle,
		StStarting,
		StWorking
	} __state;



	logic [__MSB_POS__MULT_ARR:0] __mult_arr
		[0 : `ARR_SIZE_TO_LAST_INDEX(__RADIX)];
	//logic [__MSB_POS__TEMP:0] __mult_arr[0 : __RADIX];

	logic [__MSB_POS__IN_A:0] __captured_a;
	logic [__MSB_POS__IN_B:0] __captured_b;

	logic [__MSB_POS__TEMP:0] __current;

	logic [__MSB_POS__INDEX:0] __i;
	logic [__MSB_POS__TEMP:0] __j;

	//logic [__MSB_POS__TEMP:0] __search_result;

	task iteration_end;
		input [__MSB_POS__INDEX:0] some_index;
		case (__i[3:2])
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
					__state <= StStarting;

					//$display("in_a, in_b:  %d, %d", in_a, in_b);
					if (in_b != 0)
					begin
						__captured_a <= in_a;
						__captured_b <= in_b;
					end

					else // if (in_b == 0)
					begin
						// Ensure "correct" results
						__captured_a <= 0;
						//__captured_b <= in_b;
						__captured_b <= 1;
					end
					out_data_valid <= 0;
					out_can_accept_cmd <= 0;
				end
			end

			StStarting:
			begin
				__state <= StWorking;

				__mult_arr[0] <= __captured_b * 0;
				__mult_arr[1] <= __captured_b * 1;
				__mult_arr[2] <= __captured_b * 2;
				__mult_arr[3] <= __captured_b * 3;

				__mult_arr[4] <= __captured_b * 4;
				__mult_arr[5] <= __captured_b * 5;
				__mult_arr[6] <= __captured_b * 6;
				__mult_arr[7] <= __captured_b * 7;

				__mult_arr[8] <= __captured_b * 8;
				__mult_arr[9] <= __captured_b * 9;
				__mult_arr[10] <= __captured_b * 10;
				__mult_arr[11] <= __captured_b * 11;

				__mult_arr[12] <= __captured_b * 12;
				__mult_arr[13] <= __captured_b * 13;
				__mult_arr[14] <= __captured_b * 14;
				__mult_arr[15] <= __captured_b * 15;

				__i <= __STARTING_I_VALUE;
			end

			StWorking:
			begin
				__i <= __i - __NUM_BITS_PER_ITERATION;

				// Last iteration means we should update __state
				if (__i == __NUM_BITS_PER_ITERATION - 1)
				begin
					__state <= StIdle;
					out_data_valid <= 1;
					out_can_accept_cmd <= 1;
				end
			end

			default:
			begin
				// Eek!
			end
		endcase
	end

	always @(posedge clk)
	begin
		case (__state)
			StStarting:
			begin
				__current = 0;
				out_data = 0;
				//__mult_arr[0] = __captured_b * 0;
				//__mult_arr[1] = __captured_b * 1;
				//__mult_arr[2] = __captured_b * 2;
				//__mult_arr[3] = __captured_b * 3;

				//__mult_arr[4] = __captured_b * 4;
				//__mult_arr[5] = __captured_b * 5;
				//__mult_arr[6] = __captured_b * 6;
				//__mult_arr[7] = __captured_b * 7;

				//__mult_arr[8] = __captured_b * 8;
				//__mult_arr[9] = __captured_b * 9;
				//__mult_arr[10] = __captured_b * 10;
				//__mult_arr[11] = __captured_b * 11;

				//__mult_arr[12] = __captured_b * 12;
				//__mult_arr[13] = __captured_b * 13;
				//__mult_arr[14] = __captured_b * 14;
				//__mult_arr[15] = __captured_b * 15;
			end

			StWorking:
			begin
				//$display("StWorking:  __i:  %d", __i);
				case (__i[3:2])
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

				//$display("__current, __captured_a:  %h, %h", __current,
				//	__captured_a);


				//__search_result = -1;

				//// A linear search... shouldn't this be replaced?
				//for (__j=1; __j<=__RADIX; __j=__j+1)
				//begin
				//	if (__mult_arr[__j] > __current)
				//	begin
				//		if (__search_result[__MSB_POS__TEMP])
				//		begin
				//			__search_result = __j - 1;
				//		end
				//	end
				//end

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
								//__search_result = 0;
								iteration_end(0);
							end
							else // if (__mult_arr[1] <= __current)
							begin
								//__search_result = 1;
								iteration_end(1);
							end
						end
						else // if (__mult_arr[2] <= __current)
						begin
							// 2 or 3
							if (__mult_arr[3] > __current)
							begin
								//__search_result = 2;
								iteration_end(2);
							end
							else // if (__mult_arr[3] <= __current)
							begin
								//__search_result = 3;
								iteration_end(3);
							end
						end
					end
					else // if (__mult_arr[4] <= __current)
					begin
						if (__mult_arr[6] > __current)
						begin
							// 4 or 5
							if (__mult_arr[5] > __current)
							begin
								//__search_result = 4;
								iteration_end(4);
							end
							else // if (__mult_arr[5] <= __current)
							begin
								//__search_result = 5;
								iteration_end(5);
							end
						end
						else // if (__mult_arr[6] <= __current)
						begin
							// 6 or 7
							if (__mult_arr[7] > __current)
							begin
								//__search_result = 6;
								iteration_end(6);
							end
							else // if (__mult_arr[7] <= __current)
							begin
								//__search_result = 7;
								iteration_end(7);
							end
						end
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
								//__search_result = 8;
								iteration_end(8);
							end
							else // if (__mult_arr[9] <= __current)
							begin
								//__search_result = 9;
								iteration_end(9);
							end
						end
						else // if (__mult_arr[10] <= __current)
						begin
							// 10 or 11
							if (__mult_arr[11] > __current)
							begin
								//__search_result = 10;
								iteration_end(10);
							end
							else // if (__mult_arr[11] <= __current)
							begin
								//__search_result = 11;
								iteration_end(11);
							end
						end
					end
					else // if (__mult_arr[12] <= __current)
					begin
						if (__mult_arr[14] > __current)
						begin
							// 12 or 13
							if (__mult_arr[13] > __current)
							begin
								//__search_result = 12;
								iteration_end(12);
							end
							else // if (__mult_arr[13] <= __current)
							begin
								//__search_result = 13;
								iteration_end(13);
							end
						end
						else // if (__mult_arr[14] <= __current)
						begin
							// 14 or 15
							if (__mult_arr[15] > __current)
							begin
								//__search_result = 14;
								iteration_end(14);
							end
							else
							begin
								//__search_result = 15;
								iteration_end(15);
								//__search_result = 14;
							end
						end
					end
				end
			end

			default:
			begin
				// Eek!
			end
		endcase
	end

endmodule
