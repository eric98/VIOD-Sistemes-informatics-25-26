#!/bin/bash

# b) El client inicia la connexió i envia la capçalera VIOD-NET per indicar que vol connectar-se.
SERVER_IP="10.65.0.53"
SERVER_PORT=50000
CLIENT_PORT=51000

FILE_NAME="enviament.txt"

echo "VIOD-NET" | nc $SERVER_IP $SERVER_PORT

# d) El client llegeix la resposta del servidor:
#  • si rep KO_HEADER, tanca el programa.
#  • si rep OK_HEADER, envia un missatge amb la capçalera FILE_NAME i el nom d’un fitxer a enviar.
message=$(nc -l $CLIENT_PORT)

# Es tanca el programa per a qualsevol capçalera diferent a "OK_HEADER
if [ $message != "OK_HEADER" ]
        exit 1 # Sortida amb un error general

echo "FILE_NAME" | nc $SERVER_IP $SERVER_PORT

# f) El client espera rebre la resposta del servidor:
#  • si no rep OK_FILE_NAME, tanca el programa.
#  • si rep OK_FILE_NAME, envia el contingut del fitxer mitjançant la comanda cat.
message=$(nc -l $CLIENT_PORT)

if [ $message != "OK_FILE_NAME" ]
        exit 1 # Sortida amb un error general

cat $FILE_NAME | nc $SERVER_IP $SERVER_PORT

exit 0 # Sortida satisfactòria (sense errors)
