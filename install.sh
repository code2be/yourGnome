#!/bin/sh
#-------------------------------------------------------------------------------#
#				yourgnome version 2             		#
#			http://code.google.com/p/yourgnome     			#
#				Licence: GPL version 3				#
#	GPL version 3 (http://www.gnu.org/licenses/quick-guide-gplv3.html)	#
#-------------------------------------------------------------------------------#
zenity --help > /dev/null &
if [ "$?" = 0 ] ; then 
if [ ! -d $HOME/yourgnomeTEMP ]; then
mkdir $HOME/yourgnomeTEMP
if [ "$?" = 1 ] ; then 
echo "   Error: Cannot write to folder \n $HOME";
exit;
fi
fi
cp yourgnome2.sh /usr/bin/yourgnome
patch -f -s -p0 /usr/share/zenity/zenity.glade < zenity-2.24.0-focus.patch > /dev/null
if [ "$?" = 0 ] ; then 
echo "   yourgnome2 Installed Succefully !";
echo "   you can run it by running the command: yourgnome";
else
echo "   Errors while installing yourgnome2 !";
echo "   Error: You've to be root to install yourgnome2 \n   try running this file again after being root or using sudo command";
echo "   Or: Delete the line number 18 in this install script then, re-run it.";
fi
else
echo "   Error: Check that you\'ve package zenity installed.";
exit;
fi
