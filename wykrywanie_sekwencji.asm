.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
public _main

.data
tekst_iso		db 'g',0EAH,'fajna g',0EAH,0B6H,'³ mordou'
koniec_tekstu	db ?
liczba_znakow	dd ?

szukana_sekw	db 'g',0EAH,0B6H

koniec_sekw		db ?
dlugosc_sekw	dd ?

nowa_sekw		dw 0D83EH, 0DD86H
koniec_nowej	dd ?
dlugosc_nowej	dd ?

ost_do_spr		dd ?

tekst_utf		dw 80 dup (?)
tytul_utf		dw 't','y','t','u','l'

liczba_polskich	dd 18
tab_polskie_iso	db 0B1H, 0A1H, 0E6H, 0C6H, 0EAH, 0CAH, 0B3H, 0A3H, 0F1H, 0D1H, 0F3H, 0D3H, 0B6H, 0A6H, 0BCH, 0ACH, 0BFH, 0AFH
tab_polskie_utf	dw 0105H, 0104H, 0107H, 0106H, 0119H, 0118H, 0142H, 0141H, 0144H, 0143H, 00F3H, 00D3H, 015BH, 015AH, 017AH, 0179H, 017CH, 017BH


.code
_main PROC

			mov		liczba_znakow, OFFSET koniec_tekstu - OFFSET tekst_iso		; zapisanie do pamieci liczby znakow
			mov		dlugosc_sekw, OFFSET koniec_sekw - OFFSET szukana_sekw
			mov		dlugosc_nowej, OFFSET koniec_nowej - OFFSET nowa_sekw
			mov		edx, 0
			mov		eax, dlugosc_nowej
			mov		ebx, 2
			div		ebx
			mov		dlugosc_nowej, eax											; zapisanie do pamieci faktycznej dlugosci nowej sekwencji w wordach
			mov		edx, liczba_znakow
			sub		edx, dlugosc_nowej
			mov		ost_do_spr, edx												; zapisanie do pamiêci ostatniego indexu ktory mam prawo sprawdzic
			

; glowna petla zamiana znakow iso na utf-16
			mov		ecx, liczba_znakow
			mov		ebx, 0														; index do tablicy iso
			mov		edi, 0														; index do tablicy utf
ptl_utf:	movzx 	dx, tekst_iso[ebx]											; pobranie znaku
			mov		esi, 0														; indeks tablicy przechodzacej po polskich, albo po sprawdzeniu sekwencji
			push	ebx															; zapisanie na stosie indeksu znaku na ktorym jestem przed sprawdzaniem sekwencji, bo ono przechodzi sobie dalej szukajac swojej sekwencji
			cmp		ebx, ost_do_spr
			jbe		spr_sekw
spr_pol:	pop		ebx
			movzx 	dx, tekst_iso[ebx]											; pobranie z pamieci z powrotem odpowiedniego znaku po nieudanym szukaniu sekwencji
			cmp		dx, 'z'
			ja		polskie_utf	


; odeslanie znaku w UTF16 do pamieci
send_utf:	mov		tekst_utf[edi*2], dx
			inc		ebx															; inkrementacja indeksu
			inc		edi
			dec		ecx
			jnz		ptl_utf														; sterowanie petla
			mov		tekst_utf[edi*2], 0											; przekazanie bajtu 0 zeby MessageBox wiedzial gdzie jest koniec
			

; wyswietlenie tekstu w MessageBoxW
			push	0															; stala MB_OK
			push	OFFSET tytul_utf
			push	OFFSET tekst_utf
			push	0															; NULL
			call	_MessageBoxW@16

			
			push 0
			call _ExitProcess@4


; petla zamiany polskich znakow z iso na utf
polskie_utf:cmp		dl, tab_polskie_iso[esi]
			jne		skip_utf
			mov		dx, tab_polskie_utf[esi*2]
			jmp		send_utf
skip_utf:	inc		esi
			cmp		esi, liczba_polskich
			jne		polskie_utf
			jmp		send_utf


; sprawdzenie sekwencji i ewentualne zamienienie		
spr_sekw:	cmp		dl, szukana_sekw[esi]
			jne		spr_pol
			inc		esi
			inc		ebx
			movzx	dx, tekst_iso[ebx]
			cmp		esi, dlugosc_sekw
			jne		spr_sekw

; wklejenie nowej sekwencji zamiast
			mov		esi, 0
ptl_zamiana:mov		dx, nowa_sekw[esi*2]
			mov		tekst_utf[edi*2], dx
			inc		edi
			inc		esi
			cmp		esi, dlugosc_nowej
			jne		ptl_zamiana
			jmp		ptl_utf


_main ENDP
END