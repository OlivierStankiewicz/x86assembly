.686
.model flat
public _odejmij_jeden

.code
_odejmij_jeden PROC
		push ebp			; zapisanie zawarto�ci EBP na stosie
		mov ebp,esp			; kopiowanie zawarto�ci ESP do EBP
		push ebx			; przechowanie zawarto�ci rejestru EBX

		mov ebx, [ebp+8]	; wpisanie do ebx adresu wskaznika do zmiennej z jezyka C

		mov eax, [ebx]		; wpisanie do eax adresu zmiennej w jezyku C

		dec	dword PTR [eax]	; odjecie 1
		mov [ebx], eax		; odes�anie wyniku do docelowego adresu
		
		pop ebx
		pop ebp
		ret
_odejmij_jeden ENDP
END