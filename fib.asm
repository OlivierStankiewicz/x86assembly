.686
.model flat
public _fibonacci

.code
_fibonacci PROC
		push	ebp
		mov		ebp,esp
		push	ebx
		push	esi

		mov		ebx, [ebp+8]	; adres zmiennej k

		cmp		ebx, 47
		ja		blad

		cmp		ebx, 0
		je		zero

		cmp		ebx, 2
		ja		ponad2
		mov		eax, 1
		jmp		koniec

ponad2:	sub		ebx, 1
		push	ebx
		call	_fibonacci		; wynikiem bedzie fibonacci od liczby 1 mniejszej
		add		esp, 4

		mov		esi, eax		; zapisanie wyniku fibonacciego dla liczby 1 mniejszej

		sub		ebx, 1
		push	ebx
		call	_fibonacci		; wynikiem bedzie fibonacci od liczby 2 mniejszej
		add		esp, 4

		add		eax, esi		; polaczenie tych 2 wynikow w koncowy

koniec:	pop		esi
		pop		ebx
		pop		ebp
		ret

blad:	mov		eax, -1
		jmp		koniec

zero:	mov		eax, 0
		jmp		koniec
_fibonacci ENDP
END