`include "src/snow64_alu_defines.header.sv"

module SetLessThanUnsigned #(parameter WIDTH__DATA_INOUT=64)
	(input logic [MSB_POS__DATA_INOUT:0] in_a, in_b, 
	output logic out_data);

	localparam MSB_POS__DATA_INOUT = `WIDTH2MP(WIDTH__DATA_INOUT);
	logic [MSB_POS__DATA_INOUT:0] __temp;

	// 6502-style subtract
	assign {out_data, __temp} = in_a + (~in_b) 
		+ {{MSB_POS__DATA_INOUT{1'b0}}, 1'b1};
endmodule

module SetLessThanSigned #(parameter WIDTH__DATA_INOUT=64)
	(input logic [MSB_POS__DATA_INOUT:0] in_a, in_b, 
	output logic out_data);

	localparam MSB_POS__DATA_INOUT = `WIDTH2MP(WIDTH__DATA_INOUT);
	logic [MSB_POS__DATA_INOUT:0] __temp;

	// 6502-style subtract
	assign __temp = in_a + (~in_b) + {{MSB_POS__DATA_INOUT{1'b0}}, 1'b1};

	// 6502-style "N" and "V" flags.
	assign out_data = (__temp[MSB_POS__DATA_INOUT]
		^ ((in_a[MSB_POS__DATA_INOUT] ^ in_b[MSB_POS__DATA_INOUT])
		& (in_a[MSB_POS__DATA_INOUT] ^ __temp[MSB_POS__DATA_INOUT])));
endmodule

// Barrel shifters to compute arithmetic shift right.
// This is used instead of the ">>>" Verilog operator to prevent the need
// for "$signed" and ">>>", which allow me to use Icarus Verilog's
// "-tvlog95" option).

`define get_modded_i(i) (1 << (i - 1))

`define set_temp(i, some_msb_pos) \
	__temp[i] = in_amount[i - 1] \
		? {{`get_modded_i(i){in_to_shift[__MSB_POS__DATA_INOUT]}}, \
		__temp[i - 1][some_msb_pos : `get_modded_i(i)]} \
		: __temp[i - 1][some_msb_pos : 0]

module ArithmeticShiftRight64
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);


	localparam __WIDTH__DATA_INOUT = 64;
	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(__WIDTH__DATA_INOUT);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= `ARR_SIZE_TO_LAST_INDEX(__ARR_SIZE__TEMP);

	localparam __INDEX__OUT_DATA = __LOG2__WIDTH__DATA_INOUT;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];

	always @(*)
	begin
		if (in_amount >= (1 << __LOG2__WIDTH__DATA_INOUT))
		begin
			__temp[__INDEX__OUT_DATA]
				= {__WIDTH__DATA_INOUT
				{in_to_shift[__MSB_POS__DATA_INOUT]}};
		end

		else
		begin
			`set_temp(1, __MSB_POS__DATA_INOUT);
			`set_temp(2, __MSB_POS__DATA_INOUT);
			`set_temp(3, __MSB_POS__DATA_INOUT);
			`set_temp(4, __MSB_POS__DATA_INOUT);
			`set_temp(5, __MSB_POS__DATA_INOUT);
			`set_temp(6, __MSB_POS__DATA_INOUT);
		end
	end
endmodule

module ArithmeticShiftRight32
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);


	localparam __WIDTH__DATA_INOUT = 32;
	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(__WIDTH__DATA_INOUT);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= `ARR_SIZE_TO_LAST_INDEX(__ARR_SIZE__TEMP);

	localparam __INDEX__OUT_DATA = __LOG2__WIDTH__DATA_INOUT;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];

	always @(*)
	begin
		if (in_amount >= (1 << __LOG2__WIDTH__DATA_INOUT))
		begin
			__temp[__INDEX__OUT_DATA]
				= {__WIDTH__DATA_INOUT
				{in_to_shift[__MSB_POS__DATA_INOUT]}};
		end

		else
		begin
			`set_temp(1, __MSB_POS__DATA_INOUT);
			`set_temp(2, __MSB_POS__DATA_INOUT);
			`set_temp(3, __MSB_POS__DATA_INOUT);
			`set_temp(4, __MSB_POS__DATA_INOUT);
			`set_temp(5, __MSB_POS__DATA_INOUT);
		end
	end
