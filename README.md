# Shredder en Assembler x86_64

![image](https://github.com/user-attachments/assets/71b7ec5a-253a-47a3-be96-108926cbc6e5)


`L'effaceur` est un programme asm qui permet d'écraser un fichier en le rendant illisible avant de supprimer son contenu.  
Il est conçu pour assurer que les données supprimées sont irrécupérables, même avec des outils d'analyse forensics.

---

## PREREQUIS

- **Système d'exploitation :** Linux (x86_64).
- **Assembleur :** NASM (Netwide Assembler).
- **Linker :** ld (GNU linker).

---

## INSTALLATION

1. Clonez ce dépôt :
   ```bash
   git clone https://github.com/B1J1M11/Shredder.git
   cd file-shredder

2. Compiler lee dépôt :
   ```bash
   nasm -f elf64 shredder.asm -o shredder.o
   ld shredder.o -o shredder

3. Executer le code :
   ```bash
   ./shredder

## EXEMPLE

![image](https://github.com/user-attachments/assets/5243f4e5-3fa1-4d49-8b3c-b9b6f22414c6)


## AXE D'AMELIORATION :

- Ne fonctionne pas que les fichiers volumineux (sera pris en compte dans un avenir proche)
- Les autres réponse que `y` ou `n` pour confirmer la suppression, ne sont pas pris en charge, donc possiblité d'erreurs.
- Si une entrée dépasse la taille maximale prévue pour les variables user_path_input et user_answ_input, dépassements de mémoire tampon.
