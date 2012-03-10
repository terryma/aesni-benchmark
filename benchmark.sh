#!/bin/sh
names=( plain aesni )
files=( /dev/xvdg /dev/xvdf )
length=${#names[@]}
count=$1
description=$2

if [ -z $count ]
then
  count=300
fi

# create a directory for this test run
dir="$description-"`date +"%Y_%m_%d_%H_%M"`
mkdir $dir
cd $dir

for (( i=0; i<$length; i++ ));
do
  name=${names[$i]}
  file=${files[$i]}

  # copy the template input file
  cp ../template.fio ./$name.fio  
  
  # set the time interval for fio
  sed -i s/^runtime=.*/runtime=$count/ $name.fio

  # set the test name
  sed -i s/^\\[-/\\[$name-/ $name.fio

  # set the file
  sed -i s,^filename=.*,filename=$file, $name.fio
  
  # start sar that captures CPU and device activity per second
  sar -u -P ALL -p -d -o $name-sar.out 1 $count >/dev/null 2>&1 &
  echo "Started $name test on `date`"
  fio --output=$name-fio.out $name.fio >/dev/null 2>&1 
  echo "Stopped $name test on `date`"
  
  # convert the sar output
  sadf -d $name-sar.out -- -P ALL > $name-sar-cpu.out
  sadf -d $name-sar.out -- -d -p > $name-sar-disk.out
done
