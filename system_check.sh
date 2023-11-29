#/bin/bash

# check system uptime
checkUptime(){
	echo -e 'Checking uptime ...'
	CHARGE=$(uptime | awk -F 'average: ' '{print $2}' | awk '{print $1}' | sed 's/,//g')
	[ $CHARGE -ge 80 ] && echo '[NAO OK]' || echo "[OK] [ACTING IN $CHARGE FROM 100]"
}

# check system RAM
checkRam(){
	echo "Checking ram memory ..."
	MEM_TOTAL=$(free -m | grep ^Mem | awk '{print $2}')
	MEM_FREE=$(free -m | grep ^Mem | awk '{print $4}')
	PERC=$(echo "($MEM_FREE*100)/$MEM_TOTAL" | bc)

	[ $PERC -ge 90 ] && echo '[NAO OK]' || echo "[OK] [$PERC% from 100%]"
}

# check hard disk
checkDisk(){
	echo 'Checking Disk ...'
	df -h | grep ^/dev | while read line;do
	USED=$(echo $line | awk '{print $5}' | sed 's/%//g')
		PARTITION=$(echo $line | awk 'print $6')

	[ $USED -ge 90 ] && echo "[NAO OK - $PARTITION]" || echo "[OK - $PARTITION] [ACTING IN $USED% from 100%]"
	done
}

case $1 in
	"uptime") checkUptime ;;
	"mem") checkRam ;;
	"disk") checkDisk ;;
	"all") checkUptime; checkRam; checkDisk ;;
	*) echo "forma de usar: $0 + <uptime | mem | disk | all>"
esac
