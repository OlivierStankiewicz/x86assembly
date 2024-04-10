.686
.model flat
extern _GetLocalTime@4 : PROC
public _daj_czas

.data
buffor db 64 dup (0)

.code
_daj_czas PROC
		push	ebp
		mov		ebp,esp
		push	ebx

		mov		ebx, [ebp+8]	; adres struktury

; wywolanie GetLocalTime
		push	OFFSET buffor
		call	_GetLocalTime@4
		
		mov		dl, buffor[8]	; lokalizacja godziny w zwracanej strukturze
		mov		[ebx], dl		; wpisanie godziny do wyjsciowej struktury
		mov		dl, buffor[10]	; lokalizacja minut w zwracanej strukturze
		mov		[ebx+1], dl		; wpisanie minut do zwracanej struktury
		
		pop		ebx
		pop		ebp
		ret
_daj_czas ENDP
END