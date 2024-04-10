.686
.model flat
public _isPalindrom

.code
_isPalindrom PROC
		push	ebp				; zapisanie zawarto�ci EBP na stosie
		mov		ebp,esp			; kopiowanie zawarto�ci ESP do EBP
		push	ebx				; przechowanie zawarto�ci rejestru EBX


		mov		ebx, [ebp+8]	; adres tablicy znakow
		mov		ecx, [ebp+12]	; liczba element�w tablicy

		cmp		ecx, 1
		jbe		prawda

		mov		dx, word ptr [ebx]
		cmp		dx, word ptr [ebx+2*ecx-2]
		jne		falsz

		sub		ecx, 2
		add		ebx, 2
		push	ecx
		push	ebx
		call	_isPalindrom
		add		esp, 8


koniec:	pop		ebx				; odtworzenie zawarto�ci rejestr�w
		pop		ebp
		ret						; powr�t do programu g��wnego

prawda:	mov		eax, 1
		jmp		koniec

falsz:	mov		eax, 0
		jmp		koniec
_isPalindrom ENDP
END