; 使用call, ret 实现函数调用

assume cs:code, ds:data, ss:stack

data segment

db 'Welcome to Masm', 0
db 'Hello World!', 0, 3 dup ('.')
db 'written by Kevin', 0

data ends

stack segment

dw 20 dup (0)

stack ends

code segment

; 字符串输出到屏幕(不修改源数据)
; 要求：字符串以0结尾
; 参数： al: 要输出到的行数
;       ah: 要输出到的列数
;       dl: 样式
;       bx: 字符串首字符偏移地址
;       ds: 字符串首字符段地址
; 影响: ax, bx, cx, dx, si, di, es
print:
    ; 保护数据
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es

    ; 计算要操作的显存偏移地址
    push ax              ; 备份ax
    mov cl, 160           ; 将乘数放在cl中
    mul cl               ; al * cl 相当于行数*80*2，(显存中是两个字节存一个字符，一行80个字符)，结果存放在ax中
    mov di, ax           ; 
    pop ax               ; 恢复ax的数值

    ; 显存偏移地址(di+al的内容)
    mov al, ah
    mov ah, 0
    mov cl, 2
    mul cl               ; 列数*2，跳着存 (显存中是两个字节存一个字符)
    add di, ax

    ; 显存的段地址放入es中
    mov ax, 0b800h
    mov es, ax

    mov si, 0            ; 清空偏移地址
    s:
        mov cx, 0            ; 初始化，用于判断
        mov cl, ds:[bx + si]
        jcxz ok              ; 判断字符是否为零(判断cx), 则跳出循环
        mov es:[di], cl      ; 将该字符放入显存
        mov es:[di+1], dl    ; 将样式放入显存
        add di, 2            ; 指向下一个显存位置
        inc si               ; 指向下一个字符位置
    jmp short s              ; 死循环，回到初始化

    ok:
        ; 恢复数据
        pop es
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        ret                  ; 返回


; 主函数
main:
    ; 初始化，设定数据段地址及栈段地址
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax
    mov sp, 40

    mov al, 10              ; 行
    mov ah, 40              ; 列
    mov dl, 01110001b       ; 黑底白字
    mov bx, 0

    mov cx, 3
    a:
        call print
        add al, 1               ; 下一行
        add bx, 16              ; 字符下一行
    loop a

    mov ax, 4c00h
    int 21h

code ends
end main