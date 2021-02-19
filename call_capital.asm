; 使用call, ret 实现函数调用

assume cs:code, ds:data, ss:stack

data segment

db 'interesting', 0, '....'
db 'kevin', 0, '..........'
db 'lalala', 0, '.........'
db 'yousa', 0, '..........'
db 'program', 0, '....'

data ends

stack segment

dw 10 dup (0)

stack ends

code segment

; 字符串转大写（更改源数据）
; 要求字符串以0结尾
; 参数：bx：字符串在内存的首字母偏移地址
;      ds：字符串在内存的段地址
; 影响：ax, bx, cx, si
capital:
    ; 保护数据，入栈
    push cx
    push ax
    push bx
    push si

    mov si, 0           ; 设定字符串偏移量
    s:
        mov cx, 0           ; 用于判断，提前初始化
        mov al, [bx + si]   ; 从第一位向后偏移寻址
        mov cl, al
        jcxz ok             ; 判断末尾是否为0 (使用cx)
        and al, 11011111b   ; 转大写
        mov [bx + si], al
        inc si              ; 下一个数据
    loop s

    ok:
        ; 恢复数据，出栈
        pop si
        pop bx
        pop ax
        pop cx
        ret             ; 返回

; 主函数
main:
    ; 初始化，设定数据段地址及栈段地址
    mov ax, data
    mov ds, ax
    mov ax, stack
    mov ss, ax

    mov bx, 0           ; 设置开始行数
    mov cx, 5           ; 设置循环次数
    a:
        call capital        ; 调用capital函数

        add bx, 16          ; 下一行
    loop a

    mov ax, 4c00h
    int 21h

code ends
end main