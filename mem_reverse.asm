; 利用栈将内存中的数据反转

assume cs:code, ds:data, ss:stack

data segment

db 'interesting.....'
db '................'

data ends

stack segment

db '................'

stack ends

code segment
start:
    mov ax, data
    mov ds, ax

    mov ax, stack
    mov ss, ax

    mov bx, 0
    mov cx, 11
    s:
        
        mov ax, [bx]
        push ax
        inc bx
    loop s 

    mov bx, 16
    mov cx, 11
    b:
        pop ax
        mov [bx], ax
        inc bx
    loop b 

    mov ax, 4c00h
    int 21h

code ends
end start 