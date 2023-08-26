#!/bin/bash
case $1 in
  1) i2c=0x02 ;;
  2) i2c=0x04 ;;
  3) i2c=0x08 ;;
  4) i2c=0x10 ;;
  5) i2c=0x80 ;;
  6) i2c=0x40 ;;
  7) i2c=0x20 ;;
  *) echo  "Syntax ./poweroff.sh [1..7]"
     exit ;;
esac
for i in {1..7};do
  ip=192.168.20.6$i
  if [ $1 -ne $i ];then
    if ping -c 1 -W 1 "$ip" >/dev/null; then
      echo "using turingpi$i ($ip) to poweroff turingpi$1"
      break
    fi
  fi
done

if [ "$ip" == "" ];then
  echo no server to poweroff
  exit
fi
ssh root@${ip} "i2cset -m $i2c -y 1 0x57 0xf2 0x00"
