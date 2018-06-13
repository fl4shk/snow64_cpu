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

// Barrel shifter to compute arithmetic shift right.
// This is used instead of the ">>>" Verilog operator to prevent the need
// for "$signed" and ">>>", which allow me to use Icarus Verilog's
// "-tvlog95" option).

// Note that this only works for powers of two
module ArithmeticShiftRight #(parameter WIDTH__DATA_INOUT=64)
	(input logic [__MSB_POS__DATA_INOUT:0] in_to_shift, in_amount,
	output logic [__MSB_POS__DATA_INOUT:0] out_data);

	localparam __MSB_POS__DATA_INOUT = `WIDTH2MP(WIDTH__DATA_INOUT);

	localparam __LOG2__WIDTH__DATA_INOUT = $clog2(WIDTH__DATA_INOUT);
	//localparam __ARR_SIZE__TEMP = __LOG2__WIDTH__DATA_INOUT + 1;
	localparam __ARR_SIZE__TEMP = $clog2(64) + 1;
	localparam __LAST_INDEX__TEMP
		= `ARR_SIZE_TO_LAST_INDEX(__ARR_SIZE__TEMP);

	localparam __INDEX__OUT_DATA = __LOG2__WIDTH__DATA_INOUT;


	localparam __WIDTH__OF_64 = 64;
	localparam __MSB_POS__OF_64 = `WIDTH2MP(__WIDTH__OF_64);
	localparam __WIDTH__OF_32 = 32;
	localparam __MSB_POS__OF_32 = `WIDTH2MP(__WIDTH__OF_32);
	localparam __WIDTH__OF_16 = 16;
	localparam __MSB_POS__OF_16 = `WIDTH2MP(__WIDTH__OF_16);
	localparam __WIDTH__OF_8 = 8;
	localparam __MSB_POS__OF_8 = `WIDTH2MP(__WIDTH__OF_8);
	localparam __WIDTH__OF_4 = 4;
	localparam __MSB_POS__OF_4 = `WIDTH2MP(__WIDTH__OF_4);
	localparam __WIDTH__OF_2 = 2;
	localparam __MSB_POS__OF_2 = `WIDTH2MP(__WIDTH__OF_2);

	// Local variables
	//logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];
	//logic [__MSB_POS__DATA_INOUT:0] __temp[0 : __LAST_INDEX__TEMP];
	logic [__MSB_POS__OF_64:0] __temp[0 : __LAST_INDEX__TEMP];

	//logic [__MSB_POS__DATA_INOUT:0] __i;

	//function [__MSB_POS__DATA_INOUT:0] get_modded_i;
	//	input [__MSB_POS__DATA_INOUT:0] i;
	//	get_modded_i = (1 << (i - 1));
	//endfunction
	`define get_modded_i(i) (1 << (i - 1))

	//`define set_temp(i) \
	//	__temp[i] = in_amount[i - 1] \
	//		? {{`get_modded_i(i){in_to_shift[__MSB_POS__DATA_INOUT]}}, \
	//		__temp[i - 1][__MSB_POS__DATA_INOUT : `get_modded_i(i)]} \
	//		: __temp[i - 1]
	`define set_temp(i, some_msb_pos) \
		__temp[i] = in_amount[i - 1] \
			? {{`get_modded_i(i){in_to_shift[__MSB_POS__DATA_INOUT]}}, \
			__temp[i - 1][some_msb_pos : `get_modded_i(i)]} \
			: __temp[i - 1][some_msb_pos : 0]

	// Assignments
	always @(*)
	begin
		__temp[0] = in_to_shift;
	end

	assign out_data = __temp[__INDEX__OUT_DATA];


	always @(*)
	begin
		//if (in_amount[__MSB_POS__DATA_INOUT:__LOG2__WIDTH__DATA_INOUT - 1])
		//if (in_amount[__MSB_POS__DATA_INOUT:__LOG2__WIDTH__DATA_INOUT])
		//begin
		//	__temp[`WIDTH2MP(__LOG2__WIDTH__DATA_INOUT)]
		//		[__MSB_POS__DATA_INOUT:0]
		//		= {WIDTH__DATA_INOUT{in_to_shift[__MSB_POS__DATA_INOUT]}};
		//end
		if (in_amount >= (1 << __LOG2__WIDTH__DATA_INOUT))
		begin
			__temp[__INDEX__OUT_DATA]
				= {WIDTH__DATA_INOUT{in_to_shift[__MSB_POS__DATA_INOUT]}};
		end
		//if (in_amount >= WIDTH__DATA_INOUT)
		//begin
		//	__temp[__LOG2__WIDTH__DATA_INOUT] = -1;
		//end

		else
		begin
			case (WIDTH__DATA_INOUT)
			__WIDTH__OF_64:
			begin
				`set_temp(1, __MSB_POS__OF_64);
				`set_temp(2, __MSB_POS__OF_64);
				`set_temp(3, __MSB_POS__OF_64);
				`set_temp(4, __MSB_POS__OF_64);
				`set_temp(5, __MSB_POS__OF_64);
				`set_temp(6, __MSB_POS__OF_64);
			end

			__WIDTH__OF_32:
			begin
				`set_temp(1, __MSB_POS__OF_32);
				`set_temp(2, __MSB_POS__OF_32);
				`set_temp(3, __MSB_POS__OF_32);
				`set_temp(4, __MSB_POS__OF_32);
				`set_temp(5, __MSB_POS__OF_32);
			end

			__WIDTH__OF_16:
			begin
				`set_temp(1, __MSB_POS__OF_16);
				`set_temp(2, __MSB_POS__OF_16);
				`set_temp(3, __MSB_POS__OF_16);
				`set_temp(4, __MSB_POS__OF_16);
			end

			__WIDTH__OF_8:
			begin
				`set_temp(1, __MSB_POS__OF_8);
				`set_temp(2, __MSB_POS__OF_8);
				`set_temp(3, __MSB_POS__OF_8);
			end

			__WIDTH__OF_4:
			begin
				`set_temp(1, __MSB_POS__OF_4);
				`set_temp(2, __MSB_POS__OF_4);
			end

			__WIDTH__OF_2:
			begin
				`set_temp(1, __MSB_POS__OF_2);
			end

			default:
			begin
				__temp[__INDEX__OUT_DATA] = 0;
			end

			endcase
		end

	end

endmodule
