assume ds:data, cs:code
data segment
    ; 定义词数据，一个数据占两位 取值0~65536
    ; 从cs段的第一个位置开始
    dw 1, 2, 3, 4, 5, 6, 7, 8, 9
data ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov bx, 16 ; 取内存第十八号位，代表数据总长

    mov dx, 0     ; 存放结果

    mov cx, 9
    s:  
        add dx, [bx]  ; 取值，相加到bx
        sub bx, 2
    loop s           ; cx-- (当cx<0时停止)

    mov ax, 4c00h
    int 21h

code ends
end start