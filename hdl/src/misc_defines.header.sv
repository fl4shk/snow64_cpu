`ifndef src__slash__misc_defines_header_sv
`define src__slash__misc_defines_header_sv

// src/misc_defines.header.sv

`define WIDTH2MP(some_width) ((some_width) - 1)
`define ARR_SIZE_TO_LAST_INDEX(some_arr_size) ((some_arr_size) - 1)

`define SIGN_EXTEND(some_full_width, some_width_of_simm, some_simm) \
	{{(some_full_width - some_width_of_simm) \
	{some_simm[`WIDTH2MP(some_width_of_simm)]}},some_simm}
`define ZERO_EXTEND(some_full_width, some_width_of_imm, some_imm) \
	{{(some_full_width - some_width_of_imm) \
	{1'b0}},some_imm}

`endif		// src__slash__misc_defines_header_sv
