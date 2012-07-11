#!/bin/bash

#echo "Installing compilation softwares"
#if (! sudo yum install libgtk-3-dev valac-0.14 libmenu-cache1-dev ); then
#    echo "Can't install necessary packages"
 #   exit 1
#fi

cd src
VALAFLAGS="--pkg gtk+-3.0 --pkg libmenu-cache --pkg gee-1.0 --pkg posix"
files=$(find ./ | grep .vala)
if (! valac $VALAFLAGS --vapidir=../vapi -g $files -o lxlauncher); then
    echo "Some errors during the compilation, please report this at eco.stefi@fastwebnet.it"
    exit 1
fi

echo "Successfully compiled"
echo "Hit Ctrl+C to exit, or Enter to execute lxlauncher"
read

echo "Start of the lxlauncher output"
echo "------------------------------"

./lxlauncher
