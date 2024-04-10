; Wyświetlanie znaków * w takt przerwań zegarowych w trybie rzeczywistym procesora x86
; zakończenie programu - x
.386
rozkazy SEGMENT use16
    ASSUME CS:rozkazy


obsluga_klawiatury PROC
    ;push ax
	;push bx
	;push es

    in al, 60H  ; wczytanie do al kodu wcisnietego klawisza
    call wyswietl_AL

	;pop es
	;pop bx
	;pop ax

	jmp dword PTR cs:wektor9	; skok do oryginalnej procedury obsługi przerwania zegarowego

; dane programu ze względu na specyfikę obsługi przerwań
; umieszczone są w segmencie kodu
	
	wektor9 dd ?

obsluga_klawiatury ENDP

wyswietl_AL PROC
; wyświetlanie zawartości AL na ekranie wg adresu ES:BX
; stosowany jest bezpośredni zapis do pamięci ekranu
    push ax
    push bx
    push cx
    push dx

    mov bx, 0B800h
	mov es, bx

    mov bx, 0

    mov cl, 10  ; dzielnik
    mov ah, 0   ; zerowanie starszej części dzielnej
    div cl      ; dzielenie AX przez CL, iloraz w AL, reszta w AH

    add ah, 30H ; zamiana na kod ASCII
    mov es:[bx+4], ah ; cyfra jedności

    mov ah, 0
    div cl ; drugie dzielenie przez 10

    add ah, 30H ; zamiana na kod ASCII
    mov es:[bx+2], ah ; cyfra dziesiątek

    add al, 30H ; zamiana na kod ASCII
    mov es:[bx+0], al ; cyfra setek

; wpisanie znakow do pamieci ekranu
    mov al, 00001111B
    mov es:[bx+1],al
    mov es:[bx+3],al
    mov es:[bx+5],al

    pop dx
    pop cx
    pop bx
    pop ax
    ret
wyswietl_AL ENDP

; program główny - instalacja i deinstalacja procedury obsługi przerwań
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
	mov al, 0
	mov ah, 5
	int 10

	mov ax, 0
	mov ds,ax ; zerowanie rejestru DS

; zapisanie zawartosci wektora9 do zmiennej, wektor9 zajmuje 4 bajty zaczynajac od adresu fizycznego 9*4=36
	mov eax,ds:[36]
	mov cs:wektor9, eax

; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
	mov ax, SEG obsluga_klawiatury      ; część segmentowa adresu
	mov bx, OFFSET obsluga_klawiatury   ; offset adresu

	cli ; zablokowanie przerwań
; zapisanie adresu procedury do wektora nr 9
	mov ds:[36], bx ; OFFSET
	mov ds:[38], ax ; cz. segmentowa
	sti ;odblokowanie przerwań

; oczekiwanie na naciśnięcie klawisza 'x'
aktywne_oczekiwanie:
	mov ah,1
	int 16H		; INT 16H (AH=1) BIOSu ustawia ZF=1 jesli nacisnieto jakis klawisz
	jz aktywne_oczekiwanie

; odczytanie kodu ASCII naciśniętego klawisza (INT 16H, AH=0) do rejestru AL
	mov ah, 0
	int 16H
	cmp al, 'x'
	jne aktywne_oczekiwanie

; deinstalacja procedury obsługi przerwania zegarowego
; odtworzenie oryginalnej zawartości wektora nr 9
	mov eax, cs:wektor9
	cli
	mov ds:[36], eax ; przesłanie wartości oryginalnej do wektora 9 w tablicy wektorów przerwań
	sti

; zakończenie programu
	mov al, 0
	mov ah, 4CH
	int 21H
rozkazy ENDS

nasz_stos SEGMENT stack
	db 128 dup (?)
nasz_stos ENDS

END zacznij