assume cs:code, ds:data, ss:stack

data segment

; 将每列单词的每个字母大写
db 'cat.............'
db 'dog.............'
db 'car.............'
db 'var.............'
db 'dos.............'

data ends

stack segment

dw 0, 0, 0, 0, 0

stack ends

code segment
start:
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax

    mov bx, 0        ; 用作行指示器
    
    mov cx, 5
    a:
        push cx           ; 进入下层循环前保存上层循环数值
        
        mov cx, 3         ; 设定循环次数为3
        mov si, 0         ; 列指示器(每次循环前数值要清空)
        b:
            mov al, [bx + si]   ;相当于高级语言中的list[y][x]
            and al, 11011111b
            mov [bx + si], al
            inc si              ; 下一列
        loop b

        pop cx            ; 恢复循环数值      
        add bx, 16        ; 下一行
    loop a

    mov ax, 4c00h
    int 21h

code ends
end start 