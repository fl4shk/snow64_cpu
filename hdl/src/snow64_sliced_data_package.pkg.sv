`include "src/snow64_cpu_defines.header.sv"

package PkgSnow64SlicedData;

`ifdef FORMAL
typedef struct packed
{
	logic data_7, data_6, data_5, data_4, data_3, data_2, data_1, data_0;
} FormalSlicedData1;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_SIZE_2:0]
		data_3, data_2, data_1, data_0;
} FormalSlicedData2;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_SIZE_4:0] data_1, data_0;
} FormalSlicedData4;

typedef struct packed
{
	logic [`MSB_POS__SNOW64_SIZE_8:0] data_0;
} FormalSlicedData8;
`endif		// FORMAL

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


//// Probably only used by the vector multipliers.
//typedef struct packed
//{
//	logic [`MSB_POS__SNOW64_SIZE_16:0]
//		data_7, data_6, data_5, data_4, data_3, data_2, data_1, data_0;
//} DoubleSlicedData16;
//typedef struct packed
//{
//	logic [`MSB_POS__SNOW64_SIZE_32:0] data_3, data_2, data_1, data_0;
//} DoubleSlicedData32;
//typedef struct packed
//{
//	logic [`MSB_POS__SNOW64_SIZE_64:0] data_1, data_0;
//} DoubleSlicedData64;


endpackage : PkgSnow64SlicedData
