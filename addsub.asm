.686
.XMM
.model flat
public _pm_jeden

.data
jedynki dd 1.0, 1.0, 1.0, 1.0

.code

_pm_jeden PROC
		push ebp
		mov ebp, esp
		push esi

		mov esi, [ebp+8]	; adres tablicy

		movups xmm0, [esi]
		movups xmm1, jedynki

		addsubps	xmm0, xmm1
		movups	[esi], xmm0

		pop esi
		pop ebp
		ret
_pm_jeden ENDP


END