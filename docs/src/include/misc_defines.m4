define(`BACKTICK',`changequote(<,>)`dnl'
changequote`'')dnl
define(`MDCODE',`changequote(⋀,⋁)`$1`dnl''
changequote`'')dnl  This is a bit funky
define(`CONCAT',$1$2)dnl
define(`CONCAT3',CONCAT(CONCAT($1,$2),$3))dnl
define(`SIGN_EXTEND_TO_64',sign\_extend\_to\_64`($1)')dnl
define(`EXTEND_TO_64',extend\_to\_64`($1)')dnl
define(`CAST_TO_64',cast\_to\_64`($1)')dnl
