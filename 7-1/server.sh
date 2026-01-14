#!/bin/bash

SERVER_PORT=50000
CLIENT_PORT=51000
CLIENT_IP="192.168.1.82"

FILE_NAME="rebuda.txt"

# a) El servidor escolta connexions en un port TCP definit prèviament
echo "a)"
message=$(nc -l $SERVER_PORT)

# b)

# c) El servidor verifica la capçalera rebuda:
#   • si la capçalera no és VIOD-NET, el servidor respon amb KO_HEADER i tanca la connexió.
#   • si la capçalera és VIOD-NET, el servidor respon amb OK_HEADER i continua l’execució.
echo "c) Rebut $message"
if [ $message != "VIOD-NET" ]; then
	echo "KO_HEADER" | nc -q 0 $CLIENT_IP $CLIENT_PORT
	exit 1 # Sortida amb un error general
fi

echo "envio OK_HEADER"
echo "OK_HEADER" | nc -q 0 $CLIENT_IP $CLIENT_PORT

# d)

# e) El servidor llegeix el missatge rebut:
#   • si la capçalera no és FILE_NAME, respon amb KO_FILE_NAME i tanca la connexió.
#   • si la capçalera és FILE_NAME, respon amb OK_FILE_NAME.
echo "e) Escolto nom del fitxer"
message=$(nc -l $SERVER_PORT)
echo "rebut $message"
if [ $message != "FILE_NAME" ]; then
        echo "KO_FILE_NAME" | nc -q 0 $CLIENT_IP $CLIENT_PORT
        exit 1 # Sortida amb un error general
fi

echo "OK_FILE_NAME" | nc -q 0 $CLIENT_IP $CLIENT_PORT

# f)

# g) El servidor llegeix el missatge rebut i ho guarda al fitxer $FILE_NAME
echo "g)"
message=$(nc -l $SERVER_PORT)

echo $message >> $FILE_NAME

exit 0 # Sortida satisfactòria (sense errors)
