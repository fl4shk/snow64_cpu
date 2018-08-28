`include "src/snow64_alu_defines.header.sv" 
//module SetLessThanUnsigned #(parameter WIDTH__DATA_INOUT=64)
//	(input logic [__MSB_POS__DATA_INOUT:0] in_a, in_b, 
//	output logic out_data);
//
//	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(WIDTH__DATA_INOUT);
//	logic [__MSB_POS__DATA_INOUT:0] __temp;
//
//	// 6502-style subtract
//	assign {out_data, __temp} = in_a + (~in_b) 
//		+ {{__MSB_POS__DATA_INOUT{1'b0}}, 1'b1};
//endmodule

//module SetLessThanSigned #(parameter WIDTH__DATA_INOUT=64)
//	(input logic [__MSB_POS__DATA_INOUT:0] in_a, in_b, 
//	output logic out_data);
//
//	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(WIDTH__DATA_INOUT);
//	logic [__MSB_POS__DATA_INOUT:0] __temp;
//
//	// 6502-style subtract
//	assign __temp = in_a + (~in_b) + {{__MSB_POS__DATA_INOUT{1'b0}}, 1'b1};
//
//	// 6502-style "N" and "V" flags.
//	assign out_data = (__temp[__MSB_POS__DATA_INOUT]
//		^ ((in_a[__MSB_POS__DATA_INOUT] ^ in_b[__MSB_POS__DATA_INOUT])
//		& (in_a[__MSB_POS__DATA_INOUT] ^ __temp[__MSB_POS__DATA_INOUT])));
//endmodule

//module SetLessThanUnsigned(input logic in_a_msb_pos, in_b_msb_pos,
//	output logic out_data);
//
//endmodule

module __RawSetLessThanSigned
	(input logic in_a_msb_pos, in_b_msb_pos, in_sub_result_msb_pos,
	output logic out_data);

	// 6502-style "N" and "V" flags.
	assign out_data = (in_sub_result_msb_pos
		^ ((in_a_msb_pos ^ in_b_msb_pos)
		& (in_a_msb_pos ^ in_sub_result_msb_pos)));
endmodule

module SetLessThanSigned #(parameter WIDTH__DATA_INOUT=64)
	(input logic [__MSB_POS__DATA_INOUT:0] in_a, in_b,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(WIDTH__DATA_INOUT);

	logic [__MSB_POS__DATA_INOUT:0] __sub_result;
	assign __sub_result = in_a - in_b;

	logic __out_raw_slts_data;

	__RawSetLessThanSigned __inst_raw_slts
		(.in_a_msb_pos(in_a[__MSB_POS__DATA_INOUT]),
		.in_b_msb_pos(in_b[__MSB_POS__DATA_INOUT]),
		.in_sub_result_msb_pos(__sub_result[__MSB_POS__DATA_INOUT]),
		.out_data(__out_raw_slts_data));

	assign out_data = `ZERO_EXTEND(WIDTH__DATA_INOUT, 1, 
		__out_raw_slts_data);

endmodule

// Barrel shifters to compute arithmetic shift right.
// This is used instead of the ">>>" Verilog operator to prevent the need
// for "$signed" and ">>>", which allow me to use Icarus Verilog's
// "-tvlog95" option).

