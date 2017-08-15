#!/bin/bash

download(){
	curl http://us.download.nvidia.com/XFree86/Linux-x86_64/$latestLBOnline/NVIDIA-Linux-x86_64-$latestLBOnline.run -o /tmp/nvidiaupdate.run;
	echo -e "File successfully downloaded.\nMarking as executable.";
	chmod +x /tmp/nvidiaupdate.run;
	sh /tmp/nvidiaupdate.run;
}
askForDownload()
{
	echo -e "No Nvidia drivers installed.\nDo you want to download and install (y|n) : ";
	read downloadInstall;
	if [ $downloadInstall = "y" ]
	then
	latestLBOnline=`curl -s www.nvidia.com/object/unix.html | grep Linux\ x86_64 | cut -d '>' -f 5 | cut -d '<' -f 1`;
	echo "Latest \"Long Branch\" available online : "$latestLBOnline;
		download;
	else
		echo "Aborting !" ; exit 1;
	fi
}
#check for root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root."
  exit
fi

set -e

command -v nvidia-settings -v >/dev/null 2>&1 || askForDownload 

#get latest versions on computer and online
currentVersion=`nvidia-settings -v | grep version | cut -d ' ' -f 4`
echo -e "Current version : $currentVersion\nLooking for latest version available online..."
latestLBOnline=`curl -s www.nvidia.com/object/unix.html | grep Linux\ x86_64 | cut -d '>' -f 5 | cut -d '<' -f 1`
echo "Latest \"Long Branch\" available online : "$latestLBOnline


if [ $currentVersion = $latestLBOnline ]
then
	echo -e "Latest version is already installed !\nDo you want to reinstall (y|n) : "
	read reinstall
	if [ $reinstall = "y" ]
	then
		download
	else
		echo "Aborting !" ; exit 1;
	fi
else
	echo -e "New version is available online !\rDo you want to update to the latest version (y|n) :"
	read update
	if [ $update = "y" ]
	then
		download
	else
		echo "Aborting !" ; exit 1;
	fi
fi

