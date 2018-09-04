`include "src/snow64_lar_file_defines.header.sv"

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
		__tag_search_8_to_11, __tag_search_12_to_15;

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

	assign out = __tag_search_1_to_3 | __tag_search_4_to_7
		| __tag_search_8_to_11 | __tag_search_12_to_15;

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
	import PkgSnow64LarFile::PartialPortOut_LarFile_MemRead;
	import PkgSnow64LarFile::PartialPortOut_LarFile_MemWrite;
	import PkgSnow64LarFile::PartialPortOut_LarFile_WaitForMe;


	PartialPortIn_LarFile_Read real_in_rd_a, real_in_rd_b, real_in_rd_c;
	PartialPortIn_LarFile_Write real_in_wr;
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
	PartialPortOut_LarFile_MemRead real_out_mem_read;
	PartialPortOut_LarFile_MemWrite real_out_mem_write;
	PartialPortOut_LarFile_WaitForMe real_out_wait_for_me;

	assign out = {real_out_rd_metadata_a, real_out_rd_metadata_b,
		real_out_rd_metadata_c,
		real_out_rd_shareddata_a, real_out_rd_shareddata_b,
		real_out_rd_shareddata_c,
		real_out_mem_read,
		real_out_mem_write,
		real_out_wait_for_me};



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

	// Tag stack
	logic [__MSB_POS__LAR_FILE_METADATA_TAG:0]
		__lar_tag_stack[__ARR_SIZE__NUM_LARS];
	logic [__MSB_POS__LAR_FILE_METADATA_TAG:0]
		__curr_tag_stack_index;

	// Tag search stuff
	logic [__MSB_POS__LAR_FILE_METADATA_TAG:0]
		__captured_tag_search_final;

	PkgSnow64LarFile::LarIncomingBaseAddr __captured_in_wr__base_addr;

	// Metadata

	// Attempt to implement this as block RAM
	logic [__MSB_POS__LAR_FILE_METADATA_TAG:0]
		__lar_metadata__tag[__ARR_SIZE__NUM_LARS];

	logic [__MSB_POS__LAR_FILE_METADATA_DATA_OFFSET:0]
		__lar_metadata__data_offset[__ARR_SIZE__NUM_LARS];

	logic [__MSB_POS__CPU_DATA_TYPE:0]
		__lar_metadata__data_type[__ARR_SIZE__NUM_LARS];

	logic [__MSB_POS__CPU_INT_TYPE_SIZE:0]
		__lar_metadata__int_type_size[__ARR_SIZE__NUM_LARS];


	// Shared data
	// This needs to be implemented as block RAM!
	logic [__MSB_POS__LAR_FILE_DATA:0]
		__lar_shareddata__data[__ARR_SIZE__NUM_LARS];


	// These two arrays are essentially forced to be implemented as arrays
	// of logic due to the tag search.
	logic [__MSB_POS__LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__lar_shareddata__base_addr[__ARR_SIZE__NUM_LARS];
	logic [__MSB_POS__LAR_FILE_SHAREDDATA_REF_COUNT:0]
		__lar_shareddata__ref_count[__ARR_SIZE__NUM_LARS];

	// This needs to be implemented as block RAM.
	logic [__MSB_POS__LAR_FILE_SHAREDDATA_DIRTY:0]
		__lar_shareddata__dirty[__ARR_SIZE__NUM_LARS];

	wire [__MSB_POS__LAR_FILE_METADATA_TAG:0] __out_tag_search;
	__Snow64LarFileTagSearch __inst_tag_search
		(.in_addr(real_in_wr.ldst_addr),
		.in_lar_shareddata__base_addr_0(__lar_shareddata__base_addr[0]),
		.in_lar_shareddata__base_addr_1(__lar_shareddata__base_addr[1]),
		.in_lar_shareddata__base_addr_2(__lar_shareddata__base_addr[2]),
		.in_lar_shareddata__base_addr_3(__lar_shareddata__base_addr[3]),
		`ifdef SMALL_LAR_FILE
		.in_lar_shareddata__base_addr_4
			({{__WIDTH__LAR_FILE_SHAREDDATA_BASE_ADDR{1'b0}}}),
		.in_lar_shareddata__base_addr_5
			({{__WIDTH__LAR_FILE_SHAREDDATA_BASE_ADDR{1'b0}}}),
		.in_lar_shareddata__base_addr_6
			({{__WIDTH__LAR_FILE_SHAREDDATA_BASE_ADDR{1'b0}}}),
		.in_lar_shareddata__base_addr_7
			({{__WIDTH__LAR_FILE_SHAREDDATA_BASE_ADDR{1'b0}}}),
		.in_lar_shareddata__base_addr_8
			({{__WIDTH__LAR_FILE_SHAREDDATA_BASE_ADDR{1'b0}}}),
		.in_lar_shareddata__base_addr_9
			({{__WIDTH__LAR_FILE_SHAREDDATA_BASE_ADDR{1'b0}}}),
		.in_lar_shareddata__base_addr_10
			({{__WIDTH__LAR_FILE_SHAREDDATA_BASE_ADDR{1'b0}}}),
		.in_lar_shareddata__base_addr_11
			({{__WIDTH__LAR_FILE_SHAREDDATA_BASE_ADDR{1'b0}}}),
		.in_lar_shareddata__base_addr_12
			({{__WIDTH__LAR_FILE_SHAREDDATA_BASE_ADDR{1'b0}}}),
		.in_lar_shareddata__base_addr_13
			({{__WIDTH__LAR_FILE_SHAREDDATA_BASE_ADDR{1'b0}}}),
		.in_lar_shareddata__base_addr_14
			({{__WIDTH__LAR_FILE_SHAREDDATA_BASE_ADDR{1'b0}}}),
		.in_lar_shareddata__base_addr_15
			({{__WIDTH__LAR_FILE_SHAREDDATA_BASE_ADDR{1'b0}}}),
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
		.in_lar_shareddata__ref_count_4
			({{__WIDTH__LAR_FILE_SHAREDDATA_REF_COUNT{1'b0}}}),
		.in_lar_shareddata__ref_count_5
			({{__WIDTH__LAR_FILE_SHAREDDATA_REF_COUNT{1'b0}}}),
		.in_lar_shareddata__ref_count_6
			({{__WIDTH__LAR_FILE_SHAREDDATA_REF_COUNT{1'b0}}}),
		.in_lar_shareddata__ref_count_7
			({{__WIDTH__LAR_FILE_SHAREDDATA_REF_COUNT{1'b0}}}),
		.in_lar_shareddata__ref_count_8
			({{__WIDTH__LAR_FILE_SHAREDDATA_REF_COUNT{1'b0}}}),
		.in_lar_shareddata__ref_count_9
			({{__WIDTH__LAR_FILE_SHAREDDATA_REF_COUNT{1'b0}}}),
		.in_lar_shareddata__ref_count_10
			({{__WIDTH__LAR_FILE_SHAREDDATA_REF_COUNT{1'b0}}}),
		.in_lar_shareddata__ref_count_11
			({{__WIDTH__LAR_FILE_SHAREDDATA_REF_COUNT{1'b0}}}),
		.in_lar_shareddata__ref_count_12
			({{__WIDTH__LAR_FILE_SHAREDDATA_REF_COUNT{1'b0}}}),
		.in_lar_shareddata__ref_count_13
			({{__WIDTH__LAR_FILE_SHAREDDATA_REF_COUNT{1'b0}}}),
		.in_lar_shareddata__ref_count_14
			({{__WIDTH__LAR_FILE_SHAREDDATA_REF_COUNT{1'b0}}}),
		.in_lar_shareddata__ref_count_15
			({{__WIDTH__LAR_FILE_SHAREDDATA_REF_COUNT{1'b0}}}),
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
	wire [__MSB_POS__LAR_FILE_METADATA_TAG:0] __formal__in_wr__non_ldst_tag
		= real_in_wr.non_ldst_tag;
	wire [__MSB_POS__CPU_ADDR:0] __formal__in_wr__ldst_addr
		= real_in_wr.ldst_addr;
	wire [__MSB_POS__CPU_DATA_TYPE:0] __formal__in_wr__data_type
		= real_in_wr.data_type;
	wire [__MSB_POS__CPU_INT_TYPE_SIZE:0] __formal__in_wr__int_type_size
		= real_in_wr.int_type_size;

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
		__formal__out_rd_shareddata_a__data
		= real_out_rd_shareddata_a.data,
		__formal__out_rd_shareddata_b__data
		= real_out_rd_shareddata_b.data,
		__formal__out_rd_shareddata_c__data
		= real_out_rd_shareddata_c.data;
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

	wire __formal__out_mem_read__req = real_out_mem_read.req;
	wire [__MSB_POS__LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__formal__out_mem_read__base_addr = real_out_mem_read.base_addr;

	wire __formal__out_mem_write__req = real_out_mem_write.req;
	wire [__MSB_POS__LAR_FILE_DATA:0] __formal__out_mem_write__data
		= real_out_mem_write.data;
	wire [__MSB_POS__LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__formal__out_mem_write__base_addr = real_out_mem_write.base_addr;
	wire __formal__out_wait_for_me__busy = real_out_wait_for_me.busy;


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

			__debug_lar_shareddata__data[__i]
				<= __lar_shareddata__data[__i];
			__debug_lar_shareddata__base_addr[__i]
				<= __lar_shareddata__base_addr[__i];
			__debug_lar_shareddata__ref_count[__i]
				<= __lar_shareddata__ref_count[__i];
			__debug_lar_shareddata__dirty[__i]
				<= __lar_shareddata__dirty[__i];
		end
	end
	`endif		// FORMAL



endmodule
