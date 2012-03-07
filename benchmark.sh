#!/bin/sh
name=plain
count=10

echo "Started $name test on `date`"
cd $name
# clean up the outputs
rm -rf *.log
rm -rf *.out

# set the time interval for fio
sed -i s/^runtime=.*/runtime=$count/ $name.fio

# start sar that captures CPU and device activity per second
sar -u -P ALL -p -d -o $name-sar.out 1 $count >/dev/null 2>&1 &
fio --output=$name-fio.out $name.fio >/dev/null 2>&1 
echo "Stopped $name test on `date`"

# convert the sar output
sadf -d $name-sar.out -- -P ALL > $name-sar-cpu.out
sadf -d $name-sar.out -- -d -p > $name-sar-disk.out
