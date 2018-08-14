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


	PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_ReqWrite
		real_in_req_write_data;
	assign real_in_req_write_data = in.req_write_data;


	PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_MemAccess
		real_in_mem_access;
	assign real_in_mem_access = in.mem_access;



	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_ReqRead
		real_out_req_read_instr, real_out_req_read_data;
	assign out.req_read_instr = real_out_req_read_instr;
	assign out.req_read_data = real_out_req_read_data;




	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_ReqWrite
		real_out_req_write_data;
	assign out.req_write_data = real_out_req_write_data;




	PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_MemAccess
		real_out_mem_access;
	assign out.mem_access = real_out_mem_access;





	`ifdef FORMAL
	wire __formal__in_req_read_instr__req
		= real_in_req_read_instr.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __formal__in_req_read_instr__addr
		= real_in_req_read_instr.addr;

	wire __formal__in_req_read_data__req
		= real_in_req_read_data.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __formal__in_req_read_data__addr
		= real_in_req_read_data.addr;


	wire __formal__in_req_write_data__req = real_in_req_write_data.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __formal__in_req_write_data__addr
		= real_in_req_write_data.addr;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__in_req_write_data__data
		= real_in_req_write_data.data;


	wire __formal__in_mem_access__valid = real_in_mem_access.valid;

	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__in_mem_access__data
		= real_in_mem_access.data;


	wire __formal__out_req_read_instr__valid
		= real_out_req_read_instr.valid;
	wire __formal__out_req_read_instr__cmd_accepted
		= real_out_req_read_instr.cmd_accepted;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__out_req_read_instr__data = real_out_req_read_instr.data;

	wire __formal__out_req_read_data__valid = real_out_req_read_data.valid;
	wire __formal__out_req_read_data__cmd_accepted
		= real_out_req_read_data.cmd_accepted;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__formal__out_req_read_data__data = real_out_req_read_data.data;


	wire __formal__out_req_write_data__valid
		= real_out_req_write_data.valid;
	wire __formal__out_req_write_data__cmd_accepted
		= real_out_req_write_data.cmd_accepted;


	wire __formal__out_mem_access__req = real_out_mem_access.req;
	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __formal__out_mem_access__addr
		= real_out_mem_access.addr;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __formal__out_mem_access__data
		= real_out_mem_access.data;
	wire __formal__out_mem_access__mem_acc_type
		= real_out_mem_access.mem_acc_type;
	`endif		// FORMAL

	// Basically the "global valid signal" method of stalling.
	// This is used for simplicity, and because this pipeline will never
	// stall when we are interfacing with purely synchronous block RAM that
	// has the same clock rate as us.
	wire __stall = ((__stage_1_to_2__req_type
		!= PkgSnow64MemoryBusGuard::ReqTypNone)
		&& (!real_in_mem_access.valid));

	initial
	begin
		{__stage_0_to_1__req_type, __stage_1_to_2__req_type} = 0;

		{real_out_req_read_instr.valid, real_out_req_read_data.valid} = 0;
		{real_out_req_read_instr.cmd_accepted,
			real_out_req_read_data.cmd_accepted} = 0;
		{real_out_req_read_instr.data, real_out_req_read_data.data} = 0;
		real_out_req_write_data.valid = 0;
		real_out_req_write_data.cmd_accepted = 0;
		{real_out_mem_access.req, real_out_mem_access.addr,
			real_out_mem_access.data} = 0;

		real_out_mem_access.mem_acc_type
			= PkgSnow64MemoryBusGuard::MemAccTypRead;
	end


	task stop_mem_access;
		real_out_mem_access.req <= 0;
	endtask : stop_mem_access

	task prep_mem_read(input CpuAddr addr);
		real_out_mem_access.req <= 1;
		real_out_mem_access.addr <= addr;
		real_out_mem_access.mem_acc_type
			<= PkgSnow64MemoryBusGuard::MemAccTypRead;
	endtask : prep_mem_read

	task prep_mem_write;
		real_out_mem_access.req <= 1;
		real_out_mem_access.addr <= real_in_req_write_data.addr;
		real_out_mem_access.mem_acc_type
			<= PkgSnow64MemoryBusGuard::MemAccTypWrite;
		real_out_mem_access.data <= real_in_req_write_data.data;
	endtask : prep_mem_write


	// Stage 0:  Accept a request, drive memory bus.
	always @(posedge clk)
	begin
		// If we're stalling, that means we can't drive the memory bus, and
		// therefore we have nothing to send down the pipe to later stages.
		if (!__stall)
		begin
			// Instruction reader thing requested a block of instructions.
			if (real_in_req_read_instr.req)
			begin
				__stage_0_to_1__req_type
					<= PkgSnow64MemoryBusGuard::ReqTypReadInstr;
				prep_mem_read(real_in_req_read_instr.addr);

				real_out_req_read_instr.cmd_accepted <= 1;
				real_out_req_read_data.cmd_accepted <= 0;
				real_out_req_write_data.cmd_accepted <= 0;
			end

			// LAR file wants to read data.
			else if (real_in_req_read_data.req)
			begin
				__stage_0_to_1__req_type
					<= PkgSnow64MemoryBusGuard::ReqTypReadData;
				prep_mem_read(real_in_req_read_data.addr);

				real_out_req_read_instr.cmd_accepted <= 0;
				real_out_req_read_data.cmd_accepted <= 1;
				real_out_req_write_data.cmd_accepted <= 0;
			end

			// LAR file wants to write data.
			else if (real_in_req_write_data.req)
			begin
				__stage_0_to_1__req_type
					<= PkgSnow64MemoryBusGuard::ReqTypWriteData;
				prep_mem_write();

				real_out_req_read_instr.cmd_accepted <= 0;
				real_out_req_read_data.cmd_accepted <= 0;
				real_out_req_write_data.cmd_accepted <= 1;
			end

			else
			begin
				__stage_0_to_1__req_type
					<= PkgSnow64MemoryBusGuard::ReqTypNone;
				stop_mem_access();

				real_out_req_read_instr.cmd_accepted <= 0;
				real_out_req_read_data.cmd_accepted <= 0;
				real_out_req_write_data.cmd_accepted <= 0;
			end
		end

		else // if (__stall)
		begin
			stop_mem_access();

			real_out_req_read_instr.cmd_accepted <= 0;
			real_out_req_read_data.cmd_accepted <= 0;
			real_out_req_write_data.cmd_accepted <= 0;
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
				real_out_req_read_instr.valid <= 1;
				real_out_req_read_data.valid <= 0;
				real_out_req_write_data.valid <= 0;

				real_out_req_read_instr.data <= real_in_mem_access.data;
			end

			PkgSnow64MemoryBusGuard::ReqTypReadData:
			begin
				real_out_req_read_instr.valid <= 0;
				real_out_req_read_data.valid <= 1;
				real_out_req_write_data.valid <= 0;

				real_out_req_read_data.data <= real_in_mem_access.data;
			end

			PkgSnow64MemoryBusGuard::ReqTypWriteData:
			begin
				real_out_req_read_instr.valid <= 0;
				real_out_req_read_data.valid <= 0;
				real_out_req_write_data.valid <= 1;
			end

			default:
			begin
				real_out_req_read_instr.valid <= 0;
				real_out_req_read_data.valid <= 0;
				real_out_req_write_data.valid <= 0;
			end
			endcase
		end

		else // if (__stall)
		begin
			real_out_req_read_instr.valid <= 0;
			real_out_req_read_data.valid <= 0;
			real_out_req_write_data.valid <= 0;
		end
	end

endmodule
