; 利用print函数完成绘图任务

assume cs:code, ds:data, ss:stack

data segment

; 使用了内存单元标号'char'(直接定址表)
; 可直接代替基址：char[bx]
char db 80 dup (32)
col  db 32, 0

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


; 在屏幕上绘制矩形
; 要求：
; 参数：开始坐标(左上角)： 
;         al: 行
;         ah: 列
;      dl: 样式
;      bl: 长(横向长度)
;      bh: 宽(竖直长度)
; 影响: 
draw:
    ; 保存数据
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push es

    ; 横向打印
        ; 根据需要的长度在字符列中插入一个零来控制
        push ax
        mov ax, 0
        mov al, bl
        mov si, ax
        mov char[si], 0
        pop ax

        mov cx, bx
        ; 与print字符串首字符偏移地址参数冲突，保护原数据
        push bx
        ; offset 编译器获取标号的偏移地址
        mov bx, offset char
        ; 打印矩形的第一个长边
        call print

        ; 与print需要更改参数冲突，保护原数据
        push ax
        ; 将开始行数加上持续行数-1=结束行数
        add al, ch
        sub ax, 1
        ; 打印矩形的第二个长边
        call print

        pop ax ; 恢复ax:起始位置
        pop bx ; 恢复bx:持续距离
        ; 将插入的0恢复
        mov char[si], 32

    ; 竖直打印
        push bx
        push ax
        
        ; 设置循环为持续行数-1，第一行横向打过了
        mov cx, 0
        mov cl, bh
        sub cx, 1 
        push cx

        ; 计算最后列数=开始列数+持续列数-1，第一列第一遍竖向打过了
        mov dh, bl
        add dh, ah
        sub dh, 1

        ; 设置打印字符为一个空格
        mov bx, offset col
        r_s:
            ; 从开始行数+1打印， 之后每次+1
            add al, 1
            call print
            jcxz one_ok
            loop r_s
        one_ok: 
            ; 判断是否为第二轮循环
            ; 当前列数已经为最终列数时停止
            mov cx, 0
            mov cl, dh
            sub cl, ah
            jcxz loop_end 
            
            ; 重置cx次数，见138行
            pop cx

            ; 重置ax内容到参数状态，将行数初始化
            pop ax
            push ax
            ; 设置到最终列数
            mov ah, dh
            
            ; 跳转，进行第二轮循环
            jmp r_s

        loop_end:
            pop ax
            pop bx

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

    mov al, 3
    mov ah, 0
    mov dl, 01110001b       ; 黑底白字
    mov bl, 20
    mov bh, 3

    call draw

    mov ax, 4c00h
    int 21h

code ends
end main