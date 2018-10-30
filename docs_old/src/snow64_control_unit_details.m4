include(src/include/misc_defines.m4)dnl
define(`CONTROL_UNIT_MODULE',`_CODE(Snow64Cpu)')dnl
define(`ONE_MODULE_FOR_TWO_REGS',`one for each of the two "source" data
LARs that can be used in an instruction')dnl

# Snow64 Control Unit Details
* General Notes
	* The SystemVerilog module for the control unit is actually just called
	CONTROL_UNIT_MODULE().
* The following units are part of the CONTROL_UNIT_MODULE() module.
* Operand Forwarding
	* Operand forwarding is very similar to operand forwarding in a
	conventional architecture, but it differs slightly.
		* In a nutshell, it checks if the data being compared have the same 
		_CODE(base\_addr) value.
