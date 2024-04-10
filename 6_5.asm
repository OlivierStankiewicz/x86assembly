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

        mov al, cs:kolor
        mov es:[bx], al             ; wpisanie kodu koloru do pamięci ekranu

; sprawdzenie czy to pierwsza czy druga przekatna
        mov al, cs:pierwsza
        cmp al, 1
        jne druga_przekatna

        add bx, 320                 ; przejście do następnego wiersza na ekranie
        inc bx                      ; przesuniecie o 1 piksel w prawo
        jmp sprawdzenie

druga_przekatna:
        add bx, 320                 ; przejście do następnego wiersza na ekranie
        dec bx                      ; przesuniecie o 1 piksel w lewo

sprawdzenie:
        cmp bx, 320*200             ; sprawdzenie czy cała linia wykreślona
        jb kontynuacja              ; skok, gdy linia jeszcze nie wykreślona

; koniec linii - następna będzie startowac od gory w przeciwnym rogu, defaultowo ustawiam lewy gorny rog
        mov ax, 0
        mov cs:aktualny_x, ax
        mov cs:aktualny_y, ax

        mov al, cs:pierwsza
        xor al, 1                   ; toggle boola
        mov cs:pierwsza, al
        cmp al, 1                   ; jesli teraz ma byc rysowana pierwsza to pomijam przestawienie pocz rysowania na prawo
        je pomin
        
        mov ax, 319
        mov cs:aktualny_x, ax
pomin:  
        inc cs:kolor                ; kolejny kod koloru
        mov al, 3
        mov cs:licznik_3, al
        jmp wyjscie

; rozpatrzenie kontynuacji rysowania
kontynuacja:  
        mov dx, 0
        mov ax, bx
        mov cx, 320
        div cx
        mov cs:aktualny_y, ax
        mov cs:aktualny_x, dx

; sprawdzam czy czas na 'powtorzenie' piksela
        mov al, cs:licznik_3
        dec al
        jnz licznik_nz
        mov al, 3
        mov cx, cs:aktualny_y
        dec cx
        mov cs:aktualny_y, cx
        
licznik_nz:
        mov cs:licznik_3, al

wyjscie:pop es
        pop dx
        pop cx
        pop bx
        pop ax

        jmp dword PTR cs:wektor8

        kolor db 1                  ; bieżący numer koloru
        pierwsza db 1               ; bool czy to przekatna lewo-gora -> prawo dol
        wektor8 dd ?
        aktualny_x dw 0
        aktualny_y dw 0
        licznik_3 db 3
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