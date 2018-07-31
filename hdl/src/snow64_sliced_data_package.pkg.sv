`include "src/snow64_cpu_defines.header.sv"

package PkgSnow64SlicedData;


typedef struct packed
{
	logic [`MSB_POS__SNOW64_SIZE_8:0] 
		data_7, data_6, data_5, data_4, data_3, data_2, data_1, data_0;
} SlicedData8;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_SIZE_16:0] 
		data_3, data_2, data_1, data_0;
} SlicedData16;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_SIZE_32:0] data_1, data_0;
} SlicedData32;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_SIZE_64:0] data_0;
} SlicedData64;


endpackage : PkgSnow64SlicedData
