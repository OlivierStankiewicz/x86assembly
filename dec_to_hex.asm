.686
.model flat

extern _ExitProcess@4 : PROC
extern __read : PROC
extern __write : PROC
public _main

.data
dekoder_hex db '0123456789ABCDEF'
tekst_in db 12 dup (?)
tekst_out db 12 dup (?)
podstawa_systemu dd 10
kod_entera db 10

.code
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

wyswietl_EAX_hex PROC
			pusha

			sub		esp, 8					; rezerwacja 8 bajtow na stosie na przechowywanie tymczasowo cyfr
			mov		edi, esp				; zapisanie w edi adresu zarezerwowanego obszaru
			
			mov		ecx, 8					; tyle bedzie obiegow petli, bo w EAX jest 8*4 bity
			mov		esi, 0					; index poczatowoy do zapisu cyfr

ptl_hex:	rol		eax, 4					; przesuniecie bitow liczby, tak by do 'ramki' odczytu weszly teraz rozpatrywane (w 1. obiegu beda to najstarsze)
			mov		ebx, eax				; skopiowanie eax do ebx zeby nie popsuc liczby w eax
			and		ebx, 0000000FH			; nalozenie maski na ebx tak zeby zostaly tylko 4 ostatnie bity czyli aktualnie rozpatrywana cyfra w hex

			mov		dl, dekoder_hex[ebx]	; zapisanie do dl odpowiedniej reprezentacji cyfry dla hex
			mov		[edi][esi], dl			; zapisanie do obszaru roboczego na stosie cyfry

			inc		esi
			loop	ptl_hex

			push	8
			push	edi
			push	1
			call	__write
			
			add		esp, 20					; wyczyszczenie stosu bo 8 bajtow zarezerwowane na znaki plus 12 dla __write

			popa
			ret
wyswietl_EAX_hex ENDP

_main PROC
			call	wczytaj_do_EAX

			call	wyswietl_EAX_hex

			push	0
			call	_ExitProcess@4
_main ENDP
END