`include "src/snow64_memory_bus_guard_defines.header.sv"
`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"


module Snow64MemoryBusGuard(input logic clk,
	input PkgSnow64MemoryBusGuard::PortIn_MemoryBusGuard in,
	output PkgSnow64MemoryBusGuard::PortOut_MemoryBusGuard out);

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

	wire __in_mem_access__busy = real_in_mem_access.busy;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __in_mem_access__data
		= real_in_mem_access.data;


	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_ReqRead
		real_out_req_read_instr, real_out_req_read_data;
	assign out.req_read_instr = real_out_req_read_instr;
	assign out.req_read_data = real_out_req_read_data;

	logic __out_req_read_instr__busy, __out_req_read_data__busy;
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__out_req_read_instr__data, __out_req_read_data__data;

	assign real_out_req_read_instr.busy = __out_req_read_instr__busy;
	assign real_out_req_read_instr.data = __out_req_read_instr__data;

	assign real_out_req_read_data.busy = __out_req_read_data__busy;
	assign real_out_req_read_data.data = __out_req_read_data__data;

	initial
	begin
		{__out_req_read_instr__busy, __out_req_read_data__busy} = 0;
		{__out_req_read_instr__data, __out_req_read_data__data} = 0;
	end

	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_ReqWrite
		real_out_req_write_data;
	assign out.req_write_data = real_out_req_write_data;

	logic __out_req_write_data__busy;
	assign real_out_req_write_data.busy = __out_req_write_data__busy;

	initial
	begin
		__out_req_write_data__busy = 0;
	end

	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_Status
		real_out_status;
	assign out.status = real_out_status;

	logic __out_status__can_accept_cmd, __out_status__busy;
	assign real_out_status.can_accept_cmd = __out_status__can_accept_cmd;
	assign real_out_status.busy = __out_status__busy;

	initial
	begin
		{__out_status__can_accept_cmd, __out_status__busy} = 0;
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

	initial
	begin
		{__out_mem_access__req, __out_mem_access__addr,
			__out_mem_access__data} = 0;

		__out_mem_access__mem_acc_type
			= PkgSnow64MemoryBusGuard::MemAccTypRead;
	end

endmodule
