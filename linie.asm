; Program linie.asm
; Wyświetlanie pionowych linii w różnych kolorach (w takt przerwań zegarowych)
.386
rozkazy SEGMENT use16
        ASSUME cs:rozkazy
linia PROC
        push ax
        push bx
        push es
        mov ax, 0A000H              ; adres pamięci ekranu dla trybu 13H
        mov es, ax
        mov bx, cs:adres_piksela    ; adres bieżący piksela
        mov al, cs:kolor
        mov es:[bx], al             ; wpisanie kodu koloru do pamięci ekranu

        add bx, 320                 ; przejście do następnego wiersza na ekranie

        cmp bx, 320*200             ; sprawdzenie czy cała linia wykreślona
        jb dalej                    ; skok, gdy linia jeszcze nie wykreślona

; koniec linii - następna będzie w innym kolorze o 10 pikseli dalej
        add word PTR cs:przyrost, 10
        mov bx, 10
        add bx, cs:przyrost
        inc cs:kolor                ; kolejny kod koloru

; zapisanie adresu bieżącego piksela
dalej:  mov cs:adres_piksela, bx
        pop es
        pop bx
        pop ax

        jmp dword PTR cs:wektor8

        kolor db 1                  ; bieżący numer koloru
        adres_piksela dw 10         ; bieżący adres piksela
        przyrost dw 0
        wektor8 dd ?
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