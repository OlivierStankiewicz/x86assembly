.686
.model flat

extern _ExitProcess@4 : PROC
extern __read : PROC
public _main

.data
tekst db 12 dup (?)
podstawa_systemu dd 10
kod_entera db 10

.code
wczytaj_do_EAX PROC
; odlozenie na stos rejestrow ktore maja zostac zachowane
			push	ebx
			push	ecx

; pobranie liczby z konsoli
			push	12
			push	OFFSET tekst
			push	0
			call	__read
			add		esp, 12

			mov		eax, 0					; index poczatkowy tablicy tekstu
			mov		ebx, OFFSET tekst		; adres tekstu
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

			push 0
			call _ExitProcess@4
_main ENDP
END