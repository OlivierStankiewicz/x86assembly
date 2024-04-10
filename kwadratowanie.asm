.686
.model flat

extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
tekst_in db 12 dup (?)
tekst_out db 12 dup (?)
podstawa_systemu dd 10
kod_entera db 10

.code

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

wczytaj_do_EAX PROC
; odlozenie na stos rejestrow ktore maja zostac zachowane
			push	ebx
			push	ecx

; pobranie liczby z konsoli
			push	12
			push	OFFSET tekst_in
			push	0
			call	__read
			add		esp, 12

			mov		eax, 0					; index poczatkowy tablicy tekstu
			mov		ebx, OFFSET tekst_in	; adres tekstu
ptl_znaki:	mov		cl, [ebx]				; pobranie kolejnego znaku z tekstu do cl
			inc		ebx						; zwiekszenie adresu i przejscie na adres kolejnego znaku bo s¹ 1-bajtowe
			cmp		cl, kod_entera			; sprawdzenie czy to enter
			je		koniec_tekstu			; jesli to enter to oznacza ze tekst sie skonczyl wiec wychodzimy z petli
			sub		cl, '0'					; zamiana z kodu ASCII na liczbe
			movzx	ecx, cl					; wyzerowanie reszty rejestru ecx
			mul		podstawa_systemu		; przemnozenie tego co do tej pory bylo w eax
			add		eax, ecx				; dodanie do wyniku kolejnej cyfry
			jmp		ptl_znaki

koniec_tekstu:
; pobranie ze stosu zachowanych rejestrow
			pop		ecx
			pop		ebx
			ret
wczytaj_do_EAX ENDP

_main PROC

			call wczytaj_do_EAX

			mul		eax

			call wyswietl_EAX


			push 0
			call _ExitProcess@4
_main ENDP
END