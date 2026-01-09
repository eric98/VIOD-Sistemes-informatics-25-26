#!/bin/bash

SERVER_PORT=50000
CLIENT_PORT=51000
CLIENT_IP="10.65.0.53"

FILE_NAME="rebuda.txt"

# a) El servidor escolta connexions en un port TCP definit prèviament
message=$(nc -l $SERVER_PORT)

# c) El servidor verifica la capçalera rebuda:
#   • si la capçalera no és VIOD-NET, el servidor respon amb KO_HEADER i tanca la connexió.
#   • si la capçalera és VIOD-NET, el servidor respon amb OK_HEADER i continua l’execució.
if [ $message != "VIOD-NET" ]
	echo "KO_HEADER" | nc $CLIENT_IP $CLIENT_PORT
	exit 1 # Sortida amb un error general

echo "OK_HEADER" | nc $CLIENT_IP $CLIENT_PORT

# e) El servidor llegeix el missatge rebut:
#   • si la capçalera no és FILE_NAME, respon amb KO_FILE_NAME i tanca la connexió.
#   • si la capçalera és FILE_NAME, respon amb OK_FILE_NAME.
message=$(nc -l $SERVER_PORT)

if [ $message != "FILE_NAME" ]
        echo "KO_FILE_NAME" | nc $CLIENT_IP $CLIENT_P
ORT
        exit 1 # Sortida amb un error general

echo "OK_FILE_NAME" | nc $CLIENT_IP $CLIENT_PORT

# g) El servidor llegeix el missatge rebut i ho guarda al fitxer $FILE_NAME
message=$(nc -l $SERVER_PORT)

echo $message >> $FILE_NAME
