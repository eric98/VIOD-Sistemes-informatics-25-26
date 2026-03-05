# 1. Sistema d'arxius i particions
- Sistema d'arxius a Linux
TODO

_Més informació: https://youtu.be/vaInQiOynWM?list=PLbLU-PtjC2ZXmYEcTb0ix-JnC_1nzG-EB_

- Què són les particions? Per què utilitzar-les?
- Què és un punt de muntatge? Per què ext4?
- Particions primàries vs. lògiques. Per què només hi ha 4 particions primàries?
- Què és sda3, sda4, sda5 i sda6?

## >> Comàndes bàsiques
Llista les particions del sistema
```bash
$ lsblk
```

Consulta el contingut de la carpeta arrel
```bash
$ ls -la /
```

# 2. Gestor d'arranc i Dual Boot
- Què és EFI? Què és GPT? Per què pot haver-hi problemes de compatibilitat?
- Reparació del grub al fer Ubuntu + Windows10
TODO

_Exemple resolt: [dualboot-u+w.md](./dualboot-u+w.md)_

## >> Comàndes bàsiques
Reinstal·la el paquet que conté els arxius que gestionen l'arrancada del sistema
```bash
$ apt install --reinstall grub-pc
```

Edita el fitxer de configuració del GRUB
```bash
$ nano /etc/default/grub
```

# Activa OS_PROBER, un servei que escaneja les diferents particions en busca de sistemes operatius. Els SO que troba els afegeix al GRUB
```bash
GRUB_DISABLE_OS_PROBER=false
```

Actualitza la configuració del GRUB
```bash
$ update-grub2
```

Mostra l'ordre d'arrancada
```bash
$ efibootmgr
```

Actualitza l'ordre d'arrancada
```bash
$ efibootmgr -o bootId[,bootId2] ...
```

# 3. Gestors de paquets
- Instal·lació de programari a Windows

(exercici) Instal·la, executa i desinstal·la un paquet segons els següents mètodes
- Gestors de paquets I: apt
- Gestors de paquets II: dpkg
- Gestors de paquets III: aptitude
- Gestors de paquets IV: repositoris

## >> Comàndes bàsiques
Actualitza l'índex del gestor apt
```bash
$ apt update
```

Actualitza els paquets que tenen una versió nova a l'índex d'apt
```bash
$ apt upgrade
```

Instal·la un paquet amb apt
```bash
$ apt install {paquet}
```

Desinstal·la un paquet amb apt
```bash
$ apt remove {paquet}
```

Instal·la un paquet amb dpkg
```bash
$ sudo dpkg -i {paquet}
```

Desinstal·la un paquet amb dpkg
```bash
$ sudo dpkg -r {paquet}
```

# 4. Usuaris
- Què són els usuaris i on es guarda la seva informació (/etc/passwd i /etc/shadow)
- Per què hi ha usuaris del sistema
-> Canviar de /bin/bash a /bin/zsh ($ chsh -s /bin/zsh eric)
-> Què és la variable PATH
https://blog.elhacker.net/2022/02/icheros-etc-passwd-shadow-y-group.html
- Crear usuaris amb adduser (adduser test) i veure que la /home només es crea una vegada s'ha iniciat sessió
- Esborrar un usuari amb deluser --remove-home test
- Editar DHOME a /etc/adduser.conf i veure que s'ha actualitzat la home

## >> Comàndes bàsiques
Afegeix un nou usuari al sistema operatiu
```bash
$ adduser {nom_usuari}
```

Esborra un usuari del sistema operatiu
```bash
$ deluser [--remove-home] {nom_usuari}
```

Canvia la shell d'un usuari
```bash
$ chsh -s {ruta_shell} {nom_usuari}
```

Visualitza els usuaris existents
```bash
$ cat /etc/passwd
```
https://blog.elhacker.net/2022/02/icheros-etc-passwd-shadow-y-group.html

Edita el fitxer que conté la configuració de creació d'usuaris
```bash
$ nano /etc/adduser.conf
```

Inciar la sessió d'un altre usuari
```bash
$ su - {nom_usuari}
```

(exercici)
Explorar directori /etc/skel i fer les següents tasques:
> Editar /etc/skel/.profile per a afegir la benvinguda a l'usuari
> Editar /etc/skel/.bashrc per a afegir un alias que faci 'apt update' quan s'escrigui 'aupdate'
> Editar /etc/skel/.bash_logout per a afegir un missatge de comiat.

# 5. Grups
- Què són els grups i on es guarda la seva informació (etc/group i /etc/gshadow)
- Afegir usuaris a un grup (adduser test sudo) i comprovar-ho (groups)

## >> Comàndes bàsiques
TODO

# 6. Gestió de permisos
https://www.reddit.com/r/linux/comments/ayditr/chmod_cheatsheet/
(ls -l) (Linux File Permissions) (getfacl)
- Què és un enllaç simbòlic?
- Comandes chown i chgrp per a modificar usuari i grup propietari
- Comanda chmod per a modificar els permisos:
```bash
$ chmod 750 {fitxer}
$ chmod o=--- {fitxer}
$ chmod o-r,o-x {fitxer}
$ chmod o-rx {fitxer}
```

## >> Comàndes bàsiques
TODO

(exercici)
- Crea 1 grup (prototip) i 4 usuaris (u1, u2, u3 i u4).
- Crea una carpeta (prototip) a /var.
- Assigna u3 com a usuari propietari de la carpeta i prototip com a grup propietari de la carpeta. Comprova el resultat amb ls -l.
- Elimina els permisos de lectura i execució a prototip a la  resta d'usuaris. Comprova el resultat amb ls -l.
- Comprova que u3 pot crear arxius dins de prototip.
- Comprova que u2 no pot crear arxius dins de prototip.

# 7. Sistemes de fitxers i Formatejos
- Conceptes sectors i blocs
https://www.youtube.com/watch?v=n6uPALWAyxc
- Mostrar blocs al sistema
- Fragmentar un fitxer
- Formatejar amb "$ mkfs.ext4 -b 2048"
- Formatejar amb GParted
- Muntar partició amb "$ mount -t ext4 /dev/sdb1 /mnt/particio1"

## >> Comàndes bàsiques
Sectors a cada partició
```bash
$ sudo fdisk -l
```

Mida dels blocs a una partició
```bash
$ sudo tune2fs -l {particio} | grep Block
```

Ús del disc (disk usage) - mida de l'arxiu en bytes
```bash
$ du -b {fitxer}
```
-bh per humanitzar les dades

Ús del disc (disk usage) - quants de bytes ocupa al disc
```bash
$ du -s {fitxer}
```
-sh per humanitzar les dades

Analitzar el nivell de fragmentació a una partició
```bash
$ e4defrag -c {particio}
```

Analitzar i desfragmentar una partició
```bash
$ e4defrag {partició}
```