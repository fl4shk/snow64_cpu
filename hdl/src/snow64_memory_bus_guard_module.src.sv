`include "src/snow64_memory_bus_guard_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"


module Snow64MemoryBusGuard(input logic clk,
	input PkgSnow64MemoryBusGuard::PortIn_MemoryBusGuard in,
	output PkgSnow64MemoryBusGuard::PortOut_MemoryBusGuard out);

	import PkgSnow64MemoryBusGuard::CpuAddr;
	import PkgSnow64MemoryBusGuard::LarData;

	typedef logic [`MSB_POS__SNOW64_MEMORY_BUS_GUARD__REQUEST_TYPE:0]
		RequestType;

	logic [`MSB_POS__SNOW64_MEMORY_BUS_GUARD__REQUEST_TYPE:0]
		__stage_0_to_1__req_type, __stage_1_to_2__req_type;

	initial
	begin
		{__stage_0_to_1__req_type, __stage_1_to_2__req_type} = 0;
	end


	`ifdef FORMAL
	localparam __ENUM__REQUEST_TYPE__NONE
		= PkgSnow64MemoryBusGuard::ReqTypNone;
	localparam __ENUM__REQUEST_TYPE__READ_INSTR
		= PkgSnow64MemoryBusGuard::ReqTypReadInstr;
	localparam __ENUM__REQUEST_TYPE__READ_DATA
		= PkgSnow64MemoryBusGuard::ReqTypReadData;
	localparam __ENUM__REQUEST_TYPE__WRITE_DATA
		= PkgSnow64MemoryBusGuard::ReqTypWriteData;

	localparam __ENUM__MEM_ACCESS_TYPE__READ
		= PkgSnow64MemoryBusGuard::MemAccTypRead;
	localparam __ENUM__MEM_ACCESS_TYPE__WRITE
		= PkgSnow64MemoryBusGuard::MemAccTypWrite;
	`endif

	PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_ReqRead
		real_in_req_read_instr, real_in_req_read_data;
	assign real_in_req_read_instr = in.req_read_instr;
	assign real_in_req_read_data = in.req_read_data;

	wire __in_req_read_instr__req
		= real_in_req_read_instr.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __in_req_read_instr__addr
		= real_in_req_read_instr.addr;

	wire __in_req_read_data__req
		= real_in_req_read_data.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __in_req_read_data__addr
		= real_in_req_read_data.addr;

	PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_ReqWrite
		real_in_req_write_data;
	assign real_in_req_write_data = in.req_write_data;

	wire __in_req_write_data__req = real_in_req_write_data.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __in_req_write_data__addr
		= real_in_req_write_data.addr;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __in_req_write_data__data
		= real_in_req_write_data.data;

	PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_MemAccess
		real_in_mem_access;
	assign real_in_mem_access = in.mem_access;

	wire __in_mem_access__valid = real_in_mem_access.valid;

	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __in_mem_access__data
		= real_in_mem_access.data;


	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_ReqRead
		real_out_req_read_instr, real_out_req_read_data;
	assign out.req_read_instr = real_out_req_read_instr;
	assign out.req_read_data = real_out_req_read_data;

	logic __out_req_read_instr__valid, __out_req_read_data__valid;
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__out_req_read_instr__data, __out_req_read_data__data;

	assign real_out_req_read_instr.valid = __out_req_read_instr__valid;
	assign real_out_req_read_instr.data = __out_req_read_instr__data;

	assign real_out_req_read_data.valid = __out_req_read_data__valid;
	assign real_out_req_read_data.data = __out_req_read_data__data;

	initial
	begin
		{__out_req_read_instr__valid, __out_req_read_data__valid} = 0;
		{__out_req_read_instr__data, __out_req_read_data__data} = 0;
	end

	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_ReqWrite
		real_out_req_write_data;
	assign out.req_write_data = real_out_req_write_data;

	logic __out_req_write_data__valid;
	assign real_out_req_write_data.valid = __out_req_write_data__valid;

	initial
	begin
		__out_req_write_data__valid = 0;
	end


	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_MemAccess
		real_out_mem_access;
	assign out.mem_access = real_out_mem_access;


	logic __out_mem_access__req;
	logic [`MSB_POS__SNOW64_CPU_ADDR:0] __out_mem_access__addr;
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __out_mem_access__data;
	PkgSnow64MemoryBusGuard::MemAccessType __out_mem_access__mem_acc_type;

	assign real_out_mem_access.req = __out_mem_access__req;
	assign real_out_mem_access.addr = __out_mem_access__addr;
	assign real_out_mem_access.data = __out_mem_access__data;
	assign real_out_mem_access.mem_acc_type
		= __out_mem_access__mem_acc_type;


	// Basically the "global valid signal" method of stalling.
	// This is used for simplicity, and because this pipeline will never
	// stall when we are interfacing with purely synchronous block RAM that
	// has the same clock rate as us.
	wire __stall = ((__stage_1_to_2__req_type
		!= PkgSnow64MemoryBusGuard::ReqTypNone)
		&& (!__in_mem_access__valid));

	initial
	begin
		{__out_mem_access__req, __out_mem_access__addr,
			__out_mem_access__data} = 0;

		__out_mem_access__mem_acc_type
			= PkgSnow64MemoryBusGuard::MemAccTypRead;
	end


	task stop_mem_access;
		__out_mem_access__req <= 0;
	endtask : stop_mem_access

	task prep_mem_read(input CpuAddr addr);
		__out_mem_access__req <= 1;
		__out_mem_access__addr <= addr;
		__out_mem_access__mem_acc_type
			<= PkgSnow64MemoryBusGuard::MemAccTypRead;
	endtask : prep_mem_read

	task prep_mem_write;
		__out_mem_access__req <= 1;
		__out_mem_access__addr <= __in_req_write_data__addr;
		__out_mem_access__mem_acc_type
			<= PkgSnow64MemoryBusGuard::MemAccTypWrite;
		__out_mem_access__data <= __in_req_write_data__data;
	endtask : prep_mem_write


	// Stage 0:  Accept a request, drive memory bus.
	always @(posedge clk)
	begin
		// If we're stalling, that means we can't drive the memory bus, and
		// therefore we have nothing to send down the pipe to later stages.
		if (!__stall)
		begin
			// Instruction reader thing requested a block of instructions.
			if (__in_req_read_instr__req)
			begin
				__stage_0_to_1__req_type
					<= PkgSnow64MemoryBusGuard::ReqTypReadInstr;
				prep_mem_read(__in_req_read_instr__addr);
			end

			// LAR file wants to read data.
			else if (__in_req_read_data__req)
			begin
				__stage_0_to_1__req_type
					<= PkgSnow64MemoryBusGuard::ReqTypReadData;
				prep_mem_read(__in_req_read_data__addr);
			end

			// LAR file wants to write data.
			else if (__in_req_write_data__req)
			begin
				__stage_0_to_1__req_type
					<= PkgSnow64MemoryBusGuard::ReqTypWriteData;
				prep_mem_write();
			end

			else
			begin
				__stage_0_to_1__req_type
					<= PkgSnow64MemoryBusGuard::ReqTypNone;
				stop_mem_access();
			end
		end
	end

	// Stage 1:  Idle while the memory (or memory controller, as the case
	// may be) sees our request and synchronously drives its own outputs.
	always_ff @(posedge clk)
	begin
		if (!__stall)
		begin
			__stage_1_to_2__req_type <= __stage_0_to_1__req_type;
		end
	end

	// Stage 2:  Let requester know that stuff is done.
	// Here, it's possible
	always_ff @(posedge clk)
	begin
		if (!__stall)
		begin
			case (__stage_1_to_2__req_type)
			PkgSnow64MemoryBusGuard::ReqTypReadInstr:
			begin
				__out_req_read_instr__valid <= 1;
				__out_req_read_data__valid <= 0;
				__out_req_write_data__valid <= 0;

				__out_req_read_instr__data <= __in_mem_access__data;
			end

			PkgSnow64MemoryBusGuard::ReqTypReadData:
			begin
				__out_req_read_instr__valid <= 0;
				__out_req_read_data__valid <= 1;
				__out_req_write_data__valid <= 0;

				__out_req_read_data__data <= __in_mem_access__data;
			end

			PkgSnow64MemoryBusGuard::ReqTypWriteData:
			begin
				__out_req_read_instr__valid <= 0;
				__out_req_read_data__valid <= 0;
				__out_req_write_data__valid <= 1;
			end

			default:
			begin
				__out_req_read_instr__valid <= 0;
				__out_req_read_data__valid <= 0;
				__out_req_write_data__valid <= 0;
			end
			endcase
		end

		else // if (__stall)
		begin
			__out_req_read_instr__valid <= 0;
			__out_req_read_data__valid <= 0;
			__out_req_write_data__valid <= 0;
		end
	end

endmodule
