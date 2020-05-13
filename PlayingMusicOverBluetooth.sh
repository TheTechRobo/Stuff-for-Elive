#!/bin/sh
echo "This program will require root access."

echo "WARNING: the program will need to delete the previous pulseaudio configuration to permit music over bluetooth speaker!"

echo "May you grant super user rights? [Y/n]"
zenity --warning --text="WARNING: the program will need to delete the previous pulseaudio coniguration to play audio properly!"
zenity --question --text="May you grant super user rights to install needed software?"
input1=$?
case $input1 in
    1)
        echo "The program will exit. The user cannot grant the needed privileges!"
        zenity --error --text="The script will exit as the user cannot grant the necessary privileges."
        exit 1
        ;;
    0)
        ;;
esac
echo "The script will now install the needed dependencies."

########INSTALLING DEPENDENCIES#######################
sudo -A apt-get update
sudo -A apt-get install bluetooth blueman bluez pulseaudio-module-bluetooth bluez-firmware


#############INSTALLING CONNMAN GTK###########################

sudo -A apt-get install connman-gtk
echo "Stopping connman service..."
sudo -A service connman stop
echo "Starting connman service..."
sudo -A service connman start

echo "Make sure your Bluetooth is turned on."
zenity --info --text="Make sure your Bluetooth is turned on."
connman-gtk

echo "Removing previous pulseaudio configuration..."
echo "rm -r ~/.config/pulse ; pulseaudio -k"
rm -r ~/.config/pulse ; pulseaudio -k

############# playing some music ########
echo "Checking VLC installation..."
sudo -A apt-get install --no-upgrade vlc

echo "Downloading music Sample..."
wget https://sample-videos.com/audio/mp3/crowd-cheering.mp3

echo "Playing music sample..."
zenity --info --text="About to play an audio sample. You will supposedly hear a crowd cheering. This is completely normal."
cvlc crowd-cheering.mp3&
sleep 10
killall vlc

rm crowd-cheering.mp3

#### blueman ####
clear
echo "Please configure your Bluetooth device."
zenity --info --text="Please configure your Bluetooth device."

blueman-applet &; disown

echo "You can reopen blueman-applet in your menu."
zenity --info --text="You can re-open blueman-applet in your menu."

exit 0

