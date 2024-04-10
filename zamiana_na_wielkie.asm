; wczytywanie w latin2 i zamiana na wielkie litery
; z uwzglednieniem polskich
; wyœwietlanie tekstu wielkimi literami w latin2, windows1250, utf-16

.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC
extern __read : PROC
extern _MessageBoxA@16 : PROC
extern _MessageBoxW@16 : PROC
public _main

.data
tekst_pocz		db 10, 'Prosze napisac jakis tekst i nacisnac Enter', 10
koniec_t		db ?

magazyn_latin	db 80 dup (?)
magazyn_windows	db 80 dup (?)
magazyn_utf16	dw 80 dup (?)
liczba_znakow	dd ?
tytul_windows	db 'Zamieniony tekst wyswietlony w kodowaniu Windows1250', 0
tytul_utf16		dw 'Z','a','m','i','e','n','i','o','n','y',' ','t','e','k','s','t',' ','w','y','s','w','i','e','t','l','o','n','y',' '
				dw 'w',' ','k','o','d','o','w','a','n','i','u',' ','U','T','F','-','1','6', 0

liczba_polskich	dd 9
male_latin		db 0A5H,86H,0A9H,88H,0E4H,0A2H,98H,0ABH,0BEH
duze_latin		db 0A4H,8FH,0A8H,9DH,0E3H,0E0H,97H,8DH,0BDH
duze_windows	db 0A5H,0C6H,0CAH,0A3H,0D1H,0D3H,8CH,8FH,0AFH
duze_utf16		dw 0104H, 0106H, 0118H, 0141H, 0143H, 00D3H, 015AH, 0179H, 017BH

.code
_main	PROC

; wypisanie tekstu poczatkowego
			mov		ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)		; stylistycznie powinno sie to dac do ecx przed pushem
			push	ecx
			push	OFFSET tekst_pocz
			push 1													; nr urzadzenia (tu ekran, czyli 1)
			call __write
			add esp, 12												; usuniecie parametrow ze stosu


; czytanie wiersza z klawiatury
			push	80												; maksymalna liczba znakow
			push	OFFSET magazyn_latin
			push	0												; nr urzadzenia (tu klawiatura, czyli 0)
			call	__read
			add		esp, 12											; usuniecie parametrow ze stosu

			mov		liczba_znakow, eax								; read wpisuje do eax liczbe wprowadzonych znakow		


; glowna petla zamiany znakow w latin2 na duze
			mov		ecx, eax										; ecx jest licznikiem obiegow petli
			mov		ebx, 0											; indeks poczatkowy glownej petli
ptl_latin:	mov		dl, magazyn_latin[ebx]							; pobranie znaku
			mov		esi, 0											; indeks tablicy przechodzacej po polskich
			cmp		dl, 'a'
			jb		dalej											; skok, gdy znak nie wymaga zamiany
			cmp		dl, 'z'
			ja		polskie_lat										; skok, gdy znak jest polski
			sub		dl, 20H											; zamiana na wielkie litery (w latin 2)

			
; odeslanie znaku w latin do pamieci
send_lat:	mov		magazyn_latin[ebx], dl
dalej:		inc		ebx
			dec		ecx
			jnz		ptl_latin


; wyswietlenie tekstu w _write
			push	liczba_znakow
			push	OFFSET magazyn_latin
			push	1
			call	__write
			add		esp,12											; usuniecie parametrow ze stosu


; glowna petla zamiana znakow latin2 na windows1250
			mov		ecx, liczba_znakow
			mov		ebx, 0
ptl_windows:mov		dl, magazyn_latin[ebx]							; pobranie znaku
			mov		esi, 0											; indeks tablicy przechodzacej po polskich
			cmp		dl, 'Z'
			ja		polskie_win			


; odeslanie znaku w windows do pamieci
send_win:	mov		magazyn_windows[ebx], dl
			inc		ebx												; inkrementacja indeksu
			dec		ecx
			jnz		ptl_windows										; sterowanie petla
			mov		magazyn_windows[ebx], 0							; przekazanie bajtu 0 zeby MessageBox wiedzial gdzie jest koniec


; wyswietlenie tekstu w MessageBoxA
			push	0												; stala MB_OK
			push	OFFSET tytul_windows
			push	OFFSET magazyn_windows
			push	0												; NULL
			call	_MessageBoxA@16


; glowna petla zamiana znakow latin2 na utf-16
			mov		ecx, liczba_znakow
			mov		ebx, 0
ptl_utf:	movzx 	dx, magazyn_latin[ebx]							; pobranie znaku
			mov		esi, 0											; indeks tablicy przechodzacej po polskich
			cmp		dx, 'Z'
			ja		polskie_utf			


; odeslanie znaku w UTF16 do pamieci
send_utf:	mov		magazyn_utf16[ebx*2], dx
			inc		ebx												; inkrementacja indeksu
			dec		ecx
			jnz		ptl_utf											; sterowanie petla
			mov		magazyn_utf16[ebx*2], 0							; przekazanie bajtu 0 zeby MessageBox wiedzial gdzie jest koniec


; wyswietlenie tekstu w MessageBoxW
			push	0												; stala MB_OK
			push	OFFSET tytul_utf16
			push	OFFSET magazyn_utf16
			push	0												; NULL
			call	_MessageBoxW@16


; zakonczenie programu
			push 0
			call _ExitProcess@4


; petla zamiany polskich znakow w latin na duze
polskie_lat:cmp		dl, male_latin[esi]
			jne		skip_latin
			mov		dl, duze_latin[esi]
			jmp		send_lat
skip_latin:	inc		esi
			cmp		esi, liczba_polskich
			jne		polskie_lat
			jmp		send_lat


; petla zamiany duzych polskich znakow z latin na windows
polskie_win:cmp		dl, duze_latin[esi]
			jne		skip_win
			mov		dl, duze_windows[esi]
			jmp		send_win
skip_win:	inc		esi
			cmp		esi, liczba_polskich
			jne		polskie_win
			jmp		send_win


; petla zamiany duzych polskich znakow z latin na utf
polskie_utf:cmp		dl, duze_latin[esi]
			jne		skip_utf
			mov		dx, duze_utf16[esi*2]
			jmp		send_utf
skip_utf:	inc		esi
			cmp		esi, liczba_polskich
			jne		polskie_utf
			jmp		send_utf


_main	ENDP
END