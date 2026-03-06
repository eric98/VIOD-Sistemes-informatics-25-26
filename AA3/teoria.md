# 1. Sistema d'arxius i particions
A diferència de Windows, on cada partició es mostra com un dispositiu (s'assigna C:, D:, E:, etc.), a Linux tot s'engloba dins d'un ún punt anomenat arrel (/). Dins d'aquesta, cada carpeta té un propòsit específic:
- **/bin** i **/sbin**: Contenen els binaris (programes) essencials del sistema.
- **/etc**: Fitxers de configuració de tot el sistema.
- **/home**: Carpetes personals per als usuaris.
- **/dev**: Fitxers especials que representen el hardware (discs, ratolí, etc.).
- **/proc** i **/sys**: Directoris virtuals amb informació del nucli i el sistema en temps real.
- **/var**: Arxius variables com bases de dades o logs d'error.

_Més informació: https://youtu.be/vaInQiOynWM?list=PLbLU-PtjC2ZXmYEcTb0ix-JnC_1nzG-EB_

Per altra banda, el disc es dividex en particions. Una partició és una divisió lògica d'un disc. Els beneficis d'utilitzar particions són principalment la seguretat i la modularitat. 
- **Seguretat**: Si una partició s'omple o es corromp, no afecta les altres.
- **Modularitat**: Permet reinstal·lar el sistema operatiu sense esborrar dades d'altres particions.

### Conceptes importants quan definim particions
***Punt de muntatge***: És el directori on es connecta cada partició per fer-la accessible dins de l'arbre de fitxers del sistema.

***Sistema de fitxers***: Defineix el mètode i estructura de dades que utilitza el SO per gestionar els arxius del disc. A Linux s'utilitza ext4 per defecte, a Windows NTFS per a particinos del SO i FAT32 per als dispositius extraïbles.

És el mètode i l'estructura de dades que utilitza el sistema operatiu per emmagatzemar, organitzar i recuperar els arxius en el disc. Defineix com es gestionen els noms dels fitxers, els permisos i l'espai lliure.

## >> Comàndes bàsiques
Llista les particions del sistema operatiu.
```bash
$ lsblk
```

Consulta el contingut de la carpeta arrel
```bash
$ ls -la /
```

# 2. Gestor d'arranc i Dual Boot
L'arrancada d'un SO es gestiona depén del programari de la placa base i de l'estructura del disc dur. A un mateix disc dur poden coexistir diferents SO, però és vital una bona configuració per a que no hi hagi conflictes entre ells.

A l'exemple enllaçat es veu tot un procediment de com es crea un sistema de Dual Boot des de zero. Es mostra com s'instal·la un Ubutnu en mode BIOS, seguidament s'instal·la un Windwos en mode UEFI, i posteriorment es repara el gestor d'arranc d'Ubuntu, anomenat GRUB, per a poder arrencar en mode UEFI compatible amb Windows.

Quan instal·lem Windows després d'Ubuntu, el Windows Boot Manager sobrescriu la prioritat d'arrencada a la NVRAM de la placa base, fent que el menú del GRUB desaparegui. La reparació consisteix a entrar a Linux mitjançant alguna eina externa per a poder reinstal·lar el GRUB a la partició EFI, tornar-li el control del procés d'arrencada i mostrar tots els SO disponibles.

_Exemple resolt: [dualboot-u+w.md](./dualboot-u+w.md)_

### Conceptes importants 
***NVRAM***: Sigles de Non-Volatile RAM. És una memòria especial de la placa base que no s'esborra en apagar l'ordinador. Entre altres, gestiona l'ordre de prioritat en carregar un sistema operatiu.

***EFI / UEFI***: Substitueix a l'antiga BIOS. És el programari de la placa base que substitueix l'antiga BIOS. EFI és l'estàndard original creat per Intel (Extensible Firmware Interface), UEFI és seva evolució i el que s'utilitza actualment. 

***GRUB / Windows Boot Manager***: És el gestor d'arrencada. La majoria de distribucions basades en Linux utilitzen GRUB (Grand Unified Bootloader). Windows utilitza Windows Boot Manager.

## >> Comàndes bàsiques
Instal·la els fitxers binaris del gestor d'arrencada preparats per a funcionar amb interfícies UEFI
```bash
$ sudo apt install grub-efi-amd64-signed
```

Busca la partició definida amb /boot/efi dins del disc /dev/sda, li assigna els fitxers del GRUB i registra l'entrada a la memòria NVRAM de la placa base perquè sigui la primera opció en arrencar.
```bash
$ sudo grub-install /dev/sda
```

Edita el fitxer de configuració del GRUB
```bash
$ sudo nano /etc/default/grub
```

Activa OS_PROBER, un servei que escaneja totes les particions en busca de sistemes operatius i els afegeix al GRUB.
```bash
GRUB_DISABLE_OS_PROBER=false
```

Actualitza la configuració del GRUB és a dir, escaneja totes les particions del disc buscant nuclis de Sistemes Operatius i genera el menú GNU GRUB amb tots els SO trobats.
```bash
$ sudo update-grub
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
$ sudo apt update
```

Actualitza els paquets que tenen una versió nova a l'índex d'apt
```bash
$ sudo apt upgrade
```

Instal·la un paquet amb apt
```bash
$ sudo apt install {paquet}
```

Desinstal·la un paquet amb apt
```bash
$ sudo apt remove {paquet}
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
El control d'accés i la propietat de fitxers depèn dels usuaris. 

La informació del sistema sobre els usuaris es guarda en dos fitxers clau:
- **/etc/passwd**: Conté dades bàsiques com el nom, l'ID de l'usuari (UID), el directori personal i la shell per defecte. Tothom el pot llegir.
**/etc/shadow**: Conté la informació crítica, com les contrasenyes xifrades i les dates d'expiració. Només l'usuari root hi té accés.

Alguns usuaris no tenen accés a una interfície visual ni a una shell interactiva (mysql, www-data, etc.). El benefici de gestionar-ho tot amb usuaris és que si un servei és vulnerat, l'atacant només tindrà els permisos de l'usuari del servi vulnerat (permisos de mysql, permisos de www-data, etc.) 

TODO afegir exemple
- Crear usuaris amb adduser (adduser test) i veure que la /home només es crea una vegada s'ha iniciat sessió
- Esborrar un usuari amb deluser --remove-home test
- Editar DHOME a /etc/adduser.conf i veure que s'ha actualitzat la home

## >> Comàndes bàsiques
Afegeix un nou usuari al sistema operatiu
```bash
$ sudo adduser {nom_usuari}
```

Esborra un usuari del sistema operatiu i el seu directori personal
```bash
$ sudo deluser --remove-home {nom_usuari}
```

Canvia la shell d'un usuari
```bash
$ sudo chsh -s {ruta_shell} {nom_usuari}    # exemple: sudo chsh -s /bin/zsh eric
```

Visualitza els usuaris existents
```bash
$ cat /etc/passwd
```
https://blog.elhacker.net/2022/02/icheros-etc-passwd-shadow-y-group.html

Edita el fitxer que conté la configuració de creació d'usuaris
```bash
$ sudo nano /etc/adduser.conf
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
Els grups s'utilitzen per a organitzar usuaris i assignar-los permisos de manera col·lectiva sobre fitxers, directoris o dispositius. Cada usuari pot pertànyer a un o diversos grups.

***Nota***: Quan parlem dels grups als que pertany un usuari, solem parlar de grup primari per al grup que es crea amb el mateix nom d'usuari i grups secundaris per a la resta.

TODO afegir imatge amb groups

La informació del sistema sobre els grups es guarda en dos fitxers de configuració crítics:
- **/etc/group**: Conté la llista de tots els grups del sistema, el seu ID (GID) i els usuaris que en formen part.
- **/etc/gshadow**: Conté les contrasenyes dels grups (si en tenen) i informació xifrada per a la seguretat dels administradors de grup.

## >> Comàndes bàsiques
Mostra a quins grups pertany l'usuari actual o un usuari específic.
```bash
$ groups
$ groups {usuari}
```

Crea un nou grup al sistema.
```bash
$ sudo groupadd {nom_grup}
```

Afegeix un usuari existent a un grup (com a grup secundari).
```bash
$ sudo adduser {usuari} {grup}
```

Elimina un usuari d'un grup específic.
```bash
$ sudo deluser {usuari} {grup}
```

Esborra un grup del sistema.
```bash
$ sudo deluser {usuari} {grup}
```

# 6. Gestió de permisos
Quan fem un `ls -l` per a llistar el contingut d'un directori, podem veure els seus permisos segons u="usuari propietari", g="grup propietari" i o="others", és a dir, resta d'usuaris.

TODO afegir imatge ls -l

El primer caràcter indica si és un enllaç simbòlic, si és un directori o si és un fitxer.

| Valor | Bits | Permís | Descripció |
| ------ | ----- | ----- | ----- |
| 7 (4+2+1) | 111 | rwx | Lectura, escriptura i execució. |
| 6 (4+2) | 110 | rw- | Lectura i escriptura. |
| 5 (4+1) | 101 | r-x | Lectura i execució. |
| 4 | 100 | r-- | Només lectura. |
| 3 (2+1) | 011 | -wx | Escriptura i execució. |
| 2 | 010 | -w- | Només escriptura. |
| 1 | 001 | --x | Només execució. |
| 0 | 000 | --- | Cap permís. |

![Sistema octal per a definir permisos](https://devopscube.com/content/images/2025/03/permissions-1.png)

_Més informació: https://bytebytego.com/guides/linux-file-permission-illustrated/_

## >> Comàndes bàsiques
- Comandes chown i chgrp per a modificar usuari i grup propietari
- Comanda chmod per a modificar els permisos:
```bash
$ chmod 750 {fitxer}
$ chmod o=--- {fitxer}
$ chmod o-r,o-x {fitxer}
$ chmod o-rx {fitxer}
```

Modifica l'usuari i el grup propietari d'un fitxer o directori.
```bash
$ sudo chown usuari:grup {fitxer}   # Canvia usuari i grup
$ sudo chown usuari {fitxer}        # Canvia l'usuari
$ sudo chgrp grup {fitxer}          # Canvia el grup
```

Modifica els permisos d'accés utilitzant el mètode numèric (octal) o simbòlic.
El mètode numèric utilitza valors: 4 (lectura), 2 (escriptura) i 1 (execució).
```bash
# Propietari: tot (7), Grup: llegir i executar (5), Altres: res (0)
$ chmod 750 {fitxer}

# Elimina tots els permisos per a "Others" (altres)
$ chmod o=--- {fitxer}       

# Elimina els permisos de lectura i d'execució a "Others"
$ chmod o-r,o-x {fitxer}
# Forma abreujada de la comanda anterior
$ chmod o-rx {fitxer}
```

(exercici)
- Crea 1 grup (prototip) i 4 usuaris (u1, u2, u3 i u4).
- Crea una carpeta (prototip) a /var.
- Assigna u3 com a usuari propietari de la carpeta i prototip com a grup propietari de la carpeta. Comprova el resultat amb ls -l.
- Elimina els permisos de lectura i execució a prototip a la  resta d'usuaris. Comprova el resultat amb ls -l.
- Comprova que u3 pot crear arxius dins de prototip.
- Comprova que u2 no pot crear arxius dins de prototip.

# 7. Sistemes de fitxers i Formatejos
### Conceptes previs

- ***Sector***: Unitat física mínima de lectura/escriptura en un disc dur. És una divisió física al hardware. En els SSD, els sectors són simulats ja que no tenen una limitació física real (lectura/escriptura per seccions de bits). *Vídeo on es veu què és un sector a un HDD: https://www.youtube.com/watch?v=n6uPALWAyxc*
- ***Bloc***: Unitat mínima de gestió que utilitza el Sistema de Fitxers (ext4, NFTS, FAT32, etc.). És un conjunt de sectors agrupats pel Sistema Operatiu per fer la lectura de dades més eficient. Com que diferents discs poden utilitzar diferents mides de sector, el SO tradueix els diferents sectors a blocs i gestiona les dades de tot el SO amb blocs.

- **Important!**: Si un fitxer ocupa 1 byte, el sistema de fitxers reservarà un bloc sencer per a ell. Per tant, mides de bloc molt grans poden desaprofitar espai si tenim molts fitxers petits.

Quan l'espai lliure al disc dur està fragmentat entre diversos blocs, els nous fitxers queden dispersats per tot el disc. Això degrada els HDD ja que obliga al capçal del disc a recórrer diferents espais per llegir o escriure un sol fitxer. En els discs durs sòlids aquest problema és insignificant; en aquests no hi ha capçal i l'accés a les dades és gairebé instantani.

El sistema de fitxers és l'estructura que permet definir fitxers i gestionar tota la informació emmagatzemada. Això inclou tant les dades emmagatzemades per cada fitxer com les seves metadades. Existeixen diferents sistemes de fitxers, cadascun implementa diferents algoritmes per a la gestió de la seva informació optimitzada per a tolerar fallades o compatibilitat a un SO concret.
A Linux s'utilitza la família ext4 com a estàndard i a Windows NTFS per a discs del sistema i la família FAT32 per a unitats extraïbles.

TODO es pot formatejar amb mkfs / Gparted

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