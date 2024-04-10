.686
.XMM ; zezwolenie na asemblacjê rozkazów grupy SSE
.model flat
public _dodaj_SSE, _pierwiastek_SSE, _odwrotnosc_SSE

.code

_dodaj_SSE PROC
		push ebp
		mov ebp, esp
		push ebx
		push esi
		push edi

		mov esi, [ebp+8]	; adres pierwszej tablicy
		mov edi, [ebp+12]	; adres drugiej tablicy
		mov ebx, [ebp+16]	; adres tablicy wynikowej

; ³adowanie do rejestru xmm5 czterech liczb zmiennoprzecinkowych 32-bitowych - liczby zostaj¹ pobrane z tablicy, której adres poczatkowy podany jest w rejestrze ESI
; mov - operacja przes³ania,
; u - unaligned (adres obszaru nie jest podzielny przez 16),
; p - packed (do rejestru ³adowane s¹ od razu cztery liczby),
; s - short (inaczej float, liczby zmiennoprzecinkowe 32-bitowe)

		movups xmm5, [esi]
		movups xmm6, [edi]

		addps xmm5, xmm6	; zsumowanie 4 liczb zmiennoprzecinkowych zawartych w xmm5 i xmm6, wynik zapisuje siê w xmm5
		movups [ebx], xmm5

		pop edi
		pop esi
		pop ebx
		pop ebp
		ret
_dodaj_SSE ENDP

_pierwiastek_SSE PROC
		push ebp
		mov ebp, esp
		push ebx
		push esi

		mov esi, [ebp+8] ; adres pierwszej tablicy
		mov ebx, [ebp+12] ; adres tablicy wynikowej

		movups xmm6, [esi]

		sqrtps xmm5, xmm6
		movups [ebx], xmm5

		pop esi
		pop ebx
		pop ebp
		ret

_pierwiastek_SSE ENDP


_odwrotnosc_SSE PROC
		push ebp
		mov ebp, esp
		push ebx
		push esi

		mov esi, [ebp+8]	; adres pierwszej tablicy
		mov ebx, [ebp+12]	; adres tablicy wynikowej

		movups xmm5, [esi]

; obliczanie odwrotnoœci czterech liczb zmiennoprzecinkowych z xmm6, zapisanie do xmm5
		rcpps xmm5, xmm6	; u¿ywa 12 zamiast 24 bitowej mantysy - obliczenia szybsze, ale mniej dok³adne
		movups [ebx], xmm5

		pop esi
		pop ebx
		pop ebp
		ret
_odwrotnosc_SSE ENDP

_dodaj_8bit_SSE PROC
		push ebp
		mov ebp, esp
		push ebx
		push esi
		push edi

		mov esi, [ebp+8]	; adres pierwszej tablicy
		mov edi, [ebp+12]	; adres drugiej tablicy
		mov ebx, [ebp+16]	; adres tablicy wynikowej

		movups xmm5, [esi]
		movups xmm6, [edi]

		paddsb xmm5, xmm6	; zsumowanie 2x16 liczb 8 bitowych
		movups [ebx], xmm5

		pop edi
		pop esi
		pop ebx
		pop ebp
		ret
_dodaj_8bit_SSE ENDP
END