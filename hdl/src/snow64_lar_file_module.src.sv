`include "src/snow64_lar_file_defines.header.sv"

// Use block RAM to implement the shareddata's "data" field.
module __Snow64LarFileShareddataData(input logic clk,
	input logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0]
		in_rd_a_index, in_rd_b_index, in_rd_c_index, in_rd_for_wr_index,
		in_wr_index,
	input logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] in_wr_data,
	input logic in_wr_req,
	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		out_rd_a_data, out_rd_b_data, out_rd_c_data, out_rd_for_wr_data
		`ifdef FORMAL
		,
	output logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		out_debug_data_0, out_debug_data_1,
		out_debug_data_2, out_debug_data_3,
		out_debug_data_4, out_debug_data_5,
		out_debug_data_6, out_debug_data_7,
		out_debug_data_8, out_debug_data_9,
		out_debug_data_10, out_debug_data_11,
		out_debug_data_12, out_debug_data_13,
		out_debug_data_14, out_debug_data_15
		`endif		// FORMAL
		);

	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__arr[`ARR_SIZE__SNOW64_LAR_FILE_NUM_LARS];

	initial
	begin
		integer __i;

		for (__i=0; __i<`ARR_SIZE__SNOW64_LAR_FILE_NUM_LARS; __i=__i+1)
		begin
			__arr[__i] = 0;
		end
	end

	//// Asynchronous reads
	////always @(*)
	//always_ff @(posedge clk)
	//begin
	//	//out_rd_a_data = __arr[in_rd_a_index];
	//	out_rd_a_data <= __arr[in_rd_a_index];
	//end
	////always @(*)
	//always_ff @(posedge clk)
	//begin
	//	//out_rd_b_data = __arr[in_rd_b_index];
	//	out_rd_b_data <= __arr[in_rd_b_index];
	//end
	////always @(*)
	//always_ff @(posedge clk)
	//begin
	//	//out_rd_c_data = __arr[in_rd_c_index];
	//	out_rd_c_data <= __arr[in_rd_c_index];
	//end
	//always @(posedge clk)
	//begin
	//	out_rd_a_data <= __arr[in_rd_a_index];
	//	out_rd_b_data <= __arr[in_rd_b_index];
	//	out_rd_c_data <= __arr[in_rd_c_index];
	//	out_rd_for_wr_data <= __arr[in_rd_for_wr_index];
	//end
	assign out_rd_a_data = __arr[in_rd_a_index];
	assign out_rd_b_data = __arr[in_rd_b_index];
	assign out_rd_c_data = __arr[in_rd_c_index];
	assign out_rd_for_wr_data = __arr[in_rd_for_wr_index];
	//always @(*)
	//begin
	//	if ((in_rd_a_index == in_wr_index) && in_wr_req)
	//	begin
	//		out_rd_a_data = in_wr_data;
	//	end
	//	else
	//	begin
	//		out_rd_a_data = __arr[in_rd_a_index];
	//	end
	//end
	//always @(*)
	//begin
	//	if ((in_rd_b_index == in_wr_index) && in_wr_req)
	//	begin
	//		out_rd_b_data = in_wr_data;
	//	end
	//	else
	//	begin
	//		out_rd_b_data = __arr[in_rd_b_index];
	//	end
	//end
	//always @(*)
	//begin
	//	if ((in_rd_c_index == in_wr_index) && in_wr_req)
	//	begin
	//		out_rd_c_data = in_wr_data;
	//	end
	//	else
	//	begin
	//		out_rd_c_data = __arr[in_rd_c_index];
	//	end
	//end
	//always @(*)
	//begin
	//	if ((in_rd_for_wr_index == in_wr_index) && in_wr_req)
	//	begin
	//		out_rd_for_wr_data = in_wr_data;
	//	end
	//	else
	//	begin
	//		out_rd_for_wr_data = __arr[in_rd_for_wr_index];
	//	end
	//end

	`ifdef FORMAL
	assign out_debug_data_0 = __arr[0];
	assign out_debug_data_1 = __arr[1];
	assign out_debug_data_2 = __arr[2];
	assign out_debug_data_3 = __arr[3];

	`ifndef SMALL_LAR_FILE
	assign out_debug_data_4 = __arr[4];
	assign out_debug_data_5 = __arr[5];
	assign out_debug_data_6 = __arr[6];
	assign out_debug_data_7 = __arr[7];
	assign out_debug_data_8 = __arr[8];
	assign out_debug_data_9 = __arr[9];
	assign out_debug_data_10 = __arr[10];
	assign out_debug_data_11 = __arr[11];
	assign out_debug_data_12 = __arr[12];
	assign out_debug_data_13 = __arr[13];
	assign out_debug_data_14 = __arr[14];
	assign out_debug_data_15 = __arr[15];
	`else		// if (defined(SMALL_LAR_FILE))
	assign out_debug_data_4 = 0;
	assign out_debug_data_5 = 0;
	assign out_debug_data_6 = 0;
	assign out_debug_data_7 = 0;
	assign out_debug_data_8 = 0;
	assign out_debug_data_9 = 0;
	assign out_debug_data_10 = 0;
	assign out_debug_data_11 = 0;
	assign out_debug_data_12 = 0;
	assign out_debug_data_13 = 0;
	assign out_debug_data_14 = 0;
	assign out_debug_data_15 = 0;
	`endif		// (!defined(SMALL_LAR_FILE))
	`endif		// FORMAL

	always_ff @(posedge clk)
	begin
		if (in_wr_req)
		begin
			__arr[in_wr_index] <= in_wr_data;
		end
	end

endmodule

module __Snow64LarFileTagSearch
	(input logic [`MSB_POS__SNOW64_CPU_ADDR:0] in_addr,
	input logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		in_lar_shareddata__base_addr_0, in_lar_shareddata__base_addr_1,
		in_lar_shareddata__base_addr_2, in_lar_shareddata__base_addr_3,
		in_lar_shareddata__base_addr_4, in_lar_shareddata__base_addr_5,
		in_lar_shareddata__base_addr_6, in_lar_shareddata__base_addr_7,
		in_lar_shareddata__base_addr_8, in_lar_shareddata__base_addr_9,
		in_lar_shareddata__base_addr_10, in_lar_shareddata__base_addr_11,
		in_lar_shareddata__base_addr_12, in_lar_shareddata__base_addr_13,
		in_lar_shareddata__base_addr_14, in_lar_shareddata__base_addr_15,
	input logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_REF_COUNT:0]
		in_lar_shareddata__ref_count_0, in_lar_shareddata__ref_count_1,
		in_lar_shareddata__ref_count_2, in_lar_shareddata__ref_count_3,
		in_lar_shareddata__ref_count_4, in_lar_shareddata__ref_count_5,
		in_lar_shareddata__ref_count_6, in_lar_shareddata__ref_count_7,
		in_lar_shareddata__ref_count_8, in_lar_shareddata__ref_count_9,
		in_lar_shareddata__ref_count_10, in_lar_shareddata__ref_count_11,
		in_lar_shareddata__ref_count_12, in_lar_shareddata__ref_count_13,
		in_lar_shareddata__ref_count_14, in_lar_shareddata__ref_count_15,
	output logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0] out);

	PkgSnow64LarFile::LarIncomingBaseAddr __in_wr__incoming_base_addr;
	assign __in_wr__incoming_base_addr = in_addr;

	wire [`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0]
		__tag_search_1,
		__tag_search_2, __tag_search_3,
		__tag_search_4, __tag_search_5,
		__tag_search_6, __tag_search_7,
		__tag_search_8, __tag_search_9,
		__tag_search_10, __tag_search_11,
		__tag_search_12, __tag_search_13,
		__tag_search_14, __tag_search_15,

		__tag_search_2_to_3,
		__tag_search_4_to_5, __tag_search_6_to_7,
		__tag_search_8_to_9, __tag_search_10_to_11,
		__tag_search_12_to_13, __tag_search_14_to_15,

		__tag_search_1_to_3, __tag_search_4_to_7,
		__tag_search_8_to_11, __tag_search_12_to_15,

		__tag_search_1_to_7, __tag_search_8_to_15;

	`define DO_TAG_SEARCH(index) \
		((in_lar_shareddata__ref_count_``index \
		&& (in_lar_shareddata__base_addr_``index \
		== __in_wr__incoming_base_addr.base_addr)) \
		? index : 0)

	assign __tag_search_1 = `DO_TAG_SEARCH(1);
	assign __tag_search_2 = `DO_TAG_SEARCH(2);
	assign __tag_search_3 = `DO_TAG_SEARCH(3);

	`ifdef SMALL_LAR_FILE
	assign __tag_search_4 = 0;
	assign __tag_search_5 = 0;
	assign __tag_search_6 = 0;
	assign __tag_search_7 = 0;
	assign __tag_search_8 = 0;
	assign __tag_search_9 = 0;
	assign __tag_search_10 = 0;
	assign __tag_search_11 = 0;
	assign __tag_search_12 = 0;
	assign __tag_search_13 = 0;
	assign __tag_search_14 = 0;
	assign __tag_search_15 = 0;
	`else // if (!defined(SMALL_LAR_FILE))
	assign __tag_search_4 = `DO_TAG_SEARCH(4);
	assign __tag_search_5 = `DO_TAG_SEARCH(5);
	assign __tag_search_6 = `DO_TAG_SEARCH(6);
	assign __tag_search_7 = `DO_TAG_SEARCH(7);
	assign __tag_search_8 = `DO_TAG_SEARCH(8);
	assign __tag_search_9 = `DO_TAG_SEARCH(9);
	assign __tag_search_10 = `DO_TAG_SEARCH(10);
	assign __tag_search_11 = `DO_TAG_SEARCH(11);
	assign __tag_search_12 = `DO_TAG_SEARCH(12);
	assign __tag_search_13 = `DO_TAG_SEARCH(13);
	assign __tag_search_14 = `DO_TAG_SEARCH(14);
	assign __tag_search_15 = `DO_TAG_SEARCH(15);
	`endif		// (defined(SMALL_LAR_FILE))

	`undef DO_TAG_SEARCH

	assign __tag_search_2_to_3 = __tag_search_2 | __tag_search_3;

	assign __tag_search_4_to_5 = __tag_search_4 | __tag_search_5;
	assign __tag_search_6_to_7 = __tag_search_6 | __tag_search_7;
	assign __tag_search_8_to_9 = __tag_search_8 | __tag_search_9;
	assign __tag_search_10_to_11 = __tag_search_10 | __tag_search_11;
	assign __tag_search_12_to_13 = __tag_search_12 | __tag_search_13;
	assign __tag_search_14_to_15 = __tag_search_14 | __tag_search_15;

	assign __tag_search_1_to_3 = __tag_search_1 | __tag_search_2_to_3;
	assign __tag_search_4_to_7
		= __tag_search_4_to_5 | __tag_search_6_to_7;
	assign __tag_search_8_to_11
		= __tag_search_8_to_9 | __tag_search_10_to_11;
	assign __tag_search_12_to_15
		= __tag_search_12_to_13 | __tag_search_14_to_15;

	assign __tag_search_1_to_7 = __tag_search_1_to_3 | __tag_search_4_to_7;
	assign __tag_search_8_to_15
		= __tag_search_8_to_11 | __tag_search_12_to_15;
	assign out = __tag_search_1_to_7 | __tag_search_8_to_15;

endmodule


module Snow64LarFile(input logic clk,
	input PkgSnow64LarFile::PortIn_LarFile in,
	output PkgSnow64LarFile::PortOut_LarFile out);


	import PkgSnow64LarFile::PartialPortIn_LarFile_Read;
	import PkgSnow64LarFile::PartialPortIn_LarFile_Write;
	import PkgSnow64LarFile::PartialPortIn_LarFile_MemRead;
	import PkgSnow64LarFile::PartialPortIn_LarFile_MemWrite;

	import PkgSnow64LarFile::PartialPortOut_LarFile_ReadMetadata;
	import PkgSnow64LarFile::PartialPortOut_LarFile_ReadShareddata;
	import PkgSnow64LarFile::PartialPortOut_LarFile_Write;
	import PkgSnow64LarFile::PartialPortOut_LarFile_MemRead;
	import PkgSnow64LarFile::PartialPortOut_LarFile_MemWrite;


	PartialPortIn_LarFile_Read real_in_rd_a, real_in_rd_b, real_in_rd_c;
	PartialPortIn_LarFile_Write real_in_wr, __captured_in_wr;
	PartialPortIn_LarFile_MemRead real_in_mem_read;
	PartialPortIn_LarFile_MemWrite real_in_mem_write;

	assign {real_in_rd_a, real_in_rd_b, real_in_rd_c,
		real_in_wr,
		real_in_mem_read,
		real_in_mem_write} = in;


	PartialPortOut_LarFile_ReadMetadata
		real_out_rd_metadata_a, real_out_rd_metadata_b,
		real_out_rd_metadata_c;
	PartialPortOut_LarFile_ReadShareddata
		real_out_rd_shareddata_a, real_out_rd_shareddata_b,
		real_out_rd_shareddata_c;
	PartialPortOut_LarFile_Write real_out_wr;
	PartialPortOut_LarFile_MemRead real_out_mem_read;
	PartialPortOut_LarFile_MemWrite real_out_mem_write;

	assign out = {real_out_rd_metadata_a, real_out_rd_metadata_b,
		real_out_rd_metadata_c,
		real_out_rd_shareddata_a, real_out_rd_shareddata_b,
		real_out_rd_shareddata_c,
		real_out_wr,
		real_out_mem_read,
		real_out_mem_write};



	localparam __ARR_SIZE__NUM_LARS = `ARR_SIZE__SNOW64_LAR_FILE_NUM_LARS;
	localparam __LAST_INDEX__NUM_LARS
		= `LAST_INDEX__SNOW64_LAR_FILE_NUM_LARS;


	localparam __WIDTH__LAR_FILE_DATA
		= `WIDTH__SNOW64_LAR_FILE_DATA;
	localparam __MSB_POS__LAR_FILE_DATA
		= `WIDTH2MP(__WIDTH__LAR_FILE_DATA);
	localparam __WIDTH__SCALAR_DATA
		= `WIDTH__SNOW64_SCALAR_DATA;
	localparam __MSB_POS__SCALAR_DATA
		= `WIDTH2MP(__WIDTH__SCALAR_DATA);

	localparam __WIDTH__LAR_FILE_METADATA_DATA_OFFSET
		= `WIDTH__SNOW64_LAR_FILE_METADATA_DATA_OFFSET;
	localparam __MSB_POS__LAR_FILE_METADATA_DATA_OFFSET
		= `WIDTH2MP(__WIDTH__LAR_FILE_METADATA_DATA_OFFSET);

	localparam __WIDTH__LAR_FILE_METADATA_TAG
		= `WIDTH__SNOW64_LAR_FILE_METADATA_TAG;
	localparam __MSB_POS__LAR_FILE_METADATA_TAG
		= `WIDTH2MP(__WIDTH__LAR_FILE_METADATA_TAG);

	localparam __WIDTH__CPU_ADDR
		= `WIDTH__SNOW64_CPU_ADDR;
	localparam __MSB_POS__CPU_ADDR
		= `WIDTH2MP(__WIDTH__CPU_ADDR);

	localparam __WIDTH__CPU_DATA_TYPE
		= `WIDTH__SNOW64_CPU_DATA_TYPE;
	localparam __MSB_POS__CPU_DATA_TYPE
		= `WIDTH2MP(__WIDTH__CPU_DATA_TYPE);

	localparam __WIDTH__CPU_INT_TYPE_SIZE
		= `WIDTH__SNOW64_CPU_INT_TYPE_SIZE;
	localparam __MSB_POS__CPU_INT_TYPE_SIZE
		= `WIDTH2MP(__WIDTH__CPU_INT_TYPE_SIZE);

	localparam __WIDTH__LAR_FILE_WRITE_TYPE
		= `WIDTH__SNOW64_LAR_FILE_WRITE_TYPE;
	localparam __MSB_POS__LAR_FILE_WRITE_TYPE
		= `WIDTH2MP(__WIDTH__LAR_FILE_WRITE_TYPE);

	localparam __WIDTH__LAR_FILE_WRITE_STATE
		= `WIDTH__SNOW64_LAR_FILE_WRITE_STATE;
	localparam __MSB_POS__LAR_FILE_WRITE_STATE
		= `WIDTH2MP(__WIDTH__LAR_FILE_WRITE_STATE);


	localparam __WIDTH__LAR_FILE_SHAREDDATA_BASE_ADDR
		= `WIDTH__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR;
	localparam __MSB_POS__LAR_FILE_SHAREDDATA_BASE_ADDR
		= `WIDTH2MP(__WIDTH__LAR_FILE_SHAREDDATA_BASE_ADDR);

	localparam __WIDTH__LAR_FILE_SHAREDDATA_REF_COUNT
		= `WIDTH__SNOW64_LAR_FILE_SHAREDDATA_REF_COUNT;
	localparam __MSB_POS__LAR_FILE_SHAREDDATA_REF_COUNT
		= `WIDTH2MP(__WIDTH__LAR_FILE_SHAREDDATA_REF_COUNT);

	localparam __WIDTH__LAR_FILE_SHAREDDATA_DIRTY
		= `WIDTH__SNOW64_LAR_FILE_SHAREDDATA_DIRTY;
	localparam __MSB_POS__LAR_FILE_SHAREDDATA_DIRTY
		= `WIDTH2MP(__WIDTH__LAR_FILE_SHAREDDATA_DIRTY);

	localparam __UNALLOCATED_TAG = 0;

	logic [__MSB_POS__LAR_FILE_WRITE_STATE:0] __wr_state;


	// Tag stack
	logic [__MSB_POS__LAR_FILE_METADATA_TAG:0]
		__lar_tag_stack[__ARR_SIZE__NUM_LARS];
	logic [__MSB_POS__LAR_FILE_METADATA_TAG:0]
		__curr_tag_stack_index, __above_curr_tag_stack_index,
		__captured_top_lar_tag;

	logic __captured_in_wr__shareddata_dirty_from_tag;
	logic [__MSB_POS__LAR_FILE_SHAREDDATA_REF_COUNT:0]
		__captured_in_wr__shareddata_ref_count_from_tag;
	logic [__MSB_POS__LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__captured_in_wr__shareddata_base_addr_from_tag;

	// Tag search stuff
	logic [__MSB_POS__LAR_FILE_METADATA_TAG:0]
		__captured_in_wr__tag_from_index, __captured_tag_search;
	logic [__MSB_POS__LAR_FILE_DATA:0]
		__captured_out_shareddata_data_rd_for_wr_data;

	PkgSnow64LarFile::LarIncomingBaseAddr
		__in_wr__incoming_base_addr, __captured_in_wr__base_addr;
	assign __in_wr__incoming_base_addr = real_in_wr.ldst_addr;
	assign __captured_in_wr__base_addr = __captured_in_wr.ldst_addr;

	logic __captured_in_mem_read__valid, __captured_in_mem_write__valid;

	// Metadata
	logic [__MSB_POS__LAR_FILE_METADATA_TAG:0]
		__lar_metadata__tag[__ARR_SIZE__NUM_LARS];

	logic [__MSB_POS__LAR_FILE_METADATA_DATA_OFFSET:0]
		__lar_metadata__data_offset[__ARR_SIZE__NUM_LARS];

	logic [__MSB_POS__CPU_DATA_TYPE:0]
		__lar_metadata__data_type[__ARR_SIZE__NUM_LARS];

	logic [__MSB_POS__CPU_INT_TYPE_SIZE:0]
		__lar_metadata__int_type_size[__ARR_SIZE__NUM_LARS];


	// Shared data
	wire [__MSB_POS__LAR_FILE_METADATA_TAG:0]
		__in_shareddata_data_rd_a_index, __in_shareddata_data_rd_b_index,
		__in_shareddata_data_rd_c_index,
		__in_shareddata_data_rd_for_wr_index;
	assign __in_shareddata_data_rd_for_wr_index
		= __lar_metadata__tag[real_in_wr.index];

	logic [__MSB_POS__LAR_FILE_METADATA_TAG:0]
		__in_shareddata_data_wr_index;
	logic [__MSB_POS__LAR_FILE_DATA:0] __in_shareddata_data_wr_data;
	logic __in_shareddata_data_wr_req;
	wire [__MSB_POS__LAR_FILE_DATA:0] __out_shareddata_data_rd_a_data,
		__out_shareddata_data_rd_b_data, __out_shareddata_data_rd_c_data,
		__out_shareddata_data_rd_for_wr_data;

	`ifdef FORMAL
	wire [__MSB_POS__LAR_FILE_DATA:0]
		__out_shareddata_data_debug_data_0,
		__out_shareddata_data_debug_data_1,
		__out_shareddata_data_debug_data_2,
		__out_shareddata_data_debug_data_3,
		__out_shareddata_data_debug_data_4,
		__out_shareddata_data_debug_data_5,
		__out_shareddata_data_debug_data_6,
		__out_shareddata_data_debug_data_7,
		__out_shareddata_data_debug_data_8,
		__out_shareddata_data_debug_data_9,
		__out_shareddata_data_debug_data_10,
		__out_shareddata_data_debug_data_11,
		__out_shareddata_data_debug_data_12,
		__out_shareddata_data_debug_data_13,
		__out_shareddata_data_debug_data_14,
		__out_shareddata_data_debug_data_15;
	`endif		// FORMAL
	__Snow64LarFileShareddataData __inst_shareddata_data(.clk(clk),
		.in_rd_a_index(__in_shareddata_data_rd_a_index),
		.in_rd_b_index(__in_shareddata_data_rd_b_index),
		.in_rd_c_index(__in_shareddata_data_rd_c_index),
		.in_rd_for_wr_index(__in_shareddata_data_rd_for_wr_index),
		.in_wr_index(__in_shareddata_data_wr_index),
		.in_wr_data(__in_shareddata_data_wr_data),
		.in_wr_req(__in_shareddata_data_wr_req),
		.out_rd_a_data(__out_shareddata_data_rd_a_data),
		.out_rd_b_data(__out_shareddata_data_rd_b_data),
		.out_rd_c_data(__out_shareddata_data_rd_c_data),
		.out_rd_for_wr_data(__out_shareddata_data_rd_for_wr_data)
		`ifdef FORMAL
		,
		.out_debug_data_0(__out_shareddata_data_debug_data_0),
		.out_debug_data_1(__out_shareddata_data_debug_data_1),
		.out_debug_data_2(__out_shareddata_data_debug_data_2),
		.out_debug_data_3(__out_shareddata_data_debug_data_3),
		.out_debug_data_4(__out_shareddata_data_debug_data_4),
		.out_debug_data_5(__out_shareddata_data_debug_data_5),
		.out_debug_data_6(__out_shareddata_data_debug_data_6),
		.out_debug_data_7(__out_shareddata_data_debug_data_7),
		.out_debug_data_8(__out_shareddata_data_debug_data_8),
		.out_debug_data_9(__out_shareddata_data_debug_data_9),
		.out_debug_data_10(__out_shareddata_data_debug_data_10),
		.out_debug_data_11(__out_shareddata_data_debug_data_11),
		.out_debug_data_12(__out_shareddata_data_debug_data_12),
		.out_debug_data_13(__out_shareddata_data_debug_data_13),
		.out_debug_data_14(__out_shareddata_data_debug_data_14),
		.out_debug_data_15(__out_shareddata_data_debug_data_15)
		`endif		// FORMAL
		);


	// These two arrays are essentially forced to be implemented as arrays
	// of logic due to the tag search.
	logic [__MSB_POS__LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__lar_shareddata__base_addr[__ARR_SIZE__NUM_LARS];
	logic [__MSB_POS__LAR_FILE_SHAREDDATA_REF_COUNT:0]
		__lar_shareddata__ref_count[__ARR_SIZE__NUM_LARS];

	// This needs to be implemented as block RAM.
	logic [__MSB_POS__LAR_FILE_SHAREDDATA_DIRTY:0]
		__lar_shareddata__dirty[__ARR_SIZE__NUM_LARS];

	`ifdef SMALL_LAR_FILE
	wire [__MSB_POS__LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__in_tag_search_dummy_base_addr = 0;
	wire [__MSB_POS__LAR_FILE_SHAREDDATA_REF_COUNT:0]
		__in_tag_search_dummy_ref_count = 0;
	`endif		// SMALL_LAR_FILE
	wire [__MSB_POS__LAR_FILE_METADATA_TAG:0] __out_tag_search;
	__Snow64LarFileTagSearch __inst_tag_search
		(.in_addr(real_in_wr.ldst_addr),
		.in_lar_shareddata__base_addr_0(__lar_shareddata__base_addr[0]),
		.in_lar_shareddata__base_addr_1(__lar_shareddata__base_addr[1]),
		.in_lar_shareddata__base_addr_2(__lar_shareddata__base_addr[2]),
		.in_lar_shareddata__base_addr_3(__lar_shareddata__base_addr[3]),
		`ifdef SMALL_LAR_FILE
		.in_lar_shareddata__base_addr_4(__in_tag_search_dummy_base_addr),
		.in_lar_shareddata__base_addr_5(__in_tag_search_dummy_base_addr),
		.in_lar_shareddata__base_addr_6(__in_tag_search_dummy_base_addr),
		.in_lar_shareddata__base_addr_7(__in_tag_search_dummy_base_addr),
		.in_lar_shareddata__base_addr_8(__in_tag_search_dummy_base_addr),
		.in_lar_shareddata__base_addr_9(__in_tag_search_dummy_base_addr),
		.in_lar_shareddata__base_addr_10(__in_tag_search_dummy_base_addr),
		.in_lar_shareddata__base_addr_11(__in_tag_search_dummy_base_addr),
		.in_lar_shareddata__base_addr_12(__in_tag_search_dummy_base_addr),
		.in_lar_shareddata__base_addr_13(__in_tag_search_dummy_base_addr),
		.in_lar_shareddata__base_addr_14(__in_tag_search_dummy_base_addr),
		.in_lar_shareddata__base_addr_15(__in_tag_search_dummy_base_addr),
		`else // if (!defined(SMALL_LAR_FILE))
		.in_lar_shareddata__base_addr_4(__lar_shareddata__base_addr[4]),
		.in_lar_shareddata__base_addr_5(__lar_shareddata__base_addr[5]),
		.in_lar_shareddata__base_addr_6(__lar_shareddata__base_addr[6]),
		.in_lar_shareddata__base_addr_7(__lar_shareddata__base_addr[7]),
		.in_lar_shareddata__base_addr_8(__lar_shareddata__base_addr[8]),
		.in_lar_shareddata__base_addr_9(__lar_shareddata__base_addr[9]),
		.in_lar_shareddata__base_addr_10(__lar_shareddata__base_addr[10]),
		.in_lar_shareddata__base_addr_11(__lar_shareddata__base_addr[11]),
		.in_lar_shareddata__base_addr_12(__lar_shareddata__base_addr[12]),
		.in_lar_shareddata__base_addr_13(__lar_shareddata__base_addr[13]),
		.in_lar_shareddata__base_addr_14(__lar_shareddata__base_addr[14]),
		.in_lar_shareddata__base_addr_15(__lar_shareddata__base_addr[15]),
		`endif		// SMALL_LAR_FILE
		.in_lar_shareddata__ref_count_0(__lar_shareddata__ref_count[0]),
		.in_lar_shareddata__ref_count_1(__lar_shareddata__ref_count[1]),
		.in_lar_shareddata__ref_count_2(__lar_shareddata__ref_count[2]),
		.in_lar_shareddata__ref_count_3(__lar_shareddata__ref_count[3]),
		`ifdef SMALL_LAR_FILE
		.in_lar_shareddata__ref_count_4(__in_tag_search_dummy_ref_count),
		.in_lar_shareddata__ref_count_5(__in_tag_search_dummy_ref_count),
		.in_lar_shareddata__ref_count_6(__in_tag_search_dummy_ref_count),
		.in_lar_shareddata__ref_count_7(__in_tag_search_dummy_ref_count),
		.in_lar_shareddata__ref_count_8(__in_tag_search_dummy_ref_count),
		.in_lar_shareddata__ref_count_9(__in_tag_search_dummy_ref_count),
		.in_lar_shareddata__ref_count_10(__in_tag_search_dummy_ref_count),
		.in_lar_shareddata__ref_count_11(__in_tag_search_dummy_ref_count),
		.in_lar_shareddata__ref_count_12(__in_tag_search_dummy_ref_count),
		.in_lar_shareddata__ref_count_13(__in_tag_search_dummy_ref_count),
		.in_lar_shareddata__ref_count_14(__in_tag_search_dummy_ref_count),
		.in_lar_shareddata__ref_count_15(__in_tag_search_dummy_ref_count),
		`else // if (!defined(SMALL_LAR_FILE))
		.in_lar_shareddata__ref_count_4(__lar_shareddata__ref_count[4]),
		.in_lar_shareddata__ref_count_5(__lar_shareddata__ref_count[5]),
		.in_lar_shareddata__ref_count_6(__lar_shareddata__ref_count[6]),
		.in_lar_shareddata__ref_count_7(__lar_shareddata__ref_count[7]),
		.in_lar_shareddata__ref_count_8(__lar_shareddata__ref_count[8]),
		.in_lar_shareddata__ref_count_9(__lar_shareddata__ref_count[9]),
		.in_lar_shareddata__ref_count_10(__lar_shareddata__ref_count[10]),
		.in_lar_shareddata__ref_count_11(__lar_shareddata__ref_count[11]),
		.in_lar_shareddata__ref_count_12(__lar_shareddata__ref_count[12]),
		.in_lar_shareddata__ref_count_13(__lar_shareddata__ref_count[13]),
		.in_lar_shareddata__ref_count_14(__lar_shareddata__ref_count[14]),
		.in_lar_shareddata__ref_count_15(__lar_shareddata__ref_count[15]),
		`endif		// SMALL_LAR_FILE
		.out(__out_tag_search));



	`ifdef FORMAL
	localparam __ENUM__WRITE_TYPE__ONLY_DATA
		= PkgSnow64LarFile::WriteTypOnlyData;
	localparam __ENUM__WRITE_TYPE__DATA_AND_TYPE
		= PkgSnow64LarFile::WriteTypDataAndType;
	localparam __ENUM__WRITE_TYPE__LD = PkgSnow64LarFile::WriteTypLd;
	localparam __ENUM__WRITE_TYPE__ST = PkgSnow64LarFile::WriteTypSt;

	localparam __ENUM__WRITE_STATE__IDLE = PkgSnow64LarFile::WrStIdle;
	localparam __ENUM__WRITE_STATE__START_LD_ST
		= PkgSnow64LarFile::WrStStartLdSt;
	localparam __ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_READ
		= PkgSnow64LarFile::WrStWaitForJustMemRead;
	localparam __ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_WRITE
		= PkgSnow64LarFile::WrStWaitForJustMemWrite;
	localparam __ENUM__WRITE_STATE__WAIT_FOR_MEM_READ_AND_MEM_WRITE
		= PkgSnow64LarFile::WrStWaitForMemReadAndMemWrite;

	localparam __ENUM__DATA_TYPE__UNSGN_INT
		= PkgSnow64Cpu::DataTypUnsgnInt;
	localparam __ENUM__DATA_TYPE__SGN_INT = PkgSnow64Cpu::DataTypSgnInt;
	localparam __ENUM__DATA_TYPE__BFLOAT16 = PkgSnow64Cpu::DataTypBFloat16;
	localparam __ENUM__DATA_TYPE__RESERVED = PkgSnow64Cpu::DataTypReserved;

	localparam __ENUM__INT_TYPE_SIZE__8 = PkgSnow64Cpu::IntTypSz8;
	localparam __ENUM__INT_TYPE_SIZE__16 = PkgSnow64Cpu::IntTypSz16;
	localparam __ENUM__INT_TYPE_SIZE__32 = PkgSnow64Cpu::IntTypSz32;
	localparam __ENUM__INT_TYPE_SIZE__64 = PkgSnow64Cpu::IntTypSz64;


	wire [__MSB_POS__LAR_FILE_METADATA_TAG:0]
		__formal__in_rd_a__index
		= real_in_rd_a.index[__MSB_POS__LAR_FILE_METADATA_TAG:0],
		__formal__in_rd_b__index
		= real_in_rd_b.index[__MSB_POS__LAR_FILE_METADATA_TAG:0],
		__formal__in_rd_c__index
		= real_in_rd_c.index[__MSB_POS__LAR_FILE_METADATA_TAG:0];
	wire __formal__in_wr__req = real_in_wr.req;
	wire [__MSB_POS__LAR_FILE_WRITE_TYPE:0] __formal__in_wr__write_type
		= real_in_wr.write_type;
	wire [__MSB_POS__LAR_FILE_METADATA_TAG:0] __formal__in_wr__index
		= real_in_wr.index[__MSB_POS__LAR_FILE_METADATA_TAG:0];
	wire [__MSB_POS__LAR_FILE_DATA:0] __formal__in_wr__non_ldst_data
		= real_in_wr.non_ldst_data;
	//wire [__MSB_POS__LAR_FILE_METADATA_TAG:0] __formal__in_wr__non_ldst_tag
	//	= real_in_wr.non_ldst_tag;
	wire [__MSB_POS__CPU_ADDR:0] __formal__in_wr__ldst_addr
		= real_in_wr.ldst_addr;
	wire [__MSB_POS__CPU_DATA_TYPE:0] __formal__in_wr__data_type
		= real_in_wr.data_type;
	wire [__MSB_POS__CPU_INT_TYPE_SIZE:0] __formal__in_wr__int_type_size
		= real_in_wr.int_type_size;

	wire __formal__captured_in_wr__req = __captured_in_wr.req;
	wire [__MSB_POS__LAR_FILE_WRITE_TYPE:0]
		__formal__captured_in_wr__write_type = __captured_in_wr.write_type;
	wire [__MSB_POS__LAR_FILE_METADATA_TAG:0]
		__formal__captured_in_wr__index
		= __captured_in_wr.index[__MSB_POS__LAR_FILE_METADATA_TAG:0];
	wire [__MSB_POS__LAR_FILE_DATA:0]
		__formal__captured_in_wr__non_ldst_data
		= __captured_in_wr.non_ldst_data;
	//wire [__MSB_POS__LAR_FILE_METADATA_TAG:0]
	//	__formal__captured_in_wr__non_ldst_tag
	//	= __captured_in_wr.non_ldst_tag;
	wire [__MSB_POS__CPU_ADDR:0] __formal__captured_in_wr__ldst_addr
		= __captured_in_wr.ldst_addr;
	wire [__MSB_POS__CPU_DATA_TYPE:0] __formal__captured_in_wr__data_type
		= __captured_in_wr.data_type;
	wire [__MSB_POS__CPU_INT_TYPE_SIZE:0]
		__formal__captured_in_wr__int_type_size
		= __captured_in_wr.int_type_size;

	wire __formal__in_mem_read__valid = real_in_mem_read.valid;
	wire [__MSB_POS__LAR_FILE_DATA:0] __formal__in_mem_read__data
		= real_in_mem_read.data;

	wire __formal__in_mem_write__valid = real_in_mem_write.valid;

	wire [__MSB_POS__LAR_FILE_METADATA_TAG:0]
		__formal__out_rd_metadata_a__tag = real_out_rd_metadata_a.tag,
		__formal__out_rd_metadata_b__tag = real_out_rd_metadata_b.tag,
		__formal__out_rd_metadata_c__tag = real_out_rd_metadata_c.tag;
	wire [__MSB_POS__LAR_FILE_METADATA_DATA_OFFSET:0]
		__formal__out_rd_metadata_a__data_offset
		= real_out_rd_metadata_a.data_offset,
		__formal__out_rd_metadata_b__data_offset
		= real_out_rd_metadata_b.data_offset,
		__formal__out_rd_metadata_c__data_offset
		= real_out_rd_metadata_c.data_offset;
	wire [__MSB_POS__CPU_DATA_TYPE:0]
		__formal__out_rd_metadata_a__data_type
		= real_out_rd_metadata_a.data_type,
		__formal__out_rd_metadata_b__data_type
		= real_out_rd_metadata_b.data_type,
		__formal__out_rd_metadata_c__data_type
		= real_out_rd_metadata_c.data_type;
	wire [__MSB_POS__CPU_INT_TYPE_SIZE:0]
		__formal__out_rd_metadata_a__int_type_size
		= real_out_rd_metadata_a.int_type_size,
		__formal__out_rd_metadata_b__int_type_size
		= real_out_rd_metadata_b.int_type_size,
		__formal__out_rd_metadata_c__int_type_size
		= real_out_rd_metadata_c.int_type_size;

	wire [__MSB_POS__LAR_FILE_DATA:0]
		__formal__out_rd_shareddata_a__data = real_out_rd_shareddata_a.data,
		__formal__out_rd_shareddata_b__data = real_out_rd_shareddata_b.data,
		__formal__out_rd_shareddata_c__data = real_out_rd_shareddata_c.data;
	wire [__MSB_POS__SCALAR_DATA:0]
		__formal__out_rd_shareddata_a__scalar_data
		= real_out_rd_shareddata_a.scalar_data,
		__formal__out_rd_shareddata_b__scalar_data
		= real_out_rd_shareddata_b.scalar_data,
		__formal__out_rd_shareddata_c__scalar_data
		= real_out_rd_shareddata_c.scalar_data;
	wire [__MSB_POS__LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__formal__out_rd_shareddata_a__base_addr
		= real_out_rd_shareddata_a.base_addr,
		__formal__out_rd_shareddata_b__base_addr
		= real_out_rd_shareddata_b.base_addr,
		__formal__out_rd_shareddata_c__base_addr
		= real_out_rd_shareddata_c.base_addr;

	wire __formal__out_wr__valid = real_out_wr.valid;

	wire __formal__out_mem_read__req = real_out_mem_read.req;
	wire [__MSB_POS__LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__formal__out_mem_read__base_addr = real_out_mem_read.base_addr;

	wire __formal__out_mem_write__req = real_out_mem_write.req;
	wire [__MSB_POS__LAR_FILE_DATA:0] __formal__out_mem_write__data
		= real_out_mem_write.data;
	wire [__MSB_POS__LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__formal__out_mem_write__base_addr = real_out_mem_write.base_addr;


	logic [__MSB_POS__LAR_FILE_METADATA_TAG:0]
		__debug_lar_metadata__tag[__ARR_SIZE__NUM_LARS];
	logic [__MSB_POS__LAR_FILE_METADATA_DATA_OFFSET:0]
		__debug_lar_metadata__data_offset[__ARR_SIZE__NUM_LARS];
	logic [__MSB_POS__CPU_DATA_TYPE:0]
		__debug_lar_metadata__data_type[__ARR_SIZE__NUM_LARS];
	logic [__MSB_POS__CPU_INT_TYPE_SIZE:0]
		__debug_lar_metadata__int_type_size[__ARR_SIZE__NUM_LARS];

	logic [__MSB_POS__LAR_FILE_DATA:0]
		__debug_lar_shareddata__data[__ARR_SIZE__NUM_LARS];
	logic [__MSB_POS__LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__debug_lar_shareddata__base_addr[__ARR_SIZE__NUM_LARS];
	logic [__MSB_POS__LAR_FILE_SHAREDDATA_REF_COUNT:0]
		__debug_lar_shareddata__ref_count[__ARR_SIZE__NUM_LARS];
	logic [__MSB_POS__LAR_FILE_SHAREDDATA_DIRTY:0]
		__debug_lar_shareddata__dirty[__ARR_SIZE__NUM_LARS];


	always_ff @(posedge clk)
	begin
		integer __i;
		for (__i=0; __i<__ARR_SIZE__NUM_LARS; __i=__i+1)
		begin
			__debug_lar_metadata__tag[__i]
				<= __lar_metadata__tag[__i];
			__debug_lar_metadata__data_offset[__i]
				<= __lar_metadata__data_offset[__i];
			__debug_lar_metadata__data_type[__i]
				<= __lar_metadata__data_type[__i];
			__debug_lar_metadata__int_type_size[__i]
				<= __lar_metadata__int_type_size[__i];

			__debug_lar_shareddata__base_addr[__i]
				<= __lar_shareddata__base_addr[__i];
			__debug_lar_shareddata__ref_count[__i]
				<= __lar_shareddata__ref_count[__i];
			__debug_lar_shareddata__dirty[__i]
				<= __lar_shareddata__dirty[__i];
		end

		__debug_lar_shareddata__data[0]
			<= __out_shareddata_data_debug_data_0;
		__debug_lar_shareddata__data[1]
			<= __out_shareddata_data_debug_data_1;
		__debug_lar_shareddata__data[2]
			<= __out_shareddata_data_debug_data_2;
		__debug_lar_shareddata__data[3]
			<= __out_shareddata_data_debug_data_3;
		`ifndef SMALL_LAR_FILE
		__debug_lar_shareddata__data[4]
			<= __out_shareddata_data_debug_data_4;
		__debug_lar_shareddata__data[5]
			<= __out_shareddata_data_debug_data_5;
		__debug_lar_shareddata__data[6]
			<= __out_shareddata_data_debug_data_6;
		__debug_lar_shareddata__data[7]
			<= __out_shareddata_data_debug_data_7;
		__debug_lar_shareddata__data[8]
			<= __out_shareddata_data_debug_data_8;
		__debug_lar_shareddata__data[9]
			<= __out_shareddata_data_debug_data_9;
		__debug_lar_shareddata__data[10]
			<= __out_shareddata_data_debug_data_10;
		__debug_lar_shareddata__data[11]
			<= __out_shareddata_data_debug_data_11;
		__debug_lar_shareddata__data[12]
			<= __out_shareddata_data_debug_data_12;
		__debug_lar_shareddata__data[13]
			<= __out_shareddata_data_debug_data_13;
		__debug_lar_shareddata__data[14]
			<= __out_shareddata_data_debug_data_14;
		__debug_lar_shareddata__data[15]
			<= __out_shareddata_data_debug_data_15;
		`endif		// (!defined(SMALL_LAR_FILE))
	end
	`endif		// FORMAL

	initial
	begin
		integer __i;
		__wr_state = PkgSnow64LarFile::WrStIdle;

		for (__i=0; __i<__ARR_SIZE__NUM_LARS; __i=__i+1)
		begin
			__lar_metadata__tag[__i] = __UNALLOCATED_TAG;
			__lar_metadata__data_offset[__i] = 0;
			__lar_metadata__data_type[__i] = 0;
			__lar_metadata__int_type_size[__i] = 0;

			__lar_shareddata__base_addr[__i] = 0;
			__lar_shareddata__ref_count[__i] = 0;
			__lar_shareddata__dirty[__i] = 0;

			// Fill up the stack of tags
			__lar_tag_stack[__i] = __i;
		end

		__in_shareddata_data_wr_req = 0;
		__in_shareddata_data_wr_index = 0;
		__in_shareddata_data_wr_data = 0;

		__curr_tag_stack_index = __LAST_INDEX__NUM_LARS;
		__above_curr_tag_stack_index = 0;
		__captured_top_lar_tag = 0;
		__captured_in_wr__shareddata_dirty_from_tag = 0;
		__captured_in_wr__shareddata_ref_count_from_tag = 0;
		__captured_in_wr__shareddata_base_addr_from_tag = 0;
		{real_out_rd_metadata_a, real_out_rd_metadata_b,
			real_out_rd_metadata_c} = 0;
		{real_out_rd_shareddata_a, real_out_rd_shareddata_b,
			real_out_rd_shareddata_c} = 0;
		real_out_wr = 0;
		real_out_mem_read = 0;
		real_out_mem_write = 0;

		__captured_in_wr = 0;
		__captured_in_wr__tag_from_index = 0;
		__captured_tag_search = 0;
		__captured_out_shareddata_data_rd_for_wr_data = 0;

		{__captured_in_mem_read__valid, __captured_in_mem_write__valid}
			= 0;
	end

	`define RD_INDEX(which) real_in_rd_``which``.index
	`define RD_TAG(which) __lar_metadata__tag[`RD_INDEX(which)]

	`define GEN_RD(which) \
	assign __in_shareddata_data_rd_``which``_index = `RD_TAG(which); \
	always_ff @(posedge clk) \
	begin \
		real_out_rd_metadata_``which.tag \
			<= __lar_metadata__tag[`RD_INDEX(which)]; \
		real_out_rd_metadata_``which.data_offset \
			<= __lar_metadata__data_offset[`RD_INDEX(which)]; \
		real_out_rd_metadata_``which.int_type_size \
			<= __lar_metadata__int_type_size[`RD_INDEX(which)]; \
		real_out_rd_shareddata_``which.data \
			<= __out_shareddata_data_rd_``which``_data; \
		/* Temporary! */ \
		real_out_rd_shareddata_``which.scalar_data <= 0; \
		real_out_rd_shareddata_``which.base_addr \
			<= __lar_shareddata__base_addr[`RD_TAG(which)]; \
	end


	`GEN_RD(a)
	`GEN_RD(b)
	`GEN_RD(c)

	`undef RD_INDEX
	`undef RD_TAG
	`undef GEN_RD


	`define BEFORE_LDST_IN_WR_METADATA_TAG \
		__lar_metadata__tag[real_in_wr.index]

	`define IN_LDST_CAPTURED_CURR_METADATA_TAG \
		__captured_in_wr__tag_from_index
	`define IN_LDST_CAPTURED_TOP_METADATA_TAG \
		__captured_top_lar_tag
	`define IN_LDST_CAPTURED_ALIASED_METADATA_TAG \
		__captured_tag_search

	`define IN_LDST_CAPTURED_CURR_SHAREDDATA_DATA \
		__captured_out_shareddata_data_rd_for_wr_data

	`define IN_LDST_CAPTURED_CURR_SHAREDDATA_BASE_ADDR \
		__captured_in_wr__shareddata_base_addr_from_tag
	`define IN_LDST_CAPTURED_CURR_SHAREDDATA_REF_COUNT \
		__captured_in_wr__shareddata_ref_count_from_tag
	`define IN_LDST_CAPTURED_CURR_SHAREDDATA_DIRTY \
		__captured_in_wr__shareddata_dirty_from_tag


	`define IN_LDST_MODDABLE_CURR_METADATA_TAG \
		__lar_metadata__tag[__captured_in_wr.index]
	`define IN_LDST_MODDABLE_CURR_METADATA_DATA_TYPE \
		__lar_metadata__data_type[__captured_in_wr.index]
	`define IN_LDST_MODDABLE_CURR_METADATA_INT_TYPE_SIZE \
		__lar_metadata__int_type_size[__captured_in_wr.index]
	`define IN_LDST_MODDABLE_CURR_METADATA_DATA_OFFSET \
		__lar_metadata__data_offset[__captured_in_wr.index]


	`define IN_LDST_MODDABLE_CURR_SHAREDDATA_BASE_ADDR \
		__lar_shareddata__base_addr[`IN_LDST_CAPTURED_CURR_METADATA_TAG]
	`define IN_LDST_MODDABLE_CURR_SHAREDDATA_REF_COUNT \
		__lar_shareddata__ref_count[`IN_LDST_CAPTURED_CURR_METADATA_TAG]
	`define IN_LDST_MODDABLE_CURR_SHAREDDATA_DIRTY \
		__lar_shareddata__dirty[`IN_LDST_CAPTURED_CURR_METADATA_TAG]

	`define IN_LDST_MODDABLE_TOP_SHAREDDATA_BASE_ADDR \
		__lar_shareddata__base_addr[`IN_LDST_CAPTURED_TOP_METADATA_TAG]
	`define IN_LDST_MODDABLE_TOP_SHAREDDATA_REF_COUNT \
		__lar_shareddata__ref_count[`IN_LDST_CAPTURED_TOP_METADATA_TAG]
	`define IN_LDST_MODDABLE_TOP_SHAREDDATA_DIRTY \
		__lar_shareddata__dirty[`IN_LDST_CAPTURED_TOP_METADATA_TAG]

	`define IN_LDST_MODDABLE_ALIASED_SHAREDDATA_BASE_ADDR \
		__lar_shareddata__base_addr \
			[`IN_LDST_CAPTURED_ALIASED_METADATA_TAG]
	`define IN_LDST_MODDABLE_ALIASED_SHAREDDATA_REF_COUNT \
		__lar_shareddata__ref_count \
			[`IN_LDST_CAPTURED_ALIASED_METADATA_TAG]
	`define IN_LDST_MODDABLE_ALIASED_SHAREDDATA_DIRTY \
		__lar_shareddata__dirty \
			[`IN_LDST_CAPTURED_ALIASED_METADATA_TAG]

	`define REAL_OUT_WR__VALID real_out_wr
	`define REAL_IN_MEM_WRITE__VALID real_in_mem_write


	task finish_ldst;
		__wr_state <= PkgSnow64LarFile::WrStIdle;
		`REAL_OUT_WR__VALID <= 1;
	endtask

	task prep_mem_read;
		real_out_mem_read.req <= 1;
		real_out_mem_read.base_addr
			<= __captured_in_wr__base_addr.base_addr;
	endtask : prep_mem_read

	task stop_mem_read;
		real_out_mem_read.req <= 0;
	endtask : stop_mem_read

	task prep_mem_write;
		real_out_mem_write.req <= 1;
		real_out_mem_write.data <= `IN_LDST_CAPTURED_CURR_SHAREDDATA_DATA;

		// The base_addr of the data is ALWAYS the old data's address for a
		// memory write by the LAR file.
		real_out_mem_write.base_addr
			<= `IN_LDST_CAPTURED_CURR_SHAREDDATA_BASE_ADDR;
	endtask : prep_mem_write

	task stop_mem_write;
		real_out_mem_write.req <= 0;
	endtask : stop_mem_write

	task prep_shareddata_data_write
		(input logic [__MSB_POS__LAR_FILE_METADATA_TAG:0] n_wr_index,
		input logic [__MSB_POS__LAR_FILE_DATA:0] n_wr_data);

		__in_shareddata_data_wr_req <= 1;
		__in_shareddata_data_wr_index <= n_wr_index;
		__in_shareddata_data_wr_data <= n_wr_data;
	endtask : prep_shareddata_data_write

	task stop_shareddata_data_write;
		__in_shareddata_data_wr_req <= 0;
	endtask : stop_shareddata_data_write

	// Writes into the LAR file
	always @(posedge clk)
	begin
		case (__wr_state)
		PkgSnow64LarFile::WrStIdle:
		begin
			stop_mem_read();
			stop_mem_write();

			__captured_in_wr <= real_in_wr;
			`IN_LDST_CAPTURED_CURR_METADATA_TAG
				<= `BEFORE_LDST_IN_WR_METADATA_TAG;

			`IN_LDST_CAPTURED_CURR_SHAREDDATA_DIRTY
				<= __lar_shareddata__dirty
				[`BEFORE_LDST_IN_WR_METADATA_TAG];
			`IN_LDST_CAPTURED_CURR_SHAREDDATA_REF_COUNT
				<= __lar_shareddata__ref_count
				[`BEFORE_LDST_IN_WR_METADATA_TAG];
			`IN_LDST_CAPTURED_CURR_SHAREDDATA_BASE_ADDR
				<= __lar_shareddata__base_addr
				[`BEFORE_LDST_IN_WR_METADATA_TAG];

			__above_curr_tag_stack_index <= __curr_tag_stack_index + 1;

			`IN_LDST_CAPTURED_ALIASED_METADATA_TAG <= __out_tag_search;
			`IN_LDST_CAPTURED_TOP_METADATA_TAG
				<= __lar_tag_stack[__curr_tag_stack_index];
			`IN_LDST_CAPTURED_CURR_SHAREDDATA_DATA
				<= __out_shareddata_data_rd_for_wr_data;

			__captured_in_mem_read__valid <= 0;
			__captured_in_mem_write__valid <= 0;

			if (real_in_wr.req && (real_in_wr.index != 0))
			begin
				case (real_in_wr.write_type)
				// Mostly ALU/FPU instructions
				PkgSnow64LarFile::WriteTypOnlyData:
				begin
					if (`BEFORE_LDST_IN_WR_METADATA_TAG
						!= __UNALLOCATED_TAG)
					begin
						`REAL_OUT_WR__VALID <= 1;
						__lar_shareddata__dirty
							[`BEFORE_LDST_IN_WR_METADATA_TAG] <= 1;
						prep_shareddata_data_write
							(`BEFORE_LDST_IN_WR_METADATA_TAG,
							real_in_wr.non_ldst_data);
					end
					else
					begin
						stop_shareddata_data_write();
						`REAL_OUT_WR__VALID <= 0;
					end
				end

				// Used for port-mapped input instructions
				PkgSnow64LarFile::WriteTypDataAndType:
				begin
					if (`BEFORE_LDST_IN_WR_METADATA_TAG
						!= __UNALLOCATED_TAG)
					begin
						`REAL_OUT_WR__VALID <= 1;
						__lar_shareddata__dirty
							[`BEFORE_LDST_IN_WR_METADATA_TAG] <= 1;
						prep_shareddata_data_write
							(`BEFORE_LDST_IN_WR_METADATA_TAG,
							real_in_wr.non_ldst_data);

						__lar_metadata__data_type[real_in_wr.index]
							<= real_in_wr.data_type;
						__lar_metadata__int_type_size[real_in_wr.index]
							<= real_in_wr.int_type_size;
					end
					else
					begin
						stop_shareddata_data_write();
						`REAL_OUT_WR__VALID <= 0;
					end
				end

				// PkgSnow64LarFile::WriteTypLd or
				// PkgSnow64LarFile::WriteTypSt
				default:
				begin
					stop_shareddata_data_write();
					`REAL_OUT_WR__VALID <= 0;
					__wr_state <= PkgSnow64LarFile::WrStStartLdSt;

					__lar_metadata__data_type[real_in_wr.index]
						<= real_in_wr.data_type;
					__lar_metadata__int_type_size[real_in_wr.index]
						<= real_in_wr.int_type_size;
				end
				endcase
			end

			else // if (not writing into the LAR file this cycle)
			begin
				stop_shareddata_data_write();
				`REAL_OUT_WR__VALID <= 0;
			end
		end

		PkgSnow64LarFile::WrStStartLdSt:
		begin
			// If we already had the address's data.
			if (`IN_LDST_CAPTURED_ALIASED_METADATA_TAG != 0)
			begin
				stop_mem_read();

				// A tag already exists.  We set our tag to the existing
				// one.
				`IN_LDST_MODDABLE_CURR_METADATA_TAG
					<= `IN_LDST_CAPTURED_ALIASED_METADATA_TAG;

				// If our existing tag ISN'T the one we found.
				if (`IN_LDST_CAPTURED_ALIASED_METADATA_TAG
					!= `IN_LDST_CAPTURED_CURR_METADATA_TAG)
				begin
					// The aliased reference count always increments here.
					`IN_LDST_MODDABLE_ALIASED_SHAREDDATA_REF_COUNT
						<= `IN_LDST_MODDABLE_ALIASED_SHAREDDATA_REF_COUNT
						+ 1;

					if (__captured_in_wr.write_type
						== PkgSnow64LarFile::WriteTypSt)
					begin
						// Make a copy of our data to the new address.
						// This also causes us to need to set the dirty
						// flag.
						prep_shareddata_data_write
							(`IN_LDST_CAPTURED_ALIASED_METADATA_TAG,
							`IN_LDST_CAPTURED_CURR_SHAREDDATA_DATA);
						`IN_LDST_MODDABLE_ALIASED_SHAREDDATA_DIRTY <= 1;
					end

					else // if (__captured_in_wr.write_type
						// == PkgSnow64LarFile::WriteTypLd)
					begin
						stop_shareddata_data_write();
					end

					case (`IN_LDST_CAPTURED_CURR_SHAREDDATA_REF_COUNT)
					// We haven't been allocated yet.
					// Since we haven't been allocated yet, we don't need
					// to do a write back to memory.
					0:
					begin
						stop_mem_write();
						finish_ldst();
					end

					// There were no other references to us, so deallocate
					// the old tag (pushing it onto the stack), and (if we
					// were dirty) send our old data out to memory.
					1:
					begin
						// Deallocate our old tag.  Note that this is
						// actually the only case where we will ever do so.
						__lar_tag_stack[__above_curr_tag_stack_index]
							<= `IN_LDST_CAPTURED_CURR_METADATA_TAG;
						__curr_tag_stack_index
							<= __above_curr_tag_stack_index;

						// Since we're deallocating stuff, we need to write
						// our old data back to memory if it's not already
						// up to date.
						case (`IN_LDST_CAPTURED_CURR_SHAREDDATA_DIRTY)
						1:
						begin
							// As we've been deallocated, write our old
							// data back out to memory.
							__wr_state <= PkgSnow64LarFile
								::WrStWaitForJustMemWrite;
							prep_mem_write();
						end

						0:
						begin
							stop_mem_write();
							finish_ldst();
						end
						endcase

						// We were the only LAR that cared about our old
						// shared data, which means our old shared data
						// becomes free for use.

						`IN_LDST_MODDABLE_CURR_SHAREDDATA_REF_COUNT <= 0;
						`IN_LDST_MODDABLE_CURR_SHAREDDATA_DIRTY <= 0;
					end

					// There was at least one other reference to us, so
					// don't deallocate anything, but do decrement our old
					// reference count (we increment our new reference
					// count as well).
					// In this situation, all that happens is that our tag
					// changes and our shared data loses a reference, but
					// our new shared data gains a reference
					default:
					begin
						stop_mem_write();
						finish_ldst();
						`IN_LDST_MODDABLE_CURR_SHAREDDATA_REF_COUNT
							<= `IN_LDST_MODDABLE_CURR_SHAREDDATA_REF_COUNT
							- 1;
					end
					endcase
				end

				// If our address is identical to the one being searched
				// for, we do nothing useful.
				// ...This could perhaps just... NOT take an extra cycle,
				// but we'll leave things as they are for now.
				else
				begin
					// In this case, we do nothing of interest.
					finish_ldst();
					stop_mem_write();
					stop_shareddata_data_write();
				end
			end

			// Nobody had the address we were looking for.
			else // if (`IN_LDST_CAPTURED_ALIASED_METADATA_TAG == 0)
			begin
				case (`IN_LDST_CAPTURED_CURR_SHAREDDATA_REF_COUNT)
				// This is from before we were allocated.
				0:
				begin
					stop_mem_write();

					// Allocate a new element of shared data.
					`IN_LDST_MODDABLE_CURR_METADATA_TAG
						<= `IN_LDST_CAPTURED_TOP_METADATA_TAG;
					__curr_tag_stack_index <= __curr_tag_stack_index - 1;

					`IN_LDST_MODDABLE_TOP_SHAREDDATA_BASE_ADDR
						<= __captured_in_wr__base_addr.base_addr;

					// Within the run of the current program, we are the
					// first LAR to ever reference this element of shared
					// data.
					`IN_LDST_MODDABLE_TOP_SHAREDDATA_REF_COUNT <= 1;

					case (__captured_in_wr.write_type)
					PkgSnow64LarFile::WriteTypLd:
					begin
						// Because we haven't been allocated yet, we only
						// need to perform a data read.
						__wr_state <= PkgSnow64LarFile
							::WrStWaitForJustMemRead;
						prep_mem_read();

						// A load of fresh data marks us as clean
						`IN_LDST_MODDABLE_TOP_SHAREDDATA_DIRTY <= 0;
					end

					PkgSnow64LarFile::WriteTypSt:
					begin
						finish_ldst();
						// If you do a store before there was any data in a
						// LAR, the resulting data WILL be zero.

						// Stores mark the data as dirty.
						`IN_LDST_MODDABLE_TOP_SHAREDDATA_DIRTY <= 1;
					end
					endcase
				end

				// We were the only reference, so don't perform any
				// allocation or deallocation, and don't change the
				// reference count.  Note however that this can still cause
				// accessing memory
				1:
				begin
					`IN_LDST_MODDABLE_CURR_SHAREDDATA_BASE_ADDR
						<= __captured_in_wr__base_addr.base_addr;

					case (`IN_LDST_CAPTURED_CURR_SHAREDDATA_DIRTY)
					1:
					begin
						prep_mem_write();
						case (__captured_in_wr.write_type)
						PkgSnow64LarFile::WriteTypLd:
						begin
							__wr_state <= PkgSnow64LarFile
								::WrStWaitForMemReadAndMemWrite;
							prep_mem_read();

							// Loads of fresh data mark us as clean.
							`IN_LDST_MODDABLE_CURR_SHAREDDATA_DIRTY <= 0;
						end

						PkgSnow64LarFile::WriteTypSt:
						begin
							__wr_state <= PkgSnow64LarFile
								::WrStWaitForJustMemWrite;
							stop_mem_read();
						end
						endcase
					end

					0:
					begin
						stop_mem_write();

						case (__captured_in_wr.write_type)
						PkgSnow64LarFile::WriteTypLd:
						begin
							__wr_state <= PkgSnow64LarFile
								::WrStWaitForJustMemRead;
							prep_mem_read();
						end

						PkgSnow64LarFile::WriteTypSt:
						begin
							stop_mem_read();
							finish_ldst();

							`IN_LDST_MODDABLE_CURR_SHAREDDATA_DIRTY <= 1;
						end
						endcase
					end
					endcase
				end

				// There are other LARs that have our old data, but no LAR
				// has the data from our new address.
				default:
				begin
					stop_mem_write();

					// Decrement our old reference count
					`IN_LDST_MODDABLE_CURR_SHAREDDATA_REF_COUNT
						<= `IN_LDST_CAPTURED_CURR_SHAREDDATA_REF_COUNT
						- 1;

					// Allocate a new element of shared data
					`IN_LDST_MODDABLE_CURR_METADATA_TAG
						<= `IN_LDST_CAPTURED_TOP_METADATA_TAG;
					__curr_tag_stack_index <= __curr_tag_stack_index - 1;

					`IN_LDST_MODDABLE_TOP_SHAREDDATA_BASE_ADDR
						<= __captured_in_wr__base_addr.base_addr;
					`IN_LDST_MODDABLE_TOP_SHAREDDATA_REF_COUNT <= 1;

					case (__captured_in_wr.write_type)
					PkgSnow64LarFile::WriteTypLd:
					begin
						__wr_state <= PkgSnow64LarFile
							::WrStWaitForJustMemRead;
						prep_mem_read();

						// Loads of fresh data mark us as clean.
						`IN_LDST_MODDABLE_TOP_SHAREDDATA_DIRTY <= 0;
					end

					PkgSnow64LarFile::WriteTypSt:
					begin
						finish_ldst();
						stop_mem_read();

						// Make a copy of our old data over to the freshly
						// allocated element of shared data.
						prep_shareddata_data_write
							(`IN_LDST_CAPTURED_TOP_METADATA_TAG,
							`IN_LDST_CAPTURED_CURR_SHAREDDATA_DATA);

						// Also, since this is a store, mark the copy of
						// our old data as dirty.
						`IN_LDST_MODDABLE_TOP_SHAREDDATA_DIRTY <= 1;
					end
					endcase
				end
				endcase
			end
		end

		PkgSnow64LarFile::WrStWaitForJustMemRead:
		begin
			stop_mem_read();
			stop_mem_write();

			if (real_in_mem_read.valid)
			begin
				finish_ldst();

				prep_shareddata_data_write
					(`IN_LDST_MODDABLE_CURR_METADATA_TAG,
					real_in_mem_read.data);
			end
		end

		PkgSnow64LarFile::WrStWaitForJustMemWrite:
		begin
			stop_mem_read();
			stop_mem_write();
			stop_shareddata_data_write();

			if (`REAL_IN_MEM_WRITE__VALID)
			begin
				finish_ldst();
			end
		end

		PkgSnow64LarFile::WrStWaitForMemReadAndMemWrite:
		begin
			stop_mem_read();
			stop_mem_write();

			if (real_in_mem_read.valid)
			begin
				__captured_in_mem_read__valid <= 1;

				prep_shareddata_data_write
					(`IN_LDST_MODDABLE_CURR_METADATA_TAG,
					real_in_mem_read.data);

				if ((!`REAL_IN_MEM_WRITE__VALID)
					&& __captured_in_mem_write__valid)
				begin
					finish_ldst();
				end
			end

			if (`REAL_IN_MEM_WRITE__VALID)
			begin
				__captured_in_mem_write__valid <= 1;

				if ((!real_in_mem_read.valid)
					&& __captured_in_mem_read__valid)
				begin
					finish_ldst();
				end
			end
		end
		endcase
	end

	`undef BEFORE_LDST_IN_WR_METADATA_TAG
	`undef IN_LDST_CAPTURED_CURR_METADATA_TAG
	`undef IN_LDST_CAPTURED_TOP_METADATA_TAG
	`undef IN_LDST_CAPTURED_ALIASED_METADATA_TAG

	`undef IN_LDST_CAPTURED_CURR_SHAREDDATA_REF_COUNT
	`undef IN_LDST_CAPTURED_CURR_SHAREDDATA_DIRTY


	`undef IN_LDST_MODDABLE_CURR_METADATA_TAG
	`undef IN_LDST_MODDABLE_CURR_METADATA_DATA_TYPE
	`undef IN_LDST_MODDABLE_CURR_METADATA_INT_TYPE_SIZE
	`undef IN_LDST_MODDABLE_CURR_METADATA_DATA_OFFSET


	`undef IN_LDST_MODDABLE_CURR_SHAREDDATA_BASE_ADDR
	`undef IN_LDST_MODDABLE_CURR_SHAREDDATA_REF_COUNT
	`undef IN_LDST_MODDABLE_CURR_SHAREDDATA_DIRTY

	`undef IN_LDST_MODDABLE_TOP_SHAREDDATA_BASE_ADDR
	`undef IN_LDST_MODDABLE_TOP_SHAREDDATA_REF_COUNT
	`undef IN_LDST_MODDABLE_TOP_SHAREDDATA_DIRTY

	`undef IN_LDST_MODDABLE_ALIASED_SHAREDDATA_BASE_ADDR
	`undef IN_LDST_MODDABLE_ALIASED_SHAREDDATA_REF_COUNT
	`undef IN_LDST_MODDABLE_ALIASED_SHAREDDATA_DIRTY

endmodule
