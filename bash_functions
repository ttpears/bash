#! /bin/bash

# The grep functions below can probably be converted to ack or something more efficient
# but they've worked well so far
phpgrep ()
{
   grep --include=*.php -irHn "$@" *
}

cssgrep ()
{
   grep --include=*.css -irHn "$@" *
}

jsgrep ()
{
   grep --include=*.js -irHn "$@" *
}

xgrep ()
{
   grep --include=*.xhtml -irHn "$@" *
}

# Most commonly used grep function
# "Simple" grep
function sgrep () {
   grep "$1" -irHn *
}

# Show the files modified in "tip" rev 
# or pass a rev
hgfiles ()
{
    if [ $# -ne 1 ]; then
        hg log --template "{files}" -r tip | perl -lpe 's/\b \b/\n/g';
    fi;
    if [ $# == 1 ]; then
        hg log --template "{files}" -r$@ | perl -lpe 's/\b \b/\n/g';
    fi
}

# Generate complex passwords
function passes () {
   apg -a 1 -M SNLC -m 20 -E \'\\'"#`'
}

# Show a "pretty diff" of <rev>
function showchanges () {
	if [[ $# -ne "1" ]]; then
		echo "Usage: showchanges <revision>"
	else
		hg export $1 | colordiff | less -R
	fi
}

# Show InnoDB locks on specified host
function get_mysql_lock () {
	CMD="mysql -e \"SHOW ENGINE INNODB STATUS\G SHOW STATUS\""
	if [ ! -n "$1" ]; then
      echo "Must pass a host"
	else
		HOST="$1"
      echo -e "Showing status for: $HOST\n"
      CMD="$CMD -h $HOST | grep 'lock'"
      $CMD
	fi
}

# Find and display nicely all replicants on a MySQL master
function show_replicants() {
   if [ -z "$1" ]; then
      echo "Pass a master host to show replicants for"
   else
      HOST="$1"
      mysql -h $HOST -e "show full processlist\G" | grep -B 2 "Binlog Dump" | grep "Host:" | sed 's/   //g'
   fi
}

# Import the tip-most change pop/push it back
# Frequently used to rebase a single changeset
# that is on it's own head
function hgrebase () {
   hg qimport -r tip
   hg qpop
   hg qpush
   hg qfinish -a
}

# Update all the BIND9 serials, using current timestamp in <FILES>
# If no files are passed in, assumes outstanding files
# in the Mercurial repo are to be updated
function update_zone_serial() {
   if [ -z $1 ]; then
      FILES=$(hg st | cut -d' ' -f2 | tr '\n' ' ')
   else
      if [ ! -f $1 ]; then echo "Can't locate $1" && exit 1; fi
      FILES=$1
   fi
   if [ ! -z "$FILES" ]; then
      for f in $FILES
      do
         DATE=$(date '+%Y%m%d')
         REPLACE=$(grep -is "; serial" $f | egrep -o "([0-9]{10})")
         # Only numerics
         if [[ "$REPLACE" =~ ^[0-9]+$ ]]
         then
            LAST_DATE=$(echo $REPLACE | cut -c 1-8)
            CURRENT_INCREMENT="00"
            if [ $LAST_DATE -eq $DATE ]
            then
               LAST_INCREMENT=$(echo $REPLACE | cut -c 9-10)
               CURRENT_INCREMENT=$(expr $LAST_INCREMENT + 1)
               CURRENT_INCREMENT=$(printf "%02d" $CURRENT_INCREMENT)
            fi
            SED="sed -i \"s/$REPLACE/$DATE$CURRENT_INCREMENT/\" \"$f\""
            $(sed -i "s/$REPLACE/$DATE$CURRENT_INCREMENT/" "$f")
         fi
      done
   else
      echo "No files specified"
   fi
}

# Pretty print the grants list for <host> <user>
function show_grants {
   if [ -z $1 ]; then
      echo "Pass a host"
   fi
   if [ -z $2 ]; then
      echo "Pass a username"
   else
      mysql --batch -h $1 -e "show grants for $2" | sed 's/$/;/g'
   fi
}

# Issue a start slave on <host>
function start_slave {
   if [ -z $1 ]; then
      echo "Pass a host"
   else
      mysql -h $1 -e "stop slave; start slave;"
   fi
}

# Show slave status for <host>
function slave_status {
   if [ -z $1 ]; then
      echo "Pass a host"
   else
      mysql -h $1 -e "show slave status\G"
   fi
}


# Show row locks in MySQL for <host>
function mysql_lock_info {
   if [ -z $1 ]; then
      echo "Pass a host"
   else
      echo "If Innodb_row_lock_current_waits is large, something is likely holding a long lock, do a 'show engine innodb status\G'."
      echo "If Innodb_row_lock_waits shows how many locks have existed since DB was started, watch if it's incrementing."
      mysql -h $1 -e "show status like '%row_lock%'"
   fi
}

# Tmux attach/detach
# Attach to the named session
# Disconnect any other terminals attached
function tad() {
   if [ -z $1 ]; then
      echo "Pass the session to attach to:"
      SESSIONS="$(tmux ls)"
      echo "$SESSIONS"
   else
      tmux attach -d -t $1
   fi
}

# I think I nabbed at least part of this from
# someone, but don't recall where
# Good IO display
function ioload {
   case "$OSTYPE" in
       linux-gnu)
           io_line_count=`iostat -d -x -m | wc -l` ; 
           iostat -d -x -m 1 2 -z | tail -n +$io_line_count | grep -e "^sd[a-z].*" | awk 'BEGIN{rsum=0; wsum=0}{ rsum+=$6; wsum+=$7} END {print "IO Load\nRead:\t" rsum "\nWrite:\t" wsum }'
           ;;
   esac
}

# serve this directory via http
function pyserve {
   PORT=""
   if [ ! -z $1 ]; then
      PORT=$1
   fi
   python3 -m http.server $PORT
}

function arch_container {
   DATE=$(date +%Y-%m-%d_%H_%M)
   VMPATH="/root/vm_$DATE"
   PACKS=$1
   if [ ! -d $VMPATH ]; then
      $(sudo mkdir -p $VMPATH)
      RESULT=$(sudo pacstrap -c -d $VMPATH base --ignore linux $PACKS)
      BOLD=$(tput bold)
      NORM=$(tput sgr0)
      echo "Start container using:"
      echo "${BOLD}sudo systemd-nspawn -b -D $VMPATH${NORM}"
      echo
      echo "Use '${BOLD}sudo machinectl${NORM}' command to control containers."
      echo "View logs ${BOLD}outside${NORM} the container using: ${BOLD}sudo journalctl -M vm_$DATE${NORM}"
   else
      echo "Directory exists: $VMPATH"
   fi
}
