assume cs:code, ds:data

data segment

; 将每列单词的列数位字母大写
db 'interesting.....'
db 'kevin...........'
db 'lalala..........'
db 'yousa...........'
db 'how.are.you?....'

data ends

code segment
start:
    mov ax, data
    mov ds, ax

    mov bx, 0        ; 用作行指示器
    mov si, 0        ; 列指示器

    mov cx, 5
    a:
        mov al, [bx + si]
        and al, 11011111b
        mov [bx + si], al
        add bx, 16
        inc si
    loop a



    mov ax, 4c00h
    int 21h

code ends
end start 