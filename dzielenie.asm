.686
.model flat
public _dzielenie

.code
_dzielenie PROC
		push	ebp				; zapisanie zawartoœci EBP na stosie
		mov		ebp,esp			; kopiowanie zawartoœci ESP do EBP
		push	ebx				; przechowanie zawartoœci rejestru EBX
		push	esi


		mov		ebx, [ebp+8]	; adres dzielnej w ebx
		mov		esi, [ebp+12]	; adres adresu dzielnika w esi
		mov		ecx, [esi]		; adres dzielnika w ecx


		
		mov		eax, [ebx]		; dzielna w eax
		mov		edx, 0
		bt		eax, 31
		jnc		dodat
		mov		edx, -1

dodat:	idiv	dword ptr [ecx]


		pop		esi
		pop		ebx				; odtworzenie zawartoœci rejestrów
		pop		ebp
		ret						; powrót do programu g³ównego
_dzielenie ENDP
END