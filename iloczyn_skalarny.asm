.686
.model flat
public _iloczyn_skalarny

.code
_iloczyn_skalarny PROC
		push ebp			; zapisanie zawartoœci EBP na stosie
		mov ebp,esp			; kopiowanie zawartoœci ESP do EBP
		push ebp
		push esi
		push edi
		
		mov esi, [ebp+8]	; adres tablicy tab1
		mov edi, [ebp+12]	; adres tablicy tab2
		mov ecx, [ebp+16]	; liczba elementów tablicy

		mov	ebx, 0			; wyzerowanie sumy

ptl:	mov eax, [esi]		; pobranie kolejnego elementu tablicy do eax
		mov	edx, 0
		imul dword ptr [edi]
		add	ebx, eax

		add	esi, 4
		add edi, 4			; wyznaczenie adresu kolejnego elementu
		loop ptl

		mov	eax, ebx

		pop edi
		pop esi
		pop ebx				; odtworzenie zawartoœci rejestrów
		pop ebp
		ret					; powrót do programu g³ównego
_iloczyn_skalarny ENDP
END