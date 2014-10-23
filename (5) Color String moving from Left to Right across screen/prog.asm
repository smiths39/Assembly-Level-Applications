.model small
.data
		StringToPrint db "Enter a String: $"
		MyString db 28h dup(0)
		MyChar db ?
		Str_Length dw 4
		Color db 5
		Row db 12
		Col db 3
		Counter dw 0
		Direction db 0
		Num_Loop dw 0FFFFh
		
.stack 100h
.code

main:
		call InitSegs
		call PrintString
		call ReadString
	done:
		call Blank
		call PrintColorString
		call Delay
		call MovePosition
		dec Num_Loop
		loop done
		
		call Exit
		
		;================ InitSegs ================
		Proc InitSegs
			push ax
			
			mov ax, @data
			mov ds, ax
			mov es, ax
			
			pop ax
		RET
		EndP InitSegs
		
		;================ PrintString ============
		Proc PrintString
			push ax dx
			
			mov ah, 09h
			mov dx, OFFSET StringToPrint
			int 21h
			
			pop dx ax
		RET
		EndP PrintString
		
		;================ ReadString ==============
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
		
		;----------------- ReadChar -----------------
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
		;================= Delay ===================
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
		
		;================ PrintColorString ===============
		Proc PrintColorString
			push ax bx cx dx bp
			
			mov ah, 13h
			mov al, 1
			mov bh, 0
			mov bl, Color
			mov cx, Str_length
			mov dh, Row
			mov dl, Col
			mov bp, OFFSET MyString
			int 10h
		
			pop bp dx cx bx ax 
		RET
		EndP PrintColorString
		
		;============== MovePosition =================
		Proc MovePosition
			push ax bx
			
			cmp direction, 0
			jnz go_left
			inc col
			inc color
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
			cmp col, 0
			jnz not_end
			mov direction, 0
		not_end:
			pop bx ax
		RET
		EndP MovePosition
		;================= Exit =======================
		Proc Exit
			push ax
			
			mov ah, 4ch
			int 21h
			
			pop ax
		RET
		EndP Exit
end main