msbp.exe backup "db(database=AlloyDB;backuptype=full)" "zip64(level=3)" "local(path=c:\alloy.bak)"

#restore
msbp.exe restore "local(path=c:\alloy.bak)" "zip64" "db(database=AlloyDB;replace)"