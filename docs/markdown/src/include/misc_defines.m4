define(`_BACKTICK',`changequote(<,>)`dnl'
changequote`'')dnl
define(`_MDCODE',`changequote(⋀,⋁)`$1`dnl''
changequote`'')dnl  This is a bit funky
define(`_CONCAT',`$1$2')dnl
define(`_CONCAT3',_CONCAT(_CONCAT(`$1',`$2'),`$3'))dnl
define(`_SIGN_EXTEND_TO_64',sign\_extend\_to\_64`($1)')dnl
define(`_EXTEND_TO_64',extend\_to\_64`($1)')dnl
define(`_CAST_TO_64',cast\_to\_64`($1)')dnl
define(`_CODE',_CONCAT3(`<code>',`$1',`</code>'))dnl
define(`_BOLD',_CONCAT3(`<b>',`$1',`</b>'))dnl
define(`_ITALIC',_CONCAT3(`<i>',`$1',`</i>'))dnl
define(`_UNDERLINE',_CONCAT3(`<u>',`$1',`</u>'))dnl
define(`_NEWLINE',`<br>')dnl
define(`_UINT8_T',`_CODE(uint8\_t)')dnl
define(`_INT8_T',`_CODE(int8\_t)')dnl
define(`_UINT16_T',`_CODE(uint16\_t)')dnl
define(`_INT16_T',`_CODE(int16\_t)')dnl
define(`_UINT32_T',`_CODE(uint32\_t)')dnl
define(`_INT32_T',`_CODE(int32\_t)')dnl
define(`_UINT64_T',`_CODE(uint64\_t)')dnl
define(`_INT64_T',`_CODE(int64\_t)')dnl
define(`_INCR',`define(`$1',eval($1() + 1))')dnl
define(`_DECR',`define(`$1',eval($1() - 1))')dnl
define(`_ARRSET', `define(`$1[$2]', `$3')')dnl
define(`_ARRGET', `defn(`$1[$2]')')dnl
define(`_ARRINCR', `define(`$1[$2]', eval(defn(`$1[$2]') + 1))')dnl
define(`_ARRDECR', `define(`$1[$2]', eval(defn(`$1[$2]') - 1))')dnl
define(`_FOR',`ifelse($#,0,``$0'',`ifelse(eval($2<=$3),1,dnl
`pushdef(`$1',$2)$4`'popdef(`$1')$0(`$1',incr($2),$3,`$4')')')')dnl
dnl for ifelse
define(`_IFELSEDEF', `ifdef(`$1', 1, 0)')dnl
changecom dnl
