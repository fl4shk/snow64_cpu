include(src/include/misc_defines.m4)dnl

# Snow64 LAR File Details
* Data only:
	* metadata:
		* MDCODE(tag):  constant
		* MDCODE(data_type):  constant
		* MDCODE(int_type_size):  constant
		* MDCODE(data_offset):  constant
	* shareddata:
		* MDCODE(base_addr):  constant
		* MDCODE(ref_count):  constant
		* MDCODE(dirty):  set to 1
		* MDCODE(data):  set to MDCODE(real_in_wr.non_ldst_data)
* Data and Type:
	* metadata:
		* MDCODE(tag):  constant
		* MDCODE(data_type):  set to
		MDCODE(real_in_wr.data_type)
		* MDCODE(int_type_size):  set to
		MDCODE(real_in_wr.int_type_size)
		* MDCODE(data_offset):  constant
	* shareddata:
		* MDCODE(base_addr):  constant
		* MDCODE(ref_count):  constant
		* MDCODE(dirty):  set to 1
		* MDCODE(data):  set to MDCODE(real_in_wr.non_ldst_data)
* Loads and Stores:
	* set our MDCODE(data_type) and our MDCODE(int_type_size) to that
	provided by the instruction.
	* If BOLD(any) LAR has data from the requested address
		* If BOLD(we) aren't one of those LARs
			* Set our tag to the already allocated one.
			* Increment the reference count of the already allocated shared
			data.
			* If we were doing a store instruction:  copy our old element of
			shared data's "data" field to our new element of shared data.
			* Depending on our shared data's MDCODE(ref_count):
				* MDCODE(current ref_count == 0):
					* We do not much of interest here, and we don't have to touch
					memory at all.
				* MDCODE(current ref_count == 1):
					* We were the BOLD(only) reference to our old data.
					* In this situation, we need to deallocate our old tag, pushing
					it onto the stack of tags.
						* Note that this is the BOLD(only) situation in which we need
						to actually deallocate a tag.
					* In addition to deallocating our tag, we need to set our old
					element of shared data to have zero references.
					* If we are doing a MDCODE(store) instruction, we don't need to
					actually do anything else, but if we are doing a MDCODE(load)
					instruction, we need to write our old data back out to memory.
