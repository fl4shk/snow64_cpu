`ifndef src__slash__misc_defines_header_sv
`define src__slash__misc_defines_header_sv

// src/misc_defines.header.sv

//`default_nettype none

`define WIDTH2MP(some_width) ((some_width) - 1)
`define MP2WIDTH(some_msb_pos) ((some_msb_pos) + 1)
`define ARR_SIZE_TO_LAST_INDEX(some_arr_size) ((some_arr_size) - 1)

// MSB position of some struct... used for approximating the ability to put
// a packed struct into another packed struct with Icarus Verilog.
// Ideally, Icarus Verilog would support that directly.
`define MPOFSTRUCT(some_struct) `WIDTH2MP($bits(some_struct))

// A struct's dimensions (mostly used to work around limitations in Icarus
// Verilog's support of packed structs).
`define STRUCTDIM(some_struct) [`MPOFSTRUCT(some_struct):0]

`define MAKE_NEXT_INDEX_LO(some_prev_index_hi) \
	((some_prev_index_hi) + 1)
`define MAKE_INDEX_HI(some_index_lo, some_width) \
	((some_index_lo) + (`WIDTH2MP(some_width)))

`define SIGN_EXTEND(some_full_width, some_width_of_arg, some_arg) \
	{{(some_full_width - some_width_of_arg) \
	{some_arg[`WIDTH2MP(some_width_of_arg)]}},some_arg}
