#!/bin/bash
if [[ $1 == 'snapshot' ]]
then
  snapshot="snapshot"
else
  snapshot=""
fi
currentdir=$(dirname $0)
echo "Host node server backup script (c) Pedro Amador 2011-2014"
# Determine backup period
period=''
if [ `date +%e` -le 7 ] && [ `date +%u` == 6 ]
then
  # Monthly; first saturnday of month (monthday <= 6, weekday = 6)
  period='monthly'
elif [ `date +%u` == 6 ]
then
  # Weekly: all saturnday
  period='weekly'
else
  period='daily'
fi
# Get exclude list
exclude=`head -n1 $currentdir/$period.exclude 2> /dev/null`

# Exec backup script
$currentdir/_backup_period.sh $period $snapshot $exclude
resul_backup_period=$?

# Do other things
if [ $resul_backup_period == 0 ]
then
  $currentdir/post_script.sh $period $snapshot $exclude
  exit $?
else
  exit $resul_backup_period
fi
