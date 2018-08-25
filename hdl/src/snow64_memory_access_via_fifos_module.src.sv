`include "src/snow64_memory_access_via_fifos_defines.header.sv"

// Since with Icarus Verilog at least (not sure if that's required by the
// standard?) we can't do a forward reference from one package to another
// package, we're stuck using multiple packed structs here for the ports of
// Snow64MemoryAccessViaFifos.
module Snow64MemoryAccessViaFifos(input logic clk,
	input PkgSnow64MemoryAccessFifo::PartialPortIn_ReadFifo_ReqRead
		in_mem_acc_read_fifo__instr__req_read,
		in_mem_acc_read_fifo__data__req_read,
	input PkgSnow64MemoryAccessFifo::PartialPortIn_WriteFifo_ReqWrite
		in_mem_acc_write_fifo__data__req_write,

	input PkgSnow64MemoryBusGuard::PartialPortIn_MemoryBusGuard_MemAccess
		in_mem_bus_guard__mem_access,

	output PkgSnow64MemoryAccessFifo::PartialPortOut_ReadFifo_ReqRead
		out_mem_acc_read_fifo__instr__req_read,
		out_mem_acc_read_fifo__data__req_read,
	output PkgSnow64MemoryAccessFifo::PartialPortOut_WriteFifo_ReqWrite
		out_mem_acc_write_fifo__data__req_write,

	output PkgSnow64MemoryBusGuard::PartialPortOut_MemoryBusGuard_MemAccess
		out_mem_bus_guard__mem_access);


	import PkgSnow64MemoryAccessFifo::*;
	import PkgSnow64MemoryBusGuard::*;




	PortIn_MemoryAccessReadFifo
		__in_mem_acc_read_fifo__instr, __in_mem_acc_read_fifo__data;
	PortOut_MemoryAccessReadFifo
		__out_mem_acc_read_fifo__instr, __out_mem_acc_read_fifo__data;
	Snow64MemoryAccessReadFifo __inst_mem_acc_read_fifo__instr
		(.clk(clk), .in(__in_mem_acc_read_fifo__instr),
		.out(__out_mem_acc_read_fifo__instr));
	Snow64MemoryAccessReadFifo __inst_mem_acc_read_fifo__data
		(.clk(clk), .in(__in_mem_acc_read_fifo__data),
		.out(__out_mem_acc_read_fifo__data));


	PartialPortIn_ReadFifo_FromMemoryBusGuard
		__real_in_mem_acc_read_fifo__instr__from_mbg,
		__real_in_mem_acc_read_fifo__data__from_mbg;
	PartialPortOut_ReadFifo_ToMemoryBusGuard
		__real_out_mem_acc_read_fifo__instr__to_mbg,
		__real_out_mem_acc_read_fifo__data__to_mbg;

	assign __in_mem_acc_read_fifo__instr
		= {in_mem_acc_read_fifo__instr__req_read,
		__real_in_mem_acc_read_fifo__instr__from_mbg};
	assign __in_mem_acc_read_fifo__data
		= {in_mem_acc_read_fifo__data__req_read,
		__real_in_mem_acc_read_fifo__data__from_mbg};

	assign {out_mem_acc_read_fifo__instr__req_read,
		__real_out_mem_acc_read_fifo__instr__to_mbg}
		= __out_mem_acc_read_fifo__instr;
	assign {out_mem_acc_read_fifo__data__req_read,
		__real_out_mem_acc_read_fifo__data__to_mbg}
		= __out_mem_acc_read_fifo__data;


	PortIn_MemoryAccessWriteFifo __in_mem_acc_write_fifo__data;
	PortOut_MemoryAccessWriteFifo __out_mem_acc_write_fifo__data;
	Snow64MemoryAccessWriteFifo __inst_mem_acc_write_fifo(.clk(clk),
		.in(__in_mem_acc_write_fifo__data),
		.out(__out_mem_acc_write_fifo__data));

	PartialPortIn_WriteFifo_FromMemoryBusGuard
		__real_in_mem_acc_write_fifo__data__from_mbg;
	PartialPortOut_WriteFifo_ToMemoryBusGuard
		__real_out_mem_acc_write_fifo__data__to_mbg;

	assign __in_mem_acc_write_fifo__data
		= {in_mem_acc_write_fifo__data__req_write,
		__real_in_mem_acc_write_fifo__data__from_mbg};

	assign {out_mem_acc_write_fifo__data__req_write,
		__real_out_mem_acc_write_fifo__data__to_mbg}
		= __out_mem_acc_write_fifo__data;


	PortIn_MemoryBusGuard __in_mem_bus_guard;
	PortOut_MemoryBusGuard __out_mem_bus_guard;
	Snow64MemoryBusGuard __inst_mem_bus_guard(.clk(clk),
		.in(__in_mem_bus_guard), .out(__out_mem_bus_guard));

	PartialPortIn_MemoryBusGuard_ReqRead
		__real_in_mem_bus_guard__req_read__instr,
		__real_in_mem_bus_guard__req_read__data;
	PartialPortIn_MemoryBusGuard_ReqWrite
		__real_in_mem_bus_guard__req_write__data;

	PartialPortOut_MemoryBusGuard_ReqRead
		__real_out_mem_bus_guard__req_read__instr,
		__real_out_mem_bus_guard__req_read__data;
	PartialPortOut_MemoryBusGuard_ReqWrite
		__real_out_mem_bus_guard__req_write__data;

	assign __in_mem_bus_guard
		= {__real_in_mem_bus_guard__req_read__instr,
		__real_in_mem_bus_guard__req_read__data,
		__real_in_mem_bus_guard__req_write__data,
		in_mem_bus_guard__mem_access};

	assign {__real_out_mem_bus_guard__req_read__instr,
		__real_out_mem_bus_guard__req_read__data,
		__real_out_mem_bus_guard__req_write__data,
		out_mem_bus_guard__mem_access}
		= __out_mem_bus_guard;

	// Connections between the FIFOs and the Snow64MemoryBusGuard.
	assign __real_in_mem_bus_guard__req_read__instr
		= __real_out_mem_acc_read_fifo__instr__to_mbg;
	assign __real_in_mem_bus_guard__req_read__data
		= __real_out_mem_acc_read_fifo__data__to_mbg;
	assign __real_in_mem_bus_guard__req_write__data
		= __real_out_mem_acc_write_fifo__data__to_mbg;

	assign __real_in_mem_acc_read_fifo__instr__from_mbg
		= __real_out_mem_bus_guard__req_read__instr;
	assign __real_in_mem_acc_read_fifo__data__from_mbg
		= __real_out_mem_bus_guard__req_read__data;
	assign __real_in_mem_acc_write_fifo__data__from_mbg
		= __real_out_mem_bus_guard__req_write__data;

	`ifdef FORMAL
	`endif		// FORMAL



endmodule
