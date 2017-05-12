REMOTE="your.remote.server"
PORT="22"
EMAIL="your@email.com"
emailSent=0
powerLoss=0

while true
do
  echo "I'm checking for power .... `date`"
  nc -z -w 1 $REMOTE $PORT
  if [ $? -ne 0 ]; then
  echo “cannot connect to remote host”
    powerLoss=$(($powerLoss + 1))
    if [[ $emailSent -lt 3 && $powerLoss -gt 5 ]]; then
      echo "Sending email to $EMAIL"
      echo "Power outage detected. `date`" | mail -s "ALERT: Power loss" -a "From: alert@fromblah.com" $EMAIL
      emailSent=$(($emailSent + 1))
    fi

  else
    if [ $emailSent -gt 2 ]; then
      echo "Power is restored. `date`" | mail -s "ALERT: Power restored" -a "From: alert@fromblah.com" $EMAIL
      powerLoss=0
      emailSent=0
      continue
    fi
  fi
  sleep 30
done
