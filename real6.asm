.386
rozkazy SEGMENT use16
        ASSUME cs:rozkazy

obsluga_klawiatury PROC
        push cx

        in al, 60H          ; wczytanie do al kodu wcisnietego klawisza

        cmp al, 72          ; kod strzalki w gore
        jne prawo
        cmp cs:start_y, 0
        je  bledne
        sub cs:start_y, 100

prawo:  cmp al, 77          ; kod strzalki w prawo
        jne dol
        cmp cs:start_x, 159
        je  bledne
        add cs:start_x, 159

dol:    cmp al, 80          ; kod strzalki w dol
        jne lewo
        cmp cs:start_y, 100
        je  bledne
        add cs:start_y, 100

lewo:   cmp al, 75          ; kod strzalki w lewo
        jne bledne
        cmp cs:start_x, 0
        je  bledne
        sub cs:start_x, 159

bledne: pop cx

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

; sprawdzenie czy jest to co 18 obieg, czyli co sekunda
        sub cs:rysowac, 1
        jnz wyjscie

        mov cs:rysowac, 18


; czyszczenie ekranu
        mov bx, 0                   ; adres pierwszego piksela
        mov cl, 0                   ; cl zawiera kod koloru czarnego
clear:  mov es:[bx], cl
        inc bx
        cmp bx, 320*200
        jbe clear


; ustawienie odpowiedniego koloru kwadratu
        cmp cs:licznik, 0
        jne dalej1
        mov cs:kolor, 4
        add cs:licznik,1
        jmp ustawianie

dalej1: cmp cs:licznik, 1
        jne dalej2
        mov cs:kolor, 2
        add cs:licznik, 1
        jmp ustawianie

dalej2: mov cs:kolor, 1
        mov cs:licznik, 0

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

; sprawdzenie czy trzeba przejsc do nastepnej linii
        mov ax, bx
        mov dx, 0
        mov bx, 320
        div bx

        mov bx, cs:start_x
        add bx, cs:szerokosc
        cmp bx, dx
        jne skip       ; znaczy ze nie trzeba przechodzic do kolejnej linijki

; sprawdzenie czy to koniec kwadratu
        mov bx, cs:start_y
        add bx, cs:wysokosc
        cmp bx, ax
        je  wyjscie     ; znaczy ze caly kwadrat narysowany

; przestawienie adresu na poczatek kolejnej linijki
        mov ax, cs:adres_piksela
        sub ax, cs:szerokosc
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

        kolor db 4                  ; bieżący numer koloru
        wektor8 dd ?
        start_x dw 0
        start_y dw 0
        szerokosc dw 160
        wysokosc dw 100
        adres_piksela dw ?
        licznik db 0
        rysowac db 1
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

; zapisanie adresu procedury 'kwadrat' do wektora nr 8
        cli
        mov es:[32], bx
        mov es:[32+2], ax
        sti

        mov ax, 0
	    mov ds,ax

; zapisanie zawartosci wektora9 do zmiennej, wektor9 zajmuje 4 bajty zaczynajac od adresu fizycznego 9*4=36
	    mov eax,ds:[36]
	    mov cs:wektor9, eax

; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
	    mov ax, SEG obsluga_klawiatury
	    mov bx, OFFSET obsluga_klawiatury

	    
; zapisanie adresu procedury do wektora nr 9
        cli
	    mov ds:[36], bx
	    mov ds:[38], ax
	    sti


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

; odtworzenie oryginalnej zawartosci wektora nr 8
        mov eax, cs:wektor8
        mov es:[32], eax

; odtworzenie oryginalnej zawartości wektora nr 9
	    mov eax, cs:wektor9
	    mov ds:[36], eax

; zakończenie wykonywania programu
        mov ax, 4C00H
        int 21H
rozkazy ENDS

nasz_stos SEGMENT stack
        db 256 dup (?)
nasz_stos ENDS

END zacznij