.model small
.data
		StringToPrint db "Please Enter Word: $"
		MyString db 28h dup(0)
		MyChar db ?
		Row db 1
		Col db 10
		Color db 1
		Str_Length dw 4
		
.stack 100h
.code 

main:
		call InitSegs
		call Print_Prompt
		call ReadString
		mov cx, 2
	done:
		call Blank
		call PrintColorString
		call Delay
		call MoveDown
		loop done
		
		call Exit
		
		;============ InitSegs ================
		Proc InitSegs
			push ax
			
			mov ax, @data
			mov ds, ax
			mov es, ax
			
			pop ax
		RET
		EndP InitSegs
		
		;============ Print_Prompt =============
		Proc Print_Prompt
			push ax dx
			
			mov ah, 09h
			mov dx, OFFSET StringToPrint
			int 21h
			
			pop dx ax
		RET
		EndP Print_Prompt
		
		;============ ReadString ==============
		Proc ReadString
			push ax bx
			
			clc
			mov bx, OFFSET MyString
		next_char:
			call ReadChar
			jc done2
			mov al, MyChar
			mov [bx], al
			inc bx
			jmp next_char
		done2:
			mov [bx], BYTE PTR '$'
			
			pop bx ax
		RET
		EndP ReadString
		
		;-------------- ReadChar ----------------
		Proc ReadChar
			push ax
			
			mov ah, 1
			int 21h
			
			mov MyChar, al
			cmp MyChar, 13
			jnz done3
			stc
		done3:
			pop ax
		RET
		EndP ReadChar

		;============== Blank ================
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
		
		;=============== Delay ================
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
		
		;============== MoveDown ================
		Proc MoveDown
		top_move:
			inc row
			inc Color
			call Blank
			call PrintColorString
			call Delay
			cmp Row, 23
			jnz top_move
			mov row, 0
			call Delay
			call Blank
			call PrintColorString
		RET
		EndP MoveDown
		
		;============= PrintString ===============
		Proc PrintColorString
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
			
			pop bx dx cx bx ax
		RET
		EndP PrintColorString
		
		;============= Exit ================
		Proc Exit
			push ax
			
			mov ah, 4ch
			int 21h
			
			pop ax
		RET
		EndP Exit
end main