# Dualboot Ubuntu + Windows

0. [Conceptes previs](#0-conceptes-previs)  
1. [Configurar màquina virtual](#1-configurar-màquina-virtual)  
2. [Particions a Ubuntu](#2-particions-a-ubuntu)  
3. [Preparar instal·lació de Windows](#3-preparar-installació-de-windows)  
4. [Particions a Windows](#4-particions-a-windows)  
5. [Accedir a Ubuntu](#5-accedir-a-ubuntu)  
6. [Reparació del grub](#6-reparació-del-grub)

## 0. Conceptes previs

### 0.1 Programari de la placa base (antiga BIOS, nova UEFI)
És el primer programa que s'executa quan s'inicia l'ordinador. Era l'antiga BIOS i s'encarregava de carregar el sistema operatiu i inicialitzar cada component connectat. Actualment està substituïda per la UEFI. Permeten establir la configuració més bàsica, com la velocitat del rellotge del sistema o la velocitat dels ventiladors.

| BIOS d'un PC estàndard | UEFI BIOS d'un PC |
| ------ | ----- |
| ![BIOS d'un PC estàndard](https://upload.wikimedia.org/wikipedia/commons/0/05/Award_BIOS_setup_utility.png) | ![UEFI BIOS d'un PC](https://img.pccomponentes.com/pcblog/1684101600000/uefi-bios-2.jpg) |

### 0.2 Índex de particions (antiga MBR, nova GPT)
És una estructura que defineix on comença i acaba cada partició. L'antiga MBR només permetia 4 particions i discos fins a 2TB. Actualment està substituïda per la GPT que permet fins a 128 particions i discs de fins a 9.4ZB, limits gairebé inexistents. ($9.4ZB = 9.4TB \times 10^{9}$).

| | BIOS d'un PC estàndard | UEFI BIOS d'un PC |
| ------ | ----- | ----- |
| Màxima capacitat per partició | 2TB | 9.4ZB |
| Màxim nombre de particions | 4 particions primàries | 128 particions primàries |
| Firmware compatible | BIOS | UEFI |
| SO compatibles | Windows 7 i anteriors | Windows 8 i posteriors |

_Més info: https://www.diskpart.com/gpt-mbr/mbr-vs-gpt-1004.html_

### 0.3 Gestor d'arrencada (GRUB / Windows Boot Manager)
És un programari especialitzat en carregar el Kernel del SO a la memòria RAM i transferir-li el control a la CPU. En sistemes informàtics actuals es permet la convivència de diversos sistemes operatius en un mateix disc (Dual Boot).

**Conflictes al fer un Dual Boot**: La instal·lació de Windows configura el seu gestor d'arrencada (Windows Boot Manager) com a opció predeterminada a la NVRAM (RAM NoVolàtil, utilitzada per la placa base). Windows Boot Manager és el gestor d'arrancada oficial de l'ecosistema Windows i solament permet arrencar SO de la família Windows. Per tant, si s'ha instal·lat un SO basat en Linux abans, aquest queda invisible per a l'usuari. 

La **reparació del conflicte** es basa en reinstal·lar el GRUB, detectar tots els SO disponibles i asssignar al GRUB la prioritat d'arrancada.

| Característica | GNU GRUB (Linux) | Windows Boot Manager |
| ------ | ----- | ----- |
| Funció principal | Carregador multiboot i gestor de menús. | Carregador oficial de l'ecosistema Windows. |
| Suport Dual-Boot | Detecta i arrenca Windows i altres Linux. | Dissenyat principalment per arrencar Windows. |

## 1. Configurar màquina virtual

1. Afegim iso d'Ubuntu

![Pas 1 iso](./imatges/1-iso.JPG "Afegir iso d'Ubuntu")

2. Afegim 4GB de RAM i 2 nuclis de processador i establim el mode BIOS (deixem desmarcada l'opció EFI)

![Pas 2 hardware](./imatges/2-hardware.JPG "Configurar el hardware")

3. Deixem suficient espai per poder instal·lar Ubuntu i Windows 10 (per exemple 80 GB)

![Pas 3 discdur](./imatges/3-discdur.JPG "Configurar el disc dur")

## 2. Particions a Ubuntu

4. Accedim al menú de crear particions

![Pas 4 installaciomanual](./imatges/4-installaciomanual.JPG "Accedir al menú de crear particions")

5. Fem clic a "Taula de particions nova" per a crear una nova partició

![Pas 5 menuparticions](./imatges/5-menuparticions.JPG "Crear una nova partició")

6. Es crea una partició d'1MB automàticament. Aquesta és necessària per a permetre que GRUB s’instal·li correctament en discs GPT quan el sistema arrenca en mode BIOS.

![Pas 6 dispositiuparticions](./imatges/6-dispositiuparticions.png "Es crea una partició buida")

7. Definim particions per separat permet assegurar que si una partició falla, no afecta a les altres. Per exemple, reinstal·lar el sistema operatiu no afecta a les dades guardades a /home, o malmetre la /home no afecta a la resta del sistema operatiu:
- **(partició buida d'1MB)**: Partició imprescindible i generada automàticament que utilitza el GRUB per a arrencar en sistemes GPT amb mode BIOS. No té sistema de fitxers i és creada automàticament per algunes distribucions.
- **Arrel (/)**: On s'instal·la el sistema operatiu. Ext4 - 20 GB d'espai.
- **Home (/home)**: On es guarden les dades personals de cada usuari. Ext4 - 10 GB d'espai.
- **Àrea d'intercanvi (Swap)**: Espai del disc que s'utilitza com a memòria virtual quan la memòria RAM està plena. 4 GB d'espai.
- **Partició del sistema EFI (/boot/efi)**: On es troben els programes que gestionen l'arrencada en sistemes moderns amb UEFI, com Windows. Utilitzem VFAT perquè és compatible amb Windows. 512 MB d'espai.

![Pas 7 menunovaparticio](./imatges/7-menunovaparticio.png "Menú nova partició a Ubuntu")

8. Definim les particions

![Pas 8 particionsdefinides](./imatges/8-particionsdefinides.png "Particions definides")

9. Resum de les particions

![Pas 9 resumparticions](./imatges/9-resumparticions.png "Resum de les particions")

10. Comprovació de les particions creades
- loopN són dispositius virtuals que utilitzen alguns programes per a millorar la seguretat, entre altres

![Pas 10 lsblk](./imatges/10-lsblk.png "Particions definides")

## 3. Preparar instal·lació de Windows

11. Activem efi "Enable EFI (special OSes only)" per a poder instal·lar Windows 10.

![Pas 11 activarefi](./imatges/11-activarefi.JPG "Activació EFI")

12. Extraiem la ISO d'Ubuntu i afegim la de Windows 10.

![Pas 12 afegirisowindows](./imatges/12-afegirisowindows.JPG "Afegir ISO Windows")

***Extra**: existeixen diverses maneres de saltar-se el control de Microsoft quan pregunta per el correu. Una d'aquestes és desconnectar l'adaptador de xarxa a VirtualBox i tornar-li a activar una vegada el SO ja s'hagi acabat d'instal·lar.*

| Desconnexió d'adaptador de xarxa a VirtualBox | Microsoft permet saltar-se tota la comprovació inicial |
| ------ | ----- |
| ![Música desconnectada](./imatges/extra-desactivarinternet.JPG) | ![Música desconnectada](./imatges/extra2-notincinternet.png)

## 4. Particions a Windows

13. A Windows també podem escollir quines particions volem.

![Pas 13 installaciomanual](./imatges/13-installaciomanual.JPG "Definició particions a Windows")

14. Menú de fer particions a Windows

![Pas 14 novaparticio](./imatges/14-novaparticio.png "Menú de creació de particions a Windows")

15. Hem passat de 5 partions a 8 particions. Windows en genera 3 automàticament per facilitar la gestió del sistema operatiu.

![Pas 15 particions](./imatges/15-particions.png "Particions definides")

16. Des del *Panel de Control* podem accedir a _Administación de discos_ i veure quines particions hi ha al disc dur actual.

![Pas 16.1 paneldecontrol](./imatges/16-1-paneldecontrol.png "Accedir a Administración de discos")

17. Resum de particions a _Administación de discos_

![Pas 17 administraciondediscos](./imatges/16-2-administraciondediscos.png "Particions disponibles a Windows")

## 5. Accedir a Ubuntu

18. En aquest punt, Windows ha sobreescrit la prioritat a la NVRAM i, per tant, sempe es carregarà el Windows Boot Manager. Haurem d'afegir la ISO supergrub2, accedir a Ubuntu i reinstal·lar la grub. Inserim el disc.

![Pas 18 afegirisosupergrub](./imatges/17-afegirisosupergrub.JPG "Afegir ISO supergrub2")

19. Amb "ESC" hem de carregar la BIOS de la màquina virtual i seleccionar que es carregi el Boot Manager.

![Pas 19 accedirbootmanager](./imatges/18-accedirbootmanager.JPG "Prémer ESC per a accedir a la BIOS de la màquina virtual")

20. Podem carregar la ISO de supergrub2 mitjançant carregar la lectura UWFI VBOX CD-ROM 

![Pas 20 arranquemuefivbox](./imatges/19-arranquemuefivbox.JPG "Iniciar la màquina virtual amb la informació del CD-ROM")

21. Podem escanejar els Sistemes Opeatius que hi ha al nostre disc dur i carregar Ubuntu.

![Pas 21 detectarubuntu](./imatges/20-detectarubuntu.JPG "Escanejar els altres SO a l'ordinar")

22. Iniciem Ubuntu.

23. ![Pas 22 arrancarubuntu](./imatges/21-arrancarubuntu.JPG "S'ha trobat el SO Ubuntu")

## 6. Reparació del grub

24. Aquest últim bloc tracta de la reinstal·lació del GRUB.

La partició /dev/sda5 està al dispositiu /dev/sda (necessari identificar-lo).

![Pas 23 lsblk](./imatges/22-lsblk.png "Particions disponibles a Ubuntu")

25. El paquet grub-efi-amd64-signed conté els arxius del GRUB per a sistemes UEFI.

![Pas 24 canviarmotordelgrub](./imatges/23-canviarmotordelgrub.png "Instal·lació del paquet grub-efi-amd64-signed")

26. Reinstal·lem el GRUB al disc (dispositiu /dev/sda)

![Pas 25 installarcarregadoranvram](./imatges/24-installarcarregadoranvram.png "Reinstal·lació del GRUB")

27. Permetem que GRUB detecti altres sistemes operatius

![Pas 26 editarfitxergrub](./imatges/25-editarfitxergrub.png "Escaneig de l'ordinador en busca de SO instal·lats")

28. Actualitzem la configuració del GRUB

![Pas 27 actualitzarmenugrub](./imatges/26-actualitzarmenugrub.png "Actualització de la configuració del GRUB")

29. El GRUB s’ha reinstal·lat correctament i ja podem seleccionar entre Ubuntu i Windwos.

![Pas 28 final-gnugrub](./imatges/27-final-gnugrub.png "GRUB funciona")