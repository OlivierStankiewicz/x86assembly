.686
.model flat
extern _GetSystemDirectoryA@8 : PROC
public _check_system_dir

.data
tekst db 32 dup (0)

.code
_check_system_dir PROC
		push	ebp
		mov		ebp,esp
		push	ebx
		push	esi

		mov		ebx, [ebp+8]	; adres dzielnej tablicy charow

; wywolanie GetSystemDirectory
		mov		ecx, 32 
		push	ecx
		push	OFFSET tekst
		call	_GetSystemDirectoryA@8

; petla porownania ciagow znakow
		mov		ecx, eax
		mov		esi, 0
ptl:	mov		dl, [ebx+esi]	; pobranie do edx kolejnego znaku
		cmp		dl, tekst[esi]
		jne		zle
		inc		esi
		loop	ptl
		
		
		mov		eax, 1
koniec:	pop		esi				; odtworzenie zawartoœci rejestrów
		pop		ebx
		pop		ebp
		ret						; powrót do programu g³ównego

zle:	mov		eax, 0
		jmp		koniec
_check_system_dir ENDP
END