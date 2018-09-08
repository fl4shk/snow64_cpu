 
# Snow64 LAR File Details
* Data only:
	* metadata:
		* `tag`:  constant
		* `data_type`:  constant
		* `int_type_size`:  constant
		* `data_offset`:  constant
	* shareddata:
		* `base_addr`:  constant
		* `ref_count`:  constant
		* `dirty`:  set to 1
		* `data`:  set to `real_in_wr.non_ldst_data`
* Data and Type:
	* metadata:
		* `tag`:  constant
		* `data_type`:  set to
		`real_in_wr.data_type`
		* `int_type_size`:  set to
		`real_in_wr.int_type_size`
		* `data_offset`:  constant
	* shareddata:
		* `base_addr`:  constant
		* `ref_count`:  constant
		* `dirty`:  set to 1
		* `data`:  set to `real_in_wr.non_ldst_data`
* Loads and Stores:
	* set our `data_type` and our `int_type_size` to that
	provided by the instruction.
	* If <u>any</u> LAR has data from the requested address
		* If <u>we</u> aren't one of those LARs
			* Set our tag to the already allocated one.
			* Increment the reference count of the already allocated shared
			data.
			* Depending on our shared data's `ref_count`:
				* `ref_count == 0`:
					* Egg
