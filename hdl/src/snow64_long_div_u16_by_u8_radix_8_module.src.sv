`include "src/snow64_long_div_u16_by_u8_defines.header.sv"

module Snow64LongDivU16ByU8Radix8(input logic clk, in_start,
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

	localparam __WIDTH__MULT_ARR = 11;
	localparam __MSB_POS__MULT_ARR = `WIDTH2MP(__WIDTH__MULT_ARR);


	localparam __RADIX = 8;
	localparam __NUM_BITS_PER_ITERATION = 3;
	localparam __STARTING_I_VALUE = 5;


	localparam __WIDTH__TEMP = 18;
	localparam __MSB_POS__TEMP = `WIDTH2MP(__WIDTH__TEMP);


	localparam __WIDTH__ARR_INDEX = 3;
	localparam __MSB_POS__ARR_INDEX = `WIDTH2MP(__WIDTH__ARR_INDEX);


	localparam __WIDTH__CAPTURED_A = 18;
	localparam __MSB_POS__CAPTURED_A = `WIDTH2MP(__WIDTH__CAPTURED_A);
	localparam __WIDTH__CAPTURED_B = __WIDTH__IN_B;
	localparam __MSB_POS__CAPTURED_B = `WIDTH2MP(__WIDTH__CAPTURED_B);

	localparam __WIDTH__ALMOST_OUT_DATA = __WIDTH__CAPTURED_A;
	localparam __MSB_POS__ALMOST_OUT_DATA = __WIDTH__ALMOST_OUT_DATA;


	enum logic
	{
		StIdle,
		StWorking
	} __state;



	logic [__MSB_POS__MULT_ARR:0] __mult_arr
		[0 : `ARR_SIZE_TO_LAST_INDEX(__RADIX)];
	//logic [__MSB_POS__TEMP:0] __mult_arr[0 : __RADIX];

	logic [__MSB_POS__CAPTURED_A:0] __captured_a;
	logic [__MSB_POS__CAPTURED_B:0] __captured_b;
	logic [__MSB_POS__ALMOST_OUT_DATA:0] __almost_out_data;

	logic [__MSB_POS__TEMP:0] __current;

	logic [__MSB_POS__ARR_INDEX:0] __i;
	//logic [1:0] __i;
	logic [__MSB_POS__TEMP:0] __j;

	logic [__MSB_POS__ARR_INDEX:0] __search_result;
	//logic [__MSB_POS__ARR_INDEX:0] 
	//	__search_result_0_1_2_3, __search_result_4_5_6_7;

	assign out_data = __almost_out_data;

	task iteration_end;
		input [__MSB_POS__ARR_INDEX:0] some_index;

		case (__i)
			3'd5:
			begin
				__almost_out_data[17:15] = some_index;
			end

			3'd4:
			begin
				__almost_out_data[14:12] = some_index;
			end

			3'd3:
			begin
				__almost_out_data[11:9] = some_index;
			end

			3'd2:
			begin
				__almost_out_data[8:6] = some_index;
			end

			3'd1:
			begin
				__almost_out_data[5:3] = some_index;
			end

			3'd0:
			begin
				__almost_out_data[2:0] = some_index;
			end

			//default:
			//begin
			//	// Eek!
			//	out_data = 0;
			//end
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
						__captured_b <= in_b;

						//__mult_arr[0] <= in_b * 0;
						__mult_arr[1] <= in_b * 1;
						__mult_arr[2] <= in_b * 2;
						__mult_arr[3] <= in_b * 3;

						__mult_arr[4] <= in_b * 4;
						__mult_arr[5] <= in_b * 5;
						__mult_arr[6] <= in_b * 6;
						__mult_arr[7] <= in_b * 7;
					end

					else // if (in_b == 0)
					begin
						// Ensure "correct" results (return a zero when
						// in_b is zero)
						__captured_a <= 0;
						//__captured_b <= in_b;
						__captured_b <= 1;

						//__mult_arr[0] <= 0;
						__mult_arr[1] <= 1;
						__mult_arr[2] <= 2;
						__mult_arr[3] <= 3;

						__mult_arr[4] <= 4;
						__mult_arr[5] <= 5;
						__mult_arr[6] <= 6;
						__mult_arr[7] <= 7;
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
				__almost_out_data = 0;
			end

			StWorking:
			begin
				case (__i)
					3'd5:
					begin
						__current = {__current[15:0], __captured_a[17:15]};
					end

					3'd4:
					begin
						__current = {__current[15:0], __captured_a[14:12]};
					end

					3'd3:
					begin
						__current = {__current[15:0], __captured_a[11:9]};
					end

					3'd2:
					begin
						__current = {__current[15:0], __captured_a[8:6]};
					end

					3'd1:
					begin
						__current = {__current[15:0], __captured_a[5:3]};
					end

					3'd0:
					begin
						__current = {__current[15:0], __captured_a[2:0]};
					end
				endcase

				// Binary search
				if (__mult_arr[4] > __current)
				begin
					if (__mult_arr[2] > __current)
					begin
						// 0 or 1
						if (__mult_arr[1] > __current)
						begin
							__search_result = 0;
							//iteration_end(0);
						end
						else // if (__mult_arr[1] <= __current)
						begin
							__search_result = 1;
							//iteration_end(1);
						end
					end
					else // if (__mult_arr[2] <= __current)
					begin
						// 2 or 3
						if (__mult_arr[3] > __current)
						begin
							__search_result = 2;
							//iteration_end(2);
						end
						else // if (__mult_arr[3] <= __current)
						begin
							__search_result = 3;
							//iteration_end(3);
						end
					end
					//iteration_end(__search_result_0_1_2_3);
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
						end
						else // if (__mult_arr[5] <= __current)
						begin
							__search_result = 5;
							//iteration_end(5);
						end
					end
					else // if (__mult_arr[6] <= __current)
					begin
						// 6 or 7
						if (__mult_arr[7] > __current)
						begin
							__search_result = 6;
							//iteration_end(6);
						end
						else // if (__mult_arr[7] <= __current)
						begin
							__search_result = 7;
							//iteration_end(7);
						end
					end
					//iteration_end(__search_result_4_5_6_7);
				end

				iteration_end(__search_result);
			end

		endcase
	end

endmodule
