`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_bfloat16_defines.header.sv"

// BFloat16 (to/from int) vector casting module.
module Snow64ToOrFromBFloat16VectorCaster(input logic clk,
	input PkgSnow64VectorCaster::PortIn_ToOrFromBFloat16VectorCaster in,
	output PkgSnow64VectorCaster::PortOut_ToOrFromBFloat16VectorCaster
		out);

	localparam __WIDTH__STATE = 2;
	localparam __MSB_POS__STATE = `WIDTH2MP(__WIDTH__STATE);

	enum logic [__MSB_POS__STATE:0]
	{
		StIdle,
		StWaitForCastFrom,
		StWaitForCastTo,
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
	localparam __ENUM__INT_TYPE_SIZE__8 = PkgSnow64Cpu::IntTypSz8;
	localparam __ENUM__INT_TYPE_SIZE__16 = PkgSnow64Cpu::IntTypSz16;
	localparam __ENUM__INT_TYPE_SIZE__32 = PkgSnow64Cpu::IntTypSz32;
	localparam __ENUM__INT_TYPE_SIZE__64 = PkgSnow64Cpu::IntTypSz64;
	`endif		// FORMAL


	`define OPERATE_ON_CAST_FROM_INT_ALL_PORTS \
		`X(0) `X(1) `X(2) `X(3) `X(4) `X(5) `X(6) `X(7) \
		`X(8) `X(9) `X(10) `X(11) `X(12) `X(13) `X(14) `X(15) \
		`X(16) `X(17) `X(18) `X(19) `X(20) `X(21) `X(22) `X(23) \
		`X(24) `X(25) `X(26) `X(27) `X(28) `X(29) `X(30) `X(31)

	`define OPERATE_ON_CAST_FROM_INT_PORTS_8 \
		`X(0) `X(1) `X(2) `X(3) `X(4) `X(5) `X(6) `X(7) \
		`X(8) `X(9) `X(10) `X(11) `X(12) `X(13) `X(14) `X(15) \
		`X(16) `X(17) `X(18) `X(19) `X(20) `X(21) `X(22) `X(23) \
		`X(24) `X(25) `X(26) `X(27) `X(28) `X(29) `X(30) `X(31)

	`define OPERATE_ON_CAST_FROM_INT_PORTS_16 \
		`X(0) `X(1) `X(2) `X(3) `X(4) `X(5) `X(6) `X(7) \
		`X(8) `X(9) `X(10) `X(11) `X(12) `X(13) `X(14) `X(15)

	`define OPERATE_ON_CAST_FROM_INT_PORTS_32 \
		`X(0) `X(1) `X(2) `X(3) `X(4) `X(5) `X(6) `X(7)

	`define OPERATE_ON_CAST_FROM_INT_PORTS_64 \
		`X(0) `X(1) `X(2) `X(3)


	`define OPERATE_ON_CAST_TO_INT_PORTS \
		`X(0) `X(1) `X(2) `X(3) `X(4) `X(5) `X(6) `X(7) \
		`X(8) `X(9) `X(10) `X(11) `X(12) `X(13) `X(14) `X(15)



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
	`OPERATE_ON_CAST_FROM_INT_ALL_PORTS
	`undef X


	`define X(which) \
		PkgSnow64BFloat16::PortIn_CastToInt \
			`PORT_IN_CAST_TO_INT(which); \
		PkgSnow64BFloat16::PortOut_CastToInt \
			`PORT_OUT_CAST_TO_INT(which); \
		Snow64BFloat16CastToInt __inst_cast_to_int_``which \
			(.clk(clk), .in(`PORT_IN_CAST_TO_INT(which)), \
			.out(`PORT_OUT_CAST_TO_INT(which)));
	`OPERATE_ON_CAST_TO_INT_PORTS
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
					__state <= StWaitForCastFrom;

					case (__in_int_type_size)
					PkgSnow64Cpu::IntTypSz8:
					begin
						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).start <= 1'b1;
						`OPERATE_ON_CAST_FROM_INT_PORTS_8
						`undef X

						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).int_type_size \
								<= __in_int_type_size;
						`OPERATE_ON_CAST_FROM_INT_PORTS_8
						`undef X

						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).type_signedness \
								<= __in_type_signedness;
						`OPERATE_ON_CAST_FROM_INT_PORTS_8
						`undef X

						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).to_cast \
								<= __sliced_8__in_to_cast.data_``which;
						`OPERATE_ON_CAST_FROM_INT_PORTS_8
						`undef X
					end

					PkgSnow64Cpu::IntTypSz16:
					begin
						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).start <= 1'b1;
						`OPERATE_ON_CAST_FROM_INT_PORTS_16
						`undef X

						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).int_type_size \
								<= __in_int_type_size;
						`OPERATE_ON_CAST_FROM_INT_PORTS_16
						`undef X

						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).type_signedness \
								<= __in_type_signedness;
						`OPERATE_ON_CAST_FROM_INT_PORTS_16
						`undef X

						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).to_cast \
								<= __sliced_16__in_to_cast.data_``which;
						`OPERATE_ON_CAST_FROM_INT_PORTS_16
						`undef X
					end

					PkgSnow64Cpu::IntTypSz32:
					begin
						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).start <= 1'b1;
						`OPERATE_ON_CAST_FROM_INT_PORTS_32
						`undef X

						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).int_type_size \
								<= __in_int_type_size;
						`OPERATE_ON_CAST_FROM_INT_PORTS_32
						`undef X

						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).type_signedness \
								<= __in_type_signedness;
						`OPERATE_ON_CAST_FROM_INT_PORTS_32
						`undef X

						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).to_cast \
								<= __sliced_32__in_to_cast.data_``which;
						`OPERATE_ON_CAST_FROM_INT_PORTS_32
						`undef X
					end

					PkgSnow64Cpu::IntTypSz64:
					begin
						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).start <= 1'b1;
						`OPERATE_ON_CAST_FROM_INT_PORTS_64
						`undef X

						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).int_type_size \
								<= __in_int_type_size;
						`OPERATE_ON_CAST_FROM_INT_PORTS_64
						`undef X

						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).type_signedness \
								<= __in_type_signedness;
						`OPERATE_ON_CAST_FROM_INT_PORTS_64
						`undef X

						`define X(which) \
							`PORT_IN_CAST_FROM_INT(which).to_cast \
								<= __sliced_64__in_to_cast.data_``which;
						`OPERATE_ON_CAST_FROM_INT_PORTS_64
						`undef X
					end
					endcase
				end

				1:
				begin
					__state <= StWaitForCastTo;
					__captured_in_int_type_size <= __in_int_type_size;

					`define X(which) \
						`PORT_IN_CAST_TO_INT(which).start <= 1'b1;
					`OPERATE_ON_CAST_TO_INT_PORTS
					`undef X

					`define X(which) \
						`PORT_IN_CAST_TO_INT(which).int_type_size \
							<= __in_int_type_size;
					`OPERATE_ON_CAST_TO_INT_PORTS
					`undef X

					`define X(which) \
						`PORT_IN_CAST_TO_INT(which).type_signedness \
							<= __in_type_signedness;
					`OPERATE_ON_CAST_TO_INT_PORTS
					`undef X

					`define X(which) \
						`PORT_IN_CAST_TO_INT(which).to_cast \
							<= __sliced_16__in_to_cast.data_``which;
					`OPERATE_ON_CAST_TO_INT_PORTS
					`undef X
				end
				endcase
			end
		end

		StWaitForCastFrom:
		begin
			`define X(which) `PORT_IN_CAST_FROM_INT(which).start <= 1'b0;
			`OPERATE_ON_CAST_FROM_INT_ALL_PORTS
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
				`OPERATE_ON_CAST_FROM_INT_ALL_PORTS
				`undef X
			end
		end

		StWaitForCastTo:
		begin
			`define X(which) `PORT_IN_CAST_TO_INT(which).start <= 1'b0;
			`OPERATE_ON_CAST_TO_INT_PORTS
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
					__real_out_data[0 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(0).data[`WIDTH2MP(8):0];
					__real_out_data[1 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(1).data[`WIDTH2MP(8):0];
					__real_out_data[2 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(2).data[`WIDTH2MP(8):0];
					__real_out_data[3 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(3).data[`WIDTH2MP(8):0];
					__real_out_data[4 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(4).data[`WIDTH2MP(8):0];
					__real_out_data[5 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(5).data[`WIDTH2MP(8):0];
					__real_out_data[6 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(6).data[`WIDTH2MP(8):0];
					__real_out_data[7 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(7).data[`WIDTH2MP(8):0];
					__real_out_data[8 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(8).data[`WIDTH2MP(8):0];
					__real_out_data[9 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(9).data[`WIDTH2MP(8):0];
					__real_out_data[10 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(10).data[`WIDTH2MP(8):0];
					__real_out_data[11 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(11).data[`WIDTH2MP(8):0];
					__real_out_data[12 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(12).data[`WIDTH2MP(8):0];
					__real_out_data[13 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(13).data[`WIDTH2MP(8):0];
					__real_out_data[14 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(14).data[`WIDTH2MP(8):0];
					__real_out_data[15 * 8 +: 8]
						<= `PORT_OUT_CAST_TO_INT(15).data[`WIDTH2MP(8):0];
					__real_out_data[16 * 8 +: 8] <= 8'h0;
					__real_out_data[17 * 8 +: 8] <= 8'h0;
					__real_out_data[18 * 8 +: 8] <= 8'h0;
					__real_out_data[19 * 8 +: 8] <= 8'h0;
					__real_out_data[20 * 8 +: 8] <= 8'h0;
					__real_out_data[21 * 8 +: 8] <= 8'h0;
					__real_out_data[22 * 8 +: 8] <= 8'h0;
					__real_out_data[23 * 8 +: 8] <= 8'h0;
					__real_out_data[24 * 8 +: 8] <= 8'h0;
					__real_out_data[25 * 8 +: 8] <= 8'h0;
					__real_out_data[26 * 8 +: 8] <= 8'h0;
					__real_out_data[27 * 8 +: 8] <= 8'h0;
					__real_out_data[28 * 8 +: 8] <= 8'h0;
					__real_out_data[29 * 8 +: 8] <= 8'h0;
					__real_out_data[30 * 8 +: 8] <= 8'h0;
					__real_out_data[31 * 8 +: 8] <= 8'h0;
				end

				PkgSnow64Cpu::IntTypSz16:
				begin
					__real_out_data[0 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(0)
						.data[`WIDTH2MP(16):0];
					__real_out_data[1 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(1)
						.data[`WIDTH2MP(16):0];
					__real_out_data[2 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(2)
						.data[`WIDTH2MP(16):0];
					__real_out_data[3 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(3)
						.data[`WIDTH2MP(16):0];
					__real_out_data[4 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(4)
						.data[`WIDTH2MP(16):0];
					__real_out_data[5 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(5)
						.data[`WIDTH2MP(16):0];
					__real_out_data[6 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(6)
						.data[`WIDTH2MP(16):0];
					__real_out_data[7 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(7)
						.data[`WIDTH2MP(16):0];
					__real_out_data[8 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(8)
						.data[`WIDTH2MP(16):0];
					__real_out_data[9 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(9)
						.data[`WIDTH2MP(16):0];
					__real_out_data[10 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(10)
						.data[`WIDTH2MP(16):0];
					__real_out_data[11 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(11)
						.data[`WIDTH2MP(16):0];
					__real_out_data[12 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(12)
						.data[`WIDTH2MP(16):0];
					__real_out_data[13 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(13)
						.data[`WIDTH2MP(16):0];
					__real_out_data[14 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(14)
						.data[`WIDTH2MP(16):0];
					__real_out_data[15 * 16 +: 16]
						<= `PORT_OUT_CAST_TO_INT(15)
						.data[`WIDTH2MP(16):0];
				end

				PkgSnow64Cpu::IntTypSz32:
				begin
					__real_out_data[0 * 32 +: 32]
						<= `PORT_OUT_CAST_TO_INT(0)
						.data[`WIDTH2MP(32):0];
					__real_out_data[1 * 32 +: 32]
						<= `PORT_OUT_CAST_TO_INT(1)
						.data[`WIDTH2MP(32):0];
					__real_out_data[2 * 32 +: 32]
						<= `PORT_OUT_CAST_TO_INT(2)
						.data[`WIDTH2MP(32):0];
					__real_out_data[3 * 32 +: 32]
						<= `PORT_OUT_CAST_TO_INT(3)
						.data[`WIDTH2MP(32):0];
					__real_out_data[4 * 32 +: 32]
						<= `PORT_OUT_CAST_TO_INT(4)
						.data[`WIDTH2MP(32):0];
					__real_out_data[5 * 32 +: 32]
						<= `PORT_OUT_CAST_TO_INT(5)
						.data[`WIDTH2MP(32):0];
					__real_out_data[6 * 32 +: 32]
						<= `PORT_OUT_CAST_TO_INT(6)
						.data[`WIDTH2MP(32):0];
					__real_out_data[7 * 32 +: 32]
						<= `PORT_OUT_CAST_TO_INT(7)
						.data[`WIDTH2MP(32):0];
				end

				PkgSnow64Cpu::IntTypSz64:
				begin
					__real_out_data[0 * 64 +: 64]
						<= `PORT_OUT_CAST_TO_INT(0)
						.data[`WIDTH2MP(64):0];
					__real_out_data[1 * 64 +: 64]
						<= `PORT_OUT_CAST_TO_INT(1)
						.data[`WIDTH2MP(64):0];
					__real_out_data[2 * 64 +: 64]
						<= `PORT_OUT_CAST_TO_INT(2)
						.data[`WIDTH2MP(64):0];
					__real_out_data[3 * 64 +: 64]
						<= `PORT_OUT_CAST_TO_INT(3)
						.data[`WIDTH2MP(64):0];
				end
				endcase
			end
		end
		endcase
	end



	`undef OPERATE_ON_CAST_FROM_INT_ALL_PORTS
	`undef OPERATE_ON_CAST_FROM_INT_PORTS_8
	`undef OPERATE_ON_CAST_FROM_INT_PORTS_16
	`undef OPERATE_ON_CAST_FROM_INT_PORTS_32
	`undef OPERATE_ON_CAST_FROM_INT_PORTS_64
	`undef OPERATE_ON_CAST_TO_INT_PORTS
	`undef PORT_IN_CAST_FROM_INT
	`undef PORT_OUT_CAST_FROM_INT
	`undef PORT_IN_CAST_TO_INT
	`undef PORT_OUT_CAST_TO_INT

endmodule

// Integer vector casting module.
// 
// Used by the EX stage of the CPU pipeline to cast from one integer type
// to another.
// 
// Note that casting to/from BFloat16s is NOT done with this module.
module Snow64IntVectorCaster(input logic clk,
	input PkgSnow64VectorCaster::PortIn_IntVectorCaster in,
	output PkgSnow64VectorCaster::PortOut_IntVectorCaster out);


	wire [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __in_to_cast = in.to_cast;
	wire __in_src_type_signedness = in.src_type_signedness;

	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__in_src_int_type_size = in.src_int_type_size,
		__in_dst_int_type_size = in.dst_int_type_size;
	logic [`MSB_POS__SNOW64_LAR_FILE_DATA:0] __real_out_data;


	`ifdef FORMAL
	localparam __ENUM__INT_TYPE_SIZE__8 = PkgSnow64Cpu::IntTypSz8;
	localparam __ENUM__INT_TYPE_SIZE__16 = PkgSnow64Cpu::IntTypSz16;
	localparam __ENUM__INT_TYPE_SIZE__32 = PkgSnow64Cpu::IntTypSz32;
	localparam __ENUM__INT_TYPE_SIZE__64 = PkgSnow64Cpu::IntTypSz64;
	`endif		// FORMAL

	PkgSnow64SlicedData::SlicedLarData8 __sliced_8__in_to_cast;
	PkgSnow64SlicedData::SlicedLarData16 __sliced_16__in_to_cast;
	PkgSnow64SlicedData::SlicedLarData32 __sliced_32__in_to_cast;
	PkgSnow64SlicedData::SlicedLarData64 __sliced_64__in_to_cast;

	assign __sliced_8__in_to_cast = __in_to_cast;
	assign __sliced_16__in_to_cast = __in_to_cast;
	assign __sliced_32__in_to_cast = __in_to_cast;
	assign __sliced_64__in_to_cast = __in_to_cast;



	initial
	begin
		__real_out_data = 0;
	end

	assign out.data = __real_out_data;

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
					__real_out_data[0 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_0);
					__real_out_data[1 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_1);
					__real_out_data[2 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_2);
					__real_out_data[3 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_3);
					__real_out_data[4 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_4);
					__real_out_data[5 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_5);
					__real_out_data[6 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_6);
					__real_out_data[7 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_7);
					__real_out_data[8 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_8);
					__real_out_data[9 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_9);
					__real_out_data[10 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_10);
					__real_out_data[11 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_11);
					__real_out_data[12 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_12);
					__real_out_data[13 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_13);
					__real_out_data[14 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_14);
					__real_out_data[15 * 16 +: 16]
						<= `ZERO_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_15);
				end

				1:
				begin
					__real_out_data[0 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_0);
					__real_out_data[1 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_1);
					__real_out_data[2 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_2);
					__real_out_data[3 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_3);
					__real_out_data[4 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_4);
					__real_out_data[5 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_5);
					__real_out_data[6 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_6);
					__real_out_data[7 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_7);
					__real_out_data[8 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_8);
					__real_out_data[9 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_9);
					__real_out_data[10 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_10);
					__real_out_data[11 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_11);
					__real_out_data[12 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_12);
					__real_out_data[13 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_13);
					__real_out_data[14 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_14);
					__real_out_data[15 * 16 +: 16]
						<= `SIGN_EXTEND(16, 8,
						__sliced_8__in_to_cast.data_15);
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				case (__in_src_type_signedness)
				0:
				begin
					__real_out_data[0 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_0);
					__real_out_data[1 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_1);
					__real_out_data[2 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_2);
					__real_out_data[3 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_3);
					__real_out_data[4 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_4);
					__real_out_data[5 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_5);
					__real_out_data[6 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_6);
					__real_out_data[7 * 32 +: 32]
						<= `ZERO_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_7);
				end

				1:
				begin
					__real_out_data[0 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_0);
					__real_out_data[1 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_1);
					__real_out_data[2 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_2);
					__real_out_data[3 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_3);
					__real_out_data[4 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_4);
					__real_out_data[5 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_5);
					__real_out_data[6 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_6);
					__real_out_data[7 * 32 +: 32]
						<= `SIGN_EXTEND(32, 8,
						__sliced_8__in_to_cast.data_7);
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (__in_src_type_signedness)
				0:
				begin
					__real_out_data[0 * 64 +: 64]
						<= `ZERO_EXTEND(64, 8,
						__sliced_8__in_to_cast.data_0);
					__real_out_data[1 * 64 +: 64]
						<= `ZERO_EXTEND(64, 8,
						__sliced_8__in_to_cast.data_1);
					__real_out_data[2 * 64 +: 64]
						<= `ZERO_EXTEND(64, 8,
						__sliced_8__in_to_cast.data_2);
					__real_out_data[3 * 64 +: 64]
						<= `ZERO_EXTEND(64, 8,
						__sliced_8__in_to_cast.data_3);
				end

				1:
				begin
					__real_out_data[0 * 64 +: 64]
						<= `SIGN_EXTEND(64, 8,
						__sliced_8__in_to_cast.data_0);
					__real_out_data[1 * 64 +: 64]
						<= `SIGN_EXTEND(64, 8,
						__sliced_8__in_to_cast.data_1);
					__real_out_data[2 * 64 +: 64]
						<= `SIGN_EXTEND(64, 8,
						__sliced_8__in_to_cast.data_2);
					__real_out_data[3 * 64 +: 64]
						<= `SIGN_EXTEND(64, 8,
						__sliced_8__in_to_cast.data_3);
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
				__real_out_data[0 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_0[`WIDTH2MP(8):0];
				__real_out_data[1 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_1[`WIDTH2MP(8):0];
				__real_out_data[2 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_2[`WIDTH2MP(8):0];
				__real_out_data[3 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_3[`WIDTH2MP(8):0];
				__real_out_data[4 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_4[`WIDTH2MP(8):0];
				__real_out_data[5 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_5[`WIDTH2MP(8):0];
				__real_out_data[6 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_6[`WIDTH2MP(8):0];
				__real_out_data[7 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_7[`WIDTH2MP(8):0];
				__real_out_data[8 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_8[`WIDTH2MP(8):0];
				__real_out_data[9 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_9[`WIDTH2MP(8):0];
				__real_out_data[10 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_10[`WIDTH2MP(8):0];
				__real_out_data[11 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_11[`WIDTH2MP(8):0];
				__real_out_data[12 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_12[`WIDTH2MP(8):0];
				__real_out_data[13 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_13[`WIDTH2MP(8):0];
				__real_out_data[14 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_14[`WIDTH2MP(8):0];
				__real_out_data[15 * 8 +: 8]
					<= __sliced_16__in_to_cast.data_15[`WIDTH2MP(8):0];
				__real_out_data[16 * 8 +: 8] <= 0;
				__real_out_data[17 * 8 +: 8] <= 0;
				__real_out_data[18 * 8 +: 8] <= 0;
				__real_out_data[19 * 8 +: 8] <= 0;
				__real_out_data[20 * 8 +: 8] <= 0;
				__real_out_data[21 * 8 +: 8] <= 0;
				__real_out_data[22 * 8 +: 8] <= 0;
				__real_out_data[23 * 8 +: 8] <= 0;
				__real_out_data[24 * 8 +: 8] <= 0;
				__real_out_data[25 * 8 +: 8] <= 0;
				__real_out_data[26 * 8 +: 8] <= 0;
				__real_out_data[27 * 8 +: 8] <= 0;
				__real_out_data[28 * 8 +: 8] <= 0;
				__real_out_data[29 * 8 +: 8] <= 0;
				__real_out_data[30 * 8 +: 8] <= 0;
				__real_out_data[31 * 8 +: 8] <= 0;
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
					__real_out_data[0 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_0);
					__real_out_data[1 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_1);
					__real_out_data[2 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_2);
					__real_out_data[3 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_3);
					__real_out_data[4 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_4);
					__real_out_data[5 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_5);
					__real_out_data[6 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_6);
					__real_out_data[7 * 32 +: 32]
						<= `ZERO_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_7);
				end

				1:
				begin
					__real_out_data[0 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_0);
					__real_out_data[1 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_1);
					__real_out_data[2 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_2);
					__real_out_data[3 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_3);
					__real_out_data[4 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_4);
					__real_out_data[5 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_5);
					__real_out_data[6 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_6);
					__real_out_data[7 * 32 +: 32]
						<= `SIGN_EXTEND(32, 16,
						__sliced_16__in_to_cast.data_7);
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (__in_src_type_signedness)
				0:
				begin
					__real_out_data[0 * 64 +: 64]
						<= `ZERO_EXTEND(64, 16,
						__sliced_16__in_to_cast.data_0);
					__real_out_data[1 * 64 +: 64]
						<= `ZERO_EXTEND(64, 16,
						__sliced_16__in_to_cast.data_1);
					__real_out_data[2 * 64 +: 64]
						<= `ZERO_EXTEND(64, 16,
						__sliced_16__in_to_cast.data_2);
					__real_out_data[3 * 64 +: 64]
						<= `ZERO_EXTEND(64, 16,
						__sliced_16__in_to_cast.data_3);
				end

				1:
				begin
					__real_out_data[0 * 64 +: 64]
						<= `SIGN_EXTEND(64, 16,
						__sliced_16__in_to_cast.data_0);
					__real_out_data[1 * 64 +: 64]
						<= `SIGN_EXTEND(64, 16,
						__sliced_16__in_to_cast.data_1);
					__real_out_data[2 * 64 +: 64]
						<= `SIGN_EXTEND(64, 16,
						__sliced_16__in_to_cast.data_2);
					__real_out_data[3 * 64 +: 64]
						<= `SIGN_EXTEND(64, 16,
						__sliced_16__in_to_cast.data_3);
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
				__real_out_data[0 * 8 +: 8]
					<= __sliced_32__in_to_cast.data_0[`WIDTH2MP(8):0];
				__real_out_data[1 * 8 +: 8]
					<= __sliced_32__in_to_cast.data_1[`WIDTH2MP(8):0];
				__real_out_data[2 * 8 +: 8]
					<= __sliced_32__in_to_cast.data_2[`WIDTH2MP(8):0];
				__real_out_data[3 * 8 +: 8]
					<= __sliced_32__in_to_cast.data_3[`WIDTH2MP(8):0];
				__real_out_data[4 * 8 +: 8]
					<= __sliced_32__in_to_cast.data_4[`WIDTH2MP(8):0];
				__real_out_data[5 * 8 +: 8]
					<= __sliced_32__in_to_cast.data_5[`WIDTH2MP(8):0];
				__real_out_data[6 * 8 +: 8]
					<= __sliced_32__in_to_cast.data_6[`WIDTH2MP(8):0];
				__real_out_data[7 * 8 +: 8]
					<= __sliced_32__in_to_cast.data_7[`WIDTH2MP(8):0];
				__real_out_data[8 * 8 +: 8] <= 0;
				__real_out_data[9 * 8 +: 8] <= 0;
				__real_out_data[10 * 8 +: 8] <= 0;
				__real_out_data[11 * 8 +: 8] <= 0;
				__real_out_data[12 * 8 +: 8] <= 0;
				__real_out_data[13 * 8 +: 8] <= 0;
				__real_out_data[14 * 8 +: 8] <= 0;
				__real_out_data[15 * 8 +: 8] <= 0;
				__real_out_data[16 * 8 +: 8] <= 0;
				__real_out_data[17 * 8 +: 8] <= 0;
				__real_out_data[18 * 8 +: 8] <= 0;
				__real_out_data[19 * 8 +: 8] <= 0;
				__real_out_data[20 * 8 +: 8] <= 0;
				__real_out_data[21 * 8 +: 8] <= 0;
				__real_out_data[22 * 8 +: 8] <= 0;
				__real_out_data[23 * 8 +: 8] <= 0;
				__real_out_data[24 * 8 +: 8] <= 0;
				__real_out_data[25 * 8 +: 8] <= 0;
				__real_out_data[26 * 8 +: 8] <= 0;
				__real_out_data[27 * 8 +: 8] <= 0;
				__real_out_data[28 * 8 +: 8] <= 0;
				__real_out_data[29 * 8 +: 8] <= 0;
				__real_out_data[30 * 8 +: 8] <= 0;
				__real_out_data[31 * 8 +: 8] <= 0;
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				__real_out_data[0 * 16 +: 16]
					<= __sliced_32__in_to_cast.data_0[`WIDTH2MP(16):0];
				__real_out_data[1 * 16 +: 16]
					<= __sliced_32__in_to_cast.data_1[`WIDTH2MP(16):0];
				__real_out_data[2 * 16 +: 16]
					<= __sliced_32__in_to_cast.data_2[`WIDTH2MP(16):0];
				__real_out_data[3 * 16 +: 16]
					<= __sliced_32__in_to_cast.data_3[`WIDTH2MP(16):0];
				__real_out_data[4 * 16 +: 16]
					<= __sliced_32__in_to_cast.data_4[`WIDTH2MP(16):0];
				__real_out_data[5 * 16 +: 16]
					<= __sliced_32__in_to_cast.data_5[`WIDTH2MP(16):0];
				__real_out_data[6 * 16 +: 16]
					<= __sliced_32__in_to_cast.data_6[`WIDTH2MP(16):0];
				__real_out_data[7 * 16 +: 16]
					<= __sliced_32__in_to_cast.data_7[`WIDTH2MP(16):0];
				__real_out_data[8 * 16 +: 16] <= 0;
				__real_out_data[9 * 16 +: 16] <= 0;
				__real_out_data[10 * 16 +: 16] <= 0;
				__real_out_data[11 * 16 +: 16] <= 0;
				__real_out_data[12 * 16 +: 16] <= 0;
				__real_out_data[13 * 16 +: 16] <= 0;
				__real_out_data[14 * 16 +: 16] <= 0;
				__real_out_data[15 * 16 +: 16] <= 0;
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
					__real_out_data[0 * 64 +: 64]
						<= `ZERO_EXTEND(64, 32,
						__sliced_32__in_to_cast.data_0);
					__real_out_data[1 * 64 +: 64]
						<= `ZERO_EXTEND(64, 32,
						__sliced_32__in_to_cast.data_1);
					__real_out_data[2 * 64 +: 64]
						<= `ZERO_EXTEND(64, 32,
						__sliced_32__in_to_cast.data_2);
					__real_out_data[3 * 64 +: 64]
						<= `ZERO_EXTEND(64, 32,
						__sliced_32__in_to_cast.data_3);
				end

				1:
				begin
					__real_out_data[0 * 64 +: 64]
						<= `SIGN_EXTEND(64, 32,
						__sliced_32__in_to_cast.data_0);
					__real_out_data[1 * 64 +: 64]
						<= `SIGN_EXTEND(64, 32,
						__sliced_32__in_to_cast.data_1);
					__real_out_data[2 * 64 +: 64]
						<= `SIGN_EXTEND(64, 32,
						__sliced_32__in_to_cast.data_2);
					__real_out_data[3 * 64 +: 64]
						<= `SIGN_EXTEND(64, 32,
						__sliced_32__in_to_cast.data_3);
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
				__real_out_data[0 * 8 +: 8]
					<= __sliced_64__in_to_cast.data_0[`WIDTH2MP(8):0];
				__real_out_data[1 * 8 +: 8]
					<= __sliced_64__in_to_cast.data_1[`WIDTH2MP(8):0];
				__real_out_data[2 * 8 +: 8]
					<= __sliced_64__in_to_cast.data_2[`WIDTH2MP(8):0];
				__real_out_data[3 * 8 +: 8]
					<= __sliced_64__in_to_cast.data_3[`WIDTH2MP(8):0];
				__real_out_data[4 * 8 +: 8] <= 0;
				__real_out_data[5 * 8 +: 8] <= 0;
				__real_out_data[6 * 8 +: 8] <= 0;
				__real_out_data[7 * 8 +: 8] <= 0;
				__real_out_data[8 * 8 +: 8] <= 0;
				__real_out_data[9 * 8 +: 8] <= 0;
				__real_out_data[10 * 8 +: 8] <= 0;
				__real_out_data[11 * 8 +: 8] <= 0;
				__real_out_data[12 * 8 +: 8] <= 0;
				__real_out_data[13 * 8 +: 8] <= 0;
				__real_out_data[14 * 8 +: 8] <= 0;
				__real_out_data[15 * 8 +: 8] <= 0;
				__real_out_data[16 * 8 +: 8] <= 0;
				__real_out_data[17 * 8 +: 8] <= 0;
				__real_out_data[18 * 8 +: 8] <= 0;
				__real_out_data[19 * 8 +: 8] <= 0;
				__real_out_data[20 * 8 +: 8] <= 0;
				__real_out_data[21 * 8 +: 8] <= 0;
				__real_out_data[22 * 8 +: 8] <= 0;
				__real_out_data[23 * 8 +: 8] <= 0;
				__real_out_data[24 * 8 +: 8] <= 0;
				__real_out_data[25 * 8 +: 8] <= 0;
				__real_out_data[26 * 8 +: 8] <= 0;
				__real_out_data[27 * 8 +: 8] <= 0;
				__real_out_data[28 * 8 +: 8] <= 0;
				__real_out_data[29 * 8 +: 8] <= 0;
				__real_out_data[30 * 8 +: 8] <= 0;
				__real_out_data[31 * 8 +: 8] <= 0;
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				__real_out_data[0 * 16 +: 16]
					<= __sliced_64__in_to_cast.data_0[`WIDTH2MP(16):0];
				__real_out_data[1 * 16 +: 16]
					<= __sliced_64__in_to_cast.data_1[`WIDTH2MP(16):0];
				__real_out_data[2 * 16 +: 16]
					<= __sliced_64__in_to_cast.data_2[`WIDTH2MP(16):0];
				__real_out_data[3 * 16 +: 16]
					<= __sliced_64__in_to_cast.data_3[`WIDTH2MP(16):0];
				__real_out_data[4 * 16 +: 16] <= 0;
				__real_out_data[5 * 16 +: 16] <= 0;
				__real_out_data[6 * 16 +: 16] <= 0;
				__real_out_data[7 * 16 +: 16] <= 0;
				__real_out_data[8 * 16 +: 16] <= 0;
				__real_out_data[9 * 16 +: 16] <= 0;
				__real_out_data[10 * 16 +: 16] <= 0;
				__real_out_data[11 * 16 +: 16] <= 0;
				__real_out_data[12 * 16 +: 16] <= 0;
				__real_out_data[13 * 16 +: 16] <= 0;
				__real_out_data[14 * 16 +: 16] <= 0;
				__real_out_data[15 * 16 +: 16] <= 0;
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				__real_out_data[0 * 32 +: 32]
					<= __sliced_64__in_to_cast.data_0[`WIDTH2MP(32):0];
				__real_out_data[1 * 32 +: 32]
					<= __sliced_64__in_to_cast.data_1[`WIDTH2MP(32):0];
				__real_out_data[2 * 32 +: 32]
					<= __sliced_64__in_to_cast.data_2[`WIDTH2MP(32):0];
				__real_out_data[3 * 32 +: 32]
					<= __sliced_64__in_to_cast.data_3[`WIDTH2MP(32):0];
				__real_out_data[4 * 32 +: 32] <= 0;
				__real_out_data[5 * 32 +: 32] <= 0;
				__real_out_data[6 * 32 +: 32] <= 0;
				__real_out_data[7 * 32 +: 32] <= 0;
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
