###cut first row
``` bash
awk '{$1="";print $0}' file
```
