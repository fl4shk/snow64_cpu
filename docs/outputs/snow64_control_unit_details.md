 
# Snow64 Control Unit Details
* General Notes
	* The SystemVerilog module for the control unit is actually just called
	<code>Snow64Cpu</code>.
* The following units are part of the <code>Snow64Cpu</code> module.
* Operand Forwarding
	* Operand forwarding is very similar to operand forwarding in a
	conventional architecture, but it differs slightly.
		* In a nutshell, it checks if the data being compared have the same 
		<code>base\_addr</code> value.
