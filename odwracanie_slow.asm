.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
magazyn_wejscie		db 80 dup (?)
magazyn_odwrocone	db 80 dup (?)
magazyn_utf			dw 80 dup (?)
liczba_znakow		dd ?
spacja				db ' '

liczba_polskich	dd 9
male_latin		db 0A5H,86H,0A9H,88H,0E4H,0A2H,98H,0ABH,0BEH
male_utf		dw 0105H, 0107H, 0119H, 0142H, 0144H, 00F3H, 015BH, 017AH, 017CH

tytul_utf16		dw 'Z','a','m','i','e','n','i','o','n','y',' ','t','e','k','s','t',' ','w','y','s','w','i','e','t','l','o','n','y',' '
				dw 'w',' ','k','o','d','o','w','a','n','i','u',' ','U','T','F','-','1','6', 0

.code
_main PROC
; pobranie tekstu do zamiany
			push	80
			push	OFFSET magazyn_wejscie
			push	0												; 0 to klawiatura
			call	__read
			add		esp, 12

			mov		liczba_znakow, eax

; glowna petla odwracania slow
			mov		ecx, liczba_znakow								; licznik glownej petli
			dec		ecx												; bo na koncu jest znak nowej linii
			mov		liczba_znakow, ecx
			mov		esi, liczba_znakow								; index startowy sprawdzania od tylu
			dec		esi												; bo indexowanie jest od 0 nie 1, a na koncu jeszcze jest znak nowej linii
			mov		edi, 0											; poczatkowy index dla bufora wynikowego
ptl_main:	mov		dl, magazyn_wejscie[esi]
			cmp		dl, spacja
			je		nowe_slowo
			dec		esi
			dec		ecx
			jnz		ptl_main


; petla szukajaca slowa i zapisujaca je do buforu wynikowego
nowe_slowo:	push	esi
			inc		esi
ptl_slowo:	mov		dl, magazyn_wejscie[esi]
			mov		magazyn_odwrocone[edi], dl
			cmp		dl, spacja
			je		koniec_slowa
			inc		edi
			inc		esi
			cmp		esi, liczba_znakow
			jne		ptl_slowo
			mov		magazyn_odwrocone[edi], ' '

koniec_slowa:inc	edi
			mov		magazyn_odwrocone[edi], ' '
			pop		esi
			dec		esi
			dec		ecx
			cmp		ecx, liczba_znakow
			jb		ptl_main


; wyswietlenie odwroconego tekstu
			push	liczba_znakow
			push	OFFSET magazyn_odwrocone
			push	1
			call	__write
			add		esp, 12


; glowna petla zamiana znakow iso na utf-16
			mov		ecx, liczba_znakow
			mov		ebx, 0														; index do tablicy iso
			mov		edi, 0														; index do tablicy utf
ptl_utf:	movzx 	dx, magazyn_wejscie[ebx]											; pobranie znaku
			;mov		esi, 0														; indeks tablicy przechodzacej po polskich, albo po sprawdzeniu sekwencji
spr_pol:	movzx 	dx, magazyn_wejscie[ebx]											; pobranie z pamieci z powrotem odpowiedniego znaku po nieudanym szukaniu sekwencji
			cmp		dx, 'z'
			ja		polskie_utf	


send_utf:	mov		magazyn_utf[edi*2], dx
			inc		ebx															; inkrementacja indeksu
			inc		edi
			dec		ecx
			jnz		ptl_utf													; sterowanie petla
			mov		magazyn_utf[edi*2], 0D83CH
			inc		edi
			mov		magazyn_utf[edi*2], 0DF1EH
			inc		edi
			mov		magazyn_utf[edi*2], 0


 ;wyswietlenie tekstu w MessageBoxW
			push	0															; stala MB_OK
			push	OFFSET tytul_utf16
			push	OFFSET magazyn_utf
			push	0															; NULL
			call	_MessageBoxW@16

			
			push 0
			call _ExitProcess@4


			push 0
			call _ExitProcess@4


; petla zamiany polskich znakow z latin na utf
polskie_utf:cmp		dl, male_latin[esi]
			jne		skip_utf
			mov		dx, male_utf[esi*2]
			jmp		send_utf
skip_utf:	inc		esi
			cmp		esi, liczba_polskich
			jne		polskie_utf
			jmp		send_utf


_main ENDP
END