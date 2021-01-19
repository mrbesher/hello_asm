section .data

section .text

global doInterview

doInterview:
		PUSH ebp
		MOV ebp, esp
		PUSH esi
		PUSH ecx
		PUSH edi
		
		MOV esi, [ebp+8] ;get the address of notlar
		MOV ecx, [ebp+12] ;get n
outlo:		MOV eax, [ebp+12]
		SUB eax, ecx
		PUSH ecx
		MOV ecx, [ebp+12]
		SUB ecx, eax
		MOV esi, [ebp+8] ; get the address of the array again
inner:		MOV eax, [esi+4]
		CMP eax, [esi+12]
		JAE cont
		XCHG eax, [esi+12] ; swap the points of the students
		MOV [esi+4], eax
		MOV eax, [esi]
		XCHG eax, [esi+8] ; swap the student IDs
		MOV [esi], eax
cont:		ADD esi, 8
		LOOP inner
		POP ecx
		LOOP outlo
		
		; The array is sorted now. Determine if the student satisfies the conditions
		MOV esi, [ebp+8] ;get the address of notlar
		MOV ecx, [ebp+12] ;get n
		MOV eax, [ebp+16] ;get stdno
		XOR edi, edi
		SHR ecx, 2 ;divide by 4 since we care only about the top quarter
searchlo:	CMP edi, ecx ; i<n
		JAE fail
		CMP eax, [esi] ; a[i] == stdno
		JNZ notfound
		JMP found
notfound:	INC edi
		ADD esi, 8
		JMP searchlo
found:		MOV eax, [esi+4]
		CMP eax, 80
		JBE fail
		MOV eax, 1
		JMP done
fail:		MOV eax, 0
done:		POP edi
		POP ecx
		POP esi
		POP ebp
		RET
