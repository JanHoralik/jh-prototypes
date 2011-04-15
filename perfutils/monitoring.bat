@echo ON
set OUTPUT=c:\perflogs\vendavo_perf-%ComputerName%.csv
del %OUTPUT%
typeperf "System\Processor Queue Length" "Memory\Pages Input/Sec" "PhysicalDisk(_total)\Current Disk Queue Length" "Network Interface(*)\Output Queue Length" "Network Interface(*)\Packets Received Errors" "\processor(_total)\%% processor time" "Process(_Total)\Working Set" "Memory\Available MBytes" "PhysicalDisk(_Total)\Disk Bytes/sec" "Network Interface(*)\Bytes Total/Sec" -si 3 -o %OUTPUT%
