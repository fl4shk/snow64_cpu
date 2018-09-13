`include "src/snow64_cpu_defines.header.sv"
`include "src/snow64_bfloat16_defines.header.sv"


// Integer scalar casting module.
//
// Used by the EX stage of the CPU pipeline for casting scalar integers
// from one integer type to another integer type.
module Snow64IntScalarCaster(input logic clk,
	input PkgSnow64Caster::PortIn_IntScalarCaster in,
	output PkgSnow64Caster::PortOut_IntScalarCaster out);

	wire [`MSB_POS__SNOW64_SCALAR_DATA:0] __in_to_cast = in.to_cast;
	wire __in_src_type_signedness = in.src_type_signedness;
	wire [`MSB_POS__SNOW64_CPU_INT_TYPE_SIZE:0]
		__in_src_int_type_size = in.src_int_type_size,
		__in_dst_int_type_size = in.dst_int_type_size;

	logic [`MSB_POS__SNOW64_SCALAR_DATA:0] __real_out_data;

	wire [`WIDTH2MP(8):0] __bits_8__in_to_cast
		= __in_to_cast[`WIDTH2MP(8):0];
	wire [`WIDTH2MP(16):0] __bits_16__in_to_cast
		= __in_to_cast[`WIDTH2MP(16):0];
	wire [`WIDTH2MP(32):0] __bits_32__in_to_cast
		= __in_to_cast[`WIDTH2MP(32):0];

	`ifdef FORMAL
	localparam __ENUM__INT_TYPE_SIZE__8 = PkgSnow64Cpu::IntTypSz8;
	localparam __ENUM__INT_TYPE_SIZE__16 = PkgSnow64Cpu::IntTypSz16;
	localparam __ENUM__INT_TYPE_SIZE__32 = PkgSnow64Cpu::IntTypSz32;
	localparam __ENUM__INT_TYPE_SIZE__64 = PkgSnow64Cpu::IntTypSz64;
	`endif		// FORMAL

	assign out.data = __real_out_data;

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
				__real_out_data <= __bits_8__in_to_cast;
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				case (__in_src_type_signedness)
				0:
				begin
					__real_out_data <= `ZERO_EXTEND(16, 8,
						__bits_8__in_to_cast);
				end

				1:
				begin
					__real_out_data <= `SIGN_EXTEND(16, 8,
						__bits_8__in_to_cast);
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				case (__in_src_type_signedness)
				0:
				begin
					__real_out_data <= `ZERO_EXTEND(32, 8,
						__bits_8__in_to_cast);
				end

				1:
				begin
					__real_out_data <= `SIGN_EXTEND(32, 8,
						__bits_8__in_to_cast);
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (__in_src_type_signedness)
				0:
				begin
					__real_out_data <= `ZERO_EXTEND(64, 8,
						__bits_8__in_to_cast);
				end

				1:
				begin
					__real_out_data <= `SIGN_EXTEND(64, 8,
						__bits_8__in_to_cast);
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
				__real_out_data <= __bits_8__in_to_cast;
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				__real_out_data <= __bits_16__in_to_cast;
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				case (__in_src_type_signedness)
				0:
				begin
					__real_out_data <= `ZERO_EXTEND(32, 16,
						__bits_16__in_to_cast);
				end

				1:
				begin
					__real_out_data <= `SIGN_EXTEND(32, 16,
						__bits_16__in_to_cast);
				end
				endcase
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (__in_src_type_signedness)
				0:
				begin
					__real_out_data <= `ZERO_EXTEND(64, 16,
						__bits_16__in_to_cast);
				end

				1:
				begin
					__real_out_data <= `SIGN_EXTEND(64, 16,
						__bits_16__in_to_cast);
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
				__real_out_data <= __bits_8__in_to_cast;
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				__real_out_data <= __bits_16__in_to_cast;
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				__real_out_data <= __bits_32__in_to_cast;
			end

			PkgSnow64Cpu::IntTypSz64:
			begin
				case (__in_src_type_signedness)
				0:
				begin
					__real_out_data <= `ZERO_EXTEND(64, 32,
						__bits_32__in_to_cast);
				end

				1:
				begin
					__real_out_data <= `SIGN_EXTEND(64, 32,
						__bits_32__in_to_cast);
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
				__real_out_data <= __bits_8__in_to_cast;
			end

			PkgSnow64Cpu::IntTypSz16:
			begin
				__real_out_data <= __bits_16__in_to_cast;
			end

			PkgSnow64Cpu::IntTypSz32:
			begin
				__real_out_data <= __bits_32__in_to_cast;
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

