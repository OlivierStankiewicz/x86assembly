.686
.model flat
public _nowy_exp

.data
jeden	dd 1.0

.code
_nowy_exp PROC
		push	ebp
		mov		ebp,esp

		mov		ecx, 20					; licznik powtorzen petli

		finit

		fldz							; poczatkowa wartosc sumy
		fld1							; liczba przez ktora trzeba przemnozyc mianownik
		fld1							; wpisanie wartoœci pocz¹tkowej mianownika
		fld1							; wpisanie wartosci poczatkowej licznika

ptl:	fld		st(0)					; skopiowanie licznika
		fdiv	st(0), st(2)			; podzielenie licznika przez mianownik
		faddp	st(4), st(0)			; dodanie wyniku do sumy i usuniecie tego wyniku

		fld		dword PTR [ebp+8]		; zaladowanie x na stos
		fmulp	st(1), st(0)			; domno¿enie licznika przez x i usuniecie tego x ze stosu

		fld		st(2)					; skopiowanie na wierzcholek stosu liczby do domnozenia mianownika
		fmulp	st(2), 	st(0)			; domno¿enie mianownika przez kolejn¹ liczbe

		fld1							; zaladowanie 1 na stos
		faddp	st(3), st(0)			; dodanie 1 do liczby do kolejnego mnozenia mianownika
		loop ptl

; oczyszczenie stosu
		fstp	st(0)
		fstp	st(0)
		fstp	st(0)

		pop ebp
		ret
_nowy_exp ENDP
END