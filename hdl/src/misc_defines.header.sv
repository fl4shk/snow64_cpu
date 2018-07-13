`ifndef src__slash__misc_defines_header_sv
`define src__slash__misc_defines_header_sv

// src/misc_defines.header.sv

`default_nettype none

`define WIDTH2MP(some_width) ((some_width) - 1)
`define ARR_SIZE_TO_LAST_INDEX(some_arr_size) ((some_arr_size) - 1)

`define SIGN_EXTEND(some_full_width, some_width_of_arg, some_arg) \
	{{(some_full_width - some_width_of_arg) \
	{some_arg[`WIDTH2MP(some_width_of_arg)]}},some_arg}
//`define SIGN_EXTEND_SLICED(some_full_width, some_width_of_arg, 
//	some_non_sliced_arg, some_other_arg) \
//	{{(some_full_width - some_width_of_arg) \
//	{some_non_sliced_arg[`WIDTH2MP(some_width_of_arg)]}},some_other_arg}
`define ZERO_EXTEND(some_full_width, some_width_of_arg, some_other_arg) \
	{{(some_full_width - some_width_of_arg) {1'b0}},some_other_arg}


`define INDEX64_8__7_H 63
`define INDEX64_8__7_L 56
`define INDEX64_8__6_H 55
`define INDEX64_8__6_L 48
`define INDEX64_8__5_H 47
`define INDEX64_8__5_L 40
`define INDEX64_8__4_H 39
`define INDEX64_8__4_L 32
`define INDEX64_8__3_H 31
`define INDEX64_8__3_L 24
`define INDEX64_8__2_H 23
`define INDEX64_8__2_L 16
`define INDEX64_8__1_H 15
`define INDEX64_8__1_L 8
`define INDEX64_8__0_H 7
`define INDEX64_8__0_L 0

`define INDEX64_16__3_H 63
`define INDEX64_16__3_L 48
`define INDEX64_16__2_H 47
`define INDEX64_16__2_L 32
`define INDEX64_16__1_H 31
`define INDEX64_16__1_L 16
`define INDEX64_16__0_H 15
`define INDEX64_16__0_L 0

`define INDEX64_32__1_H 63
`define INDEX64_32__1_L 32
`define INDEX64_32__0_H 31
`define INDEX64_32__0_L 0

`define SLICE64_32__1 [`INDEX64_32__1_H : `INDEX64_32__1_L]
`define SLICE64_32__0 [`INDEX64_32__0_H : `INDEX64_32__0_L]

`define SLICE64_16__3 [`INDEX64_16__3_H : `INDEX64_16__3_L]
`define SLICE64_16__2 [`INDEX64_16__2_H : `INDEX64_16__2_L]
`define SLICE64_16__1 [`INDEX64_16__1_H : `INDEX64_16__1_L]
`define SLICE64_16__0 [`INDEX64_16__0_H : `INDEX64_16__0_L]

`define SLICE64_8__7 [`INDEX64_8__7_H : `INDEX64_8__7_L]
`define SLICE64_8__6 [`INDEX64_8__6_H : `INDEX64_8__6_L]
`define SLICE64_8__5 [`INDEX64_8__5_H : `INDEX64_8__5_L]
`define SLICE64_8__4 [`INDEX64_8__4_H : `INDEX64_8__4_L]
`define SLICE64_8__3 [`INDEX64_8__3_H : `INDEX64_8__3_L]
`define SLICE64_8__2 [`INDEX64_8__2_H : `INDEX64_8__2_L]
`define SLICE64_8__1 [`INDEX64_8__1_H : `INDEX64_8__1_L]
`define SLICE64_8__0 [`INDEX64_8__0_H : `INDEX64_8__0_L]

//`define ID_INST_8__7 _64_0
//`define ID_INST_8__6 _32_0
//`define ID_INST_8__5 _16_1
//`define ID_INST_8__4 _16_0
//`define ID_INST_8__3 _8_3
//`define ID_INST_8__2 _8_2
//`define ID_INST_8__1 _8_1
//`define ID_INST_8__0 _8_0
//
//`define ID_INST_16__3 `ID_INST_8__7
//`define ID_INST_16__2 `ID_INST_8__6
//`define ID_INST_16__1 `ID_INST_8__5
//`define ID_INST_16__0 `ID_INST_8__4
//
//`define ID_INST_32__1 `ID_INST_8__7
//`define ID_INST_32__0 `ID_INST_8__6
//
//`define ID_INST_64__0 `ID_INST_8__7

`define INST_8__7(prefix) prefix``_64_0
`define INST_8__6(prefix) prefix``_32_0
`define INST_8__5(prefix) prefix``_16_1
`define INST_8__4(prefix) prefix``_16_0
`define INST_8__3(prefix) prefix``_8_3
`define INST_8__2(prefix) prefix``_8_2
`define INST_8__1(prefix) prefix``_8_1
`define INST_8__0(prefix) prefix``_8_0

`define INST_8__7_S(prefix, suffix) prefix``_64_0``suffix
`define INST_8__6_S(prefix, suffix) prefix``_32_0``suffix
`define INST_8__5_S(prefix, suffix) prefix``_16_1``suffix
`define INST_8__4_S(prefix, suffix) prefix``_16_0``suffix
`define INST_8__3_S(prefix, suffix) prefix``_8_3``suffix
`define INST_8__2_S(prefix, suffix) prefix``_8_2``suffix
`define INST_8__1_S(prefix, suffix) prefix``_8_1``suffix
`define INST_8__0_S(prefix, suffix) prefix``_8_0``suffix

`define WIDTH__INST_8__7__DATA_INOUT 64
`define MSB_POS__INST_8__7__DATA_INOUT \
	`WIDTH2MP(`WIDTH__INST_8__7__DATA_INOUT)
`define WIDTH__INST_8__6__DATA_INOUT 32
`define MSB_POS__INST_8__6__DATA_INOUT \
	`WIDTH2MP(`WIDTH__INST_8__6__DATA_INOUT)
`define WIDTH__INST_8__5__DATA_INOUT 16
`define MSB_POS__INST_8__5__DATA_INOUT \
	`WIDTH2MP(`WIDTH__INST_8__5__DATA_INOUT)
`define WIDTH__INST_8__4__DATA_INOUT 16
`define MSB_POS__INST_8__4__DATA_INOUT \
	`WIDTH2MP(`WIDTH__INST_8__4__DATA_INOUT)
`define WIDTH__INST_8__3__DATA_INOUT 8
`define MSB_POS__INST_8__3__DATA_INOUT \
	`WIDTH2MP(`WIDTH__INST_8__3__DATA_INOUT)
