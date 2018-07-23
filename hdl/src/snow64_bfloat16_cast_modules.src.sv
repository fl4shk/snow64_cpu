`include "src/snow64_bfloat16_defines.header.sv"

//module Snow64BFloat16CastFromInt(input logic clk,
//	input PkgSnow64BFloat16::PortIn_CastFromInt in,
//	output PkgSnow64BFloat16::PortOut_CastFromInt out);
//
//
//	enum logic
//	{
//		StIdle,
//		StFinishing
//	} __state;
//
//	logic __temp_out_data_valid, __temp_out_can_accept_cmd;
//	PkgSnow64BFloat16::BFloat16 __temp_out_data;
//	logic [`MSB_POS__SNOW64_SIZE_64:0] __temp_ret_enc_exp;
//
//	assign out.data_valid = __temp_out_data_valid;
//	assign out.can_accept_cmd = __temp_out_can_accept_cmd;
//	assign out.data = __temp_out_data;
//
//	logic [`MSB_POS__SNOW64_SIZE_64:0] __width;
//
//	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_64_IN:0] __temp_abs_data;
//	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_64_OUT:0] __out_clz64;
//
//	Snow64CountLeadingZeros64 __inst_clz64(.in(__temp_abs_data),
//		.out(__out_clz64));
//
//	initial
//	begin
//		__state = StIdle;
//		__temp_out_data_valid = 0;
//		__temp_out_can_accept_cmd = 1;
//		__temp_out_data = 0;
//	end
//
//	// Pseudo combinational logic
//	always @(posedge clk)
//	begin
//		case (__state)
//		StIdle:
//		begin
//			if (in.start)
//			begin
//				case (in.type_signedness)
//				0:
//				begin
//					case (in.type_size)
//					PkgSnow64Cpu::TypSz8:
//					begin
//						__temp_abs_data = {56'h0, in.to_cast[7:0]};
//						__width = 8;
//					end
//
//					PkgSnow64Cpu::TypSz16:
//					begin
//						__temp_abs_data = {48'h0, in.to_cast[15:0]};
//						__width = 16;
//					end
//
//					PkgSnow64Cpu::TypSz32:
//					begin
//						__temp_abs_data = {32'h0, in.to_cast[31:0]};
//						__width = 32;
//					end
//
//					PkgSnow64Cpu::TypSz64:
//					begin
//						__temp_abs_data = in.to_cast;
//						__width = 64;
//					end
//					endcase
//
//					__temp_out_data.sign = 0;
//				end
//
//				1:
//				begin
//					case (in.type_size)
//					PkgSnow64Cpu::TypSz8:
//					begin
//						__temp_abs_data = in.to_cast[7]
//							? (-in.to_cast[7:0]) : in.to_cast[7:0];
//						__width = 8;
//						__temp_out_data.sign = in.to_cast[7];
//					end
//
//					PkgSnow64Cpu::TypSz16:
//					begin
//						__temp_abs_data = in.to_cast[15]
//							? (-in.to_cast[15:0]) : in.to_cast[15:0];
//						__width = 16;
//						__temp_out_data.sign = in.to_cast[15];
//					end
//
//					PkgSnow64Cpu::TypSz32:
//					begin
//						__temp_abs_data = in.to_cast[31]
//							? (-in.to_cast[31:0]) : in.to_cast[31:0];
//						__width = 32;
//						__temp_out_data.sign = in.to_cast[31];
//					end
//
//					PkgSnow64Cpu::TypSz64:
//					begin
//						__temp_abs_data = in.to_cast;
//						__width = 64;
//						__temp_out_data.sign = in.to_cast[63];
//					end
//					endcase
//				end
//				endcase
//			end
//		end
//
//		StFinishing:
//		begin
//			__temp_ret_enc_exp = `ZERO_EXTEND(`WIDTH__SNOW64_SIZE_64,
//				`WIDTH__SNOW64_SIZE_8, `SNOW64_BFLOAT16_BIAS)
//				+ (__width - `WIDTH__SNOW64_SIZE_64'h1) - __out_clz64;
//
//			__temp_abs_data = __temp_abs_data << __out_clz64;
//			__temp_abs_data = __temp_abs_data[63:56];
//
//			if (__temp_abs_data == 0)
//			begin
//				{__temp_out_data.enc_exp, __temp_out_data.enc_mantissa}
//					= 0;
//			end
//			else // if (__temp_abs_data != 0)
//			begin
//				{__temp_out_data.enc_exp, __temp_out_data.enc_mantissa}
//					= {__temp_ret_enc_exp
//					[`MSB_POS__SNOW64_BFLOAT16_ENC_EXP:0],
//					__temp_abs_data
//					[`MSB_POS__SNOW64_BFLOAT16_ENC_MANTISSA:0]};
//			end
//
//		end
//		endcase
//	end
//
//	always_ff @(posedge clk)
//	begin
//		case (__state)
//		StIdle:
//		begin
//			if (in.start)
//			begin
//				__state <= StFinishing;
//				__temp_out_data_valid <= 0;
//				__temp_out_can_accept_cmd <= 0;
//			end
//		end
//
//		StFinishing:
//		begin
//			__state <= StIdle;
//			__temp_out_data_valid <= 1;
//			__temp_out_can_accept_cmd <= 1;
//		end
//		endcase
//	end
//
//endmodule

//module Snow64BFloat16CastToInt(input logic clk,
//	input PkgSnow64BFloat16::PortIn_CastToInt in,
//	output PkgSnow64BFloat16::PortOut_CastToInt out);
//
//endmodule
