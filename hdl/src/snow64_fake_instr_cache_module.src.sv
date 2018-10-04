`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"

// One line of instruction cache...
// This can easily be replaced with a REAL instruction cache, as the rest
// of the logic of the CPU is set up for it.
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
	localparam __MSB_POS__BASE_ADDR = `WIDTH2MP(__WIDTH__BASE_ADDR);

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
					out_mem_access.req <= 1;
					out_mem_access.addr <= in_req_read.addr;

					// The only time the output isn't valid is when there's
					// a miss.
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


