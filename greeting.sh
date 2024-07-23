#!/bin/bash
PERSON=$1
echo "heloo $PERSON:good morning. we am learning shell script"
NAME=""
WISHES="Good morning"
USAGE(){
    echo "USAGE::$(basename $0) -n <name> -w <wishes>"
    echo "options::"
    echo "-n, specify the name(mandatory)"
    echo "-w, specify the wishes,ex,good morning"
    echo "-h, display help and exit"
}
while getopts ":n:w:h" opt;
do
    case $opt in
        n)NAME="$OPTARGS";;
        w)WISHES="$OPTARGS";;
       \?)echo "invalid options: -"$OPTARGS"" >&2; USAGE; exit;;
        :)USAGE; exit;;
        h)USAGE; exit;;
   
    esac    
done
if [ -z "$NAME" ]||[ -z "$WISHES" ];then
    echo "ERROR:both -n and -w are mantary options"
    USAGE
    exit 1
fi
echo "Hello $NAME. $WISHES. I have learning shell script"