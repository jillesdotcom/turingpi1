#!/bin/bash
for i in {1..7};do
  ip=192.168.20.6$i
  if ping -c 1 -W 1 "$ip" >/dev/null; then
    echo "using turingpi$i ($ip) to retrieve status"
    echo
    break
  fi
done

if [ "$ip" == "" ];then
  echo no server to obtain status
  exit
fi

RED=$(echo -en '\e[1;6;31m')
GREEN=$(echo -en '\e[1;32m')
NORMAL=$(echo -en '\e[0m')

output=$(ssh root@$ip "i2cget -y 1 0x57 0xf8")
output=${output:2:2}
output=${output^^}
output=$(echo "obase=2; ibase=16; $output" |bc)
output=${output:0:7}
nodes=5674321
for f in {0..6};do
  if [ ${output:$f:1} -eq 1 ];then
    status=${GREEN}on${NORMAL}
  else
    status=${RED}off${NORMAL}
  fi
  echo -e Turingpi${nodes:$f:1} = $status
done | sort
