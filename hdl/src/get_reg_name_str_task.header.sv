
// src/get_reg_name_str_task.header.sv


	function string get_reg_name_str
		(input logic [`MSB_POS__SNOW64_IENC_REG_INDEX:0] some_reg_index);

		case (some_reg_index)
		0: return "dzero";
		1: return "du0";
		2: return "du1";
		3: return "du2";
		4: return "du3";
		5: return "du4";
		6: return "du5";
		7: return "du6";
		8: return "du7";
		9: return "du8";
		10: return "du9";
		11: return "du10";
		12: return "du12";
		13: return "dlr";
		14: return "dfp";
		15: return "dsp";
		endcase
	endfunction

