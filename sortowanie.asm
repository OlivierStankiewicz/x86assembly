.686
.model flat
public _przestaw

.code
_przestaw PROC
		push ebp			; zapisanie zawartoœci EBP na stosie
		mov ebp,esp			; kopiowanie zawartoœci ESP do EBP
		push ebx			; przechowanie zawartoœci rejestru EBX


		mov ebx, [ebp+8]	; adres tablicy tabl
		mov ecx, [ebp+12]	; liczba elementów tablicy
		dec ecx				; bo powtorzen petli o 1 mniej niz elementow w tablicy

ptl:	mov eax, [ebx]		; pobranie kolejnego elementu tablicy do eax
		cmp eax, [ebx+4]	; porowananie elementu tablicy z nastepnym
		jle gotowe			; skok, gdy nie ma przestawiania

; zamiana s¹siednich elementów tablicy
		mov edx, [ebx+4]
		mov [ebx], edx
		mov [ebx+4], eax

gotowe:	add ebx, 4			; wyznaczenie adresu kolejnego elementu
		loop ptl


		pop ebx				; odtworzenie zawartoœci rejestrów
		pop ebp
		ret					; powrót do programu g³ównego
_przestaw ENDP
END