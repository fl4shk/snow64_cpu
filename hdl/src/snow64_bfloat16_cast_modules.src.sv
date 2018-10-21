`include "src/snow64_bfloat16_defines.header.sv"

module Snow64BFloat16CastFromInt(input logic clk,
	input PkgSnow64BFloat16::PortIn_CastFromInt in,
	output PkgSnow64BFloat16::PortOut_CastFromInt out);


	enum logic
	{
		StIdle,
		StFinishing
	} __state;

	logic __temp_out_valid, __temp_out_can_accept_cmd;
	PkgSnow64BFloat16::BFloat16 __temp_out_data;
	logic [`MSB_POS__SNOW64_SIZE_64:0] __temp_ret_enc_exp;

	always @(*) out.valid = __temp_out_valid;
	always @(*) out.can_accept_cmd = __temp_out_can_accept_cmd;
	always @(*) out.data = __temp_out_data;

	logic [`MSB_POS__SNOW64_SIZE_64:0] __width;
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] __captured_in_type_size;

	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_64_IN:0] __temp_abs_data;
	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_64_OUT:0] __out_clz64;

	Snow64CountLeadingZeros64 __inst_clz64(.in(__temp_abs_data),
		.out(__out_clz64));

	initial
	begin
		__state = StIdle;
		__temp_out_valid = 0;
		__temp_out_can_accept_cmd = 1;
		__temp_out_data = 0;
	end

	// Pseudo combinational logic
	always @(posedge clk)
	begin
		case (__state)
		StIdle:
		begin
			if (in.start)
			begin
				case (in.type_signedness)
				0:
				begin
					case (in.int_type_size)
					PkgSnow64Cpu::IntTypSz8:
					begin
						__temp_abs_data = {56'h0, in.to_cast[7:0]};
						__width = 8;
					end

					PkgSnow64Cpu::IntTypSz16:
					begin
						__temp_abs_data = {48'h0, in.to_cast[15:0]};
						__width = 16;
					end

					PkgSnow64Cpu::IntTypSz32:
					begin
						__temp_abs_data = {32'h0, in.to_cast[31:0]};
						__width = 32;
					end

					PkgSnow64Cpu::IntTypSz64:
					begin
						__temp_abs_data = in.to_cast;
						__width = 64;
					end
					endcase

					__temp_out_data.sign = 0;
				end

				1:
				begin
					case (in.int_type_size)
					PkgSnow64Cpu::IntTypSz8:
					begin
						__temp_abs_data = in.to_cast[7]
							? (-in.to_cast[7:0]) : in.to_cast[7:0];
						__width = 8;
						__temp_out_data.sign = in.to_cast[7];
					end

					PkgSnow64Cpu::IntTypSz16:
					begin
						__temp_abs_data = in.to_cast[15]
							? (-in.to_cast[15:0]) : in.to_cast[15:0];
						__width = 16;
						__temp_out_data.sign = in.to_cast[15];
					end

					PkgSnow64Cpu::IntTypSz32:
					begin
						__temp_abs_data = in.to_cast[31]
							? (-in.to_cast[31:0]) : in.to_cast[31:0];
						__width = 32;
						__temp_out_data.sign = in.to_cast[31];
					end

					PkgSnow64Cpu::IntTypSz64:
					begin
						//__temp_abs_data = in.to_cast;
						//__temp_abs_data = in.to_cast;
						__temp_abs_data = in.to_cast[63]
							? (-in.to_cast[63:0]) : in.to_cast[63:0];
						__width = 64;
						__temp_out_data.sign = in.to_cast[63];
					end
					endcase
				end
				endcase
			end
		end

		StFinishing:
		begin
			case (__captured_in_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				__temp_ret_enc_exp = `SNOW64_BFLOAT16_BIAS
					+ (__width - `WIDTH__SNOW64_SIZE_64'h1) 
					- (__out_clz64 - (64 - 8));
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				__temp_ret_enc_exp = `SNOW64_BFLOAT16_BIAS
					+ (__width - `WIDTH__SNOW64_SIZE_64'h1) 
					- (__out_clz64 - (64 - 16));
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				__temp_ret_enc_exp = `SNOW64_BFLOAT16_BIAS
					+ (__width - `WIDTH__SNOW64_SIZE_64'h1) 
					- (__out_clz64 - (64 - 32));
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				__temp_ret_enc_exp = `SNOW64_BFLOAT16_BIAS
					+ (__width - `WIDTH__SNOW64_SIZE_64'h1) 
					- __out_clz64;
			end
			endcase

			__temp_abs_data = __temp_abs_data << __out_clz64;
			__temp_abs_data = __temp_abs_data[63:56];

			if (__temp_abs_data == 0)
			begin
				{__temp_out_data.enc_exp, __temp_out_data.enc_mantissa}
					= 0;
			end
			else // if (__temp_abs_data != 0)
			begin
				//{__temp_out_data.enc_exp, __temp_out_data.enc_mantissa}
				//	= {__temp_ret_enc_exp
				//	[`MSB_POS__SNOW64_BFLOAT16_ENC_EXP:0],
				//	__temp_abs_data
				//	[`MSB_POS__SNOW64_BFLOAT16_ENC_MANTISSA:0]};
				__temp_out_data.enc_exp = __temp_ret_enc_exp;
				__temp_out_data.enc_mantissa = __temp_abs_data;
			end

		end
		endcase
	end

	always_ff @(posedge clk)
	begin
		case (__state)
		StIdle:
		begin
			if (in.start)
			begin
				__state <= StFinishing;
				__temp_out_valid <= 0;
				__temp_out_can_accept_cmd <= 0;
				__captured_in_type_size <= in.int_type_size;
			end
		end

		StFinishing:
		begin
			__state <= StIdle;
			__temp_out_valid <= 1;
			__temp_out_can_accept_cmd <= 1;
		end
		endcase
	end

endmodule

module Snow64BFloat16CastToInt(input logic clk,
	input PkgSnow64BFloat16::PortIn_CastToInt in,
	output PkgSnow64BFloat16::PortOut_CastToInt out);

	localparam __WIDTH__STATE = 2;
	localparam __MSB_POS__STATE = `WIDTH2MP(__WIDTH__STATE);

	enum logic [__MSB_POS__STATE:0]
	{
		StIdle,
		StInner,
		StFinishing
	} __state;

	logic __temp_out_valid, __temp_out_can_accept_cmd;
	logic [`MSB_POS__SNOW64_SIZE_64:0] __temp_out_data, __temp_for_sticky;

	always @(*) out.valid = __temp_out_valid;
	always @(*) out.can_accept_cmd = __temp_out_can_accept_cmd;
	always @(*) out.data = __temp_out_data;


	//logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] __captured_in_to_cast;
	PkgSnow64BFloat16::BFloat16 __curr_in_to_cast, __captured_in_to_cast;
	assign __curr_in_to_cast = in.to_cast;

	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] __captured_in_type_size;
	logic __captured_in_type_signedness;

	//logic [`MSB_POS__SNOW64_BFLOAT16_ENC_EXP:0]
	logic [`MSB_POS__SNOW64_SIZE_16:0]
		__curr_exp, __abs_curr_exp, __max_shift_amount;

	logic [`MSB_POS__SNOW64_SIZE_64:0] __width;
	logic [`MSB_POS__SNOW64_SIZE_64:0] __temp_ret_enc_exp;
	logic __sticky;

	// I treat SystemVerilog tasks a lot like I would local variable lambda
	// functions in C++.
	// In fact, "set_to_max_signed()" was a C++ local variable lambda
	// function in my BFloat16 software implementation.
	task set_to_max_signed;
		case (__captured_in_type_size)
		PkgSnow64Cpu::IntTypSz8:
		begin
			__temp_out_data = {{(`WIDTH__SNOW64_SIZE_64
				- `WIDTH__SNOW64_SIZE_8){1'b1}}, 1'b1, 7'h0};
		end

		PkgSnow64Cpu::IntTypSz16:
		begin
			__temp_out_data = {{(`WIDTH__SNOW64_SIZE_64
				- `WIDTH__SNOW64_SIZE_16){1'b1}}, 1'b1, 15'h0};
		end

		PkgSnow64Cpu::IntTypSz32:
		begin
			__temp_out_data = {{(`WIDTH__SNOW64_SIZE_64
				- `WIDTH__SNOW64_SIZE_32){1'b1}}, 1'b1, 31'h0};
		end

		PkgSnow64Cpu::IntTypSz64:
		begin
			__temp_out_data = {1'b1, 63'h0};
		end
		endcase
	endtask

	task set_sticky;
		case (__captured_in_type_size)
			PkgSnow64Cpu::IntTypSz32:
			begin
				__temp_for_sticky = (~((32'h1
					<< (`WIDTH2MP(__width) - {16'h0, __abs_curr_exp}))
					- 32'h1));
				__sticky = (__temp_out_data[31:0] 
					& __temp_for_sticky[31:0]) != 0;
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				__temp_for_sticky = (~((64'h1
					<< (`WIDTH2MP(__width) - {48'h0, __abs_curr_exp}))
					- 64'h1));
				__sticky = (__temp_out_data[63:0] 
					& __temp_for_sticky[63:0]) != 0;
			end
		endcase
	endtask

	initial
	begin
		__state = StIdle;
		__temp_out_valid = 0;
		__temp_out_can_accept_cmd = 1;
		__temp_out_data = 0;
	end

	// Pseudo combinational logic
	always @(posedge clk)
	begin
		case (__state)
		StIdle:
		begin
			if (in.start)
			begin
				//$display("__curr_in_to_cast:  %h",
				//	__curr_in_to_cast);
				__temp_out_data = `SNOW64_BFLOAT16_FRAC(__curr_in_to_cast);

				//__curr_exp = `SIGN_EXTEND(`WIDTH__SNOW64_SIZE_64,
				//	`WIDTH__SNOW64_BFLOAT16_ENC_EXP,
				//	__curr_in_to_cast.enc_exp)
				//	- `SIGN_EXTEND(`WIDTH__SNOW64_SIZE_64,
				//	`WIDTH__SNOW64_BFLOAT16_ENC_EXP,
				//	`SNOW64_BFLOAT16_MODDED_BIAS);
				//__curr_exp = `SIGN_EXTEND(`WIDTH__SNOW64_SIZE_64,
				//	`WIDTH__SNOW64_BFLOAT16_ENC_EXP,
				//	__curr_in_to_cast.enc_exp)
				//	- `SNOW64_BFLOAT16_MODDED_BIAS;
				__curr_exp = __curr_in_to_cast.enc_exp
					- `SNOW64_BFLOAT16_MODDED_BIAS;

				if (__curr_exp[`MSB_POS__SNOW64_SIZE_16])
				begin
					__abs_curr_exp = -__curr_exp;
				end
				else
				begin
					__abs_curr_exp = __curr_exp;
				end

				case (in.int_type_size)
				PkgSnow64Cpu::IntTypSz8:
				begin
					__max_shift_amount = `MSB_POS__SNOW64_SIZE_8;
					__width = `WIDTH__SNOW64_SIZE_8;
				end

				PkgSnow64Cpu::IntTypSz16:
				begin
					__max_shift_amount = `MSB_POS__SNOW64_SIZE_16;
					__width = `WIDTH__SNOW64_SIZE_16;
				end

				PkgSnow64Cpu::IntTypSz32:
				begin
					__max_shift_amount = `MSB_POS__SNOW64_SIZE_32;
					__width = `WIDTH__SNOW64_SIZE_32;
				end

				PkgSnow64Cpu::IntTypSz64:
				begin
					__max_shift_amount = `MSB_POS__SNOW64_SIZE_64;
					__width = `WIDTH__SNOW64_SIZE_64;
				end
				endcase
			end
		end

		StInner:
		begin
			//$display("StInner stuffs:  %h\t\t%h, %h, %h",
			//	__temp_out_data, __curr_exp, __abs_curr_exp,
			//	__max_shift_amount);
			if (__curr_exp != __abs_curr_exp)
			begin
				//$display("StInner:  __curr_exp < 0");
				if (__abs_curr_exp <= __max_shift_amount)
				begin
					//$display("StInner:  %s",
					//	"__abs_curr_exp <= __max_shift_amount");
					__temp_out_data = __temp_out_data >> __abs_curr_exp;


					if ((!__captured_in_type_signedness)
						&& __captured_in_to_cast.sign)
					begin
						__temp_out_data = -__temp_out_data;
					end
				end
				else
				begin
					//$display("StInner:  %s",
					//	"__abs_curr_exp > __max_shift_amount");
					__temp_out_data = 0;
				end
			end
			else // if (__curr_exp == __abs_curr_exp)
			begin
				//$display("StInner:  __curr_exp >= 0");
				if (__abs_curr_exp <= __max_shift_amount)
				begin
					//$display("StInner:  %s",
					//	"__abs_curr_exp <= __max_shift_amount");
					//if (__abs_curr_exp == 0)
					//begin
					//	__sticky = `GET_BITS_WITH_RANGE(__temp_out_data,
					//		`WIDTH2MP(__width), 0) != 0;
					//end
					//else // if (__abs_curr_exp != 0)
					//begin
					//	__sticky = `GET_BITS_WITH_RANGE(__temp_out_data,
					//		`WIDTH2MP(__width),
					//		(`WIDTH2MP(__width) - __abs_curr_exp))
					//		!= 0;
					//end
					set_sticky();

					__temp_out_data = __temp_out_data << __abs_curr_exp;

					if ((!__captured_in_type_signedness)
						&& __captured_in_to_cast.sign)
					begin
						__temp_out_data = -__temp_out_data;
					end

					//$display("StInner last __temp_out_data:  %h",
					//	__temp_out_data);
				end

				else // if (__abs_curr_exp > __max_shift_amount)
				begin
					//$display("StInner:  %s",
					//	"__abs_curr_exp > __max_shift_amount");

					//$display("stuffs:  %h\t\t%h, %h, %h\t\t%h, %h, %h",
					//	__captured_in_type_signedness,
					//	__captured_in_type_size,
					//	__curr_exp, __width,
					//	__captured_in_to_cast.enc_exp,
					//	`SNOW64_BFLOAT16_MAX_ENC_EXP,
					//	(__captured_in_to_cast.enc_exp
					//	!= `SNOW64_BFLOAT16_MAX_ENC_EXP));

					__temp_out_data = 0;

					//if ((__captured_in_type_size >= PkgSnow64Cpu::IntTypSz32)
					//	&& (__curr_exp >= __width)
					//	&& (__captured_in_to_cast.enc_exp
					//	!= `SNOW64_BFLOAT16_MAX_ENC_EXP))
					if ((__captured_in_type_size >= PkgSnow64Cpu::IntTypSz32)
						&& ({8'h00, __curr_exp} >= __width[15:0])
						&& (__captured_in_to_cast.enc_exp
						!= `SNOW64_BFLOAT16_MAX_ENC_EXP))
					begin
						if (!__captured_in_type_signedness)
						begin
							if (__captured_in_to_cast.sign
								&& (__captured_in_type_size
								== PkgSnow64Cpu::IntTypSz64))
							begin
								set_to_max_signed();
							end
						end
						else // if (__captured_in_type_signedness)
						begin
							//$display("set_to_max_signed()");
							set_to_max_signed();
						end
					end
				end
			end
		end

		StFinishing:
		begin
			// I have no idea what's up with this strange behavior,
			// but this is what I had to do to get it to properly
			// match what IEEE floats do on my x86-64 laptop.

			//$display("StFinishing:  %h", __sticky);

			if ((__curr_exp == __abs_curr_exp)
				&& (__abs_curr_exp <= __max_shift_amount)
				&& (__captured_in_type_size >= PkgSnow64Cpu::IntTypSz32)
				&& __sticky)
			begin
				if (!__captured_in_type_signedness)
				begin
					if (__captured_in_type_size == PkgSnow64Cpu::IntTypSz64)
					begin
						if (__captured_in_to_cast.sign)
						begin
							__temp_out_data = 0;

							if (__curr_exp >= 56)
							begin
								set_to_max_signed();
							end
						end

						else if (__curr_exp >= 57)
						begin
							__temp_out_data = 0;
						end
					end
				end
				else // if (__captured_in_type_signedness)
				begin
					set_to_max_signed();
				end
			end

			if (__captured_in_type_signedness
				&& __captured_in_to_cast.sign)
			begin
				__temp_out_data = -__temp_out_data;
			end

			//$display("StFinishing");

			case (__captured_in_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				//$display("Shrinking things:  %h", __temp_out_data);
				__temp_out_data = __temp_out_data[7:0];
				//$display("Shrinking things:  %h", __temp_out_data);
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				__temp_out_data = __temp_out_data[15:0];
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				__temp_out_data = __temp_out_data[31:0];
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				
			end
			endcase
		end
		endcase
	end

	always_ff @(posedge clk)
	begin
		case (__state)
		StIdle:
		begin
			if (in.start)
			begin
				__state <= StInner;
				__temp_out_valid <= 0;
				__temp_out_can_accept_cmd <= 0;

				__captured_in_to_cast <= in.to_cast;
				__captured_in_type_size <= in.int_type_size;
				__captured_in_type_signedness <= in.type_signedness;
			end
		end

		StInner:
		begin
			__state <= StFinishing;
		end

		StFinishing:
		begin
			__state <= StIdle;
			__temp_out_valid <= 1;
			__temp_out_can_accept_cmd <= 1;
		end
		endcase
	end

endmodule


//module DebugSnow64BFloat16CastFromInt(input logic clk,
//	input logic in_start,
//	input logic [`MSB_POS__SNOW64_SIZE_64:0] in_to_cast,
//	input logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] in_type_size,
//	input logic in_type_signedness,
//	output logic out_valid, out_can_accept_cmd,
//	output logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] out_data);
//
//	PkgSnow64BFloat16::PortIn_CastFromInt __in_cast_from_int;
//	PkgSnow64BFloat16::PortOut_CastFromInt __out_cast_from_int;
//
//	Snow64BFloat16CastFromInt __inst_cast_from_int(.clk(clk),
//		.in(__in_cast_from_int), .out(__out_cast_from_int));
//
//
//	always @(*) __in_cast_from_int.start = in_start;
//	always @(*) __in_cast_from_int.to_cast = in_to_cast;
//	always @(*) __in_cast_from_int.int_type_size = in_type_size;
//	always @(*) __in_cast_from_int.type_signedness = in_type_signedness;
//
//	assign out_valid = __out_cast_from_int.valid;
//	assign out_can_accept_cmd = __out_cast_from_int.can_accept_cmd;
//	assign out_data = __out_cast_from_int.data;
//
//endmodule
//
//
//module DebugSnow64BFloat16CastToInt(input logic clk,
//	input logic in_start,
//	input logic [`MSB_POS__SNOW64_BFLOAT16_ITSELF:0] in_to_cast,
//	input logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] in_type_size,
//	input logic in_type_signedness,
//	output logic out_valid, out_can_accept_cmd,
//	output logic [`MSB_POS__SNOW64_SIZE_64:0] out_data);
//
//	PkgSnow64BFloat16::PortIn_CastToInt __in_cast_to_int;
//	PkgSnow64BFloat16::PortOut_CastToInt __out_cast_to_int;
//
//	Snow64BFloat16CastToInt __inst_cast_to_int(.clk(clk),
//		.in(__in_cast_to_int), .out(__out_cast_to_int));
//
//
//	always @(*) __in_cast_to_int.start = in_start;
//	always @(*) __in_cast_to_int.to_cast = in_to_cast;
//	always @(*) __in_cast_to_int.int_type_size = in_type_size;
//	always @(*) __in_cast_to_int.type_signedness = in_type_signedness;
//
//	assign out_valid = __out_cast_to_int.valid;
//	assign out_can_accept_cmd = __out_cast_to_int.can_accept_cmd;
//	assign out_data = __out_cast_to_int.data;
//
//endmodule
