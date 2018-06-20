`include "src/snow64_cpu_defines.header.sv"

package PkgSnow64Cpu;


typedef enum logic [`MSB_POS__SNOW64_CPU_TYPE_SIZE:0]
{
	TypSz8,
	TypSz16,
	TypSz32,
	TypSz64
} TypeSize;

localparam __DEBUG_ENUM__TYP_SZ_8 = TypSz8;
localparam __DEBUG_ENUM__TYP_SZ_16 = TypSz16;
localparam __DEBUG_ENUM__TYP_SZ_32 = TypSz32;
localparam __DEBUG_ENUM__TYP_SZ_64 = TypSz64;

endpackage : PkgSnow64Cpu
