.686
.model flat
public _dylatacja_czasu

.data
predkosc_swiatla	dd	300000000

.code
_dylatacja_czasu PROC
		push	ebp
		mov		ebp,esp

		;[ebp+8]			int delta t
		;[ebp+12]			float v

		finit

		fild	dword PTR [ebp+8]		; zaladowanie licznika

		fld1							; zaladowanie pocz. wyniku

		fld		dword PTR [ebp+12]		; v
		fmul	st(0), st(0)			; v do kwadratu

		fild	predkosc_swiatla		; c
		fmul	st(0), st(0)			; c do kwadratu

		fdivp	st(1), st(0)			; v^2 = v^2 / c^2

		fsubp	st(1), st(0)			; wynik = 1 - (v^2 / c^2)

		fsqrt							; robi pierwiastek z mianownika

		fdivp st(1), st(0)

		pop ebp
		ret
_dylatacja_czasu ENDP
END