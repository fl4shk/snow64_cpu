`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"


//module Snow64TopLevel;
//	logic __clk;
//
//	initial
//	begin
//		__clk = 0;
//	end
//
//	always
//	begin
//		#1
//		__clk = !__clk;
//	end
//
//
//	PkgSnow64Cpu::PortIn_Cpu __in_inst_cpu;
//	PkgSnow64Cpu::PortOut_Cpu __out_inst_cpu;
//	Snow64Cpu __inst_cpu(.clk(__clk), .in(__in_inst_cpu),
//		.out(__out_inst_cpu));
//
//
//	wire __in_main_mem_req_wr
//		= (__out_inst_cpu.req && __out_inst_cpu.mem_acc_type);
//
//	//wire [PkgSnow64MainMem::MSB_POS__MEM_ADDRESS:0] __in_main_mem_addr
//	//	= __out_inst_cpu.addr[PkgSnow64MainMem::MSB_POS__MEM_ADDRESS:0];
//
//	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __out_inst_cpu__addr
//		= __out_inst_cpu.addr;
//	wire [`MSB_POS__SNOW64_CPU_ADDR:0] __edited_out_inst_cpu_addr
//		= __out_inst_cpu__addr[`MSB_POS__SNOW64_CPU_ADDR
//		:$clog2(`WIDTH__SNOW64_LAR_FILE_DATA / 8)];
//	wire [PkgSnow64MainMem::MSB_POS__MEM_ADDRESS:0] __in_main_mem_addr
//		= __edited_out_inst_cpu_addr;
//	wire [PkgSnow64MainMem::MSB_POS__DATA_INOUT:0]
//		__in_main_mem_data, __out_main_mem_data;
//	assign __in_main_mem_data = __out_inst_cpu.data;
//
//	Snow64MainMem __inst_main_mem(.clk(__clk),
//		.in_req_wr(__in_main_mem_req_wr), .in_addr(__in_main_mem_addr),
//		.in_data(__in_main_mem_data), .out_data(__out_main_mem_data));
//
//	//assign __in_inst_cpu.valid = 1'b1;
//	//assign __in_inst_cpu.data = __out_main_mem_data;
//	assign __in_inst_cpu = {1'b1, __out_main_mem_data};
//
//endmodule
