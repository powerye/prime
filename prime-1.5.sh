#! /bin/bash

MAX=100

Prime1() {
	echo -ne "2 "
	local PRIME=1
	local temp

	while ((PRIME+=2)); do
		[ $PRIME -gt $MAX ] && break
		temp=`factor $PRIME`
		[ $PRIME -eq ${temp##* } ] && echo -ne "$PRIME "
	done
}
#1-100 time:0.058s
#1-10000 time:0.456s
#1-1000000 time:601.612s

Prime2() {
	local sqMAX=`echo sqrt\($MAX\) | bc`
	local i t
	local PRIME=()

	for ((i=3;i<=MAX;i+=2)); do
		PRIME[$i]=$i
	done

	i=3
	echo -n '2 '

	while [ $i -lt $sqMAX ]; do
		until [ -n "${PRIME[$i]}" ]; do
			((i+=2))
		done
		echo -n "${PRIME[$i]} "

		for ((t=i;t<=MAX;t+=2*i)); do
			unset PRIME[$t]
		done
	done

	echo ${PRIME[*]}
}
#1-100 time:0.005s
#1-10000 time:0.346s
#1-1000000 time:3948.738s

Prime3() {
	local PRIME=(3)
	local x i

	echo -n "2 3 "
	for ((x=5;x<MAX;x+=2)); do
		for ((i=0;PRIME[i]*PRIME[i]-x<=0;i++)); do
			[ $[$x%${PRIME[$i]}] -eq 0 ] && continue 2
		done
		PRIME[${#PRIME[*]}]=$x
		echo -n "$x "
	done
}
#1-100 time: 0.003s
#1-10000 time: 1.134s
#1-1000000 time: 59.647s

MAX=10000
time Prime1
time Prime2
time Prime3
