.model small
.data
		StringToPrint db "Sean"
		MyString db "BEAMMEUP"
		Str_Length dw 4
		Color db 0eh
		Col db 0
		Row db 0
		Counter dw 0
		Count dw 0
		MyChar db ?
		direction db, 0
		
.stack 100h
.code

main:
		call InitSegs
		call Blank
		call PrintColorString
		call Wait4Key
		mov cx, 20
	do:
		call Blank
		inc row
		inc col
		call PrintColorString
		call Delay
		loop do
		
		call Exit
		
		;=========== InitSegs ==============
		Proc InitSegs
			push ax 
			
			mov ax, @data
			mov ds, ax
			mov es, ax
			
			pop ax
		RET
		EndP InitSegs
		
		;=========== Blank =============
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
	
		;======== PrintColorString ============
		Proc PrintColorString
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
		EndP PrintColorString
		
		;========== PrintColorString2 =========
		Proc PrintColorString2
			push ax bx cx dx bp
			
			mov ah, 13h
			mov al, 1
			mov bh, 0
			mov bl, color
			mov cx, Str_Length
			mov dh, row
			mov dl, col
			mov bp, OFFSET MyString
			int 10h
			
			pop bp dx cx bx ax
		RET
		EndP PrintColorString2
		
		;============= PrintColorString3 ============
		Proc PrintColorChar3
			push ax bx cx dx bp
			
			mov ah, 13h
			mov al, 1
			mov bh, 0
			mov bl, color
			mov cx, 1
			mov dh, row
			mov dl, col
			mov bp, OFFSET MyChar
			int 10h
			
			pop bp dx cx bx ax
		RET
		EndP PrintColorChar3
		
		;======= Wait4Key =============
		Proc Wait4Key
			push ax
			
			mov ah, 0h
			int 16h
			
			pop ax
		RET
		EndP Wait4Key
		
		;========== GetChar ==========
		Proc GetChar
			push ax bx
			
			mov bx, count 
			mov al, MyString[bx]
			mov MyChar, al
			inc count
			
			pop bx ax
		RET
		EndP GetChar
		
		;========== MoveUp ==============
		Proc MoveUp
		topmove:
			mov color, 0
			call PrintColorChar3
			dec row
			mov color, 0eh
			call PrintColorChar3
			call Delay
			cmp row, 0
			jnz topmove
			mov row, 24
		RET
		EndP MoveUp
		
		;============ Delay ==============
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
		;============== Exit ============
		Proc Exit
			push ax
			
			mov ah, 4ch
			int 21h
			
			pop ax
		RET
		EndP Exit
		
		;============ MovePosition ============
		Proc MovePosition
		again:
			inc col
			inc color
			call Blank
			call PrintColorString
			call Delay
			cmp row, 27
			jnz again
			mov row, 0
			call Delay
			call Blank
			call PrintColorString
		RET
		EndP MovePosition
		
		;============ MoveSide =================
		Proc MoveSide
			push ax bx
			
			cmp direction, 0
			jnz go_left
			call blank
			xor ax, ax
			mov al, col
			mov bx, counter
			add bx, ax
			cmp bx, 79
			jnz not_end
			mov direction, 1
			jmp not_end
		go_left:
			dec col
			inc color
			call blank
			cmp col, 0h
			jnz not_end
			mov direction, 0
		not_end:
			pop bx ax
		
			pop bx ax
		RET
		EndP MoveSide

end main