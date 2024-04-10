.686
.model flat
public _swap

.code
_swap PROC
		push	ebp				; zapisanie zawarto�ci EBP na stosie
		mov		ebp,esp			; kopiowanie zawarto�ci ESP do EBP
		push	ebx				; przechowanie zawarto�ci rejestru EBX
		push	esi
		push	edi


		mov		ebx, [ebp+8]	; adres tablicy tabl
		mov		ecx, [ebp+12]	; liczba element�w tablicy
		mov		esi, [ebp+16]	; index pierwszego do swapa
		mov		edi, [ebp+20]	; index drugiego do swapa

; sprawdzenie czy ktorys index wychodzi
		dec		ecx
		cmp		esi, ecx
		ja		blad
		cmp		esi, 0
		jb		blad
		cmp		edi, ecx
		ja		blad
		cmp		edi, 0
		jb		blad

; zamiana element�w tablicy miejscami
		mov		edx, [ebx+4*esi]
		xchg	edx, [ebx+4*edi]
		mov		[ebx+4*esi], edx

		mov		eax, 1
koniec:	pop		edi
		pop		esi
		pop		ebx
		pop		ebp
		ret					; powr�t do programu g��wnego

blad:	mov		eax, 0
		jmp		koniec
_swap ENDP
END