`define SIGN_EXTEND_TYPE_2(some_full_width, some_width_of_arg, some_bit_to_extend, some_arg) \
	{{(some_full_width - some_width_of_arg) \
	{some_bit_to_extend}},some_arg}
//`define SIGN_EXTEND_SLICED(some_full_width, some_width_of_arg, 
//	some_non_sliced_arg, some_other_arg) \
//	{{(some_full_width - some_width_of_arg) \
//	{some_non_sliced_arg[`WIDTH2MP(some_width_of_arg)]}},some_other_arg}
`define ZERO_EXTEND(some_full_width, some_width_of_arg, some_other_arg) \
	{{(some_full_width - some_width_of_arg){1'b0}},some_other_arg}


`define BPRANGE_TO_MASK(bit_pos_hi, bit_pos_lo) \
	((1 << (bit_pos_hi - bit_pos_lo + 1)) - 1)
`define BPRANGE_TO_SHIFTED_MASK(bit_pos_hi, bit_pos_lo) \
	(((1 << (bit_pos_hi - bit_pos_lo + 1)) - 1) << bit_pos_lo)
`define GET_BITS(to_get_from, mask, shift) \
	((to_get_from & mask) >> shift)
`define GET_BITS_WITH_RANGE(to_get_from, bit_pos_range_hi, bit_pos_range_lo) \
	`GET_BITS(to_get_from, \
		`BPRANGE_TO_SHIFTED_MASK(bit_pos_range_hi, bit_pos_range_lo), \
		bit_pos_range_lo)
`define GET_CLEARED_BITS(to_clear, mask) (to_clear & (~mask))
`define GET_CLEARED_BITS_WITH_RANGE(to_clear, bit_pos_range_hi, bit_pos_range_lo) \
	`GET_CLEARED_BITS(to_clear, (`BPRANGE_TO_MASK(bit_pos_range_hi, \
	bit_pos_range_lo) << bit_pos_range_lo))

`define GET_SET_BITS(to_set, mask) (to_set | mask)
`define GET_SET_BITS_WITH_RANGE(to_set, val, bit_pos_range_hi, bit_pos_range_hi) \
	`GET_SET_BITS(to_set, ((val & `BPRANGE_TO_MASK(bit_pos_range_hi, \
	bit_pos_range_lo)) << bit_pos_range_lo))

`define WIDTH__SLICE_64_TO_8 (64 / 8)
`define MSB_POS__SLICE_64_TO_8 `WIDTH2MP(`WIDTH__SLICE_64_TO_8)

`define WIDTH__SLICE_64_TO_16 (64 / 16)
`define MSB_POS__SLICE_64_TO_16 `WIDTH2MP(`WIDTH__SLICE_64_TO_16)

`define WIDTH__SLICE_64_TO_32 (64 / 32)
`define MSB_POS__SLICE_64_TO_32 `WIDTH2MP(`WIDTH__SLICE_64_TO_32)

`define WIDTH__SLICE_64_TO_64 (64 / 64)
`define MSB_POS__SLICE_64_TO_64 `WIDTH2MP(`WIDTH__SLICE_64_TO_64)

`define WIDTH__SNOW64_COUNT_LEADING_ZEROS_16_IN 16
`define MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_IN \
	`WIDTH2MP(`WIDTH__SNOW64_COUNT_LEADING_ZEROS_16_IN)
`define WIDTH__SNOW64_COUNT_LEADING_ZEROS_32_IN 32
`define MSB_POS__SNOW64_COUNT_LEADING_ZEROS_32_IN \
	`WIDTH2MP(`WIDTH__SNOW64_COUNT_LEADING_ZEROS_32_IN)
`define WIDTH__SNOW64_COUNT_LEADING_ZEROS_64_IN 64
`define MSB_POS__SNOW64_COUNT_LEADING_ZEROS_64_IN \
	`WIDTH2MP(`WIDTH__SNOW64_COUNT_LEADING_ZEROS_64_IN)


// 5 because the number itself may be zero (meaning we have 16 leading
// zeros)

`define WIDTH__SNOW64_COUNT_LEADING_ZEROS_16_OUT 5
`define MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_OUT \
	`WIDTH2MP(`WIDTH__SNOW64_COUNT_LEADING_ZEROS_16_OUT)

`define WIDTH__SNOW64_COUNT_LEADING_ZEROS_32_OUT 6
`define MSB_POS__SNOW64_COUNT_LEADING_ZEROS_32_OUT \
	`WIDTH2MP(`WIDTH__SNOW64_COUNT_LEADING_ZEROS_32_OUT)

`define WIDTH__SNOW64_COUNT_LEADING_ZEROS_64_OUT 7
`define MSB_POS__SNOW64_COUNT_LEADING_ZEROS_64_OUT \
	`WIDTH2MP(`WIDTH__SNOW64_COUNT_LEADING_ZEROS_64_OUT)

`define EXTRACT_DATA_INDEX__8(msb_pos, to_extract_from) \
	{to_extract_from[msb_pos:0]}

`define EXTRACT_DATA_INDEX__16(msb_pos, to_extract_from) \
	{to_extract_from[msb_pos:1], 1'b0}

`define EXTRACT_DATA_INDEX__32(msb_pos, to_extract_from) \
	{to_extract_from[msb_pos:2], 2'b0}

`define EXTRACT_DATA_INDEX__64(msb_pos, to_extract_from) \
	{to_extract_from[msb_pos:3], 3'b0}

`define EXTRACT_DATA_INDEX_TYPE_2__8(msb_pos, to_extract_from) \
	to_extract_from[msb_pos:0]

`define EXTRACT_DATA_INDEX_TYPE_2__16(msb_pos, to_extract_from) \
	to_extract_from[msb_pos:1]

`define EXTRACT_DATA_INDEX_TYPE_2__32(msb_pos, to_extract_from) \
	to_extract_from[msb_pos:2]

`define EXTRACT_DATA_INDEX_TYPE_2__64(msb_pos, to_extract_from) \
	to_extract_from[msb_pos:3]

`define DOWNCAST_TO_8(to_cast) (to_cast[`WIDTH2MP(8):0])
`define DOWNCAST_TO_16(to_cast) (to_cast[`WIDTH2MP(16):0])
`define DOWNCAST_TO_32(to_cast) (to_cast[`WIDTH2MP(32):0])


`endif		// src__slash__misc_defines_header_sv
