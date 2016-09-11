## Bug 02
Sun  11 Sep 16:50:39 CEST 2016

Libary Save.sh can't create tarball, or take lot of time to, because of:
 - "file changed as we read it"
 - "socket ignored" (can block tar cmd)
 

## Bug 02 [TMP-Resolv]
Sun  11 Sep 16:55:39 CEST 2016

Bug resolved
Two solutions : 
 - add in $HOM_PATH/ExcludeSave.d/ListExcludeHeb (or ListExcludeMen) /proc and/or all app can block tarball with socket file
 - Change "TAR_CMD" commande with /proc and/or all app can block tarball with socket file

Know app : 
 - Cloud9

## Bug 01
Thu  8 Sep 15:05:39 CEST 2016

Libary Save.sh create empty tarball because of empty argument ("--exclude" argument)


## Bug 01 [Resolv]
Thu  8 Sep 15:18:39 CEST 2016

Bug resolved
Change "TAR_CMD" commande if exclude argument is empty (empty arg => "TAR_CMD" without exclude arg )