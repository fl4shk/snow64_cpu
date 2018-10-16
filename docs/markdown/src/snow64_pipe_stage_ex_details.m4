include(src/include/misc_defines.m4)dnl

# Snow64 Pipe Stage EX Details
* Submodules
	* Operand Forwarder
	* Rotate LAR Data (and determine a mask)
	* Inject casted _MDCODE(dSrc0) scalar data and casted _MDCODE(dSrc1)
	scalar data into vectors
	* Extract scalar data from _MDCODE(dSrc0) and _MDCODE(dSrc1)
	* Cast scalar data of _MDCODE(dSrc0) and _MDCODE(dSrc1)
	* Cast vector data of _MDCODE(dSrc0) and _MDCODE(dSrc1)
	* Perform an operation on vectors
