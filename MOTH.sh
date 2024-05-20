#!/bin/bash

read -p "Usuario: " hostName
read -p "IP: " hostIP
read -sp "Contraseña: " hostPass 
echo
read -p "Archivo a enviar: " filePath

remoteHost="$hostName@$hostIP"

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


