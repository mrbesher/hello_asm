datasg  SEGMENT PARA 'veri'
dizi    DD 19011923, 19011080, 19011234, 19011312, 19011542, 19011545, 19011725, 19011736, 19011654, 19011642, 19011732, 19011004, 19011754, 19011340, 19011852, 19011842  ;ogrenci dizi
d1      DW 35  DUP(?)
d2      DW 35  DUP(?)
d3      DW 35  DUP(?)
d4      DW 35  DUP(?)
j       DW 0 ;dizilerdeki indisler
l       DW 0
m       DW 0
n       DW 0
datasg  ENDS
stacksg SEGMENT PARA STACK 'yigin'
        DW 20 DUP(?)
stacksg ENDS
codesg  SEGMENT PARA 'kod'
        ASSUME CS:codesg, SS:stacksg, DS:datasg
MAIN    PROC FAR
        ;EXE tipi komutlari
        PUSH DS
        XOR AX, AX
        PUSH AX
        MOV AX, datasg
        MOV DS, AX

        ;dongu icin SI'yi sifirla ve cx'e dongu sayisini ata
        XOR SI, SI
        MOV CX, 16

        ;Double degiskenin en anlamli ve az anlamli kisimlarini DIV icin AX, DX'e ata
lo1:    MOV AX, WORD PTR dizi[SI]
        MOV DX, WORD PTR dizi[SI+2]
        MOV BX, 1000
        DIV BX
        ;1000'e bolumden kalani AX'e al
        MOV AX, DX
        MOV BL, 10
        MOV BH, 100 ;10 ve 100 dogrudan bolunemez BL ve BH'e al
        XOR DL, DL ;toplam degiskenini sifirla

        ;birler basamagi
        PUSH AX
        DIV BL
        ADD DL, AH ;toplama birler basmagini ekle
        POP AX
        PUSH AX ;Ax'i koru

        ;onlar basamagi
        DIV BH
        MOV AL, AH ;kalani (AH'ta) al 10'a bol
        CBW ;bolmede Ax kullanilacak
        DIV BL
        ADD DL, AL ;bolumu toplama ekle

        ;100ler basamagi
        POP AX
        PUSH AX
        DIV BH ;100'e bol
        ADD DL, AL ;basamagi toplama ekle
        POP AX

        ;Ax'in LSB'ni CF'e al
        SHR AX, 1
        JC  tek
        RCL AX, 1 ;Ax'i eski haline dondur
        SHR DL, 1 ;toplam cift mi
        JC  toptek

        ;sayi cift toplam cift
        MOV DI, j ;d3 dizisinin indisini memeoryden al
        MOV d3[DI], AX
        ADD DI, 2
        MOV j, DI ;indise yeni degeri ata
        JMP devam
loopa:	JMP lo1
        ;sayi cift toplam tek
toptek: MOV DI, l ;d4 dizisinin indisini memeoryden al
        MOV d4[DI], AX
        ADD DI, 2
        MOV l, DI ;indise yeni degeri ata
        JMP devam

        ;sayi tek
tek:    RCL AX, 1 ;Ax'i eski haline dondur
        SHR DL, 1 ;toplam cift mi
        JNC topcift

        ;sayi tek toplam tek
        MOV DI, n ;d2 dizisinin indisini memeoryden al
        MOV d2[DI], AX
        ADD DI,2
        MOV n, DI ;indise yeni degeri ata
        JMP devam

        ;sayi tek toplam cift
topcift:MOV DI, m ;d1 dizisinin indisini memeoryden al
        MOV d1[DI], AX
        ADD DI, 2
        MOV m, DI ;indise yeni degeri ata
devam:  ADD SI, 4 ;Double oldugu icin 4 arttir
        LOOP loopa
        RETF
        MAIN ENDP
        codesg ENDS
        END MAIN
