.model small
.data
		StringToPrint db "£"
		Str_Length dw 1
		Color db 1
		Row db 0
		Col db 15
		
.stack 100h
.code

main:
		call InitSegs
		mov cx, 2
	done:
		call Blank
		call PrintColorChar
		call Delay
		call MoveDown
		loop done
		
		call Exit

		;============ InitSegs ==============
		Proc InitSegs
			push ax
			
			mov ax, @data
			mov ds, ax
			mov es, ax
			
			pop ax
		RET
		EndP InitSegs
		
		;=========== Delay ===============
		Proc Delay
			push cx dx
			
			mov dx, 0FFFFh 
		dec_again:
			mov cx, 300h
		dec_2:
			loop dec_2
			dec dx
			jnz dec_again
			
			pop dx cx
		RET
		EndP Delay
		;=========== Blank ===============
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
		
		;========== PrintColorChar =========
		Proc PrintColorChar
			push ax bx cx dx bp
			
			mov ah, 13h
			mov al, 1
			mov bh, 0
			mov bl, Color
			mov cx, Str_Length
			mov dh, Row
			mov dl, Col
			mov bp, OFFSET StringToPrint
			int 10h
			
			pop bp dx cx bx ax
		RET
		EndP PrintColorChar
		
		;========= Exit ===========
		Proc Exit
			push ax
			
			mov ah, 4ch
			int 21h
		RET
		EndP Exit
		
		;======== MoveDown ===========
		Proc MoveDown
		top_move:
			inc Row
			inc Color
			call Blank
			call PrintColorChar
			call Delay
			cmp Row, 23
			jnz top_move
			mov Row, 0
			call Delay
			call Blank
			call PrintColorChar
		RET
		EndP MoveDown
end main