.686
.model flat

extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
limit_znakow_in dd 33
tekst_in db 33 dup (?)				; tu tez trzeba zmieniac limit znakow in

podstawa_systemu_in dd 13
maks_mala_litera_in db ?
maks_duza_litera_in db ?
maks_cyfra_in db ?
ujemna_in db ?

podstawa_systemu_out dd 13
tekst_out db 33 dup (?)				; tu trzba zmieniac limit znakow out ale write dostaje i tak tylko tyle ile ich jest bo licze w trakcie
ujemna_out db ?

kod_entera db 10

.code
wczytaj_do_EAX_dowolny_u2 PROC
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

; ustawienie w zmiennych jaka jest maksymalna cyfra i litera w danym systemie
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

; ustawienie poczatkowych wartosci
			mov		eax, 0					; poczatkowa postac wyniku
			mov		ebx, OFFSET tekst_in	; adres tekstu

; sprawdzenie czy na poczatku jest minus
			mov		ujemna_in, 0			; wyzerowanie boola ujemna_in, bo jak kilka razy wywolamy podprogram to zawsze musimy zaczynac od false
			mov		cl, [ebx]				; pobranie pierwszego znaku
			cmp		cl, '-'					; sprawdzenie czy jest to minus
			jne		konw_in					; jesli nie to skipujemy do normalnej konwersji
			mov		ujemna_in, 1			; skoro byl, to ustawiamy bool ujemna_in na true
			inc		ebx						; zwiekszamy ebx zeby w normalnej konwersji nie brac pod uwage znaku minusa

; glowna petla konwersji
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
; obsluga ujemnych
			cmp		ujemna_in, 1			; czy byl wczytany minus na poczatku liczby
			jne		ende					; jesli nie to skipuje zamiane na u2
			neg		eax						; konwersja eax na u2

; pobranie ze stosu zachowanych rejestrow
ende:		pop		edx
			pop		ecx
			pop		ebx
			ret
wczytaj_do_EAX_dowolny_u2 ENDP

wyswietl_EAX_dowolny_u2 PROC
			pusha

			mov		edi, 0							; edi jest indexem tablicy tekstu wychodzacego

			mov		ujemna_out, 0					; wyzerowanie boola ujemna_out, bo jak kilka razy wywolamy podprogram to zawsze musimy zaczynac od false
			bt		eax, 31							; sprawdzenie jaki jest najstarszy bit w eax
			jnc		ptl								; jesli byl 0 to normalnie konwertujemy
			neg		eax								; skoro byl 1 to liczba jest ujemna wiec zamieniamy ja na dodatnia
			mov		ujemna_out, 1					; i zapisujemy w boolu ujemna_out, ze na koniec musimy dopisac minus

; petla bin to dec i wpisania do pamieci w odwrotnej kolejnosci
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

; jesli bool ujemna_out jest true to dopisujemy minus na koniec i zwiekszamy liczbe znakow ktore maja zostac wypisane
spr_ujemn:	cmp		ujemna_out, 1
			jne		odwracanie
			mov		tekst_out[edi], byte ptr '-'
			inc		edi



; petla odwracania tekstu
odwracanie:	push	edi								; zapisuje sobie edi na stosie, bo tam przy okazji tej zamiany znajduje sie po petli liczba cyfr liczby
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
wyswietl_EAX_dowolny_u2 ENDP

_main PROC
			call	wczytaj_do_EAX_dowolny_u2
			mov		ebx, eax
			call	wczytaj_do_EAX_dowolny_u2
			imul	ebx
			call	wyswietl_EAX_dowolny_u2

			call	wczytaj_do_EAX_dowolny_u2
			sub		eax, 5
			call	wyswietl_EAX_dowolny_u2

			push	0
			call	_ExitProcess@4
_main ENDP
END