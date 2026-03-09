# == PREPARACIÓ ENTORN ==
# Crea un fitxer gran i contigu de 100MB
dd if=/dev/zero of=gran1.dat bs=1M count=100

# Crea 50000 fitxers petits de 4KB
for i in $(seq 1 50000); do dd if=/dev/zero of=f_$i bs=4K count=1; done

# Elimina 1 fitxer cada 3. Deixa l'espai lliure fragmentat.
for i in $(seq 1 40000); do if (( $i % 3 == 0 )); then rm f_$i; fi; done

# Crea un segon fitxer de 100MB. Com que l'espai lliure està fragmentat, el fitxer queda fragmentat.
dd if=/dev/zero of=gran2.dat bs=1M count=100

# ----- Comprovació
filefrag -v gran2.dat

# == DESFRAGMENTACIÓ ==
# Desfragmenta el segon fitxer. El fitxer queda repartit entre blocs contigus.
e4defrag gran2.dat

# ----- Comprovació
filefrag -v gran2.dat
