# Shredder en Assembler x86_64

## Description

Voici est un programme en assembleur qui permet d'écraser un fichier en le rendant illisible avant de supprimer son contenu. 
Il est conçu pour garantir que les données ne peuvent pas être récupérées à l'aide d'outils de récupération.

---

## Prérequis

- **Système d'exploitation :** Linux (64 bits uniquement).
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

##EXEMPLE

![image](https://github.com/user-attachments/assets/95f737f4-cbd6-43ce-ad1d-31142b5c91ce)



   
