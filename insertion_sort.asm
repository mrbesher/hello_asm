datasg SEGMENT PARA 'veri'
    n DW 8
    dizi DW 1, 3, 6, 7, 2, 0, 32, 2
datasg ENDS
stacksg SEGMENT PARA STACK 's'
    DW 15 DUP(?)
stacksg ENDS
codesg SEGMENT PARA 'kod'
    ASSUME CS:codesg, DS:datasg, SS:stacksg
MAIN PROC FAR
    PUSH DS
    XOR AX, AX
    PUSH AX
    MOV AX, datasg
    MOV DS, AX
    XOR SI, SI
    MOV CX, n
    DEC CX
L2: MOV BX, SI
    PUSH CX
    MOV DI, SI
    ADD DI, 2
    MOV DX, SI
    SHR DX, 1
    MOV CX, n
    SUB CX, DX
L1: MOV AX, dizi[DI]
    CMP AX, dizi[BX]
    JGE L3
    MOV BX, DI
    ADD DI, 2
L3: LOOP L1
    MOV AX, dizi[SI]
    XCHG AX, dizi[BX]
    MOV dizi[SI], AX
    POP CX
    ADD SI, 2
    LOOP L2
    RETF
MAIN ENDP
codesg ENDS
    END MAIN