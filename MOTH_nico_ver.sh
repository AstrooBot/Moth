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

elif [ $flag == '-s' ];then

  cat $HOME/Desktop/message.txt 2> moth_error_log.txt
  
  if [[ $? -eq 1 ]];then

    echo "No se ha recibido ningun mensaje"

  fi

fi


