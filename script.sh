#!/bin/bash
echo "this is modified"
cat /etc/hosts | while read ip dom
do
	if [ "$dom" != localhost ] && [[ ! $dom == *`hostname`* ]] && [ -n "$dom" ]; then
		if [ "$ip" = "#" ]; then
			break
		fi
		gasit=0
		if [ -n "$dom" ]; then
			nslookup $dom 8.8.8.8 | while read a text; do
				if [ "$text" = "$ip" ]; then
					gasit=1
					touch gasit
				fi
			done <<< "$(nslookup "$dom" 8.8.8.8)"
		fi
		if [ -e gasit ]; then
			rm gasit
		else
			echo "Bogus IP for $dom in /etc/hosts!"
		fi
	fi
done
