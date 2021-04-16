
duration=30

csv=res.csv
echo "conn,load,meanLat,reqPerSec">${csv}

for conn in `seq 1 1 1`
do
	for load in `seq 1 20 501`
	do
		file=out_${conn}_${load}.log
		./wrk -D exp -t 1 -c ${conn} -d ${duration}s -L -s ./scripts/social-network/compose-post.lua http://192.168.1.74:8080/wrk2-api/post/compose -R ${load} > $file
		meanL=`awk  '/, StdDeviation/ { printf "%s", $3 ; }' $file`
		reqPerSec=`awk  '/Requests[/]sec:/ { printf "%s", $2 ; }' $file`
		echo "${conn},${load},${meanL}${reqPerSec}" >>${csv}
	done
done
