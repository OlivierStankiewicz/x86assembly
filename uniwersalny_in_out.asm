.686
.model flat

extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
limit_znakow_in dd 33
tekst_in db 33 dup (?)				; tu tez trzeba zmieniac limit znakow in

podstawa_systemu_in dd 12
maks_mala_litera_in db ?
maks_duza_litera_in db ?
maks_cyfra_in db ?

podstawa_systemu_out dd 10
tekst_out db 33 dup (?)				; tu trzba zmieniac limit znakow out ale write dostaje i tak tylko tyle ile ich jest bo licze w trakcie

kod_entera db 10

.code
wczytaj_do_EAX_dowolny PROC
; odlozenie na stos rejestrow ktore maja zostac zachowane
			push	ebx
			push	ecx
			push	edx

; pobranie liczby z konsoli
			push	limit_znakow_in
			push	OFFSET tekst_in
			push	0
			call	__read
			add		esp, 12

			mov		edx, podstawa_systemu_in
			dec		edx
			add		edx, '0'
			mov		maks_cyfra_in, dl
			sub		edx, '0'
			inc		edx

			add		dl, 'A'
			sub		dl, 11
			mov		maks_duza_litera_in, dl
			sub		dl, 'A'
			add		dl, 'a'
			mov		maks_mala_litera_in, dl

			mov		eax, 0					; index poczatkowa postac wyniku
			mov		ebx, OFFSET tekst_in	; adres tekstu
konw_in:	mov		cl, [ebx]				; pobranie kolejnego znaku z tekstu do cl
			inc		ebx						; zwiekszenie adresu i przejscie na adres kolejnego znaku bo s¹ 1-bajtowe
			cmp		cl, kod_entera			; sprawdzenie czy to enter
			je		koniec_tekstu			; jesli to enter to oznacza ze tekst sie skonczyl wiec wychodzimy z petli

			cmp		cl, '0'
			jb		konw_in					; skip mniejszych niz 0

			cmp		podstawa_systemu_in, 10	
			ja		litery_0				; jesli podstawa jest >10 to pomijam sprawdzanie czy znak jest wiekszy od podstawy liczbowo bo w takim systemie sa nie tylko liczby

			cmp		cl, maks_cyfra_in
			ja		konw_in					; skip cyfr wiekszych niz podstawa

litery_0:	cmp		cl, '9'
			ja		litery_1				; przejscie do sprawdzania liter

			sub		cl, '0'					; zamiana z kodu ASCII na liczbe
			
dopisz:		movzx	ecx, cl					; wyzerowanie reszty rejestru ecx
			mul		podstawa_systemu_in		; przemnozenie tego co do tej pory bylo w eax
			add		eax, ecx				; dodanie do wyniku kolejnej cyfry
			jmp		konw_in

litery_1:	cmp		cl, 'A'
			jb		konw_in					; skip zlych znakow
			cmp		cl, maks_duza_litera_in
			ja		litery_2				; skip zlych znakow
			sub		cl, 'A' - 10			; zamiana litery na liczbe
			jmp		dopisz

litery_2:	cmp		cl, 'a'
			jb		konw_in					; skip zlych znakow
			cmp		cl, maks_mala_litera_in
			ja		konw_in					; skip zlych znakow
			sub		cl, 'a' - 10			; zamiana litery na liczbe
			jmp		dopisz

koniec_tekstu:
; pobranie ze stosu zachowanych rejestrow
			pop		edx
			pop		ecx
			pop		ebx
			ret
wczytaj_do_EAX_dowolny ENDP

wyswietl_EAX_dowolny PROC
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
wyswietl_EAX_dowolny ENDP

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
			dec		esi
			cmp		esi, ecx						; sprawdzenie czy kropka ma byc tu
			jb		nie_tu

			mov		tekst_out[edi], byte ptr '.'	; jak znalazlem miejsce dla kropki
			inc		edi
tu:			mov		tekst_out[edi], byte ptr '0'
			inc		edi
			jmp		odwroc

nie_tu:		mov		tekst_out[edi], byte ptr '0'
			inc		edi
			jmp		src_kropka
			

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

			call	wczytaj_do_EAX_dowolny
			mov		ebx, eax
			call	wczytaj_do_EAX_dowolny
			mov		edx, 0
			mov		ecx, 1000
			mul		ecx
			div		ebx
			mov		cl, 3
			call	wyswietl_EAX_cl_precision

			push	0
			call	_ExitProcess@4
_main ENDP
END