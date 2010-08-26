#!/bin/sh
#-------------------------------------------------------------------------------#
#				yourgnome version 2             								#
#			http://code.google.com/p/yourgnome     								#
#				Licence: GPL version 3											#
#	GPL version 3 (http://www.gnu.org/licenses/quick-guide-gplv3.html)			#
#-------------------------------------------------------------------------------#
if [ ! -d $HOME/yourgnomeTEMP ]; then
mkdir $HOME/yourgnomeTEMP
fi
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error: Cannot write to folder \n $HOME"
exit;
fi
zenity --list --title=yourgnome\ version\ 2 --text=What\ do\ you\ want\ to\ do\ ? --column=Function Create\ a\ backup Restore\ a\ backup > $HOME/yourgnomeTEMP/yourgnomeInput1
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Backup Cancelled !"
exit;
fi
choice=`cat $HOME/yourgnomeTEMP/yourgnomeInput1`
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error: Cannot write to folder \n $HOME"
echo "# Error !"; sleep 1;
exit;
fi
if [ "$choice" = "Create a backup" ]
then
zenity --question --title="yourgnome2" --text="Gnome will be backed up for the user: $USERNAME\nDo you want to continue?"
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Backup Cancelled !"
exit;
fi
zenity --file-selection --title="yourgnome2: Choose; where to save the backup file ?" --confirm-overwrite --save  > $HOME/yourgnomeTEMP/yourgnomeInput2
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Backup Cancelled !"
exit;
fi
path=`cat $HOME/yourgnomeTEMP/yourgnomeInput2`
nowd=`date | awk '{ print $3_$2_$6 }'`
ran=`echo $$`
(
echo "# Starting .."; sleep 1;
echo "0"; sleep 1;
echo "# Creating temporary folder .."; sleep 1;
mkdir $HOME/yourgnomeTEMP/yourgnome_$ran-$nowd
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error: Cannot create folder \n $HOME/yourgnomeTEMP/yourgnome_$ran-$nowd"
echo "# Error !"; sleep 1;
exit;
fi
echo "10"; sleep 1;
echo "# Creating backup of: Gnome Themes .."; sleep 1;
cd $HOME/
tar -z -P --create --file $HOME/yourgnomeTEMP/yourgnome_$ran-$nowd/yourgnome_themes_$ran-$nowd.tar.gz .themes
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error: Cannot write to folder \n $HOME/yourgnomeTEMP/yourgnome_$ran-$nowd"
echo "# Error !"; sleep 1;
exit;
fi
echo "45"; sleep 1;
echo "# Creating backup of: Gnome Background Image .."; sleep 1;
bgpath=`gconftool -g /desktop/gnome/background/picture_filename`
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error: Check that you\'ve package gconftool installed."
echo "# Error !"; sleep 1;
exit;
fi
bgdir=`dirname $bgpath`
fname=`basename $bgpath`
cd $bgdir/
tar -z -P --create --file $HOME/yourgnomeTEMP/yourgnome_$ran-$nowd/yourgnome_bg_$ran-$nowd.tar.gz $fname
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error: Cannot create folder \n $HOME/yourgnomeTEMP/yourgnome_$ran-$nowd"
echo "# Error !"; sleep 1;
exit;
fi
echo "55"; sleep 1;
echo "# Creating backup of: Gnome Configuration Records .."; sleep 1;
cd $HOME/
tar -z -P --create --file $HOME/yourgnomeTEMP/yourgnome_$ran-$nowd/yourgnome_conf_$ran-$nowd.tar.gz .gconf
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error: Cannot create folder \n $HOME/yourgnomeTEMP/yourgnome_$ran-$nowd"
echo "# Error !"; sleep 1;
exit;
fi
gconftool-2 --dump / > $HOME/yourgnomeTEMP/yourgnome_$ran-$nowd/dump
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error: Check that you\'ve package gconftool-2 installed."
echo "# Error !"; sleep 1;
exit;
fi
echo "75"; sleep 1;
echo "# Creating Info Files .."; sleep 1;
echo "$ran-$nowd" > $HOME/yourgnomeTEMP/yourgnome_$ran-$nowd/infofile
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error: Cannot create folder \n $HOME/yourgnomeTEMP/yourgnome_$ran-$nowd"
echo "# Error !"; sleep 1;
exit;
fi
echo "$fname" > $HOME/yourgnomeTEMP/yourgnome_$ran-$nowd/bgfile
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error: Cannot create folder \n $HOME/yourgnomeTEMP/yourgnome_$ran-$nowd"
echo "# Error !"; sleep 1;
exit;
fi
echo "80"; sleep 1;
echo "# Creating Final File .."; sleep 1;
cd $HOME/yourgnomeTEMP/yourgnome_$ran-$nowd/
tar -z -P --create --file $path.tar.gz *
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error: Cannot write to file \n $path"
echo "# Error !"; sleep 1;
exit;
fi
echo "98"; sleep 1;
echo "# Removing temporary folder .."; sleep 1;
rm -rf $HOME/yourgnomeTEMP
echo "100"; sleep 1;
echo "# Done !, Backup created, You can click OK Button now."; sleep 1;
) | zenity --progress --title="yourgnome2: Creating backup" --percentage=0
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Backup Cancelled !"
exit;
fi
fi
if [ "$choice" = "Restore a backup" ]
then
zenity --question --title="yourgnome2" --text="Gnome will be restored to the user: $USERNAME\nDo you want to continue?"
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Backup Cancelled !"
exit;
fi
zenity --file-selection --title="yourgnome2: Choose; where is the backup file ?" > $HOME/yourgnomeTEMP/yourgnomeInput3
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Restoring Cancelled !"
exit;
fi
epath=`cat $HOME/yourgnomeTEMP/yourgnomeInput3`
(
echo "# Starting .."; sleep 1;
echo "0"; sleep 1;
echo "# Creating temporary folder ..";sleep 1;
if [ ! -d $HOME/yourgnomeTEMP/yourgnome ]; then
mkdir $HOME/yourgnomeTEMP/yourgnome
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error, Cannot create directory \n $HOME/yourgnomeTEMP/yourgnome"
exit;
fi
fi
echo "10"; sleep 1;
echo "# Reading backup ..";sleep 2;
tar --extract --directory=$HOME/yourgnomeTEMP/yourgnome --file=$epath
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error, Cannot read backup file, check that you've enough permissions"
exit;
fi
getinfofile=`cat $HOME/yourgnomeTEMP/yourgnome/infofile`
echo "20"; sleep 1;
echo "# Extracting: Gnome Themes ..";sleep 1;
cd $HOME/yourgnomeTEMP/yourgnome/
tar --extract --directory=$HOME --file=yourgnome_themes_$getinfofile.tar.gz
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error, Cannot write to directory \n $HOME/yourgnomeTEMP/yourgnome"
exit;
fi
echo "60"; sleep 1;
echo "# Extracting: Gnome Configuration Records ..";sleep 1;
tar --extract --directory=$HOME --file=yourgnome_conf_$getinfofile.tar.gz
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error, Cannot write to directory \n $HOME/yourgnomeTEMP/yourgnome"
exit;
fi
gconftool-2 --load $HOME/yourgnomeTEMP/yourgnome/dump /
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error: Check that you\'ve package gconftool-2 installed."
echo "# Error !"; sleep 1;
exit;
fi
echo "70"; sleep 1;
echo "# Extracting: Gnome Background Image ..";sleep 1;
zenity --file-selection --directory --title="yourgnome2: Choose; where to save RESTORED background file ?" > $HOME/yourgnomeTEMP/yourgnomeInput4
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Restoring Cancelled !"
exit;
fi
np=`cat $HOME/yourgnomeTEMP/yourgnomeInput4`
tar --extract -P --directory=$np --file=yourgnome_bg_$getinfofile.tar.gz
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error, Cannot write to directory \n $np"
exit;
fi
bgf=`cat $HOME/yourgnomeTEMP/yourgnome/bgfile`
gconftool -s /desktop/gnome/background/picture_filename -t string $np/$bgf
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Error: Check that you\'ve package gconftool installed."
echo "# Error !"; sleep 1;
exit;
fi
echo "90"; sleep 1;
echo "# Removing temporary folder ..";sleep 1;
rm -rf $HOME/yourgnomeTEMP
echo "100"; sleep 1;
echo "# Restoring Completed !";
) | zenity --progress --title="yourgnome2: Restoring backup" --percentage=0
if [ "$?" = 1 ] ; then 
zenity --warning --title="yourgnome2" --text="Restoring Cancelled !"
exit;
fi
fi
