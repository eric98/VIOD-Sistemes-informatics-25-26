#!/bin/bash

SERVER_IP="192.168.1.57"
SERVER_PORT=50000
CLIENT_PORT=51000

FILE_NAME="enviament.txt"

# a)

# b) El client inicia la connexió i envia la capçalera VIOD-NET per indicar que vol connectar-se.
echo "b)"
echo "VIOD-NET" | nc -q 0 $SERVER_IP $SERVER_PORT

# c)

# d) El client llegeix la resposta del servidor:
#  • si rep KO_HEADER, tanca el programa.
#  • si rep OK_HEADER, envia un missatge amb la capçalera FILE_NAME i el nom d’un fitxer a enviar.
echo "d) escolto OK_HEADER"
message=$(nc -l -p $CLIENT_PORT)
echo "rebut $message"
# Es tanca el programa per a qualsevol capçalera diferent a "OK_HEADER
if [ $message != "OK_HEADER" ]; then
        exit 1 # Sortida amb un error general
fi

echo "envio FILE_NAME"
# TODO: enviar el nom del fitxer
echo "FILE_NAME" | nc -q 0 $SERVER_IP $SERVER_PORT

# e)

# f) El client espera rebre la resposta del servidor:
#  • si no rep OK_FILE_NAME, tanca el programa.
#  • si rep OK_FILE_NAME, envia el contingut del fitxer mitjançant la comanda cat.
echo "f)"
message=$(nc -l -p $CLIENT_PORT)

if [ $message != "OK_FILE_NAME" ]; then
        exit 1 # Sortida amb un error general
fi

cat $FILE_NAME | nc -q 0 $SERVER_IP $SERVER_PORT

exit 0 # Sortida satisfactòria (sense errors)
