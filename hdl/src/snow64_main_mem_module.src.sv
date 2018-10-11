`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"


module Snow64MainMem(input logic clk,
	input logic in_req_wr,
	input logic [PkgSnow64MainMem::MSB_POS__MEM_ADDRESS:0] in_addr,
	input logic [PkgSnow64MainMem::MSB_POS__DATA_INOUT:0] in_data,
	output logic [PkgSnow64MainMem::MSB_POS__DATA_INOUT:0] out_data);


	logic [PkgSnow64MainMem::MSB_POS__DATA_INOUT:0]
		__mem[PkgSnow64MainMem::ARR_SIZE__MEM];
	integer i;

	initial
	begin
		for (i=0; i<PkgSnow64MainMem::ARR_SIZE__MEM; i=i+1)
		begin
			__mem[i] = 0;
		end

		//$readmemh("initial_mem_contents.txt.ignore", __mem);
		//#2
		//$display("Snow64MainMem:  %h", __mem[0]);
		//$display("Snow64MainMem:  %h", __mem[1]);
		//__mem[0][31:0] = 32'h0000_e000;

		__mem[0][31:0] = 32'h0000_e000;
		__mem[0][63:32] = 32'h0000_e001;
		__mem[0][95:64] = 32'h0000_e001;
		__mem[0][127:96] = 32'h0000_e001;
	end


	always @(posedge clk)
	begin
		//$display("Snow64MainMem clocked logic");
		if (in_req_wr)
		begin
			__mem[in_addr] <= in_data;
		end

		//else // if (!in_req_wr)
		begin
			//$display("Snow64MainMem data read:  %h %h", in_addr,
			//	__mem[in_addr]);
			out_data <= __mem[in_addr];
		end
	end


endmodule