`define GET_MODDED_I(i) (1 << (i - 1))

`define SET_TEMP_LSL(i) \
	__temp[i] = in_amount[i - 1] \
		? {__temp[i - 1][__MSB_POS__DATA_INOUT - `GET_MODDED_I(i) : 0], \
		{`GET_MODDED_I(i){1'b0}}} \
		: __temp[i - 1]

`define SET_TEMP_LSR(i) \
	__temp[i] = in_amount[i - 1] \
		? {{`GET_MODDED_I(i){1'b0}}, \
		__temp[i - 1][__MSB_POS__DATA_INOUT : `GET_MODDED_I(i)]} \
		: __temp[i - 1][__MSB_POS__DATA_INOUT : 0]

`define SET_TEMP_ASR(i) \
	__temp[i] = in_amount[i - 1] \
		? {{`GET_MODDED_I(i){in_to_shift[__MSB_POS__DATA_INOUT]}}, \
		__temp[i - 1][__MSB_POS__DATA_INOUT : `GET_MODDED_I(i)]} \
		: __temp[i - 1][__MSB_POS__DATA_INOUT : 0]


`define MAKE_BIT_SHIFT_PROLOG(some_width) \
	localparam __WIDTH__DATA_INOUT = some_width; \
	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(__WIDTH__DATA_INOUT); \
\
	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT); \
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1; \
	localparam __LAST_INDEX__TEMP \
		= `ARR_SIZE_TO_LAST_INDEX(__ARR_SIZE__TEMP); \
\
	localparam __INDEX__OUT_DATA = __LAST_INDEX__TEMP; \
\
	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP]; \
\
	always @(*) \
	begin \
		__temp[0] = in_to_shift; \
	end \
\
	assign out_data = __temp[__INDEX__OUT_DATA]; \

`define COMPARE_BIT_SHIFT_IN_AMOUNT \
	in_amount[__MSB_POS__DATA_INOUT:__LOG2__WIDTH__DATA_INOUT]


module LogicalShiftLeft64
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	`MAKE_BIT_SHIFT_PROLOG(64)

	always @(*)
	begin
		if (`COMPARE_BIT_SHIFT_IN_AMOUNT)
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			`SET_TEMP_LSL(1);
			`SET_TEMP_LSL(2);
			`SET_TEMP_LSL(3);
			`SET_TEMP_LSL(4);
			`SET_TEMP_LSL(5);
			`SET_TEMP_LSL(6);
		end
	end
endmodule
module LogicalShiftLeft32
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	`MAKE_BIT_SHIFT_PROLOG(32)

	always @(*)
	begin
		if (`COMPARE_BIT_SHIFT_IN_AMOUNT)
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			`SET_TEMP_LSL(1);
			`SET_TEMP_LSL(2);
			`SET_TEMP_LSL(3);
			`SET_TEMP_LSL(4);
			`SET_TEMP_LSL(5);
		end
	end
endmodule
module LogicalShiftLeft16
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	`MAKE_BIT_SHIFT_PROLOG(16)

	always @(*)
	begin
		if (`COMPARE_BIT_SHIFT_IN_AMOUNT)
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			`SET_TEMP_LSL(1);
			`SET_TEMP_LSL(2);
			`SET_TEMP_LSL(3);
			`SET_TEMP_LSL(4);
		end
	end
endmodule
module LogicalShiftLeft8
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	`MAKE_BIT_SHIFT_PROLOG(8)

	always @(*)
	begin
		if (`COMPARE_BIT_SHIFT_IN_AMOUNT)
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			`SET_TEMP_LSL(1);
			`SET_TEMP_LSL(2);
			`SET_TEMP_LSL(3);
		end
	end
endmodule


module LogicalShiftRight64
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	`MAKE_BIT_SHIFT_PROLOG(64)

	always @(*)
	begin
		if (`COMPARE_BIT_SHIFT_IN_AMOUNT)
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			`SET_TEMP_LSR(1);
			`SET_TEMP_LSR(2);
			`SET_TEMP_LSR(3);
			`SET_TEMP_LSR(4);
			`SET_TEMP_LSR(5);
			`SET_TEMP_LSR(6);
		end
	end
endmodule
module LogicalShiftRight32
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	`MAKE_BIT_SHIFT_PROLOG(32)

	always @(*)
	begin
		if (`COMPARE_BIT_SHIFT_IN_AMOUNT)
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			`SET_TEMP_LSR(1);
			`SET_TEMP_LSR(2);
			`SET_TEMP_LSR(3);
			`SET_TEMP_LSR(4);
			`SET_TEMP_LSR(5);
		end
	end
endmodule
module LogicalShiftRight16
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	`MAKE_BIT_SHIFT_PROLOG(16)

	always @(*)
	begin
		if (`COMPARE_BIT_SHIFT_IN_AMOUNT)
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			`SET_TEMP_LSR(1);
			`SET_TEMP_LSR(2);
			`SET_TEMP_LSR(3);
			`SET_TEMP_LSR(4);
		end
	end
endmodule
module LogicalShiftRight8
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	`MAKE_BIT_SHIFT_PROLOG(8)

	always @(*)
	begin
		if (`COMPARE_BIT_SHIFT_IN_AMOUNT)
		begin
			__temp[__INDEX__OUT_DATA] = 0;
		end

		else
		begin
			`SET_TEMP_LSR(1);
			`SET_TEMP_LSR(2);
			`SET_TEMP_LSR(3);
		end
	end
endmodule

module ArithmeticShiftRight64
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	`MAKE_BIT_SHIFT_PROLOG(64)

	always @(*)
	begin
		if (`COMPARE_BIT_SHIFT_IN_AMOUNT)
		begin
			__temp[__INDEX__OUT_DATA]
				= {__WIDTH__DATA_INOUT
				{in_to_shift[__MSB_POS__DATA_INOUT]}};
		end

		else
		begin
			`SET_TEMP_ASR(1);
			`SET_TEMP_ASR(2);
			`SET_TEMP_ASR(3);
			`SET_TEMP_ASR(4);
			`SET_TEMP_ASR(5);
			`SET_TEMP_ASR(6);
		end
	end
endmodule

module ArithmeticShiftRight32
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	`MAKE_BIT_SHIFT_PROLOG(32)

	always @(*)
	begin
		if (`COMPARE_BIT_SHIFT_IN_AMOUNT)
		begin
			__temp[__INDEX__OUT_DATA]
				= {__WIDTH__DATA_INOUT
				{in_to_shift[__MSB_POS__DATA_INOUT]}};
		end

		else
		begin
			`SET_TEMP_ASR(1);
			`SET_TEMP_ASR(2);
			`SET_TEMP_ASR(3);
			`SET_TEMP_ASR(4);
			`SET_TEMP_ASR(5);
		end
	end
endmodule

module ArithmeticShiftRight16
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	`MAKE_BIT_SHIFT_PROLOG(16)

	always @(*)
	begin
		if (`COMPARE_BIT_SHIFT_IN_AMOUNT)
		begin
			__temp[__INDEX__OUT_DATA]
				= {__WIDTH__DATA_INOUT
				{in_to_shift[__MSB_POS__DATA_INOUT]}};
		end

		else
		begin
			`SET_TEMP_ASR(1);
			`SET_TEMP_ASR(2);
			`SET_TEMP_ASR(3);
			`SET_TEMP_ASR(4);
		end
	end

endmodule

module ArithmeticShiftRight8
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	`MAKE_BIT_SHIFT_PROLOG(8)

	always @(*)
	begin
		if (`COMPARE_BIT_SHIFT_IN_AMOUNT)
		begin
			__temp[__INDEX__OUT_DATA]
				= {__WIDTH__DATA_INOUT
				{in_to_shift[__MSB_POS__DATA_INOUT]}};
		end

		else
		begin
			`SET_TEMP_ASR(1);
			`SET_TEMP_ASR(2);
			`SET_TEMP_ASR(3);
		end
	end
endmodule

//`define MAKE_ASR_AND_PORTS(some_width) \
//	struct packed \
//	{ \
//		logic [PkgSnow64Alu::MSB_POS__OF_``some_width:0] \
//			to_shift, amount; \
//	} __in_asr``some_width; \
//	struct packed \
//	{ \
//		logic [PkgSnow64Alu::MSB_POS__OF_``some_width:0] data; \
//	} __out_asr``some_width; \
//	assign __in_asr``some_width.to_shift = in_to_shift; \
//	assign __in_asr``some_width.amount = in_amount; \
//	ArithmeticShiftRight``some_width \
//		__inst_asr``some_width \
//		(.in_to_shift(__in_asr``some_width.to_shift), \
//		.in_amount(__in_asr``some_width.amount), \
//		.out_data(__out_asr``some_width.data));
//
//
//
//module DebugArithmeticShiftRight #(parameter WIDTH__DATA_INOUT=64)
//	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
//	output logic [__MSB_POS__DATA_INOUT:0] out_data);
//
//	//import PkgSnow64Alu::*;
//
//	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(WIDTH__DATA_INOUT);
//
//	`MAKE_ASR_AND_PORTS(64)
//
//	`MAKE_ASR_AND_PORTS(32)
//
//	`MAKE_ASR_AND_PORTS(16)
//
//	`MAKE_ASR_AND_PORTS(8)
//
//	always @(*)
//	begin
//		case (WIDTH__DATA_INOUT)
//			64:
//			begin
//				out_data = __out_asr64.data;
//			end
//
//			32:
//			begin
//				out_data = __out_asr32.data;
//			end
//
//			16:
//			begin
//				out_data = __out_asr16.data;
//			end
//
//			8:
//			begin
//				out_data = __out_asr8.data;
//			end
//
//			default:
//			begin
//				out_data = 0;
//			end
//		endcase
//	end
//
//endmodule

