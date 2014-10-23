.model small
.data
		StringToPrint db "Sean"
		Key db ?
		Str_length dw 4
		Color db 64
		Row db 10
		Col db 15
		
.stack 100h
.code

main:
		call InitSegs
	around:
		call Blank
		call PrintColorString
		call Delay
		call GetChar
		call DecodeKey
		jmp around
		
		;================= InitSegs ==================
		Proc InitSegs
			push ax
			
			mov ax, @data
			mov ds, ax
			mov es, ax
			
			pop ax
		RET
		EndP InitSegs
		
		;================ Blank ==================
		Proc Blank
			push ax bx cx dx
			
			mov bh, 0
			mov bl, 0
			sub cx, cx
			mov dx, 184fh
			mov ax, 0600h
			int 10h
			
			pop dx cx bx ax
		RET
		EndP Blank
		
		;================ Delay =====================
		Proc Delay
			push cx dx
			
			mov dx, 0FFFFh
		dec_again:
			mov cx, 300h
		dec2:
			loop dec2
			dec dx
			jnz dec_again
			
			pop dx cx
		RET
		EndP Delay
		
		;================ PrintColorString =================
		Proc PrintColorString
			push ax bx cx dx bp
			
			mov ah, 13h
			mov al, 1
			mov bh, 0
			mov bl, color
			mov cx, Str_length
			mov dh, row
			mov dl, col
			mov bp, OFFSET StringToPrint
			int 10h
			
			pop bp dx cx bx ax
		RET
		EndP PrintColorString
		
		;================= GetChar =================
		Proc GetChar
			push ax
			
			mov ah, 1
			int 21h
			mov key, al
			
			pop ax
		RET
		EndP GetChar
		
		;================= DecodeKey =================
		Proc DecodeKey
			cmp key, 'u'
			jnz try_d
		end_u:
			cmp row, 0
			jz not_any
			dec row
			call Blank
			call PrintColorString
			call Delay
			jmp end_u
		
		try_d:
			cmp key, 'd'
			jnz try_l
		end_d:
			cmp row, 23
			jz not_any
			inc row
			call Blank
			call PrintColorString
			call Delay
			jmp end_d
		
		try_l:
			cmp key, 'l'
			jnz try_r
			
		end_l:
			cmp col, 1
			jz not_any
			dec col
			call Blank
			call PrintColorString
			call Delay
			jmp end_l
		
		try_r:
			cmp key, 'r'
			jnz try_x
		
		end_r:
			cmp col, 75
			jz not_any
			inc col
			call Blank
			call PrintColorString
			call Delay
			jmp end_r
		
		try_x:
			cmp key, 'x'
			jnz not_any
			call blank
			call exit
		
		not_any:
		RET
		EndP DecodeKey
		
		;=============== Exit ===================
		Proc Exit
			push ax
			
			mov ah, 4ch
			int 21h
			
			pop ax
		RET
		EndP Exit
end main	