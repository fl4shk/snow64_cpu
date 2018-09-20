`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"


module Snow64MainMem(input logic clk,
	input logic in_req_wr,
	input logic [PkgSnow64MainMem::MSB_POS__MEM_ADDRESS:0] in_addr,
	input logic [PkgSnow64MainMem::MSB_POS__DATA_INOUT:0] in_data,
	output logic [PkgSnow64MainMem::MSB_POS__DATA_INOUT:0] out_data);


	logic [PkgSnow64MainMem::MSB_POS__DATA_INOUT:0]
		__mem[PkgSnow64MainMem::ARR_SIZE__MEM];

	//initial
	//begin
	//	$readmemh(__mem, );
	//end


	always_ff @(posedge clk)
	begin
		if (in_req_wr)
		begin
			__mem[in_addr] <= in_data;
		end

		else // if (!in_req_wr)
		begin
			out_data <= __mem[in_addr];
		end
	end


endmodule
