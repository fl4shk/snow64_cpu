`include "src/snow64_lar_file_defines.header.sv"


module Snow64LarFile(input logic clk,
	input PkgSnow64LarFile::PortIn_LarFile_Ctrl in_ctrl,
	input PkgSnow64LarFile::PortIn_LarFile_Read in_rd_a, in_rd_b, in_rd_c,
	input PkgSnow64LarFile::PortIn_LarFile_Write in_wr,
	output PkgSnow64LarFile::PortOut_LarFile_Read
		out_rd_a, out_rd_b, out_rd_c,
	output PkgSnow64LarFile::PortOut_LarFile_MemWrite out_mem_write);

	import PkgSnow64Cpu::CpuAddr;
	import PkgSnow64LarFile::LarIndex;
	import PkgSnow64LarFile::LarAddrBasePtr8;
	import PkgSnow64LarFile::LarAddrOffset8;
	import PkgSnow64LarFile::LarAddrBasePtr16;
	import PkgSnow64LarFile::LarAddrOffset16;
	import PkgSnow64LarFile::LarAddrBasePtr32;
	import PkgSnow64LarFile::LarAddrOffset32;
	import PkgSnow64LarFile::LarAddrBasePtr64;
	import PkgSnow64LarFile::LarAddrOffset64;

	localparam __ARR_SIZE__NUM_LARS = `ARR_SIZE__SNOW64_LAR_FILE_NUM_LARS;
	localparam __LAST_INDEX__NUM_LARS 
		= `LAST_INDEX__SNOW64_LAR_FILE_NUM_LARS;





	// These are used mainly because Icarus Verilog does not, at the time
	// of this writing, support creating an array of packed structs.
	//
	// The other reason for these is that they will make it easier for me
	// to formally verify this module, as I have to convert this module to
	// Verilog first before I can formally verify it.

	// Meta data fields
	localparam __METADATA__ADDR_OFFSET_8__INDEX_LO = 0;
	localparam __METADATA__ADDR_OFFSET_8__INDEX_HI
		= `MAKE_INDEX_HI(__METADATA__ADDR_OFFSET_8__INDEX_LO,
		`WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_8);
	localparam __METADATA__ADDR_BASE_PTR_8__INDEX_LO
		= `MAKE_NEXT_INDEX_LO(__METADATA__ADDR_OFFSET_8__INDEX_HI);
	localparam __METADATA__ADDR_BASE_PTR_8__INDEX_HI
		= `MAKE_INDEX_HI(__METADATA__ADDR_BASE_PTR_8__INDEX_LO,
		`WIDTH__SNOW64_LAR_FILE_ADDR_BASE_PTR_8);

	localparam __METADATA__ADDR_OFFSET_16__INDEX_LO = 0;
	localparam __METADATA__ADDR_OFFSET_16__INDEX_HI
		= `MAKE_INDEX_HI(__METADATA__ADDR_OFFSET_16__INDEX_LO,
		`WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_16);
	localparam __METADATA__ADDR_BASE_PTR_16__INDEX_LO
		= `MAKE_NEXT_INDEX_LO(__METADATA__ADDR_OFFSET_16__INDEX_HI);
	localparam __METADATA__ADDR_BASE_PTR_16__INDEX_HI
		= `MAKE_INDEX_HI(__METADATA__ADDR_BASE_PTR_16__INDEX_LO,
		`WIDTH__SNOW64_LAR_FILE_ADDR_BASE_PTR_16);

	localparam __METADATA__ADDR_OFFSET_32__INDEX_LO = 0;
	localparam __METADATA__ADDR_OFFSET_32__INDEX_HI
		= `MAKE_INDEX_HI(__METADATA__ADDR_OFFSET_32__INDEX_LO,
		`WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_32);
	localparam __METADATA__ADDR_BASE_PTR_32__INDEX_LO
		= `MAKE_NEXT_INDEX_LO(__METADATA__ADDR_OFFSET_32__INDEX_HI);
	localparam __METADATA__ADDR_BASE_PTR_32__INDEX_HI
		= `MAKE_INDEX_HI(__METADATA__ADDR_BASE_PTR_32__INDEX_LO,
		`WIDTH__SNOW64_LAR_FILE_ADDR_BASE_PTR_32);

	localparam __METADATA__ADDR_OFFSET_64__INDEX_LO = 0;
	localparam __METADATA__ADDR_OFFSET_64__INDEX_HI
		= `MAKE_INDEX_HI(__METADATA__ADDR_OFFSET_64__INDEX_LO,
		`WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_64);
	localparam __METADATA__ADDR_BASE_PTR_64__INDEX_LO
		= `MAKE_NEXT_INDEX_LO(__METADATA__ADDR_OFFSET_64__INDEX_HI);
	localparam __METADATA__ADDR_BASE_PTR_64__INDEX_HI
		= `MAKE_INDEX_HI(__METADATA__ADDR_BASE_PTR_64__INDEX_LO,
		`WIDTH__SNOW64_LAR_FILE_ADDR_BASE_PTR_64);

	localparam __METADATA__WHOLE_ADDR__INDEX_LO = 0;
	localparam __METADATA__WHOLE_ADDR__INDEX_HI
		= `MAKE_INDEX_HI(__METADATA__WHOLE_ADDR__INDEX_LO,
		`WIDTH__SNOW64_CPU_ADDR);

	localparam __METADATA__TAG__INDEX_LO
		= `MAKE_NEXT_INDEX_LO(__METADATA__WHOLE_ADDR__INDEX_HI);
	localparam __METADATA__TAG__INDEX_HI
		= `MAKE_INDEX_HI(__METADATA__TAG__INDEX_LO,
		`WIDTH__SNOW64_LAR_FILE_METADATA_TAG);

	localparam __METADATA__DATA_TYPE__INDEX_LO
		= `MAKE_NEXT_INDEX_LO(__METADATA__TAG__INDEX_HI);
	localparam __METADATA__DATA_TYPE__INDEX_HI
		= `MAKE_INDEX_HI(__METADATA__DATA_TYPE__INDEX_LO,
		`WIDTH__SNOW64_CPU_DATA_TYPE);

	localparam __METADATA__INT_TYPE_SIZE__INDEX_LO
		= `MAKE_NEXT_INDEX_LO(__METADATA__DATA_TYPE__INDEX_HI);
	localparam __METADATA__INT_TYPE_SIZE__INDEX_HI
		= `MAKE_INDEX_HI(__METADATA__INT_TYPE_SIZE__INDEX_LO,
		`WIDTH__SNOW64_CPU_INT_TYPE_SIZE);

	localparam __MSB_POS__METADATA = __METADATA__INT_TYPE_SIZE__INDEX_HI;
	localparam __WIDTH__METADATA = `MP2WIDTH(__MSB_POS__METADATA);



	// Shared data fields
	localparam __SHAREDDATA__BASE_ADDR__INDEX_LO = 0;
	localparam __SHAREDDATA__BASE_ADDR__INDEX_HI
		= `MAKE_INDEX_HI(__SHAREDDATA__BASE_ADDR__INDEX_LO,
		`WIDTH__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR);

	localparam __SHAREDDATA__DATA__INDEX_LO
		= `MAKE_NEXT_INDEX_LO(__SHAREDDATA__BASE_ADDR__INDEX_HI);
	localparam __SHAREDDATA__DATA__INDEX_HI
		= `MAKE_INDEX_HI(__SHAREDDATA__DATA__INDEX_LO,
		`WIDTH__SNOW64_LAR_FILE_SHAREDDATA_DATA);

	localparam __SHAREDDATA__REF_COUNT__INDEX_LO
		= `MAKE_NEXT_INDEX_LO(__SHAREDDATA__DATA__INDEX_HI);
	localparam __SHAREDDATA__REF_COUNT__INDEX_HI
		= `MAKE_INDEX_HI(__SHAREDDATA__REF_COUNT__INDEX_LO,
		`WIDTH__SNOW64_LAR_FILE_SHAREDDATA_REF_COUNT);

	localparam __SHAREDDATA__DIRTY__INDEX_LO
		= `MAKE_NEXT_INDEX_LO(__SHAREDDATA__REF_COUNT__INDEX_HI);
	localparam __SHAREDDATA__DIRTY__INDEX_HI
		= `MAKE_INDEX_HI(__SHAREDDATA__DIRTY__INDEX_LO, 
		`WIDTH__SNOW64_LAR_FILE_SHAREDDATA_DIRTY);


	localparam __MSB_POS__SHAREDDATA = __SHAREDDATA__DIRTY__INDEX_HI;
	localparam __WIDTH__SHAREDDATA = `MP2WIDTH(__MSB_POS__SHAREDDATA);


	wire __in_ctrl__pause = in_ctrl.pause;

	wire [`MSB_POS__SNOW64_LAR_FILE_INDEX:0] 
		__in_rd_a__index = in_rd_a.index,
		__in_rd_b__index = in_rd_b.index,
		__in_rd_c__index = in_rd_c.index;


	wire __in_wr__req = in_wr.req;
	PkgSnow64LarFile::LarFileWriteType __in_wr__write_type;
	assign __in_wr__write_type = in_wr.write_type;
	wire [`MSB_POS__SNOW64_LAR_FILE_INDEX:0] __in_wr__index = in_wr.index;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __in_wr__data = in_wr.data;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __in_wr__addr = in_wr.addr;
	PkgSnow64Cpu::DataType __in_wr__data_type;
	assign __in_wr__data_type = in_wr.data_type;
	PkgSnow64Cpu::IntTypeSize __in_wr__int_type_size;
	assign __in_wr__int_type_size = in_wr.int_type_size;

	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] 
		__out_rd_a__data, __out_rd_b__data, __out_rd_c__data;
	assign out_rd_a.data = __out_rd_a__data;
	assign out_rd_b.data = __out_rd_b__data;
	assign out_rd_c.data = __out_rd_c__data;

	logic [`MSB_POS__SNOW64_CPU_ADDR:0]
		__out_rd_a__addr, __out_rd_b__addr, __out_rd_c__addr;
	assign out_rd_a.addr = __out_rd_a__addr;
	assign out_rd_b.addr = __out_rd_b__addr;
	assign out_rd_c.addr = __out_rd_c__addr;

	logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0]
		__out_rd_a__tag, __out_rd_b__tag, __out_rd_c__tag;
	assign out_rd_a.tag = __out_rd_a__tag;
	assign out_rd_b.tag = __out_rd_b__tag;
	assign out_rd_c.tag = __out_rd_c__tag;

	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0]
		__out_rd_a__data_type, __out_rd_b__data_type,
		__out_rd_c__data_type;
	assign out_rd_a.data_type = __out_rd_a__data_type;
	assign out_rd_b.data_type = __out_rd_b__data_type;
	assign out_rd_c.data_type = __out_rd_c__data_type;

	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__out_rd_a__int_type_size, __out_rd_b__int_type_size,
		__out_rd_c__int_type_size;
	assign out_rd_a.int_type_size = __out_rd_a__int_type_size;
	assign out_rd_b.int_type_size = __out_rd_b__int_type_size;
	assign out_rd_c.int_type_size = __out_rd_c__int_type_size;

	logic __out_mem_write__req;
	assign out_mem_write.req = __out_mem_write__req;

	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __out_mem_write__data;
	assign out_mem_write.data = __out_mem_write__data;

	logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__out_mem_write__base_addr;
	assign out_mem_write.base_addr = __out_mem_write__base_addr;


	// The arrays of LAR metadata and shared data.
	logic [__MSB_POS__METADATA:0] __lar_metadata
		[0 : __LAST_INDEX__NUM_LARS];

	logic [__MSB_POS__SHAREDDATA:0] __lar_shareddata
		[0 : __LAST_INDEX__NUM_LARS];







	//// For associativity
	//logic __found_sh_da_base_addr;

	// Incoming base_addr to be written to a LAR
	PkgSnow64LarFile::LarBaseAddr __in_wr__base_addr;
	assign __in_wr__base_addr = in_wr.addr;


	//`define TAG(index) __lar_metadata[index] `METADATA__TAG

	`define metadata_whole_addr(index) \
		__lar_metadata[index] [__METADATA__WHOLE_ADDR__INDEX_HI \
			: __METADATA__WHOLE_ADDR__INDEX_LO]

	task set_metadata_whole_addr(input LarIndex index,
		input CpuAddr n_whole_addr);

		`metadata_whole_addr(index) <= n_whole_addr;
	endtask


	`define metadata_addr_offset_8(index) \
		__lar_metadata[index] [__METADATA__ADDR_OFFSET_8__INDEX_HI \
			: __METADATA__ADDR_OFFSET_8__INDEX_LO]
	`define metadata_addr_base_ptr_8(index) \
		__lar_metadata[index] [__METADATA__ADDR_BASE_PTR_8__INDEX_HI \
			: __METADATA__ADDR_BASE_PTR_8__INDEX_LO]

	task set_metadata_addr_offset_8(input LarIndex index,
		input LarAddrOffset8 n_addr_offset_8);

		`metadata_addr_offset_8(index) <= n_addr_offset_8;
	endtask

	task set_metadata_addr_base_ptr_8(input LarIndex index,
		input LarAddrBasePtr8 n_addr_base_ptr_8);

		`metadata_addr_base_ptr_8(index) <= n_addr_base_ptr_8;
	endtask

	`define metadata_addr_offset_16(index) \
		__lar_metadata[index] [__METADATA__ADDR_OFFSET_16__INDEX_HI \
			: __METADATA__ADDR_OFFSET_16__INDEX_LO]
	`define metadata_addr_base_ptr_16(index) \
		__lar_metadata[index] [__METADATA__ADDR_BASE_PTR_16__INDEX_HI \
			: __METADATA__ADDR_BASE_PTR_16__INDEX_LO]
	task set_metadata_addr_offset_16(input LarIndex index,
		input LarAddrOffset16 n_addr_offset_16);

		`metadata_addr_offset_16(index) <= n_addr_offset_16;
	endtask
	task set_metadata_addr_base_ptr_16(input LarIndex index,
		input LarAddrBasePtr16 n_addr_base_ptr_16);

		`metadata_addr_base_ptr_16(index) <= n_addr_base_ptr_16;
	endtask

	`define metadata_addr_offset_32(index) \
		__lar_metadata[index] [__METADATA__ADDR_OFFSET_32__INDEX_HI \
			: __METADATA__ADDR_OFFSET_32__INDEX_LO]
	`define metadata_addr_base_ptr_32(index) \
		__lar_metadata[index] [__METADATA__ADDR_BASE_PTR_32__INDEX_HI \
			: __METADATA__ADDR_BASE_PTR_32__INDEX_LO]
	task set_metadata_addr_offset_32(input LarIndex index,
		input LarAddrOffset32 n_addr_offset_32);

		`metadata_addr_offset_32(index) <= n_addr_offset_32;
	endtask
	task set_metadata_addr_base_ptr_32(input LarIndex index,
		input LarAddrBasePtr32 n_addr_base_ptr_32);

		`metadata_addr_base_ptr_32(index) <= n_addr_base_ptr_32;
	endtask

	`define metadata_addr_offset_64(index) \
		__lar_metadata[index] [__METADATA__ADDR_OFFSET_64__INDEX_HI \
			: __METADATA__ADDR_OFFSET_64__INDEX_LO]
	`define metadata_addr_base_ptr_64(index) \
		__lar_metadata[index] [__METADATA__ADDR_BASE_PTR_64__INDEX_HI \
			: __METADATA__ADDR_BASE_PTR_64__INDEX_LO]
	task set_metadata_addr_offset_64(input LarIndex index,
		input LarAddrOffset64 n_addr_offset_64);

		`metadata_addr_offset_64(index) <= n_addr_offset_64;
	endtask
	task set_metadata_addr_base_ptr_64(input LarIndex index,
		input LarAddrBasePtr64 n_addr_base_ptr_64);

		`metadata_addr_base_ptr_64(index) <= n_addr_base_ptr_64;
	endtask




	// The LAR's tag... specifies which shared data is used by this LAR.
	`define metadata_tag(index) \
		__lar_metadata[index] [__METADATA__TAG__INDEX_HI \
			: __METADATA__TAG__INDEX_LO]

	// See PkgSnow64Cpu::DataType.
	`define metadata_data_type(index) \
		__lar_metadata[index] [__METADATA__DATA_TYPE__INDEX_HI \
			: __METADATA__DATA_TYPE__INDEX_LO]

	// See PkgSnow64Cpu::IntTypeSize.
	`define METADATA__INT_TYPE_SIZE \
		[__METADATA__INT_TYPE_SIZE__INDEX_HI \
		: __METADATA__INT_TYPE_SIZE__INDEX_LO]


	// LAR Shared Data stuff
	// Used for extracting the base_addr from a 64-bit address
	`define SHAREDDATA__INCOMING_BASE_ADDR `METADATA__ADDR_BASE_PTR_8

	// The base address, used for associativity between LARs.
	`define SHAREDDATA__BASE_ADDR \
		[__SHAREDDATA__BASE_ADDR__INDEX_HI \
		: __SHAREDDATA__BASE_ADDR__INDEX_LO]


	// The data itself.
	`define SHAREDDATA__DATA \
		[__SHAREDDATA__DATA__INDEX_HI \
		: __SHAREDDATA__DATA__INDEX_LO]

	// The reference count of this shared data.
	`define SHAREDDATA__REF_COUNT \
		[__SHAREDDATA__REF_COUNT__INDEX_HI \
		: __SHAREDDATA__REF_COUNT__INDEX_LO]

	// The "dirty" flag.  Used to determine if we should write back to
	// memory.
	`define SHAREDDATA__DIRTY \
		[__SHAREDDATA__DIRTY__INDEX_HI \
		: __SHAREDDATA__DIRTY__INDEX_LO]

	initial
	begin
		integer __i;
		for (__i=0; __i<__ARR_SIZE__NUM_LARS; __i=__i+1)
		begin
			__lar_metadata[__i] = 0;
			__lar_shareddata[__i] = 0;
		end
	end



	`define RD_INDEX(which) __in_rd_``which``__index

	`define RD_TAG(which) `TAG(`RD_INDEX(which))

	//`define GEN_RD(which) \
	//always_ff @(posedge clk) \
	//begin \
	//	__out_rd_``which``__data \
	//		<= __lar_shareddata[`RD_TAG(which)] `SHAREDDATA__DATA; \
	//	__out_rd_``which``__addr \
	//		<= __lar_metadata[`RD_INDEX(which)] `METADATA__WHOLE_ADDR; \
	//	__out_rd_``which``__tag <= `RD_TAG(which); \
	//end

	//`GEN_RD(a)
	//`GEN_RD(b)
	//`GEN_RD(c)

	`undef RD_INDEX
	`undef RD_TAG
	//`undef GEN_RD

	//always_ff @(posedge clk)
	//begin
	//	//__lar_metadata[1] `METADATA__TAG <= 1;
	//	`TAG(1) <= 1;

	//	if (__in_wr__req)
	//	begin
	//		if (__in_wr__index == 1)
	//		begin
	//			__lar_shareddata[`TAG(__in_wr__index)] 
	//				`SHAREDDATA__BASE_ADDR
	//				<= __in_wr__addr `SHAREDDATA__INCOMING_BASE_ADDR;
	//			__lar_shareddata[`TAG(__in_wr__index)] `SHAREDDATA__DATA
	//				<= __in_wr__data;
	//		end
	//	end
	//end

	`undef TAG
	`undef metadata_whole_addr



endmodule
