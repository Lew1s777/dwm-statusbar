#! /bin/bash

thisdir=$(cd $(dirname $0);pwd)
#tempfile=$thisdir/temp
tempfile=/tmp/dwm
touch $tempfile

# set status for specific module update cpu mem ...
update() {
    [ ! "$1" ] && refresh && return                                      # stop if no module
    bash $thisdir/packages/$1.sh                                         # exeute script
    shift 1; update $*                                                   # recall the function
}

# tackle clicks
click() {
    [ ! "$1" ] && return                                                 # stop if no arg
    bash $thisdir/packages/$1.sh click $2                                # run the click function
    update $1                                                            # update the module
    refresh                                                              # refresh the module
}

# update statusbar
refresh() {
    _music='';_wifi='';_cpu='';_mem='';_vol='';_bat='';_date='';_icons=''	# reset status
    source $tempfile														# get status frome tmp
    xsetroot -name "$_music$_wifi$_cpu$_mem$_vol$_bat$_date$_icons"		# update statusbar
    #echo "$_music$_wifi$_cpu$_mem$_vol$_bat$_date$_icons" | ~/scripts/bin/dwm-setstatus
}

# refresh function
cron() {
    echo > $tempfile
    let i=0
    while true; do
        to=()
        [ $((i % 10)) -eq 0 ]  && to=(${to[@]} wifi)
        [ $((i % 20)) -eq 0 ]  && to=(${to[@]} cpu mem vol icons)
        [ $((i % 300)) -eq 0 ] && to=(${to[@]} bat)
        [ $((i % 5)) -eq 0 ]   && to=(${to[@]} date music)
        [ $i -lt 30 ] && to=(wifi cpu mem vol bat date icons)
        update ${to[@]}                                                  
        sleep 5; let i+=5
    done &
}

case $1 in
    cron) cron ;;
    update) shift 1; update $* ;;
    updateall|check) update music wifi cpu mem vol bat date icons;;
    *) click $1 $2 ;;
esac
