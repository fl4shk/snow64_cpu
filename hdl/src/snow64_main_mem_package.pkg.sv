`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_lar_file_defines.header.sv"

package PkgSnow64MainMem;

localparam WIDTH__DATA_INOUT = `WIDTH__SNOW64_LAR_FILE_DATA;
localparam MSB_POS__DATA_INOUT = `WIDTH2MP(WIDTH__DATA_INOUT);

// 64 kiB of RAM
localparam ARR_SIZE__MEM = 2048; 

localparam WIDTH__MEM_ADDRESS = $clog2(ARR_SIZE__MEM);
localparam MSB_POS__MEM_ADDRESS = `WIDTH2MP(WIDTH__MEM_ADDRESS);

endpackage : PkgSnow64MainMem
