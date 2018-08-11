`include "src/snow64_lar_file_defines.header.sv"

//// For when we're done formally verifying the LAR file itself.
//// As of this writing, formal verification is totally done.
//`ifdef FORMAL
//`undef FORMAL
//`endif		// FORMAL

`ifdef FORMAL
`define SMALL_LAR_FILE
`endif

module Snow64LarFile(input logic clk,
	input PkgSnow64LarFile::PortIn_LarFile in,
	output PkgSnow64LarFile::PortOut_LarFile out);


	PkgSnow64LarFile::PartialPortIn_LarFile_Ctrl real_in_ctrl;
	PkgSnow64LarFile::PartialPortIn_LarFile_Read 
		real_in_rd_a, real_in_rd_b, real_in_rd_c;
	PkgSnow64LarFile::PartialPortIn_LarFile_Write real_in_wr;
	PkgSnow64LarFile::PartialPortIn_LarFile_MemRead real_in_mem_read;
	PkgSnow64LarFile::PartialPortIn_LarFile_MemWrite real_in_mem_write;

	PkgSnow64LarFile::PartialPortOut_LarFile_Read
		real_out_rd_a, real_out_rd_b, real_out_rd_c;
	PkgSnow64LarFile::PartialPortOut_LarFile_MemRead real_out_mem_read;
	PkgSnow64LarFile::PartialPortOut_LarFile_MemWrite
		real_out_mem_write;
	PkgSnow64LarFile::PartialPortOut_LarFile_WaitForMe
		real_out_wait_for_me;

	assign real_in_ctrl = in.ctrl;
	assign real_in_rd_a = in.rd_a;
	assign real_in_rd_b = in.rd_b;
	assign real_in_rd_c = in.rd_c;
	assign real_in_wr = in.wr;
	assign real_in_mem_read = in.mem_read;
	assign real_in_mem_write = in.mem_write;


	assign out.rd_a = real_out_rd_a;
	assign out.rd_b = real_out_rd_b;
	assign out.rd_c = real_out_rd_c;
	assign out.mem_read = real_out_mem_read;
	assign out.mem_write = real_out_mem_write;
	assign out.wait_for_me = real_out_wait_for_me;



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
	import PkgSnow64LarFile::LarTag;
	import PkgSnow64LarFile::LarData;
	import PkgSnow64LarFile::LarBaseAddr;
	import PkgSnow64LarFile::LarRefCount;
	import PkgSnow64LarFile::LarDirty;

	`ifndef FORMAL
	localparam __ARR_SIZE__NUM_LARS = `ARR_SIZE__SNOW64_LAR_FILE_NUM_LARS;
	localparam __LAST_INDEX__NUM_LARS 
		= `LAST_INDEX__SNOW64_LAR_FILE_NUM_LARS;
	`else // if defined(FORMAL)
		`ifdef SMALL_LAR_FILE
		// Verify the LAR file when there are only Four LARs 
		localparam __ARR_SIZE__NUM_LARS = 4;
		`else // if !defined(SMALL_LAR_FILE)
		localparam __ARR_SIZE__NUM_LARS
			= `ARR_SIZE__SNOW64_LAR_FILE_NUM_LARS;
		`endif		// SMALL_LAR_FILE
		localparam __LAST_INDEX__NUM_LARS
			= `ARR_SIZE_TO_LAST_INDEX(__ARR_SIZE__NUM_LARS);
	`endif // FORMAL


	`ifdef FORMAL
	// Mostly ALU/FPU operations.
	localparam __ENUM__WRITE_TYPE__ONLY_DATA 
		= PkgSnow64LarFile::WriteTypOnlyData;

	// Used for port-mapped input instructions
	localparam __ENUM__WRITE_TYPE__DATA_AND_TYPE
		= PkgSnow64LarFile::WriteTypDataAndType;

	// Used for load and store instructions.
	localparam __ENUM__WRITE_TYPE__LD = PkgSnow64LarFile::WriteTypLd;
	localparam __ENUM__WRITE_TYPE__ST = PkgSnow64LarFile::WriteTypSt;

	localparam __ENUM__WRITE_STATE__IDLE
		= PkgSnow64LarFile::WrStIdle;
	localparam __ENUM__WRITE_STATE__START_LD_ST
		= PkgSnow64LarFile::WrStStartLdSt;
	localparam __ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_READ
		= PkgSnow64LarFile::WrStWaitForJustMemRead;
	localparam __ENUM__WRITE_STATE__WAIT_FOR_JUST_MEM_WRITE
		= PkgSnow64LarFile::WrStWaitForJustMemWrite;

	localparam __ENUM__WRITE_STATE__WAIT_FOR_MEM_READ_AND_MEM_WRITE
		= PkgSnow64LarFile::WrStWaitForMemReadAndMemWrite;
	localparam __ENUM__WRITE_STATE__BAD_0
		= PkgSnow64LarFile::WrStBad0;
	localparam __ENUM__WRITE_STATE__BAD_1
		= PkgSnow64LarFile::WrStBad1;
	localparam __ENUM__WRITE_STATE__BAD_2
		= PkgSnow64LarFile::WrStBad2;

	localparam __ENUM__DATA_TYPE__UNSGN_INT
		= PkgSnow64Cpu::DataTypUnsgnInt;
	localparam __ENUM__DATA_TYPE__SGN_INT
		= PkgSnow64Cpu::DataTypSgnInt;
	localparam __ENUM__DATA_TYPE__BFLOAT16
		= PkgSnow64Cpu::DataTypBFloat16;
	localparam __ENUM__DATA_TYPE__RESERVED
		= PkgSnow64Cpu::DataTypReserved;

	localparam __ENUM__INT_TYPE_SIZE__8 = PkgSnow64Cpu::IntTypSz8;
	localparam __ENUM__INT_TYPE_SIZE__16 = PkgSnow64Cpu::IntTypSz16;
	localparam __ENUM__INT_TYPE_SIZE__32 = PkgSnow64Cpu::IntTypSz32;
	localparam __ENUM__INT_TYPE_SIZE__64 = PkgSnow64Cpu::IntTypSz64;
	`endif		// FORMAL

	localparam __UNALLOCATED_TAG = 0;

	logic [`MSB_POS__SNOW64_LAR_FILE_WRITE_STATE:0] __wr_state;



	// These are used mainly because Icarus Verilog does not, at the time
	// of this writing, support creating an array of packed structs.
	//
	// The other reason for these is that they will make it easier for me
	// to formally verify this module, as I have to convert this module to
	// Verilog first before I can formally verify it.

	// Metadata fields
	localparam __METADATA__DATA_INDEX__INDEX_LO = 0;
	localparam __METADATA__DATA_INDEX__INDEX_HI
		= `MAKE_INDEX_HI(__METADATA__DATA_INDEX__INDEX_LO,
		`WIDTH__SNOW64_LAR_FILE_ADDR_OFFSET_8);

	localparam __METADATA__TAG__INDEX_LO
		= `MAKE_NEXT_INDEX_LO(__METADATA__DATA_INDEX__INDEX_HI);
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



	localparam __MSB_POS__METADATA__DATA_INDEX
		= __METADATA__DATA_INDEX__INDEX_HI
		- __METADATA__DATA_INDEX__INDEX_LO;
	localparam __WIDTH__METADATA__DATA_INDEX
		= `MP2WIDTH(__MSB_POS__METADATA__DATA_INDEX);

	localparam __MSB_POS__METADATA__TAG
		= `WIDTH2MP($clog2(__ARR_SIZE__NUM_LARS));
	localparam __WIDTH__METADATA__TAG
		= `MP2WIDTH(__MSB_POS__METADATA__TAG);

	localparam __MSB_POS__METADATA__DATA_TYPE
		= __METADATA__DATA_TYPE__INDEX_HI
		- __METADATA__DATA_TYPE__INDEX_LO;
	localparam __WIDTH__METADATA__DATA_TYPE
		= `MP2WIDTH(__MSB_POS__METADATA__DATA_TYPE);

	localparam __MSB_POS__METADATA__INT_TYPE_SIZE
		= __METADATA__INT_TYPE_SIZE__INDEX_HI
		- __METADATA__INT_TYPE_SIZE__INDEX_LO;
	localparam __WIDTH__METADATA__INT_TYPE_SIZE
		= `MP2WIDTH(__MSB_POS__METADATA__INT_TYPE_SIZE);

	localparam __MSB_POS__SHAREDDATA__BASE_ADDR
		= __SHAREDDATA__BASE_ADDR__INDEX_HI
		- __SHAREDDATA__BASE_ADDR__INDEX_LO;
	localparam __WIDTH__SHAREDDATA__BASE_ADDR
		= `MP2WIDTH(__MSB_POS__SHAREDDATA__BASE_ADDR);

	localparam __MSB_POS__SHAREDDATA__DATA
		= __SHAREDDATA__DATA__INDEX_HI
		- __SHAREDDATA__DATA__INDEX_LO;
	localparam __WIDTH__SHAREDDATA__DATA
		= `MP2WIDTH(__MSB_POS__SHAREDDATA__DATA);

	localparam __MSB_POS__SHAREDDATA__REF_COUNT
		= __MSB_POS__METADATA__TAG;
	localparam __WIDTH__SHAREDDATA__REF_COUNT
		= `MP2WIDTH(__MSB_POS__SHAREDDATA__REF_COUNT);

	localparam __MSB_POS__SHAREDDATA__DIRTY
		= __SHAREDDATA__DIRTY__INDEX_HI
		- __SHAREDDATA__DIRTY__INDEX_LO;
	localparam __WIDTH__SHAREDDATA__DIRTY
		= `MP2WIDTH(__MSB_POS__SHAREDDATA__DIRTY);

	//wire __in_ctrl__mem_bus_guard_instr_load_busy
	//	= real_in_ctrl.mem_bus_guard_instr_load_busy;
	wire __in_ctrl__mem_bus_guard_busy 
		= real_in_ctrl.mem_bus_guard_busy;

	wire [__MSB_POS__METADATA__TAG:0] 
		__in_rd_a__index = real_in_rd_a.index[__MSB_POS__METADATA__TAG:0],
		__in_rd_b__index = real_in_rd_b.index[__MSB_POS__METADATA__TAG:0],
		__in_rd_c__index = real_in_rd_c.index[__MSB_POS__METADATA__TAG:0];

	wire __in_wr__req = real_in_wr.req;
	wire [`MSB_POS__SNOW64_LAR_FILE_WRITE_TYPE:0] __in_wr__write_type
		= real_in_wr.write_type;


	logic [`MSB_POS__SNOW64_LAR_FILE_WRITE_TYPE:0]
		__captured_in_wr__write_type;
	// The index of the LAR we want to read data into.
	logic [__MSB_POS__METADATA__TAG:0] __captured_in_wr__index;
	// Incoming base_addr to be written to a LAR
	PkgSnow64LarFile::LarIncomingBaseAddr __captured_in_wr__base_addr;
	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] __captured_in_wr__data_type;
	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__captured_in_wr__int_type_size;

	wire [__MSB_POS__METADATA__TAG:0] __in_wr__index
		= real_in_wr.index[__MSB_POS__METADATA__TAG:0];

	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __in_wr__data
		= real_in_wr.data;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __in_wr__addr = real_in_wr.addr;
	wire [`MSB_POS__SNOW64_CPU_DATA_TYPE:0] __in_wr__data_type
		= real_in_wr.data_type;
	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] __in_wr__int_type_size
		= real_in_wr.int_type_size;


	wire __in_mem_read__valid = real_in_mem_read.valid;
	wire __in_mem_read__busy = real_in_mem_read.busy;
	wire [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_DATA:0]
		__in_mem_read__data = real_in_mem_read.data;

	wire __in_mem_write__valid = real_in_mem_write.valid;
	wire __in_mem_write__busy = real_in_mem_write.busy;

	// For when we're both reading from and writing to memory
	logic __captured_in_mem_read__valid, __captured_in_mem_write__valid;


	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] 
		__out_rd_a__data, __out_rd_b__data, __out_rd_c__data;
	assign real_out_rd_a.data = __out_rd_a__data;
	assign real_out_rd_b.data = __out_rd_b__data;
	assign real_out_rd_c.data = __out_rd_c__data;

	logic [`MSB_POS__SNOW64_CPU_ADDR:0]
		__out_rd_a__addr, __out_rd_b__addr, __out_rd_c__addr;
	assign real_out_rd_a.addr = __out_rd_a__addr;
	assign real_out_rd_b.addr = __out_rd_b__addr;
	assign real_out_rd_c.addr = __out_rd_c__addr;

	logic [`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0]
		__out_rd_a__tag, __out_rd_b__tag, __out_rd_c__tag;
	assign real_out_rd_a.tag = __out_rd_a__tag;
	assign real_out_rd_b.tag = __out_rd_b__tag;
	assign real_out_rd_c.tag = __out_rd_c__tag;

	logic [`MSB_POS__SNOW64_CPU_DATA_TYPE:0]
		__out_rd_a__data_type, __out_rd_b__data_type,
		__out_rd_c__data_type;
	assign real_out_rd_a.data_type = __out_rd_a__data_type;
	assign real_out_rd_b.data_type = __out_rd_b__data_type;
	assign real_out_rd_c.data_type = __out_rd_c__data_type;

	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__out_rd_a__int_type_size, __out_rd_b__int_type_size,
		__out_rd_c__int_type_size;
	assign real_out_rd_a.int_type_size = __out_rd_a__int_type_size;
	assign real_out_rd_b.int_type_size = __out_rd_b__int_type_size;
	assign real_out_rd_c.int_type_size = __out_rd_c__int_type_size;

	logic __out_mem_read__req;
	assign real_out_mem_read.req = __out_mem_read__req;

	logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__out_mem_read__base_addr;
	assign real_out_mem_read.base_addr = __out_mem_read__base_addr;

	logic __out_mem_write__req;
	assign real_out_mem_write.req = __out_mem_write__req;

	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __out_mem_write__data;
	assign real_out_mem_write.data = __out_mem_write__data;

	logic [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__out_mem_write__base_addr;
	assign real_out_mem_write.base_addr = __out_mem_write__base_addr;

	logic __out_wait_for_me__busy;
	assign real_out_wait_for_me.busy = __out_wait_for_me__busy;

	assign __out_wait_for_me__busy
		= (__wr_state != PkgSnow64LarFile::WrStIdle);


	// The arrays of LAR metadata and shared data.
	logic [__MSB_POS__METADATA__DATA_INDEX : 0]
		__lar_metadata__data_index[0 : __LAST_INDEX__NUM_LARS];
	`ifdef FORMAL
	logic [__MSB_POS__METADATA__DATA_INDEX : 0]
		__debug_lar_metadata__data_index[0 : __LAST_INDEX__NUM_LARS];
	`endif		// FORMAL

	logic [__MSB_POS__METADATA__TAG : 0]
		__lar_metadata__tag[0 : __LAST_INDEX__NUM_LARS];
	`ifdef FORMAL
	logic [__MSB_POS__METADATA__TAG : 0]
		__debug_lar_metadata__tag[0 : __LAST_INDEX__NUM_LARS];
	`endif		// FORMAL

	logic [__MSB_POS__METADATA__DATA_TYPE : 0]
		__lar_metadata__data_type[0 : __LAST_INDEX__NUM_LARS];
	`ifdef FORMAL
	logic [__MSB_POS__METADATA__DATA_TYPE : 0]
		__debug_lar_metadata__data_type[0 : __LAST_INDEX__NUM_LARS];
	`endif		// FORMAL

	logic [__MSB_POS__METADATA__INT_TYPE_SIZE : 0]
		__lar_metadata__int_type_size[0 : __LAST_INDEX__NUM_LARS];
	`ifdef FORMAL
	logic [__MSB_POS__METADATA__INT_TYPE_SIZE : 0]
		__debug_lar_metadata__int_type_size[0 : __LAST_INDEX__NUM_LARS];
	`endif		// FORMAL


	//logic [__MSB_POS__SHAREDDATA:0] __lar_shareddata
	//	[0 : __LAST_INDEX__NUM_LARS];
	logic [__MSB_POS__SHAREDDATA__BASE_ADDR : 0]
		__lar_shareddata__base_addr[0 : __LAST_INDEX__NUM_LARS];
	`ifdef FORMAL
	logic [__MSB_POS__SHAREDDATA__BASE_ADDR : 0]
		__debug_lar_shareddata__base_addr[0 : __LAST_INDEX__NUM_LARS];
	`endif		// FORMAL

	logic [__MSB_POS__SHAREDDATA__DATA : 0]
		__lar_shareddata__data[0 : __LAST_INDEX__NUM_LARS];
	`ifdef FORMAL
	logic [__MSB_POS__SHAREDDATA__DATA : 0]
		__debug_lar_shareddata__data[0 : __LAST_INDEX__NUM_LARS];
	`endif		// FORMAL

	logic [__MSB_POS__SHAREDDATA__REF_COUNT : 0]
		__lar_shareddata__ref_count[0 : __LAST_INDEX__NUM_LARS];
	`ifdef FORMAL
	logic [__MSB_POS__SHAREDDATA__REF_COUNT : 0]
		__debug_lar_shareddata__ref_count[0 : __LAST_INDEX__NUM_LARS];
	`endif		// FORMAL

	logic [__MSB_POS__SHAREDDATA__DIRTY : 0]
		__lar_shareddata__dirty[0 : __LAST_INDEX__NUM_LARS];
	`ifdef FORMAL
	logic [__MSB_POS__SHAREDDATA__DIRTY : 0]
		__debug_lar_shareddata__dirty[0 : __LAST_INDEX__NUM_LARS];
	`endif		// FORMAL

	`ifdef FORMAL
	always_ff @(posedge clk)
	begin
		integer i;

		for (i=0; i<__ARR_SIZE__NUM_LARS; i=i+1)
		begin
			__debug_lar_metadata__data_index[i]
				<= __lar_metadata__data_index[i];
			__debug_lar_metadata__tag[i]
				<= __lar_metadata__tag[i];
			__debug_lar_metadata__data_type[i]
				<= __lar_metadata__data_type[i];
			__debug_lar_metadata__int_type_size[i]
				<= __lar_metadata__int_type_size[i];

			__debug_lar_shareddata__base_addr[i]
				<= __lar_shareddata__base_addr[i];
			__debug_lar_shareddata__data[i]
				<= __lar_shareddata__data[i];
			__debug_lar_shareddata__ref_count[i]
				<= __lar_shareddata__ref_count[i];
			__debug_lar_shareddata__dirty[i]
				<= __lar_shareddata__dirty[i];
		end
	end
	`endif		// FORMAL


	// Used for allocating/deallocating shared data.
	//logic [__METADATA__TAG__INDEX_HI - __METADATA__TAG__INDEX_LO : 0]
	//	__lar_tag_stack[0 : __LAST_INDEX__NUM_LARS];
	//logic [__METADATA__TAG__INDEX_HI - __METADATA__TAG__INDEX_LO : 0]
	//	__curr_tag_stack_index;
	logic [__MSB_POS__METADATA__TAG : 0]
		__lar_tag_stack[0 : __LAST_INDEX__NUM_LARS];
	logic [__MSB_POS__METADATA__TAG : 0]
		__curr_tag_stack_index;

	logic [__MSB_POS__METADATA__TAG:0] __captured_tag_search_final;
	`ifndef FORMAL
	logic [__MSB_POS__METADATA__TAG : 0]
		__tag_search_0, __tag_search_1, __tag_search_2, __tag_search_3,
		__tag_search_final;
	`else // if !defined(FORMAL)
	logic __found_tag;
	//logic __eek;
	logic [__MSB_POS__METADATA__TAG : 0] __debug_tag_search_final;

	initial
	begin
		__debug_tag_search_final = 0;
		__found_tag = 0;
	end
	`endif		// FORMAL










	//`define TAG(index) __lar_metadata[index] `METADATA__TAG

	`define metadata_data_index(index) \
		__lar_metadata__data_index[index]





	// The LAR's tag... specifies which shared data is used by this LAR.
	`define metadata_tag(index) \
		__lar_metadata__tag[index] \

	// See PkgSnow64Cpu::DataType.
	`define metadata_data_type(index) \
		__lar_metadata__data_type[index]

	// See PkgSnow64Cpu::IntTypeSize.
	`define metadata_int_type_size(index) \
		__lar_metadata__int_type_size[index]


	// LAR Shared Data stuff
	// Used for extracting the base_addr from a 64-bit address

	// The base address, used for associativity between LARs.
	`define shareddata_base_addr(index) \
		__lar_shareddata__base_addr[index]
	`define shareddata_tagged_base_addr(index) \
		`shareddata_base_addr(`metadata_tag(index))


	// The data itself.
	`define shareddata_data(index) \
		__lar_shareddata__data[index] 
	`define shareddata_tagged_data(index) \
		`shareddata_data(`metadata_tag(index))

	// The reference count of this shared data.
	`define shareddata_ref_count(index) \
		__lar_shareddata__ref_count[index] 
	`define shareddata_tagged_ref_count(index) \
		`shareddata_ref_count(`metadata_tag(index))

	// The "dirty" flag.  Used to determine if we should write back to
	// memory.
	`define shareddata_dirty(index) \
		__lar_shareddata__dirty[index]
	`define shareddata_tagged_dirty(index) \
		`shareddata_dirty(`metadata_tag(index))

	initial
	begin
		integer __i;

		__wr_state = PkgSnow64LarFile::WrStIdle;

		for (__i=0; __i<__ARR_SIZE__NUM_LARS; __i=__i+1)
		begin
			__lar_metadata__data_index[__i] = 0;

			__lar_metadata__tag[__i] = __UNALLOCATED_TAG;
			//__lar_metadata__tag[__i] = __LAST_INDEX__NUM_LARS;
			__lar_metadata__data_type[__i] = 0;
			__lar_metadata__int_type_size[__i] = 0;

			__lar_shareddata__base_addr[__i] = 0;
			__lar_shareddata__data[__i] = 0;
			__lar_shareddata__ref_count[__i] = 0;
			__lar_shareddata__dirty[__i] = 0;

			// Fill up the stack of tags.
			__lar_tag_stack[__i] = __i;
		end

		__captured_in_wr__index = 0;
		__captured_in_wr__base_addr = 0;
		__captured_in_wr__write_type = 0;
		__captured_in_wr__data_type = 0;
		__captured_in_wr__int_type_size = 0;
		__captured_in_mem_read__valid = 0;
		__captured_in_mem_write__valid = 0;
		__curr_tag_stack_index = __LAST_INDEX__NUM_LARS;
		{__out_rd_a__data, __out_rd_b__data, __out_rd_c__data} = 0;
		{__out_rd_a__addr, __out_rd_b__addr, __out_rd_c__addr} = 0;
		{__out_rd_a__tag, __out_rd_b__tag, __out_rd_c__tag} = 0;
		{__out_rd_a__data_type, __out_rd_b__data_type,
			__out_rd_c__data_type} = 0;
		{__out_rd_a__int_type_size, __out_rd_b__int_type_size,
			__out_rd_c__int_type_size} = 0;

		__out_mem_read__req = 0;
		__out_mem_read__base_addr = 0;

		__out_mem_write__req = 0;
		__out_mem_write__data = 0;
		__out_mem_write__base_addr = 0;
	end



	`define RD_INDEX(which) __in_rd_``which``__index

	`define GEN_RD(which) \
	always @(posedge clk) \
	begin \
		__out_rd_``which``__data \
			<= `shareddata_tagged_data(`RD_INDEX(which));\
		case (`metadata_data_type(`RD_INDEX(which))) \
		PkgSnow64Cpu::DataTypBFloat16: \
		begin \
			__out_rd_``which``__addr \
				<= {`shareddata_tagged_base_addr(`RD_INDEX(which)), \
					`EXTRACT_DATA_INDEX__16 \
					(__METADATA__DATA_INDEX__INDEX_HI, \
					`metadata_data_index \
					(`RD_INDEX(which)))}; \
		end \
		\
		/* We don't care about DataTypReserved */ \
		PkgSnow64Cpu::DataTypReserved: \
		begin \
			__out_rd_``which``__addr \
				<= {`shareddata_tagged_base_addr(`RD_INDEX(which)), \
				{`MP2WIDTH(__METADATA__DATA_INDEX__INDEX_HI){1'b0}}}; \
		end \
		\
		/* An integer of either signedness */ \
		default: \
		begin \
			case (`metadata_int_type_size(`RD_INDEX(which))) \
			PkgSnow64Cpu::IntTypSz8: \
			begin \
				__out_rd_``which``__addr \
					<= {`shareddata_tagged_base_addr(`RD_INDEX(which)), \
						`EXTRACT_DATA_INDEX__8 \
						(__METADATA__DATA_INDEX__INDEX_HI, \
						`metadata_data_index \
						(`RD_INDEX(which)))}; \
			end \
			\
			PkgSnow64Cpu::IntTypSz16: \
			begin \
				__out_rd_``which``__addr \
					<= {`shareddata_tagged_base_addr(`RD_INDEX(which)), \
						`EXTRACT_DATA_INDEX__16 \
						(__METADATA__DATA_INDEX__INDEX_HI, \
						`metadata_data_index \
						(`RD_INDEX(which)))}; \
			end \
			\
			PkgSnow64Cpu::IntTypSz32: \
			begin \
				__out_rd_``which``__addr \
					<= {`shareddata_tagged_base_addr(`RD_INDEX(which)), \
						`EXTRACT_DATA_INDEX__32 \
						(__METADATA__DATA_INDEX__INDEX_HI, \
						`metadata_data_index \
						(`RD_INDEX(which)))}; \
			end \
			\
			PkgSnow64Cpu::IntTypSz64: \
			begin \
				__out_rd_``which``__addr \
					<= {`shareddata_tagged_base_addr(`RD_INDEX(which)), \
						`EXTRACT_DATA_INDEX__64 \
						(__METADATA__DATA_INDEX__INDEX_HI, \
						`metadata_data_index \
						(`RD_INDEX(which)))}; \
			end \
			endcase \
		end \
		endcase \
		__out_rd_``which``__tag \
			<= `metadata_tag(`RD_INDEX(which)); \
		__out_rd_``which``__data_type \
			<= `metadata_data_type(`RD_INDEX(which)); \
		__out_rd_``which``__int_type_size \
			<= `metadata_int_type_size(`RD_INDEX(which)); \
	end

	`GEN_RD(a)
	`GEN_RD(b)
	`GEN_RD(c)

	`undef RD_INDEX
	`undef GEN_RD

	`define do_tag_search(index) \
		((`shareddata_ref_count(index) \
		&& (`shareddata_base_addr(index) \
		== __captured_in_wr__base_addr.base_addr)) \
		? index : 0)

	`ifdef FORMAL
	`define actual_tag_search_0 (`do_tag_search(1) | `do_tag_search(2) \
		| `do_tag_search(3))
		`ifndef SMALL_LAR_FILE
		`define actual_tag_search_1 \
			(`do_tag_search(4) | `do_tag_search(5) \
			| `do_tag_search(6) | `do_tag_search(7))
		`define actual_tag_search_2  \
			(`do_tag_search(8) | `do_tag_search(9) \
			| `do_tag_search(10) | `do_tag_search(11))
		`define actual_tag_search_3 \
			(`do_tag_search(12) | `do_tag_search(13) \
			| `do_tag_search(14) | `do_tag_search(15))
		`else // if defined(SMALL_LAR_FILE)
		`define actual_tag_search_1 0
		`define actual_tag_search_2 0
		`define actual_tag_search_3 0 
		`endif		// !defined(SMALL_LAR_FILE)

	`define actual_tag_search_final (`actual_tag_search_0 \
		| `actual_tag_search_1 | `actual_tag_search_2 \
		| `actual_tag_search_3)

	`else // if !defined(FORMAL)
	assign __tag_search_0 = `do_tag_search(1) | `do_tag_search(2)
		| `do_tag_search(3);

	assign __tag_search_1 = `do_tag_search(4) | `do_tag_search(5)
		| `do_tag_search(6) | `do_tag_search(7);

	assign __tag_search_2 = `do_tag_search(8) | `do_tag_search(9)
		| `do_tag_search(10) | `do_tag_search(11);

	assign __tag_search_3 = `do_tag_search(12) | `do_tag_search(13)
		| `do_tag_search(14) | `do_tag_search(15);

	assign __tag_search_final = __tag_search_0 | __tag_search_1
		| __tag_search_2 | __tag_search_3;

	`define actual_tag_search_0 __tag_search_0
	`define actual_tag_search_1 __tag_search_1
	`define actual_tag_search_2 __tag_search_2
	`define actual_tag_search_3 __tag_search_3
	`define actual_tag_search_final __tag_search_final
	`endif		// FORMAL




	`define incoming__wr_metadata_data_index \
		`metadata_data_index(__in_wr__index)
	`define incoming__wr_metadata_data_type \
		`metadata_data_type(__in_wr__index)
	`define incoming__wr_metadata_int_type_size \
		`metadata_int_type_size(__in_wr__index)
	`define incoming__wr_metadata_tag \
		`metadata_tag(__in_wr__index)

	`define captured__wr_metadata_tag \
		`metadata_tag(__captured_in_wr__index)

	`define top_metadata_tag \
		__lar_tag_stack[__curr_tag_stack_index]
	`define above_top_metadata_tag \
		__lar_tag_stack[__curr_tag_stack_index + 1]

	`define captured__wr_curr_shareddata_base_addr \
		`shareddata_tagged_base_addr(__captured_in_wr__index)
	`define wr_aliased_shareddata_base_addr \
		`shareddata_base_addr(__captured_tag_search_final)
	`define wr_to_allocate_shareddata_base_addr \
		`shareddata_base_addr(`top_metadata_tag)

	`define incoming__wr_curr_shareddata_data \
		`shareddata_tagged_data(__in_wr__index)
	`define captured__wr_curr_shareddata_data \
		`shareddata_tagged_data(__captured_in_wr__index)
	`define wr_aliased_shareddata_data \
		`shareddata_data(__captured_tag_search_final)
	`define wr_to_allocate_shareddata_data \
		`shareddata_data(`top_metadata_tag)

	`define incoming__wr_curr_shareddata_dirty \
		`shareddata_tagged_dirty(__in_wr__index)
	`define captured__wr_curr_shareddata_dirty \
		`shareddata_tagged_dirty(__captured_in_wr__index)
	`define wr_aliased_shareddata_dirty \
		`shareddata_dirty(__captured_tag_search_final)
	`define wr_to_allocate_shareddata_dirty \
		`shareddata_dirty(`top_metadata_tag)

	`define captured__wr_curr_shareddata_ref_count \
		`shareddata_tagged_ref_count(__captured_in_wr__index)
	`define wr_aliased_shareddata_ref_count \
		`shareddata_ref_count(__captured_tag_search_final)
	`define wr_to_allocate_shareddata_ref_count \
		`shareddata_ref_count(`top_metadata_tag)

	task stop_mem_read;
		__out_mem_read__req <= 0;
	endtask : stop_mem_read

	//task prep_mem_read;
	//	__out_mem_read__req <= 1;
	//	__out_mem_read__base_addr
	//		<= `shareddata_tagged_base_addr(__captured_in_wr__index);
	//endtask

	// Reads from memory ALWAYS use the captured base addr
	task prep_mem_read;
		__out_mem_read__req <= 1;
		__out_mem_read__base_addr <= __captured_in_wr__base_addr.base_addr;
	endtask : prep_mem_read

	task stop_mem_write;
		__out_mem_write__req <= 0;
	endtask : stop_mem_write

	task send_shareddata_to_mem(input LarTag tag);
		__out_mem_write__req <= 1;
		__out_mem_write__data <= `shareddata_data(tag);
		__out_mem_write__base_addr <= `shareddata_base_addr(tag);
	endtask : send_shareddata_to_mem

	//always @(posedge clk)
	//begin
	//	case (__wr_state)
	//	PkgSnow64LarFile::WrStIdle:
	//	begin
	//		stop_mem_read();
	//		__captured_in_wr__index <= __in_wr__index;
	//		__captured_in_mem_read__valid <= 0;
	//		__captured_in_mem_write__valid <= 0;

	//		if (__in_wr__req && (__in_wr__index != 0))
	//		begin
	//			case (__in_wr__write_type)
	//			// Mostly ALU/FPU operations.
	//			PkgSnow64LarFile::WriteTypOnlyData:
	//			begin
	//				if (`wr_metadata_tag != __UNALLOCATED_TAG)
	//				begin
	//					// Data identical to what we have means we might
	//					// not have to touch memory.
	//					if (`wr_curr_shareddata_data != __in_wr__data)
	//					begin
	//						`wr_curr_shareddata_dirty <= 1;
	//					end
	//					`wr_curr_shareddata_data <= __in_wr__data;
	//				end

	//				stop_mem_write();

	//				`ifdef FORMAL
	//				__debug_tag_search_final <= 0;
	//				__found_tag <= 0;
	//				`endif		// FORMAL
	//			end

	//			// Used for port-mapped input instructions
	//			PkgSnow64LarFile::WriteTypDataAndType:
	//			begin
	//				if (`wr_metadata_tag != __UNALLOCATED_TAG)
	//				begin
	//					`wr_metadata_data_type <= __in_wr__data_type;
	//					`wr_metadata_int_type_size
	//						<= __in_wr__int_type_size;


	//					// We basically have to convert the index from one
	//					// type to another here.
	//					case (__in_wr__data_type)
	//					PkgSnow64Cpu::DataTypBFloat16:
	//					begin
	//						// BFloat16's here are actually 16-bit, or two
	//						// bytes.
	//						`wr_metadata_data_index
	//							<= `EXTRACT_DATA_INDEX__16(
	//							__METADATA__DATA_INDEX__INDEX_HI,
	//							`wr_metadata_data_index);
	//					end

	//					PkgSnow64Cpu::DataTypReserved:
	//					begin
	//						// As usual, we don't care about
	//						// DataTypReserved.
	//						`wr_metadata_data_index <= 0;
	//					end

	//					// An integer of either signedness
	//					default:
	//					begin
	//						case (__in_wr__int_type_size)
	//						PkgSnow64Cpu::IntTypSz8:
	//						begin
	//							`wr_metadata_data_index
	//								<= `EXTRACT_DATA_INDEX__8(
	//								__METADATA__DATA_INDEX__INDEX_HI,
	//								`wr_metadata_data_index);
	//						end

	//						PkgSnow64Cpu::IntTypSz16:
	//						begin
	//							`wr_metadata_data_index
	//								<= `EXTRACT_DATA_INDEX__16(
	//								__METADATA__DATA_INDEX__INDEX_HI,
	//								`wr_metadata_data_index);
	//						end

	//						PkgSnow64Cpu::IntTypSz32:
	//						begin
	//							`wr_metadata_data_index
	//								<= `EXTRACT_DATA_INDEX__32(
	//								__METADATA__DATA_INDEX__INDEX_HI,
	//								`wr_metadata_data_index);
	//						end

	//						PkgSnow64Cpu::IntTypSz64:
	//						begin
	//							`wr_metadata_data_index
	//								<= `EXTRACT_DATA_INDEX__64(
	//								__METADATA__DATA_INDEX__INDEX_HI,
	//								`wr_metadata_data_index);
	//						end
	//						endcase
	//					end
	//					endcase


	//					// Data identical to what we have means we might
	//					// not have to touch memory.
	//					if (`wr_curr_shareddata_data != __in_wr__data)
	//					begin
	//						`wr_curr_shareddata_dirty <= 1;
	//					end
	//					`wr_curr_shareddata_data <= __in_wr__data;
	//				end

	//				stop_mem_write();

	//				`ifdef FORMAL
	//				__debug_tag_search_final <= 0;
	//				__found_tag <= 0;
	//				`endif		// FORMAL
	//			end

	//			// PkgSnow64LarFile::WriteTypLd or
	//			// PkgSnow64LarFile::WriteTypSt
	//			default:
	//			begin
	//				case (__in_wr__data_type)
	//				PkgSnow64Cpu::DataTypBFloat16:
	//				begin
	//					// BFloat16's are 16-bit, or two bytes.
	//					`wr_metadata_data_index
	//						<= `EXTRACT_DATA_INDEX__16(
	//						__METADATA__DATA_INDEX__INDEX_HI,
	//						__in_wr__addr);
	//				end

	//				// We don't care about DataTypReserved
	//				PkgSnow64Cpu::DataTypReserved:
	//				begin
	//					`wr_metadata_data_index <= 0;
	//				end

	//				// An integer of either signedness
	//				default:
	//				begin
	//					case (__in_wr__int_type_size)
	//					PkgSnow64Cpu::IntTypSz8:
	//					begin
	//						`wr_metadata_data_index
	//							<= `EXTRACT_DATA_INDEX__8(
	//							__METADATA__DATA_INDEX__INDEX_HI,
	//							__in_wr__addr);
	//					end

	//					PkgSnow64Cpu::IntTypSz16:
	//					begin
	//						`wr_metadata_data_index
	//							<= `EXTRACT_DATA_INDEX__16(
	//							__METADATA__DATA_INDEX__INDEX_HI,
	//							__in_wr__addr);
	//					end

	//					PkgSnow64Cpu::IntTypSz32:
	//					begin
	//						`wr_metadata_data_index
	//							<= `EXTRACT_DATA_INDEX__32(
	//							__METADATA__DATA_INDEX__INDEX_HI,
	//							__in_wr__addr);
	//					end

	//					PkgSnow64Cpu::IntTypSz64:
	//					begin
	//						`wr_metadata_data_index
	//							<= `EXTRACT_DATA_INDEX__64(
	//							__METADATA__DATA_INDEX__INDEX_HI,
	//							__in_wr__addr);
	//					end
	//					endcase
	//				end
	//				endcase

	//				`wr_metadata_data_type <= __in_wr__data_type;
	//				`wr_metadata_int_type_size <= __in_wr__int_type_size;

	//				`ifdef FORMAL
	//				__debug_tag_search_final <= `actual_tag_search_final;
	//				__found_tag <= `actual_tag_search_final != 0;
	//				`endif		// FORMAL

	//				// The address's data is already in at least one LAR.
	//				if (`actual_tag_search_final != 0)
	//				begin
	//					// A tag already exists.  We set our tag to the
	//					// existing one.
	//					`wr_metadata_tag <= `actual_tag_search_final;

	//					// Loads of data we already had don't affect the
	//					// dirty flag.

	//					// If our existing tag ISN'T the one we found.
	//					if (`actual_tag_search_final != `wr_metadata_tag)
	//					begin
	//						`wr_aliased_shareddata_ref_count
	//							<= `wr_aliased_shareddata_ref_count + 1;

	//						if (__in_wr__write_type 
	//							== PkgSnow64LarFile::WriteTypSt)
	//						begin
	//							// Make a copy of our data to the new
	//							// address.  This also causes us to need to
	//							// set the dirty flag.
	//							`wr_aliased_shareddata_data
	//								<= `wr_curr_shareddata_data;
	//							`wr_aliased_shareddata_dirty <= 1;
	//						end


	//						case (`wr_curr_shareddata_ref_count)
	//						// We haven't been allocated yet.
	//						0:
	//						begin
	//							stop_mem_write();
	//						end

	//						// There were no other references to us, so
	//						// deallocate the old tag (pushing it onto the
	//						// stack), and (if we were dirty) send our old
	//						// data out to memory.
	//						1:
	//						begin
	//							// Deallocate our old tag.
	//							`above_top_metadata_tag
	//								<= `wr_metadata_tag;
	//							__curr_tag_stack_index
	//								<= __curr_tag_stack_index + 1;

	//							// Since we're deallocating stuff, we need
	//							// to write our old data back to memory if
	//							// it's not already up to date.
	//							if (`wr_curr_shareddata_dirty)
	//							begin
	//								send_shareddata_to_mem
	//									(`wr_metadata_tag);
	//								__wr_state <= 
	//							end
	//							else
	//							begin
	//								stop_mem_write();
	//							end

	//							// We were the only LAR that cared about
	//							// our old shared data, which means our old
	//							// shared data becomes free for other use.
	//							`wr_curr_shareddata_ref_count <= 0;

	//							// We don't need to write any data out to
	//							// memory if 
	//							`wr_curr_shareddata_dirty <= 0;

	//							// For good measure.
	//							`wr_curr_shareddata_base_addr <= 0;
	//							`wr_curr_shareddata_data <= 0;
	//						end

	//						// There was at least one other reference to
	//						// us, so don't deallocate anything, but do
	//						// decrement the reference count.
	//						default:
	//						begin
	//							`wr_curr_shareddata_ref_count
	//								<= `wr_curr_shareddata_ref_count - 1;
	//							stop_mem_write();
	//						end
	//						endcase
	//					end

	//					else
	//					begin
	//						stop_mem_write();
	//					end
	//				end

	//				// We didn't find any aliases of __in_wr__addr.
	//				else // if (`actual_tag_search_final == 0)
	//				begin
	//					case (`wr_curr_shareddata_ref_count)
	//					// This is from before we were allocated.
	//					0:
	//					begin
	//						// Allocate a new element of shared data.
	//						`wr_metadata_tag <= `top_metadata_tag;
	//						__curr_tag_stack_index
	//							<= __curr_tag_stack_index - 1;

	//						`wr_to_allocate_shareddata_base_addr
	//							<= __in_wr__incoming_base_addr.base_addr;

	//						// Within the run of the current program we are
	//						// the first LAR to ever reference this element
	//						// of shared data.
	//						`wr_to_allocate_shareddata_ref_count <= 1;

	//						if (__in_wr__write_type
	//							== PkgSnow64LarFile::WriteTypLd)
	//						begin
	//							//`wr_to_allocate_shareddata_data
	//							//	<= __in_wr__data;
	//							//__wr_state
	//							//	<= PkgSnow64LarFile::WrStWaitForMem;


	//							// Because we haven't been allocated yet,
	//							// we only need to perform a data read.
	//							__wr_state <= PkgSnow64LarFile
	//								::WrStWaitForJustMemRead;
	//							prep_mem_read();

	//							// Loads mark the data as clean.
	//							`wr_to_allocate_shareddata_dirty <= 0;
	//						end
	//						else // if (__in_wr__write_type
	//							// == PkgSnow64LarFile::WriteTypSt)
	//						begin
	//							// Simple default behavior... if you do a
	//							// store before there was any data in a
	//							// LAR, why not make the result data zero?
	//							// 
	//							// ...In actuality, it the data will
	//							// already be zero anyway.
	//							`wr_to_allocate_shareddata_data <= 0;

	//							// Stores mark the data as dirty.
	//							`wr_to_allocate_shareddata_dirty <= 1;
	//						end

	//						stop_mem_write();
	//					end

	//					// We were the only reference, so don't perform any
	//					// allocation or deallocation, and don't change the
	//					// reference count.  Note however that this can
	//					// still cause a write back to memory.
	//					// 
	//					// Also, it can cause a read from memory.
	//					1:
	//					begin
	//						`wr_curr_shareddata_base_addr
	//							<= __in_wr__incoming_base_addr.base_addr;

	//						// If we changed our address and our data is
	//						// dirty, we need to write our old data back to
	//						// memory.
	//						if ((`wr_curr_shareddata_base_addr
	//							!= __in_wr__incoming_base_addr.base_addr)
	//							&& `wr_curr_shareddata_dirty)
	//						begin
	//							send_shareddata_to_mem(`wr_metadata_tag);

	//							if (__in_wr__write_type
	//								== PkgSnow64LarFile::WriteTypLd)
	//							begin
	//								// We need to perform both a read and a
	//								// write.
	//								__wr_state <= PkgSnow64LarFile
	//									::WrStWaitForMemReadAndMemWrite;
	//								prep_mem_read();
	//							end
	//							else // if (__in_wr__write_type
	//								// == PkgSnow64LarFile::WriteTypSt)
	//							begin
	//								// We only need to perform a write
	//								__wr_state <= PkgSnow64LarFile
	//									::WrStWaitForJustMemWrite;
	//							end
	//						end

	//						// Our old data is already clean, so we don't
	//						// need to write it out to memory.
	//						// However, if the instruction is for a load,
	//						// we do still need to read from memory.
	//						else
	//						begin
	//							stop_mem_write();

	//							if (__in_wr__write_type
	//								== PkgSnow64LarFile::WriteTypLd)
	//							begin
	//								__wr_state <= PkgSnow64LarFile
	//									::WrStWaitForJustMemRead;
	//							end
	//						end

	//						if (__in_wr__write_type
	//							== PkgSnow64LarFile::WriteTypLd)
	//						begin
	//							// Loads of fresh data mark us as clean.
	//							`wr_curr_shareddata_dirty <= 0;
	//						end
	//						else // if (__in_wr__write_type
	//							// == PkgSnow64LarFile::WriteTypSt)
	//						begin
	//							// We don't need to change our data in this
	//							// case, but we do need to mark stuff as
	//							// dirty.
	//							`wr_curr_shareddata_dirty <= 1;
	//						end
	//					end

	//					// There was at least one other reference to our
	//					// data, so don't deallocate anything, but do
	//					// decrement the old reference count.
	//					default:
	//					begin
	//						// Allocate a new element of shared data.
	//						`wr_metadata_tag <= `top_metadata_tag;
	//						__curr_tag_stack_index
	//							<= __curr_tag_stack_index - 1;

	//						// Set the base_addr and ref_count of our
	//						// allocated element shared data.
	//						`wr_to_allocate_shareddata_base_addr
	//							<= __in_wr__incoming_base_addr.base_addr;

	//						`wr_to_allocate_shareddata_ref_count <= 1;

	//						if (__in_wr__write_type
	//							== PkgSnow64LarFile::WriteTypLd)
	//						begin
	//							// Because at least one othe LARs has our
	//							// previous data, we do not need to store
	//							// it back to memory yet, but since nobody
	//							// has our new address, we need to load
	//							// that address's data from memory.
	//							__wr_state <= PkgSnow64LarFile
	//								::WrStWaitForJustMemRead;
	//							prep_mem_read();

	//							// Loads always provide clean data.
	//							`wr_to_allocate_shareddata_dirty <= 0;
	//						end
	//						else // if (__in_wr__write_type
	//							// == PkgSnow64LarFile::WriteTypSt)
	//						begin
	//							// Make a copy of our old data over to the
	//							// freshly allocated element of shared
	//							// data.
	//							`wr_to_allocate_shareddata_data
	//								<= `wr_curr_shareddata_data;

	//							// Also, since this is a store, mark it as
	//							// dirty.
	//							`wr_to_allocate_shareddata_dirty <= 1;
	//						end
	//						
	//						// Decrement the old reference count.
	//						`wr_curr_shareddata_ref_count
	//							<= `wr_curr_shareddata_ref_count - 1;
	//						stop_mem_write();
	//					end
	//					endcase
	//				end

	//			end
	//			endcase
	//		end

	//		else // if (!(__in_wr__req && (__in_wr__index != 0)))
	//		begin
	//			// Temporary!  We should really be sending out the data of
	//			// dirty LARs when we're not trying to write to the LAR
	//			// file.
	//			//__out_mem_write__req <= 0;
	//			stop_mem_write();
	//			stop_mem_read();
	//		end
	//	end

	//	PkgSnow64LarFile::WrStWaitForJustMemRead:
	//	begin
	//		
	//	end

	//	PkgSnow64LarFile::WrStWaitForJustMemWrite:
	//	begin
	//		
	//	end

	//	PkgSnow64LarFile::WrStWaitForMemReadAndMemWrite:
	//	begin
	//		
	//	end
	//	endcase
	//end

	always @(posedge clk)
	begin
		case (__wr_state)
		PkgSnow64LarFile::WrStIdle:
		begin
			stop_mem_read();
			__captured_in_wr__index <= __in_wr__index;
			__captured_in_wr__write_type <= __in_wr__write_type;
			__captured_in_wr__base_addr <= __in_wr__addr;
			__captured_in_wr__data_type <= __in_wr__data_type;
			__captured_in_wr__int_type_size <= __in_wr__int_type_size;

			__captured_in_mem_read__valid <= 0;
			__captured_in_mem_write__valid <= 0;

			if (__in_wr__req && (__in_wr__index != 0))
			begin
				// Mostly ALU/FPU operations.
				case (__in_wr__write_type)
				PkgSnow64LarFile::WriteTypOnlyData:
				begin
					stop_mem_write();
					if (`incoming__wr_metadata_tag != __UNALLOCATED_TAG)
					begin
						// Data identical to what we have means we might
						// not have to touch memory.
						if (`incoming__wr_curr_shareddata_data
							!= __in_wr__data)
						begin
							`incoming__wr_curr_shareddata_dirty <= 1;
						end
						`incoming__wr_curr_shareddata_data
							<= __in_wr__data;
					end


					`ifdef FORMAL
					__debug_tag_search_final <= 0;
					__found_tag <= 0;
					`endif		// FORMAL
				end

				// Used for port-mapped input instructions
				PkgSnow64LarFile::WriteTypDataAndType:
				begin
					stop_mem_write();
					if (`incoming__wr_metadata_tag != __UNALLOCATED_TAG)
					begin
						`incoming__wr_metadata_data_type
							<= __in_wr__data_type;
						`incoming__wr_metadata_int_type_size
							<= __in_wr__int_type_size;

						// We basically have to convert the index from one
						// type to another here.
						case (__in_wr__data_type)
						PkgSnow64Cpu::DataTypBFloat16:
						begin
							// BFloat16's here are actually 16-bit, or two
							// bytes.
							`incoming__wr_metadata_data_index
								<= `EXTRACT_DATA_INDEX__16(
								__METADATA__DATA_INDEX__INDEX_HI,
								`incoming__wr_metadata_data_index);
						end

						PkgSnow64Cpu::DataTypReserved:
						begin
							// As usual, we don't care about
							// DataTypReserved.
							`incoming__wr_metadata_data_index <= 0;
						end

						// An integer of either signedness
						default:
						begin
							case (__in_wr__int_type_size)
							PkgSnow64Cpu::IntTypSz8:
							begin
								`incoming__wr_metadata_data_index
									<= `EXTRACT_DATA_INDEX__8(
									__METADATA__DATA_INDEX__INDEX_HI,
									`incoming__wr_metadata_data_index);
							end

							PkgSnow64Cpu::IntTypSz16:
							begin
								`incoming__wr_metadata_data_index
									<= `EXTRACT_DATA_INDEX__16(
									__METADATA__DATA_INDEX__INDEX_HI,
									`incoming__wr_metadata_data_index);
							end

							PkgSnow64Cpu::IntTypSz32:
							begin
								`incoming__wr_metadata_data_index
									<= `EXTRACT_DATA_INDEX__32(
									__METADATA__DATA_INDEX__INDEX_HI,
									`incoming__wr_metadata_data_index);
							end

							PkgSnow64Cpu::IntTypSz64:
							begin
								`incoming__wr_metadata_data_index
									<= `EXTRACT_DATA_INDEX__64(
									__METADATA__DATA_INDEX__INDEX_HI,
									`incoming__wr_metadata_data_index);
							end
							endcase
						end
						endcase


						// Data identical to what we have means we might
						// not have to touch memory.
						if (`incoming__wr_curr_shareddata_data
							!= __in_wr__data)
						begin
							`incoming__wr_curr_shareddata_dirty <= 1;
						end
						`incoming__wr_curr_shareddata_data
							<= __in_wr__data;
					end


					`ifdef FORMAL
					__debug_tag_search_final <= 0;
					__found_tag <= 0;
					`endif		// FORMAL
				end

				// PkgSnow64LarFile::WriteTypLd or
				// PkgSnow64LarFile::WriteTypSt
				default:
				begin
					__wr_state <= PkgSnow64LarFile::WrStStartLdSt;

					`incoming__wr_metadata_data_type
						<= __in_wr__data_type;
					`incoming__wr_metadata_int_type_size
						<= __in_wr__int_type_size;

					__captured_tag_search_final
						<= `actual_tag_search_final;

					`ifdef FORMAL
					__debug_tag_search_final <= `actual_tag_search_final;
					__found_tag <= `actual_tag_search_final != 0;
					`endif		// FORMAL

					case (__in_wr__data_type)
					PkgSnow64Cpu::DataTypBFloat16:
					begin
						// BFloat16's are 16-bit, or two bytes.
						`incoming__wr_metadata_data_index
							<= `EXTRACT_DATA_INDEX__16(
							__METADATA__DATA_INDEX__INDEX_HI,
							__in_wr__addr);
					end

					// We don't care about DataTypReserved
					PkgSnow64Cpu::DataTypReserved:
					begin
						`incoming__wr_metadata_data_index <= 0;
					end

					// An integer of either signedness
					default:
					begin
						case (__in_wr__int_type_size)
						PkgSnow64Cpu::IntTypSz8:
						begin
							`incoming__wr_metadata_data_index
								<= `EXTRACT_DATA_INDEX__8(
								__METADATA__DATA_INDEX__INDEX_HI,
								__in_wr__addr);
						end

						PkgSnow64Cpu::IntTypSz16:
						begin
							`incoming__wr_metadata_data_index
								<= `EXTRACT_DATA_INDEX__16(
								__METADATA__DATA_INDEX__INDEX_HI,
								__in_wr__addr);
						end

						PkgSnow64Cpu::IntTypSz32:
						begin
							`incoming__wr_metadata_data_index
								<= `EXTRACT_DATA_INDEX__32(
								__METADATA__DATA_INDEX__INDEX_HI,
								__in_wr__addr);
						end

						PkgSnow64Cpu::IntTypSz64:
						begin
							`incoming__wr_metadata_data_index
								<= `EXTRACT_DATA_INDEX__64(
								__METADATA__DATA_INDEX__INDEX_HI,
								__in_wr__addr);
						end
						endcase
					end
					endcase
				end
				endcase
			end
		end

		PkgSnow64LarFile::WrStStartLdSt:
		begin
			// The address's data is already in at least one LAR.
			// 
			// This is the best case scenario.  It's the analog of a cache
			// hit in a conventional cache.
			if (__captured_tag_search_final != 0)
			begin
				// A tag already exists.  We set our tag to the existing
				// one.
				`captured__wr_metadata_tag <= __captured_tag_search_final;

				// Loads of data we already had don't affect the dirty
				// flag.

				// If our existing tag ISN'T the one we found.
				if (__captured_tag_search_final
					!= `captured__wr_metadata_tag)
				begin
					stop_mem_read();
					`wr_aliased_shareddata_ref_count
						<= `wr_aliased_shareddata_ref_count + 1;

					if (__captured_in_wr__write_type
						== PkgSnow64LarFile::WriteTypSt)
					begin
						// Make a copy of our data to the new address.
						// This also causes us to need to set the dirty
						// flag.
						`wr_aliased_shareddata_data
							<= `captured__wr_curr_shareddata_data;
						`wr_aliased_shareddata_dirty <= 1;
					end

					case (`captured__wr_curr_shareddata_ref_count)
					// We haven't been allocated yet.
					0:
					begin
						stop_mem_write();
						__wr_state <= PkgSnow64LarFile::WrStIdle;
					end

					// There were no other references to us, so deallocate
					// the old tag (pushing it onto the stack), and (if we
					// were dirty) send our old data out to memory.
					1:
					begin
						// Deallocate our old tag.
						`above_top_metadata_tag
							<= `captured__wr_metadata_tag;
						__curr_tag_stack_index <= __curr_tag_stack_index
							+ 1;

						// Since we're deallocating stuff, we need to write
						// our old data back to memory if it's not already
						// up to date.

						if (`captured__wr_curr_shareddata_dirty)
						begin
							__wr_state <= PkgSnow64LarFile
								::WrStWaitForJustMemWrite;
							send_shareddata_to_mem
								(`captured__wr_metadata_tag);
						end
						else
						begin
							// We need to go back to our previous state.
							__wr_state <= PkgSnow64LarFile::WrStIdle;
							stop_mem_write();
						end

						// We were the only LAR that cared about our old
						// shared data, which means our old shared data
						// becomes free for other use.
						`captured__wr_curr_shareddata_ref_count <= 0;


						`captured__wr_curr_shareddata_dirty <= 0;

						// For good measure.
						`captured__wr_curr_shareddata_base_addr <= 0;
						`captured__wr_curr_shareddata_data <= 0;
					end

					// There was at least one other reference to us, so
					// don't deallocate anything, but do decrement the
					// reference count.
					// In this situation, all that happens is that our tag
					// changes and our shared data loses a reference, but
					// our new shared data gains a reference.
					default:
					begin
						__wr_state <= PkgSnow64LarFile::WrStIdle;
						`captured__wr_curr_shareddata_ref_count
							<= `captured__wr_curr_shareddata_ref_count
							- 1;
						stop_mem_write();
					end
					endcase
				end
			end
		end

		PkgSnow64LarFile::WrStWaitForJustMemRead:
		begin
			
		end

		PkgSnow64LarFile::WrStWaitForJustMemWrite:
		begin
			
		end

		PkgSnow64LarFile::WrStWaitForMemReadAndMemWrite:
		begin
			
		end
		endcase
	end
	`undef incoming__wr_metadata_data_index
	`undef incoming__wr_metadata_data_type
	`undef incoming__wr_metadata_int_type_size
	`undef incoming__wr_metadata_tag

	`undef captured__wr_metadata_tag

	`undef top_metadata_tag
	`undef above_top_metadata_tag

	`undef captured__wr_curr_shareddata_base_addr
	`undef wr_aliased_shareddata_base_addr
	`undef wr_to_allocate_shareddata_base_addr

	`undef incoming__wr_curr_shareddata_data
	`undef captured__wr_curr_shareddata_data
	`undef wr_aliased_shareddata_data
	`undef wr_to_allocate_shareddata_data

	`undef incoming__wr_curr_shareddata_dirty
	`undef captured__wr_curr_shareddata_dirty
	`undef wr_aliased_shareddata_dirty
	`undef wr_to_allocate_shareddata_dirty

	`undef captured__wr_curr_shareddata_ref_count
	`undef wr_aliased_shareddata_ref_count
	`undef wr_to_allocate_shareddata_ref_count


	`undef metadata_data_index

	`undef metadata_tag
	`undef metadata_data_type
	`undef metadata_int_type_size

	`undef shareddata_base_addr
	`undef shareddata_tagged_base_addr

	`undef shareddata_data
	`undef shareddata_tagged_data

	`undef shareddata_ref_count
	`undef shareddata_tagged_ref_count

	`undef shareddata_dirty
	`undef shareddata_tagged_dirty

	`undef actual_tag_search_0
	`undef actual_tag_search_1
	`undef actual_tag_search_2
	`undef actual_tag_search_3
	`undef actual_tag_search_final
	`undef do_tag_search



endmodule
