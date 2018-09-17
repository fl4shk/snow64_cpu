 
# Snow64 Control Unit Details
* General Notes
	* The SystemVerilog module for the control unit is actually just called
	<code>Snow64Cpu</code>.
* The following units are part of the <code>Snow64Cpu</code> module.
	* <b>One</b> <code>Snow64FakeInstrCache</code> instance
	* <b>One</b> <code>Snow64InstrDecoder</code> instance
	* <b>One</b> <code>Snow64MemoryAccessViaFifos</code> instance
	* <b>One</b> <code>Snow64LarFile</code> instance
	* <b>Four</b> <code>Snow64Alu</code> instances (covers a whole LAR's worth of
	data)
	* <b>Four</b> <code>Snow64VectorMul</code> instances (covers a whole LAR's
	worth of data)
	* <b>Four</b> <code>Snow64NonRestoringDivider</code> instances, with
	parameter <code>WIDTH__ARGS</code> set to the default of <code>64</code>.  Note
	that because there are only four of these, vector divides for types
	other than both types of 64-bit integer will take much longer than
	would be desired.
	* <b>Three</b> <code>Snow64ScalarDataExtractor</code> instances, one for each
	of the "dest" register and the two "source" registers.
	* <b>One</b> <code>Snow64ScalarDataInjector</code> instance, which is used
	for writing into the "dest" register.
	* <b>Four</b> <code>Snow64BFloat16Fpu</code> instances, which is <i>not</i>
	enough to perform vector BFloat16 operations on whole LARs in parallel.
	* <b>Two</b> <code>Snow64BFloat16CastFromInt</code> instances,
	one for each of the two "source" data
LARs that can be used in an instruction
	* <b>Two</b> <code>Snow64BFloat16CastToInt</code> instances,
	one for each of the two "source" data
LARs that can be used in an instruction
	* <b>Two</b> <code>Snow64IntScalarCaster</code> instances,
	one for each of the two "source" data
LARs that can be used in an instruction
	* <b>Two</b> <code>Snow64IntVectorCaster</code> instances,
	one for each of the two "source" data
LARs that can be used in an instruction
	* <b>Two</b> <code>Snow64ToOrFromBFloat16VectorCaster</code> instances,
	one for each of the two "source" data
LARs that can be used in an instruction
