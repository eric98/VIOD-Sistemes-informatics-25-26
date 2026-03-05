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

### 0.2 Índex de particions (antiga MBR -> nova GPT)
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

Configurem la màquina virtual:
- Afegim iso d'Ubuntu
![Pas 1 iso](./imatges/1-iso.JPG)

- Afegim 4GB de RAM i 2 nuclis de processador
- Establim el mode BIOS (deixem desmarcada l'opció EFI)
![Pas 2 hardware](./imatges/2-hardware.JPG)

- Deixem suficient espai per poder instal·lar Ubuntu i Windows 10 (per exemple 80 GB)
![Pas 3 discdur](./imatges/3-discdur.JPG)

## 2. Particions a Ubuntu

- Accedim al menú de crear particions
![Pas 4 installaciomanual](./imatges/4-installaciomanual.JPG)

- Fem clic a "Taula de particions nova" per a crear una nova partició
![Pas 5 menuparticions](./imatges/5-menuparticions.JPG)

- Es crea una partició d'1MB automàticament. Aquesta és necessària per TODO
![Pas 6 dispositiuparticions](./imatges/6-dispositiuparticions.png)

- Definim particions per separat permet assegurar que si una partició falla, no afecta a les altres. Per exemple, reinstal·lar el sistema operatiu no afecta a les dades guardades a /home, o malmetre la /home no afecta a la resta del sistema operatiu:
    - **(partició buida d'1MB)**: TODO
    - **Arrel (/)**: On s'instal·la el sistema operatiu. Ext4 - 20 GB d'espai.
    - **Home (/home)**: On es guarden les dades personals de cada usuari. Ext4 - 10 GB d'espai.
    - **Àrea d'intercanvi (Swap)**: Espai del disc que s'utilitza com a memòria virtual quan la memòria RAM està plena. 4 GB d'espai.
    - **Partició del sistema EFI (/boot/efi)**: On es troben els programes que gestionen l'arrencada en sistemes moderns amb UEFI, com Windows. Utilitzem VFAT perquè és compatible amb Windows. 512 MB d'espai.
![Pas 7 menunovaparticio](./imatges/7-menunovaparticio.png)

![Pas 8 particionsdefinides](./imatges/8-particionsdefinides.png)
![Pas 9 resumparticions](./imatges/9-resumparticions.png)
![Pas 10 lsblk](./imatges/10-lsblk.png)

## 3. Preparar instal·lació de Windows
![Pas 11 activarefi](./imatges/11-activarefi.JPG)
![Pas 12 afegirisowindows](./imatges/12-afegirisowindows.JPG)

TODO explicar que per a una instal·lació sense les funcionalitats online de microsoft, com el correu, es pot desactivar internet de la màquina virtual
![extra2-notincinternet](./imatges/extra2-notincinternet.png)

## 4. Particions a Windows
![Pas 13 installaciomanual](./imatges/13-installaciomanual.JPG)
![Pas 14 novaparticio](./imatges/14-novaparticio.png)
![Pas 15 particions](./imatges/15-particions.png)
![Pas 16.1 paneldecontrol](./imatges/16-1-paneldecontrol.png)
![Pas 16.2 administraciondediscos](./imatges/16-2-administraciondediscos.png)

## 5. Accedir a Ubuntu
![Pas 17 afegirisosupergrub](./imatges/17-afegirisosupergrub.JPG)
![Pas 18 accedirbootmanager](./imatges/18-accedirbootmanager.JPG)
![Pas 19 arranquemuefivbox](./imatges/19-arranquemuefivbox.JPG)
![Pas 20 detectarubuntu](./imatges/20-detectarubuntu.JPG)
![Pas 21 arrancarubuntu](./imatges/21-arrancarubuntu.JPG)

## 6. Reparació del grub
![Pas 22 lsblk](./imatges/22-lsblk.png)
![Pas 23 canviarmotordelgrub](./imatges/23-canviarmotordelgrub.png)
![Pas 24 installarcarregadoranvram](./imatges/24-installarcarregadoranvram.png)
![Pas 25 editarfitxergrub](./imatges/25-editarfitxergrub.png)
![Pas 26 actualitzarmenugrub](./imatges/26-actualitzarmenugrub.png)
![Pas 27 final-gnugrub](./imatges/27-final-gnugrub.png)
