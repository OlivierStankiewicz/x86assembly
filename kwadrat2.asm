; Program linie.asm
; Wyświetlanie pionowych linii w różnych kolorach (w takt przerwań zegarowych)
.386
rozkazy SEGMENT use16
        ASSUME cs:rozkazy

obsluga_klawiatury PROC

        push cx

        in al, 60H  ; wczytanie do al kodu wcisnietego klawisza

        cmp al, 19  ; kod wcisnietego "r"
        jne czy_puszczono

        inc cs:czerwony
        jmp siema

czy_puszczono:
        cmp al, 147
        jne siema
        mov cs:czerwony, 0

siema:  pop cx

        jmp dword PTR cs:wektor9	; skok do oryginalnej procedury obsługi przerwania zegarowego

	
	wektor9 dd ?

obsluga_klawiatury ENDP

kwadrat PROC
        push ax
        push bx
        push cx
        push dx
        push es
        mov ax, 0A000H              ; adres pamięci ekranu dla trybu 13H
        mov es, ax

; sprawdzenie czy jest to co 5 obieg
        sub cs:rysowac, 1
        jnz wyjscie

        mov cs:rysowac, 5

; sprawdzenie czy teraz jest widoczny kwadrat
        xor cs:widoczny, 1
        cmp cs:widoczny, 0
        jne kolorowy
        mov cs:kolor, 0
        jmp ustawianie

; ustawienie odpowiedniego koloru kwadratu
kolorowy:cmp cs:czerwony, 20
        ja  czerw
        mov cs:kolor, 14
        jmp ustawianie

czerw:  mov cs:kolor, 4

; narysowanie kwadratu
ustawianie:  mov ax, cs:start_y
        mov dx, 0
        mov cx, 320
        mul cx
        mov bx, ax
        add bx, cs:start_x
        mov cs:adres_piksela, bx

        mov cl, cs:kolor    ; cl zawiera kod koloru
rysuj:  mov bx, cs:adres_piksela
        mov es:[bx], cl

        mov ax, bx

; sprawdzenie czy trzeba przejsc do nastepnej linii
        mov dx, 0
        mov bx, 320
        div bx

        mov bx, cs:start_x
        add bx, cs:dlugosc_boku
        cmp bx, dx
        jne skip       ; znaczy ze nie trzeba przechodzic do kolejnej linijki

; sprawdzenie czy to koniec kwadratu
        mov bx, cs:start_y
        add bx, cs:dlugosc_boku
        cmp bx, ax
        je  wyjscie     ; znaczy ze caly kwadrat narysowany

; przestawienie adresu na poczatek kolejnej linijki
        mov ax, cs:adres_piksela
        sub ax, cs:dlugosc_boku
        add ax, 320
        mov cs:adres_piksela, ax
        jmp rysuj

skip:   mov ax, cs:adres_piksela
        inc ax
        mov cs:adres_piksela, ax
        jmp rysuj

        

wyjscie:pop es
        pop dx
        pop cx
        pop bx
        pop ax

        jmp dword PTR cs:wektor8

        kolor db 14                  ; bieżący numer koloru
        wektor8 dd ?
        start_x dw 30
        start_y dw 30
        dlugosc_boku dw 50
        rysowac db 5                ; licznik czy w tym przerwaniu trzeba rysowac kwadrat na nowo
        adres_piksela dw ?
        czerwony db 0
        widoczny db 0
kwadrat ENDP

; INT 10H, funkcja nr 0 ustawia tryb sterownika graficznego
zacznij:
        mov ah, 0
        mov al, 13H                 ; nr trybu
        int 10H
        mov bx, 0
        mov es, bx
        mov eax, es:[32]
        mov cs:wektor8, eax
        mov ax, SEG kwadrat
        mov bx, OFFSET kwadrat
        cli

; zapisanie adresu procedury 'kwadrat' do wektora nr 8
        mov es:[32], bx
        mov es:[32+2], ax
        sti

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


czekaj:
        mov ah, 1                   ; sprawdzenie czy jest jakiś znak w buforze klawiatury
        int 16h
        jz czekaj

        mov ah, 0
	int 16H
        cmp al, 'x'
	jne czekaj

        mov ah, 0                   ; funkcja nr 0 ustawia tryb sterownika
        mov al, 3H                  ; nr trybu
        int 10H

        mov eax, cs:wektor8
        mov es:[32], eax

; odtworzenie oryginalnej zawartości wektora nr 9
	mov eax, cs:wektor9
	cli
	mov ds:[36], eax ; przesłanie wartości oryginalnej do wektora 9 w tablicy wektorów przerwań
	sti

; zakończenie wykonywania programu
        mov ax, 4C00H
        int 21H
rozkazy ENDS

stosik SEGMENT stack
        db 256 dup (?)
stosik ENDS

END zacznij