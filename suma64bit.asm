public sum

.code
sum PROC
			push	rbp
			mov		rbp, rsp

			mov		rax, 0			; w rax bedzie suma
			
			cmp		rcx, 0			; w rcx jest ilosc liczb do zsumowania
			je		koniec

			add		rax, rdx
			dec		rcx
			cmp		rcx, 0
			je		koniec

			add		rax, r8
			dec		rcx
			cmp		rcx, 0
			je		koniec
			
			add		rax, r9
			dec		rcx
			cmp		rcx, 0
			je		koniec

			mov		rbx, 2
ptl:		add		rax, [rbp + rbx*8 + 32]
			inc		rbx
			loop	ptl
			
koniec:		pop		rbp
			ret
sum ENDP
END