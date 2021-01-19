datasg  SEGMENT PARA 'veri'
    dizi DW 12, 15, 78, 90, 0
    n    DW 5 ;length
datasg  ENDS
stacksg SEGMENT PARA STACK 'yigin'
        DW 20 DUP(?)
stacksg ENDS
codesg  SEGMENT PARA 'kod'
        ASSUME CS:codesg, SS:stacksg, DS:datasg
MAIN    PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, datasg
        MOV DS, AX ;default end
        ;my code
        XOR SI, SI
        MOV CX, n
        SUB CX, 1
lo1:    MOV BX, SI ;BX is min index
        MOV DI, SI ;DI is j var (inner)
        ADD DI, 2
        PUSH CX
        MOV CX, n
        SHR DI, 1
        SUB CX, DI
        RCL DI, 1
lo2:    MOV AX, dizi[DI]
        CMP AX, dizi[BX]
        JAE cont
        MOV BX, DI
cont:   ADD DI, 2
        LOOP lo2
        MOV AX, dizi[BX]
        XCHG AX, dizi[SI]
        MOV dizi[BX], AX
        ADD SI, 2
        POP CX
        LOOP lo1
        RETF
        MAIN ENDP
        codesg ENDS
        END MAIN