`define WIDTH__INST_8__2__DATA_INOUT 8
`define MSB_POS__INST_8__2__DATA_INOUT \
	`WIDTH2MP(`WIDTH__INST_8__2__DATA_INOUT)
`define WIDTH__INST_8__1__DATA_INOUT 8
`define MSB_POS__INST_8__1__DATA_INOUT \
	`WIDTH2MP(`WIDTH__INST_8__1__DATA_INOUT)
`define WIDTH__INST_8__0__DATA_INOUT 8
`define MSB_POS__INST_8__0__DATA_INOUT \
	`WIDTH2MP(`WIDTH__INST_8__0__DATA_INOUT)


`define INST_16__3(prefix) `INST_8__7(prefix)
`define INST_16__2(prefix) `INST_8__6(prefix)
`define INST_16__1(prefix) `INST_8__5(prefix)
`define INST_16__0(prefix) `INST_8__4(prefix)

`define INST_16__3_S(prefix, suffix) `INST_8__7(prefix)``suffix
`define INST_16__2_S(prefix, suffix) `INST_8__6(prefix)``suffix
`define INST_16__1_S(prefix, suffix) `INST_8__5(prefix)``suffix
`define INST_16__0_S(prefix, suffix) `INST_8__4(prefix)``suffix

`define WIDTH__INST_16__3__DATA_INOUT 64
`define MSB_POS__INST_16__3__DATA_INOUT \
	`WIDTH2MP(`WIDTH__INST_16__3__DATA_INOUT)
`define WIDTH__INST_16__2__DATA_INOUT 32
`define MSB_POS__INST_16__2__DATA_INOUT \
	`WIDTH2MP(`WIDTH__INST_16__2__DATA_INOUT)
`define WIDTH__INST_16__1__DATA_INOUT 16
`define MSB_POS__INST_16__1__DATA_INOUT \
	`WIDTH2MP(`WIDTH__INST_16__1__DATA_INOUT)
`define WIDTH__INST_16__0__DATA_INOUT 16
`define MSB_POS__INST_16__0__DATA_INOUT \
	`WIDTH2MP(`WIDTH__INST_16__0__DATA_INOUT)


`define INST_32__1(prefix) `INST_8__7(prefix)
`define INST_32__0(prefix) `INST_8__6(prefix)

`define INST_32__1_S(prefix, suffix) `INST_8__7(prefix)``suffix
`define INST_32__0_S(prefix, suffix) `INST_8__6(prefix)``suffix

`define WIDTH__INST_32__1__DATA_INOUT 64
`define MSB_POS__INST_32__1__DATA_INOUT \
	`WIDTH2MP(`WIDTH__INST_32__1__DATA_INOUT)
`define WIDTH__INST_32__0__DATA_INOUT 32
`define MSB_POS__INST_32__0__DATA_INOUT \
	`WIDTH2MP(`WIDTH__INST_32__0__DATA_INOUT)



`define INST_64__0(prefix) `INST_8__7(prefix)

`define INST_64__0_S(prefix, suffix) `INST_8__7(prefix)``suffix

`define WIDTH__INST_64__0__DATA_INOUT 64
`define MSB_POS__INST_64__0__DATA_INOUT \
	`WIDTH2MP(`WIDTH__INST_64__0__DATA_INOUT)

`define WIDTH__SNOW64_COUNT_LEADING_ZEROS_16_IN 16
`define MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_IN \
	`WIDTH2MP(`WIDTH__SNOW64_COUNT_LEADING_ZEROS_16_IN)


// 5 because the number itself may be zero (meaning we have 16 leading
// zeros)

`define WIDTH__SNOW64_COUNT_LEADING_ZEROS_16_OUT 5
`define MSB_POS__SNOW64_COUNT_LEADING_ZEROS_16_OUT \
	`WIDTH2MP(`WIDTH__SNOW64_COUNT_LEADING_ZEROS_16_OUT)

`endif		// src__slash__misc_defines_header_sv
