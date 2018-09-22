`include "src/snow64_operand_manager_defines.header.sv"

module Snow64OperandManager(input logic clk,
	input PkgSnow64OperandManager::PortIn_OperandManager in,
	output PkgSnow64OperandManager::PortOut_OperandManager out);

	localparam __WIDTH__STATE = 2;
	localparam __MSB_POS__STATE
		= `WIDTH2MP(__WIDTH__STATE);


	enum logic [__MSB_POS__STATE:0]
	{
		StIdle,
		StMultiCycleOperandForwarding,
		StMultiCycle
	} __state;

	PkgSnow64OperandManager::PartialPortIn_OperandManager_RegData
		real_in_ra_curr_data, real_in_rb_curr_data, real_in_rc_curr_data,
		real_in_past_computed_data;

	assign real_in_ra_curr_data = in.ra_curr_data;
	assign real_in_rb_curr_data = in.rb_curr_data;
	assign real_in_rc_curr_data = in.rc_curr_data;
	assign real_in_past_computed_data = in.past_computed_data;


	logic __captured_in__perf_cast_rb, __captured_in__perf_cast_rc;
	logic __captured_in__op_type;
	PkgSnow64OperandManager::PartialPortIn_OperandManager_RegData
		__captured_in__ra_curr_data, __captured_in__rb_curr_data,
		__captured_in__rc_curr_data;
	PkgSnow64OperandManager::VectorData __captured_in__past_computed_data;


	logic __real_out_stall;
	PkgSnow64OperandManager::VectorData
		__real_out_ra_vector_data, __real_out_rb_vector_data,
		__real_out_rc_vector_data;
	PkgSnow64OperandManager::ScalarData
		__real_out_ra_scalar_data, __real_out_rb_scalar_data,
		__real_out_rc_scalar_data;


	always @(*) out.stall = __real_out_stall;

	always @(*) out.ra_vector_data = __real_out_ra_vector_data;
	always @(*) out.rb_vector_data = __real_out_rb_vector_data;
	always @(*) out.rc_vector_data = __real_out_rc_vector_data;

	always @(*) out.ra_scalar_data = __real_out_ra_scalar_data;
	always @(*) out.rb_scalar_data = __real_out_rb_scalar_data;
	always @(*) out.rc_scalar_data = __real_out_rc_scalar_data;



	initial
	begin
		__state = StIdle;

		{__captured_in__perf_cast_rb, __captured_in__perf_cast_rc,
			__captured_in__op_type} = 0;
	
		{__captured_in__ra_curr_data, __captured_in__rb_curr_data,
			__captured_in__rc_curr_data} = 0;
		__captured_in__past_computed_data = 0;

		__real_out_stall = 0;
	
		{__real_out_ra_vector_data, __real_out_rb_vector_data,
		__real_out_rc_vector_data} = 0;
	
		{__real_out_ra_scalar_data, __real_out_rb_scalar_data,
			__real_out_rc_scalar_data} = 0;
	end


	//always @(*)
	//begin
	//	case (__state)
	//	StIdle:
	//	begin
	//	end

	//	StMultiCycleOperation:
	//	begin
	//	end
	//	endcase
	//end

	//always_ff @(posedge clk)
	//begin
	//	case (__state)
	//	StIdle:
	//	begin
	//	end

	//	StMultiCycleOperation:
	//	begin
	//	end
	//	endcase
	//end


endmodule
