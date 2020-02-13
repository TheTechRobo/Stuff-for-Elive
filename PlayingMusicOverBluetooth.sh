#!/bin/sh
echo "This program will require root access."

echo "WARNING: the program will need to delete the previous pulseaudio configuration to permit music over bluetooth speaker!"

echo "May you grant super user rights? [Y/n]"
read input1
case $input1 in
    n*)
        echo "The program will exit. The user cannot grant the needed privileges!"
        exit 1
        ;;
    *)
        ;;
esac
echo "Will now install the needed dependencies!"

########INSTALLING DEPENDENCIES#######################
sudo apt-get update
sudo apt-get install bluetooth blueman bluez pulseaudio-module-bluetooth bluez-firmware

clear
echo "Do you have connman installed? [y/n/IDK]"
read input2

#############INSTALLING CONNMAN GTK###########################

case $input2 in
    n*)
        sudo apt-get install connman-gtk
        echo "Starting connman service..."
        sudo service connman start
        ;;
    y*)
        echo "I will need to uninstall it to install connmon-gtk. Can i? [Y/n]"
        read input3

        case $input3 in
            n*)
                echo "I cannot continue the installation."
                exit 2
                ;;
            *)
                sudo apt-get --download-only --reinstall install connman-gtk
                echo "Stopping connman service..."
                sudo service connman stop
                sudo apt-get remove connman && sudo apt-get install connman-gtk
                echo "Starting connman service..."
                sudo service connman start
                ;;
        esac
        ;;
    *) echo "I would try to uninstall it and install connman-gtk instead. Can i? [Y/n]"
       read input3

       case $input3 in
            n*)
                echo "I cannot continue the installation."
                exit 2
                ;;
            *)
                sudo apt-get --download-only -reinstall install connman-gtk
                echo "Trying to stop connman service..."
                sudo service connman stop >/dev/null 2>&1
                sudo apt-get remove connman && sudo apt-get install connman-gtk
                echo "Starting connman service..."
                sudo service connman start
                ;;
        esac
     ;;
esac

clear
echo "Make sure your bluetooth is turned on."
connman-gtk

echo "Removing previous pulseaudio configuration..."
echo "rm -r ~/.config/pulse ; pulseaudio -k"
rm -r ~/.config/pulse ; pulseaudio -k

############# playing some music ########
echo "Checking VLC installation..."
sudo apt-get install --no-upgrade vlc

echo "Downloading music Sample..."
wget https://sample-videos.com/audio/mp3/crowd-cheering.mp3

echo "Playing music sample..."
cvlc crowd-cheering.mp3&
sleep 10
killall vlc

rm crowd-cheering.mp3

#### blueman ####
clear
echo "Please configure your bluetooth device"

blueman-applet

echo "You can reopen blueman-applet in your menu."
echo
echo
echo "Press return to end this script..."
read input1

exit 0

