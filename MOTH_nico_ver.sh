#!/bin/bash

flag=$1
  
if [ -z "$flag" ]; then

read -p " > Nombre del usuario destino: " hostname
read -p " > Dirección IP del usuario destino: " hostIP
read -sp "> Contraseña: " hostPass
echo
read -p "> Mensaje que desea enviar: " message

remoteHost="$hostname@$hostIP"

#Ruta del archivo a enviar en desde mi máquina
filePath="$HOME/Desktop/Mensaje_enviado.txt"
echo "$message" > "$filePath"

remoteDesktopPath=$(sshpass -p "$hostPass" ssh "$remoteHost" 'echo $HOME/Desktop')
remoteDesktopPath="$(echo "$remoteDesktopPath" | tr -d '[:space:]')"

destinationPath="${remoteHost}:${remoteDesktopPath}"

sshpass -p "$hostPass" scp "$filePath" "$destinationPath"

echo
echo ' ~Transferencia realizada ~ '
echo

fileName=$(basename "$filePath")

notificationCommand="notify-send 'Archivo recibido' 'Ha recibido el archivo $fileName en el escritorio'"
sshpass -p "$hostPass" ssh "$remoteHost" "$notificationCommand"

elif [ $flag == '-s' ];then

  cat $HOME/Desktop/Mensaje_enviado.txt 2> moth_error_log.txt
  
  if [[ $? -eq 1 ]];then

    echo "No se ha recibido ningun mensaje"

  fi

fi



