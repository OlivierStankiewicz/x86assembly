.686
.model flat

extern _ExitProcess@4 : PROC
extern __write : PROC
public _main

.data
tekst db 12 dup (?)
podstawa_systemu dd 10
nowa_linia db 10

.code

wyswietl_EAX PROC
			pusha
; petla bin to dec i wpisania do pamieci w odwrotnej kolejnosci
			mov		edi, 0							; edi jest indexem tablicy
ptl:		mov		edx, 0							; edx jest zarezerwowany bo dzielenie
			div		podstawa_systemu

			add		dl, '0'							; dodanie kodu ascii '0' co konwertuje liczbe zawarta w dl na jej kod ascii
			mov		tekst[edi], dl

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
ptl_swap:	mov		dl, tekst[esi]					; pobranie litery z pamieci do dl
			xchg	dl, tekst[edi]					; swap znakow
			mov		tekst[esi], dl					; odeslanie litery z dl do pamieci
			inc		esi
			dec		edi
			dec		ecx
			jnz		ptl_swap


; wypisanie przetlumaczonej liczby
wypisanie:	pop		edi
			push	edi
			push	OFFSET tekst
			push	1
			call	__write
			add		esp, 12

			popa
			ret
wyswietl_EAX ENDP

wyswietl_nl PROC
			pusha

			push	1
			push	OFFSET nowa_linia
			push	1
			call	__write
			add		esp, 12

			popa
			ret
wyswietl_nl ENDP

_main PROC

			mov		eax, 1						; w eax zapisana jest poczatkowa liczba do wyswietlenia
			mov		ebx, 1

; petla wyswietlajaca 50 pierwszych elementow ciagu
			mov		ecx, 50
ptl_wysw:	call	wyswietl_EAX
			call	wyswietl_nl
			add		eax, ebx
			inc		ebx
			dec		ecx
			jnz		ptl_wysw


		push 0
		call _ExitProcess@4
_main ENDP
END