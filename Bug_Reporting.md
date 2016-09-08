## Bug 01
Thu  8 Sep 15:05:39 CEST 2016

Libary Save.sh create empty tarball because of empty argument ("--exclude" argument)


## Bug 01 [Resolv]
Thu  8 Sep 15:18:39 CEST 2016

Bug resolved
Change "TAR_CMD" if exclude argument is empty (empty arg => "TAR_CMD" without exclude arg )