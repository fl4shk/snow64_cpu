`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"


// One line of instruction cache...
module Snow64FakeInstrCache(input logic clk,
	input PkgSnow64InstrCache::PartialPortIn_InstrCache_ReqRead
		in_req_read,
	input PkgSnow64InstrCache::PartialPortIn_InstrCache_MemAccess
		in_mem_access,

	output PkgSnow64InstrCache::PartialPortOut_InstrCache_ReqRead
		out_req_read,
	output PkgSnow64InstrCache::PartialPortOut_InstrCache_MemAccess
		out_mem_access);

	PkgSnow64InstrCache::State __state;
	
	logic __did_init;

	localparam __WIDTH__DATA_OFFSET
		= $clog2(`WIDTH__SNOW64_ICACHE_LINE_DATA / `WIDTH__SNOW64_INSTR);
	localparam __MSB_POS__DATA_OFFSET = `WIDTH2MP(__WIDTH__DATA_OFFSET);

	localparam __WIDTH__BASE_ADDR
		= `WIDTH__SNOW64_CPU_ADDR - __WIDTH__DATA_OFFSET;
	localparam __MSB_POS__BASE_ADDR
		= `WIDTH2MP(__WIDTH__BASE_ADDR);

	logic [__MSB_POS__DATA_OFFSET:0] __captured_req_data_offset,
		__curr_req_data_offset;
	logic [__MSB_POS__BASE_ADDR:0] __base_addr, __curr_req_base_addr;

	assign {__curr_req_base_addr, __curr_req_data_offset}
		= in_req_read.addr;

	logic [`MSB_POS__SNOW64_ICACHE_LINE_DATA:0] __line;

	initial
	begin
		__state = PkgSnow64InstrCache::StIdle;
		__did_init = 0;
		__captured_req_data_offset = 0;
		__base_addr = 0;
		__line = 0;
	end


	always_ff @(posedge clk)
	begin
		case (__state)
		PkgSnow64InstrCache::StIdle:
		begin
			if (in_req_read.req)
			begin
				if (__did_init && (__base_addr == __curr_req_base_addr))
				begin
					out_mem_access.req <= 0;
					out_req_read.valid <= 1;

					case (__curr_req_data_offset)
					0: out_req_read.instr <= __line[0 * 32 +: 32];
					1: out_req_read.instr <= __line[1 * 32 +: 32];
					2: out_req_read.instr <= __line[2 * 32 +: 32];
					3: out_req_read.instr <= __line[3 * 32 +: 32];
					4: out_req_read.instr <= __line[4 * 32 +: 32];
					5: out_req_read.instr <= __line[5 * 32 +: 32];
					6: out_req_read.instr <= __line[6 * 32 +: 32];
					7: out_req_read.instr <= __line[7 * 32 +: 32];
					endcase
				end

				else
				begin
					out_mem_access.req <= 0;
					out_mem_access.addr <= in_req_read.addr;

					out_req_read.valid <= 0;

					__state <= PkgSnow64InstrCache::StWaitForMem;

					__did_init <= 1;
					__base_addr <= __curr_req_base_addr;
					__captured_req_data_offset <= __curr_req_data_offset;
				end
			end

			else
			begin
				out_mem_access.req <= 0;
				out_req_read.valid <= 0;
			end
		end

		PkgSnow64InstrCache::StWaitForMem:
		begin
			out_mem_access.req <= 0;

			if (in_mem_access.valid)
			begin
				out_req_read.valid <= 1;
				__state <= PkgSnow64InstrCache::StIdle;
				__line <= in_mem_access.data;

				case (__captured_req_data_offset)
				0: out_req_read.instr <= in_mem_access.data[0 * 32 +: 32];
				1: out_req_read.instr <= in_mem_access.data[1 * 32 +: 32];
				2: out_req_read.instr <= in_mem_access.data[2 * 32 +: 32];
				3: out_req_read.instr <= in_mem_access.data[3 * 32 +: 32];
				4: out_req_read.instr <= in_mem_access.data[4 * 32 +: 32];
				5: out_req_read.instr <= in_mem_access.data[5 * 32 +: 32];
				6: out_req_read.instr <= in_mem_access.data[6 * 32 +: 32];
				7: out_req_read.instr <= in_mem_access.data[7 * 32 +: 32];
				endcase
			end
		end
		endcase
	end

endmodule

module Snow64Cpu(input logic clk,
	input PkgSnow64Cpu::PortIn_Cpu in,
	output PkgSnow64Cpu::PortOut_Cpu out);


	// Ports of Snow64Cpu
	PkgSnow64Cpu::PartialPortIn_Cpu_Interrupt real_in_interrupt;
	PkgSnow64Cpu::PartialPortIn_Cpu_ExtDataAccess
		real_in_ext_dat_acc_mem, real_in_ext_dat_acc_io;
	assign {real_in_interrupt, real_in_ext_dat_acc_mem,
		real_in_ext_dat_acc_io} = in;


	PkgSnow64Cpu::PartialPortOut_Cpu_Interrupt real_out_interrupt;
	PkgSnow64Cpu::PartialPortOut_Cpu_ExtDataAccess
		real_out_ext_dat_acc_mem, real_out_ext_dat_acc_io;
	assign out = {real_out_interrupt, real_out_ext_dat_acc_mem,
		real_out_ext_dat_acc_io};


	// Fake instruction cache (really just one line of data...)
	PkgSnow64InstrCache::PartialPortIn_InstrCache_ReqRead
		real_in_inst_fake_instr_cache_req_read;
	PkgSnow64InstrCache::PartialPortIn_InstrCache_MemAccess
		real_in_inst_fake_instr_cache_mem_access;

	PkgSnow64InstrCache::PartialPortOut_InstrCache_ReqRead
		real_out_inst_fake_instr_cache_req_read;
	PkgSnow64InstrCache::PartialPortOut_InstrCache_MemAccess
		real_out_inst_fake_instr_cache_mem_access;


	Snow64FakeInstrCache __inst_fake_instr_cache(.clk(clk),
		.in_req_read(real_in_inst_fake_instr_cache_req_read),
		.in_mem_access(real_in_inst_fake_instr_cache_mem_access),

		.out_req_read(real_out_inst_fake_instr_cache_req_read),
		.out_mem_access(real_out_inst_fake_instr_cache_mem_access));


	// Instruction decoder
	wire [`MSB_POS__SNOW64_INSTR:0] real_in_inst_instr_decoder;
	PkgSnow64InstrDecoder::PortOut_InstrDecoder
		real_out_inst_instr_decoder;
	Snow64InstrDecoder __inst_instr_decoder
		(.in(real_in_inst_instr_decoder),
		.out(real_out_inst_instr_decoder));

	// Interface for accessing memory
	PkgSnow64MemoryAccessFifo::PartialPortIn_ReadFifo_ReqRead
		real_in_inst_read_fifo__instr,
		real_in_inst_read_fifo__data;
	PkgSnow64MemoryAccessFifo::PartialPortIn_WriteFifo_ReqWrite
		real_in_inst_write_fifo__data;
	PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_MemAccess
		real_in_inst_mem_bus_guard;
	PkgSnow64MemoryAccessFifo::PartialPortOut_ReadFifo_ReqRead
		real_out_inst_read_fifo__instr,
		real_out_inst_read_fifo__data;
	PkgSnow64MemoryAccessFifo::PartialPortOut_WriteFifo_ReqWrite
		real_out_inst_write_fifo__data;
	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_MemAccess
		real_out_inst_mem_bus_guard;
	Snow64MemoryAccessViaFifos __inst_memory_access_via_fifos(.clk(clk),
		.in_mem_acc_read_fifo__instr__req_read
		(real_in_inst_read_fifo__instr),
		.in_mem_acc_read_fifo__data__req_read
		(real_in_inst_read_fifo__data),
		.in_mem_acc_write_fifo__data__req_write
		(real_in_inst_write_fifo__data),

		.in_mem_bus_guard__mem_access
		(real_in_inst_mem_bus_guard),

		.out_mem_acc_read_fifo__instr__req_read
		(real_out_inst_read_fifo__instr),
		.out_mem_acc_read_fifo__data__req_read
		(real_out_inst_read_fifo__data),
		.out_mem_acc_write_fifo__data__req_write
		(real_out_inst_write_fifo__data),

		.out_mem_bus_guard__mem_access
		(real_out_inst_mem_bus_guard));


	// The LAR file
	PkgSnow64LarFile::PortIn_LarFile __in_inst_lar_file;
	PkgSnow64LarFile::PortOut_LarFile __out_inst_lar_file;
	Snow64LarFile __inst_lar_file(.clk(clk), .in(__in_inst_lar_file),
		.out(__out_inst_lar_file));

	PkgSnow64LarFile::PartialPortIn_LarFile_Read
		real_in_inst_lar_file__rd_a, real_in_inst_lar_file__rd_b,
		real_in_inst_lar_file__rd_c;
	PkgSnow64LarFile::PartialPortIn_LarFile_Write real_in_inst_lar_file__wr;
	PkgSnow64LarFile::PartialPortIn_LarFile_MemRead
		real_in_inst_lar_file__mem_read;
	PkgSnow64LarFile::PartialPortIn_LarFile_MemWrite
		real_in_inst_lar_file__mem_write;

	assign __in_inst_lar_file
		= {real_in_inst_lar_file__rd_a, real_in_inst_lar_file__rd_b,
		real_in_inst_lar_file__rd_c,
		real_in_inst_lar_file__wr,
		real_in_inst_lar_file__mem_read,
		real_in_inst_lar_file__mem_write};


	PkgSnow64LarFile::PartialPortOut_LarFile_ReadMetadata
		real_out_inst_lar_file__rd_metadata_a,
		real_out_inst_lar_file__rd_metadata_b,
		real_out_inst_lar_file__rd_metadata_c;
	PkgSnow64LarFile::PartialPortOut_LarFile_ReadShareddata
		real_out_inst_lar_file__rd_shareddata_a,
		real_out_inst_lar_file__rd_shareddata_b,
		real_out_inst_lar_file__rd_shareddata_c;
	PkgSnow64LarFile::PartialPortOut_LarFile_Write
		real_out_inst_lar_file__wr;
	PkgSnow64LarFile::PartialPortOut_LarFile_MemRead
		real_out_inst_lar_file__mem_read;
	PkgSnow64LarFile::PartialPortOut_LarFile_MemWrite
		real_out_inst_lar_file__mem_write;

	assign {real_out_inst_lar_file__rd_metadata_a,
		real_out_inst_lar_file__rd_metadata_b,
		real_out_inst_lar_file__rd_metadata_c,
		real_out_inst_lar_file__rd_shareddata_a,
		real_out_inst_lar_file__rd_shareddata_b,
		real_out_inst_lar_file__rd_shareddata_c,
		real_out_inst_lar_file__wr,
		real_out_inst_lar_file__mem_read,
		real_out_inst_lar_file__mem_write} = __out_inst_lar_file;



	// The ALUs
	PkgSnow64Alu::PortIn_Alu
		real_in_inst_alu_0, real_in_inst_alu_1,
		real_in_inst_alu_2, real_in_inst_alu_3;
	PkgSnow64Alu::PortOut_Alu
		real_out_inst_alu_0, real_out_inst_alu_1,
		real_out_inst_alu_2, real_out_inst_alu_3;
	Snow64Alu __inst_alu_0(.in(real_in_inst_alu_0),
		.out(real_out_inst_alu_0));
	Snow64Alu __inst_alu_1(.in(real_in_inst_alu_1),
		.out(real_out_inst_alu_1));
	Snow64Alu __inst_alu_2(.in(real_in_inst_alu_2),
		.out(real_out_inst_alu_2));
	Snow64Alu __inst_alu_3(.in(real_in_inst_alu_3),
		.out(real_out_inst_alu_3));


	// The vector multipliers
	PkgSnow64Alu::PortIn_VectorMul
		real_in_inst_vec_mul_0, real_in_inst_vec_mul_1,
		real_in_inst_vec_mul_2, real_in_inst_vec_mul_3;
	PkgSnow64Alu::PortOut_Mul
		real_out_inst_vec_mul_0, real_out_inst_vec_mul_1,
		real_out_inst_vec_mul_2, real_out_inst_vec_mul_3;
	Snow64VectorMul __inst_vec_mul_0(.clk(clk),
		.in(real_in_inst_vec_mul_0), .out(real_out_inst_vec_mul_0));
	Snow64VectorMul __inst_vec_mul_1(.clk(clk),
		.in(real_in_inst_vec_mul_1), .out(real_out_inst_vec_mul_1));
	Snow64VectorMul __inst_vec_mul_2(.clk(clk),
		.in(real_in_inst_vec_mul_2), .out(real_out_inst_vec_mul_2));
	Snow64VectorMul __inst_vec_mul_3(.clk(clk),
		.in(real_in_inst_vec_mul_3), .out(real_out_inst_vec_mul_3));


	// The dividers.  For simplicity purposes, four 64-bit dividers are
	// used.  Because of the simplicity of the divider module itself, this
	// means that vector divides take significantly longer than is ideal.
	struct packed
	{
		logic enable, signedness;
		logic [`MSB_POS__SNOW64_SIZE_64:0] num, denom;
	} real_in_inst_div_0, real_in_inst_div_1,
		real_in_inst_div_2, real_in_inst_div_3;

	//struct packed
	//{
	//	logic [`MSB_POS__SNOW64_SIZE_64:0] quot, rem;
	//	logic can_accept_cmd, data_ready;
	//} real_out_inst_div_0;

	wire [`MSB_POS__SNOW64_SIZE_64:0]
		real_out_inst_div_0__quot, real_out_inst_div_0__rem;
	wire real_out_inst_div_0__can_accept_cmd,
		real_out_inst_div_0__data_ready;

	wire [`MSB_POS__SNOW64_SIZE_64:0]
		real_out_inst_div_1__quot, real_out_inst_div_1__rem;
	wire real_out_inst_div_1__can_accept_cmd,
		real_out_inst_div_1__data_ready;

	wire [`MSB_POS__SNOW64_SIZE_64:0]
		real_out_inst_div_2__quot, real_out_inst_div_2__rem;
	wire real_out_inst_div_2__can_accept_cmd,
		real_out_inst_div_2__data_ready;

	wire [`MSB_POS__SNOW64_SIZE_64:0]
		real_out_inst_div_3__quot, real_out_inst_div_3__rem;
	wire real_out_inst_div_3__can_accept_cmd,
		real_out_inst_div_3__data_ready;

	Snow64NonRestoringDivider __inst_div_0(.clk(clk),
		.in_enable(real_in_inst_div_0.enable),
		.in_signedness(real_in_inst_div_0.signedness),
		.in_num(real_in_inst_div_0.num),
		.in_denom(real_in_inst_div_0.denom),

		.out_quot(real_out_inst_div_0__quot),
		.out_rem(real_out_inst_div_0__rem),
		.out_can_accept_cmd(real_out_inst_div_0__can_accept_cmd),
		.out_data_ready(real_out_inst_div_0__data_ready));

	Snow64NonRestoringDivider __inst_div_1(.clk(clk),
		.in_enable(real_in_inst_div_1.enable),
		.in_signedness(real_in_inst_div_1.signedness),
		.in_num(real_in_inst_div_1.num),
		.in_denom(real_in_inst_div_1.denom),

		.out_quot(real_out_inst_div_1__quot),
		.out_rem(real_out_inst_div_1__rem),
		.out_can_accept_cmd(real_out_inst_div_1__can_accept_cmd),
		.out_data_ready(real_out_inst_div_1__data_ready));

	Snow64NonRestoringDivider __inst_div_2(.clk(clk),
		.in_enable(real_in_inst_div_2.enable),
		.in_signedness(real_in_inst_div_2.signedness),
		.in_num(real_in_inst_div_2.num),
		.in_denom(real_in_inst_div_2.denom),

		.out_quot(real_out_inst_div_2__quot),
		.out_rem(real_out_inst_div_2__rem),
		.out_can_accept_cmd(real_out_inst_div_2__can_accept_cmd),
		.out_data_ready(real_out_inst_div_2__data_ready));

	Snow64NonRestoringDivider __inst_div_3(.clk(clk),
		.in_enable(real_in_inst_div_3.enable),
		.in_signedness(real_in_inst_div_3.signedness),
		.in_num(real_in_inst_div_3.num),
		.in_denom(real_in_inst_div_3.denom),

		.out_quot(real_out_inst_div_3__quot),
		.out_rem(real_out_inst_div_3__rem),
		.out_can_accept_cmd(real_out_inst_div_3__can_accept_cmd),
		.out_data_ready(real_out_inst_div_3__data_ready));



	// Scalar data extractors
	PkgSnow64ScalarDataExtractOrInject::PortIn_ScalarDataExtractor
		real_in_inst_scalar_data_extractor_0,
		real_in_inst_scalar_data_extractor_1;
	PkgSnow64ScalarDataExtractOrInject::PortOut_ScalarDataExtractor
		real_out_inst_scalar_data_extractor_0,
		real_out_inst_scalar_data_extractor_1;
	Snow64ScalarDataExtractor __inst_scalar_data_extractor_0
		(.in(real_in_inst_scalar_data_extractor_0),
		.out(real_out_inst_scalar_data_extractor_0));
	Snow64ScalarDataExtractor __inst_scalar_data_extractor_1
		(.in(real_in_inst_scalar_data_extractor_1),
		.out(real_out_inst_scalar_data_extractor_1));

	// Scalar data injector
	PkgSnow64ScalarDataExtractOrInject::PortIn_ScalarDataInjector
		real_in_inst_scalar_data_injector;
	PkgSnow64ScalarDataExtractOrInject::PortOut_ScalarDataInjector
		real_out_inst_scalar_data_injector;
	Snow64ScalarDataInjector __inst_scalar_data_injector
		(.in(real_in_inst_scalar_data_injector),
		.out(real_out_inst_scalar_data_injector));


	// BFloat16 Floating Point Units
	PkgSnow64BFloat16::PortIn_Fpu
		real_in_inst_fpu_0, real_in_inst_fpu_1, real_in_inst_fpu_2,
		real_in_inst_fpu_3;
	PkgSnow64BFloat16::PortOut_Fpu
		real_out_inst_fpu_0, real_out_inst_fpu_1, real_out_inst_fpu_2,
		real_out_inst_fpu_3;
	Snow64BFloat16Fpu __inst_fpu_0(.clk(clk), .in(real_in_inst_fpu_0),
		.out(real_out_inst_fpu_0));
	Snow64BFloat16Fpu __inst_fpu_1(.clk(clk), .in(real_in_inst_fpu_1),
		.out(real_out_inst_fpu_1));
	Snow64BFloat16Fpu __inst_fpu_2(.clk(clk), .in(real_in_inst_fpu_2),
		.out(real_out_inst_fpu_2));
	Snow64BFloat16Fpu __inst_fpu_3(.clk(clk), .in(real_in_inst_fpu_3),
		.out(real_out_inst_fpu_3));

	// Cast from scalar integer to scalar bfloat16
	PkgSnow64BFloat16::PortIn_CastFromInt
		real_in_inst_cast_from_int_to_bfloat16_0,
		real_in_inst_cast_from_int_to_bfloat16_1;
	PkgSnow64BFloat16::PortOut_CastFromInt
		real_out_inst_cast_from_int_to_bfloat16_0,
		real_out_inst_cast_from_int_to_bfloat16_1;
	Snow64BFloat16CastFromInt __inst_cast_from_int_to_bfloat16_0
		(.clk(clk), .in(real_in_inst_cast_from_int_to_bfloat16_0),
		.out(real_out_inst_cast_from_int_to_bfloat16_0));
	Snow64BFloat16CastFromInt __inst_cast_from_int_to_bfloat16_1
		(.clk(clk), .in(real_in_inst_cast_from_int_to_bfloat16_1),
		.out(real_out_inst_cast_from_int_to_bfloat16_1));

	// Cast to scalar integer to scalar bfloat16
	PkgSnow64BFloat16::PortIn_CastToInt
		real_in_inst_cast_to_int_from_bfloat16_0,
		real_in_inst_cast_to_int_from_bfloat16_1;
	PkgSnow64BFloat16::PortOut_CastToInt
		real_out_inst_cast_to_int_from_bfloat16_0,
		real_out_inst_cast_to_int_from_bfloat16_1;
	Snow64BFloat16CastToInt __inst_cast_to_int_from_bfloat16_0
		(.clk(clk), .in(real_in_inst_cast_to_int_from_bfloat16_0),
		.out(real_out_inst_cast_to_int_from_bfloat16_0));
	Snow64BFloat16CastToInt __inst_cast_to_int_from_bfloat16_1
		(.clk(clk), .in(real_in_inst_cast_to_int_from_bfloat16_1),
		.out(real_out_inst_cast_to_int_from_bfloat16_1));

	// Cast from one integer type to another integer type
	PkgSnow64Caster::PortIn_IntScalarCaster
		real_in_inst_int_scalar_caster_0, real_in_inst_int_scalar_caster_1;
	PkgSnow64Caster::PortOut_IntScalarCaster
		real_out_inst_int_scalar_caster_0,
		real_out_inst_int_scalar_caster_1;
	Snow64IntScalarCaster __inst_int_scalar_caster_0(.clk(clk),
		.in(real_in_inst_int_scalar_caster_0),
		.out(real_out_inst_int_scalar_caster_0));
	Snow64IntScalarCaster __inst_int_scalar_caster_1(.clk(clk),
		.in(real_in_inst_int_scalar_caster_1),
		.out(real_out_inst_int_scalar_caster_1));

	PkgSnow64Caster::PortIn_IntVectorCaster
		real_in_inst_int_vector_caster_0, real_in_inst_int_vector_caster_1;
	PkgSnow64Caster::PortOut_IntVectorCaster
		real_out_inst_int_vector_caster_0,
		real_out_inst_int_vector_caster_1;
	Snow64IntVectorCaster __inst_int_vector_caster_0(.clk(clk),
		.in(real_in_inst_int_vector_caster_0),
		.out(real_out_inst_int_vector_caster_0));
	Snow64IntVectorCaster __inst_int_vector_caster_1(.clk(clk),
		.in(real_in_inst_int_vector_caster_1),
		.out(real_out_inst_int_vector_caster_1));

	PkgSnow64Caster::PortIn_ToOrFromBFloat16VectorCaster
		real_in_inst_to_or_from_bfloat16_vector_caster_0,
		real_in_inst_to_or_from_bfloat16_vector_caster_1;
	PkgSnow64Caster::PortOut_ToOrFromBFloat16VectorCaster
		real_out_inst_to_or_from_bfloat16_vector_caster_0,
		real_out_inst_to_or_from_bfloat16_vector_caster_1;
	Snow64ToOrFromBFloat16VectorCaster
		__inst_to_or_from_bfloat16_vector_caster_0(.clk(clk),
		.in(real_in_inst_to_or_from_bfloat16_vector_caster_0),
		.out(real_out_inst_to_or_from_bfloat16_vector_caster_0));
	Snow64ToOrFromBFloat16VectorCaster
		__inst_to_or_from_bfloat16_vector_caster_1(.clk(clk),
		.in(real_in_inst_to_or_from_bfloat16_vector_caster_1),
		.out(real_out_inst_to_or_from_bfloat16_vector_caster_1));



	// Locals
	logic __spec_reg_ie;
	logic [`MSB_POS__SNOW64_CPU_ADDR:0] __spec_reg_ireta, __spec_reg_pc;


	`ifdef FORMAL
	localparam __ENUM__IG0OPER__ADD_THREEREGS
		= PkgSnow64InstrDecoder::Add_ThreeRegs;
	localparam __ENUM__IOG0OPER__SUB_THREEREGS
		= PkgSnow64InstrDecoder::Sub_ThreeRegs;
	localparam __ENUM__IOG0OPER__SLT_THREEREGS
		= PkgSnow64InstrDecoder::Slt_ThreeRegs;
	localparam __ENUM__IOG0OPER__MUL_THREEREGS
		= PkgSnow64InstrDecoder::Mul_ThreeRegs;

	localparam __ENUM__IOG0OPER__DIV_THREEREGS
		= PkgSnow64InstrDecoder::Div_ThreeRegs;
	localparam __ENUM__IOG0OPER__AND_THREEREGS
		= PkgSnow64InstrDecoder::And_ThreeRegs;
	localparam __ENUM__IOG0OPER__ORR_THREEREGS
		= PkgSnow64InstrDecoder::Orr_ThreeRegs;
	localparam __ENUM__IOG0OPER__XOR_THREEREGS
		= PkgSnow64InstrDecoder::Xor_ThreeRegs;

	localparam __ENUM__IOG0OPER__SHL_THREEREGS
		= PkgSnow64InstrDecoder::Shl_ThreeRegs;
	localparam __ENUM__IOG0OPER__SHR_THREEREGS
		= PkgSnow64InstrDecoder::Shr_ThreeRegs;
	localparam __ENUM__IOG0OPER__INV_THREEREGS
		= PkgSnow64InstrDecoder::Inv_ThreeRegs;
	localparam __ENUM__IOG0OPER__NOT_THREEREGS
		= PkgSnow64InstrDecoder::Not_ThreeRegs;

	localparam __ENUM__IOG0OPER__ADD_ONEREGONEPCONESIMM12
		= PkgSnow64InstrDecoder::Add_OneRegOnePcOneSimm12;
	localparam __ENUM__IOG0OPER__BAD0_IOG0
		= PkgSnow64InstrDecoder::Bad0_Iog0;
	localparam __ENUM__IOG0OPER__BAD1_IOG0
		= PkgSnow64InstrDecoder::Bad1_Iog0;
	localparam __ENUM__IOG0OPER__BAD2_IOG0
		= PkgSnow64InstrDecoder::Bad2_Iog0;

	localparam __ENUM__IOG1OPER__BTRU_ONEREGONESIMM20
		= PkgSnow64InstrDecoder::Btru_OneRegOneSimm20;
	localparam __ENUM__IOG1OPER__BFAL_ONEREGONESIMM20
		= PkgSnow64InstrDecoder::Bfal_OneRegOneSimm20;
	localparam __ENUM__IOG1OPER__JMP_ONEREG
		= PkgSnow64InstrDecoder::Jmp_OneReg;
	localparam __ENUM__IOG1OPER__EI_NOARGS
		= PkgSnow64InstrDecoder::Ei_NoArgs;

	localparam __ENUM__IOG1OPER__DI_NOARGS
		= PkgSnow64InstrDecoder::Di_NoArgs;
	localparam __ENUM__IOG1OPER__RETI_NOARGS
		= PkgSnow64InstrDecoder::Reti_NoArgs;
	localparam __ENUM__IOG1OPER__CPY_ONEREGONEIE
		= PkgSnow64InstrDecoder::Cpy_OneRegOneIe;
	localparam __ENUM__IOG1OPER__CPY_ONEREGONEIRETA
		= PkgSnow64InstrDecoder::Cpy_OneRegOneIreta;

	localparam __ENUM__IOG1OPER__CPY_ONEREGONEIDSTA
		= PkgSnow64InstrDecoder::Cpy_OneRegOneIdsta;
	localparam __ENUM__IOG1OPER__CPY_ONEIEONEREG
		= PkgSnow64InstrDecoder::Cpy_OneIeOneReg;
	localparam __ENUM__IOG1OPER__CPY_ONEIRETAONEREG
		= PkgSnow64InstrDecoder::Cpy_OneIretaOneReg;
	localparam __ENUM__IOG1OPER__CPY_ONEIDSTAONEREG
		= PkgSnow64InstrDecoder::Cpy_OneIdstaOneReg;

	localparam __ENUM__IOG1OPER__BAD0_IOG1
		= PkgSnow64InstrDecoder::Bad0_Iog1;
	localparam __ENUM__IOG1OPER__BAD1_IOG1
		= PkgSnow64InstrDecoder::Bad1_Iog1;
	localparam __ENUM__IOG1OPER__BAD2_IOG1
		= PkgSnow64InstrDecoder::Bad2_Iog1;
	localparam __ENUM__IOG1OPER__BAD3_IOG1
		= PkgSnow64InstrDecoder::Bad3_Iog1;

	localparam __ENUM__IOG2OPER__LDU8_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdU8_ThreeRegsOneSimm12;
	localparam __ENUM__IOG2OPER__LDS8_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdS8_ThreeRegsOneSimm12;
	localparam __ENUM__IOG2OPER__LDU16_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdU16_ThreeRegsOneSimm12;
	localparam __ENUM__IOG2OPER__LDS16_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdS16_ThreeRegsOneSimm12;

	localparam __ENUM__IOG2OPER__LDU32_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdU32_ThreeRegsOneSimm12;
	localparam __ENUM__IOG2OPER__LDS32_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdS32_ThreeRegsOneSimm12;
	localparam __ENUM__IOG2OPER__LDU64_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdU64_ThreeRegsOneSimm12;
	localparam __ENUM__IOG2OPER__LDS64_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdS64_ThreeRegsOneSimm12;

	localparam __ENUM__IOG2OPER__LDF16_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::LdF16_ThreeRegsOneSimm12;
	localparam __ENUM__IOG2OPER__BAD0_IOG2
		= PkgSnow64InstrDecoder::Bad0_Iog2;
	localparam __ENUM__IOG2OPER__BAD1_IOG2
		= PkgSnow64InstrDecoder::Bad1_Iog2;
	localparam __ENUM__IOG2OPER__BAD2_IOG2
		= PkgSnow64InstrDecoder::Bad2_Iog2;

	localparam __ENUM__IOG2OPER__BAD3_IOG2
		= PkgSnow64InstrDecoder::Bad3_Iog2;
	localparam __ENUM__IOG2OPER__BAD4_IOG2
		= PkgSnow64InstrDecoder::Bad4_Iog2;
	localparam __ENUM__IOG2OPER__BAD5_IOG2
		= PkgSnow64InstrDecoder::Bad5_Iog2;
	localparam __ENUM__IOG2OPER__BAD6_IOG2
		= PkgSnow64InstrDecoder::Bad6_Iog2;

	localparam __ENUM__IOG3OPER__STU8_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StU8_ThreeRegsOneSimm12;
	localparam __ENUM__IOG3OPER__STS8_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StS8_ThreeRegsOneSimm12;
	localparam __ENUM__IOG3OPER__STU16_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StU16_ThreeRegsOneSimm12;
	localparam __ENUM__IOG3OPER__STS16_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StS16_ThreeRegsOneSimm12;

	localparam __ENUM__IOG3OPER__STU32_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StU32_ThreeRegsOneSimm12;
	localparam __ENUM__IOG3OPER__STS32_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StS32_ThreeRegsOneSimm12;
	localparam __ENUM__IOG3OPER__STU64_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StU64_ThreeRegsOneSimm12;
	localparam __ENUM__IOG3OPER__STS64_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StS64_ThreeRegsOneSimm12;

	localparam __ENUM__IOG3OPER__STF16_THREEREGSONESIMM12
		= PkgSnow64InstrDecoder::StF16_ThreeRegsOneSimm12;
	localparam __ENUM__IOG3OPER__BAD0_IOG3
		= PkgSnow64InstrDecoder::Bad0_Iog3;
	localparam __ENUM__IOG3OPER__BAD1_IOG3
		= PkgSnow64InstrDecoder::Bad1_Iog3;
	localparam __ENUM__IOG3OPER__BAD2_IOG3
		= PkgSnow64InstrDecoder::Bad2_Iog3;

	localparam __ENUM__IOG3OPER__BAD3_IOG3
		= PkgSnow64InstrDecoder::Bad3_Iog3;
	localparam __ENUM__IOG3OPER__BAD4_IOG3
		= PkgSnow64InstrDecoder::Bad4_Iog3;
	localparam __ENUM__IOG3OPER__BAD5_IOG3
		= PkgSnow64InstrDecoder::Bad5_Iog3;
	localparam __ENUM__IOG3OPER__BAD6_IOG3
		= PkgSnow64InstrDecoder::Bad6_Iog3;

	localparam __ENUM__IOG4OPER__INU8_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InU8_TwoRegsOneSimm16;
	localparam __ENUM__IOG4OPER__INS8_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InS8_TwoRegsOneSimm16;
	localparam __ENUM__IOG4OPER__INU16_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InU16_TwoRegsOneSimm16;
	localparam __ENUM__IOG4OPER__INS16_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InS16_TwoRegsOneSimm16;

	localparam __ENUM__IOG4OPER__INU32_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InU32_TwoRegsOneSimm16;
	localparam __ENUM__IOG4OPER__INS32_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InS32_TwoRegsOneSimm16;
	localparam __ENUM__IOG4OPER__INU64_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InU64_TwoRegsOneSimm16;
	localparam __ENUM__IOG4OPER__INS64_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::InS64_TwoRegsOneSimm16;

	localparam __ENUM__IOG4OPER__OUT_TWOREGSONESIMM16
		= PkgSnow64InstrDecoder::Out_TwoRegsOneSimm16;
	localparam __ENUM__IOG4OPER__BAD0_IOG4
		= PkgSnow64InstrDecoder::Bad0_Iog4;
	localparam __ENUM__IOG4OPER__BAD1_IOG4
		= PkgSnow64InstrDecoder::Bad1_Iog4;
	localparam __ENUM__IOG4OPER__BAD2_IOG4
		= PkgSnow64InstrDecoder::Bad2_Iog4;

	localparam __ENUM__IOG4OPER__BAD3_IOG4
		= PkgSnow64InstrDecoder::Bad3_Iog4;
	localparam __ENUM__IOG4OPER__BAD4_IOG4
		= PkgSnow64InstrDecoder::Bad4_Iog4;
	localparam __ENUM__IOG4OPER__BAD5_IOG4
		= PkgSnow64InstrDecoder::Bad5_Iog4;
	localparam __ENUM__IOG4OPER__BAD6_IOG4
		= PkgSnow64InstrDecoder::Bad6_Iog4;

	// Ports of Snow64Cpu
	wire __formal__in_interrupt__req = real_in_interrupt.req;

	wire __formal__in_ext_dat_acc_mem__valid
		= real_in_ext_dat_acc_mem.valid,
		__formal__in_ext_dat_acc_io__valid
		= real_in_ext_dat_acc_io.valid;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__in_ext_dat_acc_mem__data = real_in_ext_dat_acc_mem.data,
		__formal__in_ext_dat_acc_io__data = real_in_ext_dat_acc_io.data;

	wire __formal__out_interrupt__responding
		= real_out_interrupt.responding;
	wire __formal__out_ext_dat_acc_mem__req = real_out_ext_dat_acc_mem.req,
		__formal__out_ext_dat_acc_io__req = real_out_ext_dat_acc_io.req;
	wire __formal__out_ext_dat_acc_mem__access_type
		= real_out_ext_dat_acc_mem.access_type,
		__formal__out_ext_dat_acc_io__access_type
		= real_out_ext_dat_acc_io.access_type;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0]
		__formal__out_ext_dat_acc_mem__addr
		= real_out_ext_dat_acc_mem.addr,
		__formal__out_ext_dat_acc_io__addr
		= real_out_ext_dat_acc_io.addr;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__out_ext_dat_acc_mem__data
		= real_out_ext_dat_acc_mem.data,
		__formal__out_ext_dat_acc_io__data
		= real_out_ext_dat_acc_io.data;


	// Ports of __inst_instr_decoder
	wire [`MSB_POS__SNOW64_IENC_GROUP:0]
		__formal__out_inst_instr_decoder__group
		= real_out_inst_instr_decoder.group;
	wire __formal__out_inst_instr_decoder__op_type
		= real_out_inst_instr_decoder.op_type;
	wire [`MSB_POS__SNOW64_IENC_REG_INDEX:0]
		__formal__out_inst_instr_decoder__ra_index
		= real_out_inst_instr_decoder.ra_index,
		__formal__out_inst_instr_decoder__rb_index
		= real_out_inst_instr_decoder.rb_index,
		__formal__out_inst_instr_decoder__rc_index
		= real_out_inst_instr_decoder.rc_index;
	wire [`MSB_POS__SNOW64_IENC_OPCODE:0]
		__formal__out_inst_instr_decoder__oper
		= real_out_inst_instr_decoder.oper;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0]
		__formal__out_inst_instr_decoder__signext_imm
		= real_out_inst_instr_decoder.signext_imm;

	wire __formal__out_inst_instr_decoder__nop
		= real_out_inst_instr_decoder.nop;


	// Ports of __inst_memory_access_via_fifos
	wire __formal__in_inst_read_fifo__instr__req
		= real_in_inst_read_fifo__instr.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0]
		__formal__in_inst_read_fifo__instr__addr
		= real_in_inst_read_fifo__instr.addr;

	wire __formal__in_inst_read_fifo__data__req
		= real_in_inst_read_fifo__data.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0]
		__formal__in_inst_read_fifo__data__addr
		= real_in_inst_read_fifo__data.addr;

	wire __formal__in_inst_write_fifo__data__req
		= real_in_inst_write_fifo__data.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0]
		__formal__in_inst_write_fifo__data__addr
		= real_in_inst_write_fifo__data.addr;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__in_inst_write_fifo__data__data
		= real_in_inst_write_fifo__data.data;

	wire __formal__in_inst_mem_bus_guard__valid
		= real_in_inst_mem_bus_guard.valid;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__in_inst_mem_bus_guard__data
		= real_in_inst_mem_bus_guard.data;


	wire __formal__out_inst_read_fifo__instr__valid
		= real_out_inst_read_fifo__instr.valid,
		__formal__out_inst_read_fifo__data__valid
		= real_out_inst_read_fifo__data.valid,
		__formal__out_inst_write_fifo__data__valid
		= real_out_inst_write_fifo__data.valid;
	wire __formal__out_inst_read_fifo__instr__busy
		= real_out_inst_read_fifo__instr.busy,
		__formal__out_inst_read_fifo__data__busy
		= real_out_inst_read_fifo__data.busy,
		__formal__out_inst_write_fifo__data__busy
		= real_out_inst_write_fifo__data.busy;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__out_inst_read_fifo__instr__data
		= real_out_inst_read_fifo__instr.data,
		__formal__out_inst_read_fifo__data__data
		= real_out_inst_read_fifo__data.data;

	wire __formal__out_inst_mem_bus_guard__req
		= real_out_inst_mem_bus_guard.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0]
		__formal__out_inst_mem_bus_guard__addr
		= real_out_inst_mem_bus_guard.addr;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__out_inst_mem_bus_guard__data
		= real_out_inst_mem_bus_guard.data;
	wire __formal__out_inst_mem_bus_guard__mem_acc_type
		= real_out_inst_mem_bus_guard.mem_acc_type;

	// Ports of __inst_lar_file
	wire [`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0]
		__formal__in_inst_lar_file__rd_a__index
		= real_in_inst_lar_file__rd_a.index
		[`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0],
		__formal__in_inst_lar_file__rd_b__index
		= real_in_inst_lar_file__rd_b.index
		[`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0],
		__formal__in_inst_lar_file__rd_c__index
		= real_in_inst_lar_file__rd_c.index
		[`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0];
	wire __formal__in_inst_lar_file__wr__req
		= real_in_inst_lar_file__wr.req;
	wire [`MSB_POS__SNOW64_LAR_FILE_WRITE_TYPE:0]
		__formal__in_inst_lar_file__wr__write_type
		= real_in_inst_lar_file__wr.write_type;
	wire [`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0]
		__formal__in_inst_lar_file__wr__index
		= real_in_inst_lar_file__wr.index
		[`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0];
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__in_inst_lar_file__wr__non_ldst_data
		= real_in_inst_lar_file__wr.non_ldst_data;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0]
		__formal__in_inst_lar_file__wr__ldst_addr
		= real_in_inst_lar_file__wr.ldst_addr;
	wire [`MSB_POS__SNOW64_CPU_DATA_TYPE:0]
		__formal__in_inst_lar_file__wr__data_type
		= real_in_inst_lar_file__wr.data_type;
	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__formal__in_inst_lar_file__wr__int_type_size
		= real_in_inst_lar_file__wr.int_type_size;


	wire __formal__in_inst_lar_file__mem_read__valid
		= real_in_inst_lar_file__mem_read.valid;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__in_inst_lar_file__mem_read__data
		= real_in_inst_lar_file__mem_read.data;

	wire __formal__in_inst_lar_file__mem_write__valid
		= real_in_inst_lar_file__mem_write.valid;

	wire [`MSB_POS__SNOW64_LAR_FILE_METADATA_TAG:0]
		__formal__out_inst_lar_file__rd_metadata_a__tag
		= real_out_inst_lar_file__rd_metadata_a.tag,
		__formal__out_inst_lar_file__rd_metadata_b__tag
		= real_out_inst_lar_file__rd_metadata_b.tag,
		__formal__out_inst_lar_file__rd_metadata_c__tag
		= real_out_inst_lar_file__rd_metadata_c.tag;
	wire [`MSB_POS__SNOW64_LAR_FILE_METADATA_DATA_OFFSET:0]
		__formal__out_inst_lar_file__rd_metadata_a__data_offset
		= real_out_inst_lar_file__rd_metadata_a.data_offset,
		__formal__out_inst_lar_file__rd_metadata_b__data_offset
		= real_out_inst_lar_file__rd_metadata_b.data_offset,
		__formal__out_inst_lar_file__rd_metadata_c__data_offset
		= real_out_inst_lar_file__rd_metadata_c.data_offset;
	wire [`MSB_POS__SNOW64_CPU_DATA_TYPE:0]
		__formal__out_inst_lar_file__rd_metadata_a__data_type
		= real_out_inst_lar_file__rd_metadata_a.data_type,
		__formal__out_inst_lar_file__rd_metadata_b__data_type
		= real_out_inst_lar_file__rd_metadata_b.data_type,
		__formal__out_inst_lar_file__rd_metadata_c__data_type
		= real_out_inst_lar_file__rd_metadata_c.data_type;
	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__formal__out_inst_lar_file__rd_metadata_a__int_type_size
		= real_out_inst_lar_file__rd_metadata_a.int_type_size,
		__formal__out_inst_lar_file__rd_metadata_b__int_type_size
		= real_out_inst_lar_file__rd_metadata_b.int_type_size,
		__formal__out_inst_lar_file__rd_metadata_c__int_type_size
		= real_out_inst_lar_file__rd_metadata_c.int_type_size;

	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__out_inst_lar_file__rd_shareddata_a__data
		= real_out_inst_lar_file__rd_shareddata_a.data,
		__formal__out_inst_lar_file__rd_shareddata_b__data
		= real_out_inst_lar_file__rd_shareddata_b.data,
		__formal__out_inst_lar_file__rd_shareddata_c__data
		= real_out_inst_lar_file__rd_shareddata_c.data;
	wire [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__formal__out_inst_lar_file__rd_shareddata_a__base_addr
		= real_out_inst_lar_file__rd_shareddata_a.base_addr,
		__formal__out_inst_lar_file__rd_shareddata_b__base_addr
		= real_out_inst_lar_file__rd_shareddata_b.base_addr,
		__formal__out_inst_lar_file__rd_shareddata_c__base_addr
		= real_out_inst_lar_file__rd_shareddata_c.base_addr;

	wire __formal__out_inst_lar_file__wr__valid
		= real_out_inst_lar_file__wr.valid;

	wire __formal__out_inst_lar_file__mem_read__req
		= real_out_inst_lar_file__mem_read.req;
	wire [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__formal__out_inst_lar_file__mem_read__base_addr
		= real_out_inst_lar_file__mem_read.base_addr;

	wire __formal__out_inst_lar_file__mem_write__req
		= real_out_inst_lar_file__mem_write.req;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__out_inst_lar_file__mem_write__data
		= real_out_inst_lar_file__mem_write.data;
	wire [`MSB_POS__SNOW64_LAR_FILE_SHAREDDATA_BASE_ADDR:0]
		__formal__out_inst_lar_file__mem_write__base_addr
		= real_out_inst_lar_file__mem_write.base_addr;
	`endif		// FORMAL



	initial
	begin
		real_out_interrupt = 0;
		real_out_ext_dat_acc_mem = 0;
		real_out_ext_dat_acc_io = 0;

		{real_in_inst_read_fifo__instr,
			real_in_inst_read_fifo__data,
			real_in_inst_write_fifo__data,
			real_in_inst_mem_bus_guard} = 0;

		{real_in_inst_lar_file__rd_a, real_in_inst_lar_file__rd_b,
			real_in_inst_lar_file__rd_c,
			real_in_inst_lar_file__wr,
			real_in_inst_lar_file__mem_read,
			real_in_inst_lar_file__mem_write} = 0;

		{real_in_inst_alu_0, real_in_inst_alu_1,
		real_in_inst_alu_2, real_in_inst_alu_3} = 0;

		{real_in_inst_vec_mul_0, real_in_inst_vec_mul_1,
		real_in_inst_vec_mul_2, real_in_inst_vec_mul_3} = 0;

		{real_in_inst_div_0, real_in_inst_div_1,
			real_in_inst_div_2, real_in_inst_div_3} = 0;

		{real_in_inst_scalar_data_extractor_0,
			real_in_inst_scalar_data_extractor_1} = 0;
		real_in_inst_scalar_data_injector = 0;

		{real_in_inst_fpu_0, real_in_inst_fpu_1, real_in_inst_fpu_2,
			real_in_inst_fpu_3} = 0;

		{real_in_inst_cast_from_int_to_bfloat16_0,
			real_in_inst_cast_from_int_to_bfloat16_1} = 0;

		{real_in_inst_cast_to_int_from_bfloat16_0,
			real_in_inst_cast_to_int_from_bfloat16_1} = 0;

		{real_in_inst_int_scalar_caster_0,
			real_in_inst_int_scalar_caster_1} = 0;

		{real_in_inst_int_vector_caster_0,
			real_in_inst_int_vector_caster_1} = 0;
		{real_in_inst_to_or_from_bfloat16_vector_caster_0,
			real_in_inst_to_or_from_bfloat16_vector_caster_1} = 0;

		{__spec_reg_ie, __spec_reg_ireta, __spec_reg_pc} = 0;
	end

	//always @(*)
	//begin
	//	
	//end

	//always @(posedge clk)
	//begin
	//	
	//end


endmodule
