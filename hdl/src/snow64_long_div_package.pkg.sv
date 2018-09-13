`include "src/snow64_long_div_u16_by_u8_defines.header.sv"

package PkgSnow64LongDiv;

//typedef enum logic [`MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_OUT_DATA:0]
//{
//	StIdle,
//	StWorking,
//	StEnding
//} State;

typedef struct packed
{
	logic start;
	logic [`MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_IN_A:0] a;
	logic [`MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_IN_B:0] b;
} PortIn_LongDivU16ByU8;

typedef struct packed
{
	logic valid, can_accept_cmd;
	logic [`MSB_POS__SNOW64_LONG_DIV_U16_BY_U8_OUT_DATA:0] data;
} PortOut_LongDivU16ByU8;

endpackage : PkgSnow64LongDiv
