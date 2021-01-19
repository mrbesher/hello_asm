datasg  SEGMENT PARA 'DATA'
    arr DD 10000000h, 10008456h
    result DD 2 DUP(?)
datasg  ENDS
stacksg SEGMENT PARA STACK 'STACK'
        DW 20 DUP(?)
stacksg ENDS
codesg  SEGMENT PARA 'CODE'
        ASSUME CS:codesg, SS:stacksg, DS:datasg
MAIN    PROC FAR
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, datasg
        MOV DS, AX
        ;DDxDD = A:BxC:D = E:F:G:H
        ;order in memory arr -> 0B:2A:4D:6C | result -> 0H:2G:4F:6E
        ;multiply the least significant parts BxD (stored in reverse order)
        XOR SI, SI
        MOV AX, WORD PTR arr[SI] ; B -> AX
        MOV BX, WORD PTR arr[SI+4] ; D -> BX
        MUL BX
        MOV WORD PTR result[SI], AX ; AX -> H
        MOV WORD PTR result[SI+2], DX ; DX -> G
        ;multiply the most significant parts AxC
        MOV AX, WORD PTR arr[SI+2] ; A -> AX
        MOV BX, WORD PTR arr[SI+6] ; C -> AX
        MUL BX
        MOV WORD PTR result[SI+4], AX ; AX -> F
        MOV WORD PTR result[SI+6], DX ; DX -> E
        ;AxD
        MOV AX, WORD PTR arr[SI+2] ; A -> AX
        MOV BX, WORD PTR arr[SI+4] ; D -> BX
        MUL BX
        ADD AX, WORD PTR result[SI+2] ; AX + G -> AX
        MOV WORD PTR result[SI+2], AX ; AX -> G
        ADC DX, WORD PTR result[SI+4] ; CF + DX + F -> DX
        MOV WORD PTR result[SI+4], DX ; DX -> F
        XOR AX, AX
        ADC AX, WORD PTR result[SI+6] ; CF + E -> AX
        MOV WORD PTR result[SI+6], AX ; AX -> E
        ;BxC
        MOV AX, WORD PTR arr[SI] ; B -> AX
        MOV BX, WORD PTR arr[SI+6] ; C -> BX
        MUL BX
        ADD AX, WORD PTR result[SI+2] ; AX + G -> AX
        MOV WORD PTR result[SI+2], AX ; AX -> G
        ADC DX, WORD PTR result[SI+4] ; CF + DX + F -> DX
        MOV WORD PTR result[SI+4], DX ; DX -> F
        XOR AX, AX
        ADC AX, WORD PTR result[SI+6] ; CF + AX + E -> AX
        MOV WORD PTR result[SI+6], AX ; AX -> E
        RETF
        MAIN ENDP
        codesg ENDS
        END MAIN
