; 使用[bx + idata]

assume cs:code, ds:data

data segment

db 'interesting.....'
db '................'

data ends

code segment
start:
    mov ax, data
    mov ds, ax

    mov cx, 11

    mov bx, 0
    a:
        mov ax, 0[bx]
        mov 16[bx], ax
        inc bx
    loop a

    mov ax, 4c00h
    int 21h

code ends
end start 