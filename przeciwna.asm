.686
.model flat
public _przeciwna

.code
_przeciwna PROC
		push ebp		; zapisanie zawarto�ci EBP na stosie
		mov ebp,esp		; kopiowanie zawarto�ci ESP do EBP
		push ebx		; przechowanie zawarto�ci rejestru EBX

; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej
; w kodzie w j�zyku C
		mov ebx, [ebp+8]

		mov eax, [ebx]	; odczytanie warto�ci zmiennej
		neg eax			; zamiana na przeciwna
		mov [ebx], eax	; odes�anie wyniku do zmiennej
; zamiast tego mozna neg dword PTR [ebx] chyba
		
		pop ebx
		pop ebp
		ret
_przeciwna ENDP
END