#ifndef src_allocation_stuff_hpp
#define src_allocation_stuff_hpp

// src/allocation_stuff.hpp

#include "misc_includes.hpp"


#include <map>

int* cstm_intdup(int to_dup);
std::string* cstm_strdup(const std::string& to_dup);

#endif		// src_allocation_stuff_hpp
