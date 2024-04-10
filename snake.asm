.386
rozkazy SEGMENT use16
        ASSUME cs:rozkazy

obsluga_klawiatury PROC
        push cx

        in al, 60H  ; wczytanie do al kodu wcisnietego klawisza

        cmp al, 72  ; kod strzalki w gore
        jne prawo
        mov cl, 0
        mov cs:kierunek, cl

prawo:  cmp al, 77  ; kod strzalki w prawo
        jne dol
        mov cl, 1
        mov cs:kierunek, cl

dol:    cmp al, 80  ; kod strzalki w dol
        jne lewo
        mov cl, 2
        mov cs:kierunek, cl

lewo:   cmp al, 75  ; kod strzalki w lewo
        jne bledne
        mov cl, 3
        mov cs:kierunek, cl

bledne: pop cx

        jmp dword PTR cs:wektor9	; skok do oryginalnej procedury obsługi przerwania zegarowego

	
	    wektor9 dd ?

obsluga_klawiatury ENDP

linia PROC
        push ax
        push bx
        push cx
        push dx
        push es
        mov ax, 0A000H              ; adres pamięci ekranu dla trybu 13H
        mov es, ax

; wstepne wykonanie ruchu
        mov al, cs:kierunek
        cmp al, 0
        jne dalej1
; obsluga jesli ma byc ruch w gore (+ sprawdzenie czy nie wyjechal)
        cmp cs:aktualny_y, 0
        je  oblicz
        dec cs:aktualny_y
        jmp oblicz

dalej1: cmp al, 1
        jne dalej2
; obsluga jesli ma byc ruch w prawo (+ sprawdzenie czy nie wyjechal)
        cmp cs:aktualny_x, 319
        je  oblicz
        add cs:aktualny_x, 1
        jmp oblicz

dalej2: cmp al, 2
        jne dalej3
; obsluga jesli ma byc ruch w dol (+ sprawdzenie czy nie wyjechal)
        cmp cs:aktualny_y, 200
        je  oblicz
        inc cs:aktualny_y
        jmp oblicz

; obsluga ruchu w lewo (+ sprawdzenie czy nie wyjechal)
dalej3: cmp cs:aktualny_x, 0
        je  oblicz
        dec cs:aktualny_x     


; obliczenie numeru aktualnego piksela
oblicz: mov ax, cs:aktualny_y
        mov dx, 0
        mov cx, 320
        mul cx
        mov bx, ax
        add bx, cs:aktualny_x

; zapisanie nowego piksela w pamieci
        mov al, cs:kolor
        mov es:[bx], al

        pop es
        pop dx
        pop cx
        pop bx
        pop ax

        jmp dword PTR cs:wektor8

        kolor db 2                  ; bieżący numer koloru
        wektor8 dd ?
        aktualny_x dw 160
        aktualny_y dw 100
        kierunek db 1               ; 0-gora, 1-prawo, 2-dol, 3-lewo
linia ENDP

; INT 10H, funkcja nr 0 ustawia tryb sterownika graficznego
zacznij:
        mov ah, 0
        mov al, 13H                 ; nr trybu
        int 10H
        mov bx, 0
        mov es, bx
        mov eax, es:[32]
        mov cs:wektor8, eax
        mov ax, SEG linia
        mov bx, OFFSET linia
        cli

        mov es:[32], bx
        mov es:[32+2], ax
        sti


        mov ax, 0
	    mov ds,ax ; zerowanie rejestru DS

	    mov eax,ds:[36]
	    mov cs:wektor9, eax

	    mov ax, SEG obsluga_klawiatury
	    mov bx, OFFSET obsluga_klawiatury

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

        mov eax, cs:wektor8
        mov es:[32], eax

; odtworzenie oryginalnej zawartości wektora nr 9
	    mov eax, cs:wektor9
	    mov ds:[36], eax ; przesłanie wartości oryginalnej do wektora 9 w tablicy wektorów przerwań
        
; zakończenie wykonywania programu
        mov ax, 4C00H
        int 21H
rozkazy ENDS

stosik SEGMENT stack
        db 256 dup (?)
stosik ENDS

END zacznij