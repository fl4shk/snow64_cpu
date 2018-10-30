include(src/include/misc_defines.m4)dnl

# Snow64 Instruction Cache Details
* General Notes
	* The instruction cache is 32 kiB.
		* This is actually a typical amount of L1 instruction cache.
	* It is a direct-mapped cache.
		* As such, the replacement policy is to always replace if the CPU
		tries to load an instruction from a location that isn't cached.
	* Each cache line is 32 bytes (eight instructions), the same as a data
	LAR.
		* Therefore, the original address's low five bits are used as a
		byte index into a cache line.
		* Since this is an instruction cache for 32-bit fixed-width
		instructions, we can ignore _CODE(in\_addr[1:0]).
		* This leaves us with _CODE(in\_addr[4:2]) as the "true" index into
		the cache line.
		* We can use SystemVerilog's multidimensional packed arrays as
		follows:
			* _CODE(logic [31:0][7:0] lines\_arr[1 << 15];)
	* Effective Address
		* The tag of a cache entry is _CODE(in\_addr[63:15])
		* The index into the array of cache lines is _CODE(in\_addr[14:5])
		* The index into a single cache line is _CODE(in\_addr[4:2])
		* _CODE(in\_addr[1:0]) is forcibly aligned to the size of an
		instruction (set to _CODE(2'b00)).
