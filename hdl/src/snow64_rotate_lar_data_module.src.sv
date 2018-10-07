`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"
`include "src/snow64_pipe_stage_structs.header.sv"

// Rotate left
module Snow64RotateLarData
	(input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] in_to_rotate,
	input logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET:0]
		in_src_data_offset, in_dest_data_offset,
	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		out_data_8, out_data_16, out_data_32, out_data_64);


	localparam __MSB_POS__DATA = `MSB_POS__SNOW64_LAR_FILE_DATA;

	localparam __MSB_POS__DATA_OFFSET
		= `MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET;

	localparam __LSB_POS__DATA_OFFSET_8 = 0;
	localparam __LSB_POS__DATA_OFFSET_16 = 1;
	localparam __LSB_POS__DATA_OFFSET_32 = 2;
	localparam __LSB_POS__DATA_OFFSET_64 = 3;



	wire [__MSB_POS__DATA_OFFSET - __LSB_POS__DATA_OFFSET_8:0]
		__rotate_amount_8
		= in_dest_data_offset
		[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_8]
		- in_src_data_offset
		[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_8];
	wire [__MSB_POS__DATA_OFFSET - __LSB_POS__DATA_OFFSET_16:0]
		__rotate_amount_16
		= in_dest_data_offset
		[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_16]
		- in_src_data_offset
		[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_16];
	wire [__MSB_POS__DATA_OFFSET - __LSB_POS__DATA_OFFSET_32:0]
		__rotate_amount_32
		= in_dest_data_offset
		[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_32]
		- in_src_data_offset
		[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_32];
	wire [__MSB_POS__DATA_OFFSET - __LSB_POS__DATA_OFFSET_64:0]
		__rotate_amount_64
		= in_dest_data_offset
		[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_64]
		- in_src_data_offset
		[__MSB_POS__DATA_OFFSET:__LSB_POS__DATA_OFFSET_64];


	initial
	begin
		{out_data_8, out_data_16, out_data_32, out_data_64} = 0;
	end
	`define PERF_ROTATE(width, num) \
		num: out_data_``width \
			= {in_to_rotate[`WIDTH2MP(256 - (num * width)):0], \
			in_to_rotate[`WIDTH2MP(256):(256 - (num * width))]}
	always @(*)
	begin
		case (__rotate_amount_8)
		0: out_data_8 = in_to_rotate;
		`PERF_ROTATE(8, 1);
		`PERF_ROTATE(8, 2); `PERF_ROTATE(8, 3);
		`PERF_ROTATE(8, 4); `PERF_ROTATE(8, 5);
		`PERF_ROTATE(8, 6); `PERF_ROTATE(8, 7);
		`PERF_ROTATE(8, 8); `PERF_ROTATE(8, 9);
		`PERF_ROTATE(8, 10); `PERF_ROTATE(8, 11);
		`PERF_ROTATE(8, 12); `PERF_ROTATE(8, 13);
		`PERF_ROTATE(8, 14); `PERF_ROTATE(8, 15);
		`PERF_ROTATE(8, 16); `PERF_ROTATE(8, 17);
		`PERF_ROTATE(8, 18); `PERF_ROTATE(8, 19);
		`PERF_ROTATE(8, 20); `PERF_ROTATE(8, 21);
		`PERF_ROTATE(8, 22); `PERF_ROTATE(8, 23);
		`PERF_ROTATE(8, 24); `PERF_ROTATE(8, 25);
		`PERF_ROTATE(8, 26); `PERF_ROTATE(8, 27);
		`PERF_ROTATE(8, 28); `PERF_ROTATE(8, 29);
		`PERF_ROTATE(8, 30); `PERF_ROTATE(8, 31);
		endcase
	end

	always @(*)
	begin
		case (__rotate_amount_16)
		0: out_data_16 = in_to_rotate;
		`PERF_ROTATE(16, 1);
		`PERF_ROTATE(16, 2); `PERF_ROTATE(16, 3);
		`PERF_ROTATE(16, 4); `PERF_ROTATE(16, 5);
		`PERF_ROTATE(16, 6); `PERF_ROTATE(16, 7);
		`PERF_ROTATE(16, 8); `PERF_ROTATE(16, 9);
		`PERF_ROTATE(16, 10); `PERF_ROTATE(16, 11);
		`PERF_ROTATE(16, 12); `PERF_ROTATE(16, 13);
		`PERF_ROTATE(16, 14); `PERF_ROTATE(16, 15);
		endcase
	end

	always @(*)
	begin
		case (__rotate_amount_32)
		0: out_data_32 = in_to_rotate;
		`PERF_ROTATE(32, 1);
		`PERF_ROTATE(32, 2); `PERF_ROTATE(32, 3);
		`PERF_ROTATE(32, 4); `PERF_ROTATE(32, 5);
		`PERF_ROTATE(32, 6); `PERF_ROTATE(32, 7);
		endcase
	end

	always @(*)
	begin
		case (__rotate_amount_64)
		0: out_data_64 = in_to_rotate;
		`PERF_ROTATE(64, 1);
		`PERF_ROTATE(64, 2); `PERF_ROTATE(64, 3);
		endcase
	end
	`undef PERF_ROTATE

endmodule
