#!/bin/bash
PERSON=$1
echo "heloo $PERSON:good morning. we am learning shell script"
NAME=""
WISHES=""
USAGE(){
    echo "USAGE::$(basename $0) -n <name> -w <wishes>"
    echo "options::"
    echo "-n, specify the name(mandatory)"
    echo "-w, specify the wishes,ex,good morning"
    echo "-h, display help and exit"
}
while getopts "n:w:h" opt;
do
    case $opt in
        n)NAME="$OPTARGS";;
        \?)echo "invalid options:"$OPTARGS"" >&2 USAGE exit
        w)WISHES="$OPTARGS";;
        h|*)USAGE; exit;;
        :)USAGE; exit;;
    esac    
done