endmodule

module ArithmeticShiftRight16
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);


	localparam __WIDTH__DATA_INOUT = 16;
	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(__WIDTH__DATA_INOUT);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= `ARR_SIZE_TO_LAST_INDEX(__ARR_SIZE__TEMP);

	localparam __INDEX__OUT_DATA = __LOG2__WIDTH__DATA_INOUT;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];

	always @(*)
	begin
		if (in_amount >= (1 << __LOG2__WIDTH__DATA_INOUT))
		begin
			__temp[__INDEX__OUT_DATA]
				= {__WIDTH__DATA_INOUT
				{in_to_shift[__MSB_POS__DATA_INOUT]}};
		end

		else
		begin
			`set_temp(1, __MSB_POS__DATA_INOUT);
			`set_temp(2, __MSB_POS__DATA_INOUT);
			`set_temp(3, __MSB_POS__DATA_INOUT);
			`set_temp(4, __MSB_POS__DATA_INOUT);
		end
	end

endmodule

module ArithmeticShiftRight8
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);


	localparam __WIDTH__DATA_INOUT = 8;
	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(__WIDTH__DATA_INOUT);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(__WIDTH__DATA_INOUT);
	localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __LAST_INDEX__TEMP
		= `ARR_SIZE_TO_LAST_INDEX(__ARR_SIZE__TEMP);

	localparam __INDEX__OUT_DATA = __LOG2__WIDTH__DATA_INOUT;

	logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];

	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];

	always @(*)
	begin
		if (in_amount >= (1 << __LOG2__WIDTH__DATA_INOUT))
		begin
			__temp[__INDEX__OUT_DATA]
				= {__WIDTH__DATA_INOUT
				{in_to_shift[__MSB_POS__DATA_INOUT]}};
		end

		else
		begin
			`set_temp(1, __MSB_POS__DATA_INOUT);
			`set_temp(2, __MSB_POS__DATA_INOUT);
			`set_temp(3, __MSB_POS__DATA_INOUT);
		end
	end
endmodule

`define MAKE_ASR_AND_PORTS(some_width) \
	struct packed \
	{ \
		logic [PkgSnow64Alu::MSB_POS__OF_``some_width:0] \
			to_shift, amount; \
	} __in_asr``some_width; \
	struct packed \
	{ \
		logic [PkgSnow64Alu::MSB_POS__OF_``some_width:0] data; \
	} __out_asr``some_width; \
	assign __in_asr``some_width.to_shift = in_to_shift; \
	assign __in_asr``some_width.amount = in_amount; \
	ArithmeticShiftRight``some_width \
		__inst_asr``some_width \
		(.in_to_shift(__in_asr``some_width.to_shift), \
		.in_amount(__in_asr``some_width.amount), \
		.out_data(__out_asr``some_width.data));



module DebugArithmeticShiftRight #(parameter WIDTH__DATA_INOUT=64)
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	import PkgSnow64Alu::*;

	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(WIDTH__DATA_INOUT);

	`MAKE_ASR_AND_PORTS(64)

	`MAKE_ASR_AND_PORTS(32)

	`MAKE_ASR_AND_PORTS(16)

	`MAKE_ASR_AND_PORTS(8)

	always @(*)
	begin
		case (WIDTH__DATA_INOUT)
			64:
			begin
				out_data = __out_asr64.data;
			end

			32:
			begin
				out_data = __out_asr32.data;
			end

			16:
			begin
				out_data = __out_asr16.data;
			end

			8:
			begin
				out_data = __out_asr8.data;
			end

			default:
			begin
				out_data = 0;
			end
		endcase
	end

endmodule
