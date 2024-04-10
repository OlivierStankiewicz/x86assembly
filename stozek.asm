.686
.model flat
public _objetosc_stozka

.data
trzy	dd	3.0

.code
_objetosc_stozka PROC
		push	ebp
		mov		ebp,esp

		;[ebp+8]			uint big r
		;[ebp+12]			uint small r
		;[ebp+16]			float h

		finit

		fldz							; zaladowanie na stos poczatkowego wyniku

		fild		dword ptr [ebp+8]	; R na stos
		fmul	st(0), st(0)			; R do kwadratu
		faddp	st(1), st(0)			; wynik += R^2

		fild		dword ptr [ebp+8]	; R na stos
		fild		dword ptr [ebp+12]	; r na stos
		fmulp	st(1), st(0)			; R*r
		faddp	st(1), st(0)			; wynik += R*r

		fild		dword ptr [ebp+12]	; r na stos
		fmul	st(0), st(0)			; r do kwadratu
		faddp	st(1), st(0)			; wynik += r^2

		fld		dword ptr [ebp+16]		; h na stos
		fmulp	st(1), st(0)			; wynik *= h

		fldpi							; pi na stos
		fmulp	st(1), st(0)			; wynik *= pi

		fld		trzy					; 3 na stos
		fdivp	st(1), st(0)			; wynik /= 3



		pop ebp
		ret
_objetosc_stozka ENDP
END