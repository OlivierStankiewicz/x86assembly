.686
.model flat
public _find_max_range

.data
g	dd	9.81
dwa	dd	2
sto80 dd 180

.code
_find_max_range PROC
		push	ebp
		mov		ebp,esp

		;[ebp+8]			float v
		;[ebp+12]			float alpha

		finit

		fldz							; zaladowanie pocz. wyniku

		fld		dword ptr [ebp+8]		; v na stos
		fmul	st(0), st(0)			; v do kwadratu
		faddp	st(1), st(0)			; wynik += v^2

		fld		g						; g na stos
		fdivp	st(1), st(0)			; wynik	/= g

		fild		dword ptr [ebp+12]	; alpha na stos
		fild	sto80					; 180 na stos
		fdivp	st(1), st(0)			; alpha /= 180
		fldpi							; pi na stos
		fmulp	st(1), st(0)			; alpha *= pi

		fild	dwa						; 2 na stos
		fmulp	st(1), st(0)			; alpha *= 2
		fsin							; 2*alpha = sin(2*alpha)
		fmulp	st(1), st(0)			; wynik *= sin(2*alpha)

		pop ebp
		ret
_find_max_range ENDP
END