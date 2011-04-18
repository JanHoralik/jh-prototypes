@echo ON
set OUTPUT_FOLDER=c:\perflogs
set OUTPUT_FILE=%OUTPUT_FOLDER%\vendavo_perf-%ComputerName%.csv

mkdir %OUTPUT_FOLDER%
del %OUTPUT_FILE%
typeperf "System\Processor Queue Length" "Memory\Pages Input/Sec" "PhysicalDisk(_total)\Current Disk Queue Length" "Network Interface(*)\Output Queue Length" "Network Interface(*)\Packets Received Errors" "\processor(*)\%% processor time" "Process(_Total)\Working Set" "Memory\Available MBytes" "PhysicalDisk(_Total)\Disk Bytes/sec" "Network Interface(*)\Bytes Total/Sec" -si 3 -o %OUTPUT_FILE%
