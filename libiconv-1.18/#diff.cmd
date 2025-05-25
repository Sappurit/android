
set "file1=localcharset.c"

set "diff=C:\util\GNU\bin\diff.exe"

"%diff%"  --text  --unified  "%file1%"  "%file1%.mod"  >  "%file1%.diff"
