.686
.model flat

extern _ExitProcess@4 : PROC
extern __write : PROC
extern _MessageBoxW@16 : PROC
public _main

.data
podstawa_systemu_out dd 10
tekst_out db 33 dup (?)				; tu trzba zmieniac limit znakow out ale write dostaje i tak tylko tyle ile ich jest bo licze w trakcie

podstawa_systemu_msgbox dd 14
tekst_out_utf dw 80 dup (?)
tytul_utf		dw 'Z','a','m','i','e','n','i','o','n','a',' ','l','i','c','z','b','a', 0

kod_entera db 10

.code

wyswietl_EAX_dowolny_msgboxW PROC
			pusha
; petla bin to dec i wpisania do pamieci w odwrotnej kolejnosci
			mov		edi, 0							; edi jest indexem tablicy
ptl:		mov		edx, 0							; edx jest zarezerwowany bo dzielenie
			div		podstawa_systemu_msgbox

			cmp		dx, 9							; sprawdzenie czy to cyfra
			jbe		cyfra							; jak cyfra to skipuje zamiane na litere

			sub		dx, 10							; konwersja na litere
			add		dx, 'A'							; dalej
			jmp		dopisanie						; skoro to byla litera to skipuje zamiane na cyfre

cyfra:		add		dx, '0'							; dodanie kodu ascii '0' co konwertuje liczbe zawarta w dl na jej kod ascii

dopisanie:	mov	tekst_out_utf[edi*2], dx

			inc		edi								; zwiekszenie indexu tablicy gdzie zapisywane sa cyfry
			cmp		eax, 0							; sprawdzenie czy liczba sie skonczyla - podzielila sie bez zadnych calosci
			jnz		ptl

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
ptl_swap:	mov		dx, tekst_out_utf[esi*2]		; pobranie litery z pamieci do dl
			xchg	dx, tekst_out_utf[edi*2]		; swap znakow
			mov		tekst_out_utf[esi*2], dx		; odeslanie litery z dl do pamieci
			inc		esi
			dec		edi
			dec		ecx
			jnz		ptl_swap


; wypisanie przetlumaczonej liczby
wypisanie:	push	0												; stala MB_OK
			push	OFFSET tytul_utf
			push	OFFSET tekst_out_utf
			push	0												; NULL
			call	_MessageBoxW@16

			popa
			ret
wyswietl_EAX_dowolny_msgboxW ENDP

wyswietl_EAX_cl_precision PROC
			pusha
; petla bin to dec i wpisania do pamieci w odwrotnej kolejnosci
			mov		edi, 0							; edi jest indexem tablicy
ptl:		mov		edx, 0							; edx jest zarezerwowany bo dzielenie
			div		podstawa_systemu_out

			cmp		dl, 9							; sprawdzenie czy to cyfra
			jbe		cyfra							; jak cyfra to skipuje zamiane na litere

			sub		dl, 10							; konwersja na litere
			add		dl, 'A'							; dalej
			jmp		dopisanie						; skoro to byla litera to skipuje zamiane na cyfre

cyfra:		add		dl, '0'							; dodanie kodu ascii '0' co konwertuje liczbe zawarta w dl na jej kod ascii

dopisanie:	mov		tekst_out[edi], dl

			inc		edi								; zwiekszenie indexu tablicy gdzie zapisywane sa cyfry

			movzx	ecx, cl
			cmp		edi, ecx
			jne		niekropka
			mov		tekst_out[edi], byte ptr '.'
			inc		edi

niekropka:	cmp		eax, 0							; sprawdzenie czy liczba sie skonczyla - podzielila sie bez zadnych calosci
			jne		ptl

spr:		mov		esi, edi						; esi bedzie do sprawdzania miesjca kropki, kiedy esi == ecx to tam jest kropka
			dec		esi
			cmp		esi, ecx						; sprawdzenie czy juz dobrze dodal kropke			
			ja		odwroc
			je		tu

; petla szukania miejsca kropki
src_kropka:	mov		esi, edi						; esi bedzie do sprawdzania miesjca kropki, kiedy esi == ecx to tam jest kropka
			cmp		esi, ecx						; sprawdzenie czy kropka ma byc tu
			jb		nie_tu

			mov		tekst_out[edi], byte ptr '.'	; jak znalazlem miejsce dla kropki
			inc		edi
			mov		tekst_out[edi], byte ptr '0'
			inc		edi
			jmp		odwroc

nie_tu:		mov		tekst_out[edi], byte ptr '0'
			inc		edi
			jmp		src_kropka

tu:			mov		tekst_out[edi], byte ptr '0'
			inc		edi
			jmp		odwroc			

odwroc:		push	edi								; zapisuje sobie edi na stosie, bo tam przy okazji tej zamiany znajduje sie po petli liczba cyfr liczby


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
wyswietl_EAX_cl_precision ENDP

wyswietl_nl PROC
			pusha

			push	1
			push	OFFSET kod_entera
			push	1
			call	__write
			add		esp, 12

			popa
			ret
wyswietl_nl ENDP

_main PROC
			mov		eax, 15

			mov		cl, 1
			call	wyswietl_EAX_cl_precision
			call	wyswietl_nl

			mov		cl, 2
			call	wyswietl_EAX_cl_precision
			call	wyswietl_nl

			mov		cl, 3
			call	wyswietl_EAX_cl_precision
			call	wyswietl_nl

			mov		cl, 4
			call	wyswietl_EAX_cl_precision
			call	wyswietl_nl

			mov		eax, 28
			call	wyswietl_EAX_dowolny_msgboxW

			push	0
			call	_ExitProcess@4
_main ENDP
END