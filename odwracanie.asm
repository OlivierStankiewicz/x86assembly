.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
tekst_pocz		db 10, 'Wpisz tekst ktory ma zostac odwrocony', 10
koniec_t		db ?

magazyn_znakow	db 80 dup (?)
liczba_znakow	dd ?

.code
_main PROC

; wypisanie tekstu powitalnego
			mov		ecx, OFFSET koniec_t - OFFSET tekst_pocz
			push	ecx
			push	OFFSET tekst_pocz
			push	1												; 1 to ekran
			call	__write
			add		esp, 12


; pobranie tekstu do zamiany
			push	80
			push	OFFSET magazyn_znakow
			push	0												; 0 to klawiatura
			call	__read
			add		esp, 12

			mov		liczba_znakow, eax




; glowna petla odwracania tekstu
			mov		edx, 0											; wyzerowanie edx przed dzieleniem
			mov		ebx, 2
			div		ebx
			mov		ecx, eax										; podzielenie ecx przez 2 bo chcemy zeby petla wykonala sie do polowy znakow
			mov		esi, 0											; indeks poczatkowy 'tablicy' znakow
			mov		edi, liczba_znakow
			sub		edi,2											; indeks koncowy 'tablicy' znakow
ptl_swap:	mov		dl, magazyn_znakow[esi]							; pobranie litery z pamieci do dl
			xchg	dl, magazyn_znakow[edi]							; swap znakow
			mov		magazyn_znakow[esi], dl							; odeslanie litery z dl do pamieci
			inc		esi
			dec		edi
			dec		ecx
			jnz		ptl_swap


; wyswietlenie odwroconego tekstu
			push	liczba_znakow
			push	OFFSET magazyn_znakow
			push	1
			call	__write
			add		esp, 12


		push 0
		call _ExitProcess@4
_main ENDP
END