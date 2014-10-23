.model small
.data
		MyString db "Shrinking box"
		StringToPrint db "##########"
		Str_Length dw 10
		Color db 0ch
		Col db 5
		Row db 3
		Count dw 10
.stack 100h
.code

main:
		call InitSegs
		call Blank
		call PrintString
		call Wait4Key
		mov cx, 10
	move:
		call Blank
		call PrintBox
		call Delay
		call MoveBox
		loop move
		
		call Wait4Key
		call Exit
	
		;============= InitSegs ==============
		Proc InitSegs
			push ax
			
			mov ax, @data
			mov ds, ax
			mov es, ax
			
			pop ax
		RET
		EndP InitSegs
		
		;=========== Blank ================
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
	
		;============ PrintString ==============
		Proc PrintString
			push ax bx cx dx bp
			
			mov ah, 13h
			mov al, 1
			mov bh, 0
			mov bl, color
			mov cx, 13
			mov dh, row
			mov dl, col
			mov bp, OFFSET MyString
			int 10h
			
			pop bp dx cx bx ax
		RET
		EndP PrintString
		
		;=========== Wait4Key ============
		Proc Wait4Key
			push ax
			
			mov ah, 0h
			int 16h
			
			pop ax
		RET
		EndP Wait4Key
		
		;=========== Delay =============
		Proc Delay
			push cx dx
			
			mov dx, 0FFFFH
		dec_again:
			mov cx, 300h
		dec2:
			loop dec2
			dec dx
			jnz dec_again
		
			pop dx cx 
		RET
		EndP Delay
		
		;========== PrintBox =========
		Proc PrintBox
			push bx cx
			
			mov cx, count
			mov bl, row
		down:
			call PrintLine
			dec row
			loop down
			add bl, 1
			mov row, bl
			
			pop cx bx
		RET
		EndP PrintBox
			
		;=========== PrintLine ==============
		Proc PrintLine
			push ax bx cx dx bp
			
			mov ah, 13h
			mov al, 1
			mov bh, 0
			mov bl, color
			mov cx, Str_Length
			mov dh, row
			mov dl, col
			mov bp, OFFSET StringToPrint
			int 10h
			
			pop bp dx cx bx ax
		RET
		EndP PrintLine
		
		;============ MoveBox ==============
		Proc MoveBox
			push ax
			
			mov ah, col
			add ah, 2
			mov col, ah
			
			dec str_length
			dec count
		
			pop ax
		RET
		EndP MoveBox
		;=========== Exit ===============
		Proc Exit
			push ax
			
			mov ah, 4ch
			int 21h
			
			pop ax
		RET
		EndP Exit
end main