#!/bin/bash

flag=$1

if [ -z "$flag" ]; then

	read -p "Usuario: " hostName
	read -p "IP: " hostIP
	read -sp "Contraseña: " hostPass 
	echo
	read -p "Mensaje a enviar: " message

	remoteHost="$hostName@$hostIP"

	filePath="$HOME/Desktop/message.txt"
	echo $message > $filePath

	echo $remoteHost > keys.txt

	remoteDesktopPath=$(sshpass -p "$hostPass" ssh "$remoteHost" 'echo $HOME/Desktop')
	remoteDesktopPath=$(echo "$remoteDesktopPath" | tr -d '[:space:]')

	destinationPath="${remoteHost}:${remoteDesktopPath}"

	sshpass -p "$hostPass" scp "$filePath" "$destinationPath"

	echo
	echo "Transferencia finalizada"
	echo

	fileName=$(basename "$filePath")

	sshpass -p "$hostPass" ssh "$remoteHost" "${remoteDesktopPath}/notification.sh $fileName"

fi

if [ $flag == '-s' ];then

        read -p "Usuario: " hostName
        read -p "IP: " hostIP
        read -sp "Contraseña: " hostPass
        echo
        read -p "Mensaje a enviar: " message

        remoteHost="$hostName@$hostIP"
	
	filePath="$HOME/Desktop/message.txt"
	echo $message > $filePath

        echo $remoteHost > keys.txt

        remoteDesktopPath=$(sshpass -p "$hostPass" ssh "$remoteHost" 'echo $HOME/Desktop')
        remoteDesktopPath=$(echo "$remoteDesktopPath" | tr -d '[:space:]')

        destinationPath="${remoteHost}:${remoteDesktopPath}"

        sshpass -p "$hostPass" scp "$filePath" "$destinationPath"

        echo
        echo "Transferencia finalizada"
        echo

        fileName=$(basename "$filePath")

        sshpass -p "$hostPass" ssh "$remoteHost" "${remoteDesktopPath}/notification.sh $fileName"
	desktopEnv=$(sshpass -p "$hostPass" ssh "$remoteHost" 'echo $XDG_CURRENT_DESKTOP')
	desktopEnv=$(echo "$desktopEnv" | tr -d '[:space:]')

	case "$desktopEnv" in
  	"GNOME")
          editor="gedit"
          ;;
        "Cinnamon")
          editor="xed"
          ;;
        "XFCE")
          editor="mousepad"
          ;;
        "KDE")
          editor="kate"
          ;;
        *)
          editor="xed" 
          ;;
        esac
	
	openMessage="$editor ${remoteDesktopPath}/message.txt"
        sshpass -p "$hostPass" ssh "$remoteHost" "$openMessage"	
fi
