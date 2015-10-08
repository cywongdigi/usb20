# for removing the error "integer overflow"
set intovf_severity_level warning
# for dumping the signals
database -open waves -shm -default
#run 52370269885
probe -create -shm -depth all -all
run
exit

