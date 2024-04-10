; Program linie.asm
; Wyświetlanie pionowych linii w różnych kolorach (w takt przerwań zegarowych)
.386
rozkazy SEGMENT use16
        ASSUME cs:rozkazy
linia PROC
        push ax
        push bx
        push cx
        push dx
        push es
        mov ax, 0A000H              ; adres pamięci ekranu dla trybu 13H
        mov es, ax

        ; obliczenie numeru aktualnego piksela
        mov ax, cs:aktualny_y
        mov dx, 0
        mov cx, 320
        mul cx
        mov bx, ax
        add bx, cs:aktualny_x

        mov al, 1                   ;cs:kolor
        mov es:[bx], al             ; wpisanie kodu koloru do pamięci ekranu

        mov al, cs:pierwsza
        cmp al, 1
        jne druga_przekatna

        add bx, 320                 ; przejście do następnego wiersza na ekranie
        inc bx
        jmp sprawdzenie

druga_przekatna:
        add bx, 320
        dec bx

sprawdzenie:
        cmp bx, 320*200             ; sprawdzenie czy cała linia wykreślona
        jb dalej                    ; skok, gdy linia jeszcze nie wykreślona

; koniec linii - następna będzie startowac od gory w przeciwnym rogu
        mov ax, 0
        mov aktualny_x, ax
        mov aktualny_y, ax
dalej:  mov dx, 0
        mov ax, bx
        mov cx, 320
        div cx
        mov cs:aktualny_y, ax
        mov cs:aktualny_x, dx
        pop es
        pop dx
        pop cx
        pop bx
        pop ax

        jmp dword PTR cs:wektor8

        kolor db 1                  ; bieżący numer koloru
        adres_piksela dw 10         ; bieżący adres piksela
        przyrost dw 0
        pierwsza db 1               ; bool czy to przekatna lewo-gora -> prawo dol
        wektor8 dd ?
        aktualny_x dw 0
        aktualny_y dw 0
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

; zapisanie adresu procedury 'linia' do wektora nr 8
        mov es:[32], bx
        mov es:[32+2], ax
        sti
czekaj:
        mov ah, 1                   ; sprawdzenie czy jest jakiś znak w buforze klawiatury
        int 16h
        jz czekaj
        mov ah, 0                   ; funkcja nr 0 ustawia tryb sterownika
        mov al, 3H                  ; nr trybu
        int 10H

        mov eax, cs:wektor8
        mov es:[32], eax
        
; zakończenie wykonywania programu
        mov ax, 4C00H
        int 21H
rozkazy ENDS

stosik SEGMENT stack
        db 256 dup (?)
stosik ENDS

END zacznij