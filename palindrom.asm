.686
.model flat
public _isPalindrom

.code
_isPalindrom PROC
		push	ebp				; zapisanie zawartoœci EBP na stosie
		mov		ebp,esp			; kopiowanie zawartoœci ESP do EBP
		push	ebx				; przechowanie zawartoœci rejestru EBX


		mov		ebx, [ebp+8]	; adres tablicy znakow
		mov		ecx, [ebp+12]	; liczba elementów tablicy

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


koniec:	pop		ebx				; odtworzenie zawartoœci rejestrów
		pop		ebp
		ret						; powrót do programu g³ównego

prawda:	mov		eax, 1
		jmp		koniec

falsz:	mov		eax, 0
		jmp		koniec
_isPalindrom ENDP
END