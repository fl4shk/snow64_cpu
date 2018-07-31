`include "src/snow64_lar_file_defines.header.sv"


module Snow64LarFile(input logic clk,
	input PkgSnow64LarFile::PortIn_LarFile_Ctrl in_ctrl,
	input PkgSnow64LarFile::PortIn_LarFile_Read in_rd_a, in_rd_b, in_rd_c,
	input PkgSnow64LarFile::PortIn_LarFile_Write in_wr,
	output PkgSnow64LarFile::PortOut_LarFile_Read
		out_rd_a, out_rd_b, out_rd_c,
	output PkgSnow64LarFile::PortOut_LarFile_MemWrite out_mem_write);


	localparam __ARR_SIZE__NUM_LARS = `ARR_SIZE__SNOW64_LAR_FILE_NUM_LARS;
	localparam __LAST_INDEX__NUM_LARS 
		= `LAST_INDEX__SNOW64_LAR_FILE_NUM_LARS;

	localparam __WIDTH__ADDR_OFFSET_8
		= `WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_8;
	localparam __MSB_POS__ADDR_OFFSET_8
		= `MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_8;

	localparam __WIDTH__ADDR_OFFSET_16
		= `WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_16;
	localparam __MSB_POS__ADDR_OFFSET_16
		= `MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_16;

	localparam __WIDTH__ADDR_OFFSET_32
		= `WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_32;
	localparam __MSB_POS__ADDR_OFFSET_32
		= `MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_32;

	localparam __WIDTH__ADDR_OFFSET_64
		= `WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_64;
	localparam __MSB_POS__ADDR_OFFSET_64
		= `MSB_POS__SNOW64_LAR_FILE_ADDR_OFFSET_64;

	//localparam __WIDTH__META_DA_DATA_OFFSET
	//	= `WIDTH__SNOW64_LAR_FILE_META_DA_DATA_OFFSET;
	//localparam __MSB_POS__META_DA_DATA_OFFSET
	//	= `MSB_POS__SNOW64_LAR_FILE_META_DA_DATA_OFFSET;

	localparam __WIDTH__META_DA_TAG = `WIDTH__SNOW64_LAR_FILE_META_DA_TAG;
	localparam __MSB_POS__META_DA_TAG
		= `MSB_POS__SNOW64_LAR_FILE_META_DA_TAG;


	localparam __WIDTH__SH_DA_BASE_ADDR
		= `WIDTH__SNOW64_LAR_FILE_SH_DA_BASE_ADDR;
	localparam __MSB_POS__SH_DA_BASE_ADDR
		= `MSB_POS__SNOW64_LAR_FILE_SH_DA_BASE_ADDR;

	localparam __WIDTH__SH_DA_DATA
		= `WIDTH__SNOW64_LAR_FILE_SH_DA_DATA;
	localparam __MSB_POS__SH_DA_DATA
		= `MSB_POS__SNOW64_LAR_FILE_SH_DA_DATA;

	localparam __WIDTH__SH_DA_REF_COUNT
		= `WIDTH__SNOW64_LAR_FILE_SH_DA_REF_COUNT;
	localparam __MSB_POS__SH_DA_REF_COUNT
		= `MSB_POS__SNOW64_LAR_FILE_SH_DA_REF_COUNT;



	// For associativity
	logic __found_sh_da_base_addr;

	// Incoming base_addr to be written to a LAR
	PkgSnow64LarFile::LarBaseAddr __in_wr__base_addr;
	assign __in_wr__base_addr = in_wr.addr;


	// LAR Metadata stuff

	`define META_DATA__WHOLE_ADDR []
	`define META_DATA__ADDR_OFFSET_8 []
	`define META_DATA__ADDR_OFFSET_16 []
	`define META_DATA__ADDR_OFFSET_32 []
	`define META_DATA__ADDR_OFFSET_64 []

	//// The offset into the LAR.
	//logic [__MSB_POS__ADDR_OFFSET_8:0]
	//	__meta_da_arr__addr_offset_8[0 : __LAST_INDEX__NUM_LARS];

	//logic [__MSB_POS__ADDR_OFFSET_16:0]
	//	__meta_da_arr__addr_offset_16[0 : __LAST_INDEX__NUM_LARS];

	//logic [__MSB_POS__ADDR_OFFSET_32:0]
	//	__meta_da_arr__addr_offset_32[0 : __LAST_INDEX__NUM_LARS];

	//logic [__MSB_POS__ADDR_OFFSET_64:0]
	//	__meta_da_arr__addr_offset_64[0 : __LAST_INDEX__NUM_LARS];

	//logic [`MSB_POS__SNOW64_CPU_ADDR:0]
	//	__meta_da_arr__whole_addr[0 : __LAST_INDEX__NUM_LARS];


	//// The LAR's tag... specifies which shared data is used by this LAR.
	//logic [__MSB_POS__META_DA_TAG:0]
	//	__meta_da_arr__tag[0 : __LAST_INDEX__NUM_LARS];

	//// See PkgSnow64Cpu::DataType.
	//logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0]
	//	__meta_da_arr__data_type[0 : __LAST_INDEX__NUM_LARS];

	//// See PkgSnow64Cpu::IntTypeSize.
	//logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
	//	__meta_da_arr__int_type_size[0 : __LAST_INDEX__NUM_LARS];


	// LAR Shared Data stuff

	// The base address, used for associativity between LARs.
	logic [__MSB_POS__SH_DA_BASE_ADDR:0]
		__sh_da_arr__base_addr[0 : __LAST_INDEX__NUM_LARS];


	// The data themselves.
	logic [__MSB_POS__SH_DA_DATA:0]
		__sh_da_arr__data[0 : __LAST_INDEX__NUM_LARS];


	// The reference counts.
	logic [__MSB_POS__SH_DA_REF_COUNT:0]
		__sh_da_arr__ref_count[0 : __LAST_INDEX__NUM_LARS];

	// The "dirty" flags.  Used to determine if we should write back to
	// memory.
	logic __sh_da_arr__dirty[0 : __LAST_INDEX__NUM_LARS];


	// LAR reads happen during the second half of the clock cycle.
	// This prevents weirdness I dealt with in my previous pipelined CPU,
	// where a "read" from the register file might actually have to return
	// the value currently being written to the register file!

	`define RD_INDEX(suffix) \
		in_rd_``suffix.index
	`define RD_TAG(suffix) \
		__meta_da_arr__tag[`RD_INDEX(suffix)]

	`define OUT_RD_PORT(suffix) \
		out_rd_``suffix

	`define RD_LAR(suffix) \
	always_ff @(posedge clk) \
	begin \
		/* `OUT_RD_PORT(suffix).data  */\
		/* 	<= __sh_da_arr__data[`RD_TAG(suffix)]; */ \
		`OUT_RD_PORT(suffix).data \
			<= __sh_da_arr__data[`RD_INDEX(suffix)]; \
		`OUT_RD_PORT(suffix).addr \
			<= __meta_da_arr__whole_addr[`RD_INDEX(suffix)]; \
		`OUT_RD_PORT(suffix).tag \
			<= __meta_da_arr__tag[`RD_INDEX(suffix)]; \
		`OUT_RD_PORT(suffix).data_type \
			<= __meta_da_arr__data_type[`RD_INDEX(suffix)]; \
		`OUT_RD_PORT(suffix).int_type_size \
			<= __meta_da_arr__int_type_size[`RD_INDEX(suffix)]; \
	end

	`RD_LAR(a)
	`RD_LAR(b)
	`RD_LAR(c)

	`undef RD_TAG
	`undef OUT_RD_PORT
	`undef RD_LAR

	// Writes happen during the first half of the clock cycle.
	always @(posedge clk)
	begin
		if (in_wr.req)
		begin
			__sh_da_arr__data[in_wr.index] <= in_wr.data;
		end
	end


endmodule
