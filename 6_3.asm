; Wyświetlanie znaków * w takt przerwań zegarowych w trybie rzeczywistym procesora x86
; zakończenie programu - x
.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy

obsluga_zegara PROC
	push ax
	push bx
    push cx
    push dx
	push es

; wpisanie adresu pamięci ekranu do rejestru ES
; (zaczyna sie od B8000H, ale wpisujemy 1 zero mniej bo przy obliczaniu adresu automatycznie będzie mnożone przez 16)

	mov ax, 0B800h
	mov es, ax

	mov bx, cs:rzad ; 'rzad' zawiera numer rzedu gdzie chcemy wyswietlic znak
    mov ax, bx
    mov dx, 0
    mov cx, 160
    mul cx         ; mnozymy numer rzedu przez ta stala, co pozwala mam uzyskac adres pierwszego elementu w wym rzedzie
    mov bx, ax
    add bx, cs:kolumna  ; dodajemy numer kolumny, co daje nam faktyczny adres gdzie chcemy wpisac znak

; przesłanie do pamięci ekranu kodu ASCII znaku i jego atrybutów
	mov byte PTR es:[bx], '*'
	mov byte PTR es:[bx+1], 00000111B	; tło MRGB | znak IRGB

    mov ax, cs:rzad
    inc ax
    mov cs:rzad, ax
    mov dx, 0
    mov cx, 160
    mul cx
    add ax, cs:kolumna
    cmp ax, 4000
    jb  wysw_dalej

    mov ax, 1           ; bo nie ruszam pierwszego wiersza
    mov cs:rzad, ax
    mov ax, cs:kolumna
    add ax, 2
    mov cs:kolumna, ax
    cmp ax, 320
    jb  wysw_dalej
    
	mov ax, 0
    mov cs:kolumna, 0

	wysw_dalej:
	
	pop es
    pop dx
    pop cx
	pop bx
	pop ax

	jmp dword PTR cs:wektor8	; skok do oryginalnej procedury obsługi przerwania zegarowego

; dane programu ze względu na specyfikę obsługi przerwań
; umieszczone są w segmencie kodu
	
	wektor8 dd ?
    kolumna dw 0
    rzad  dw 1          ; bo zaczynam rysowanie od wiersza nr 2

obsluga_zegara ENDP


; program główny - instalacja i deinstalacja procedury obsługi przerwań
; ustalenie strony nr 0 dla trybu tekstowego
zacznij:
	mov al, 0
	mov ah, 5
	int 10

	mov ax, 0
	mov ds,ax ; zerowanie rejestru DS

; zapisanie zawartosci wektora 8 do zmiennej, wektor 8 zajmuje 4 bajty zaczynajac od adresu fizycznego 8*4=32
	mov eax,ds:[32]
	mov cs:wektor8, eax

; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
	mov ax, SEG obsluga_zegara ; część segmentowa adresu
	mov bx, OFFSET obsluga_zegara ; offset adresu

	cli ; zablokowanie przerwań
; zapisanie adresu procedury do wektora nr 8
	mov ds:[32], bx ; OFFSET
	mov ds:[34], ax ; cz. segmentowa
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
; odtworzenie oryginalnej zawartości wektora nr 8
	mov eax, cs:wektor8
	cli
	mov ds:[32], eax ; przesłanie wartości oryginalnej do wektora 8 w tablicy wektorów przerwań
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