.686
.model flat
public _przeciwna

.code
_przeciwna PROC
		push ebp		; zapisanie zawartoœci EBP na stosie
		mov ebp,esp		; kopiowanie zawartoœci ESP do EBP
		push ebx		; przechowanie zawartoœci rejestru EBX

; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej
; w kodzie w jêzyku C
		mov ebx, [ebp+8]

		mov eax, [ebx]	; odczytanie wartoœci zmiennej
		neg eax			; zamiana na przeciwna
		mov [ebx], eax	; odes³anie wyniku do zmiennej
; zamiast tego mozna neg dword PTR [ebx] chyba
		
		pop ebx
		pop ebp
		ret
_przeciwna ENDP
END