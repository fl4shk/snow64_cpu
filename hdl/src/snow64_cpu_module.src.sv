`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"


module Snow64Cpu(input logic clk,
	input PkgSnow64Cpu::PortIn_Cpu in,
	output PkgSnow64Cpu::PortOut_Cpu out);

	//PkgSnow64Cpu::Test __out_test;

	//assign out.test = __out_test;

	PkgSnow64Cpu::PartialPortIn_Cpu_Interrupt real_in_interrupt;
	assign real_in_interrupt = in.interrupt;

	wire __in_interrupt__req = real_in_interrupt.req;



	PkgSnow64Cpu::PartialPortIn_Cpu_ExtDataAccess
		real_in_ext_dat_acc_mem, real_in_ext_dat_acc_port_mapped_io;
	assign real_in_ext_dat_acc_mem
		= in.ext_dat_acc_mem;
	assign real_in_ext_dat_acc_port_mapped_io
		= in.ext_dat_acc_port_mapped_io;

	wire __in_ext_dat_acc_mem__busy
		= real_in_ext_dat_acc_mem.busy,
		__in_ext_dat_acc_port_mapped_io__busy 
		= real_in_ext_dat_acc_port_mapped_io.busy;

	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__in_ext_dat_acc_mem__data
		= real_in_ext_dat_acc_mem.data,
		__in_ext_dat_acc_port_mapped_io__data 
		= real_in_ext_dat_acc_port_mapped_io.data;




	PkgSnow64Cpu::PartialPortOut_Cpu_ExtDataAccess
		real_out_ext_dat_acc_mem, real_out_ext_dat_acc_port_mapped_io;
	assign out.ext_dat_acc_mem
		= real_out_ext_dat_acc_mem;
	assign out.ext_dat_acc_port_mapped_io
		= real_out_ext_dat_acc_port_mapped_io;


	logic __out_ext_dat_acc_mem__req,
		__out_ext_dat_acc_port_mapped_io__req;
	assign real_out_ext_dat_acc_mem.req
		= __out_ext_dat_acc_mem__req;
	assign real_out_ext_dat_acc_port_mapped_io.req
		= __out_ext_dat_acc_port_mapped_io__req;


	PkgSnow64Cpu::ExtDataAccessType __out_ext_dat_acc_mem__access_type,
		__out_ext_dat_acc_port_mapped_io__access_type;
	assign real_out_ext_dat_acc_mem.access_type
		= __out_ext_dat_acc_mem__access_type;
	assign real_out_ext_dat_acc_port_mapped_io.access_type
		= __out_ext_dat_acc_port_mapped_io__access_type;

	logic [`MSB_POS__SNOW64_CPU_ADDR:0]
		__out_ext_dat_acc_mem__addr,
		__out_ext_dat_acc_port_mapped_io__addr;
	assign real_out_ext_dat_acc_mem.addr
		= __out_ext_dat_acc_mem__addr;
	assign real_out_ext_dat_acc_port_mapped_io.addr
		= __out_ext_dat_acc_port_mapped_io__addr;

	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0]
		__out_ext_dat_acc_mem__data,
		__out_ext_dat_acc_port_mapped_io__data;
	assign real_out_ext_dat_acc_mem.data
		= __out_ext_dat_acc_mem__data;
	assign real_out_ext_dat_acc_port_mapped_io.data
		= __out_ext_dat_acc_port_mapped_io__data;

endmodule
