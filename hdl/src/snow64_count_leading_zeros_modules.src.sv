`include "src/misc_defines.header.sv"



//case 2:
//	s = get_bits_with_range(s, 15, 8)
//		? get_bits_with_range(s, 15, 8)
//		: ((1 << 8) | get_bits_with_range(s, 7, 0));
//	set_bits_with_range(ret, get_bits_with_range(s, 8, 8), 3,
//		3);

//case 1:
//	s = get_bits_with_range(s, 7, 4)
//		? get_bits_with_range(s, 7, 4)
//		: ((1 << 4) | get_bits_with_range(s, 3, 0));
//	set_bits_with_range(ret, get_bits_with_range(s, 4, 4), 2,
//		2);

//	s = get_bits_with_range(s, 3, 2)
//		? get_bits_with_range(s, 3, 2)
//		: ((1 << 2) | get_bits_with_range(s, 1, 0));
//	set_bits_with_range(ret, get_bits_with_range(s, 2, 2), 1,
//		1);

//	set_bits_with_range(ret, !get_bits_with_range(s, 1, 1), 0,
//		0);
//	break;

module Snow64CountLeadingZeros16
	(input logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_IN:0] in,
	output logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_OUT:0] out);

	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_IN:0] __temp;

	//always_comb
	always @(*)
	begin
		if (in == 0)
		begin
			// This is why "out" has a width of 5 bits.
			out = 16;
		end

		else
		begin
			__temp = in;
			out[4] = 0;

			__temp = __temp[15:8] ? __temp[15:8] : {1'b1, __temp[7:0]};
			out[3] = __temp[8];

			__temp = __temp[7:4] ? __temp[7:4] : {1'b1, __temp[3:0]};
			out[2] = __temp[4];

			__temp = __temp[3:2] ? __temp[3:2] : {1'b1, __temp[1:0]};
			out[1] = __temp[2];

			out[0] = !__temp[1];
		end
	end

endmodule

module Snow64CountLeadingZeros32
	(input logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_32_IN:0] in,
	output logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_32_OUT:0] out);

	logic [`MSB_POS__SNOW64_COUNT_LEADING_ZEROS_32_IN:0] __temp;

	//always_comb
	always @(*)
	begin
		if (in == 0)
		begin
			out = 32;
		end

		else
		begin
			__temp = in;
			out[5] = 0;

			__temp = __temp[31:16] ? __temp[31:16] : {1'b1, __temp[15:0]};
			out[4] = __temp[16];

			__temp = __temp[15:8] ? __temp[15:8] : {1'b1, __temp[7:0]};
			out[3] = __temp[8];

			__temp = __temp[7:4] ? __temp[7:4] : {1'b1, __temp[3:0]};
			out[2] = __temp[4];

			__temp = __temp[3:2] ? __temp[3:2] : {1'b1, __temp[1:0]};
			out[1] = __temp[2];

			out[0] = !__temp[1];
		end
	end

endmodule
