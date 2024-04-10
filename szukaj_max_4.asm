.686
.model flat
public _szukaj_max

.code
_szukaj_max PROC
			push ebp			; zapisanie zawartoœci EBP na stosie
			mov ebp, esp		; kopiowanie zawartoœci ESP do EBP

; wpisanie do eax liczby a jako pocz¹tkowej najwiêkszej wartoœci
			mov eax, [ebp+8]	; liczba a

; porownanie z b			
			cmp eax, [ebp+12]	; porownanie liczb a i b
			jge spr_c			; skok gdy b jest mniejsze niz a
			mov eax, [ebp+12]

; porownanie z c
spr_c:		cmp eax, [ebp+16]	; porownanie aktualnego maxa z c
			jge	spr_d			; skok, gdy c jest mniejsze ni¿ aktualny max
			mov eax, [ebp+16]

; porownanie z d
spr_d:		cmp eax, [ebp+20]	; porownanie aktualnego maxa z d
			jge koniec			; skok, gdy d jest mniejsze ni¿ aktualny max
			mov	eax, [ebp+20]

koniec:		pop ebp
			ret

_szukaj_max ENDP
END