section .data
    title db "//_SCHREDDER_FILE_\\", 10, 0
    title_len equ $ - title

    user_path db "Entrez le chemin du fichier à vérifier : ", 0
    user_path_len equ $ - user_path

    confirm_file db "Fichier ouvert avec succès !", 10, 0
    confirm_file_len equ $ - confirm_file

    error_msg db "ERREUR - Impossible d'ouvrir le fichier.", 10, 0
    error_msg_len equ $ - error_msg

    confirm_del db "Sûr de vouloir shred ce fichier ? (y/n) " , 0
    confirm_del_len equ $ - confirm_del

    error_path db "ERREUR - Chemin incorrect !", 10, 0
    error_path_len equ $ - error_path

    confirm_def db "Suppression confirmée.", 10, 0
    confirm_def_len equ $ - confirm_def

    cancel_del db "Suppression annulée.", 10, 0
    cancel_del_len equ $ - cancel_del

    error_fstat db "ERREUR - fstat !", 10, 0
    error_fstat_len equ $ - error_fstat

    error_overwrite db "ERREUR - overwrite", 10, 0
    error_overwrite_len equ $ - error_overwrite


section .bss
    user_path_input resb 100       ; Réserve un espace pour l'entrée utilisateur (fichier)
    user_answ_input resb 100       ; Réserve un espace pour l'entrée utilisateur (réponse)

section .text
    global _start

_start:
    ; Affiche le titre
    mov rax, 1 
    mov rdi, 1
    mov rsi, title
    mov rdx, title_len
    syscall

    ; Affiche le message pour demander le chemin
    mov rax, 1
    mov rdi, 1
    mov rsi, user_path
    mov rdx, user_path_len
    syscall

    ; Lis l'entrée utilisateur
    mov rax, 0
    mov rdi, 0
    mov rsi, user_path_input
    mov rdx, 100
    syscall

    mov rbx, user_path_input   ; Remplace le saut de ligne par un zéro terminal

replace_newline:
    cmp byte [rbx], 10
    je newline_replaced
    cmp byte [rbx], 0
    je newline_replaced
    inc rbx
    jmp replace_newline

newline_replaced:
    mov byte [rbx], 0          ; Remplace '\n' ou caractère final par 0
    mov rax, 2                 ; Tente d'ouvrir le fichier
    mov rdi, user_path_input
    mov rsi, 0                 ; O_RDONLY
    syscall

    ; Si l'ouverture a échoué
    cmp rax, 0
    jl invalid_path

    ; Si l'ouverture a réussi
    jmp valid_path

valid_path:                     
    ; Affiche le message de réussite
    mov rax, 1
    mov rdi, 1
    mov rsi, confirm_file
    mov rdx, confirm_file_len
    syscall

    ; Affiche le message pour demander la confirmation
    mov rax, 1
    mov rdi, 1
    mov rsi, confirm_del
    mov rdx, confirm_del_len
    syscall

    ; Lis la réponse de l'utilisateur
    mov rax, 0
    mov rdi, 0
    mov rsi, user_answ_input
    mov rdx, 100
    syscall

    cmp byte [user_answ_input], 'y' ; Si la réponse est 'y'
    je file_size                    ; Récupère la taille du fichier
    cmp byte [user_answ_input], 'n' ; Si la réponse est 'n'
    je cancel_file                  ; Quitte le programme

    ; Affiche un message d'erreur si réponse invalide
    mov rax, 1
    mov rdi, 1
    mov rsi, error_msg
    mov rdx, error_msg_len
    syscall
    jmp end_program

invalid_path:
    ; Affiche le message d'erreur
    mov rax, 1
    mov rdi, 1
    mov rsi, error_path
    mov rdx, error_path_len
    syscall
    jmp end_program

file_size:
    mov rax, 2
    lea rdi, [user_path_input]
    mov rsi, 0                 ; O_RDONLY (lecture seule)
    syscall
    test rax, rax              ; Vérifie si l'ouverture a échoué
    js failed_open             ; Si échec, failed_open

    mov rbx, rax               ; Stocke le descripteur dans rbx

    mov rax, 5                 ; Syscall pour 'fstat'
    lea rdi, [rbx]
    lea rsi, [rsp - 100]
    syscall

    cmp rax, 0
    jl failed_fstat            ; Si échec, failed_fstat

    ; Récupére la taille du fichier depuis le stat
    mov rax, [rsp - 100 + 8]
    mov rbx, rax               ; Stocke la taille du fichier dans rbx

    ; Afficher la taille du fichier (pour debug)
    mov rax, 1
    mov rdi, 1
    lea rsi, [rbx]
    mov rdx, 8
    syscall

    ; Passer à la overwrite du fichier
    jmp overwrite_file 

failed_open:
    mov rax, 1
    mov rdi, 1
    mov rsi, error_fstat
    mov rdx, error_fstat_len
    syscall
    jmp end_program

failed_fstat:
    mov rax, 1
    mov rdi, 1
    mov rsi, error_fstat
    mov rdx, error_fstat_len
    syscall
    jmp end_program

overwrite_file:
    mov rax, 2
    lea rdi, [user_path_input]
    mov rsi, 577               ; O_WRONLY | O_TRUNC
    syscall

    test rax, rax              ; Test si l'ouverture a échoué
    js failed_open             ; failed_open si echec

    mov rbx, rax               ; Stocke le descripteur de fichier dans rbx
    mov rcx, rbx               ; Taille du fichier à réécrire (taille du fichier est dans rbx)
    xor rdx, rdx               ; Valeur zéro pour chaque octet

fill_buffer:
    mov [rsp - 100 + rcx], dl  ; Remplit le buffer avec des zéros
    dec rcx                    ; Décrémente la taille restante
    jns fill_buffer            ; Répéte jusqu'à ce que la taille soit 0

    ; Écrire le buffer dans le fichier
    mov rax, 1
    mov rdi, rbx
    lea rsi, [rsp - 100]
    mov rdx, rbx
    syscall

    ; Si l'écriture a échoué
    test rax, rax
    js error_write             ; failed_write si échec

    ; Passe à la suppression du fichier
    jmp delete_file 

error_write:
    ; Affiche un message d'erreur si l'overwrite échoue
    mov rax, 1
    mov rdi, 1
    mov rsi, error_overwrite
    mov rdx, error_overwrite_len
    syscall
    jmp end_program
 
delete_file:
    ; Supprime le fichier
    mov rax, 87                ; Syscall pour "unlink"
    mov rdi, user_path_input
    syscall

    ; Si la suppression à été éffectué
    cmp rax, 0 
    jl invalid_delete          ; invalid_delete si échec

    ; Si c'est réussi
    mov rax, 1
    mov rdi, 1
    mov rsi, confirm_def
    mov rdx, confirm_def_len
    syscall
    jmp end_program

invalid_delete:
    ; Affiche un message d'erreur si la suppression échoue
    mov rax, 1
    mov rdi, 1
    mov rsi, error_msg
    mov rdx, error_msg_len
    syscall
    jmp end_program

cancel_file:
    ; Annule la suppression
    mov rax, 1
    mov rdi, 1
    mov rsi, cancel_del
    mov rdx, cancel_del_len
    syscall
    jmp end_program

end_program:
    ; Sort du programme
    mov rax, 60                ; Syscall pour 'exit'
    xor rdi, rdi 
    syscall
