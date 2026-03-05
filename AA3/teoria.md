Bloc 1 -- Sistema d'arxius i particions
- Sistema d'arxius a Linux
https://youtu.be/vaInQiOynWM?list=PLbLU-PtjC2ZXmYEcTb0ix-JnC_1nzG-EB
- Què són les particions? Per què utilitzar-les?
- Què és un punt de muntatge? Per què ext4?
- Particions primàries vs. lògiques. Per què només hi ha 4 particions primàries?
- Què és sda3, sda4, sda5 i sda6?

-- Comàndes bàsiques
Llista les particions del sistema
$ lsblk

Consulta el contingut de la carpeta arrel
$ ls -la /

Bloc 2 -- Gestor d'arranc i Dual Boot
- Què és EFI? Què és GPT? Per què pot haver-hi problemes de compatibilitat?
- Reparació del grub al fer Windows10 + Ubuntu
TODO

-- Comàndes bàsiques
Reinstal·la el paquet que conté els arxius que gestionen l'arrancada del sistema
$ apt install --reinstall grub-pc

Edita el fitxer de configuració del GRUB
$ nano /etc/default/grub

# Comportament predeterminat
> GRUB_TIMEOUT_STYLE=menu
> GRUB_TIMEOUT=5

# Activa OS_PROBER, un servei que escaneja les diferents particions en busca de sistemes operatius. Els SO que troba els afegeix al GRUB
> GRUB_DISABLE_OS_PROBER=false

Actualitza la configuració del GRUB
$ update-grub2

Mostra l'ordre d'arrancada
$ efibootmgr

Actualitza l'ordre d'arrancada
$ efibootmgr -o bootId[,bootId2] ...


Bloc 3 -- Gestors de paquets
- Instal·lació de programari a Windows

(exercici) Instal·la, executa i desinstal·la un paquet segons els següents mètodes
- Gestors de paquets I: apt
- Gestors de paquets II: dpkg
- Gestors de paquets III: aptitude
- Gestors de paquets IV: repositoris

-- Comàndes bàsiques
Actualitza l'índex del gestor apt
$ apt update

Actualitza els paquets que tenen una versió nova a l'índex d'apt
$ apt upgrade

Instal·la un paquet amb apt
$ apt install {paquet}

Desinstal·la un paquet amb apt
$ apt remove {paquet}

Instal·la un paquet amb dpkg
$ sudo dpkg -i {paquet}

Desinstal·la un paquet amb dpkg
$ sudo dpkg -r {paquet}


Bloc 4 -- Usuaris
- Què són els usuaris i on es guarda la seva informació (/etc/passwd i /etc/shadow)
- Per què hi ha usuaris del sistema
-> Canviar de /bin/bash a /bin/zsh ($ chsh -s /bin/zsh eric)
-> Què és la variable PATH
https://blog.elhacker.net/2022/02/icheros-etc-passwd-shadow-y-group.html
- Crear usuaris amb adduser (adduser test) i veure que la /home només es crea una vegada s'ha iniciat sessió
- Esborrar un usuari amb deluser --remove-home test
- Editar DHOME a /etc/adduser.conf i veure que s'ha actualitzat la home

-- Comàndes bàsiques
Afegeix un nou usuari al sistema operatiu
$ adduser {nom_usuari}

Esborra un usuari del sistema operatiu
$ deluser [--remove-home] {nom_usuari}

Canvia la shell d'un usuari
$ chsh -s {ruta_shell} {nom_usuari}

Visualitza els usuaris existents
$ cat /etc/passwd
https://blog.elhacker.net/2022/02/icheros-etc-passwd-shadow-y-group.html

Edita el fitxer que conté la configuració de creació d'usuaris
$ nano /etc/adduser.conf

Inciar la sessió d'un altre usuari
$ su - {nom_usuari}

(exercici)
Explorar directori /etc/skel i fer les següents tasques:
> Editar /etc/skel/.profile per a afegir la benvinguda a l'usuari
> Editar /etc/skel/.bashrc per a afegir un alias que faci 'apt update' quan s'escrigui 'aupdate'
> Editar /etc/skel/.bash_logout per a afegir un missatge de comiat.

Bloc 5 -- Grups
- Què són els grups i on es guarda la seva informació (etc/group i /etc/gshadow)
- Afegir usuaris a un grup (adduser test sudo) i comprovar-ho (groups)

-- Comàndes bàsiques
TODO

Bloc 6 -- Gestió de permisos
https://www.reddit.com/r/linux/comments/ayditr/chmod_cheatsheet/
(ls -l) (Linux File Permissions) (getfacl)
- Què és un enllaç simbòlic?
- Comandes chown i chgrp per a modificar usuari i grup propietari
- Comanda chmod per a modificar els permisos:
> chmod 750 fitxer
> chmod o=--- fitxer
> chmod o-r,o-x fitxer
> chmod o-rx fitxer

-- Comàndes bàsiques
TODO

(exercici)
- Crea 1 grup (prototip) i 4 usuaris (u1, u2, u3 i u4).
- Crea una carpeta (prototip) a /var.
- Assigna u3 com a usuari propietari de la carpeta i prototip com a grup propietari de la carpeta. Comprova el resultat amb ls -l.
- Elimina els permisos de lectura i execució a prototip a la  resta d'usuaris. Comprova el resultat amb ls -l.
- Comprova que u3 pot crear arxius dins de prototip.
- Comprova que u2 no pot crear arxius dins de prototip.

Bloc 7 --  Sistemes de fitxers i Formatejos
- Conceptes sectors i blocs
https://www.youtube.com/watch?v=n6uPALWAyxc
- Mostrar blocs al sistema
- Fragmentar un fitxer
- Formatejar amb "$ mkfs.ext4 -b 2048"
- Formatejar amb GParted
- Muntar partició amb "$ mount -t ext4 /dev/sdb1 /mnt/particio1"

-- Comàndes bàsiques
Sectors a cada partició
$ sudo fdisk -l

Mida dels blocs a una partició
$ sudo tune2fs -l {particio} | grep Block

Ús del disc (disk usage) - mida de l'arxiu en bytes
$ du -b {fitxer}
-bh per humanitzar les dades

Ús del disc (disk usage) - quants de bytes ocupa al disc
$ du -s {fitxer}
-sh per humanitzar les dades

Analitzar el nivell de fragmentació a una partició
$ e4defrag -c {particio}

Analitzar i desfragmentar una partició
$ e4defrag {partició}