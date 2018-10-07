`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_bfloat16_defines.header.sv"



// Integer vector casting module.
// 
// Used by the EX stage of the CPU pipeline to cast a whole LAR's data from
// one type to another to another.
// 
// Note that casting to/from BFloat16s is NOT done with this module.
module Snow64IntVectorCaster(input logic clk,
	input PkgSnow64Caster::PortIn_IntVectorCaster in,
	output PkgSnow64Caster::PortOut_IntVectorCaster out);


	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __in_to_cast = in.to_cast;
	wire __in_src_type_signedness = in.src_type_signedness;

	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__in_src_int_type_size = in.src_int_type_size,
		__in_dst_int_type_size = in.dst_int_type_size;
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __real_out_data;


	PkgSnow64SlicedData::SlicedLarData8 __sliced_8__in_to_cast;
	PkgSnow64SlicedData::SlicedLarData16 __sliced_16__in_to_cast;
	PkgSnow64SlicedData::SlicedLarData32 __sliced_32__in_to_cast;
	PkgSnow64SlicedData::SlicedLarData64 __sliced_64__in_to_cast;

	assign __sliced_8__in_to_cast = __in_to_cast;
	assign __sliced_16__in_to_cast = __in_to_cast;
	assign __sliced_32__in_to_cast = __in_to_cast;
	assign __sliced_64__in_to_cast = __in_to_cast;


	assign out.data = __real_out_data;

	`ifdef FORMAL
	localparam __ENUM__INT_TYPE_SIZE__8 = PkgSnow64Cpu::IntTypSz8;
	localparam __ENUM__INT_TYPE_SIZE__16 = PkgSnow64Cpu::IntTypSz16;
	localparam __ENUM__INT_TYPE_SIZE__32 = PkgSnow64Cpu::IntTypSz32;
	localparam __ENUM__INT_TYPE_SIZE__64 = PkgSnow64Cpu::IntTypSz64;

	`define FORMAL__PORT_IN_INT_SCALAR_CASTER(which) \
		__formal__in_int_scalar_caster_``which
	`define FORMAL__PORT_OUT_INT_SCALAR_CASTER(which) \
		__formal__out_int_scalar_caster_``which
	`define FORMAL__OUT_INT_SCALAR_CASTER__DATA(which) \
		__formal__out_int_scalar_caster__data_``which

	`define X(which) \
		PkgSnow64Caster::PortIn_IntScalarCaster \
			`FORMAL__PORT_IN_INT_SCALAR_CASTER(which); \
		PkgSnow64Caster::PortOut_IntScalarCaster \
			`FORMAL__PORT_OUT_INT_SCALAR_CASTER(which); \
		Snow64IntScalarCaster __formal__inst_int_scalar_caster_``which \
			(.clk(clk), .in(`FORMAL__PORT_IN_INT_SCALAR_CASTER(which)), \
			.out(`FORMAL__PORT_OUT_INT_SCALAR_CASTER(which))); \
		wire [`MSB_POS__SNOW64_SCALAR_DATA:0] \
			`FORMAL__OUT_INT_SCALAR_CASTER__DATA(which) \
			= `FORMAL__PORT_OUT_INT_SCALAR_CASTER(which).data; \
		always @(*) \
		begin \
			`FORMAL__PORT_IN_INT_SCALAR_CASTER(which).src_type_signedness \
				= __in_src_type_signedness; \
			`FORMAL__PORT_IN_INT_SCALAR_CASTER(which).src_int_type_size \
				= __in_src_int_type_size; \
			`FORMAL__PORT_IN_INT_SCALAR_CASTER(which).dst_int_type_size \
				= __in_dst_int_type_size; \
		end

	`X(0) `X(1) `X(2) `X(3)
	`X(4) `X(5) `X(6) `X(7)
	`X(8) `X(9) `X(10) `X(11)
	`X(12) `X(13) `X(14) `X(15)
	`X(16) `X(17) `X(18) `X(19)
	`X(20) `X(21) `X(22) `X(23)
	`X(24) `X(25) `X(26) `X(27)
	`X(28) `X(29) `X(30) `X(31)
	`undef X

	always @(*)
	begin
		case (__in_src_int_type_size)
		PkgSnow64Cpu::IntTypSz8:
		begin
			`define X(which) \
				`FORMAL__PORT_IN_INT_SCALAR_CASTER(which).to_cast \
					= __in_to_cast[which * 8 +: 8];
			`X(0) `X(1) `X(2) `X(3)
			`X(4) `X(5) `X(6) `X(7)
			`X(8) `X(9) `X(10) `X(11)
			`X(12) `X(13) `X(14) `X(15)
			`X(16) `X(17) `X(18) `X(19)
			`X(20) `X(21) `X(22) `X(23)
			`X(24) `X(25) `X(26) `X(27)
			`X(28) `X(29) `X(30) `X(31)
			`undef X
		end

		PkgSnow64Cpu::IntTypSz16:
		begin
			`define X(which) \
				`FORMAL__PORT_IN_INT_SCALAR_CASTER(which).to_cast \
					= __in_to_cast[which * 16 +: 16];
			`X(0) `X(1) `X(2) `X(3)
			`X(4) `X(5) `X(6) `X(7)
			`X(8) `X(9) `X(10) `X(11)
			`X(12) `X(13) `X(14) `X(15)
			`undef X

			`define X(which) \
				`FORMAL__PORT_IN_INT_SCALAR_CASTER(which).to_cast = 0;
			`X(16) `X(17) `X(18) `X(19)
			`X(20) `X(21) `X(22) `X(23)
			`X(24) `X(25) `X(26) `X(27)
			`X(28) `X(29) `X(30) `X(31)
			`undef X
		end

		PkgSnow64Cpu::IntTypSz32:
		begin
			`define X(which) \
				`FORMAL__PORT_IN_INT_SCALAR_CASTER(which).to_cast \
					= __in_to_cast[which * 32 +: 32];
			`X(0) `X(1) `X(2) `X(3)
			`X(4) `X(5) `X(6) `X(7)
			`undef X

			`define X(which) \
				`FORMAL__PORT_IN_INT_SCALAR_CASTER(which).to_cast = 0;
			`X(8) `X(9) `X(10) `X(11)
			`X(12) `X(13) `X(14) `X(15)
			`X(16) `X(17) `X(18) `X(19)
			`X(20) `X(21) `X(22) `X(23)
			`X(24) `X(25) `X(26) `X(27)
			`X(28) `X(29) `X(30) `X(31)
			`undef X
		end

		PkgSnow64Cpu::IntTypSz64:
		begin
			`define X(which) \
				`FORMAL__PORT_IN_INT_SCALAR_CASTER(which).to_cast \
					= __in_to_cast[which * 64 +: 64];
			`X(0) `X(1) `X(2) `X(3)
			`undef X

			`define X(which) \
				`FORMAL__PORT_IN_INT_SCALAR_CASTER(which).to_cast = 0;
			`X(4) `X(5) `X(6) `X(7)
			`X(8) `X(9) `X(10) `X(11)
			`X(12) `X(13) `X(14) `X(15)
			`X(16) `X(17) `X(18) `X(19)
			`X(20) `X(21) `X(22) `X(23)
			`X(24) `X(25) `X(26) `X(27)
			`X(28) `X(29) `X(30) `X(31)
			`undef X
		end
		endcase
	end

	`undef FORMAL__PORT_IN_INT_SCALAR_CASTER
	`undef FORMAL__PORT_OUT_INT_SCALAR_CASTER
	`undef FORMAL__OUT_INT_SCALAR_CASTER__DATA
	`endif		// FORMAL


	initial
	begin
		__real_out_data = 0;
	end

	always_ff @(posedge clk)
	begin
		case (__in_src_int_type_size)
		PkgSnow64Cpu::IntTypSz8:
		begin
			case (__in_dst_int_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				__real_out_data <= __in_to_cast;
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				case (__in_src_type_signedness)
				0:
				begin
					`define X(which) \
						__real_out_data[which * 16 +: 16] \
							<= `ZERO_EXTEND(16, 8, \
							__sliced_8__in_to_cast.data_``which);
					`X(0) `X(1) `X(2) `X(3)
					`X(4) `X(5) `X(6) `X(7)
					`X(8) `X(9) `X(10) `X(11)
					`X(12) `X(13) `X(14) `X(15)
					`undef X
				end

				1:
				begin
					`define X(which) \
						__real_out_data[which * 16 +: 16] \
							<= `SIGN_EXTEND(16, 8, \
							__sliced_8__in_to_cast.data_``which);
					`X(0) `X(1) `X(2) `X(3)
					`X(4) `X(5) `X(6) `X(7)
					`X(8) `X(9) `X(10) `X(11)
					`X(12) `X(13) `X(14) `X(15)
					`undef X
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				case (__in_src_type_signedness)
				0:
				begin
					`define X(which) \
						__real_out_data[which * 32 +: 32] \
							<= `ZERO_EXTEND(32, 8, \
							__sliced_8__in_to_cast.data_``which);
					`X(0) `X(1) `X(2) `X(3)
					`X(4) `X(5) `X(6) `X(7)
					`undef X
				end

				1:
				begin
					`define X(which) \
						__real_out_data[which * 32 +: 32] \
							<= `SIGN_EXTEND(32, 8, \
							__sliced_8__in_to_cast.data_``which);
					`X(0) `X(1) `X(2) `X(3)
					`X(4) `X(5) `X(6) `X(7)
					`undef X
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (__in_src_type_signedness)
				0:
				begin
					`define X(which) \
						__real_out_data[which * 64 +: 64] \
							<= `ZERO_EXTEND(64, 8, \
							__sliced_8__in_to_cast.data_``which);
					`X(0) `X(1) `X(2) `X(3)
					`undef X
				end

				1:
				begin
					`define X(which) \
						__real_out_data[which * 64 +: 64] \
							<= `SIGN_EXTEND(64, 8, \
							__sliced_8__in_to_cast.data_``which);
					`X(0) `X(1) `X(2) `X(3)
					`undef X
				end
				endcase
			end
			endcase
		end

		PkgSnow64Cpu::IntTypSz16:
		begin
			case (__in_dst_int_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				`define X(which) \
					__real_out_data[which * 8 +: 8] \
						<= __sliced_16__in_to_cast.data_``which \
						[`WIDTH2MP(8):0];
				`X(0) `X(1) `X(2) `X(3)
				`X(4) `X(5) `X(6) `X(7)
				`X(8) `X(9) `X(10) `X(11)
				`X(12) `X(13) `X(14) `X(15)
				`undef X

				`define X(which) \
					__real_out_data[which * 8 +: 8] <= 0;
				`X(16) `X(17) `X(18) `X(19)
				`X(20) `X(21) `X(22) `X(23)
				`X(24) `X(25) `X(26) `X(27)
				`X(28) `X(29) `X(30) `X(31)
				`undef X
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				__real_out_data <= __in_to_cast;
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				case (__in_src_type_signedness)
				0:
				begin
					`define X(which) \
						__real_out_data[which * 32 +: 32] \
							<= `ZERO_EXTEND(32, 16, \
							__sliced_16__in_to_cast.data_``which);
					`X(0) `X(1) `X(2) `X(3)
					`X(4) `X(5) `X(6) `X(7)
					`undef X
				end

				1:
				begin
					`define X(which) \
						__real_out_data[which * 32 +: 32] \
							<= `SIGN_EXTEND(32, 16, \
							__sliced_16__in_to_cast.data_``which);
					`X(0) `X(1) `X(2) `X(3)
					`X(4) `X(5) `X(6) `X(7)
					`undef X
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (__in_src_type_signedness)
				0:
				begin
					`define X(which) \
						__real_out_data[which * 64 +: 64] \
							<= `ZERO_EXTEND(64, 16, \
							__sliced_16__in_to_cast.data_``which);
					`X(0) `X(1) `X(2) `X(3)
					`undef X
				end

				1:
				begin
					`define X(which) \
						__real_out_data[which * 64 +: 64] \
							<= `SIGN_EXTEND(64, 16, \
							__sliced_16__in_to_cast.data_``which);
					`X(0) `X(1) `X(2) `X(3)
					`undef X
				end
				endcase
			end
			endcase
		end

		PkgSnow64Cpu::IntTypSz32:
		begin
			case (__in_dst_int_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				`define X(which) \
					__real_out_data[which * 8 +: 8] \
						<= __sliced_32__in_to_cast.data_``which \
						[`WIDTH2MP(8):0];
				`X(0) `X(1) `X(2) `X(3)
				`X(4) `X(5) `X(6) `X(7)
				`undef X

				`define X(which) \
					__real_out_data[which * 8 +: 8] <= 0;
				`X(8) `X(9) `X(10) `X(11)
				`X(12) `X(13) `X(14) `X(15)
				`X(16) `X(17) `X(18) `X(19)
				`X(20) `X(21) `X(22) `X(23)
				`X(24) `X(25) `X(26) `X(27)
				`X(28) `X(29) `X(30) `X(31)
				`undef X
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				`define X(which) \
					__real_out_data[which * 16 +: 16] \
						<= __sliced_32__in_to_cast.data_``which \
						[`WIDTH2MP(16):0];
				`X(0) `X(1) `X(2) `X(3)
				`X(4) `X(5) `X(6) `X(7)
				`undef X

				`define X(which) \
					__real_out_data[which * 16 +: 16] <= 0;
				`X(8) `X(9) `X(10) `X(11)
				`X(12) `X(13) `X(14) `X(15)
				`undef X
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				__real_out_data <= __in_to_cast;
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (__in_src_type_signedness)
				0:
				begin
					`define X(which) \
						__real_out_data[which * 64 +: 64] \
							<= `ZERO_EXTEND(64, 32, \
							__sliced_32__in_to_cast.data_``which);
					`X(0) `X(1) `X(2) `X(3)
					`undef X
				end

				1:
				begin
					`define X(which) \
						__real_out_data[which * 64 +: 64] \
							<= `SIGN_EXTEND(64, 32, \
							__sliced_32__in_to_cast.data_``which);
					`X(0) `X(1) `X(2) `X(3)
					`undef X
				end
				endcase
			end
			endcase
		end

		PkgSnow64Cpu::IntTypSz64:
		begin
			case (__in_dst_int_type_size)
			PkgSnow64Cpu::IntTypSz8:
			begin
				`define X(which) \
					__real_out_data[which * 8 +: 8] \
						<= __sliced_64__in_to_cast.data_``which \
						[`WIDTH2MP(8):0];
				`X(0) `X(1) `X(2) `X(3)
				`undef X

				`define X(which)  __real_out_data[which * 8 +: 8] <= 0;
				`X(4) `X(5) `X(6) `X(7)
				`X(8) `X(9) `X(10) `X(11)
				`X(12) `X(13) `X(14) `X(15)
				`X(16) `X(17) `X(18) `X(19)
				`X(20) `X(21) `X(22) `X(23)
				`X(24) `X(25) `X(26) `X(27)
				`X(28) `X(29) `X(30) `X(31)
				`undef X
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				`define X(which) \
					__real_out_data[which * 16 +: 16] \
						<= __sliced_64__in_to_cast.data_``which \
						[`WIDTH2MP(16):0];
				`X(0) `X(1) `X(2) `X(3)
				`undef X

				`define X(which) \
					__real_out_data[which * 16 +: 16] <= 0;
				`X(4) `X(5) `X(6) `X(7)
				`X(8) `X(9) `X(10) `X(11)
				`X(12) `X(13) `X(14) `X(15)
				`undef X
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				`define X(which) \
					__real_out_data[which * 32 +: 32] \
						<= __sliced_64__in_to_cast.data_``which \
						[`WIDTH2MP(32):0];
				`X(0) `X(1) `X(2) `X(3)
				`undef X

				`define X(which) __real_out_data[which * 32 +: 32] <= 0;
				`X(4) `X(5) `X(6) `X(7)
				`undef X
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				__real_out_data <= __in_to_cast;
			end
			endcase
		end
		endcase
	end

endmodule


// BFloat16 (to/from int) vector casting module.
module Snow64ToOrFromBFloat16VectorCaster(input logic clk,
	input PkgSnow64Caster::PortIn_ToOrFromBFloat16VectorCaster in,
	output PkgSnow64Caster::PortOut_ToOrFromBFloat16VectorCaster out);

	localparam __WIDTH__STATE = 2;
	localparam __MSB_POS__STATE = `WIDTH2MP(__WIDTH__STATE);

	enum logic [__MSB_POS__STATE:0]
	{
		StIdle,
		StWaitForCastFromInt,
		StWaitForCastToInt,
		StBad
	} __state;

	wire __in_start = in.start;
	wire __in_from_int_or_to_int = in.from_int_or_to_int;
	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __in_to_cast = in.to_cast;
	wire __in_type_signedness = in.type_signedness;
	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0] __in_int_type_size
		= in.int_type_size;

	PkgSnow64SlicedData::SlicedLarData8 __sliced_8__in_to_cast;
	PkgSnow64SlicedData::SlicedLarData16 __sliced_16__in_to_cast;
	PkgSnow64SlicedData::SlicedLarData32 __sliced_32__in_to_cast;
	PkgSnow64SlicedData::SlicedLarData64 __sliced_64__in_to_cast;

	assign __sliced_8__in_to_cast = __in_to_cast;
	assign __sliced_16__in_to_cast = __in_to_cast;
	assign __sliced_32__in_to_cast = __in_to_cast;
	assign __sliced_64__in_to_cast = __in_to_cast;

	logic __real_out_valid;
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __real_out_data;

	logic [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__captured_in_int_type_size;


	`ifdef FORMAL
	localparam __ENUM__STATE__IDLE = StIdle;
	localparam __ENUM__STATE__WAIT_FOR_CAST_FROM_INT
		= StWaitForCastFromInt;
	localparam __ENUM__STATE__WAIT_FOR_CAST_TO_INT = StWaitForCastToInt;
	localparam __ENUM__STATE__BAD = StBad;

	localparam __ENUM__INT_TYPE_SIZE__8 = PkgSnow64Cpu::IntTypSz8;
	localparam __ENUM__INT_TYPE_SIZE__16 = PkgSnow64Cpu::IntTypSz16;
	localparam __ENUM__INT_TYPE_SIZE__32 = PkgSnow64Cpu::IntTypSz32;
	localparam __ENUM__INT_TYPE_SIZE__64 = PkgSnow64Cpu::IntTypSz64;
	`endif		// FORMAL


	`define OPERATE_ON_ALL_PORTS \
		`X(0) `X(1) `X(2) `X(3) `X(4) `X(5) `X(6) `X(7) \
		`X(8) `X(9) `X(10) `X(11) `X(12) `X(13) `X(14) `X(15)

	`define OPERATE_ON_CAST_FROM_INT_PORTS_8 \
		`X(0) `X(1) `X(2) `X(3) `X(4) `X(5) `X(6) `X(7) \
		`X(8) `X(9) `X(10) `X(11) `X(12) `X(13) `X(14) `X(15)

	`define OPERATE_ON_CAST_FROM_INT_PORTS_16 \
		`X(0) `X(1) `X(2) `X(3) `X(4) `X(5) `X(6) `X(7) \
		`X(8) `X(9) `X(10) `X(11) `X(12) `X(13) `X(14) `X(15)

	`define OPERATE_ON_CAST_FROM_INT_PORTS_32 \
		`X(0) `X(1) `X(2) `X(3) `X(4) `X(5) `X(6) `X(7)

	`define OPERATE_ON_CAST_FROM_INT_PORTS_64 \
		`X(0) `X(1) `X(2) `X(3)



	`define PORT_IN_CAST_FROM_INT(which) __in_cast_from_int_``which
	`define PORT_OUT_CAST_FROM_INT(which) __out_cast_from_int_``which
	`define PORT_IN_CAST_TO_INT(which) __in_cast_to_int_``which
	`define PORT_OUT_CAST_TO_INT(which) __out_cast_to_int_``which

	`define X(which) \
		PkgSnow64BFloat16::PortIn_CastFromInt \
			`PORT_IN_CAST_FROM_INT(which); \
		PkgSnow64BFloat16::PortOut_CastFromInt \
			`PORT_OUT_CAST_FROM_INT(which); \
		Snow64BFloat16CastFromInt __inst_cast_from_int_``which \
			(.clk(clk), .in(`PORT_IN_CAST_FROM_INT(which)), \
			.out(`PORT_OUT_CAST_FROM_INT(which)));
	`OPERATE_ON_ALL_PORTS
	`undef X


	`define X(which) \
		PkgSnow64BFloat16::PortIn_CastToInt \
			`PORT_IN_CAST_TO_INT(which); \
		PkgSnow64BFloat16::PortOut_CastToInt \
			`PORT_OUT_CAST_TO_INT(which); \
		Snow64BFloat16CastToInt __inst_cast_to_int_``which \
			(.clk(clk), .in(`PORT_IN_CAST_TO_INT(which)), \
			.out(`PORT_OUT_CAST_TO_INT(which)));
	`OPERATE_ON_ALL_PORTS
	`undef X




	initial
	begin
		__state = StIdle;
		__real_out_valid = 1'b0;
		__real_out_data = 1'b0;
		__captured_in_int_type_size = 1'b0;
	end

	always_ff @(posedge clk)
	begin
		case (__state)
		StIdle:
		begin
			__real_out_valid <= 1'b0;

			if (__in_start)
			begin
				case (__in_from_int_or_to_int)
				0:
				begin
					__state <= StWaitForCastFromInt;

					`define X(which) \
						{`PORT_IN_CAST_FROM_INT(which).int_type_size, \
							`PORT_IN_CAST_FROM_INT(which) \
							.type_signedness} \
							<= {__in_int_type_size, __in_type_signedness};
					`OPERATE_ON_ALL_PORTS
					`undef X

					case (__in_int_type_size)
					PkgSnow64Cpu::IntTypSz8:
					begin
						`define X(which) \
							{`PORT_IN_CAST_FROM_INT(which).start, \
								`PORT_IN_CAST_FROM_INT(which).to_cast} \
								<= {1'b1, `ZERO_EXTEND(64, 8, \
								__sliced_8__in_to_cast.data_``which)};
						`OPERATE_ON_CAST_FROM_INT_PORTS_8
						`undef X
					end

					PkgSnow64Cpu::IntTypSz16:
					begin
						`define X(which) \
							{`PORT_IN_CAST_FROM_INT(which).start, \
								`PORT_IN_CAST_FROM_INT(which).to_cast} \
								<= {1'b1, `ZERO_EXTEND(64, 16, \
								__sliced_16__in_to_cast.data_``which)};
						`OPERATE_ON_CAST_FROM_INT_PORTS_16
						`undef X
					end

					PkgSnow64Cpu::IntTypSz32:
					begin
						`define X(which) \
							{`PORT_IN_CAST_FROM_INT(which).start, \
								`PORT_IN_CAST_FROM_INT(which).to_cast} \
								<= {1'b1, `ZERO_EXTEND(64, 32, \
								__sliced_32__in_to_cast.data_``which)};
						`OPERATE_ON_CAST_FROM_INT_PORTS_32
						`undef X
					end

					PkgSnow64Cpu::IntTypSz64:
					begin
						`define X(which) \
							{`PORT_IN_CAST_FROM_INT(which).start, \
								`PORT_IN_CAST_FROM_INT(which).to_cast} \
								<= {1'b1, \
								__sliced_64__in_to_cast.data_``which};
						`OPERATE_ON_CAST_FROM_INT_PORTS_64
						`undef X
					end
					endcase
				end

				1:
				begin
					__state <= StWaitForCastToInt;
					__captured_in_int_type_size <= __in_int_type_size;

					`define X(which) \
						`PORT_IN_CAST_TO_INT(which) \
							<= {1'b1, \
							__sliced_16__in_to_cast.data_``which, \
							__in_int_type_size, __in_type_signedness};
					`OPERATE_ON_ALL_PORTS
					`undef X
				end
				endcase
			end
		end

		StWaitForCastFromInt:
		begin
			`define X(which) `PORT_IN_CAST_FROM_INT(which).start <= 1'b0;
			`OPERATE_ON_ALL_PORTS
			`undef X

			// As the individual cast units are all identical (and run at
			// the same clock rate), they will all finish at the same time.
			if (`PORT_OUT_CAST_FROM_INT(0).valid)
			begin
				__state <= StIdle;
				__real_out_valid <= 1'b1;

				`define X(which) \
				__real_out_data[which * 16 +: 16] \
					<= `PORT_OUT_CAST_FROM_INT(which).data;
				`OPERATE_ON_ALL_PORTS
				`undef X
			end
		end

		StWaitForCastToInt:
		begin
			`define X(which) `PORT_IN_CAST_TO_INT(which).start <= 1'b0;
			`OPERATE_ON_ALL_PORTS
			`undef X

			// As the individual cast units are all identical (and run at
			// the same clock rate), they will all finish at the same time.
			if (`PORT_OUT_CAST_TO_INT(0).valid)
			begin
				__state <= StIdle;
				__real_out_valid <= 1'b1;

				case (__captured_in_int_type_size)
				PkgSnow64Cpu::IntTypSz8:
				begin
					`define X(which) \
						__real_out_data[which * 8 +: 8] \
							<= `PORT_OUT_CAST_TO_INT(which) \
							.data[`WIDTH2MP(8):0];
					`X(0) `X(1) `X(2) `X(3)
					`X(4) `X(5) `X(6) `X(7)
					`X(8) `X(9) `X(10) `X(11)
					`X(12) `X(13) `X(14) `X(15)
					`undef X

					`define X(which) \
						__real_out_data[which * 8 +: 8] <= 8'h0;
					`X(16) `X(17) `X(18) `X(19)
					`X(20) `X(21) `X(22) `X(23)
					`X(24) `X(25) `X(26) `X(27)
					`X(28) `X(29) `X(30) `X(31)
					`undef X
				end

				PkgSnow64Cpu::IntTypSz16:
				begin
					`define X(which) \
						__real_out_data[which * 16 +: 16] \
							<= `PORT_OUT_CAST_TO_INT(which) \
							.data[`WIDTH2MP(16):0];
					`X(0) `X(1) `X(2) `X(3)
					`X(4) `X(5) `X(6) `X(7)
					`X(8) `X(9) `X(10) `X(11)
					`X(12) `X(13) `X(14) `X(15)
					`undef X
				end

				PkgSnow64Cpu::IntTypSz32:
				begin
					`define X(which) \
						__real_out_data[which * 32 +: 32] \
							<= `PORT_OUT_CAST_TO_INT(which) \
							.data[`WIDTH2MP(32):0];
					`X(0) `X(1) `X(2) `X(3)
					`X(4) `X(5) `X(6) `X(7)
					`undef X
				end

				PkgSnow64Cpu::IntTypSz64:
				begin
					`define X(which) \
						__real_out_data[which * 64 +: 64] \
							<= `PORT_OUT_CAST_TO_INT(which) \
							.data[`WIDTH2MP(64):0];
					`X(0) `X(1) `X(2) `X(3)
					`undef X
				end
				endcase
			end
		end
		endcase
	end



	`undef OPERATE_ON_ALL_PORTS
	`undef OPERATE_ON_CAST_FROM_INT_PORTS_8
	`undef OPERATE_ON_CAST_FROM_INT_PORTS_16
	`undef OPERATE_ON_CAST_FROM_INT_PORTS_32
	`undef OPERATE_ON_CAST_FROM_INT_PORTS_64
	`undef PORT_IN_CAST_FROM_INT
	`undef PORT_OUT_CAST_FROM_INT
	`undef PORT_IN_CAST_TO_INT
	`undef PORT_OUT_CAST_TO_INT

endmodule
