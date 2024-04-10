.686
.XMM
.model flat
public _szybki_max

.code
_szybki_max PROC
		push	ebp
		mov		ebp, esp
		push	esi
		push	edi
		push	edx

		mov		eax, [ebp+20]			; n

; podzielenie n na 4 bo bierzemy po 4 liczby do maxowania, wiec po tym ecx jest licznikiem petli
		mov		edx, 0
		mov		ecx, 4
		div		ecx
		mov		ecx, eax

		mov		esi, [ebp+8]			; adres val1
		mov		edi, [ebp+12]			; adres val2
		mov		edx, [ebp+16]			; adres wynik

		mov		eax, 0					; index do adresowania tablic
ptl:	movups	xmm0, XMMWORD PTR [esi + eax*4]	; val1
		movups	xmm1, XMMWORD PTR [edi + eax*4]	; val2

		pmaxsd	xmm0, xmm1
		movups	[edx + eax*4], xmm0

		add		eax, 4
		loop ptl

		pop		ecx
		pop		edi
		pop		esi
		pop		ebp
		ret
_szybki_max ENDP
END