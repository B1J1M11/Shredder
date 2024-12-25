# Shredder en Assembler x86_64

![image](https://github.com/user-attachments/assets/71b7ec5a-253a-47a3-be96-108926cbc6e5)


`L'effaceur` est un programme en assembleur qui permet d'écraser un fichier en le rendant illisible avant de supprimer son contenu. 
Il est conçu pour garantir que les données supprimées ne peuvent pas être récupérées à l'aide d'outils de récupération.

---

## Prérequis

- **Système d'exploitation :** Linux (x86_64).
- **Assembleur :** NASM (Netwide Assembler).
- **Linker :** ld (GNU linker).

---

## Installation

1. Clonez ce dépôt :
   ```bash
   git clone https://github.com/votre-utilisateur/file-shredder.git
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


## Axe d'amélioration à prévoir : 

- Ne fonctionne pas que les fichiers volumineux (sera pris en compte dans un avenir proche)
- Les autres réponse que `y` ou `n` pour confirmer la suppression, ne sont pas pris en charge, donc possiblité d'erreurs.
- Si une entrée dépasse la taille maximale prévue pour les variables user_path_input et user_answ_input, dépassements de mémoire tampon.
