datasg SEGMENT PARA 'data'
    n DW 5
    arr DW 100, 50, 32, 1, 26
datasg ENDS
stacksg SEGMENT PARA 'stack'
    DW 12 DUP(?)
stacksg ENDS
codesg SEGMENT PARA 'code'
    ASSUME CS:codesg, DS:datasg, SS:stacksg
MAIN PROC FAR
    PUSH DS
    XOR AX,AX
    PUSH AX
    MOV AX, datasg
    MOV DS, AX
    
    mov cx, n
    dec cx
    outerloop:
        mov ax, n
        sub ax, cx
        push cx
        mov cx, n
        sub cx, ax
        xor di, di
        innerlo:
        mov ax, arr[di]
        cmp ax, arr[di+2]
        jbe continue
        xchg ax, arr[di+2]
        mov arr[di], ax
        continue:
        add di, 2
        loop innerlo
        pop cx
        loop outerloop

RETF
MAIN ENDP
codesg ENDS
END MAIN
