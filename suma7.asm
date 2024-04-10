public suma_siedmiu_liczb

.code
suma_siedmiu_liczb PROC
			push	rbp
			mov		rbp, rsp

			mov		rax, 0
			add		rax, rcx
			add		rax, rdx
			add		rax, r8
			add		rax, r9
			add		rax, [rbp+16+32]
			add		rax, [rbp+24+32]
			add		rax, [rbp+32+32]
			
			pop		rbp
			ret
suma_siedmiu_liczb ENDP
END