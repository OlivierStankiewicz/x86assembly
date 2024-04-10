.686
.model flat
public _srednia_harm

.code
_srednia_harm PROC
		push	ebp
		mov		ebp,esp
		push	edi
		push	ebx

		mov		edi, 0					; index do przechodzenia po elementach tabl
		mov		ebx, [ebp+8]			; adres tablicy tabl
		mov		ecx, [ebp+12]			; liczba element�w tablicy

		finit

		fild	dword PTR [ebp+12]		; wpisanie na stos koprocesora liczby n kt�ra jest licznikiem
		fldz							; wpisanie warto�ci pocz�tkowej mianownika
ptl:	fld1							; wpisanie 1 jako licznik u�amka b�d�cego cz�ci� sumy w mianowniku
		fld		dword PTR [ebx+4*edi]	; wczytanie z tablicy liczby, kt�ra jest mianownikiem u�amka w sumie w mianowniku
		fdivp	st(1), st(0)			; podzielenie 1 przez liczbe z tablicy, zapisania tego tam gdzie bylo 1 i usuniecie tej liczby pochodzacej z tablicy
		faddp	st(1), st(0)			; dodanie wyniku do sumy mianownika
		inc		edi
		loop ptl

		fdivp	st(1), st(0)			; podzielenie n przez obliczony mianownik


		pop		ebx
		pop		edi
		pop		ebp
		ret
_srednia_harm ENDP
END