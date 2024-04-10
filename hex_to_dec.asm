.686
.model flat

extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
tekst_out db 12 dup (?)
podstawa_systemu dd 10
kod_entera db 10

.code
wczytaj_do_EAX_hex PROC
			push	ebx
			push	ecx
			push	edx
			push	esi
			push	edi
			push	ebp

			sub		esp, 12				; zarezerwowanie na stosie 12 bajtow na przechowanie cyfr w 16
			mov		esi, esp			; zapisanie adresu zarezerwowanego obszaru

			push	dword ptr 10		; te dword ptr sa stylistyczne ale warto
			push	esi
			push	dword ptr 0
			call	__read

			add		esp, 12				; usuwamy parametry dane do reada ze stosu

			mov		eax, 0				; rejestr wynikowy

konwersja:	mov		dl, [esi]			; pobranie kolejnego bajtu
			inc		esi					; inkrementacja indexu
			cmp		dl, kod_entera
			je		koniec

			cmp		dl, '0'
			jb		konwersja			; skip zepsutych znakow
			cmp		dl, '9'
			ja		litery_1			; skip do konwersji liter
			sub		dl, '0'				; zamiana kodu ASCII cyfry na ta cyfre

dopisz:		shl		eax, 4				; przesuniecie logiczne o 4 bity
			or		al, dl				; zapisanie do 4 mlodszych bitow al tego co jest w dl
			jmp		konwersja

litery_1:	cmp		dl, 'A'
			jb		konwersja			; skip zepsutych znakow
			cmp		dl, 'F'
			ja		litery_2
			sub		dl, 'A' - 10		; zamiana litery na liczbe
			jmp		dopisz

litery_2:	cmp		dl, 'a'
			jb		konwersja			; skip zepsutych znakow
			cmp		dl, 'f'
			ja		konwersja			; skip zepsutych znakow
			sub		dl, 'a' - 10		; zamiana litery na liczbe
			jmp		dopisz

koniec:		add		esp, 12

			pop		ebp
			pop		edi
			pop		esi
			pop		edx
			pop		ecx
			pop		ebx
			ret
wczytaj_do_EAX_hex ENDP

wyswietl_EAX PROC
			pusha
; petla bin to dec i wpisania do pamieci w odwrotnej kolejnosci
			mov		edi, 0							; edi jest indexem tablicy
ptl:		mov		edx, 0							; edx jest zarezerwowany bo dzielenie
			div		podstawa_systemu

			add		dl, '0'							; dodanie kodu ascii '0' co konwertuje liczbe zawarta w dl na jej kod ascii
			mov		tekst_out[edi], dl

			inc		edi								; zwiekszenie indexu tablicy gdzie zapisywane sa cyfry
			cmp		eax, 0							; sprawdzenie czy liczba sie skonczyla - podzielila sie bez zadnych calosci
			jnz		ptl
			push	edi								; zapisuje sobie edi na stosie, bo tam przy okazji tej zamiany znajduje sie po petli liczba cyfr liczby


; petla odwracania tekstu
			mov		eax, edi						; w edi jest liczba znakow
			mov		ebx, 2									
			mov		edx, 0							; wyzerowanie edx przed dzieleniem
			div		ebx								; podzielenie ecx przez 2 bo chcemy zeby petla wykonala sie do polowy znakow
			cmp		eax, 0
			jz		wypisanie
			mov		ecx, eax						; przeniesienie podzielonej wartosci do ecx ktory bedzie licznikem petli
			mov		esi, 0							; indeks poczatkowy 'tablicy' znakow
			sub		edi,1							; osiagniecie indeksu koncowego 'tablicy' znakow, bo jest on o 1 mniejszy niz liczba tych znakow
ptl_swap:	mov		dl, tekst_out[esi]				; pobranie litery z pamieci do dl
			xchg	dl, tekst_out[edi]				; swap znakow
			mov		tekst_out[esi], dl				; odeslanie litery z dl do pamieci
			inc		esi
			dec		edi
			dec		ecx
			jnz		ptl_swap


; wypisanie przetlumaczonej liczby
wypisanie:	pop		edi
			push	edi
			push	OFFSET tekst_out
			push	1
			call	__write
			add		esp, 12

			popa
			ret
wyswietl_EAX ENDP

_main PROC
			call	wczytaj_do_EAX_hex
			call	wyswietl_EAX

			push	0
			call	_ExitProcess@4
_main ENDP
END