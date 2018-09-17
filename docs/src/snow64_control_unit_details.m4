include(src/include/misc_defines.m4)dnl
define(`CONTROL_UNIT_MODULE',`_CODE(Snow64Cpu)')dnl
define(`ONE_MODULE_FOR_TWO_REGS',`one for each of the two "source" data
LARs that can be used in an instruction')dnl

# Snow64 Control Unit Details
* General Notes
	* The SystemVerilog module for the control unit is actually just called
	CONTROL_UNIT_MODULE().
* The following units are part of the CONTROL_UNIT_MODULE() module.
	* _BOLD(One) _CODE(Snow64FakeInstrCache) instance
	* _BOLD(One) _CODE(Snow64InstrDecoder) instance
	* _BOLD(One) _CODE(Snow64MemoryAccessViaFifos) instance
	* _BOLD(One) _CODE(Snow64LarFile) instance
	* _BOLD(Four) _CODE(Snow64Alu) instances (covers a whole LAR's worth of
	data)
	* _BOLD(Four) _CODE(Snow64VectorMul) instances (covers a whole LAR's
	worth of data)
	* _BOLD(Four) _CODE(Snow64NonRestoringDivider) instances, with
	parameter _CODE(WIDTH__ARGS) set to the default of _CODE(64).  Note
	that because there are only four of these, vector divides for types
	other than both types of 64-bit integer will take much longer than
	would be desired.
	* _BOLD(Three) _CODE(Snow64ScalarDataExtractor) instances, one for each
	of the "dest" register and the two "source" registers.
	* _BOLD(One) _CODE(Snow64ScalarDataInjector) instance, which is used
	for writing into the "dest" register.
	* _BOLD(Four) _CODE(Snow64BFloat16Fpu) instances, which is _ITALIC(not)
	enough to perform vector BFloat16 operations on whole LARs in parallel.
	* _BOLD(Two) _CODE(Snow64BFloat16CastFromInt) instances,
	ONE_MODULE_FOR_TWO_REGS()
	* _BOLD(Two) _CODE(Snow64BFloat16CastToInt) instances,
	ONE_MODULE_FOR_TWO_REGS()
	* _BOLD(Two) _CODE(Snow64IntScalarCaster) instances,
	ONE_MODULE_FOR_TWO_REGS()
	* _BOLD(Two) _CODE(Snow64IntVectorCaster) instances,
	ONE_MODULE_FOR_TWO_REGS()
	* _BOLD(Two) _CODE(Snow64ToOrFromBFloat16VectorCaster) instances,
	ONE_MODULE_FOR_TWO_REGS()
