.686
.XMM
.model flat
public _int2float

.code

_int2float PROC
		push ebp
		mov ebp, esp
		push esi
		push edi

		mov esi, [ebp+8]	; adres pierwszej tablicy
		mov edi, [ebp+12]	; adres tablicy wynikowej

		cvtpi2ps xmm5, qword PTR [esi]
		movups [edi], xmm5

		pop edi
		pop esi
		pop ebp
		ret
_int2float ENDP


END